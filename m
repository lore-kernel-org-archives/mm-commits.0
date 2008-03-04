From: akpm@linux-foundation.org
Subject: - cciss-remove-read_ahead-define-and-use-block-layer-defaults.patch removed from -mm tree
Date: Tue, 04 Mar 2008 12:09:38 -0800
Message-ID: <200803042009.m24K9cYG026775@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34764 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765663AbYCDUKK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2008 15:10:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.miller@hp.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     cciss: remove READ_AHEAD define and use block layer defaults
has been removed from the -mm tree.  Its filename was
     cciss-remove-read_ahead-define-and-use-block-layer-defaults.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cciss: remove READ_AHEAD define and use block layer defaults
From: Mike Miller <mike.miller@hp.com>

This patch removes the #define READ_AHEAD 1024 from the driver and uses the
block layer defaults, instead.  We have found that under certain workloads the
setting can cause a disk connected to the e200 controller to go offline.

If the disk hiccups the link may try to downshift but the controller is never
notified that the link successfully completed the renegotiation.  We've also
found that performance using the block layer default of 32 pages was on par
with the 1024 setting.  We tried setting it to zero at one time based on info
from our firmware guys but that killed performance.  Turns out we were talking
about 2 different read ahead settings.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN drivers/block/cciss.c~cciss-remove-read_ahead-define-and-use-block-layer-defaults drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-remove-read_ahead-define-and-use-block-layer-defaults
+++ a/drivers/block/cciss.c
@@ -131,7 +131,6 @@ static struct board_type products[] = {
 /*define how many times we will try a command because of bus resets */
 #define MAX_CMD_RETRIES 3
 
-#define READ_AHEAD 	 1024
 #define MAX_CTLR	32
 
 /* Originally cciss driver only supports 8 major numbers */
@@ -1341,7 +1340,6 @@ geo_inq:
 		disk->private_data = &h->drv[drv_index];
 
 		/* Set up queue information */
-		disk->queue->backing_dev_info.ra_pages = READ_AHEAD;
 		blk_queue_bounce_limit(disk->queue, hba[ctlr]->pdev->dma_mask);
 
 		/* This is a hardware imposed limit. */
@@ -3434,7 +3432,6 @@ static int __devinit cciss_init_one(stru
 		}
 		drv->queue = q;
 
-		q->backing_dev_info.ra_pages = READ_AHEAD;
 		blk_queue_bounce_limit(q, hba[i]->pdev->dma_mask);
 
 		/* This is a hardware imposed limit. */
_

Patches currently in -mm which might be from mike.miller@hp.com are

origin.patch

