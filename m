From: akpm@osdl.org
Subject: + cciss-map-out-more-memory-for-config-table.patch added to -mm tree
Date: Tue, 12 Dec 2006 16:56:29 -0800
Message-ID: <200612130056.kBD0uTUZ023163@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:35530 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964857AbWLMA7v (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Dec 2006 19:59:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mikem@beardog.cca.cpqcorp.net, jens.axboe@oracle.com, mike.miller@hp.com


The patch titled
     cciss: map out more memory for config table
has been added to the -mm tree.  Its filename is
     cciss-map-out-more-memory-for-config-table.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cciss: map out more memory for config table
From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>

Map out more memory for our config table.  It's required to reach offset
0x214 to disable DMA on the P600.  I'm not sure how I lost this hunk. 
Please consider this for inclusion.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/block/cciss.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

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

Patches currently in -mm which might be from mikem@beardog.cca.cpqcorp.net are

cciss-map-out-more-memory-for-config-table.patch

