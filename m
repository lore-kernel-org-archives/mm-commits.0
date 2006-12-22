From: akpm@osdl.org
Subject: - performance-regression-from-block-merge.patch removed from -mm tree
Date: Fri, 22 Dec 2006 00:56:57 -0800
Message-ID: <200612220856.kBM8uvsu018453@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58320 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945999AbWLVI5Z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Dec 2006 03:57:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     performance regression from block merge
has been removed from the -mm tree.  Its filename was
     performance-regression-from-block-merge.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

