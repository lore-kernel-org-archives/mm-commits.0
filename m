From: akpm@linux-foundation.org
Subject: + x86-add-optimized-popcnt-variants.patch added to -mm tree
Date: Mon, 22 Mar 2010 15:04:40 -0700
Message-ID: <201003222204.o2MM4fmJ030162@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36386 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750918Ab0CVWFD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 18:05:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: borislav.petkov@amd.com, a.p.zijlstra@chello.nl, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: add optimized popcnt variants
has been added to the -mm tree.  Its filename is
     x86-add-optimized-popcnt-variants.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: add optimized popcnt variants
From: Borislav Petkov <borislav.petkov@amd.com>

Add support for the hardware version of the Hamming weight function,
popcnt, present in CPUs which advertize it under CPUID, Function
0x0000_0001_ECX[23].  On CPUs which don't support it, we fallback to the
default lib/hweight.c sw versions.

A synthetic benchmark comparing popcnt with __sw_hweight64 showed almost a
3x speedup on a F10h machine.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig                          |    5 +
 arch/x86/include/asm/alternative.h        |    9 ++-
 arch/x86/include/asm/arch_hweight.h       |   59 ++++++++++++++++++++
 arch/x86/include/asm/bitops.h             |    4 +
 include/asm-generic/bitops/arch_hweight.h |   22 ++++++-
 lib/Makefile                              |    3 +
 lib/hweight.c                             |   20 +++---
 scripts/Makefile.lib                      |    4 +
 8 files changed, 108 insertions(+), 18 deletions(-)

diff -puN arch/x86/Kconfig~x86-add-optimized-popcnt-variants arch/x86/Kconfig
--- a/arch/x86/Kconfig~x86-add-optimized-popcnt-variants
+++ a/arch/x86/Kconfig
@@ -238,6 +238,11 @@ config X86_32_LAZY_GS
 	def_bool y
 	depends on X86_32 && !CC_STACKPROTECTOR
 
+config ARCH_HWEIGHT_CFLAGS
+	string
+	default "-fcall-saved-ecx -fcall-saved-edx" if X86_32
+	default "-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11" if X86_64
+
 config KTIME_SCALAR
 	def_bool X86_32
 source "init/Kconfig"
diff -puN arch/x86/include/asm/alternative.h~x86-add-optimized-popcnt-variants arch/x86/include/asm/alternative.h
--- a/arch/x86/include/asm/alternative.h~x86-add-optimized-popcnt-variants
+++ a/arch/x86/include/asm/alternative.h
@@ -39,9 +39,6 @@
 #define LOCK_PREFIX ""
 #endif
 
