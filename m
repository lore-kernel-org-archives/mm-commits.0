From: akpm@linux-foundation.org
Subject: + zram-remove-workqueue-for-freeing-removed-pending-slot.patch
 added to -mm tree
Date: Tue, 14 Jan 2014 17:39:49 -0800
Message-ID: <52d5e6e5.aqh7HD9kevwPitfe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35838 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbaAOBju (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jan 2014 20:39:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com, ngupta@vflare.org, jmarchan@redhat.com, minchan@kernel.org

Subject: + zram-remove-workqueue-for-freeing-removed-pending-slot.patch added to -mm tree
To: minchan@kernel.org,jmarchan@redhat.com,ngupta@vflare.org,sergey.senozhatsky@gmail.com
From: akpm@linux-foundation.org
Date: Tue, 14 Jan 2014 17:39:49 -0800


The patch titled
     Subject: zram: remove workqueue for freeing removed pending slot
has been added to the -mm tree.  Its filename is
     zram-remove-workqueue-for-freeing-removed-pending-slot.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-remove-workqueue-for-freeing-removed-pending-slot.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-remove-workqueue-for-freeing-removed-pending-slot.patch

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
-
 	struct request_queue *queue;
 	struct gendisk *disk;
 	int init_done;
@@ -114,7 +105,6 @@ struct zram {
 	 * we can store in a disk.
 	 */
 	u64 disksize;	/* bytes */
-	spinlock_t slot_free_lock;
 
 	struct zram_stats stats;
 };
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-remove-bug_on-from-mlock_vma_page.patch
mm-hugetlb-use-get_page_foll-in-follow_hugetlb_page.patch
mm-hugetlbfs-move-the-put-get_page-slab-and-hugetlbfs-optimization-in-a-faster-path.patch
mm-thp-optimize-compound_trans_huge.patch
mm-tail-page-refcounting-optimization-for-slab-and-hugetlbfs.patch
mm-hugetlbfs-use-__compound_tail_refcounted-in-__get_page_tail-too.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-hugetlbc-defer-pageheadhuge-symbol-export.patch
memblock-numa-introduce-flags-field-into-memblock.patch
memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions.patch
memblock-make-memblock_set_node-support-different-memblock_type.patch
acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock.patch
acpi-numa-mem_hotplug-mark-all-nodes-the-kernel-resides-un-hotpluggable.patch
memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed.patch
x86-numa-acpi-memory-hotplug-make-movable_node-have-higher-priority.patch
mm-zswapc-change-params-from-hidden-to-ro.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
linux-next.patch
zsmalloc-move-it-under-mm.patch
zram-promote-zram-from-staging.patch
zram-remove-old-private-project-comment.patch
zram-add-copyright.patch
zsmalloc-add-copyright.patch
zram-add-zram-maintainers.patch
zsmalloc-add-maintainers.patch
zram-fix-race-between-reset-and-flushing-pending-work.patch
zram-delay-pending-free-request-in-read-path.patch
zram-remove-unnecessary-free.patch
zram-use-atomic-operation-for-stat.patch
zram-introduce-zram-tb_lock.patch
zram-remove-workqueue-for-freeing-removed-pending-slot.patch
zram-remove-zram-lock-in-read-path-and-change-it-with-mutex.patch
debugging-keep-track-of-page-owners.patch

