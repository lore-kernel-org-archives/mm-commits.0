From: akpm@linux-foundation.org
Subject: [merged] dma-mapping-powerpc-use-generic-pci_set_dma_mask-and-pci_set_consistent_dma_mask.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:03:46 -0400
Message-ID: <201003150704.o2F74JfR017007@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37228 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935969Ab0COHEY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:04:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, benh@kernel.crashing.org, greg@kroah.com, jbarnes@virtuousgeek.org, kay.sievers@vrfy.org, mm-commits@vger.kernel.org


The patch titled
     dma-mapping: powerpc: use generic pci_set_dma_mask and pci_set_consistent_dma_mask
has been removed from the -mm tree.  Its filename was
     dma-mapping-powerpc-use-generic-pci_set_dma_mask-and-pci_set_consistent_dma_mask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dma-mapping: powerpc: use generic pci_set_dma_mask and pci_set_consistent_dma_mask
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

This converts powerpc to use the generic pci_set_dma_mask and
pci_set_consistent_dma_mask (drivers/pci/pci.c).

The generic pci_set_dma_mask does what powerpc's pci_set_dma_mask does.

Unlike powerpc's pci_set_consistent_dma_mask, the gneric
pci_set_consistent_dma_mask sets only coherent_dma_mask.  It doesn't work
for powerpc?  pci_set_consistent_dma_mask API should set only
coherent_dma_mask?

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/dma-mapping.h |    3 ---
 arch/powerpc/kernel/pci-common.c       |   15 ---------------
 2 files changed, 18 deletions(-)

diff -puN arch/powerpc/include/asm/dma-mapping.h~dma-mapping-powerpc-use-generic-pci_set_dma_mask-and-pci_set_consistent_dma_mask arch/powerpc/include/asm/dma-mapping.h
--- a/arch/powerpc/include/asm/dma-mapping.h~dma-mapping-powerpc-use-generic-pci_set_dma_mask-and-pci_set_consistent_dma_mask
+++ a/arch/powerpc/include/asm/dma-mapping.h
@@ -127,9 +127,6 @@ static inline int dma_supported(struct d
 	return dma_ops->dma_supported(dev, mask);
 }
 
-/* We have our own implementation of pci_set_dma_mask() */
-#define HAVE_ARCH_PCI_SET_DMA_MASK
-
 static inline int dma_set_mask(struct device *dev, u64 dma_mask)
 {
 	struct dma_map_ops *dma_ops = get_dma_ops(dev);
diff -puN arch/powerpc/kernel/pci-common.c~dma-mapping-powerpc-use-generic-pci_set_dma_mask-and-pci_set_consistent_dma_mask arch/powerpc/kernel/pci-common.c
--- a/arch/powerpc/kernel/pci-common.c~dma-mapping-powerpc-use-generic-pci_set_dma_mask-and-pci_set_consistent_dma_mask
+++ a/arch/powerpc/kernel/pci-common.c
@@ -63,21 +63,6 @@ struct dma_map_ops *get_pci_dma_ops(void
 }
 EXPORT_SYMBOL(get_pci_dma_ops);
 
-int pci_set_dma_mask(struct pci_dev *dev, u64 mask)
-{
-	return dma_set_mask(&dev->dev, mask);
-}
-
-int pci_set_consistent_dma_mask(struct pci_dev *dev, u64 mask)
-{
-	int rc;
-
-	rc = dma_set_mask(&dev->dev, mask);
-	dev->dev.coherent_dma_mask = dev->dma_mask;
-
-	return rc;
-}
