From: akpm@linux-foundation.org
Subject: [merged] x86-bitops-fix-build-regression.patch removed
 from -mm tree
Date: Sun, 24 May 2020 16:18:20 -0700
Message-ID: <20200524231820.IAuFIbHey%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388468AbgEXXSV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 24 May 2020 19:18:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@intel.com, aryabinin@virtuozzo.com, bot@kernelci.org, bp@alien8.de, brgerst@gmail.com, dja@axtens.net, elver@google.com, hpa@zytor.com, ilie.halip@gmail.com, jesse.brandeburg@intel.com, luc.vanoostenryck@gmail.com, mingo@redhat.com, mm-commits@vger.kernel.org, natechancellor@gmail.com, ndesaulniers@google.com, paulmck@kernel.org, peterz@infradead.org, sedat.dilek@gmail.com, tglx@linutronix.de, yamada.masahiro@socionext.com


The patch titled
     Subject: x86: bitops: fix build regression
has been removed from the -mm tree.  Its filename was
     x86-bitops-fix-build-regression.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nick Desaulniers <ndesaulniers@google.com>
Subject: x86: bitops: fix build regression

This is easily reproducible via CC=clang+CONFIG_STAGING=y+CONFIG_VT6656=m.

It turns out that if your config tickles __builtin_constant_p via
differences in choices to inline or not, these statements produce invalid
assembly:

$ cat foo.c
long a(long b, long c) {
  asm("orb	%1, %0" : "+q"(c): "r"(b));
  return c;
}
$ gcc foo.c
foo.c: Assembler messages:
foo.c:2: Error: `%rax' not allowed with `orb'

Use the `%b` "x86 Operand Modifier" to instead force register allocation
to select a lower-8-bit GPR operand.

The "q" constraint only has meaning on -m32 otherwise is treated as
"r". Not all GPRs have low-8-bit aliases for -m32.

Link: http://lkml.kernel.org/r/20200508183230.229464-1-ndesaulniers@google.com
Link: https://github.com/ClangBuiltLinux/linux/issues/961
Link: https://lore.kernel.org/lkml/20200504193524.GA221287@google.com/
Link: https://gcc.gnu.org/onlinedocs/gcc/Extended-Asm.html#x86Operandmodifiers
Fixes: 1651e700664b4 ("x86: Fix bitops.h warning with a moved cast")
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Reported-by: kernelci.org bot <bot@kernelci.org>
Suggested-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Suggested-by: Brian Gerst <brgerst@gmail.com>
Suggested-by: H. Peter Anvin <hpa@zytor.com>
Suggested-by: Ilie Halip <ilie.halip@gmail.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-By: Brian Gerst <brgerst@gmail.com>
Tested-by: Nathan Chancellor <natechancellor@gmail.com>	[build, clang-11]
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Marco Elver <elver@google.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Daniel Axtens <dja@axtens.net>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/bitops.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/arch/x86/include/asm/bitops.h~x86-bitops-fix-build-regression
+++ a/arch/x86/include/asm/bitops.h
@@ -52,9 +52,9 @@ static __always_inline void
 arch_set_bit(long nr, volatile unsigned long *addr)
 {
 	if (__builtin_constant_p(nr)) {
-		asm volatile(LOCK_PREFIX "orb %1,%0"
+		asm volatile(LOCK_PREFIX "orb %b1,%0"
 			: CONST_MASK_ADDR(nr, addr)
-			: "iq" (CONST_MASK(nr) & 0xff)
+			: "iq" (CONST_MASK(nr))
 			: "memory");
 	} else {
 		asm volatile(LOCK_PREFIX __ASM_SIZE(bts) " %1,%0"
@@ -72,9 +72,9 @@ static __always_inline void
 arch_clear_bit(long nr, volatile unsigned long *addr)
 {
 	if (__builtin_constant_p(nr)) {
-		asm volatile(LOCK_PREFIX "andb %1,%0"
+		asm volatile(LOCK_PREFIX "andb %b1,%0"
 			: CONST_MASK_ADDR(nr, addr)
-			: "iq" (CONST_MASK(nr) ^ 0xff));
+			: "iq" (~CONST_MASK(nr)));
 	} else {
 		asm volatile(LOCK_PREFIX __ASM_SIZE(btr) " %1,%0"
 			: : RLONG_ADDR(addr), "Ir" (nr) : "memory");
@@ -123,9 +123,9 @@ static __always_inline void
 arch_change_bit(long nr, volatile unsigned long *addr)
 {
 	if (__builtin_constant_p(nr)) {
-		asm volatile(LOCK_PREFIX "xorb %1,%0"
+		asm volatile(LOCK_PREFIX "xorb %b1,%0"
 			: CONST_MASK_ADDR(nr, addr)
-			: "iq" ((u8)CONST_MASK(nr)));
+			: "iq" (CONST_MASK(nr)));
 	} else {
 		asm volatile(LOCK_PREFIX __ASM_SIZE(btc) " %1,%0"
 			: : RLONG_ADDR(addr), "Ir" (nr) : "memory");
_

Patches currently in -mm which might be from ndesaulniers@google.com are

elfnote-mark-all-note-sections-shf_alloc.patch
