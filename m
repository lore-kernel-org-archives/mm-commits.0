From: akpm@linux-foundation.org
Subject: + x86_64-save-registers-in-saved_context-during-suspend-and-hibernation.patch added to -mm tree
Date: Fri, 17 Aug 2007 14:08:32 -0700
Message-ID: <200708172108.l7HL8WHj029484@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41834 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756211AbXHQVJe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Aug 2007 17:09:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, ak@suse.de, pavel@ucw.cz


The patch titled
     x86_64: save registers in saved_context during suspend and hibernation
has been added to the -mm tree.  Its filename is
     x86_64-save-registers-in-saved_context-during-suspend-and-hibernation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: save registers in saved_context during suspend and hibernation
From: Rafael J. Wysocki <rjw@sisk.pl>

During hibernation and suspend on x86_64 save CPU registers in the
saved_context structure rather than in a handful of separate variables.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Looks-ok-to: Pavel Machek <pavel@ucw.cz>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/acpi/wakeup.S |  101 +++++++++++++++--------------
 arch/x86_64/kernel/asm-offsets.c |   28 ++++++++
 arch/x86_64/kernel/suspend.c     |    6 -
 arch/x86_64/kernel/suspend_asm.S |   72 ++++++++++----------
 include/asm-x86_64/suspend.h     |   23 ++----
 5 files changed, 125 insertions(+), 105 deletions(-)

diff -puN arch/x86_64/kernel/acpi/wakeup.S~x86_64-save-registers-in-saved_context-during-suspend-and-hibernation arch/x86_64/kernel/acpi/wakeup.S
--- a/arch/x86_64/kernel/acpi/wakeup.S~x86_64-save-registers-in-saved_context-during-suspend-and-hibernation
+++ a/arch/x86_64/kernel/acpi/wakeup.S
@@ -4,6 +4,7 @@
 #include <asm/pgtable.h>
 #include <asm/page.h>
 #include <asm/msr.h>
+#include <asm/asm-offsets.h>
 
 # Copyright 2003 Pavel Machek <pavel@suse.cz>, distribute under GPLv2
 #
@@ -395,31 +396,32 @@ do_suspend_lowlevel:
 	xorl	%eax, %eax
 	call	save_processor_state
 
-	movq %rsp, saved_context_esp(%rip)
-	movq %rax, saved_context_eax(%rip)
-	movq %rbx, saved_context_ebx(%rip)
-	movq %rcx, saved_context_ecx(%rip)
-	movq %rdx, saved_context_edx(%rip)
-	movq %rbp, saved_context_ebp(%rip)
-	movq %rsi, saved_context_esi(%rip)
-	movq %rdi, saved_context_edi(%rip)
-	movq %r8,  saved_context_r08(%rip)
-	movq %r9,  saved_context_r09(%rip)
-	movq %r10, saved_context_r10(%rip)
-	movq %r11, saved_context_r11(%rip)
-	movq %r12, saved_context_r12(%rip)
-	movq %r13, saved_context_r13(%rip)
-	movq %r14, saved_context_r14(%rip)
-	movq %r15, saved_context_r15(%rip)
-	pushfq ; popq saved_context_eflags(%rip)
+	movq	$saved_context, %rax
+	movq	%rsp, pt_regs_rsp(%rax)
+	movq	%rbp, pt_regs_rbp(%rax)
+	movq	%rsi, pt_regs_rsi(%rax)
+	movq	%rdi, pt_regs_rdi(%rax)
+	movq	%rbx, pt_regs_rbx(%rax)
+	movq	%rcx, pt_regs_rcx(%rax)
+	movq	%rdx, pt_regs_rdx(%rax)
+	movq	%r8, pt_regs_r8(%rax)
+	movq	%r9, pt_regs_r9(%rax)
+	movq	%r10, pt_regs_r10(%rax)
+	movq	%r11, pt_regs_r11(%rax)
+	movq	%r12, pt_regs_r12(%rax)
+	movq	%r13, pt_regs_r13(%rax)
+	movq	%r14, pt_regs_r14(%rax)
+	movq	%r15, pt_regs_r15(%rax)
+	pushfq
+	popq	pt_regs_eflags(%rax)
 
 	movq	$.L97, saved_rip(%rip)
 
-	movq %rsp,saved_rsp
-	movq %rbp,saved_rbp
-	movq %rbx,saved_rbx
-	movq %rdi,saved_rdi
-	movq %rsi,saved_rsi
+	movq	%rsp, saved_rsp
+	movq	%rbp, saved_rbp
+	movq	%rbx, saved_rbx
+	movq	%rdi, saved_rdi
+	movq	%rsi, saved_rsi
 
 	addq	$8, %rsp
 	movl	$3, %edi
@@ -430,32 +432,35 @@ do_suspend_lowlevel:
 .L99:
 	.align 4
 	movl	$24, %eax
