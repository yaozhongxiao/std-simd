execute_process(
   COMMAND ${OBJDUMP} --no-show-raw-insn -dC -j .text ${BINARY}
   COMMAND grep -A2 " <test"
   COMMAND sed 1d
   COMMAND cut -d: -f2
   COMMAND xargs echo
   OUTPUT_VARIABLE asm)
string(STRIP "${asm}" asm)
if("${IMPL}" STREQUAL SSE)
   set(reference "^(addps %xmm(0,%xmm1 movaps %xmm1,%xmm0|1,%xmm0 retq)|vaddps %xmm(0,%xmm1|1,%xmm0),%xmm0 retq)$")
elseif("${IMPL}" STREQUAL SSE2)
   set(reference "^vaddps %xmm(0,%xmm1|1,%xmm0),%xmm0 retq$")
elseif("${IMPL}" STREQUAL AVX)
   set(reference "^vaddps %ymm(0,%ymm1|1,%ymm0),%ymm0 retq$")
elseif("${IMPL}" STREQUAL AVX2)
   set(reference "^vaddps %ymm(0,%ymm1|1,%ymm0),%ymm0 retq$")
elseif("${IMPL}" STREQUAL MIC)
   set(reference "^vaddps %zmm(0,%zmm1|1,%zmm0),%zmm0 retq$")
else()
   message(FATAL_ERROR "Unknown IMPL '${IMPL}'")
endif()

if("${asm}" MATCHES "${reference}")
   message(STATUS "Passed.")
else()
   message(FATAL_ERROR "Failed. ('${asm}' does not match '${reference}')")
endif()