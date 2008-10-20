From: akpm@linux-foundation.org
Subject: - cciss-fix-sysfs-regression.patch removed from -mm tree
Date: Mon, 20 Oct 2008 14:43:22 -0700
Message-ID: <200810202143.m9KLhMfw023242@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51547 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751215AbYJTVni (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 17:43:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.miller@hp.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     cciss: fix sysfs regression
has been removed from the -mm tree.  Its filename was
     cciss-fix-sysfs-regression.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cciss: fix sysfs regression
From: Mike Miller <mike.miller@hp.com>

Fix a broken symlink in sysfs.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/block/cciss.c~cciss-fix-sysfs-regression drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-fix-sysfs-regression
+++ a/drivers/block/cciss.c
@@ -1365,6 +1365,7 @@ static void cciss_add_disk(ctlr_info_t *
 	disk->first_minor = drv_index << NWD_SHIFT;
 	disk->fops = &cciss_fops;
 	disk->private_data = &h->drv[drv_index];
+	disk->driverfs_dev = &h->pdev->dev;
 
 	/* Set up queue information */
 	blk_queue_bounce_limit(disk->queue, h->pdev->dma_mask);
_

Patches currently in -mm which might be from mike.miller@hp.com are

origin.patch
cciss-fix-sysfs-regression.patch

