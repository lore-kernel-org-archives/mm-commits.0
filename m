From: akpm@linux-foundation.org
Subject: + tile-uninline-dma_set_mask.patch added to -mm tree
Date: Tue, 17 Nov 2015 13:38:09 -0800
Message-ID: <564b9e41.szeoDzS6vNT3vumu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45063 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721AbbKQViM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Nov 2015 16:38:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, cmetcalf@ezchip.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tile: uninline dma_set_mask
has been added to the -mm tree.  Its filename is
     tile-uninline-dma_set_mask.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tile-uninline-dma_set_mask.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tile-uninline-dma_set_mask.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: tile: uninline dma_set_mask

We'll soon merge <asm-generic/dma-mapping-common.h> into <linux/dma-mapping.h>
and the reference to dma_capable in the tile dma_set_mask would create a
circular dependency.  Fix this by moving the implementation out of line.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Chris Metcalf <cmetcalf@ezchip.com>
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

dma-mapping-make-the-generic-coherent-dma-mmap-implementation-optional.patch
arc-convert-to-dma_map_ops.patch
avr32-convert-to-dma_map_ops.patch
blackfin-convert-to-dma_map_ops.patch
c6x-convert-to-dma_map_ops.patch
cris-convert-to-dma_map_ops.patch
nios2-convert-to-dma_map_ops.patch
frv-convert-to-dma_map_ops.patch
parisc-convert-to-dma_map_ops.patch
mn10300-convert-to-dma_map_ops.patch
m68k-convert-to-dma_map_ops.patch
metag-convert-to-dma_map_ops.patch
sparc-use-generic-dma_set_mask.patch
tile-uninline-dma_set_mask.patch
dma-mapping-always-provide-the-dma_map_ops-based-implementation.patch
dma-mapping-remove-asm-generic-dma-coherenth.patch

