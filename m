From: akpm@osdl.org
Subject: - cciss-disable-dma-prefetch-on-p600.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:00:28 -0800
Message-ID: <200612072300.kB7N0SoK029644@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51250 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163679AbWLGXAe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:00:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.miller@hp.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     cciss: disable DMA prefetch on P600
has been removed from the -mm tree.  Its filename was
     cciss-disable-dma-prefetch-on-p600.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cciss: disable DMA prefetch on P600
From: Mike Miller <mike.miller@hp.com>

Unconditionally disable DMA prefetch on the P600 controller.  An ASIC bug may
result in prefetching beyond the end of physical memory.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Acked-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/block/cciss.c     |   11 +++++++++++
 drivers/block/cciss_cmd.h |    1 +
 2 files changed, 12 insertions(+)

diff -puN drivers/block/cciss.c~cciss-disable-dma-prefetch-on-p600 drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-disable-dma-prefetch-on-p600
+++ a/drivers/block/cciss.c
@@ -3003,6 +3003,17 @@ static int cciss_pci_init(ctlr_info_t *c
 	}
 #endif
 
+	/* Disabling DMA prefetch for the P600
+	 * An ASIC bug may result in a prefetch beyond
+	 * physical memory.
+	 */
+	if(board_id == 0x3225103C) {
+		__u32 dma_prefetch;
+		dma_prefetch = readl(c->vaddr + I2O_DMA1_CFG);
+		dma_prefetch |= 0x8000;
+		writel(dma_prefetch, c->vaddr + I2O_DMA1_CFG);
+	}
+
 #ifdef CCISS_DEBUG
 	printk("Trying to put board into Simple mode\n");
 #endif				/* CCISS_DEBUG */
diff -puN drivers/block/cciss_cmd.h~cciss-disable-dma-prefetch-on-p600 drivers/block/cciss_cmd.h
--- a/drivers/block/cciss_cmd.h~cciss-disable-dma-prefetch-on-p600
+++ a/drivers/block/cciss_cmd.h
@@ -55,6 +55,7 @@
 #define I2O_INT_MASK            0x34
 #define I2O_IBPOST_Q            0x40
 #define I2O_OBPOST_Q            0x44
+#define I2O_DMA1_CFG		0x214
 
 //Configuration Table
 #define CFGTBL_ChangeReq        0x00000001l
_

Patches currently in -mm which might be from mike.miller@hp.com are

origin.patch

