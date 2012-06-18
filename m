From: akpm@linux-foundation.org
Subject: [merged] block-remove-unused-blk_abort_queue.patch removed from -mm tree
Date: Mon, 18 Jun 2012 14:32:08 -0700
Message-ID: <20120618213208.B10B9A01BD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:50820 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542Ab2FRVcL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 Jun 2012 17:32:11 -0400
Received: by fat25 with SMTP id 25so295849fat.1
        for <mm-commits@vger.kernel.org>; Mon, 18 Jun 2012 14:32:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: asias@redhat.com, axboe@kernel.dk, chris.mason@oracle.com, dave@jikos.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: block: remove unused blk_abort_queue()
has been removed from the -mm tree.  Its filename was
     block-remove-unused-blk_abort_queue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Asias He <asias@redhat.com>
Subject: block: remove unused blk_abort_queue()

This function was only used by btrfs code in btrfs_abort_devices()
(seems in a wrong way).

That call was removed in d07eb9117050 ("btrfs: Drop unused function
btrfs_abort_devices()"), so let's remove the dead code to avoid any
confusion.
already.

Signed-off-by: Asias He <asias@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: David Sterba <dave@jikos.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-timeout.c    |   41 ---------------------------------------
 include/linux/blkdev.h |    1 
 2 files changed, 42 deletions(-)

diff -puN block/blk-timeout.c~block-remove-unused-blk_abort_queue block/blk-timeout.c
--- a/block/blk-timeout.c~block-remove-unused-blk_abort_queue
+++ a/block/blk-timeout.c
@@ -197,44 +197,3 @@ void blk_add_timer(struct request *req)
 		mod_timer(&q->timeout, expiry);
 }
 
-/**
- * blk_abort_queue -- Abort all request on given queue
- * @queue:	pointer to queue
- *
- */
-void blk_abort_queue(struct request_queue *q)
-{
-	unsigned long flags;
-	struct request *rq, *tmp;
-	LIST_HEAD(list);
-
-	/*
-	 * Not a request based block device, nothing to abort
-	 */
-	if (!q->request_fn)
-		return;
-
-	spin_lock_irqsave(q->queue_lock, flags);
-
-	elv_abort_queue(q);
-
-	/*
-	 * Splice entries to local list, to avoid deadlocking if entries
-	 * get readded to the timeout list by error handling
-	 */
-	list_splice_init(&q->timeout_list, &list);
-
-	list_for_each_entry_safe(rq, tmp, &list, timeout_list)
-		blk_abort_request(rq);
-
-	/*
-	 * Occasionally, blk_abort_request() will return without
-	 * deleting the element from the list. Make sure we add those back
-	 * instead of leaving them on the local stack list.
-	 */
-	list_splice(&list, &q->timeout_list);
-
-	spin_unlock_irqrestore(q->queue_lock, flags);
