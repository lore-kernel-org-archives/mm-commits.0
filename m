From: akpm@linux-foundation.org
Subject: + revert-x86-save-registers-in-saved_context-during-suspend-and-hibernation.patch added to -mm tree
Date: Wed, 17 Oct 2007 23:24:38 -0700
Message-ID: <200710180624.l9I6OcVk029202@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41282 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752815AbXJRGYz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 02:24:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, rjw@sisk.pl, tglx@linutronix.de


The patch titled
     revert "x86: Save registers in saved_context during suspend and hibernation"
has been added to the -mm tree.  Its filename is
     revert-x86-save-registers-in-saved_context-during-suspend-and-hibernation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: revert "x86: Save registers in saved_context during suspend and hibernation"
From: Andrew Morton <akpm@linux-foundation.org>

Drop this patch from the x86 tree

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/acpi/wakeup_64.S |  101 +++++++++++++----------------
 arch/x86/kernel/asm-offsets_64.c |   29 --------
 arch/x86/kernel/suspend_64.c     |    6 +
 arch/x86/kernel/suspend_asm_64.S |   72 ++++++++++----------
 include/asm-x86/suspend_64.h     |   23 ++++--
 5 files changed, 105 insertions(+), 126 deletions(-)

diff -puN arch/x86/kernel/acpi/wakeup_64.S~revert-x86-save-registers-in-saved_context-during-suspend-and-hibernation arch/x86/kernel/acpi/wakeup_64.S
--- a/arch/x86/kernel/acpi/wakeup_64.S~revert-x86-save-registers-in-saved_context-during-suspend-and-hibernation
+++ a/arch/x86/kernel/acpi/wakeup_64.S
@@ -4,7 +4,6 @@
 #include <asm/pgtable.h>
 #include <asm/page.h>
 #include <asm/msr.h>
-#include <asm/asm-offsets.h>
 
 # Copyright 2003 Pavel Machek <pavel@suse.cz>, distribute under GPLv2
 #
@@ -343,32 +342,31 @@ do_suspend_lowlevel:
 	xorl	%eax, %eax
 	call	save_processor_state
 
-	movq	$saved_context, %rax
-	movq	%rsp, pt_regs_rsp(%rax)
-	movq	%rbp, pt_regs_rbp(%rax)
-	movq	%rsi, pt_regs_rsi(%rax)
-	movq	%rdi, pt_regs_rdi(%rax)
-	movq	%rbx, pt_regs_rbx(%rax)
-	movq	%rcx, pt_regs_rcx(%rax)
-	movq	%rdx, pt_regs_rdx(%rax)
-	movq	%r8, pt_regs_r8(%rax)
-	movq	%r9, pt_regs_r9(%rax)
-	movq	%r10, pt_regs_r10(%rax)
-	movq	%r11, pt_regs_r11(%rax)
-	movq	%r12, pt_regs_r12(%rax)
-	movq	%r13, pt_regs_r13(%rax)
-	movq	%r14, pt_regs_r14(%rax)
-	movq	%r15, pt_regs_r15(%rax)
-	pushfq
-	popq	pt_regs_eflags(%rax)
+	movq %rsp, saved_context_esp(%rip)
+	movq %rax, saved_context_eax(%rip)
+	movq %rbx, saved_context_ebx(%rip)
+	movq %rcx, saved_context_ecx(%rip)
+	movq %rdx, saved_context_edx(%rip)
+	movq %rbp, saved_context_ebp(%rip)
+	movq %rsi, saved_context_esi(%rip)
+	movq %rdi, saved_context_edi(%rip)
+	movq %r8,  saved_context_r08(%rip)
+	movq %r9,  saved_context_r09(%rip)
+	movq %r10, saved_context_r10(%rip)
+	movq %r11, saved_context_r11(%rip)
+	movq %r12, saved_context_r12(%rip)
+	movq %r13, saved_context_r13(%rip)
+	movq %r14, saved_context_r14(%rip)
+	movq %r15, saved_context_r15(%rip)
+	pushfq ; popq saved_context_eflags(%rip)
 
 	movq	$.L97, saved_rip(%rip)
 
-	movq	%rsp, saved_rsp
-	movq	%rbp, saved_rbp
-	movq	%rbx, saved_rbx
-	movq	%rdi, saved_rdi
-	movq	%rsi, saved_rsi
+	movq %rsp,saved_rsp
+	movq %rbp,saved_rbp
+	movq %rbx,saved_rbx
+	movq %rdi,saved_rdi
+	movq %rsi,saved_rsi
 
 	addq	$8, %rsp
 	movl	$3, %edi
