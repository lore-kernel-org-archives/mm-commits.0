From: akpm@linux-foundation.org
Subject: - block-remove-kblockd_flush_work.patch removed from -mm tree
Date: Sat, 06 Dec 2008 16:05:34 -0800
Message-ID: <200812070005.mB705YD4021449@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50199 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753486AbYLGAFk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 6 Dec 2008 19:05:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: crquan@gmail.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     block: remove kblockd_flush_work()
has been removed from the -mm tree.  Its filename was
     block-remove-kblockd_flush_work.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: block: remove kblockd_flush_work()
From: Cheng Renquan <crquan@gmail.com>

After many improvements on kblockd_flush_work, it is now identical to
cancel_work_sync, so a direct call to cancel_work_sync is suggested.

The only difference is that cancel_work_sync is a GPL symbol,
so no non-GPL modules anymore.

Signed-off-by: Cheng Renquan <crquan@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/as-iosched.c     |    2 +-
 block/blk-core.c       |    8 +-------
 block/cfq-iosched.c    |    2 +-
 include/linux/blkdev.h |    1 -
 4 files changed, 3 insertions(+), 10 deletions(-)

diff -puN block/as-iosched.c~block-remove-kblockd_flush_work block/as-iosched.c
--- a/block/as-iosched.c~block-remove-kblockd_flush_work
+++ a/block/as-iosched.c
@@ -1344,7 +1344,7 @@ static void as_exit_queue(elevator_t *e)
 	struct as_data *ad = e->elevator_data;
 
 	del_timer_sync(&ad->antic_timer);
-	kblockd_flush_work(&ad->antic_work);
+	cancel_work_sync(&ad->antic_work);
 
 	BUG_ON(!list_empty(&ad->fifo_list[REQ_SYNC]));
 	BUG_ON(!list_empty(&ad->fifo_list[REQ_ASYNC]));
diff -puN block/blk-core.c~block-remove-kblockd_flush_work block/blk-core.c
--- a/block/blk-core.c~block-remove-kblockd_flush_work
+++ a/block/blk-core.c
@@ -400,7 +400,7 @@ void blk_sync_queue(struct request_queue
 {
 	del_timer_sync(&q->unplug_timer);
 	del_timer_sync(&q->timeout);
-	kblockd_flush_work(&q->unplug_work);
+	cancel_work_sync(&q->unplug_work);
 }
 EXPORT_SYMBOL(blk_sync_queue);
 
@@ -2117,12 +2117,6 @@ int kblockd_schedule_work(struct request
 }
 EXPORT_SYMBOL(kblockd_schedule_work);
 
-void kblockd_flush_work(struct work_struct *work)
-{
-	cancel_work_sync(work);
-}
-EXPORT_SYMBOL(kblockd_flush_work);
-
 int __init blk_dev_init(void)
 {
 	kblockd_workqueue = create_workqueue("kblockd");
diff -puN block/cfq-iosched.c~block-remove-kblockd_flush_work block/cfq-iosched.c
--- a/block/cfq-iosched.c~block-remove-kblockd_flush_work
+++ a/block/cfq-iosched.c
@@ -2160,7 +2160,7 @@ out_cont:
 static void cfq_shutdown_timer_wq(struct cfq_data *cfqd)
 {
 	del_timer_sync(&cfqd->idle_slice_timer);
-	kblockd_flush_work(&cfqd->unplug_work);
+	cancel_work_sync(&cfqd->unplug_work);
 }
 
 static void cfq_put_async_queues(struct cfq_data *cfqd)
diff -puN include/linux/blkdev.h~block-remove-kblockd_flush_work include/linux/blkdev.h
--- a/include/linux/blkdev.h~block-remove-kblockd_flush_work
+++ a/include/linux/blkdev.h
@@ -978,7 +978,6 @@ static inline void put_dev_sector(Sector
 
 struct work_struct;
 int kblockd_schedule_work(struct request_queue *q, struct work_struct *work);
-void kblockd_flush_work(struct work_struct *work);
 
 #define MODULE_ALIAS_BLOCKDEV(major,minor) \
 	MODULE_ALIAS("block-major-" __stringify(major) "-" __stringify(minor))
_

Patches currently in -mm which might be from crquan@gmail.com are

origin.patch
linux-next.patch
fs-block_devc-__read_mostly-improvement-and-sb_is_blkdev_sb-utilization.patch