-	movw %ax, %ds
-	movq	saved_context+58(%rip), %rax
-	movq %rax, %cr4
-	movq	saved_context+50(%rip), %rax
-	movq %rax, %cr3
-	movq	saved_context+42(%rip), %rax
-	movq %rax, %cr2
-	movq	saved_context+34(%rip), %rax
-	movq %rax, %cr0
-	pushq saved_context_eflags(%rip) ; popfq
-	movq saved_context_esp(%rip), %rsp
-	movq saved_context_ebp(%rip), %rbp
-	movq saved_context_eax(%rip), %rax
-	movq saved_context_ebx(%rip), %rbx
-	movq saved_context_ecx(%rip), %rcx
-	movq saved_context_edx(%rip), %rdx
-	movq saved_context_esi(%rip), %rsi
-	movq saved_context_edi(%rip), %rdi
-	movq saved_context_r08(%rip), %r8
-	movq saved_context_r09(%rip), %r9
-	movq saved_context_r10(%rip), %r10
-	movq saved_context_r11(%rip), %r11
-	movq saved_context_r12(%rip), %r12
-	movq saved_context_r13(%rip), %r13
-	movq saved_context_r14(%rip), %r14
-	movq saved_context_r15(%rip), %r15
+	movw	%ax, %ds
+
+	/* We don't restore %rax, it must be 0 anyway */
+	movq	$saved_context, %rax
+	movq	saved_context_cr4(%rax), %rbx
+	movq	%rbx, %cr4
+	movq	saved_context_cr3(%rax), %rbx
+	movq	%rbx, %cr3
+	movq	saved_context_cr2(%rax), %rbx
+	movq	%rbx, %cr2
+	movq	saved_context_cr0(%rax), %rbx
+	movq	%rbx, %cr0
+	pushq	pt_regs_eflags(%rax)
+	popfq
+	movq	pt_regs_rsp(%rax), %rsp
+	movq	pt_regs_rbp(%rax), %rbp
+	movq	pt_regs_rsi(%rax), %rsi
+	movq	pt_regs_rdi(%rax), %rdi
+	movq	pt_regs_rbx(%rax), %rbx
+	movq	pt_regs_rcx(%rax), %rcx
+	movq	pt_regs_rdx(%rax), %rdx
+	movq	pt_regs_r8(%rax), %r8
+	movq	pt_regs_r9(%rax), %r9
+	movq	pt_regs_r10(%rax), %r10
+	movq	pt_regs_r11(%rax), %r11
+	movq	pt_regs_r12(%rax), %r12
+	movq	pt_regs_r13(%rax), %r13
+	movq	pt_regs_r14(%rax), %r14
+	movq	pt_regs_r15(%rax), %r15
 
 	xorl	%eax, %eax
 	addq	$8, %rsp
diff -puN arch/x86_64/kernel/asm-offsets.c~x86_64-save-registers-in-saved_context-during-suspend-and-hibernation arch/x86_64/kernel/asm-offsets.c
--- a/arch/x86_64/kernel/asm-offsets.c~x86_64-save-registers-in-saved_context-during-suspend-and-hibernation
+++ a/arch/x86_64/kernel/asm-offsets.c
@@ -76,6 +76,34 @@ int main(void)
 	DEFINE(pbe_orig_address, offsetof(struct pbe, orig_address));
 	DEFINE(pbe_next, offsetof(struct pbe, next));
 	BLANK();
+#define ENTRY(entry) DEFINE(pt_regs_ ## entry, offsetof(struct pt_regs, entry))
+	ENTRY(rbx);
+	ENTRY(rbx);
+	ENTRY(rcx);
+	ENTRY(rdx);
+	ENTRY(rsp);
+	ENTRY(rbp);
+	ENTRY(rsi);
+	ENTRY(rdi);
+	ENTRY(r8);
+	ENTRY(r9);
+	ENTRY(r10);
+	ENTRY(r11);
+	ENTRY(r12);
+	ENTRY(r13);
+	ENTRY(r14);
+	ENTRY(r15);
+	ENTRY(eflags);
+	BLANK();
+#undef ENTRY
+#define ENTRY(entry) DEFINE(saved_context_ ## entry, offsetof(struct saved_context, entry))
+	ENTRY(cr0);
+	ENTRY(cr2);
+	ENTRY(cr3);
+	ENTRY(cr4);
+	ENTRY(cr8);
+	BLANK();
+#undef ENTRY
 	DEFINE(TSS_ist, offsetof(struct tss_struct, ist));
 	BLANK();
 	DEFINE(crypto_tfm_ctx_offset, offsetof(struct crypto_tfm, __crt_ctx));
