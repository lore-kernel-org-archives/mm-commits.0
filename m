From: akpm@linux-foundation.org
Subject: - use-x86_eflags_if-in-x86-64-irqflagsh.patch removed from -mm tree
Date: Mon, 02 Apr 2007 16:04:12 -0700
Message-ID: <200704022304.l32N4C2l011964@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52017 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966082AbXDBXEV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 2 Apr 2007 19:04:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     Use X86_EFLAGS_IF in x86-64/irqflags.h.
has been removed from the -mm tree.  Its filename was
     use-x86_eflags_if-in-x86-64-irqflagsh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use X86_EFLAGS_IF in x86-64/irqflags.h.
From: Rusty Russell <rusty@rustcorp.com.au>

As per i386 patch: move X86_EFLAGS_IF et al out to a new header:
processor-flags.h, so we can include it from irqflags.h and use it in
raw_irqs_disabled_flags().

As a side-effect, we could now use these flags in .S files.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86_64/irqflags.h        |    9 ++++----
 include/asm-x86_64/processor-flags.h |   26 +++++++++++++++++++++++++
 include/asm-x86_64/processor.h       |   22 ---------------------
 3 files changed, 32 insertions(+), 25 deletions(-)

diff -puN include/asm-x86_64/irqflags.h~use-x86_eflags_if-in-x86-64-irqflagsh include/asm-x86_64/irqflags.h
--- a/include/asm-x86_64/irqflags.h~use-x86_eflags_if-in-x86-64-irqflagsh
+++ a/include/asm-x86_64/irqflags.h
@@ -9,6 +9,7 @@
  */
 #ifndef _ASM_IRQFLAGS_H
 #define _ASM_IRQFLAGS_H
+#include <asm/processor-flags.h>
 
 #ifndef __ASSEMBLY__
 /*
@@ -53,19 +54,19 @@ static inline void raw_local_irq_disable
 {
 	unsigned long flags = __raw_local_save_flags();
 
-	raw_local_irq_restore((flags & ~(1 << 9)) | (1 << 18));
+	raw_local_irq_restore((flags & ~X86_EFLAGS_IF) | X86_EFLAGS_AC);
 }
 
 static inline void raw_local_irq_enable(void)
 {
 	unsigned long flags = __raw_local_save_flags();
 
-	raw_local_irq_restore((flags | (1 << 9)) & ~(1 << 18));
+	raw_local_irq_restore((flags | X86_EFLAGS_IF) & (~X86_EFLAGS_AC));
 }
 
 static inline int raw_irqs_disabled_flags(unsigned long flags)
 {
-	return !(flags & (1<<9)) || (flags & (1 << 18));
+	return !(flags & X86_EFLAGS_IF) || (flags & X86_EFLAGS_AC);
 }
 
 #else /* CONFIG_X86_VSMP */
