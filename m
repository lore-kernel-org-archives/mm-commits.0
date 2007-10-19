From: akpm@linux-foundation.org
Subject: - git-x86-fixup.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:37:38 -0700
Message-ID: <200710190337.l9J3bcE1012529@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57155 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934146AbXJSDhk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:37:40 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l9J3bcsJ030455
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Thu, 18 Oct 2007 20:37:39 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     git-x86-fixup
has been removed from the -mm tree.  Its filename was
     git-x86-fixup.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: git-x86-fixup
From: Andrew Morton <akpm@linux-foundation.org>


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/suspend_asm_64.S |   36 +++++++++++++++--------------
 include/asm-x86/suspend_64.h     |   10 +-------
 2 files changed, 21 insertions(+), 25 deletions(-)

diff -puN arch/x86/kernel/suspend_asm_64.S~git-x86-fixup arch/x86/kernel/suspend_asm_64.S
--- a/arch/x86/kernel/suspend_asm_64.S~git-x86-fixup
+++ a/arch/x86/kernel/suspend_asm_64.S
@@ -113,23 +113,25 @@ ENTRY(restore_registers)
 	movq	%rcx, %cr3
 	movq	%rax, %cr4;  # turn PGE back on
 
-	movq saved_context_esp(%rip), %rsp
-	movq saved_context_ebp(%rip), %rbp
-	/* restore GPRs (we don't restore %rax, it must be 0 anyway) */
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
 
diff -puN include/asm-x86/suspend_64.h~git-x86-fixup include/asm-x86/suspend_64.h
--- a/include/asm-x86/suspend_64.h~git-x86-fixup
+++ a/include/asm-x86/suspend_64.h
@@ -33,16 +33,8 @@ struct saved_context {
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
 
@@ -59,3 +51,5 @@ extern unsigned long saved_rdi;
 extern int acpi_save_state_mem(void);
 extern char core_restore_code;
 extern char restore_registers;
+
+#endif /* __ASM_X86_64_SUSPEND_H */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
console-keyboard-events-and-accessibility.patch
git-acpi.patch
git-acpi-fixup.patch
acpi-add-reboot-mechanism.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-cifs.patch
first-stab-at-elantech-touchpad-driver-for-26226-testers.patch
git-kvm.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
ide-arm-hack.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd-fixup.patch
git-parisc.patch
fix-build-breakage-if-sysfs-fix.patch
git-scsi-misc.patch
advansys-depends-on-virt_to_bus.patch
git-unionfs.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-unionfs.patch
git-nfs-vs-git-unionfs.patch
git-wireless.patch
git-wireless-fixup.patch
git-x86.patch
git-x86-fixup.patch
revert-x86_64-mm-cpa-einval.patch
fix-x86_64-mm-sched-clock-share.patch
x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron.patch
git-xfs.patch
memory-hotplug-make-kmem_cache_node-for-slub-on-memory-online-avoid-panic-checkpatch-fixes.patch
memory-hotplug-make-kmem_cache_node-for-slub-on-memory-online-avoid-panic-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
capabilities-clean-up-file-capability-reading-checkpatch-fixes.patch
pm-qos-infrastructure-and-interface-fix.patch
pm-qos-infrastructure-and-interface-vs-git-acpi.patch
pm-qos-infrastructure-and-interface-vs-git-acpi-2.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers-checkpatch-fixes.patch
deprecate-smbfs-in-favour-of-cifs.patch
add-kernel-notifierc.patch
console-events-and-accessibility-fix.patch
procfs-detect-duplicate-names-fix.patch
procfs-detect-duplicate-names-fix-fix-2.patch
kernel-printkc-concerns-about-the-console-handover.patch
ext2-avoid-rec_len-overflow-with-64kb-block-size-checkpatch-fixes.patch
sync_sb_inodes-propagate-errors.patch
fix-random-hard-freeze-with-avm-cards-using-b1dma-checkpatch-fixes.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
jbd-config_jbd_debug-cannot-create-proc-entry-fix.patch
peterz-vs-ext4-mballoc-core.patch
64-bit-i_version-afs-fixes.patch
reiserfs-ignore-on-disk-s_bmap_nr-value-checkpatch-fixes-2.patch
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
ipc-integrate-ipc_checkid-into-ipc_lock-fix.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix-2.patch
use-extended-crashkernel-command-line-on-i386.patch
kexec-add-bss-to-resource-tree-checkpatch-fixes.patch
kexec-introduce-bootmem_exclusive-checkpatch-fixes.patch
ftd_sio-clean-ups-and-updates-for-new-termios-work-checkpatch-fixes.patch
hook-up-group-scheduler-with-control-groups-fix.patch
linux-kernel-markers-checkpatch-fixes.patch
linux-kernel-markers-samples-checkpatch-fixes.patch
uninline-forkc-exitc-checkpatch-fixes.patch
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
