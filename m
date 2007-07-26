From: akpm@linux-foundation.org
Subject: - git-block-fixup.patch removed from -mm tree
Date: Wed, 25 Jul 2007 21:02:37 -0700
Message-ID: <200707260402.l6Q42bW9012923@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53485 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750814AbXGZECt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 00:02:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     git-block-fixup
has been removed from the -mm tree.  Its filename was
     git-block-fixup.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: git-block-fixup
From: Andrew Morton <akpm@linux-foundation.org>

Fix rejects in git-block

Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/ll_rw_blk.c      |   36 +-----------------------------------
 drivers/ide/ide-disk.c |   29 -----------------------------
 drivers/md/dm-table.c  |   30 ------------------------------
 drivers/md/dm.c        |   19 -------------------
 drivers/md/linear.c    |   22 ----------------------
 drivers/md/multipath.c |   32 --------------------------------
 include/linux/blkdev.h |   17 ++---------------
 7 files changed, 3 insertions(+), 182 deletions(-)

diff -puN block/ll_rw_blk.c~git-block-fixup block/ll_rw_blk.c
--- a/block/ll_rw_blk.c~git-block-fixup
+++ a/block/ll_rw_blk.c
@@ -302,26 +302,6 @@ int blk_queue_ordered(struct request_que
 
 EXPORT_SYMBOL(blk_queue_ordered);
 
-<<<<<<< HEAD/block/ll_rw_blk.c
-/**
- * blk_queue_issue_flush_fn - set function for issuing a flush
- * @q:     the request queue
- * @iff:   the function to be called issuing the flush
- *
- * Description:
- *   If a driver supports issuing a flush command, the support is notified
- *   to the block layer by defining it through this call.
- *
- **/
-void blk_queue_issue_flush_fn(struct request_queue *q, issue_flush_fn *iff)
-{
-	q->issue_flush_fn = iff;
-}
-
-EXPORT_SYMBOL(blk_queue_issue_flush_fn);
-
-=======
->>>>>>> /block/ll_rw_blk.c
 /*
  * Cache flushing for ordered writes handling
  */
@@ -1331,13 +1311,8 @@ static int blk_hw_contig_segment(struct 
  * map a request to scatterlist, return number of sg entries setup. Caller
  * must make sure sg can hold rq->nr_phys_segments entries
  */
-<<<<<<< HEAD/block/ll_rw_blk.c
 int blk_rq_map_sg(struct request_queue *q, struct request *rq,
-		  struct scatterlist *sg)
-=======
-int blk_rq_map_sg(request_queue_t *q, struct request *rq,
 		  struct scatterlist *sglist)
->>>>>>> /block/ll_rw_blk.c
 {
 	struct bio_vec *bvec, *bvprv;
 	struct scatterlist *next_sg, *sg;
@@ -2692,14 +2667,10 @@ static int bio_end_empty_barrier(struct 
  */
 int blkdev_issue_flush(struct block_device *bdev, sector_t *error_sector)
 {
-<<<<<<< HEAD/block/ll_rw_blk.c
-	struct request_queue *q;
-=======
 	DECLARE_COMPLETION_ONSTACK(wait);
-	request_queue_t *q;
+	struct request_queue *q;
 	struct bio *bio;
 	int ret;
->>>>>>> /block/ll_rw_blk.c
 
 	if (bdev->bd_disk == NULL)
 		return -ENXIO;
@@ -3223,12 +3194,7 @@ static inline int bio_check_eod(struct b
  */
 static inline void __generic_make_request(struct bio *bio)
 {
-<<<<<<< HEAD/block/ll_rw_blk.c
 	struct request_queue *q;
-	sector_t maxsector;
-=======
-	request_queue_t *q;
->>>>>>> /block/ll_rw_blk.c
 	sector_t old_sector;
 	int ret, nr_sectors = bio_sectors(bio);
 	dev_t old_dev;
diff -puN drivers/ide/ide-disk.c~git-block-fixup drivers/ide/ide-disk.c
--- a/drivers/ide/ide-disk.c~git-block-fixup
+++ a/drivers/ide/ide-disk.c
@@ -697,35 +697,6 @@ static void idedisk_prepare_flush(struct
 	rq->buffer = rq->cmd;
 }
 
-<<<<<<< HEAD/drivers/ide/ide-disk.c
-static int idedisk_issue_flush(struct request_queue *q, struct gendisk *disk,
-			       sector_t *error_sector)
-{
-	ide_drive_t *drive = q->queuedata;
-	struct request *rq;
-	int ret;
-
-	if (!drive->wcache)
-		return 0;
-
-	rq = blk_get_request(q, WRITE, __GFP_WAIT);
-
-	idedisk_prepare_flush(q, rq);
-
-	ret = blk_execute_rq(q, disk, rq, 0);
-
-	/*
-	 * if we failed and caller wants error offset, get it
-	 */
-	if (ret && error_sector)
-		*error_sector = ide_get_error_location(drive, rq->cmd);
-
-	blk_put_request(rq);
-	return ret;
-}
-
-=======
->>>>>>> /drivers/ide/ide-disk.c
 /*
  * This is tightly woven into the driver->do_special can not touch.
  * DON'T do it again until a total personality rewrite is committed.
diff -puN drivers/md/dm-table.c~git-block-fixup drivers/md/dm-table.c
--- a/drivers/md/dm-table.c~git-block-fixup
+++ a/drivers/md/dm-table.c
@@ -999,36 +999,6 @@ void dm_table_unplug_all(struct dm_table
 	}
 }
 
-<<<<<<< HEAD/drivers/md/dm-table.c
-int dm_table_flush_all(struct dm_table *t)
-{
-	struct list_head *d, *devices = dm_table_get_devices(t);
-	int ret = 0;
-	unsigned i;
-
-	for (i = 0; i < t->num_targets; i++)
-		if (t->targets[i].type->flush)
-			t->targets[i].type->flush(&t->targets[i]);
-
-	for (d = devices->next; d != devices; d = d->next) {
-		struct dm_dev *dd = list_entry(d, struct dm_dev, list);
-		struct request_queue *q = bdev_get_queue(dd->bdev);
-		int err;
-
-		if (!q->issue_flush_fn)
-			err = -EOPNOTSUPP;
-		else
-			err = q->issue_flush_fn(q, dd->bdev->bd_disk, NULL);
-
-		if (!ret)
-			ret = err;
-	}
-
-	return ret;
-}
-
-=======
->>>>>>> /drivers/md/dm-table.c
 struct mapped_device *dm_table_get_md(struct dm_table *t)
 {
 	dm_get(t->md);
diff -puN drivers/md/dm.c~git-block-fixup drivers/md/dm.c
--- a/drivers/md/dm.c~git-block-fixup
+++ a/drivers/md/dm.c
@@ -850,26 +850,7 @@ static int dm_request(struct request_que
 	return 0;
 }
 
-<<<<<<< HEAD/drivers/md/dm.c
-static int dm_flush_all(struct request_queue *q, struct gendisk *disk,
-			sector_t *error_sector)
-{
-	struct mapped_device *md = q->queuedata;
-	struct dm_table *map = dm_get_table(md);
-	int ret = -ENXIO;
-
-	if (map) {
-		ret = dm_table_flush_all(map);
-		dm_table_put(map);
-	}
-
-	return ret;
-}
-
 static void dm_unplug_all(struct request_queue *q)
-=======
-static void dm_unplug_all(request_queue_t *q)
->>>>>>> /drivers/md/dm.c
 {
 	struct mapped_device *md = q->queuedata;
 	struct dm_table *map = dm_get_table(md);
diff -puN drivers/md/linear.c~git-block-fixup drivers/md/linear.c
--- a/drivers/md/linear.c~git-block-fixup
+++ a/drivers/md/linear.c
@@ -92,28 +92,6 @@ static void linear_unplug(struct request
 	}
 }
 
-<<<<<<< HEAD/drivers/md/linear.c
-static int linear_issue_flush(struct request_queue *q, struct gendisk *disk,
-			      sector_t *error_sector)
-{
-	mddev_t *mddev = q->queuedata;
-	linear_conf_t *conf = mddev_to_conf(mddev);
-	int i, ret = 0;
-
-	for (i=0; i < mddev->raid_disks && ret == 0; i++) {
-		struct block_device *bdev = conf->disks[i].rdev->bdev;
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
->>>>>>> /drivers/md/linear.c
 static int linear_congested(void *data, int bits)
 {
 	mddev_t *mddev = data;
diff -puN drivers/md/multipath.c~git-block-fixup drivers/md/multipath.c
--- a/drivers/md/multipath.c~git-block-fixup
+++ a/drivers/md/multipath.c
@@ -199,38 +199,6 @@ static void multipath_status (struct seq
 	seq_printf (seq, "]");
 }
 
-<<<<<<< HEAD/drivers/md/multipath.c
-static int multipath_issue_flush(struct request_queue *q, struct gendisk *disk,
-				 sector_t *error_sector)
-{
-	mddev_t *mddev = q->queuedata;
-	multipath_conf_t *conf = mddev_to_conf(mddev);
-	int i, ret = 0;
-
-	rcu_read_lock();
-	for (i=0; i<mddev->raid_disks && ret == 0; i++) {
-		mdk_rdev_t *rdev = rcu_dereference(conf->multipaths[i].rdev);
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
-=======
->>>>>>> /drivers/md/multipath.c
 static int multipath_congested(void *data, int bits)
 {
 	mddev_t *mddev = data;
diff -puN include/linux/blkdev.h~git-block-fixup include/linux/blkdev.h
--- a/include/linux/blkdev.h~git-block-fixup
+++ a/include/linux/blkdev.h
@@ -343,14 +343,8 @@ typedef int (prep_rq_fn) (struct request
 typedef void (unplug_fn) (struct request_queue *);
 
 struct bio_vec;
-<<<<<<< HEAD/include/linux/blkdev.h
-typedef int (merge_bvec_fn) (struct request_queue *, struct bio *, struct bio_vec *);
-typedef int (issue_flush_fn) (struct request_queue *, struct gendisk *, sector_t *);
-typedef void (prepare_flush_fn) (struct request_queue *, struct request *);
-=======
-typedef int (merge_bvec_fn) (request_queue_t *, struct bio *, struct bio_vec *);
-typedef void (prepare_flush_fn) (request_queue_t *, struct request *);
->>>>>>> /include/linux/blkdev.h
+typedef int (merge_bvec_fn)(struct request_queue *, struct bio *, struct bio_vec *);
+typedef void (prepare_flush_fn)(struct request_queue *, struct request *);
 typedef void (softirq_done_fn)(struct request *);
 
 enum blk_queue_state {
@@ -774,16 +768,9 @@ extern void blk_queue_merge_bvec(struct 
 extern void blk_queue_dma_alignment(struct request_queue *, int);
 extern void blk_queue_softirq_done(struct request_queue *, softirq_done_fn *);
 extern struct backing_dev_info *blk_get_backing_dev_info(struct block_device *bdev);
-<<<<<<< HEAD/include/linux/blkdev.h
 extern int blk_queue_ordered(struct request_queue *, unsigned, prepare_flush_fn *);
-extern void blk_queue_issue_flush_fn(struct request_queue *, issue_flush_fn *);
 extern int blk_do_ordered(struct request_queue *, struct request **);
 extern unsigned blk_ordered_cur_seq(struct request_queue *);
-=======
-extern int blk_queue_ordered(request_queue_t *, unsigned, prepare_flush_fn *);
-extern int blk_do_ordered(request_queue_t *, struct request **);
-extern unsigned blk_ordered_cur_seq(request_queue_t *);
->>>>>>> /include/linux/blkdev.h
 extern unsigned blk_ordered_req_seq(struct request *);
 extern void blk_ordered_complete_seq(struct request_queue *, unsigned, int);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
rtc-stk17ta8-update-for-sysfs-api-change.patch
x86_powernow_k8_acpi-must-depend-on-acpi.patch
revert-x86-serial-convert-legacy-com-ports-to-platform-devices.patch
ufs-printk-warning-fix.patch
i2c-ds1682-warning-fix.patch
edac-is-bust-on-mips.patch
kdebugh-forward-declare-struct-struct-notifier_block.patch
slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
git-acpi.patch
acpi-add-reboot-mechanism-fix.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
revert-gregkh-driver-block-device.patch
dma-arch-fix.patch
adbhid-produce-all-capslock-key-events-fix.patch
m68k-mac-make-mac_hid_mouse_emulate_buttons.patch
iforce-warning-fix.patch
git-kvm.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix.patch
fix-ide-ide-add-ide-set-pio-take3.patch
ide-bodge-things-around-to-make-arm-work.patch
mmc-build-fix.patch
git-mtd.patch
git-mtd-fix-printk-warning-in-jffs2_block_check_erase.patch
mtdoops-printk-warning-fixes.patch
ax88796-printk-fixes.patch
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
git-block-fix-headers_check.patch
git-block-whoops.patch
git-unionfs.patch
merge-the-sonics-silicon-backplane-subsystem-fix.patch
git-watchdog.patch
revert-x86_64-mm-pci-mmconfig-eax.patch
fix-x86_64-mm-early-quirks-unification.patch
x86_64-clean-up-apicid_to_node-declaration.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
mmconfig-validate-against-acpi-motherboard-resources.patch
git-kgdb-fixup.patch
git-kgdb-arm-fix.patch
git-kgdb-mips-fix.patch
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
use-list_head-in-binfmt-handling-fix.patch
softlockup-add-a-proc-tuning-parameter-fix.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91-fix.patch
add-kernel-notifierc-fix.patch
fs-9p-convc-error-path-fix.patch
loop-use-unlocked_ioctl.patch
do_sys_poll-simplify-playing-with-on-stack-data-fix.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-sparc64-fix.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2-fix.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2-sparc64-fix.patch
ip2main-warning-fix.patch
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
tpm_tis-debug.patch
