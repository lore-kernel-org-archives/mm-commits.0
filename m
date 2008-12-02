From: akpm@linux-foundation.org
Subject: + block-internal-dequeue-shouldnt-start-timer.patch added to -mm tree
Date: Tue, 02 Dec 2008 12:32:29 -0800
Message-ID: <200812022032.mB2KWTFL005863@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45122 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750770AbYLBUdN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 15:33:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, James.Bottomley@HansenPartnership.com, andmike@linux.vnet.ibm.com, hare@suse.de, jens.axboe@oracle.com


The patch titled
     block: internal dequeue shouldn't start timer
has been added to the -mm tree.  Its filename is
     block-internal-dequeue-shouldnt-start-timer.patch

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
Subject: block: internal dequeue shouldn't start timer
From: Tejun Heo <tj@kernel.org>

blkdev_dequeue_request() and elv_dequeue_request() are equivalent and
both start the timeout timer.  Barrier code dequeues the original
barrier request but doesn't passes the request itself to lower level
driver, only broken down proxy requests; however, as the original
barrier code goes through the same dequeue path and timeout timer is
started on it.  If barrier sequence takes long enough, this timer
expires but the low level driver has no idea about this request and
oops follows.

Timeout timer shouldn't have been started on the original barrier
request as it never goes through actual IO.  This patch unexports
elv_dequeue_request(), which has no external user anyway, and makes it
operate on elevator proper w/o adding the timer and make
blkdev_dequeue_request() call elv_dequeue_request() and add timer.
Internal users which don't pass the request to driver - barrier code
and end_that_request_last() - are converted to use
elv_dequeue_request().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-barrier.c    |    4 ++--
 block/blk-core.c       |   24 +++++++++++++++++++++++-
 block/elevator.c       |    7 -------
 include/linux/blkdev.h |    7 ++-----
 4 files changed, 27 insertions(+), 15 deletions(-)

diff -puN block/blk-barrier.c~block-internal-dequeue-shouldnt-start-timer block/blk-barrier.c
--- a/block/blk-barrier.c~block-internal-dequeue-shouldnt-start-timer
+++ a/block/blk-barrier.c
@@ -161,7 +161,7 @@ static inline struct request *start_orde
 	/*
 	 * Prep proxy barrier request.
 	 */
-	blkdev_dequeue_request(rq);
+	elv_dequeue_request(q, rq);
 	q->orig_bar_rq = rq;
 	rq = &q->bar_rq;
 	blk_rq_init(q, rq);
@@ -219,7 +219,7 @@ int blk_do_ordered(struct request_queue 
 			 * This can happen when the queue switches to
 			 * ORDERED_NONE while this request is on it.
 			 */
-			blkdev_dequeue_request(rq);
+			elv_dequeue_request(q, rq);
 			if (__blk_end_request(rq, -EOPNOTSUPP,
 					      blk_rq_bytes(rq)))
 				BUG();
diff -puN block/blk-core.c~block-internal-dequeue-shouldnt-start-timer block/blk-core.c
--- a/block/blk-core.c~block-internal-dequeue-shouldnt-start-timer
+++ a/block/blk-core.c
@@ -1641,6 +1641,28 @@ int blk_insert_cloned_request(struct req
 EXPORT_SYMBOL_GPL(blk_insert_cloned_request);
 
 /**
+ * blkdev_dequeue_request - dequeue request and start timeout timer
+ * @req: request to dequeue
+ *
+ * Dequeue @req and start timeout timer on it.  This hands off the
+ * request to the driver.
+ *
+ * Block internal functions which don't want to start timer should
+ * call elv_dequeue_request().
+ */
+void blkdev_dequeue_request(struct request *req)
+{
+	elv_dequeue_request(req->q, req);
+
+	/*
+	 * We are now handing the request to the hardware, add the
+	 * timeout handler.
+	 */
+	blk_add_timer(req);
+}
+EXPORT_SYMBOL(blkdev_dequeue_request);
+
+/**
  * __end_that_request_first - end I/O on a request
  * @req:      the request being processed
  * @error:    %0 for success, < %0 for error
@@ -1778,7 +1800,7 @@ static void end_that_request_last(struct
 		blk_queue_end_tag(req->q, req);
 
 	if (blk_queued_rq(req))
-		blkdev_dequeue_request(req);
+		elv_dequeue_request(req->q, req);
 
 	if (unlikely(laptop_mode) && blk_fs_request(req))
 		laptop_io_completion();
diff -puN block/elevator.c~block-internal-dequeue-shouldnt-start-timer block/elevator.c
--- a/block/elevator.c~block-internal-dequeue-shouldnt-start-timer
+++ a/block/elevator.c
@@ -844,14 +844,7 @@ void elv_dequeue_request(struct request_
 	 */
 	if (blk_account_rq(rq))
 		q->in_flight++;
-
-	/*
-	 * We are now handing the request to the hardware, add the
-	 * timeout handler.
-	 */
-	blk_add_timer(rq);
 }
-EXPORT_SYMBOL(elv_dequeue_request);
 
 int elv_queue_empty(struct request_queue *q)
 {
diff -puN include/linux/blkdev.h~block-internal-dequeue-shouldnt-start-timer include/linux/blkdev.h
--- a/include/linux/blkdev.h~block-internal-dequeue-shouldnt-start-timer
+++ a/include/linux/blkdev.h
@@ -787,6 +787,8 @@ static inline void blk_run_address_space
 		blk_run_backing_dev(mapping->backing_dev_info, NULL);
 }
 
+extern void blkdev_dequeue_request(struct request *req);
+
 /*
  * blk_end_request() and friends.
  * __blk_end_request() and end_request() must be called with
@@ -821,11 +823,6 @@ extern void blk_update_request(struct re
 extern unsigned int blk_rq_bytes(struct request *rq);
 extern unsigned int blk_rq_cur_bytes(struct request *rq);
 
-static inline void blkdev_dequeue_request(struct request *req)
-{
-	elv_dequeue_request(req->q, req);
-}
