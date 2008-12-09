From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Tue, 09 Dec 2008 10:50:51 -0800
Message-ID: <200812091850.mB9Iop5g030417@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33575 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754287AbYLISux (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Dec 2008 13:50:53 -0500
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mB9Iopio024211
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Tue, 9 Dec 2008 10:50:52 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

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
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/ide-io.c |   95 -----------------------------------------
 1 file changed, 95 deletions(-)

diff -puN drivers/ide/ide-io.c~linux-next-git-rejects drivers/ide/ide-io.c
--- a/drivers/ide/ide-io.c~linux-next-git-rejects
+++ a/drivers/ide/ide-io.c
@@ -120,101 +120,6 @@ int ide_end_request (ide_drive_t *drive,
 }
 EXPORT_SYMBOL(ide_end_request);
 
-<<<<<<< HEAD:drivers/ide/ide-io.c
-static void ide_complete_power_step(ide_drive_t *drive, struct request *rq)
-{
-	struct request_pm_state *pm = rq->data;
-
-#ifdef DEBUG_PM
-	printk(KERN_INFO "%s: complete_power_step(step: %d)\n",
-		drive->name, pm->pm_step);
-#endif
-	if (drive->media != ide_disk)
-		return;
-
-	switch (pm->pm_step) {
-	case IDE_PM_FLUSH_CACHE:	/* Suspend step 1 (flush cache) */
-		if (pm->pm_state == PM_EVENT_FREEZE)
-			pm->pm_step = IDE_PM_COMPLETED;
-		else
-			pm->pm_step = IDE_PM_STANDBY;
-		break;
-	case IDE_PM_STANDBY:		/* Suspend step 2 (standby) */
-		pm->pm_step = IDE_PM_COMPLETED;
-		break;
-	case IDE_PM_RESTORE_PIO:	/* Resume step 1 (restore PIO) */
-		pm->pm_step = IDE_PM_IDLE;
-		break;
-	case IDE_PM_IDLE:		/* Resume step 2 (idle)*/
-		pm->pm_step = IDE_PM_RESTORE_DMA;
-		break;
-	}
-}
-
-static ide_startstop_t ide_start_power_step(ide_drive_t *drive, struct request *rq)
-{
-	struct request_pm_state *pm = rq->data;
-	ide_task_t *args = rq->special;
-
-	memset(args, 0, sizeof(*args));
-
-	switch (pm->pm_step) {
-	case IDE_PM_FLUSH_CACHE:	/* Suspend step 1 (flush cache) */
-		if (drive->media != ide_disk)
-			break;
-		/* Not supported? Switch to next step now. */
-		if (ata_id_flush_enabled(drive->id) == 0 ||
-		    (drive->dev_flags & IDE_DFLAG_WCACHE) == 0) {
-			ide_complete_power_step(drive, rq);
-			return ide_stopped;
-		}
-		if (ata_id_flush_ext_enabled(drive->id))
-			args->tf.command = ATA_CMD_FLUSH_EXT;
-		else
-			args->tf.command = ATA_CMD_FLUSH;
-		goto out_do_tf;
-	case IDE_PM_STANDBY:		/* Suspend step 2 (standby) */
-		args->tf.command = ATA_CMD_STANDBYNOW1;
-		goto out_do_tf;
-	case IDE_PM_RESTORE_PIO:	/* Resume step 1 (restore PIO) */
-		ide_set_max_pio(drive);
-		/*
-		 * skip IDE_PM_IDLE for ATAPI devices
-		 */
-		if (drive->media != ide_disk)
-			pm->pm_step = IDE_PM_RESTORE_DMA;
-		else
-			ide_complete_power_step(drive, rq);
-		return ide_stopped;
-	case IDE_PM_IDLE:		/* Resume step 2 (idle) */
-		args->tf.command = ATA_CMD_IDLEIMMEDIATE;
-		goto out_do_tf;
-	case IDE_PM_RESTORE_DMA:	/* Resume step 3 (restore DMA) */
-		/*
-		 * Right now, all we do is call ide_set_dma(drive),
-		 * we could be smarter and check for current xfer_speed
-		 * in struct drive etc...
-		 */
-		if (drive->hwif->dma_ops == NULL)
-			break;
-		/*
-		 * TODO: respect IDE_DFLAG_USING_DMA
-		 */
-		ide_set_dma(drive);
-		break;
-	}
-
-	pm->pm_step = IDE_PM_COMPLETED;
-	return ide_stopped;
-
-out_do_tf:
-	args->tf_flags	 = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
-	args->data_phase = TASKFILE_NO_DATA;
-	return do_rw_taskfile(drive, args);
-}
-
-=======
->>>>>>> FETCH_HEAD:drivers/ide/ide-io.c
 /**
  *	ide_end_dequeued_request	-	complete an IDE I/O
  *	@drive: IDE device for the I/O
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-backing-devc-remove-recently-added-warn_on.patch
revert-percpu-counter-clean-up-percpu_counter_sum_and_set.patch
revert-percpu_counter-new-function-percpu_counter_sum_and_set.patch
ksym_symbol_len-fixes.patch
mm-remove-the-might_sleep-from-lock_page.patch
make-linx-next-apply.patch
linux-next.patch
next-remove-localversion.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
linux-timexh-cleanup-for-userspace.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
pci-uninline-pci_ioremap_bar.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic-checkpatch-fixes.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
mm-write_cache_pages-more-terminate-quickly.patch
swapfile-change-discard-pgoff_t-to-sector_t-fix.patch
fs-truncate-blocks-outside-i_size-after-o_direct-write-error-fix.patch
vmscan-shrink_active_list-reduce-lru_lock-hold-time.patch
init-properly-placing-noinline-keyword.patch
add-pr_prefix-to-pr_xyz-macros-checkpatch-fixes.patch
poll-allow-f_op-poll-to-sleep-take6.patch
binfmtsh-include-listh-fix.patch
max3100-spi-uart-driver-select-serial_core-fix.patch
spi_gpio-driver-cleanups.patch
kprobes-support-probing-module-__exit-function-fix.patch
kprobes-support-probing-module-__exit-function-fix-2.patch
nfs-optimize-attribute-timeouts-for-noac-and-actimeo=0-checkpatch-fixes.patch
nfs-optimize-attribute-timeouts-for-noac-and-actimeo=0-checkpatch-fixes-checkpatch-fixes.patch
rtc-au1000-on-chip-counter0-as-rtc-driver-fix.patch
cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup-checkpatch-fixes.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memcg-avoid-unnecessary-system-wide-oom-killer-fix.patch
edac-struct-device-replace-bus_id-with-dev_name-dev_set_name-checkpatch-fixes.patch
edac-x38-use-the-architectures-readq-function-fix.patch
parport-ieee1284-use-del_timer_sync-in-parport_wait_event-checkpatch-fixes.patch
romfs-romfs_iget-unsigned-ino-=-0-is-always-true-checkpatch-fixes.patch
filesystem-freeze-implement-generic-freeze-feature-fix.patch
ldisc-n_tty-export-all-n_tty-ldisc-methods-fix.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch
linux-next-git-rejects.patch

