From: akpm@linux-foundation.org
Subject: + update-documentation-block-barriertxt.patch added to -mm tree
Date: Thu, 31 May 2007 12:52:51 -0700
Message-ID: <200705311952.l4VJqqC2026647@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:58726 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758730AbXEaTxt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 May 2007 15:53:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com, htejun@gmail.com, jens.axboe@oracle.com


The patch titled
     Update Documentation/block/barrier.txt
has been added to the -mm tree.  Its filename is
     update-documentation-block-barriertxt.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Update Documentation/block/barrier.txt
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Documentation/block/barrier.txt is not in sync with the actual code:
  - blk_queue_ordered() no longer has a gfp_mask parameter
  - blk_queue_ordered_locked() no longer exists
  - sd_prepare_flush() looks slightly different

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Acked-by: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/block/barrier.txt |   16 +++-------------
 1 files changed, 3 insertions(+), 13 deletions(-)

diff -puN Documentation/block/barrier.txt~update-documentation-block-barriertxt Documentation/block/barrier.txt
--- a/Documentation/block/barrier.txt~update-documentation-block-barriertxt
+++ a/Documentation/block/barrier.txt
@@ -82,23 +82,12 @@ including draining and flushing.
 typedef void (prepare_flush_fn)(request_queue_t *q, struct request *rq);
 
 int blk_queue_ordered(request_queue_t *q, unsigned ordered,
-		      prepare_flush_fn *prepare_flush_fn,
-		      unsigned gfp_mask);
-
-int blk_queue_ordered_locked(request_queue_t *q, unsigned ordered,
-			     prepare_flush_fn *prepare_flush_fn,
-			     unsigned gfp_mask);
-
-The only difference between the two functions is whether or not the
-caller is holding q->queue_lock on entry.  The latter expects the
-caller is holding the lock.
+		      prepare_flush_fn *prepare_flush_fn);
 
 @q			: the queue in question
 @ordered		: the ordered mode the driver/device supports
 @prepare_flush_fn	: this function should prepare @rq such that it
 			  flushes cache to physical medium when executed
-@gfp_mask		: gfp_mask used when allocating data structures
-			  for ordered processing
 
 For example, SCSI disk driver's prepare_flush_fn looks like the
 following.
@@ -106,9 +95,10 @@ following.
 static void sd_prepare_flush(request_queue_t *q, struct request *rq)
 {
 	memset(rq->cmd, 0, sizeof(rq->cmd));
-	rq->flags |= REQ_BLOCK_PC;
+	rq->cmd_type = REQ_TYPE_BLOCK_PC;
 	rq->timeout = SD_TIMEOUT;
 	rq->cmd[0] = SYNCHRONIZE_CACHE;
+	rq->cmd_len = 10;
 }
 
 The following seven ordered modes are supported.  The following table
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

update-documentation-block-barriertxt.patch
fbdev-move-declaration-of-fb_class-to-linux-fbh.patch