@@ -379,35 +377,32 @@ do_suspend_lowlevel:
 .L99:
 	.align 4
 	movl	$24, %eax
-	movw	%ax, %ds
-
-	/* We don't restore %rax, it must be 0 anyway */
-	movq	$saved_context, %rax
-	movq	saved_context_cr4(%rax), %rbx
-	movq	%rbx, %cr4
-	movq	saved_context_cr3(%rax), %rbx
-	movq	%rbx, %cr3
-	movq	saved_context_cr2(%rax), %rbx
-	movq	%rbx, %cr2
-	movq	saved_context_cr0(%rax), %rbx
-	movq	%rbx, %cr0
-	pushq	pt_regs_eflags(%rax)
-	popfq
-	movq	pt_regs_rsp(%rax), %rsp
-	movq	pt_regs_rbp(%rax), %rbp
-	movq	pt_regs_rsi(%rax), %rsi
-	movq	pt_regs_rdi(%rax), %rdi
-	movq	pt_regs_rbx(%rax), %rbx
-	movq	pt_regs_rcx(%rax), %rcx
-	movq	pt_regs_rdx(%rax), %rdx
-	movq	pt_regs_r8(%rax), %r8
-	movq	pt_regs_r9(%rax), %r9
-	movq	pt_regs_r10(%rax), %r10
-	movq	pt_regs_r11(%rax), %r11
-	movq	pt_regs_r12(%rax), %r12
-	movq	pt_regs_r13(%rax), %r13
-	movq	pt_regs_r14(%rax), %r14
-	movq	pt_regs_r15(%rax), %r15
+	movw %ax, %ds
+	movq	saved_context+58(%rip), %rax
+	movq %rax, %cr4
+	movq	saved_context+50(%rip), %rax
+	movq %rax, %cr3
+	movq	saved_context+42(%rip), %rax
+	movq %rax, %cr2
+	movq	saved_context+34(%rip), %rax
+	movq %rax, %cr0
+	pushq saved_context_eflags(%rip) ; popfq
+	movq saved_context_esp(%rip), %rsp
+	movq saved_context_ebp(%rip), %rbp
+	movq saved_context_eax(%rip), %rax
+	movq saved_context_ebx(%rip), %rbx
+	movq saved_context_ecx(%rip), %rcx
+	movq saved_context_edx(%rip), %rdx
+	movq saved_context_esi(%rip), %rsi
+	movq saved_context_edi(%rip), %rdi
+	movq saved_context_r08(%rip), %r8
+	movq saved_context_r09(%rip), %r9
+	movq saved_context_r10(%rip), %r10
+	movq saved_context_r11(%rip), %r11
+	movq saved_context_r12(%rip), %r12
+	movq saved_context_r13(%rip), %r13
+	movq saved_context_r14(%rip), %r14
+	movq saved_context_r15(%rip), %r15
 
 	xorl	%eax, %eax
 	addq	$8, %rsp
diff -puN arch/x86/kernel/asm-offsets_64.c~revert-x86-save-registers-in-saved_context-during-suspend-and-hibernation arch/x86/kernel/asm-offsets_64.c
--- a/arch/x86/kernel/asm-offsets_64.c~revert-x86-save-registers-in-saved_context-during-suspend-and-hibernation
+++ a/arch/x86/kernel/asm-offsets_64.c
@@ -76,35 +76,6 @@ int main(void)
 	DEFINE(pbe_orig_address, offsetof(struct pbe, orig_address));
 	DEFINE(pbe_next, offsetof(struct pbe, next));
 	BLANK();
-#define ENTRY(entry) DEFINE(pt_regs_ ## entry, offsetof(struct pt_regs, entry))
-	ENTRY(rbx);
-	ENTRY(rbx);
-	ENTRY(rcx);
-	ENTRY(rdx);
-	ENTRY(rsp);
-	ENTRY(rbp);
-	ENTRY(rsi);
-	ENTRY(rdi);
-	ENTRY(r8);
-	ENTRY(r9);
-	ENTRY(r10);
-	ENTRY(r11);
-	ENTRY(r12);
-	ENTRY(r13);
-	ENTRY(r14);
-	ENTRY(r15);
-	ENTRY(eflags);
-	BLANK();
-#undef ENTRY
-#define ENTRY(entry) DEFINE(saved_context_ ## entry, \
-			    offsetof(struct saved_context, entry))
-	ENTRY(cr0);
-	ENTRY(cr2);
-	ENTRY(cr3);
-	ENTRY(cr4);
-	ENTRY(cr8);
-	BLANK();
-#undef ENTRY
 	DEFINE(TSS_ist, offsetof(struct tss_struct, ist));
 	BLANK();
 	DEFINE(crypto_tfm_ctx_offset, offsetof(struct crypto_tfm, __crt_ctx));
