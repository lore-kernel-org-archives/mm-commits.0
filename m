From: akpm@linux-foundation.org
Subject: - git-sched-build-fix.patch removed from -mm tree
Date: Wed, 26 Sep 2007 18:43:45 -0700
Message-ID: <200709270143.l8R1hjdI013989@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46280 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752619AbXI0BvK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 21:51:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     git-sched build fix
has been removed from the -mm tree.  Its filename was
     git-sched-build-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: git-sched build fix
From: Andrew Morton <akpm@linux-foundation.org>

Fix this:

kernel/sched_debug.c: In function `print_cfs_rq':
kernel/sched_debug.c:139: error: structure has no member named `bkl_cnt'
kernel/sched_debug.c:139: error: structure has no member named `bkl_cnt'

and rename `bkl_cnt' to the less yukky `bkl_count'.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    2 +-
 kernel/sched.c        |    6 +++---
 kernel/sched_debug.c  |   10 ++++++----
 3 files changed, 10 insertions(+), 8 deletions(-)

diff -puN kernel/sched.c~git-sched-build-fix kernel/sched.c
--- a/kernel/sched.c~git-sched-build-fix
+++ a/kernel/sched.c
@@ -360,7 +360,7 @@ struct rq {
 	unsigned long ttwu_local;
 
 	/* BKL stats */
-	unsigned long bkl_cnt;
+	unsigned long bkl_count;
 #endif
 	struct lock_class_key rq_lock_key;
 };
@@ -3421,8 +3421,8 @@ static inline void schedule_debug(struct
 	schedstat_inc(this_rq(), sched_cnt);
 #ifdef CONFIG_SCHEDSTATS
 	if (unlikely(prev->lock_depth >= 0)) {
-		schedstat_inc(this_rq(), bkl_cnt);
-		schedstat_inc(prev, sched_info.bkl_cnt);
+		schedstat_inc(this_rq(), bkl_count);
+		schedstat_inc(prev, sched_info.bkl_count);
 	}
 #endif
 }
diff -puN kernel/sched_debug.c~git-sched-build-fix kernel/sched_debug.c
--- a/kernel/sched_debug.c~git-sched-build-fix
+++ a/kernel/sched_debug.c
@@ -136,8 +136,10 @@ void print_cfs_rq(struct seq_file *m, in
 			SPLIT_NS(spread0));
 	SEQ_printf(m, "  .%-30s: %ld\n", "nr_running", cfs_rq->nr_running);
 	SEQ_printf(m, "  .%-30s: %ld\n", "load", cfs_rq->load.weight);
-	SEQ_printf(m, "  .%-30s: %ld\n", "bkl_cnt",
-			rq->bkl_cnt);
+#ifdef CONFIG_SCHEDSTATS
+	SEQ_printf(m, "  .%-30s: %ld\n", "bkl_count",
+			rq->bkl_count);
+#endif
 	SEQ_printf(m, "  .%-30s: %ld\n", "nr_spread_over",
 			cfs_rq->nr_spread_over);
 }
