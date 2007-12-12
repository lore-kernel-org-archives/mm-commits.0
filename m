From: akpm@linux-foundation.org
Subject: + as-iosched-fix-write-batch-start-point.patch added to -mm tree
Date: Wed, 12 Dec 2007 01:50:45 -0800
Message-ID: <200712120950.lBC9ojQc003800@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51003 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755740AbXLLJwr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 04:52:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aaronc@gelato.unsw.edu.au, jens.axboe@oracle.com, npiggin@suse.de


The patch titled
     as-iosched: fix write batch start point
has been added to the -mm tree.  Its filename is
     as-iosched-fix-write-batch-start-point.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: as-iosched: fix write batch start point
From: Aaron Carroll <aaronc@gelato.unsw.edu.au>

New write batches currently start from where the last one completed.  We
have no idea where the head is after switching batches, so this makes
little sense.  Instead, start the next batch from the request with the
earliest deadline in the hope that we avoid a deadline expiry later on.

Signed-off-by: Aaron Carroll <aaronc@gelato.unsw.edu.au>
Acked-by: Nick Piggin <npiggin@suse.de>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/as-iosched.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN block/as-iosched.c~as-iosched-fix-write-batch-start-point block/as-iosched.c
--- a/block/as-iosched.c~as-iosched-fix-write-batch-start-point
+++ a/block/as-iosched.c
@@ -1097,7 +1097,8 @@ dispatch_writes:
 		ad->batch_data_dir = REQ_ASYNC;
 		ad->current_write_count = ad->write_batch_count;
 		ad->write_batch_idled = 0;
-		rq = ad->next_rq[ad->batch_data_dir];
+		rq = rq_entry_fifo(ad->fifo_list[REQ_ASYNC].next);
+		ad->last_check_fifo[REQ_ASYNC] = jiffies;
 		goto dispatch_request;
 	}
 
_

Patches currently in -mm which might be from aaronc@gelato.unsw.edu.au are

as-iosched-fix-write-batch-start-point.patch