diff -puN arch/x86/kernel/suspend_64.c~revert-x86-save-registers-in-saved_context-during-suspend-and-hibernation arch/x86/kernel/suspend_64.c
--- a/arch/x86/kernel/suspend_64.c~revert-x86-save-registers-in-saved_context-during-suspend-and-hibernation
+++ a/arch/x86/kernel/suspend_64.c
@@ -19,6 +19,12 @@ extern const void __nosave_begin, __nosa
 
 struct saved_context saved_context;
 
+unsigned long saved_context_eax, saved_context_ebx, saved_context_ecx, saved_context_edx;
+unsigned long saved_context_esp, saved_context_ebp, saved_context_esi, saved_context_edi;
+unsigned long saved_context_r08, saved_context_r09, saved_context_r10, saved_context_r11;
+unsigned long saved_context_r12, saved_context_r13, saved_context_r14, saved_context_r15;
+unsigned long saved_context_eflags;
+
 void __save_processor_state(struct saved_context *ctxt)
 {
 	kernel_fpu_begin();
diff -puN arch/x86/kernel/suspend_asm_64.S~revert-x86-save-registers-in-saved_context-during-suspend-and-hibernation arch/x86/kernel/suspend_asm_64.S
--- a/arch/x86/kernel/suspend_asm_64.S~revert-x86-save-registers-in-saved_context-during-suspend-and-hibernation
+++ a/arch/x86/kernel/suspend_asm_64.S
@@ -17,24 +17,24 @@
 #include <asm/asm-offsets.h>
 
 ENTRY(swsusp_arch_suspend)
-	movq	$saved_context, %rax
-	movq	%rsp, pt_regs_rsp(%rax)
-	movq	%rbp, pt_regs_rbp(%rax)
-	movq	%rsi, pt_regs_rsi(%rax)
-	movq	%rdi, pt_regs_rdi(%rax)
-	movq	%rbx, pt_regs_rbx(%rax)
-	movq	%rcx, pt_regs_rcx(%rax)
-	movq	%rdx, pt_regs_rdx(%rax)
-	movq	%r8, pt_regs_r8(%rax)
-	movq	%r9, pt_regs_r9(%rax)
-	movq	%r10, pt_regs_r10(%rax)
-	movq	%r11, pt_regs_r11(%rax)
-	movq	%r12, pt_regs_r12(%rax)
-	movq	%r13, pt_regs_r13(%rax)
-	movq	%r14, pt_regs_r14(%rax)
-	movq	%r15, pt_regs_r15(%rax)
-	pushfq
-	popq	pt_regs_eflags(%rax)
+
+	movq %rsp, saved_context_esp(%rip)
+	movq %rax, saved_context_eax(%rip)
+	movq %rbx, saved_context_ebx(%rip)
+	movq %rcx, saved_context_ecx(%rip)
+	movq %rdx, saved_context_edx(%rip)
+	movq %rbp, saved_context_ebp(%rip)
+	movq %rsi, saved_context_esi(%rip)
+	movq %rdi, saved_context_edi(%rip)
+	movq %r8,  saved_context_r08(%rip)
+	movq %r9,  saved_context_r09(%rip)
+	movq %r10, saved_context_r10(%rip)
+	movq %r11, saved_context_r11(%rip)
+	movq %r12, saved_context_r12(%rip)
+	movq %r13, saved_context_r13(%rip)
+	movq %r14, saved_context_r14(%rip)
+	movq %r15, saved_context_r15(%rip)
+	pushfq ; popq saved_context_eflags(%rip)
 
 	call swsusp_save
 	ret
@@ -87,25 +87,23 @@ done:
 	movl	$24, %eax
 	movl	%eax, %ds
 
-	/* We don't restore %rax, it must be 0 anyway */
-	movq	$saved_context, %rax
-	movq	pt_regs_rsp(%rax), %rsp
-	movq	pt_regs_rbp(%rax), %rbp
-	movq	pt_regs_rsi(%rax), %rsi
-	movq	pt_regs_rdi(%rax), %rdi
-	movq	pt_regs_rbx(%rax), %rbx
-	movq	pt_regs_rcx(%rax), %rcx
-	movq	pt_regs_rdx(%rax), %rdx
-	movq	pt_regs_r8(%rax), %r8
-	movq	pt_regs_r9(%rax), %r9
-	movq	pt_regs_r10(%rax), %r10
-	movq	pt_regs_r11(%rax), %r11
-	movq	pt_regs_r12(%rax), %r12
-	movq	pt_regs_r13(%rax), %r13
-	movq	pt_regs_r14(%rax), %r14
-	movq	pt_regs_r15(%rax), %r15
-	pushq	pt_regs_eflags(%rax)
-	popfq
+	movq saved_context_esp(%rip), %rsp
+	movq saved_context_ebp(%rip), %rbp
+	/* Don't restore %rax, it must be 0 anyway */
+	movq saved_context_ebx(%rip), %rbx
+	movq saved_context_ecx(%rip), %rcx
+	movq saved_context_edx(%rip), %rdx
+	movq saved_context_esi(%rip), %rsi
+	movq saved_context_edi(%rip), %rdi
+	movq saved_context_r08(%rip), %r8
+	movq saved_context_r09(%rip), %r9
+	movq saved_context_r10(%rip), %r10
+	movq saved_context_r11(%rip), %r11
+	movq saved_context_r12(%rip), %r12
+	movq saved_context_r13(%rip), %r13
+	movq saved_context_r14(%rip), %r14
+	movq saved_context_r15(%rip), %r15
+	pushq saved_context_eflags(%rip) ; popfq
 
 	xorq	%rax, %rax
 
diff -puN include/asm-x86/suspend_64.h~revert-x86-save-registers-in-saved_context-during-suspend-and-hibernation include/asm-x86/suspend_64.h
--- a/include/asm-x86/suspend_64.h~revert-x86-save-registers-in-saved_context-during-suspend-and-hibernation
+++ a/include/asm-x86/suspend_64.h
@@ -3,9 +3,6 @@
  * Based on code
  * Copyright 2001 Patrick Mochel <mochel@osdl.org>
  */
-#ifndef __ASM_X86_64_SUSPEND_H
-#define __ASM_X86_64_SUSPEND_H
-
 #include <asm/desc.h>
 #include <asm/i387.h>
 
@@ -15,9 +12,8 @@ arch_prepare_suspend(void)
 	return 0;
 }
 