@@ -340,7 +342,7 @@ void proc_sched_show_task(struct task_st
 	PN(se.exec_max);
 	PN(se.slice_max);
 	PN(se.wait_max);
-	P(sched_info.bkl_cnt);
+	P(sched_info.bkl_count);
 #endif
 	SEQ_printf(m, "%-25s:%20Ld\n",
 		   "nr_switches", (long long)(p->nvcsw + p->nivcsw));
@@ -368,7 +370,7 @@ void proc_sched_set_task(struct task_str
 	p->se.exec_max			= 0;
 	p->se.slice_max			= 0;
 	p->se.wait_max			= 0;
-	p->sched_info.bkl_cnt		= 0;
+	p->sched_info.bkl_count		= 0;
 #endif
 	p->se.sum_exec_runtime		= 0;
 	p->se.prev_sum_exec_runtime	= 0;
diff -puN include/linux/sched.h~git-sched-build-fix include/linux/sched.h
--- a/include/linux/sched.h~git-sched-build-fix
+++ a/include/linux/sched.h
@@ -622,7 +622,7 @@ struct sched_info {
 			   last_queued;	/* when we were last queued to run */
 #ifdef CONFIG_SCHEDSTATS
 	/* BKL stats */
-	unsigned long bkl_cnt;
+	unsigned long bkl_count;
 #endif
 };
 #endif /* defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT) */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fix-oops-in-platform-uevent.patch
slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
acpi-add-reboot-mechanism.patch
acpi-suppress-uninitialized-var-warning.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-arm.patch
powerpc-proper-defconfig-for-crosscompiles-fix.patch
git-dvb.patch
git-dvb-fixup-2.patch
git-dvb-build-fix.patch
git-hwmon-fixup.patch
drivers-hid-hid-debugc-add-kern_debug-prefix-fix-typo-constify-fix.patch
git-infiniband.patch
infiniband-work-around-gcc-slub-problem.patch
git-input.patch
git-input-fixup.patch
adbhid-produce-all-capslock-key-events.patch
console-keyboard-events-and-accessibility-fix.patch
console-keyboard-events-and-accessibility-fix-2.patch
first-stab-at-elantech-touchpad-driver-for-26226-testers-fix.patch
git-jg-misc-fix.patch
git-jg-warning-fixes.patch
git-kbuild.patch
git-kbuild-fixup.patch
git-kvm.patch
git-libata-all.patch
ide-arm-hack.patch
git-mips.patch
git-mmc.patch
git-mmc-fixup2.patch
mmc-fix-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct-vs-git-mmc.patch
git-mtd.patch
git-mtd-vs-powerpc.patch
git-net.patch
git-net-fixup.patch
git-net-fix-wireless-kconfig.patch
net-atm-lecc-printk-warning-fix.patch
git-backlight.patch
git-backlight-dependency-fix.patch
revert-git-battery.patch
git-net-vs-git-nfs.patch
git-nfs-vs-git-unionfs.patch
git-nfsd.patch
git-ocfs2.patch
git-r8169-fixup.patch
revert-gregkh-pci-pci_bridge-device.patch
pci-remove-irritating-try-pci=assign-busses-warning.patch
fix-ide-legacy-mode-resources-fix.patch
git-s390.patch
git-scsi-misc.patch
git-scsi-misc-fixup.patch
git-scsi-misc-arcmsr-build-fix.patch
advansys-printk-fix.patch
git-block.patch
git-block-fixup.patch
git-unionfs.patch
git-unionfs-fix-2.patch
fix-gregkh-usb-usb-sisusb2vga-convert-printk-to-dev_-macros.patch
git-wireless.patch
git-wireless-fixup.patch
git-wireless-vs-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
net-add-ath5k-wireless-driver-fix.patch
revert-x86_64-mm-cpa-einval.patch
intel_cacheinfo-misc-section-annotation-fixes.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable-fix.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable-fix.patch
convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64-fix-2.patch
asm-i386-ioh-fix-constness.patch
optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft-fix.patch
x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron-fix.patch
x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-fix.patch
git-xfs.patch
git-kgdb-fixup.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
mm-use-pagevec-to-rotate-reclaimable-page-fix.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
git-nfs-vs-nfs-convert-to-new-aops.patch
git-nfs-vs-nfs-convert-to-new-aops-fix.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix-2.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix-2-3.patch
categorize-gfp-flags-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
hugetlbfs-read-support-fix.patch
mm-mempolicyc-cleanups-fix.patch
mm-bdi-init-hooks.patch
mm-per-device-dirty-threshold-warning-fix.patch
mm-dirty-balancing-for-tasks-warning-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix-2.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-unionfs.patch
oom-change-all_unreclaimable-zone-member-to-flags-fix.patch
oom-do-not-take-callback_mutex-fix.patch
security-convert-lsm-into-a-static-interface-fix.patch
security-convert-lsm-into-a-static-interface-fix-2.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
file-capabilities-clear-caps-cleanup-fix.patch
capabilityh-remove-include-of-currenth.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option-update.patch
uml-clocksource-support-fix.patch
uml-tickless-support-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
softlockup-add-a-proc-tuning-parameter-fix.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91-fix.patch
add-kernel-notifierc-fix.patch
do_sys_poll-simplify-playing-with-on-stack-data-fix.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
add-in-sunos-41x-compatible-mode-for-ufs-fix.patch
core_pattern-fix-up-a-few-miscellaneous-bugs-fix.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix.patch
deprecate-aout-elf-interpreters-fix.patch
ext2-ext3-ext4-add-block-bitmap-validation-fix.patch
pie-executable-randomization-fix-2.patch
i386-and-x86_64-randomize-brk-fix.patch
binfmt_flat-warning-fixes.patch
console-events-and-accessibility-fix.patch
track-accurate-idle-time-with-tick_schedidle_sleeptime-fix.patch
send-quota-messages-via-netlink-fix-fix.patch
i2o-fix-defined-but-not-used-build-warnings-fix.patch
procfs-detect-duplicate-names-fix.patch
procfs-detect-duplicate-names-fix-fix-2.patch
keys-make-request_key-and-co-fundamentally-asynchronous-vs-git-mmc.patch
reiserfs-workaround-for-dead-loop-in-finish_unfinished-fix.patch
tty-expose-new-methods-needed-for-drivers-to-get-termios-fix.patch
kernel-printkc-concerns-about-the-console-handover.patch
userc-ifdef-mq_bytes-fix.patch
jbd-config_jbd_debug-cannot-create-proc-entry-fix.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
revert-faster-ext2_clear_inode.patch
ext2-reservations-fix-for-percpu_counter-changes.patch
ecryptfs-printk-warning-fixes.patch
tdfxfb-mtrr-support-fix.patch
fbdev-fb_create_modedb-non-static-int-first-=-1-fix.patch
intel-fb-support-for-interlaced-video-modes.patch
export-font_vga_8x16.patch
drivers-video-pmag-ba-fbc-improve-diagnostics-fix.patch
md-software-raid-autodetect-dev-list-not-array-fix.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
64-bit-i_version-afs-fixes.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
task-containersv11-basic-task-container-framework-fix.patch
task-containersv11-shared-container-subsystem-group-arrays-include-fix.patch
add-containerstats-v3-fix.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-versus-x86_64-mm-i386-show-unhandled-signals-v3.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-2.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-3.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
memory-controller-memory-accounting-v7-fix.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
remove-bits_to_type-macro-fix.patch
use-helpers-to-obtain-task-pid-in-printks-drm-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
powerpc-lock-bitops-fix.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix-2.patch
use-extended-crashkernel-command-line-on-i386.patch
rework-proc-locks-via-seq_files-and-seq_list-helpers-fix.patch
rework-proc-locks-via-seq_files-and-seq_list-helpers-fix-2.patch
reiser4.patch
git-block-vs-reiser4.patch
git-nfsd-broke-reiser4.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
profile-likely-unlikely-macros-fix.patch
check_dirty_inode_list.patch
w1-build-fix.patch
