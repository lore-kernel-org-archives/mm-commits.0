From: akpm@linux-foundation.org
Subject: [merged] lib-scatterlist-fix-memory-leak-with-scsi-mq.patch
 removed from -mm tree
Date: Wed, 29 Oct 2014 11:23:11 -0700
Message-ID: <5451308f.olADcckexCWzXlBt%akpm__35507.4538071223$1414607009$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48465 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756404AbaJ2SXL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Oct 2014 14:23:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tonyb@cybernetics.com, James.Bottomley@HansenPartnership.com, axboe@kernel.dk, hch@infradead.org, martin.petersen@oracle.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/scatterlist: fix memory leak with scsi-mq
has been removed from the -mm tree.  Its filename was
     lib-scatterlist-fix-memory-leak-with-scsi-mq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

