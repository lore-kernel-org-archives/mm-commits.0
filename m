From: akpm@linux-foundation.org
Subject: - fix-ll_rw_blkc-build-on-s390.patch removed from -mm tree
Date: Wed, 24 Oct 2007 14:41:31 -0700
Message-ID: <200710242141.l9OLfVH2013962@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49694 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757727AbXJXVmN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 17:42:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     fix ll_rw_blk.c build on s390
has been removed from the -mm tree.  Its filename was
     fix-ll_rw_blkc-build-on-s390.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix ll_rw_blk.c build on s390
From: Heiko Carstens <heiko.carstens@de.ibm.com>

  CC      block/ll_rw_blk.o
block/ll_rw_blk.c: In function 'blk_rq_map_sg':
block/ll_rw_blk.c:1357: error: implicit declaration of function 'sg_dma_len'
block/ll_rw_blk.c:1357: error: lvalue required as left operand of assignment
block/ll_rw_blk.c:1358: error: implicit declaration of function 'sg_dma_address'
block/ll_rw_blk.c:1358: error: lvalue required as left operand of assignment
make[1]: *** [block/ll_rw_blk.o] Error 1
make: *** [block] Error 2

Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/ll_rw_blk.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN block/ll_rw_blk.c~fix-ll_rw_blkc-build-on-s390 block/ll_rw_blk.c
--- a/block/ll_rw_blk.c~fix-ll_rw_blkc-build-on-s390
+++ a/block/ll_rw_blk.c
@@ -1354,8 +1354,6 @@ new_segment:
 			else
 				sg = sg_next(sg);
 
-			sg_dma_len(sg) = 0;
-			sg_dma_address(sg) = 0;
 			sg_set_page(sg, bvec->bv_page);
 			sg->length = nbytes;
 			sg->offset = bvec->bv_offset;
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are
