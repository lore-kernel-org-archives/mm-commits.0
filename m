From: akpm@linux-foundation.org
Subject: + zram-remove-init_lock-in-zram_make_request.patch added to -mm
 tree
Date: Wed, 04 Feb 2015 14:42:32 -0800
Message-ID: <54d2a058.wIysxAZ3ayLLypHy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47216 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754268AbbBDWmd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Feb 2015 17:42:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, jmarchan@redhat.com, ngupta@vflare.org, opensource.ganesh@gmail.com, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: remove init_lock in zram_make_request
has been added to the -mm tree.  Its filename is
     zram-remove-init_lock-in-zram_make_request.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-remove-init_lock-in-zram_make_request.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-remove-init_lock-in-zram_make_request.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zram: remove init_lock in zram_make_request

Admin could reset zram during I/O operation going on so we have used
zram->init_lock as read-side lock in I/O path to prevent sudden zram meta
freeing.

However, the init_lock is really troublesome.  We can't do call
zram_meta_alloc under init_lock due to lockdep splat because zram_rw_page
is one of the function under reclaim path and hold it as read_lock while
other places in process context hold it as write_lock.  So, we have used
allocation out of the lock to avoid lockdep warn but it's not good for
readability and fainally, I met another lockdep splat between init_lock
and cpu_hotplug from kmem_cache_destroy during working zsmalloc
compaction.  :(

Yes, the ideal is to remove horrible init_lock of zram in rw path.  This
patch removes it in rw path and instead, add atomic refcount for meta
lifetime management and completion to free meta in process context.  It's
important to free meta in process context because some of resource
destruction needs mutex lock, which could be held if we releases the
resource in reclaim context so it's deadlock, again.

As a bonus, we could remove init_done check in rw path because
zram_meta_get will do a role for it, instead.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Ganesh Mahendran <opensource.ganesh@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   76 ++++++++++++++++++++++----------
 drivers/block/zram/zram_drv.h |   20 ++++----
 2 files changed, 64 insertions(+), 32 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-remove-init_lock-in-zram_make_request drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-remove-init_lock-in-zram_make_request
+++ a/drivers/block/zram/zram_drv.c
@@ -53,9 +53,9 @@ static ssize_t name##_show(struct device
 }									\
 static DEVICE_ATTR_RO(name);
 
-static inline int init_done(struct zram *zram)
+static inline bool init_done(struct zram *zram)
 {
-	return zram->meta != NULL;
+	return zram->disksize;
 }
 
 static inline struct zram *dev_to_zram(struct device *dev)
@@ -356,6 +356,18 @@ out_error:
 	return NULL;
 }
 
