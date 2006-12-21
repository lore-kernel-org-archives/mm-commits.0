From: akpm@osdl.org
Subject: + performance-regression-from-block-merge.patch added to -mm tree
Date: Thu, 21 Dec 2006 13:31:15 -0800
Message-ID: <200612212131.kBLLVFsi005608@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:42926 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423123AbWLUVbl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Dec 2006 16:31:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jens.axboe@oracle.com


The patch titled
     performance regression from block merge
has been added to the -mm tree.  Its filename is
     performance-regression-from-block-merge.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: performance regression from block merge
From: Jens Axboe <jens.axboe@oracle.com>

I spotted an obvious typo in the recent merge.

Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 block/elevator.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN block/elevator.c~performance-regression-from-block-merge block/elevator.c
--- a/block/elevator.c~performance-regression-from-block-merge
+++ a/block/elevator.c
@@ -82,7 +82,7 @@ inline int elv_rq_merge_ok(struct reques
 	/*
 	 * must be same device and not a special request
 	 */
-	if (rq->rq_disk != bio->bi_bdev->bd_disk || !rq->special)
+	if (rq->rq_disk != bio->bi_bdev->bd_disk || rq->special)
 		return 0;
 
 	if (!elv_iosched_allow_merge(rq, bio))
_

Patches currently in -mm which might be from jens.axboe@oracle.com are

origin.patch
performance-regression-from-block-merge.patch

