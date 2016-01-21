From: akpm@linux-foundation.org
Subject: [merged] tile-uninline-dma_set_mask.patch removed from -mm tree
Date: Thu, 21 Jan 2016 15:29:11 -0800
Message-ID: <56a169c7.F+CGjslfaO7JreGC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36281 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbcAUX3L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 18:29:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, borntraeger@de.ibm.com, cmetcalf@ezchip.com, jroedel@suse.de, sebott@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tile: uninline dma_set_mask
has been removed from the -mm tree.  Its filename was
     tile-uninline-dma_set_mask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: tile: uninline dma_set_mask

We'll soon merge <asm-generic/dma-mapping-common.h> into <linux/dma-mapping.h>
and the reference to dma_capable in the tile dma_set_mask would create a
circular dependency.  Fix this by moving the implementation out of line.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/include/asm/dma-mapping.h |   29 --------------------------
 arch/tile/kernel/pci-dma.c          |   29 ++++++++++++++++++++++++++
 2 files changed, 30 insertions(+), 28 deletions(-)

diff -puN arch/tile/include/asm/dma-mapping.h~tile-uninline-dma_set_mask arch/tile/include/asm/dma-mapping.h
--- a/arch/tile/include/asm/dma-mapping.h~tile-uninline-dma_set_mask
+++ a/arch/tile/include/asm/dma-mapping.h
@@ -76,34 +76,7 @@ static inline bool dma_capable(struct de
 
 #include <asm-generic/dma-mapping-common.h>
 
-static inline int
-dma_set_mask(struct device *dev, u64 mask)
-{
-	struct dma_map_ops *dma_ops = get_dma_ops(dev);
-
-	/*
-	 * For PCI devices with 64-bit DMA addressing capability, promote
-	 * the dma_ops to hybrid, with the consistent memory DMA space limited
-	 * to 32-bit. For 32-bit capable devices, limit the streaming DMA
-	 * address range to max_direct_dma_addr.
-	 */
-	if (dma_ops == gx_pci_dma_map_ops ||
-	    dma_ops == gx_hybrid_pci_dma_map_ops ||
-	    dma_ops == gx_legacy_pci_dma_map_ops) {
-		if (mask == DMA_BIT_MASK(64) &&
-		    dma_ops == gx_legacy_pci_dma_map_ops)
-			set_dma_ops(dev, gx_hybrid_pci_dma_map_ops);
-		else if (mask > dev->archdata.max_direct_dma_addr)
-			mask = dev->archdata.max_direct_dma_addr;
-	}
-
-	if (!dev->dma_mask || !dma_supported(dev, mask))
-		return -EIO;
-
-	*dev->dma_mask = mask;
-
-	return 0;
-}
+int dma_set_mask(struct device *dev, u64 mask);
 
 /*
  * dma_alloc_noncoherent() is #defined to return coherent memory,
diff -puN arch/tile/kernel/pci-dma.c~tile-uninline-dma_set_mask arch/tile/kernel/pci-dma.c
--- a/arch/tile/kernel/pci-dma.c~tile-uninline-dma_set_mask
+++ a/arch/tile/kernel/pci-dma.c
@@ -583,6 +583,35 @@ struct dma_map_ops *gx_hybrid_pci_dma_ma
 EXPORT_SYMBOL(gx_legacy_pci_dma_map_ops);
 EXPORT_SYMBOL(gx_hybrid_pci_dma_map_ops);
 
+int dma_set_mask(struct device *dev, u64 mask)
+{
+	struct dma_map_ops *dma_ops = get_dma_ops(dev);
+
+	/*
+	 * For PCI devices with 64-bit DMA addressing capability, promote
+	 * the dma_ops to hybrid, with the consistent memory DMA space limited
+	 * to 32-bit. For 32-bit capable devices, limit the streaming DMA
+	 * address range to max_direct_dma_addr.
+	 */
+	if (dma_ops == gx_pci_dma_map_ops ||
+	    dma_ops == gx_hybrid_pci_dma_map_ops ||
+	    dma_ops == gx_legacy_pci_dma_map_ops) {
+		if (mask == DMA_BIT_MASK(64) &&
+		    dma_ops == gx_legacy_pci_dma_map_ops)
+			set_dma_ops(dev, gx_hybrid_pci_dma_map_ops);
+		else if (mask > dev->archdata.max_direct_dma_addr)
+			mask = dev->archdata.max_direct_dma_addr;
+	}
+
+	if (!dev->dma_mask || !dma_supported(dev, mask))
+		return -EIO;
+
+	*dev->dma_mask = mask;
+
+	return 0;
+}
+EXPORT_SYMBOL(dma_set_mask);
+
 #ifdef CONFIG_ARCH_HAS_DMA_SET_COHERENT_MASK
 int dma_set_coherent_mask(struct device *dev, u64 mask)
 {
_

Patches currently in -mm which might be from hch@lst.de are


