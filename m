From: akpm@linux-foundation.org
Subject: + block-remove-kblockd_flush_work.patch added to -mm tree
Date: Tue, 18 Nov 2008 15:33:00 -0800
Message-ID: <200811182333.mAINX0Bl026873@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47461 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751926AbYKRXdG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Nov 2008 18:33:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: crquan@gmail.com, jens.axboe@oracle.com


The patch titled
     block: remove kblockd_flush_work()
has been added to the -mm tree.  Its filename is
     block-remove-kblockd_flush_work.patch

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
@@ -391,7 +391,7 @@ EXPORT_SYMBOL(blk_stop_queue);
 void blk_sync_queue(struct request_queue *q)
 {
 	del_timer_sync(&q->unplug_timer);
-	kblockd_flush_work(&q->unplug_work);
+	cancel_work_sync(&q->unplug_work);
 }
 EXPORT_SYMBOL(blk_sync_queue);
 
@@ -2108,12 +2108,6 @@ int kblockd_schedule_work(struct request
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

block-remove-kblockd_flush_work.patch
fs-block_devc-__read_mostly-improvement-and-sb_is_blkdev_sb-utilization.patch
md-need-another-print_sb-for-mdp_superblock_1.patch

