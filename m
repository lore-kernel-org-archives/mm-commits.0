From: akpm@linux-foundation.org
Subject: + git-block-fixup-2.patch added to -mm tree
Date: Tue, 24 Jul 2007 17:43:22 -0700
Message-ID: <200707250043.l6P0hMka009210@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34844 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758177AbXGYAoF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jul 2007 20:44:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, jens.axboe@oracle.com


The patch titled
     git-block-fixup-2
has been added to the -mm tree.  Its filename is
     git-block-fixup-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-block-fixup-2
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid0.c              |   23 --------------------
 drivers/md/raid1.c              |   33 ------------------------------
 drivers/md/raid10.c             |   33 ------------------------------
 drivers/md/raid5.c              |   33 ------------------------------
 drivers/message/i2o/i2o_block.c |   26 -----------------------
 drivers/scsi/scsi_lib.c         |   19 -----------------
 drivers/scsi/sd.c               |   18 ----------------
 include/scsi/sd.h               |    5 ----
 8 files changed, 190 deletions(-)

diff -puN drivers/md/raid0.c~git-block-fixup-2 drivers/md/raid0.c
--- a/drivers/md/raid0.c~git-block-fixup-2
+++ a/drivers/md/raid0.c
@@ -40,29 +40,6 @@ static void raid0_unplug(struct request_
 	}
 }
 
