From: akpm@osdl.org
Subject: - cciss-map-out-more-memory-for-config-table.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:06:07 -0800
Message-ID: <200612140606.kBE667wA001863@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51875 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863AbWLNGGY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:06:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.miller@hp.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     cciss: map out more memory for config table
has been removed from the -mm tree.  Its filename was
     cciss-map-out-more-memory-for-config-table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cciss: map out more memory for config table
From: Mike Miller <mike.miller@hp.com>

Map out more memory for our config table.  It's required to reach offset
0x214 to disable DMA on the P600.  I'm not sure how I lost this hunk. 
Please consider this for inclusion.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/block/cciss.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/cciss.c~cciss-map-out-more-memory-for-config-table drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-map-out-more-memory-for-config-table
+++ a/drivers/block/cciss.c
@@ -2865,7 +2865,7 @@ static int cciss_pci_init(ctlr_info_t *c
 #ifdef CCISS_DEBUG
 	printk("address 0 = %x\n", c->paddr);
 #endif				/* CCISS_DEBUG */
-	c->vaddr = remap_pci_mem(c->paddr, 200);
+	c->vaddr = remap_pci_mem(c->paddr, 0x250);
 
 	/* Wait for the board to become ready.  (PCI hotplug needs this.)
 	 * We poll for up to 120 secs, once per 100ms. */
_

Patches currently in -mm which might be from mike.miller@hp.com are


