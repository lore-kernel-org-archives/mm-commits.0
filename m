From: akpm@linux-foundation.org
Subject: + cciss-remove-read_ahead-define-and-use-block-layer-defaults.patch added to -mm tree
Date: Wed, 27 Feb 2008 20:34:25 -0800
Message-ID: <200802280434.m1S4YPrB015681@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:52400 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756485AbYB1Eep (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 23:34:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mike.miller@hp.com, jens.axboe@oracle.com


The patch titled
     cciss: remove READ_AHEAD define and use block layer defaults
has been added to the -mm tree.  Its filename is
     cciss-remove-read_ahead-define-and-use-block-layer-defaults.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

cciss-remove-read_ahead-define-and-use-block-layer-defaults.patch
cciss-procfs-updates-to-display-info-about-many-volumes.patch
