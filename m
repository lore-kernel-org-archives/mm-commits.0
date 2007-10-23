From: akpm@linux-foundation.org
Subject: + fix-ll_rw_blkc-build-on-s390.patch added to -mm tree
Date: Mon, 22 Oct 2007 23:52:19 -0700
Message-ID: <200710230652.l9N6qJfL004499@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49604 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751853AbXJWGxG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Oct 2007 02:53:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heiko.carstens@de.ibm.com, jens.axboe@oracle.com


The patch titled
     fix ll_rw_blk.c build on s390
has been added to the -mm tree.  Its filename is
     fix-ll_rw_blkc-build-on-s390.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
fix-ll_rw_blkc-build-on-s390.patch
net-fix-xfrm-build-missing-scatterlisth-include.patch