-/* Image of the saved processor state. If you touch this, fix acpi/wakeup.S. */
+/* Image of the saved processor state. If you touch this, fix acpi_wakeup.S. */
 struct saved_context {
-	struct pt_regs regs;
   	u16 ds, es, fs, gs, ss;
 	unsigned long gs_base, gs_kernel_base, fs_base;
 	unsigned long cr0, cr2, cr3, cr4, cr8;
@@ -33,14 +29,27 @@ struct saved_context {
 	unsigned long tr;
 	unsigned long safety;
 	unsigned long return_address;
+	unsigned long eflags;
 } __attribute__((packed));
 
+/* We'll access these from assembly, so we'd better have them outside struct */
+extern unsigned long saved_context_eax, saved_context_ebx, saved_context_ecx, saved_context_edx;
+extern unsigned long saved_context_esp, saved_context_ebp, saved_context_esi, saved_context_edi;
+extern unsigned long saved_context_r08, saved_context_r09, saved_context_r10, saved_context_r11;
+extern unsigned long saved_context_r12, saved_context_r13, saved_context_r14, saved_context_r15;
+extern unsigned long saved_context_eflags;
+
 #define loaddebug(thread,register) \
 	set_debugreg((thread)->debugreg##register, register)
 
 extern void fix_processor_context(void);
 
+extern unsigned long saved_rip;
+extern unsigned long saved_rsp;
+extern unsigned long saved_rbp;
+extern unsigned long saved_rbx;
+extern unsigned long saved_rsi;
+extern unsigned long saved_rdi;
+
 /* routines for saving/restoring kernel state */
 extern int acpi_save_state_mem(void);
-
-#endif /* __ASM_X86_64_SUSPEND_H */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
git-acpi.patch
git-acpi-fixup.patch
acpi-add-reboot-mechanism.patch
console-keyboard-events-and-accessibility.patch
first-stab-at-elantech-touchpad-driver-for-26226-testers.patch
git-kvm.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
ide-arm-hack.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd-fixup.patch
fix-build-breakage-if-sysfs-fix.patch
qla2xxx-printk-fixes.patch
advansys-depends-on-virt_to_bus.patch
sparc-support-for-new-termios.patch
git-unionfs.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-unionfs.patch
git-nfs-vs-git-unionfs.patch
git-watchdog-fixup.patch
git-wireless.patch
git-wireless-fixup.patch
git-x86.patch
revert-x86_64-mm-cpa-einval.patch
fix-x86_64-mm-sched-clock-share.patch
x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron.patch
memory-hotplug-make-kmem_cache_node-for-slub-on-memory-online-avoid-panic-checkpatch-fixes.patch
memory-hotplug-make-kmem_cache_node-for-slub-on-memory-online-avoid-panic-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
capabilities-clean-up-file-capability-reading-checkpatch-fixes.patch
pm-rework-struct-platform_suspend_ops-fixup-checkpatch-fixes.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option-update.patch
revert-x86-save-registers-in-saved_context-during-suspend-and-hibernation.patch
pm-qos-infrastructure-and-interface-fix.patch
pm-qos-infrastructure-and-interface-vs-git-acpi.patch
pm-qos-infrastructure-and-interface-vs-git-acpi-2.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers-checkpatch-fixes.patch
deprecate-smbfs-in-favour-of-cifs.patch
add-kernel-notifierc-fix.patch
add-kernel-notifierc-fix-2-fix-3.patch
console-events-and-accessibility-fix.patch
procfs-detect-duplicate-names-fix.patch
procfs-detect-duplicate-names-fix-fix-2.patch
stop-using-dma_xxbit_mask.patch
stop-using-dma_xxbit_mask-fix.patch
kernel-printkc-concerns-about-the-console-handover.patch
ext2-avoid-rec_len-overflow-with-64kb-block-size-checkpatch-fixes.patch
sync_sb_inodes-propagate-errors.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
jbd-config_jbd_debug-cannot-create-proc-entry-fix.patch
peterz-vs-ext4-mballoc-core.patch
64-bit-i_version-afs-fixes.patch
reiserfs-fix-up-lockdep-warnings-checkpatch-fixes.patch
reiserfs-use-is_reusable-to-catch-corruption-checkpatch-fixes.patch
reiserfs-fix-usage-of-signed-ints-for-block-numbers-checkpatch-fixes.patch
reiserfs-remove-first_zero_hint-checkpatch-fixes.patch
reiserfs-ignore-on-disk-s_bmap_nr-value-checkpatch-fixes.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
task-containersv11-basic-task-container-framework-fix.patch
task-containersv11-shared-container-subsystem-group-arrays-simplify-proc-cgroups-fix.patch
task-containersv11-shared-container-subsystem-group-arrays-include-fix.patch
add-containerstats-v3-fix.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-versus-x86_64-mm-i386-show-unhandled-signals-v3.patch
lockdep-fix-mismatched-lockdep_depth-curr_chain_hash-checkpatch-fixes.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-2.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-3.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
cpuset-sched_load_balance-flag-fix.patch
cpusets-decrustify-cpuset-mask-update-code-checkpatch-fixes.patch
fix-cpusets-update_cpumask-checkpatch-fixes.patch
memory-controller-memory-accounting-v7-fix.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memcontrol-move-oom-task-exclusion-to-tasklist-fix.patch
remove-bits_to_type-macro-fix.patch
use-helpers-to-obtain-task-pid-in-printks-drm-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified-checkpatch-fixes.patch
powerpc-lock-bitops-fix.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix-2.patch
use-extended-crashkernel-command-line-on-i386.patch
ftd_sio-clean-ups-and-updates-for-new-termios-work-checkpatch-fixes.patch
hook-up-group-scheduler-with-control-groups-fix.patch
linux-kernel-markers-checkpatch-fixes.patch
linux-kernel-markers-samples-checkpatch-fixes.patch
uninline-forkc-exitc-checkpatch-fixes.patch
fuse-fix-race-between-getattr-and-write-checkpatch-fixes.patch
fuse-add-file-handle-to-getattr-operation-checkpatch-fixes.patch
sparse-pointer-use-of-zero-as-null-checkpatch-fixes.patch
i-oat-tighten-descriptor-setup-performance-fix.patch
i-oat-add-completion-callback-for-async_tx-interface-use-fix.patch
i-oat-add-completion-callback-for-async_tx-interface-use-fix-fix.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
git-block-vs-reiser4.patch
git-nfsd-broke-reiser4.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
w1-build-fix.patch
