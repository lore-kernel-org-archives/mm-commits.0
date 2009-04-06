From: akpm@linux-foundation.org
Subject: [merged] cciss-change-to-discover-first-memory-bar.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:39:21 -0700
Message-ID: <200904061939.n36JdLcF013853@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57610 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754090AbZDFTmg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:42:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.miller@hp.com, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     cciss: change to discover first memory BAR
has been removed from the -mm tree.  Its filename was
     cciss-change-to-discover-first-memory-bar.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cciss: change to discover first memory BAR
From: Mike Miller <mike.miller@hp.com>

Add a method for discovering the first memory BAR.  All Smart Array
controllers to date have always had the the memory BAR as the first BAR. 
A new controller to be released later this year breaks that model.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff -puN drivers/block/cciss.c~cciss-change-to-discover-first-memory-bar drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-change-to-discover-first-memory-bar
+++ a/drivers/block/cciss.c
@@ -3265,12 +3265,21 @@ static int __devinit cciss_pci_init(ctlr
  */
 	cciss_interrupt_mode(c, pdev, board_id);
 
-	/*
-	 * Memory base addr is first addr , the second points to the config
-	 *   table
-	 */
+	/* find the memory BAR */
+	for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
+		if (pci_resource_flags(pdev, i) & IORESOURCE_MEM)
+			break;
+	}
+	if (i == DEVICE_COUNT_RESOURCE) {
+		printk(KERN_WARNING "cciss: No memory BAR found\n");
+		err = -ENODEV;
+		goto err_out_free_res;
+	}
+
+	c->paddr = pci_resource_start(pdev, i); /* addressing mode bits
+						 * already removed
+						 */
 
-	c->paddr = pci_resource_start(pdev, 0);	/* addressing mode bits already removed */
 #ifdef CCISS_DEBUG
 	printk("address 0 = %lx\n", c->paddr);
 #endif				/* CCISS_DEBUG */
_

Patches currently in -mm which might be from mike.miller@hp.com are

linux-next.patch

