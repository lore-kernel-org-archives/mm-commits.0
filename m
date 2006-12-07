From: akpm@osdl.org
Subject: - cciss-cleanup-cciss_interrupt-mode.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:00:40 -0800
Message-ID: <200612072300.kB7N0ehr029664@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51290 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163737AbWLGXAx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:00:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.miller@hp.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     cciss: cleanup cciss_interrupt mode
has been removed from the -mm tree.  Its filename was
     cciss-cleanup-cciss_interrupt-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cciss: cleanup cciss_interrupt mode
From: Mike Miller <mike.miller@hp.com>

A pretty simple cleanup for cciss_interrupt_mode.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/block/cciss.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/block/cciss.c~cciss-cleanup-cciss_interrupt-mode drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-cleanup-cciss_interrupt-mode
+++ a/drivers/block/cciss.c
@@ -2788,23 +2788,21 @@ static void __devinit cciss_interrupt_mo
 		if (err > 0) {
 			printk(KERN_WARNING "cciss: only %d MSI-X vectors "
 			       "available\n", err);
+			goto default_int_mode;
 		} else {
 			printk(KERN_WARNING "cciss: MSI-X init failed %d\n",
 			       err);
+			goto default_int_mode;
 		}
 	}
 	if (pci_find_capability(pdev, PCI_CAP_ID_MSI)) {
 		if (!pci_enable_msi(pdev)) {
-			c->intr[SIMPLE_MODE_INT] = pdev->irq;
 			c->msi_vector = 1;
-			return;
 		} else {
 			printk(KERN_WARNING "cciss: MSI init failed\n");
-			c->intr[SIMPLE_MODE_INT] = pdev->irq;
-			return;
 		}
 	}
-      default_int_mode:
+default_int_mode:
 #endif				/* CONFIG_PCI_MSI */
 	/* if we get here we're going to use the default interrupt mode */
 	c->intr[SIMPLE_MODE_INT] = pdev->irq;
_

Patches currently in -mm which might be from mike.miller@hp.com are

origin.patch

