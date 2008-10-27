From: akpm@linux-foundation.org
Subject: + cciss-fix-sysfs-broken-symlink-regression.patch added to -mm tree
Date: Mon, 27 Oct 2008 14:30:03 -0700
Message-ID: <200810272130.m9RLU3kQ004412@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43783 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753605AbYJ0VaZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Oct 2008 17:30:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mike.miller@hp.com, jens.axboe@oracle.com, stable@kernel.org


The patch titled
     cciss: fix sysfs broken symlink regression
has been added to the -mm tree.  Its filename is
     cciss-fix-sysfs-broken-symlink-regression.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cciss: fix sysfs broken symlink regression
From: Mike Miller <mike.miller@hp.com>

Regression introduced by commit 6ae5ce8e8d4de666f31286808d2285aa6a50fa40
("cciss: remove redundant code").

This patch fixes a broken symlink in sysfs that was introduced by the
above commit.  We broke it in 2.6.27-rc on or about 20080804.  Some
installers are broken if this symlink does not exist and they may not
detect the logical drives configured on the controller.  It does not
require being backported into 2.6.26.x or earlier kernels.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: <stable@kernel.org>		[2.6.27.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/block/cciss.c~cciss-fix-sysfs-broken-symlink-regression drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-fix-sysfs-broken-symlink-regression
+++ a/drivers/block/cciss.c
@@ -1370,6 +1370,7 @@ static void cciss_add_disk(ctlr_info_t *
 	disk->first_minor = drv_index << NWD_SHIFT;
 	disk->fops = &cciss_fops;
 	disk->private_data = &h->drv[drv_index];
+	disk->driverfs_dev = &h->pdev->dev;
 
 	/* Set up queue information */
 	blk_queue_bounce_limit(disk->queue, h->pdev->dma_mask);
_

Patches currently in -mm which might be from mike.miller@hp.com are

cciss-fix-regression-firmware-not-displayed-in-procfs-again-and-again.patch
cciss-new-hardware-support.patch
cciss-fix-sysfs-broken-symlink-regression.patch