-/* This must be included *after* the definition of LOCK_PREFIX */
-#include <asm/cpufeature.h>
-
 struct alt_instr {
 	u8 *instr;		/* original instruction */
 	u8 *replacement;
@@ -96,6 +93,12 @@ static inline int alternatives_text_rese
       ".previous"
 
 /*
+ * This must be included *after* the definition of ALTERNATIVE due to
+ * <asm/arch_hweight.h>
+ */
+#include <asm/cpufeature.h>
+
+/*
  * Alternative instructions for different CPU types or capabilities.
  *
  * This allows to use optimized instructions even on generic binary
diff -puN /dev/null arch/x86/include/asm/arch_hweight.h
--- /dev/null
+++ a/arch/x86/include/asm/arch_hweight.h
@@ -0,0 +1,59 @@
+#ifndef _ASM_X86_HWEIGHT_H
+#define _ASM_X86_HWEIGHT_H
+
+#ifdef CONFIG_64BIT
+/* popcnt %rdi, %rax */
+#define POPCNT ".byte 0xf3,0x48,0x0f,0xb8,0xc7"
+#define REG_IN "D"
+#define REG_OUT "a"
+#else
+/* popcnt %eax, %eax */
+#define POPCNT ".byte 0xf3,0x0f,0xb8,0xc0"
+#define REG_IN "a"
+#define REG_OUT "a"
+#endif
+
+/*
+ * __sw_hweightXX are called from within the alternatives below
+ * and callee-clobbered registers need to be taken care of. See
+ * ARCH_HWEIGHT_CFLAGS in <arch/x86/Kconfig> for the respective
+ * compiler switches.
+ */
+static inline unsigned int __arch_hweight32(unsigned int w)
+{
+	unsigned int res = 0;
+
+	asm (ALTERNATIVE("call __sw_hweight32", POPCNT, X86_FEATURE_POPCNT)
+		     : "="REG_OUT (res)
+		     : REG_IN (w));
+
+	return res;
+}
+
+static inline unsigned int __arch_hweight16(unsigned int w)
+{
+	return __arch_hweight32(w & 0xffff);
+}
+
+static inline unsigned int __arch_hweight8(unsigned int w)
+{
+	return __arch_hweight32(w & 0xff);
+}
+
+static inline unsigned long __arch_hweight64(__u64 w)
+{
+	unsigned long res = 0;
+
+#ifdef CONFIG_X86_32
+	return  __arch_hweight32((u32)w) +
+		__arch_hweight32((u32)(w >> 32));
+#else
+	asm (ALTERNATIVE("call __sw_hweight64", POPCNT, X86_FEATURE_POPCNT)
+		     : "="REG_OUT (res)
+		     : REG_IN (w));
+#endif /* CONFIG_X86_32 */
+
+	return res;
+}
+
+#endif
diff -puN arch/x86/include/asm/bitops.h~x86-add-optimized-popcnt-variants arch/x86/include/asm/bitops.h
--- a/arch/x86/include/asm/bitops.h~x86-add-optimized-popcnt-variants
+++ a/arch/x86/include/asm/bitops.h
@@ -444,7 +444,9 @@ static inline int fls(int x)
 
 #define ARCH_HAS_FAST_MULTIPLIER 1
 
-#include <asm-generic/bitops/hweight.h>
+#include <asm/arch_hweight.h>
+
+#include <asm-generic/bitops/const_hweight.h>
 
 #endif /* __KERNEL__ */
 
diff -puN include/asm-generic/bitops/arch_hweight.h~x86-add-optimized-popcnt-variants include/asm-generic/bitops/arch_hweight.h
--- a/include/asm-generic/bitops/arch_hweight.h~x86-add-optimized-popcnt-variants
+++ a/include/asm-generic/bitops/arch_hweight.h
@@ -3,9 +3,23 @@
 
 #include <asm/types.h>
 
-extern unsigned int __arch_hweight32(unsigned int w);
-extern unsigned int __arch_hweight16(unsigned int w);
-extern unsigned int __arch_hweight8(unsigned int w);
-extern unsigned long __arch_hweight64(__u64 w);
+inline unsigned int __arch_hweight32(unsigned int w)
+{
+	return __sw_hweight32(w);
+}
 
+inline unsigned int __arch_hweight16(unsigned int w)
+{
+	return __sw_hweight16(w);
+}
+
+inline unsigned int __arch_hweight8(unsigned int w)
+{
+	return __sw_hweight8(w);
+}
+
+inline unsigned long __arch_hweight64(__u64 w)
+{
+	return __sw_hweight64(w);
+}
 #endif /* _ASM_GENERIC_BITOPS_HWEIGHT_H_ */
diff -puN lib/Makefile~x86-add-optimized-popcnt-variants lib/Makefile
--- a/lib/Makefile~x86-add-optimized-popcnt-variants
+++ a/lib/Makefile
@@ -39,7 +39,10 @@ lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) +=
 lib-$(CONFIG_GENERIC_FIND_FIRST_BIT) += find_next_bit.o
 lib-$(CONFIG_GENERIC_FIND_NEXT_BIT) += find_next_bit.o
 obj-$(CONFIG_GENERIC_FIND_LAST_BIT) += find_last_bit.o
