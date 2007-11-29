From: akpm@linux-foundation.org
Subject: + r6040-remove-virt_to_bus.patch added to -mm tree
Date: Thu, 29 Nov 2007 15:04:08 -0800
Message-ID: <200711292304.lATN48aI011957@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40575 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933703AbXK2XEN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Nov 2007 18:04:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: romieu@fr.zoreil.com


The patch titled
     r6040: remove virt_to_bus
has been added to the -mm tree.  Its filename is
     r6040-remove-virt_to_bus.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: r6040: remove virt_to_bus
From: Francois Romieu <romieu@fr.zoreil.com>

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/r6040.c |  103 ++++++++++++++++++++----------------------
 1 file changed, 50 insertions(+), 53 deletions(-)

diff -puN drivers/net/r6040.c~r6040-remove-virt_to_bus drivers/net/r6040.c
--- a/drivers/net/r6040.c~r6040-remove-virt_to_bus
+++ a/drivers/net/r6040.c
@@ -126,8 +126,8 @@
 #define TX_DCNT		0x80	/* TX descriptor count */
 #define RX_DCNT		0x80	/* RX descriptor count */
 #define MAX_BUF_SIZE	0x600
-#define ALLOC_DESC_SIZE	((TX_DCNT+RX_DCNT) * \
-	sizeof(struct r6040_descriptor) + 0x10)
+#define RX_DESC_SIZE	(RX_DCNT * sizeof(struct r6040_descriptor))
+#define TX_DESC_SIZE	(TX_DCNT * sizeof(struct r6040_descriptor))
 #define MBCR_DEFAULT	0x012A	/* MAC Bus Control Register */
 #define MCAST_MAX	4	/* Max number multicast addresses to filter */
 
