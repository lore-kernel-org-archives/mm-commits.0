From: akpm@linux-foundation.org
Subject: [merged] replace-all-dma_39bit_mask-macro-with-dma_bit_mask39.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:07:55 -0700
Message-ID: <200904071907.n37J7tXc011526@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59208 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754623AbZDGTJO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:09:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yanghy@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     dma-mapping: replace all DMA_39BIT_MASK macro with DMA_BIT_MASK(39)
has been removed from the -mm tree.  Its filename was
     replace-all-dma_39bit_mask-macro-with-dma_bit_mask39.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dma-mapping: replace all DMA_39BIT_MASK macro with DMA_BIT_MASK(39)
From: Yang Hongyang <yanghy@cn.fujitsu.com>

Replace all DMA_39BIT_MASK macro with DMA_BIT_MASK(39)

Signed-off-by: Yang Hongyang<yanghy@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/forcedeth.c                |    4 ++--
 drivers/net/netxen/netxen_nic_main.c   |    8 ++++----
 drivers/scsi/aic7xxx/aic79xx_osm_pci.c |    4 ++--
 3 files changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/net/forcedeth.c~replace-all-dma_39bit_mask-macro-with-dma_bit_mask39 drivers/net/forcedeth.c
--- a/drivers/net/forcedeth.c~replace-all-dma_39bit_mask-macro-with-dma_bit_mask39
+++ a/drivers/net/forcedeth.c
@@ -5632,12 +5632,12 @@ static int __devinit nv_probe(struct pci
 		np->desc_ver = DESC_VER_3;
 		np->txrxctl_bits = NVREG_TXRXCTL_DESC_3;
 		if (dma_64bit) {
-			if (pci_set_dma_mask(pci_dev, DMA_39BIT_MASK))
+			if (pci_set_dma_mask(pci_dev, DMA_BIT_MASK(39)))
 				dev_printk(KERN_INFO, &pci_dev->dev,
 					"64-bit DMA failed, using 32-bit addressing\n");
 			else
 				dev->features |= NETIF_F_HIGHDMA;
-			if (pci_set_consistent_dma_mask(pci_dev, DMA_39BIT_MASK)) {
+			if (pci_set_consistent_dma_mask(pci_dev, DMA_BIT_MASK(39))) {
 				dev_printk(KERN_INFO, &pci_dev->dev,
 					"64-bit DMA (consistent) failed, using 32-bit ring buffers\n");
 			}
diff -puN drivers/net/netxen/netxen_nic_main.c~replace-all-dma_39bit_mask-macro-with-dma_bit_mask39 drivers/net/netxen/netxen_nic_main.c
--- a/drivers/net/netxen/netxen_nic_main.c~replace-all-dma_39bit_mask-macro-with-dma_bit_mask39
+++ a/drivers/net/netxen/netxen_nic_main.c
@@ -207,19 +207,19 @@ static int nx_set_dma_mask(struct netxen
 
 	adapter->pci_using_dac = 0;
 
-	mask = DMA_32BIT_MASK;
+	mask = DMA_BIT_MASK(32);
 	/*
 	 * Consistent DMA mask is set to 32 bit because it cannot be set to
 	 * 35 bits. For P3 also leave it at 32 bits for now. Only the rings
 	 * come off this pool.
 	 */
-	cmask = DMA_32BIT_MASK;
+	cmask = DMA_BIT_MASK(32);
 
 #ifndef CONFIG_IA64
 	if (revision_id >= NX_P3_B0)
-		mask = DMA_39BIT_MASK;
+		mask = DMA_BIT_MASK(39);
 	else if (revision_id == NX_P2_C1)
-		mask = DMA_35BIT_MASK;
+		mask = DMA_BIT_MASK(35);
 #endif
 	if (pci_set_dma_mask(pdev, mask) == 0 &&
 		pci_set_consistent_dma_mask(pdev, cmask) == 0) {
diff -puN drivers/scsi/aic7xxx/aic79xx_osm_pci.c~replace-all-dma_39bit_mask-macro-with-dma_bit_mask39 drivers/scsi/aic7xxx/aic79xx_osm_pci.c
--- a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c~replace-all-dma_39bit_mask-macro-with-dma_bit_mask39
+++ a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
@@ -194,11 +194,11 @@ ahd_linux_pci_dev_probe(struct pci_dev *
 	if (sizeof(dma_addr_t) > 4) {
 		const u64 required_mask = dma_get_required_mask(dev);
 
-		if (required_mask > DMA_39BIT_MASK &&
+		if (required_mask > DMA_BIT_MASK(39) &&
 		    dma_set_mask(dev, DMA_BIT_MASK(64)) == 0)
 			ahd->flags |= AHD_64BIT_ADDRESSING;
 		else if (required_mask > DMA_32BIT_MASK &&
-			 dma_set_mask(dev, DMA_39BIT_MASK) == 0)
+			 dma_set_mask(dev, DMA_BIT_MASK(39)) == 0)
 			ahd->flags |= AHD_39BIT_ADDRESSING;
 		else
 			dma_set_mask(dev, DMA_32BIT_MASK);
_

Patches currently in -mm which might be from yanghy@cn.fujitsu.com are

origin.patch

