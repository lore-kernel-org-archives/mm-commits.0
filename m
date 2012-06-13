From: akpm@linux-foundation.org
Subject: + block-remove-unused-blk_abort_queue.patch added to -mm tree
Date: Wed, 13 Jun 2012 15:31:18 -0700
Message-ID: <20120613223118.BFE17A0137@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:47262 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752005Ab2FMWbV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Jun 2012 18:31:21 -0400
Received: by lagr15 with SMTP id r15so56938lag.1
        for <mm-commits@vger.kernel.org>; Wed, 13 Jun 2012 15:31:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: asias@redhat.com, axboe@kernel.dk, chris.mason@oracle.com, dave@jikos.cz


The patch titled
     Subject: block: remove unused blk_abort_queue()
has been added to the -mm tree.  Its filename is
     block-remove-unused-blk_abort_queue.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