@@ -164,10 +164,12 @@ struct r6040_private {
 	struct r6040_descriptor *rx_remove_ptr;
 	struct r6040_descriptor *tx_insert_ptr;
 	struct r6040_descriptor *tx_remove_ptr;
+	struct r6040_descriptor *rx_ring;
+	struct r6040_descriptor *tx_ring;
+	dma_addr_t rx_ring_dma;
+	dma_addr_t tx_ring_dma;
 	u16	tx_free_desc, rx_free_desc, phy_addr, phy_mode;
 	u16	mcr0, mcr1;
-	dma_addr_t desc_dma;
-	char	*desc_pool;
 	u16	switch_sig;
 	struct net_device *dev;
 	struct mii_if_info mii_if;
@@ -291,6 +293,7 @@ static void r6040_down(struct net_device
 {
 	struct r6040_private *lp = netdev_priv(dev);
 	void __iomem *ioaddr = lp->base;
+	struct pci_dev *pdev = lp->pdev;
 	int i;
 	int limit = 2048;
 	u16 *adrp;
@@ -334,8 +337,8 @@ static void r6040_down(struct net_device
 	}
 
 	/* Free Descriptor memory */
-	pci_free_consistent(lp->pdev, ALLOC_DESC_SIZE,
-		lp->desc_pool, lp->desc_dma);
+	pci_free_consistent(pdev, RX_DESC_SIZE, lp->rx_ring, lp->rx_ring_dma);
+	pci_free_consistent(pdev, TX_DESC_SIZE, lp->tx_ring, lp->tx_ring_dma);
 }
 
 static int
@@ -577,67 +580,53 @@ static void r6040_poll_controller(struct
 #endif
 
 
+static void r6040_init_ring_desc(struct r6040_descriptor *desc_ring,
+				 dma_addr_t desc_dma, int size)
+{
+	struct r6040_descriptor *desc = desc_ring;
+	dma_addr_t mapping = desc_dma;
+
+	while (size-- > 0) {
+		mapping += sizeof(sizeof(*desc));
+		desc->ndesc = cpu_to_le32(mapping);
+		desc->vndescp = desc + 1;
+		desc++;
+	}
+	desc--;
+	desc->ndesc = cpu_to_le32(desc_dma);
+	desc->vndescp = desc_ring;
+}
+
 /* Init RDC MAC */
 static void r6040_up(struct net_device *dev)
 {
 	struct r6040_private *lp = netdev_priv(dev);
-	struct r6040_descriptor *descptr;
 	void __iomem *ioaddr = lp->base;
-	int i;
-	__le32 tmp_addr;
-	dma_addr_t desc_dma, start_dma;
 
 	/* Initialize */
 	lp->tx_free_desc = TX_DCNT;
 	lp->rx_free_desc = 0;
 	/* Init descriptor */
-	memset(lp->desc_pool, 0, ALLOC_DESC_SIZE); /* Let all descriptor = 0 */
-	lp->tx_insert_ptr = (struct r6040_descriptor *)lp->desc_pool;
-	lp->tx_remove_ptr = lp->tx_insert_ptr;
-	lp->rx_insert_ptr = (struct r6040_descriptor *)lp->tx_insert_ptr +
-		TX_DCNT;
-	lp->rx_remove_ptr = lp->rx_insert_ptr;
+	lp->tx_remove_ptr = lp->tx_insert_ptr = lp->tx_ring;
+	lp->rx_remove_ptr = lp->rx_insert_ptr = lp->rx_ring;
 	/* Init TX descriptor */
-	descptr = lp->tx_insert_ptr;
-	desc_dma = lp->desc_dma;
-	start_dma = desc_dma;
-	for (i = 0; i < TX_DCNT; i++) {
-		descptr->ndesc = cpu_to_le32(desc_dma +
-			sizeof(struct r6040_descriptor));
-		descptr->vndescp = (descptr + 1);
-		descptr = (descptr + 1);
-		desc_dma += sizeof(struct r6040_descriptor);
-	}
-	(descptr - 1)->ndesc = cpu_to_le32(start_dma);
-	(descptr - 1)->vndescp = lp->tx_insert_ptr;
+	r6040_init_ring_desc(lp->tx_ring, lp->tx_ring_dma, TX_DCNT);
 
 	/* Init RX descriptor */
-	start_dma = desc_dma;
-	descptr = lp->rx_insert_ptr;
-	for (i = 0; i < RX_DCNT; i++) {
-		descptr->ndesc = cpu_to_le32(desc_dma +
-			sizeof(struct r6040_descriptor));
-		descptr->vndescp = (descptr + 1);
-		descptr = (descptr + 1);
-		desc_dma += sizeof(struct r6040_descriptor);
-	}
-	(descptr - 1)->ndesc = cpu_to_le32(start_dma);
-	(descptr - 1)->vndescp = lp->rx_insert_ptr;
+	r6040_init_ring_desc(lp->rx_ring, lp->rx_ring_dma, RX_DCNT);
 
 	/* Allocate buffer for RX descriptor */
 	rx_buf_alloc(lp, dev);
 
-	/* TX and RX descriptor start Register */
-	tmp_addr = cpu_to_le32((u32)lp->tx_insert_ptr);
-	tmp_addr = virt_to_bus((volatile void *)tmp_addr);
-	/* Lower 16-bits to MTD_SA0 */
-	iowrite16(tmp_addr, ioaddr + MTD_SA0);
-	/* Higher 16-bits to MTD_SA1 */
-	iowrite16((u16)(tmp_addr >> 16), ioaddr + MTD_SA1);
-	tmp_addr = cpu_to_le32((u32)lp->rx_insert_ptr);
-	tmp_addr = virt_to_bus((volatile void *)tmp_addr);
-	iowrite16(tmp_addr, ioaddr + MRD_SA0);
-	iowrite16((u16)(tmp_addr >> 16), ioaddr + MRD_SA1);
+	/*
+	 * TX and RX descriptor start registers.
+	 * Lower 16-bits to MxD_SA0. Higher 16-bits to MxD_SA1.
+	 */
+	iowrite16(lp->tx_ring_dma, ioaddr + MTD_SA0);
+	iowrite16(lp->tx_ring_dma >> 16, ioaddr + MTD_SA1);
+
+	iowrite16(lp->rx_ring_dma, ioaddr + MRD_SA0);
+	iowrite16(lp->rx_ring_dma >> 16, ioaddr + MRD_SA1);
 
 	/* Buffer Size Register */
 	iowrite16(MAX_BUF_SIZE, ioaddr + MR_BSR);
@@ -743,10 +732,18 @@ r6040_open(struct net_device *dev)
 	r6040_mac_address(dev);
 
 	/* Allocate Descriptor memory */
-	lp->desc_pool = pci_alloc_consistent(lp->pdev,
-		ALLOC_DESC_SIZE, &lp->desc_dma);
-	if (!lp->desc_pool)
+	lp->rx_ring =
+		pci_alloc_consistent(lp->pdev, RX_DESC_SIZE, &lp->rx_ring_dma);
+	if (!lp->rx_ring)
+		return -ENOMEM;
+
+	lp->tx_ring =
+		pci_alloc_consistent(lp->pdev, TX_DESC_SIZE, &lp->tx_ring_dma);
+	if (!lp->tx_ring) {
+		pci_free_consistent(lp->pdev, RX_DESC_SIZE, lp->rx_ring,
+				     lp->rx_ring_dma);
 		return -ENOMEM;
+	}
 
 	r6040_up(dev);
 
_

Patches currently in -mm which might be from romieu@fr.zoreil.com are

git-netdev-all.patch
r6040-compile-error.patch
r6040-remove-virt_to_bus.patch
r6040-erroneous-dev-priv.patch
r6040-cleanups.patch