diff -puN arch/x86_64/kernel/suspend.c~x86_64-save-registers-in-saved_context-during-suspend-and-hibernation arch/x86_64/kernel/suspend.c
--- a/arch/x86_64/kernel/suspend.c~x86_64-save-registers-in-saved_context-during-suspend-and-hibernation
+++ a/arch/x86_64/kernel/suspend.c
@@ -19,12 +19,6 @@ extern const void __nosave_begin, __nosa
 
 struct saved_context saved_context;
 
-unsigned long saved_context_eax, saved_context_ebx, saved_context_ecx, saved_context_edx;
-unsigned long saved_context_esp, saved_context_ebp, saved_context_esi, saved_context_edi;
-unsigned long saved_context_r08, saved_context_r09, saved_context_r10, saved_context_r11;
-unsigned long saved_context_r12, saved_context_r13, saved_context_r14, saved_context_r15;
-unsigned long saved_context_eflags;
-
 void __save_processor_state(struct saved_context *ctxt)
 {
 	kernel_fpu_begin();
diff -puN arch/x86_64/kernel/suspend_asm.S~x86_64-save-registers-in-saved_context-during-suspend-and-hibernation arch/x86_64/kernel/suspend_asm.S
--- a/arch/x86_64/kernel/suspend_asm.S~x86_64-save-registers-in-saved_context-during-suspend-and-hibernation
+++ a/arch/x86_64/kernel/suspend_asm.S
@@ -17,24 +17,24 @@
 #include <asm/asm-offsets.h>
 
 ENTRY(swsusp_arch_suspend)
-
-	movq %rsp, saved_context_esp(%rip)
-	movq %rax, saved_context_eax(%rip)
-	movq %rbx, saved_context_ebx(%rip)
-	movq %rcx, saved_context_ecx(%rip)
-	movq %rdx, saved_context_edx(%rip)
-	movq %rbp, saved_context_ebp(%rip)
-	movq %rsi, saved_context_esi(%rip)
-	movq %rdi, saved_context_edi(%rip)
-	movq %r8,  saved_context_r08(%rip)
-	movq %r9,  saved_context_r09(%rip)
-	movq %r10, saved_context_r10(%rip)
-	movq %r11, saved_context_r11(%rip)
-	movq %r12, saved_context_r12(%rip)
-	movq %r13, saved_context_r13(%rip)
-	movq %r14, saved_context_r14(%rip)
-	movq %r15, saved_context_r15(%rip)
-	pushfq ; popq saved_context_eflags(%rip)
+	movq	$saved_context, %rax
+	movq	%rsp, pt_regs_rsp(%rax)
+	movq	%rbp, pt_regs_rbp(%rax)
+	movq	%rsi, pt_regs_rsi(%rax)
+	movq	%rdi, pt_regs_rdi(%rax)
+	movq	%rbx, pt_regs_rbx(%rax)
+	movq	%rcx, pt_regs_rcx(%rax)
+	movq	%rdx, pt_regs_rdx(%rax)
+	movq	%r8, pt_regs_r8(%rax)
+	movq	%r9, pt_regs_r9(%rax)
+	movq	%r10, pt_regs_r10(%rax)
+	movq	%r11, pt_regs_r11(%rax)
+	movq	%r12, pt_regs_r12(%rax)
+	movq	%r13, pt_regs_r13(%rax)
+	movq	%r14, pt_regs_r14(%rax)
+	movq	%r15, pt_regs_r15(%rax)
+	pushfq
+	popq	pt_regs_eflags(%rax)
 
 	call swsusp_save
 	ret
@@ -87,23 +87,25 @@ done:
 	movl	$24, %eax
 	movl	%eax, %ds
 
-	movq saved_context_esp(%rip), %rsp
-	movq saved_context_ebp(%rip), %rbp
-	/* Don't restore %rax, it must be 0 anyway */
-	movq saved_context_ebx(%rip), %rbx
-	movq saved_context_ecx(%rip), %rcx
-	movq saved_context_edx(%rip), %rdx
-	movq saved_context_esi(%rip), %rsi
-	movq saved_context_edi(%rip), %rdi
-	movq saved_context_r08(%rip), %r8
-	movq saved_context_r09(%rip), %r9
-	movq saved_context_r10(%rip), %r10
-	movq saved_context_r11(%rip), %r11
-	movq saved_context_r12(%rip), %r12
-	movq saved_context_r13(%rip), %r13
-	movq saved_context_r14(%rip), %r14
-	movq saved_context_r15(%rip), %r15
-	pushq saved_context_eflags(%rip) ; popfq
+	/* We don't restore %rax, it must be 0 anyway */
+	movq	$saved_context, %rax
+	movq	pt_regs_rsp(%rax), %rsp
+	movq	pt_regs_rbp(%rax), %rbp
+	movq	pt_regs_rsi(%rax), %rsi
+	movq	pt_regs_rdi(%rax), %rdi
+	movq	pt_regs_rbx(%rax), %rbx
+	movq	pt_regs_rcx(%rax), %rcx
+	movq	pt_regs_rdx(%rax), %rdx
+	movq	pt_regs_r8(%rax), %r8
+	movq	pt_regs_r9(%rax), %r9
+	movq	pt_regs_r10(%rax), %r10
+	movq	pt_regs_r11(%rax), %r11
+	movq	pt_regs_r12(%rax), %r12
+	movq	pt_regs_r13(%rax), %r13
+	movq	pt_regs_r14(%rax), %r14
+	movq	pt_regs_r15(%rax), %r15
+	pushq	pt_regs_eflags(%rax)
+	popfq
 
 	xorq	%rax, %rax
 
diff -puN include/asm-x86_64/suspend.h~x86_64-save-registers-in-saved_context-during-suspend-and-hibernation include/asm-x86_64/suspend.h
--- a/include/asm-x86_64/suspend.h~x86_64-save-registers-in-saved_context-during-suspend-and-hibernation
+++ a/include/asm-x86_64/suspend.h
@@ -3,6 +3,9 @@
  * Based on code
  * Copyright 2001 Patrick Mochel <mochel@osdl.org>
  */
+#ifndef __ASM_X86_64_SUSPEND_H
+#define __ASM_X86_64_SUSPEND_H
+
 #include <asm/desc.h>
 #include <asm/i387.h>
 
@@ -12,8 +15,9 @@ arch_prepare_suspend(void)
 	return 0;
 }
 
