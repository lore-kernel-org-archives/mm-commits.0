From: akpm@linux-foundation.org
Subject: + use-x86_eflags_if-in-irqflagsh-lguest.patch added to -mm tree
Date: Wed, 21 Mar 2007 22:25:30 -0800
Message-ID: <200703220625.l2M6PUBC013886@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41152 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275AbXCVGZf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Mar 2007 02:25:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au


The patch titled
     Use X86_EFLAGS_IF in irqflags.h, lguest
has been added to the -mm tree.  Its filename is
     use-x86_eflags_if-in-irqflagsh-lguest.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use X86_EFLAGS_IF in irqflags.h, lguest
From: Rusty Russell <rusty@rustcorp.com.au>

Move X86_EFLAGS_IF et al out to a new header: processor-flags.h, so we can
include it from irqflags.h and use it in raw_irqs_disabled_flags().

As a side-effect, we could now use these flags in .S files.

Lguest also modified to use the flags.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/lguest/interrupts_and_traps.c |    4 +--
 arch/i386/lguest/lguest.c               |    5 +---
 include/asm-i386/irqflags.h             |    3 +-
 include/asm-i386/processor-flags.h      |   26 ++++++++++++++++++++++
 include/asm-i386/processor.h            |   22 ------------------
 5 files changed, 33 insertions(+), 27 deletions(-)