+
+CFLAGS_hweight.o = $(subst $(quote),,$(CONFIG_ARCH_HWEIGHT_CFLAGS))
 obj-$(CONFIG_GENERIC_HWEIGHT) += hweight.o
+
 obj-$(CONFIG_LOCK_KERNEL) += kernel_lock.o
 obj-$(CONFIG_BTREE) += btree.o
 obj-$(CONFIG_DEBUG_PREEMPT) += smp_processor_id.o
diff -puN lib/hweight.c~x86-add-optimized-popcnt-variants lib/hweight.c
--- a/lib/hweight.c~x86-add-optimized-popcnt-variants
+++ a/lib/hweight.c
@@ -9,7 +9,7 @@
  * The Hamming Weight of a number is the total number of bits set in it.
  */
 
-unsigned int __arch_hweight32(unsigned int w)
+unsigned int __sw_hweight32(unsigned int w)
 {
 #ifdef ARCH_HAS_FAST_MULTIPLIER
 	w -= (w >> 1) & 0x55555555;
@@ -24,30 +24,30 @@ unsigned int __arch_hweight32(unsigned i
 	return (res + (res >> 16)) & 0x000000FF;
 #endif
 }
-EXPORT_SYMBOL(__arch_hweight32);
+EXPORT_SYMBOL(__sw_hweight32);
 
-unsigned int __arch_hweight16(unsigned int w)
+unsigned int __sw_hweight16(unsigned int w)
 {
 	unsigned int res = w - ((w >> 1) & 0x5555);
 	res = (res & 0x3333) + ((res >> 2) & 0x3333);
 	res = (res + (res >> 4)) & 0x0F0F;
 	return (res + (res >> 8)) & 0x00FF;
 }
-EXPORT_SYMBOL(__arch_hweight16);
+EXPORT_SYMBOL(__sw_hweight16);
 
-unsigned int __arch_hweight8(unsigned int w)
+unsigned int __sw_hweight8(unsigned int w)
 {
 	unsigned int res = w - ((w >> 1) & 0x55);
 	res = (res & 0x33) + ((res >> 2) & 0x33);
 	return (res + (res >> 4)) & 0x0F;
 }
-EXPORT_SYMBOL(__arch_hweight8);
+EXPORT_SYMBOL(__sw_hweight8);
 
-unsigned long __arch_hweight64(__u64 w)
+unsigned long __sw_hweight64(__u64 w)
 {
 #if BITS_PER_LONG == 32
-	return __arch_hweight32((unsigned int)(w >> 32)) +
-	       __arch_hweight32((unsigned int)w);
+	return __sw_hweight32((unsigned int)(w >> 32)) +
+	       __sw_hweight32((unsigned int)w);
 #elif BITS_PER_LONG == 64
 #ifdef ARCH_HAS_FAST_MULTIPLIER
 	w -= (w >> 1) & 0x5555555555555555ul;
@@ -64,4 +64,4 @@ unsigned long __arch_hweight64(__u64 w)
 #endif
 #endif
 }
-EXPORT_SYMBOL(__arch_hweight64);
+EXPORT_SYMBOL(__sw_hweight64);
diff -puN scripts/Makefile.lib~x86-add-optimized-popcnt-variants scripts/Makefile.lib
--- a/scripts/Makefile.lib~x86-add-optimized-popcnt-variants
+++ a/scripts/Makefile.lib
@@ -245,3 +245,7 @@ quiet_cmd_lzo = LZO     $@
 cmd_lzo = (cat $(filter-out FORCE,$^) | \
 	lzop -9 && $(call size_append, $(filter-out FORCE,$^))) > $@ || \
 	(rm -f $@ ; false)
+
+# misc stuff
+# ---------------------------------------------------------------------------
+quote:="
_

Patches currently in -mm which might be from borislav.petkov@amd.com are

origin.patch
linux-next.patch
x86-add-optimized-popcnt-variants.patch

