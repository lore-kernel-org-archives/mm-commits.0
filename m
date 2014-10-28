From: akpm@linux-foundation.org
Subject: + lib-scatterlist-fix-memory-leak-with-scsi-mq.patch added to -mm tree
Date: Tue, 28 Oct 2014 15:47:40 -0700
Message-ID: <54501d0c.Hh/oFU419wmK9txI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34326 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbaJ1Wrk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Oct 2014 18:47:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tonyb@cybernetics.com, James.Bottomley@HansenPartnership.com, axboe@kernel.dk, hch@infradead.org, martin.petersen@oracle.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/scatterlist: fix memory leak with scsi-mq
has been added to the -mm tree.  Its filename is
     lib-scatterlist-fix-memory-leak-with-scsi-mq.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-scatterlist-fix-memory-leak-with-scsi-mq.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-scatterlist-fix-memory-leak-with-scsi-mq.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tony Battersby <tonyb@cybernetics.com>
Subject: lib/scatterlist: fix memory leak with scsi-mq

Fix a memory leak with scsi-mq triggered by commands with large data
transfer length.

Fixes: c53c6d6a68b1 ("scatterlist: allow chaining to preallocated chunks")
Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Acked-by: Christoph Hellwig <hch@infradead.org>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Cc: <stable@vger.kernel.org>	[3.17.x]

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/scatterlist.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN lib/scatterlist.c~lib-scatterlist-fix-memory-leak-with-scsi-mq lib/scatterlist.c
--- a/lib/scatterlist.c~lib-scatterlist-fix-memory-leak-with-scsi-mq
+++ a/lib/scatterlist.c
@@ -203,10 +203,10 @@ void __sg_free_table(struct sg_table *ta
 		}
 
 		table->orig_nents -= sg_size;
-		if (!skip_first_chunk) {
-			free_fn(sgl, alloc_size);
+		if (skip_first_chunk)
 			skip_first_chunk = false;
-		}
+		else
+			free_fn(sgl, alloc_size);
 		sgl = next;
 	}
 
_

Patches currently in -mm which might be from tonyb@cybernetics.com are

lib-scatterlist-fix-memory-leak-with-scsi-mq.patch

