From: akpm@linux-foundation.org
Subject: + ll-temac-driver-add-non-virtex-5-support.patch added to -mm tree
Date: Wed, 03 Feb 2010 13:45:42 -0800
Message-ID: <201002032145.o13LjgUY020957@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48567 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755952Ab0BCVpu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 16:45:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jtyner@cs.ucr.edu, afleming@freescale.com, davem@davemloft.net, grant.likely@secretlab.ca


The patch titled
     LL TEMAC driver: add non-Virtex 5 support
has been added to the -mm tree.  Its filename is
     ll-temac-driver-add-non-virtex-5-support.patch

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
Subject: LL TEMAC driver: add non-Virtex 5 support
From: John Tyner <jtyner@cs.ucr.edu>

Add support for using the LL TEMAC Ethernet driver on non-Virtex 5
platforms by adding support for accessing the Soft DMA registers as if
they were memory mapped instead of solely through the DCR's (available on
the Virtex 5).

Signed-off-by: John Tyner <jtyner@cs.ucr.edu>
Cc: Andy Fleming <afleming@freescale.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ll_temac.h      |    1 +
 drivers/net/ll_temac_main.c |   31 ++++++++++++++++++++-----------
 2 files changed, 21 insertions(+), 11 deletions(-)

diff -puN drivers/net/ll_temac.h~ll-temac-driver-add-non-virtex-5-support drivers/net/ll_temac.h
--- a/drivers/net/ll_temac.h~ll-temac-driver-add-non-virtex-5-support
+++ a/drivers/net/ll_temac.h
@@ -338,6 +338,7 @@ struct temac_local {
 	/* IO registers and IRQs */
 	void __iomem *regs;
 	dcr_host_t sdma_dcrs;
+	u32 __iomem *sdma_regs;
 	int tx_irq;
 	int rx_irq;
 	int emac_num;
diff -puN drivers/net/ll_temac_main.c~ll-temac-driver-add-non-virtex-5-support drivers/net/ll_temac_main.c
--- a/drivers/net/ll_temac_main.c~ll-temac-driver-add-non-virtex-5-support
+++ a/drivers/net/ll_temac_main.c
@@ -20,9 +20,6 @@
  *   or rx, so this should be okay.
  *
  * TODO:
- * - Fix driver to work on more than just Virtex5.  Right now the driver
- *   assumes that the locallink DMA registers are accessed via DCR
- *   instructions.
  * - Factor out locallink DMA code into separate driver
  * - Fix multicast assignment.
  * - Fix support for hardware checksumming.
@@ -117,12 +114,20 @@ void temac_indirect_out32(struct temac_l
 
 static u32 temac_dma_in32(struct temac_local *lp, int reg)
 {
-	return dcr_read(lp->sdma_dcrs, reg);
+	if (lp->sdma_regs) {
+		return __raw_readl(lp->sdma_regs + reg);
+	} else {
+		return dcr_read(lp->sdma_dcrs, reg);
+	}
 }
 
 static void temac_dma_out32(struct temac_local *lp, int reg, u32 value)
 {
-	dcr_write(lp->sdma_dcrs, reg, value);
+	if (lp->sdma_regs) {
+		__raw_writel(value, lp->sdma_regs + reg);
+	} else {
+		dcr_write(lp->sdma_dcrs, reg, value);
+	}
 }
 
 /**
@@ -862,13 +867,17 @@ temac_of_probe(struct of_device *op, con
 		goto nodev;
 	}
 
-	dcrs = dcr_resource_start(np, 0);
-	if (dcrs == 0) {
-		dev_err(&op->dev, "could not get DMA register address\n");
+	lp->sdma_regs = NULL;
+
+	if ((dcrs = dcr_resource_start(np, 0)) != 0) {
+		lp->sdma_dcrs = dcr_map(np, dcrs, dcr_resource_len(np, 0));
+		dev_dbg(&op->dev, "DCR base: %x\n", dcrs);
+	} else if ((lp->sdma_regs = of_iomap(np, 0))) {
+		dev_dbg(&op->dev, "MEM base: %p\n", lp->sdma_regs);
+	} else {
+		dev_err(&op->dev, "unable to map DMA registers\n");
 		goto nodev;
 	}
-	lp->sdma_dcrs = dcr_map(np, dcrs, dcr_resource_len(np, 0));
-	dev_dbg(&op->dev, "DCR base: %x\n", dcrs);
 
 	lp->rx_irq = irq_of_parse_and_map(np, 0);
 	lp->tx_irq = irq_of_parse_and_map(np, 1);
@@ -895,7 +904,7 @@ temac_of_probe(struct of_device *op, con
 
 	lp->phy_node = of_parse_phandle(op->node, "phy-handle", 0);
 	if (lp->phy_node)
-		dev_dbg(lp->dev, "using PHY node %s (%p)\n", np->full_name, np);
+		dev_dbg(lp->dev, "using PHY node %s (%p)\n", lp->phy_node->full_name, lp->phy_node);
 
 	/* Add the device attributes */
 	rc = sysfs_create_group(&lp->dev->kobj, &temac_attr_group);
_

Patches currently in -mm which might be from jtyner@cs.ucr.edu are

ll-temac-driver-add-non-virtex-5-support.patch

