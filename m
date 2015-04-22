From: akpm@linux-foundation.org
Subject: [to-be-updated]
 zram-factor-out-device-reset-from-reset_store.patch removed from -mm tree
Date: Wed, 22 Apr 2015 13:30:02 -0700
Message-ID: <553804ca.8aqxS/mwi9jQ/p2r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49666 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383AbbDVUaD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Apr 2015 16:30:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, ngupta@vflare.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: factor out device reset from reset_store()
has been removed from the -mm tree.  Its filename was
     zram-factor-out-device-reset-from-reset_store.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: factor out device reset from reset_store()

Device reset currently consists of two steps:
a) holding ->bd_mutex we ensure that there are no device users
(bdev->bd_openers)

b) and internal part (executed under bdev->bd_mutex and partially
under zram->init_lock) that resets the device - frees allocated
memory and returns the device back to its initial (un-init) state.

Dynamic device removal requires the same amount of work and checks.
We can reuse internal cleanup part (b) zram_reset_device(), but step (a)
is done in sysfs ATTR reset_store() handler.

Rename step (b) from zram_reset_device() to zram_reset_device_internal()
and factor out step (a) to zram_reset_device(). Both reset_store() and
dynamic device removal will use zram_reset_device().

For readability let's keep them separated.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |  135 +++++++++++++++-----------------
 1 file changed, 67 insertions(+), 68 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-factor-out-device-reset-from-reset_store drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-factor-out-device-reset-from-reset_store
+++ a/drivers/block/zram/zram_drv.c
@@ -746,48 +746,6 @@ static void zram_bio_discard(struct zram
 	}
 }
 
-static void zram_reset_device(struct zram *zram)
-{
-	struct zram_meta *meta;
-	struct zcomp *comp;
-	u64 disksize;
-
-	down_write(&zram->init_lock);
-
-	zram->limit_pages = 0;
-
-	if (!init_done(zram)) {
-		up_write(&zram->init_lock);
-		return;
-	}
-
-	meta = zram->meta;
-	comp = zram->comp;
-	disksize = zram->disksize;
-	/*
-	 * Refcount will go down to 0 eventually and r/w handler
-	 * cannot handle further I/O so it will bail out by
-	 * check zram_meta_get.
-	 */
-	zram_meta_put(zram);
-	/*
-	 * We want to free zram_meta in process context to avoid
-	 * deadlock between reclaim path and any other locks.
-	 */
-	wait_event(zram->io_done, atomic_read(&zram->refcount) == 0);
-
-	/* Reset stats */
-	memset(&zram->stats, 0, sizeof(zram->stats));
-	zram->disksize = 0;
-	zram->max_comp_streams = 1;
-	set_capacity(zram->disk, 0);
-
-	up_write(&zram->init_lock);
-	/* I/O operation under all of CPU are done so let's free */
-	zram_meta_free(meta, disksize);
-	zcomp_destroy(comp);
-}
-
 static ssize_t disksize_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t len)
 {
@@ -846,16 +804,54 @@ out_free_meta:
 	return err;
 }
 
-static ssize_t reset_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t len)
+/* internal device reset part -- cleanup allocated memory and
+ * return back to initial state */
+static void zram_reset_device_internal(struct zram *zram)
 {
-	int ret;
-	unsigned short do_reset;
-	struct zram *zram;
-	struct block_device *bdev;
+	struct zram_meta *meta;
+	struct zcomp *comp;
+	u64 disksize;
 
-	zram = dev_to_zram(dev);
-	bdev = bdget_disk(zram->disk, 0);
+	down_write(&zram->init_lock);
+
+	zram->limit_pages = 0;
+
+	if (!init_done(zram)) {
+		up_write(&zram->init_lock);
+		return;
+	}
+
+	meta = zram->meta;
+	comp = zram->comp;
+	disksize = zram->disksize;
+	/*
+	 * Refcount will go down to 0 eventually and r/w handler
+	 * cannot handle further I/O so it will bail out by
+	 * check zram_meta_get.
+	 */
+	zram_meta_put(zram);
+	/*
+	 * We want to free zram_meta in process context to avoid
+	 * deadlock between reclaim path and any other locks.
+	 */
+	wait_event(zram->io_done, atomic_read(&zram->refcount) == 0);
+
+	/* Reset stats */
+	memset(&zram->stats, 0, sizeof(zram->stats));
+	zram->disksize = 0;
+	zram->max_comp_streams = 1;
+	set_capacity(zram->disk, 0);
+
+	up_write(&zram->init_lock);
+	/* I/O operation under all of CPU are done so let's free */
+	zram_meta_free(meta, disksize);
+	zcomp_destroy(comp);
+}
+
+static int zram_reset_device(struct zram *zram)
+{
+	int ret = 0;
+	struct block_device *bdev = bdget_disk(zram->disk, 0);
 
 	if (!bdev)
 		return -ENOMEM;
@@ -867,31 +863,34 @@ static ssize_t reset_store(struct device
 		goto out;
 	}
 
-	ret = kstrtou16(buf, 10, &do_reset);
-	if (ret)
-		goto out;
-
-	if (!do_reset) {
-		ret = -EINVAL;
-		goto out;
-	}
-
 	/* Make sure all pending I/O is finished */
 	fsync_bdev(bdev);
-	zram_reset_device(zram);
-
-	mutex_unlock(&bdev->bd_mutex);
-	revalidate_disk(zram->disk);
-	bdput(bdev);
-
-	return len;
-
+	zram_reset_device_internal(zram);
 out:
 	mutex_unlock(&bdev->bd_mutex);
 	bdput(bdev);
 	return ret;
 }
 
+static ssize_t reset_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t len)
+{
+	int ret;
+	unsigned short do_reset;
+	struct zram *zram;
+
+	zram = dev_to_zram(dev);
+	ret = kstrtou16(buf, 10, &do_reset);
+	if (ret)
+		return ret;
+
+	if (!do_reset)
+		return -EINVAL;
+
+	ret = zram_reset_device(zram);
+	return ret ? ret : len;
+}
+
 static void __zram_make_request(struct zram *zram, struct bio *bio)
 {
 	int offset, rw;
@@ -1236,7 +1235,7 @@ static void zram_remove(struct zram *zra
 	sysfs_remove_group(&disk_to_dev(zram->disk)->kobj,
 			&zram_disk_attr_group);
 
-	zram_reset_device(zram);
+	zram_reset_device_internal(zram);
 	idr_remove(&zram_index_idr, zram->disk->first_minor);
 	blk_cleanup_queue(zram->disk->queue);
 	del_gendisk(zram->disk);
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

origin.patch
revert-zram-move-compact_store-to-sysfs-functions-area.patch
zram-reorganize-code-layout.patch
zram-add-dynamic-device-add-remove-functionality.patch
zram-add-dynamic-device-add-remove-functionality-fix.patch
zram-remove-max_num_devices-limitation.patch
zram-report-every-added-and-removed-device.patch
zram-trivial-correct-flag-operations-comment.patch
zram-return-zram-device_id-value-from-zram_add.patch
zram-introduce-automatic-device_id-generation.patch
zram-introduce-automatic-device_id-generation-fix.patch
zram-do-not-let-user-enforce-new-device-dev_id.patch

