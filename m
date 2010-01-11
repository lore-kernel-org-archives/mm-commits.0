From: akpm@linux-foundation.org
Subject: [merged] mmc_block-fix-queue-cleanup.patch removed from -mm tree
Date: Mon, 11 Jan 2010 12:18:41 -0800
Message-ID: <201001112018.o0BKIf4x025506@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33599 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754025Ab0AKUg0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jan 2010 15:36:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adrian.hunter@nokia.com, linux-mmc@vger.kernel.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mmc_block: fix queue cleanup
has been removed from the -mm tree.  Its filename was
     mmc_block-fix-queue-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc_block: fix queue cleanup
From: Adrian Hunter <adrian.hunter@nokia.com>

The main bug was that 'blk_cleanup_queue()' was called while the block
device could still be in use, for example, because the card was removed
while files were still open.

In addition, to be sure that 'mmc_request()' will get called for all new
requests (so it can error them out), the queue is emptied during cleanup. 
This is done after the worker thread is stopped to avoid racing with it.

Finally, it is not a device error for this to be happening, so quiet the
(sometimes very many) error messages.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
Cc: <linux-mmc@vger.kernel.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/card/block.c |    2 ++
 drivers/mmc/card/queue.c |   18 +++++++++---------
 2 files changed, 11 insertions(+), 9 deletions(-)

diff -puN drivers/mmc/card/block.c~mmc_block-fix-queue-cleanup drivers/mmc/card/block.c
--- a/drivers/mmc/card/block.c~mmc_block-fix-queue-cleanup
+++ a/drivers/mmc/card/block.c
@@ -91,6 +91,8 @@ static void mmc_blk_put(struct mmc_blk_d
 		if (!devmaj)
 			devidx = md->disk->first_minor >> MMC_SHIFT;
 
+		blk_cleanup_queue(md->queue.queue);
+
 		__clear_bit(devidx, dev_use);
 
 		put_disk(md->disk);
diff -puN drivers/mmc/card/queue.c~mmc_block-fix-queue-cleanup drivers/mmc/card/queue.c
--- a/drivers/mmc/card/queue.c~mmc_block-fix-queue-cleanup
+++ a/drivers/mmc/card/queue.c
@@ -90,9 +90,10 @@ static void mmc_request(struct request_q
 	struct request *req;
 
 	if (!mq) {
-		printk(KERN_ERR "MMC: killing requests for dead queue\n");
-		while ((req = blk_fetch_request(q)) != NULL)
+		while ((req = blk_fetch_request(q)) != NULL) {
+			req->cmd_flags |= REQ_QUIET;
 			__blk_end_request_all(req, -EIO);
+		}
 		return;
 	}
 
@@ -223,17 +224,18 @@ void mmc_cleanup_queue(struct mmc_queue 
 	struct request_queue *q = mq->queue;
 	unsigned long flags;
 
-	/* Mark that we should start throwing out stragglers */
-	spin_lock_irqsave(q->queue_lock, flags);
-	q->queuedata = NULL;
-	spin_unlock_irqrestore(q->queue_lock, flags);
-
 	/* Make sure the queue isn't suspended, as that will deadlock */
 	mmc_queue_resume(mq);
 
 	/* Then terminate our worker thread */
 	kthread_stop(mq->thread);
 
+	/* Empty the queue */
+	spin_lock_irqsave(q->queue_lock, flags);
+	q->queuedata = NULL;
+	blk_start_queue(q);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+
  	if (mq->bounce_sg)
  		kfree(mq->bounce_sg);
  	mq->bounce_sg = NULL;
@@ -245,8 +247,6 @@ void mmc_cleanup_queue(struct mmc_queue 
 		kfree(mq->bounce_buf);
 	mq->bounce_buf = NULL;
 
-	blk_cleanup_queue(mq->queue);