+static inline bool zram_meta_get(struct zram *zram)
+{
+	if (atomic_inc_not_zero(&zram->refcount))
+		return true;
+	return false;
+}
+
+static inline void zram_meta_put(struct zram *zram)
+{
+	atomic_dec(&zram->refcount);
+}
+
 static void update_position(u32 *index, int *offset, struct bio_vec *bvec)
 {
 	if (*offset + bvec->bv_len >= PAGE_SIZE)
@@ -717,6 +729,10 @@ static void zram_bio_discard(struct zram
 
 static void zram_reset_device(struct zram *zram)
 {
+	struct zram_meta *meta;
+	struct zcomp *comp;
+	u64 disksize;
+
 	down_write(&zram->init_lock);
 
 	zram->limit_pages = 0;
@@ -726,16 +742,31 @@ static void zram_reset_device(struct zra
 		return;
 	}
 
-	zcomp_destroy(zram->comp);
-	zram->max_comp_streams = 1;
-	zram_meta_free(zram->meta, zram->disksize);
-	zram->meta = NULL;
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
 	/* Reset stats */
 	memset(&zram->stats, 0, sizeof(zram->stats));
 	zram->disksize = 0;
+	zram->max_comp_streams = 1;
 	set_capacity(zram->disk, 0);
 
 	up_write(&zram->init_lock);
+	/* I/O operation under all of CPU are done so let's free */
+	zram_meta_free(meta, disksize);
+	zcomp_destroy(comp);
 }
 
 static ssize_t disksize_store(struct device *dev,
@@ -771,6 +802,8 @@ static ssize_t disksize_store(struct dev
 		goto out_destroy_comp;
 	}
 
+	init_waitqueue_head(&zram->io_done);
+	atomic_set(&zram->refcount, 1);
 	zram->meta = meta;
 	zram->comp = comp;
 	zram->disksize = disksize;
@@ -901,23 +934,21 @@ static void zram_make_request(struct req
 {
 	struct zram *zram = queue->queuedata;
 
-	down_read(&zram->init_lock);
-	if (unlikely(!init_done(zram)))
+	if (unlikely(!zram_meta_get(zram)))
 		goto error;
 
 	if (!valid_io_request(zram, bio->bi_iter.bi_sector,
 					bio->bi_iter.bi_size)) {
 		atomic64_inc(&zram->stats.invalid_io);
-		goto error;
+		goto put_zram;
 	}
 
 	__zram_make_request(zram, bio);
-	up_read(&zram->init_lock);
-
+	zram_meta_put(zram);
 	return;
-
+put_zram:
+	zram_meta_put(zram);
 error:
-	up_read(&zram->init_lock);
 	bio_io_error(bio);
 }
 
@@ -939,21 +970,19 @@ static void zram_slot_free_notify(struct
 static int zram_rw_page(struct block_device *bdev, sector_t sector,
 		       struct page *page, int rw)
 {
-	int offset, err;
+	int offset, err = -EIO;
 	u32 index;
 	struct zram *zram;
 	struct bio_vec bv;
 
 	zram = bdev->bd_disk->private_data;
+	if (unlikely(!zram_meta_get(zram)))
+		goto out;
+
 	if (!valid_io_request(zram, sector, PAGE_SIZE)) {
 		atomic64_inc(&zram->stats.invalid_io);
-		return -EINVAL;
-	}
-
-	down_read(&zram->init_lock);
-	if (unlikely(!init_done(zram))) {
-		err = -EIO;
-		goto out_unlock;
+		err = -EINVAL;
+		goto put_zram;
 	}
 
 	index = sector >> SECTORS_PER_PAGE_SHIFT;
@@ -964,8 +993,9 @@ static int zram_rw_page(struct block_dev
 	bv.bv_offset = 0;
 
 	err = zram_bvec_rw(zram, &bv, index, offset, rw);
-out_unlock:
-	up_read(&zram->init_lock);
+put_zram:
+	zram_meta_put(zram);
+out:
 	/*
 	 * If I/O fails, just return error(ie, non-zero) without
 	 * calling page_endio.
diff -puN drivers/block/zram/zram_drv.h~zram-remove-init_lock-in-zram_make_request drivers/block/zram/zram_drv.h
--- a/drivers/block/zram/zram_drv.h~zram-remove-init_lock-in-zram_make_request
+++ a/drivers/block/zram/zram_drv.h
@@ -100,24 +100,26 @@ struct zram_meta {
 
 struct zram {
 	struct zram_meta *meta;
+	struct zcomp *comp;
 	struct request_queue *queue;
 	struct gendisk *disk;
-	struct zcomp *comp;
-
-	/* Prevent concurrent execution of device init, reset and R/W request */
+	/* Prevent concurrent execution of device init */
 	struct rw_semaphore init_lock;
 	/*
-	 * This is the limit on amount of *uncompressed* worth of data
-	 * we can store in a disk.
+	 * the number of pages zram can consume for storing compressed data
 	 */
-	u64 disksize;	/* bytes */
+	unsigned long limit_pages;
 	int max_comp_streams;
+
 	struct zram_stats stats;
+	atomic_t refcount; /* refcount for zram_meta */
+	/* wait all IO under all of cpu are done */
+	wait_queue_head_t io_done;
 	/*
-	 * the number of pages zram can consume for storing compressed data
+	 * This is the limit on amount of *uncompressed* worth of data
+	 * we can store in a disk.
 	 */
-	unsigned long limit_pages;
-
+	u64 disksize;	/* bytes */
 	char compressor[10];
 };
 #endif
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-set-page-pfmemalloc-in-prep_new_page.patch
mm-page_alloc-reduce-number-of-alloc_pages-functions-parameters.patch
mm-reduce-try_to_compact_pages-parameters.patch
mm-microoptimize-zonelist-operations.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated-fix.patch
mm-when-stealing-freepages-also-take-pages-created-by-splitting-buddy-page.patch
mm-always-steal-split-buddies-in-fallback-allocations.patch
mm-more-aggressive-page-stealing-for-unmovable-allocations.patch
vmstat-do-not-use-deferrable-delayed-work-for-vmstat_update.patch
mm-page_isolation-check-pfn-validity-before-access.patch
mm-support-madvisemadv_free.patch
mm-support-madvisemadv_free-fix.patch
x86-add-pmd_-for-thp.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp.patch
sparc-add-pmd_-for-thp-fix.patch
powerpc-add-pmd_-for-thp.patch
arm-add-pmd_mkclean-for-thp.patch
arm64-add-pmd_-for-thp.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch
zram-clean-up-zram_meta_alloc.patch
zram-free-meta-table-in-zram_meta_free.patch
zram-fix-umount-reset_store-mount-race-condition.patch
zram-rework-reset-and-destroy-path.patch
zram-rework-reset-and-destroy-path-fix.patch
zram-rework-reset-and-destroy-path-fix-2.patch
zram-rework-reset-and-destroy-path-fix-2-fix.patch
zram-check-bd_openers-instead-bd_holders.patch
zram-remove-init_lock-in-zram_make_request.patch
mm-zpool-add-name-argument-to-create-zpool.patch
mm-zsmalloc-add-statistics-support.patch

