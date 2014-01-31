From: akpm@linux-foundation.org
Subject: [merged]
 zram-remove-workqueue-for-freeing-removed-pending-slot.patch removed from
 -mm tree
Date: Fri, 31 Jan 2014 11:16:32 -0800
Message-ID: <52ebf690.npzosb9jdeqLUOUE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50634 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932651AbaAaTQc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Jan 2014 14:16:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com, ngupta@vflare.org, jmarchan@redhat.com, minchan@kernel.org

Subject: [merged] zram-remove-workqueue-for-freeing-removed-pending-slot.patch removed from -mm tree
To: minchan@kernel.org,jmarchan@redhat.com,ngupta@vflare.org,sergey.senozhatsky@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 31 Jan 2014 11:16:32 -0800


The patch titled
     Subject: zram: remove workqueue for freeing removed pending slot
has been removed from the -mm tree.  Its filename was
     zram-remove-workqueue-for-freeing-removed-pending-slot.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zram: remove workqueue for freeing removed pending slot

a0c516c ("zram: don't grab mutex in zram_slot_free_noity") introduced free
request pending code to avoid scheduling by mutex under spinlock and it
was a mess which made code lenghty and increased overhead.

Now, we don't need zram->lock any more to free slot so this patch reverts
it and then, tb_lock should protect it.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Tested-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   54 +++-----------------------------
 drivers/block/zram/zram_drv.h |   10 -----
 2 files changed, 6 insertions(+), 58 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-remove-workqueue-for-freeing-removed-pending-slot drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-remove-workqueue-for-freeing-removed-pending-slot
+++ a/drivers/block/zram/zram_drv.c
@@ -522,20 +522,6 @@ out:
 	return ret;
 }
 
-static void handle_pending_slot_free(struct zram *zram)
-{
-	struct zram_slot_free *free_rq;
-
-	spin_lock(&zram->slot_free_lock);
-	while (zram->slot_free_rq) {
-		free_rq = zram->slot_free_rq;
-		zram->slot_free_rq = free_rq->next;
-		zram_free_page(zram, free_rq->index);
-		kfree(free_rq);
-	}
-	spin_unlock(&zram->slot_free_lock);
-}
-
 static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
 			int offset, struct bio *bio, int rw)
 {
@@ -547,7 +533,6 @@ static int zram_bvec_rw(struct zram *zra
 		up_read(&zram->lock);
 	} else {
 		down_write(&zram->lock);
-		handle_pending_slot_free(zram);
 		ret = zram_bvec_write(zram, bvec, index, offset);
 		up_write(&zram->lock);
 	}
@@ -566,8 +551,6 @@ static void zram_reset_device(struct zra
 		return;
 	}
 
-	flush_work(&zram->free_work);
-
 	meta = zram->meta;
 	zram->init_done = 0;
 
@@ -769,40 +752,19 @@ error:
 	bio_io_error(bio);
 }
 
-static void zram_slot_free(struct work_struct *work)
-{
-	struct zram *zram;
-
-	zram = container_of(work, struct zram, free_work);
-	down_write(&zram->lock);
-	handle_pending_slot_free(zram);
-	up_write(&zram->lock);
-}
-
-static void add_slot_free(struct zram *zram, struct zram_slot_free *free_rq)
-{
-	spin_lock(&zram->slot_free_lock);
-	free_rq->next = zram->slot_free_rq;
-	zram->slot_free_rq = free_rq;
-	spin_unlock(&zram->slot_free_lock);
-}
-
 static void zram_slot_free_notify(struct block_device *bdev,
 				unsigned long index)
 {
 	struct zram *zram;
-	struct zram_slot_free *free_rq;
+	struct zram_meta *meta;
 
 	zram = bdev->bd_disk->private_data;
-	atomic64_inc(&zram->stats.notify_free);
-
-	free_rq = kmalloc(sizeof(struct zram_slot_free), GFP_ATOMIC);
-	if (!free_rq)
-		return;
+	meta = zram->meta;
 
-	free_rq->index = index;
-	add_slot_free(zram, free_rq);
-	schedule_work(&zram->free_work);
+	write_lock(&meta->tb_lock);
+	zram_free_page(zram, index);
+	write_unlock(&meta->tb_lock);
+	atomic64_inc(&zram->stats.notify_free);
 }
 
 static const struct block_device_operations zram_devops = {
@@ -849,10 +811,6 @@ static int create_device(struct zram *zr
 	init_rwsem(&zram->lock);
 	init_rwsem(&zram->init_lock);
 
-	INIT_WORK(&zram->free_work, zram_slot_free);
-	spin_lock_init(&zram->slot_free_lock);
-	zram->slot_free_rq = NULL;
-
 	zram->queue = blk_alloc_queue(GFP_KERNEL);
 	if (!zram->queue) {
 		pr_err("Error allocating disk queue for device %d\n",
diff -puN drivers/block/zram/zram_drv.h~zram-remove-workqueue-for-freeing-removed-pending-slot drivers/block/zram/zram_drv.h
--- a/drivers/block/zram/zram_drv.h~zram-remove-workqueue-for-freeing-removed-pending-slot
+++ a/drivers/block/zram/zram_drv.h
@@ -90,20 +90,11 @@ struct zram_meta {
 	struct zs_pool *mem_pool;
 };
 
-struct zram_slot_free {
-	unsigned long index;
-	struct zram_slot_free *next;
-};
-
 struct zram {
 	struct zram_meta *meta;
 	struct rw_semaphore lock; /* protect compression buffers,
 				   * reads and writes
 				   */
-
-	struct work_struct free_work;  /* handle pending free request */
-	struct zram_slot_free *slot_free_rq; /* list head of free request */