-<<<<<<< HEAD/drivers/md/raid0.c
-static int raid0_issue_flush(struct request_queue *q, struct gendisk *disk,
-			     sector_t *error_sector)
-{
-	mddev_t *mddev = q->queuedata;
-	raid0_conf_t *conf = mddev_to_conf(mddev);
-	mdk_rdev_t **devlist = conf->strip_zone[0].dev;
-	int i, ret = 0;
-
-	for (i=0; i<mddev->raid_disks && ret == 0; i++) {
-		struct block_device *bdev = devlist[i]->bdev;
-		struct request_queue *r_queue = bdev_get_queue(bdev);
-
-		if (!r_queue->issue_flush_fn)
-			ret = -EOPNOTSUPP;
-		else
-			ret = r_queue->issue_flush_fn(r_queue, bdev->bd_disk, error_sector);
-	}
-	return ret;
-}
-
-=======
->>>>>>> /drivers/md/raid0.c
 static int raid0_congested(void *data, int bits)
 {
 	mddev_t *mddev = data;
diff -puN drivers/md/raid1.c~git-block-fixup-2 drivers/md/raid1.c
--- a/drivers/md/raid1.c~git-block-fixup-2
+++ a/drivers/md/raid1.c
@@ -575,39 +575,6 @@ static void raid1_unplug(struct request_
 	md_wakeup_thread(mddev->thread);
 }
 
-<<<<<<< HEAD/drivers/md/raid1.c
-static int raid1_issue_flush(struct request_queue *q, struct gendisk *disk,
-			     sector_t *error_sector)
-{
-	mddev_t *mddev = q->queuedata;
-	conf_t *conf = mddev_to_conf(mddev);
-	int i, ret = 0;
-
-	rcu_read_lock();
-	for (i=0; i<mddev->raid_disks && ret == 0; i++) {
-		mdk_rdev_t *rdev = rcu_dereference(conf->mirrors[i].rdev);
-		if (rdev && !test_bit(Faulty, &rdev->flags)) {
-			struct block_device *bdev = rdev->bdev;
-			struct request_queue *r_queue = bdev_get_queue(bdev);
-
-			if (!r_queue->issue_flush_fn)
-				ret = -EOPNOTSUPP;
-			else {
-				atomic_inc(&rdev->nr_pending);
-				rcu_read_unlock();
-				ret = r_queue->issue_flush_fn(r_queue, bdev->bd_disk,
-							      error_sector);
-				rdev_dec_pending(rdev, mddev);
-				rcu_read_lock();
-			}
-		}
-	}
-	rcu_read_unlock();
-	return ret;
-}
-
-=======
->>>>>>> /drivers/md/raid1.c
 static int raid1_congested(void *data, int bits)
 {
 	mddev_t *mddev = data;
diff -puN drivers/md/raid10.c~git-block-fixup-2 drivers/md/raid10.c
--- a/drivers/md/raid10.c~git-block-fixup-2
+++ a/drivers/md/raid10.c
@@ -618,39 +618,6 @@ static void raid10_unplug(struct request
 	md_wakeup_thread(mddev->thread);
 }
 
-<<<<<<< HEAD/drivers/md/raid10.c
-static int raid10_issue_flush(struct request_queue *q, struct gendisk *disk,
-			     sector_t *error_sector)
-{
-	mddev_t *mddev = q->queuedata;
-	conf_t *conf = mddev_to_conf(mddev);
-	int i, ret = 0;
-
-	rcu_read_lock();
-	for (i=0; i<mddev->raid_disks && ret == 0; i++) {
-		mdk_rdev_t *rdev = rcu_dereference(conf->mirrors[i].rdev);
-		if (rdev && !test_bit(Faulty, &rdev->flags)) {
-			struct block_device *bdev = rdev->bdev;
-			struct request_queue *r_queue = bdev_get_queue(bdev);
-
-			if (!r_queue->issue_flush_fn)
-				ret = -EOPNOTSUPP;
-			else {
-				atomic_inc(&rdev->nr_pending);
-				rcu_read_unlock();
-				ret = r_queue->issue_flush_fn(r_queue, bdev->bd_disk,
-							      error_sector);
-				rdev_dec_pending(rdev, mddev);
-				rcu_read_lock();
-			}
-		}
-	}
-	rcu_read_unlock();
-	return ret;
-}
-
-=======
->>>>>>> /drivers/md/raid10.c
 static int raid10_congested(void *data, int bits)
 {
 	mddev_t *mddev = data;
diff -puN drivers/md/raid5.c~git-block-fixup-2 drivers/md/raid5.c
--- a/drivers/md/raid5.c~git-block-fixup-2
+++ a/drivers/md/raid5.c
@@ -3768,39 +3768,6 @@ static void raid5_unplug_device(struct r
 	unplug_slaves(mddev);
 }
 
-<<<<<<< HEAD/drivers/md/raid5.c
-static int raid5_issue_flush(struct request_queue *q, struct gendisk *disk,
-			     sector_t *error_sector)
-{
-	mddev_t *mddev = q->queuedata;
-	raid5_conf_t *conf = mddev_to_conf(mddev);
-	int i, ret = 0;
-
-	rcu_read_lock();
-	for (i=0; i<mddev->raid_disks && ret == 0; i++) {
-		mdk_rdev_t *rdev = rcu_dereference(conf->disks[i].rdev);
-		if (rdev && !test_bit(Faulty, &rdev->flags)) {
-			struct block_device *bdev = rdev->bdev;
-			struct request_queue *r_queue = bdev_get_queue(bdev);
-
-			if (!r_queue->issue_flush_fn)
-				ret = -EOPNOTSUPP;
-			else {
-				atomic_inc(&rdev->nr_pending);
-				rcu_read_unlock();
-				ret = r_queue->issue_flush_fn(r_queue, bdev->bd_disk,
-							      error_sector);
-				rdev_dec_pending(rdev, mddev);
-				rcu_read_lock();
-			}
-		}
-	}
-	rcu_read_unlock();
-	return ret;
-}
-
-=======
->>>>>>> /drivers/md/raid5.c
 static int raid5_congested(void *data, int bits)
 {
 	mddev_t *mddev = data;
diff -puN drivers/message/i2o/i2o_block.c~git-block-fixup-2 drivers/message/i2o/i2o_block.c
--- a/drivers/message/i2o/i2o_block.c~git-block-fixup-2
+++ a/drivers/message/i2o/i2o_block.c
@@ -149,32 +149,6 @@ static int i2o_block_device_flush(struct
 };
 
 /**
-<<<<<<< HEAD/drivers/message/i2o/i2o_block.c
- *	i2o_block_issue_flush - device-flush interface for block-layer
- *	@queue: the request queue of the device which should be flushed
- *	@disk: gendisk
- *	@error_sector: error offset
- *
- *	Helper function to provide flush functionality to block-layer.
- *
- *	Returns 0 on success or negative error code on failure.
- */
-
-static int i2o_block_issue_flush(struct request_queue * queue, struct gendisk *disk,
-				 sector_t * error_sector)
-{
-	struct i2o_block_device *i2o_blk_dev = queue->queuedata;
-	int rc = -ENODEV;
-
-	if (likely(i2o_blk_dev))
-		rc = i2o_block_device_flush(i2o_blk_dev->i2o_dev);
-
-	return rc;
-}
-
-/**
-=======
->>>>>>> /drivers/message/i2o/i2o_block.c
  *	i2o_block_device_mount - Mount (load) the media of device dev
  *	@dev: I2O device which should receive the mount request
  *	@media_id: Media Identifier
diff -puN drivers/scsi/scsi_lib.c~git-block-fixup-2 drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c~git-block-fixup-2
+++ a/drivers/scsi/scsi_lib.c
@@ -1143,25 +1143,6 @@ static int scsi_init_io(struct scsi_cmnd
 	return BLKPREP_KILL;
 }
 
-<<<<<<< HEAD/drivers/scsi/scsi_lib.c
-static int scsi_issue_flush_fn(struct request_queue *q, struct gendisk *disk,
-			       sector_t *error_sector)
-{
-	struct scsi_device *sdev = q->queuedata;
-	struct scsi_driver *drv;
-
-	if (sdev->sdev_state != SDEV_RUNNING)
-		return -ENXIO;
-
-	drv = *(struct scsi_driver **) disk->private_data;
-	if (drv->issue_flush)
-		return drv->issue_flush(&sdev->sdev_gendev, error_sector);
-
-	return -EOPNOTSUPP;
-}
-
-=======
->>>>>>> /drivers/scsi/scsi_lib.c
 static struct scsi_cmnd *scsi_get_cmd_from_req(struct scsi_device *sdev,
 		struct request *req)
 {
diff -puN drivers/scsi/sd.c~git-block-fixup-2 drivers/scsi/sd.c
--- a/drivers/scsi/sd.c~git-block-fixup-2
+++ a/drivers/scsi/sd.c
@@ -799,25 +799,7 @@ static int sd_sync_cache(struct scsi_dis
 	return 0;
 }
 
-<<<<<<< HEAD/drivers/scsi/sd.c
-static int sd_issue_flush(struct device *dev, sector_t *error_sector)
-{
-	int ret = 0;
-	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
-
-	if (!sdkp)
-               return -ENODEV;
-
-	if (sdkp->WCE)
-		ret = sd_sync_cache(sdkp);
-	scsi_disk_put(sdkp);
-	return ret;
-}
-
 static void sd_prepare_flush(struct request_queue *q, struct request *rq)
-=======
-static void sd_prepare_flush(request_queue_t *q, struct request *rq)
->>>>>>> /drivers/scsi/sd.c
 {
 	memset(rq->cmd, 0, sizeof(rq->cmd));
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
diff -puN include/scsi/sd.h~git-block-fixup-2 include/scsi/sd.h
--- a/include/scsi/sd.h~git-block-fixup-2
+++ a/include/scsi/sd.h
@@ -56,12 +56,7 @@ static int sd_suspend(struct device *dev
 static int sd_resume(struct device *dev);
 static void sd_rescan(struct device *);
 static int  sd_init_command(struct scsi_cmnd *);
-<<<<<<< HEAD/include/scsi/sd.h
-static int  sd_issue_flush(struct device *, sector_t *);
 static void sd_prepare_flush(struct request_queue *, struct request *);
-=======
-static void sd_prepare_flush(request_queue_t *, struct request *);
->>>>>>> /include/scsi/sd.h
 static void sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer);
 static void scsi_disk_release(struct class_device *cdev);
 static void sd_print_sense_hdr(struct scsi_disk *, struct scsi_sense_hdr *);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
rtc-stk17ta8-update-for-sysfs-api-change.patch
x86_powernow_k8_acpi-must-depend-on-acpi.patch
revert-x86-serial-convert-legacy-com-ports-to-platform-devices.patch
slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
git-acpi.patch
acpi-add-reboot-mechanism-fix.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
revert-gregkh-driver-block-device.patch
adbhid-produce-all-capslock-key-events-fix.patch
m68k-mac-make-mac_hid_mouse_emulate_buttons.patch
git-kvm.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix.patch
fix-ide-ide-add-ide-set-pio-take3.patch
mmc-build-fix.patch
git-mtd.patch
git-mtd-fix-printk-warning-in-jffs2_block_check_erase.patch
mtdoops-printk-warning-fixes.patch
e1000new-build-fix.patch
e1000new-build-fix-2.patch
ip_auto_config-fix-fix.patch
git-ocfs2.patch
serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr-fix.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix.patch
revert-gregkh-pci-pci_bridge-device.patch
i386-add-support-for-picopower-irq-router.patch
try-parent-numa_node-at-first-before-using-default-v2-fix.patch
pci-remove-irritating-try-pci=assign-busses-warning.patch
aacraid-rename-check_reset.patch
git-scsi-rc-fixes.patch
git-scsi-target-fixup.patch
git-block-fixup.patch
git-block-fixup-2.patch
more-request_queue_t-removal.patch
git-unionfs.patch
git-watchdog.patch
x86_64-clean-up-apicid_to_node-declaration.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
mmconfig-validate-against-acpi-motherboard-resources.patch
git-newsetup-fixup.patch
git-kgdb-fixup.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
hugetlbfs-read-support-fix.patch
security-convert-lsm-into-a-static-interface-fix.patch
security-convert-lsm-into-a-static-interface-fix-2.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
file-capabilities-clear-caps-cleanup-fix.patch
capabilityh-remove-include-of-currenth.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
softlockup-add-a-proc-tuning-parameter-fix.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91-fix.patch
add-kernel-notifierc-fix.patch
fs-9p-convc-error-path-fix.patch
loop-use-unlocked_ioctl.patch
do_sys_poll-simplify-playing-with-on-stack-data-fix.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
revert-faster-ext2_clear_inode.patch
ecryptfs-printk-warning-fixes.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
64-bit-i_version-afs-fixes.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
add-containerstats-v3-fix.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
reiser4.patch
git-block-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
check_dirty_inode_list.patch
alloc_pages-debug.patch
w1-build-fix.patch