@@ -82,7 +83,7 @@ static inline void raw_local_irq_enable(
 
 static inline int raw_irqs_disabled_flags(unsigned long flags)
 {
-	return !(flags & (1 << 9));
+	return !(flags & X86_EFLAGS_IF);
 }
 
 #endif
diff -puN /dev/null include/asm-x86_64/processor-flags.h
--- /dev/null
+++ a/include/asm-x86_64/processor-flags.h
@@ -0,0 +1,26 @@
+#ifndef __ASM_X86_64_PROCESSOR_FLAGS_H
+#define __ASM_X86_64_PROCESSOR_FLAGS_H
+/* Various flags defined: can be included from assembler. */
+
+/*
+ * EFLAGS bits
+ */
+#define X86_EFLAGS_CF	0x00000001 /* Carry Flag */
+#define X86_EFLAGS_PF	0x00000004 /* Parity Flag */
+#define X86_EFLAGS_AF	0x00000010 /* Auxillary carry Flag */
+#define X86_EFLAGS_ZF	0x00000040 /* Zero Flag */
+#define X86_EFLAGS_SF	0x00000080 /* Sign Flag */
+#define X86_EFLAGS_TF	0x00000100 /* Trap Flag */
+#define X86_EFLAGS_IF	0x00000200 /* Interrupt Flag */
+#define X86_EFLAGS_DF	0x00000400 /* Direction Flag */
+#define X86_EFLAGS_OF	0x00000800 /* Overflow Flag */
+#define X86_EFLAGS_IOPL	0x00003000 /* IOPL mask */
+#define X86_EFLAGS_NT	0x00004000 /* Nested Task */
+#define X86_EFLAGS_RF	0x00010000 /* Resume Flag */
+#define X86_EFLAGS_VM	0x00020000 /* Virtual Mode */
+#define X86_EFLAGS_AC	0x00040000 /* Alignment Check */
+#define X86_EFLAGS_VIF	0x00080000 /* Virtual Interrupt Flag */
+#define X86_EFLAGS_VIP	0x00100000 /* Virtual Interrupt Pending */
+#define X86_EFLAGS_ID	0x00200000 /* CPUID detection flag */
+
+#endif /* __ASM_X86_64_PROCESSOR_FLAGS_H */
diff -puN include/asm-x86_64/processor.h~use-x86_eflags_if-in-x86-64-irqflagsh include/asm-x86_64/processor.h
--- a/include/asm-x86_64/processor.h~use-x86_eflags_if-in-x86-64-irqflagsh
+++ a/include/asm-x86_64/processor.h
@@ -20,6 +20,7 @@
 #include <asm/percpu.h>
 #include <linux/personality.h>
 #include <linux/cpumask.h>
+#include <asm/processor-flags.h>
 
 #define TF_MASK		0x00000100
 #define IF_MASK		0x00000200
@@ -103,27 +104,6 @@ extern unsigned int init_intel_cacheinfo
 extern unsigned short num_cache_leaves;
 
 /*
- * EFLAGS bits
- */
-#define X86_EFLAGS_CF	0x00000001 /* Carry Flag */
-#define X86_EFLAGS_PF	0x00000004 /* Parity Flag */
-#define X86_EFLAGS_AF	0x00000010 /* Auxillary carry Flag */
-#define X86_EFLAGS_ZF	0x00000040 /* Zero Flag */
-#define X86_EFLAGS_SF	0x00000080 /* Sign Flag */
-#define X86_EFLAGS_TF	0x00000100 /* Trap Flag */
-#define X86_EFLAGS_IF	0x00000200 /* Interrupt Flag */
-#define X86_EFLAGS_DF	0x00000400 /* Direction Flag */
-#define X86_EFLAGS_OF	0x00000800 /* Overflow Flag */
-#define X86_EFLAGS_IOPL	0x00003000 /* IOPL mask */
-#define X86_EFLAGS_NT	0x00004000 /* Nested Task */
-#define X86_EFLAGS_RF	0x00010000 /* Resume Flag */
-#define X86_EFLAGS_VM	0x00020000 /* Virtual Mode */
-#define X86_EFLAGS_AC	0x00040000 /* Alignment Check */
-#define X86_EFLAGS_VIF	0x00080000 /* Virtual Interrupt Flag */
-#define X86_EFLAGS_VIP	0x00100000 /* Virtual Interrupt Pending */
-#define X86_EFLAGS_ID	0x00200000 /* CPUID detection flag */
-
-/*
  * Intel CPU features in CR4
  */
 #define X86_CR4_VME		0x0001	/* enable vm86 extensions */
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

vmi-paravirt-ops-bugfix-for-2621.patch
git-kbuild.patch
git-net.patch
allow-per-cpu-variables-to-be-page-aligned.patch
array_size-check-for-type.patch
array_size-check-for-type-uml-fix.patch
module-use-krealloc.patch
extend-print_symbol-capability.patch
extend-print_symbol-capability-fix.patch
futex-restartable-futex_wait.patch
futex-restartable-futex_wait-fix.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
add-ability-to-keep-track-of-callers-of-symbol_getput-update.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
____call_usermodehelper-dont-flush_signals.patch
