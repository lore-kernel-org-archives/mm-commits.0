From: akpm@linux-foundation.org
Subject: + dma-mapping-pci-move-pci_set_dma_mask-and-pci_set_consistent_dma_mask-to-pci-dma-compath.patch added to -mm tree
Date: Tue, 02 Mar 2010 19:06:52 -0800
Message-ID: <201003030306.o2336qLw016021@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41661 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751963Ab0CCDH0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Mar 2010 22:07:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, greg@kroah.com, jbarnes@virtuousgeek.org, kay.sievers@vrfy.org


The patch titled
     dma-mapping: pci: move pci_set_dma_mask and pci_set_consistent_dma_mask to pci-dma-compat.h
has been added to the -mm tree.  Its filename is
     dma-mapping-pci-move-pci_set_dma_mask-and-pci_set_consistent_dma_mask-to-pci-dma-compath.patch

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
 include/asm-generic/pci-dma-compat.h |   13 ++++++++---
 include/linux/pci.h                  |    2 -
 3 files changed, 10 insertions(+), 33 deletions(-)

diff -puN drivers/pci/pci.c~dma-mapping-pci-move-pci_set_dma_mask-and-pci_set_consistent_dma_mask-to-pci-dma-compath drivers/pci/pci.c
--- a/drivers/pci/pci.c~dma-mapping-pci-move-pci_set_dma_mask-and-pci_set_consistent_dma_mask-to-pci-dma-compath
+++ a/drivers/pci/pci.c
@@ -2307,32 +2307,6 @@ void pci_msi_off(struct pci_dev *dev)
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
@@ -3073,8 +3047,6 @@ EXPORT_SYMBOL(pci_set_mwi);
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
@@ -104,4 +101,14 @@ pci_dma_mapping_error(struct pci_dev *pd
 	return dma_mapping_error(&pdev->dev, dma_addr);
 }
 
+static inline int pci_set_dma_mask(struct pci_dev *dev, u64 mask)
+{
+	return dma_set_mask(&dev->dev, mask);
+}
+
+static inline int pci_set_consistent_dma_mask(struct pci_dev *dev, u64 mask)
+{
+	return dma_set_coherent_mask(&dev->dev, mask);
+}
+
 #endif
diff -puN include/linux/pci.h~dma-mapping-pci-move-pci_set_dma_mask-and-pci_set_consistent_dma_mask-to-pci-dma-compath include/linux/pci.h
--- a/include/linux/pci.h~dma-mapping-pci-move-pci_set_dma_mask-and-pci_set_consistent_dma_mask-to-pci-dma-compath
+++ a/include/linux/pci.h
@@ -770,8 +770,6 @@ int pci_try_set_mwi(struct pci_dev *dev)
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
frv-remove-pci_dma_sync_single-and-pci_dma_sync_sg.patch
documentation-dma-apitxt-remove-deprecated-function-descriptions.patch
dma-apitxt-add-dma_sync_single-sg-api-description.patch
dma-apitxt-remove-dma_sync_single_range-description.patch
alpha-remove-dma_sync_single_range.patch
um-remove-dma_sync_single_range.patch
pci-dma-add-include-linux-pci-dmah.patch
pci-dma-x86-use-include-linux-pci-dmah.patch
pci-dma-alpha-use-include-linux-pci-dmah.patch
pci-dma-arm-use-include-linux-pci-dmah.patch
pci-dma-frv-use-include-linux-pci-dmah.patch
pci-dma-ia64-use-include-linux-pci-dmah.patch
pci-dma-mips-use-include-linux-pci-dmah.patch
pci-dma-parisc-use-include-linux-pci-dmah.patch
pci-dma-powerpc-use-include-linux-pci-dmah.patch
pci-dma-sh-use-include-linux-pci-dmah.patch
pci-dma-sparc-use-include-linux-pci-dmah.patch
pci-dma-xtensa-use-include-linux-pci-dmah.patch
pci-dma-cris-use-include-linux-pci-dmah.patch
pci-dma-add-linux-pci-dmah-to-linux-pcih.patch
dma-mappingh-add-the-dma_unmap-state-api.patch
frv-remove-the-obsolete-and-unnecessary-dma-api-comments.patch
frv-remove-the-obsolete-and-unnecessary-dma-api-comments-fix.patch
blackfin-remove-the-obsolete-and-unnecessary-dma-api-comments.patch
mn10300-remove-the-obsolete-and-unnecessary-dma-api-comments.patch
mn10300-remove-the-obsolete-and-unnecessary-dma-api-comments-fix.patch
dma-mapping-sparc-unify-32bit-and-64bit-dma_set_mask.patch
dma-mapping-alpha-use-include-linux-pci-dma-compath.patch
dma-mapping-pci-convert-pci_set_dma_mask-to-call-dma_set_mask.patch
dma-mapping-dma-mappingh-add-dma_set_coherent_mask.patch
dma-mapping-powerpc-use-generic-pci_set_dma_mask-and-pci_set_consistent_dma_mask.patch
dma-mapping-arm-use-generic-pci_set_dma_mask-and-pci_set_consistent_dma_mask.patch
dma-mapping-pci-move-pci_set_dma_mask-and-pci_set_consistent_dma_mask-to-pci-dma-compath.patch
dma-mapping-pci-move-pci_set_dma_mask-and-pci_set_consistent_dma_mask-to-pci-dma-compath-fix.patch
ssb-add-dma_dev-to-ssb_device-structure.patch
b43legacy-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b43-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b44-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
ssb-remove-the-ssb-dma-api.patch