diff -puN arch/i386/lguest/interrupts_and_traps.c~use-x86_eflags_if-in-irqflagsh-lguest arch/i386/lguest/interrupts_and_traps.c
--- a/arch/i386/lguest/interrupts_and_traps.c~use-x86_eflags_if-in-irqflagsh-lguest
+++ a/arch/i386/lguest/interrupts_and_traps.c
@@ -42,7 +42,7 @@ static void reflect_trap(struct lguest *
 	   (it's always 0, since irqs are enabled when guest is running). */
 	eflags = regs->eflags;
 	get_user(irq_enable, &lg->lguest_data->irq_enabled);
-	eflags |= (irq_enable & 512);
+	eflags |= (irq_enable & X86_EFLAGS_IF);
 
 	push_guest_stack(lg, &gstack, eflags);
 	push_guest_stack(lg, &gstack, regs->cs);
@@ -86,7 +86,7 @@ void maybe_do_interrupt(struct lguest *l
 	/* If they're halted, we re-enable interrupts. */
 	if (lg->halted) {
 		/* Re-enable interrupts. */
-		put_user(512, &lg->lguest_data->irq_enabled);
+		put_user(X86_EFLAGS_IF, &lg->lguest_data->irq_enabled);
 		lg->halted = 0;
 	} else {
 		/* Maybe they have interrupts disabled? */
diff -puN arch/i386/lguest/lguest.c~use-x86_eflags_if-in-irqflagsh-lguest arch/i386/lguest/lguest.c
--- a/arch/i386/lguest/lguest.c~use-x86_eflags_if-in-irqflagsh-lguest
+++ a/arch/i386/lguest/lguest.c
@@ -107,9 +107,8 @@ static void fastcall irq_disable(void)
 
 static void fastcall irq_enable(void)
 {
-	/* Linux i386 code expects bit 9 set. */
 	/* FIXME: Check if interrupt pending... */
-	lguest_data.irq_enabled = 512;
+	lguest_data.irq_enabled = X86_EFLAGS_IF;
 }
 
 static void fastcall lguest_load_gdt(const struct Xgt_desc_struct *desc)
@@ -394,7 +393,7 @@ static fastcall void lguest_write_idt_en
 	extern const char start_##name[], end_##name[];		\
 	asm("start_" #name ": " code "; end_" #name ":")
 DEF_LGUEST(cli, "movl $0," LGUEST_IRQ);
-DEF_LGUEST(sti, "movl $512," LGUEST_IRQ);
+DEF_LGUEST(sti, "movl $"__stringify(X86_EFLAGS_IF)"," LGUEST_IRQ);
 DEF_LGUEST(popf, "movl %eax," LGUEST_IRQ);
 DEF_LGUEST(pushf, "movl " LGUEST_IRQ ",%eax");
 DEF_LGUEST(pushf_cli, "movl " LGUEST_IRQ ",%eax; movl $0," LGUEST_IRQ);
diff -puN include/asm-i386/irqflags.h~use-x86_eflags_if-in-irqflagsh-lguest include/asm-i386/irqflags.h
--- a/include/asm-i386/irqflags.h~use-x86_eflags_if-in-irqflagsh-lguest
+++ a/include/asm-i386/irqflags.h
@@ -9,6 +9,7 @@
  */
 #ifndef _ASM_IRQFLAGS_H
 #define _ASM_IRQFLAGS_H
+#include <asm/processor-flags.h>
 
 #ifndef __ASSEMBLY__
 static inline unsigned long native_save_fl(void)
@@ -119,7 +120,7 @@ static inline unsigned long __raw_local_
 
 static inline int raw_irqs_disabled_flags(unsigned long flags)
 {
-	return !(flags & (1 << 9));
+	return !(flags & X86_EFLAGS_IF);
 }
 
 static inline int raw_irqs_disabled(void)
diff -puN /dev/null include/asm-i386/processor-flags.h
--- /dev/null
+++ a/include/asm-i386/processor-flags.h
@@ -0,0 +1,26 @@
+#ifndef __ASM_I386_PROCESSOR_FLAGS_H
+#define __ASM_I386_PROCESSOR_FLAGS_H
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
+#endif	/* __ASM_I386_PROCESSOR_FLAGS_H */
diff -puN include/asm-i386/processor.h~use-x86_eflags_if-in-irqflagsh-lguest include/asm-i386/processor.h
--- a/include/asm-i386/processor.h~use-x86_eflags_if-in-irqflagsh-lguest
+++ a/include/asm-i386/processor.h
@@ -21,6 +21,7 @@
 #include <asm/percpu.h>
 #include <linux/cpumask.h>
 #include <linux/init.h>
+#include <asm/processor-flags.h>
 
 /* flag for disabling the tsc */
 extern int tsc_disable;
@@ -126,27 +127,6 @@ extern void detect_ht(struct cpuinfo_x86
 static inline void detect_ht(struct cpuinfo_x86 *c) {}
 #endif
 
-/*
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
 static inline void native_cpuid(unsigned int *eax, unsigned int *ebx,
 					 unsigned int *ecx, unsigned int *edx)
 {
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

make-kvm-conform-to-sucky-rdmsr-interface.patch
i386-vdso_prelink-warning-fix.patch
cleanup-initialize-esp0-properly-all-the-time.patch
lguest-preparation-export_symbol_gpl-5-functions.patch
lguest-preparation-expose-futex-infrastructure.patch
lguest-kconfig-and-headers.patch
lguest-the-host-code-lgko.patch
lguest-the-host-code-lgko-cleanup-allocate-separate-pages-for-switcher-code.patch
lguest-the-host-code-lgko-cleanup-clean-up-regs-save-restore.patch
lguest-the-host-code-lgko-pin-stack-page-optimization.patch
lguest-guest-code.patch
lguest-clean-up-some-references-inittext-warnings.patch
lguest-makefile.patch
lguest-use-read-only-pages-rather-than-segments-to-protect-high-mapped-switcher.patch
lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages.patch
lguest-compile-hypervisors-into-the-lg-module-directly.patch
lguest-dont-crash-host-on-nmi.patch
lguest-trivial-guest-network-driver.patch
lguest-trivial-guest-console-driver.patch
lguest-trivial-guest-block-driver.patch
lguest-trivial-guest-block-driver-lguest-block-device-speedup.patch
lguest-documentatation-and-example-launcher.patch
lguest-documentatation-and-example-launcher-bridging-support-in-example-code.patch
lguest-documentatation-and-example-launcher-bridging-support-in-example-codelguest-documentation-fixes.patch
introduce-load_tls-to-the-for-loop.patch
remove-unused-set_seg_base.patch
clarify-config_reorder-explanation.patch
allow-per-cpu-variables-to-be-page-aligned.patch
i386-gdt-cleanups-use-per-cpu-variables-for-gdt-pda.patch
i386-gdt-cleanups-use-per-cpu-gdt-immediately-upon-boot.patch
i386-gdt-cleanups-use-per-cpu-gdt-immediately-upon-boot-fix.patch
i386-gdt-cleanups-clean-up-cpu_init.patch
i386-gdt-cleanups-cleanup-gdt-access.patch
cleanup-rationalize-paravirt-wrappers.patch
use-x86_eflags_if-in-irqflagsh-lguest.patch
module-use-krealloc.patch
extend-print_symbol-capability.patch
array_size-check-for-type.patch
futex-restartable-futex_wait.patch
futex-restartable-futex_wait-fix.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
add-ability-to-keep-track-of-callers-of-symbol_getput-update.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
____call_usermodehelper-dont-flush_signals.patch