-/* Image of the saved processor state. If you touch this, fix acpi_wakeup.S. */
+/* Image of the saved processor state. If you touch this, fix acpi/wakeup.S. */
 struct saved_context {
+	struct pt_regs regs;
   	u16 ds, es, fs, gs, ss;
 	unsigned long gs_base, gs_kernel_base, fs_base;
 	unsigned long cr0, cr2, cr3, cr4, cr8;
@@ -29,27 +33,14 @@ struct saved_context {
 	unsigned long tr;
 	unsigned long safety;
 	unsigned long return_address;
-	unsigned long eflags;
 } __attribute__((packed));
 
-/* We'll access these from assembly, so we'd better have them outside struct */
-extern unsigned long saved_context_eax, saved_context_ebx, saved_context_ecx, saved_context_edx;
-extern unsigned long saved_context_esp, saved_context_ebp, saved_context_esi, saved_context_edi;
-extern unsigned long saved_context_r08, saved_context_r09, saved_context_r10, saved_context_r11;
-extern unsigned long saved_context_r12, saved_context_r13, saved_context_r14, saved_context_r15;
-extern unsigned long saved_context_eflags;
-
 #define loaddebug(thread,register) \
 	set_debugreg((thread)->debugreg##register, register)
 
 extern void fix_processor_context(void);
 
-extern unsigned long saved_rip;
-extern unsigned long saved_rsp;
-extern unsigned long saved_rbp;
-extern unsigned long saved_rbx;
-extern unsigned long saved_rsi;
-extern unsigned long saved_rdi;
-
 /* routines for saving/restoring kernel state */
 extern int acpi_save_state_mem(void);
+
+#endif /* __ASM_X86_64_SUSPEND_H */
_

Patches currently in -mm which might be from rjw@sisk.pl are

pm-fix-dependencies-of-config_suspend-and-config_hibernation-updated-3x.patch
enable-gpes-before-calling-_wak-on-resume.patch
uli526x-add-suspend-and-resume-routines.patch
x86_64-save-registers-in-saved_context-during-suspend-and-hibernation.patch
make-kernel-power-maincsuspend_enter-static.patch
pm-move-definition-of-struct-pm_ops-to-suspendh.patch
pm-rename-struct-pm_ops-and-related-things.patch
pm-rework-struct-platform_suspend_ops.patch
pm-make-suspend_ops-static.patch
pm-rework-struct-hibernation_ops.patch
pm-rename-hibernation_ops-to-platform_hibernation_ops.patch
freezer-document-relationship-with-memory-shrinking.patch
freezer-do-not-sync-filesystems-from-freeze_processes.patch
freezer-prevent-new-tasks-from-inheriting-tif_freeze-set.patch
freezer-introduce-freezer-firendly-waiting-macros.patch
freezer-introduce-freezer-firendly-waiting-macros-fix.patch
freezer-do-not-send-signals-to-kernel-threads.patch
unexport-pm_power_off_prepare.patch
pm_trace-displays-the-wrong-time-from-the-rtc.patch
freezer-be-more-verbose.patch
freezer-use-wait-queue-instead-of-busy-looping.patch
freezer-measure-freezing-time.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option-update.patch
s2ram-kill-old-debugging-junk.patch
shrink_slab-handle-bad-shrinkers.patch
