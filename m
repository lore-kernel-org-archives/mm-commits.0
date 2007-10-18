From: akpm@linux-foundation.org
Subject: - add-kernel-notifierc-fix.patch removed from -mm tree
Date: Thu, 18 Oct 2007 13:30:45 -0700
Message-ID: <200710182030.l9IKUjF5029691@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51912 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752369AbXJRUbx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 16:31:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, adobriyan@sw.ru, mm-commits@vger.kernel.org


The patch titled
     add-kernel-notifierc-fix
has been removed from the -mm tree.  Its filename was
     add-kernel-notifierc-fix.patch

This patch was dropped because it was folded into add-kernel-notifierc.patch

------------------------------------------------------
Subject: add-kernel-notifierc-fix
From: Andrew Morton <akpm@linux-foundation.org>

Might as well fix all the checkpatch warnigns while we're there.

Cc: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/notifier.c |   21 +++------------------
 1 files changed, 3 insertions(+), 18 deletions(-)

diff -puN kernel/notifier.c~add-kernel-notifierc-fix kernel/notifier.c
--- a/kernel/notifier.c~add-kernel-notifierc-fix
+++ a/kernel/notifier.c
@@ -107,7 +107,6 @@ int atomic_notifier_chain_register(struc
 	spin_unlock_irqrestore(&nh->lock, flags);
 	return ret;
 }
-
 EXPORT_SYMBOL_GPL(atomic_notifier_chain_register);
 
 /**
@@ -131,7 +130,6 @@ int atomic_notifier_chain_unregister(str
 	synchronize_rcu();
 	return ret;
 }
-
 EXPORT_SYMBOL_GPL(atomic_notifier_chain_unregister);
 
 /**
@@ -165,7 +163,6 @@ int __kprobes __atomic_notifier_call_cha
 	rcu_read_unlock();
 	return ret;
 }
-
 EXPORT_SYMBOL_GPL(__atomic_notifier_call_chain);
 
 int __kprobes atomic_notifier_call_chain(struct atomic_notifier_head *nh,
@@ -173,8 +170,8 @@ int __kprobes atomic_notifier_call_chain
 {
 	return __atomic_notifier_call_chain(nh, val, v, -1, NULL);
 }
-
 EXPORT_SYMBOL_GPL(atomic_notifier_call_chain);
+
 /*
  *	Blocking notifier chain routines.  All access to the chain is
  *	synchronized by an rwsem.
@@ -209,7 +206,6 @@ int blocking_notifier_chain_register(str
 	up_write(&nh->rwsem);
 	return ret;
 }
-
 EXPORT_SYMBOL_GPL(blocking_notifier_chain_register);
 
 /**
@@ -240,7 +236,6 @@ int blocking_notifier_chain_unregister(s
 	up_write(&nh->rwsem);
 	return ret;
 }
-
 EXPORT_SYMBOL_GPL(blocking_notifier_chain_unregister);
 
 /**
@@ -311,7 +306,6 @@ int raw_notifier_chain_register(struct r
 {
 	return notifier_chain_register(&nh->head, n);
 }
-
 EXPORT_SYMBOL_GPL(raw_notifier_chain_register);
 
 /**
@@ -329,7 +323,6 @@ int raw_notifier_chain_unregister(struct
 {
 	return notifier_chain_unregister(&nh->head, n);
 }
-
 EXPORT_SYMBOL_GPL(raw_notifier_chain_unregister);
 
 /**
@@ -358,7 +351,6 @@ int __raw_notifier_call_chain(struct raw
 {
 	return notifier_call_chain(&nh->head, val, v, nr_to_call, nr_calls);
 }
-
 EXPORT_SYMBOL_GPL(__raw_notifier_call_chain);
 
 int raw_notifier_call_chain(struct raw_notifier_head *nh,
@@ -366,7 +358,6 @@ int raw_notifier_call_chain(struct raw_n
 {
 	return __raw_notifier_call_chain(nh, val, v, -1, NULL);
 }
-
 EXPORT_SYMBOL_GPL(raw_notifier_call_chain);
 
 /*
@@ -403,7 +394,6 @@ int srcu_notifier_chain_register(struct 
 	mutex_unlock(&nh->mutex);
 	return ret;
 }
-
 EXPORT_SYMBOL_GPL(srcu_notifier_chain_register);
 
 /**
@@ -435,7 +425,6 @@ int srcu_notifier_chain_unregister(struc
 	synchronize_srcu(&nh->srcu);
 	return ret;
 }
-
 EXPORT_SYMBOL_GPL(srcu_notifier_chain_unregister);
 
 /**
@@ -498,7 +487,6 @@ void srcu_init_notifier_head(struct srcu
 		BUG();
 	nh->head = NULL;
 }
-
 EXPORT_SYMBOL_GPL(srcu_init_notifier_head);
 
 /**
@@ -512,11 +500,10 @@ EXPORT_SYMBOL_GPL(srcu_init_notifier_hea
  *	always returns zero.
  */
 
-int register_reboot_notifier(struct notifier_block * nb)
+int register_reboot_notifier(struct notifier_block *nb)
 {
 	return blocking_notifier_chain_register(&reboot_notifier_list, nb);
 }
-
 EXPORT_SYMBOL(register_reboot_notifier);
 
 /**
@@ -529,15 +516,13 @@ EXPORT_SYMBOL(register_reboot_notifier);
  *	Returns zero on success, or %-ENOENT on failure.
  */
 
-int unregister_reboot_notifier(struct notifier_block * nb)
+int unregister_reboot_notifier(struct notifier_block *nb)
 {
 	return blocking_notifier_chain_unregister(&reboot_notifier_list, nb);
 }
-
 EXPORT_SYMBOL(unregister_reboot_notifier);
 
 
-
 static ATOMIC_NOTIFIER_HEAD(die_chain);
 
 int notify_die(enum die_val val, const char *str,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
stop-using-dma_xxbit_mask.patch
fuse-fix-race-between-getattr-and-write.patch
fuse-add-file-handle-to-getattr-operation.patch
sparse-pointer-use-of-zero-as-null.patch
i-oat-tighten-descriptor-setup-performance.patch
i-oat-add-completion-callback-for-async_tx-interface-use.patch
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
git-net.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd-fixup.patch
git-parisc.patch
fix-build-breakage-if-sysfs-fix.patch
git-scsi-misc.patch
advansys-depends-on-virt_to_bus.patch
git-sparc64.patch
git-unionfs.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-unionfs.patch
git-nfs-vs-git-unionfs.patch
git-watchdog-fixup.patch
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
add-kernel-notifierc-fix.patch
add-kernel-notifierc-fix-2-fix-3.patch
console-events-and-accessibility-fix.patch
procfs-detect-duplicate-names-fix.patch
procfs-detect-duplicate-names-fix-fix-2.patch
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
