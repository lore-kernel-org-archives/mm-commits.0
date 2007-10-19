From: akpm@linux-foundation.org
Subject: - stop-using-dma_xxbit_mask.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:41:41 -0700
Message-ID: <200710190341.l9J3fffL012840@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43090 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764072AbXJSDzY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:55:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jeremy@goop.org, mm-commits@vger.kernel.org


The patch titled
     stop using DMA_xxBIT_MASK
has been removed from the -mm tree.  Its filename was
     stop-using-dma_xxbit_mask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: stop using DMA_xxBIT_MASK
From: Andrew Morton <akpm@linux-foundation.org>

Now that we have DMA_BIT_MASK(), these macros are pointless.

Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/dma-mapping.h |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN include/linux/dma-mapping.h~stop-using-dma_xxbit_mask include/linux/dma-mapping.h
--- a/include/linux/dma-mapping.h~stop-using-dma_xxbit_mask
+++ a/include/linux/dma-mapping.h
@@ -13,9 +13,15 @@ enum dma_data_direction {
 	DMA_NONE = 3,
 };
 
-#define DMA_BIT_MASK(n)	((1ULL<<(n))-1)
+#define DMA_BIT_MASK(n)	(((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))
 
-#define DMA_64BIT_MASK	(~0ULL)
+/*
+ * NOTE: do not use the below macros in new code and do not add new definitions
+ * here.
+ *
+ * Instead, just open-code DMA_BIT_MASK(n) within your driver
+ */
+#define DMA_64BIT_MASK	DMA_BIT_MASK(64)
 #define DMA_48BIT_MASK	DMA_BIT_MASK(48)
 #define DMA_47BIT_MASK	DMA_BIT_MASK(47)
 #define DMA_40BIT_MASK	DMA_BIT_MASK(40)
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
revert-x86_64-mm-cpa-einval.patch
fix-x86_64-mm-sched-clock-share.patch
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
