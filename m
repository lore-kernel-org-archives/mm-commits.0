From: akpm@linux-foundation.org
Subject: [merged] dma-mapping-pci-move-pci_set_dma_mask-and-pci_set_consistent_dma_mask-to-pci-dma-compath.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:03:52 -0400
Message-ID: <201003150704.o2F74P6p017015@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38067 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935969Ab0COHE3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:04:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, greg@kroah.com, jbarnes@virtuousgeek.org, kay.sievers@vrfy.org, mm-commits@vger.kernel.org


The patch titled
     dma-mapping: pci: move pci_set_dma_mask and pci_set_consistent_dma_mask to pci-dma-compat.h
has been removed from the -mm tree.  Its filename was
     dma-mapping-pci-move-pci_set_dma_mask-and-pci_set_consistent_dma_mask-to-pci-dma-compath.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dma-mapping: pci: move pci_set_dma_mask and pci_set_consistent_dma_mask to pci-dma-compat.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

We can use pci-dma-compat.h to implement pci_set_dma_mask and
pci_set_consistent_dma_mask as we do with the other PCI DMA API.

We can remove HAVE_ARCH_PCI_SET_DMA_MASK too.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pci.c                    |   28 -------------------------
 include/asm-generic/pci-dma-compat.h |   15 ++++++++++---
 include/linux/pci.h                  |    2 -
 3 files changed, 12 insertions(+), 33 deletions(-)

diff -puN drivers/pci/pci.c~dma-mapping-pci-move-pci_set_dma_mask-and-pci_set_consistent_dma_mask-to-pci-dma-compath drivers/pci/pci.c
--- a/drivers/pci/pci.c~dma-mapping-pci-move-pci_set_dma_mask-and-pci_set_consistent_dma_mask-to-pci-dma-compath
+++ a/drivers/pci/pci.c
@@ -2298,32 +2298,6 @@ void pci_msi_off(struct pci_dev *dev)
 	}
 }
 
-#ifndef HAVE_ARCH_PCI_SET_DMA_MASK
-/*
- * These can be overridden by arch-specific implementations
- */
-int
-pci_set_dma_mask(struct pci_dev *dev, u64 mask)
-{
-	int ret = dma_set_mask(&dev->dev, mask);
-	if (ret)
-		return ret;
-	dev_dbg(&dev->dev, "using %dbit DMA mask\n", fls64(mask));
-	return 0;
-}
-
-int
-pci_set_consistent_dma_mask(struct pci_dev *dev, u64 mask)
-{
-	int ret = dma_set_coherent_mask(&dev->dev, mask);
-	if (ret)
-		return ret;
-
-	dev_dbg(&dev->dev, "using %dbit consistent DMA mask\n", fls64(mask));
-	return 0;
-}
-#endif
-
 #ifndef HAVE_ARCH_PCI_SET_DMA_MAX_SEGMENT_SIZE
 int pci_set_dma_max_seg_size(struct pci_dev *dev, unsigned int size)
 {
@@ -3065,8 +3039,6 @@ EXPORT_SYMBOL(pci_set_mwi);
 EXPORT_SYMBOL(pci_try_set_mwi);
 EXPORT_SYMBOL(pci_clear_mwi);
 EXPORT_SYMBOL_GPL(pci_intx);
-EXPORT_SYMBOL(pci_set_dma_mask);
-EXPORT_SYMBOL(pci_set_consistent_dma_mask);
 EXPORT_SYMBOL(pci_assign_resource);
 EXPORT_SYMBOL(pci_find_parent_resource);
 EXPORT_SYMBOL(pci_select_bars);
diff -puN include/asm-generic/pci-dma-compat.h~dma-mapping-pci-move-pci_set_dma_mask-and-pci_set_consistent_dma_mask-to-pci-dma-compath include/asm-generic/pci-dma-compat.h
--- a/include/asm-generic/pci-dma-compat.h~dma-mapping-pci-move-pci_set_dma_mask-and-pci_set_consistent_dma_mask-to-pci-dma-compath
+++ a/include/asm-generic/pci-dma-compat.h
@@ -6,9 +6,6 @@
 
 #include <linux/dma-mapping.h>
 
-/* note pci_set_dma_mask isn't here, since it's a public function
- * exported from drivers/pci, use dma_supported instead */
-
 static inline int
 pci_dma_supported(struct pci_dev *hwdev, u64 mask)
 {
@@ -104,4 +101,16 @@ pci_dma_mapping_error(struct pci_dev *pd
 	return dma_mapping_error(&pdev->dev, dma_addr);
 }
 
+#ifdef CONFIG_PCI
+static inline int pci_set_dma_mask(struct pci_dev *dev, u64 mask)
+{
+	return dma_set_mask(&dev->dev, mask);
+}
+
+static inline int pci_set_consistent_dma_mask(struct pci_dev *dev, u64 mask)
+{
+	return dma_set_coherent_mask(&dev->dev, mask);
+}
+#endif
+
 #endif
diff -puN include/linux/pci.h~dma-mapping-pci-move-pci_set_dma_mask-and-pci_set_consistent_dma_mask-to-pci-dma-compath include/linux/pci.h
--- a/include/linux/pci.h~dma-mapping-pci-move-pci_set_dma_mask-and-pci_set_consistent_dma_mask-to-pci-dma-compath
+++ a/include/linux/pci.h
@@ -769,8 +769,6 @@ int pci_try_set_mwi(struct pci_dev *dev)
 void pci_clear_mwi(struct pci_dev *dev);
 void pci_intx(struct pci_dev *dev, int enable);
 void pci_msi_off(struct pci_dev *dev);
-int pci_set_dma_mask(struct pci_dev *dev, u64 mask);
-int pci_set_consistent_dma_mask(struct pci_dev *dev, u64 mask);
 int pci_set_dma_max_seg_size(struct pci_dev *dev, unsigned int size);
 int pci_set_dma_seg_boundary(struct pci_dev *dev, unsigned long mask);
 int pcix_get_max_mmrbc(struct pci_dev *dev);
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

origin.patch
linux-next.patch
scsi-add-__init-__exit-macros-to-ibmvstgtc.patch
ssb-add-dma_dev-to-ssb_device-structure.patch
b43legacy-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b43-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b44-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
ssb-remove-the-ssb-dma-api.patch

