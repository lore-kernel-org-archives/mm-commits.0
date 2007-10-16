From: akpm@linux-foundation.org
Subject: - pnp-add-debug-message-for-adding-new-device-fix-fix.patch removed from -mm tree
Date: Tue, 16 Oct 2007 16:06:32 -0700
Message-ID: <200710162306.l9GN6WIJ022448@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51377 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933553AbXJPXGf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 19:06:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bjorn.helgaas@hp.com, mm-commits@vger.kernel.org


The patch titled
     pnp-add-debug-message-for-adding-new-device-fix-fix
has been removed from the -mm tree.  Its filename was
     pnp-add-debug-message-for-adding-new-device-fix-fix.patch

This patch was dropped because it was folded into pnp-add-debug-message-for-adding-new-device.patch

------------------------------------------------------
Subject: pnp-add-debug-message-for-adding-new-device-fix-fix
From: Andrew Morton <akpm@linux-foundation.org>

nicer?

Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/core.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff -puN drivers/pnp/core.c~pnp-add-debug-message-for-adding-new-device-fix-fix drivers/pnp/core.c
--- a/drivers/pnp/core.c~pnp-add-debug-message-for-adding-new-device-fix-fix
+++ a/drivers/pnp/core.c
@@ -141,9 +141,6 @@ int __pnp_add_device(struct pnp_dev *dev
 int pnp_add_device(struct pnp_dev *dev)
 {
 	int ret;
-#ifdef CONFIG_PNP_DEBUG
-	struct pnp_id *id;
-#endif
 
 	if (dev->card)
 		return -EINVAL;
@@ -156,11 +153,15 @@ int pnp_add_device(struct pnp_dev *dev)
 		return ret;
 
 #ifdef CONFIG_PNP_DEBUG
-	dev_printk(KERN_DEBUG, &dev->dev, "%s device, IDs",
-		dev->protocol->name);
-	for (id = dev->id; id; id = id->next)
-		printk(" %s", id->id);
-	printk(" (%s)\n", dev->active ? "active" : "disabled");
+	{
+		struct pnp_id *id;
+
+		dev_printk(KERN_DEBUG, &dev->dev, "%s device, IDs",
+			dev->protocol->name);
+		for (id = dev->id; id; id = id->next)
+			printk(" %s", id->id);
+		printk(" (%s)\n", dev->active ? "active" : "disabled");
+	}
 #endif
 	return 0;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-bdi-init-hooks.patch
mm-per-device-dirty-threshold.patch
mm-dirty-balancing-for-tasks.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters.patch
oom-change-all_unreclaimable-zone-member-to-flags.patch
oom-do-not-take-callback_mutex.patch
writeback-dont-propagate-aop_writepage_activate.patch
softlockup-add-a-proc-tuning-parameter.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91.patch
do_sys_poll-simplify-playing-with-on-stack-data.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
add-in-sunos-41x-compatible-mode-for-ufs.patch
core_pattern-fix-up-a-few-miscellaneous-bugs.patch
printk-add-interfaces-for-external-access-to-the-log-buffer.patch
deprecate-aout-elf-interpreters.patch
ext2-ext3-ext4-add-block-bitmap-validation.patch
pie-executable-randomization.patch
binfmt_flat-warning-fixes.patch
i2o-fix-defined-but-not-used-build-warnings.patch
reiserfs-workaround-for-dead-loop-in-finish_unfinished.patch
tty-expose-new-methods-needed-for-drivers-to-get-termios-right.patch
userc-ifdef-mq_bytes.patch
ext3-lighten-up-resize-transaction-requirements.patch
drivers-char-ip2-fix-used-uninitd-bug.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
writeback-fix-time-ordering-of-the-per-superblock-inode-lists-8.patch
md-software-raid-autodetect-dev-list-not-array.patch
pnp-use-dev_info-dev_err-etc-in-core.patch
pnp-add-debug-message-for-adding-new-device.patch
pnp-add-debug-message-for-adding-new-device-fix-fix.patch
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
lockdep-fix-mismatched-lockdep_depth-curr_chain_hash-checkpatch-fixes.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-2.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-3.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
cpuset-sched_load_balance-flag-fix.patch
cpusets-decrustify-cpuset-mask-update-code-checkpatch-fixes.patch
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
reiser4.patch
git-block-vs-reiser4.patch
git-nfsd-broke-reiser4.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
profile-likely-unlikely-macros-fix.patch
getblk-handle-2tb-devices.patch
w1-build-fix.patch
