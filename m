From: akpm@linux-foundation.org
Subject: - x86-64-calgary-fold-in-redundant-functions.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:09:40 -0700
Message-ID: <200707192009.l6JK9ev2020599@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40547 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760924AbXGSUPa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: muli@il.ibm.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     x86-64: Calgary - fold in redundant functions
has been removed from the -mm tree.  Its filename was
     x86-64-calgary-fold-in-redundant-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86-64: Calgary - fold in redundant functions
From: Muli Ben-Yehuda <muli@il.ibm.com>

After the bitmap changes we can get rid of the unlocked versions of
calgary_unmap_sg and iommu_free. Fold __calgary_unmap_sg and
__iommu_free into their calgary_unmap_sg and iommu_free, respectively.

Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/pci-calgary.c |   30 ++++++++---------------------
 1 files changed, 9 insertions(+), 21 deletions(-)

diff -puN arch/x86_64/kernel/pci-calgary.c~x86-64-calgary-fold-in-redundant-functions arch/x86_64/kernel/pci-calgary.c
--- a/arch/x86_64/kernel/pci-calgary.c~x86-64-calgary-fold-in-redundant-functions
+++ a/arch/x86_64/kernel/pci-calgary.c
@@ -321,7 +321,7 @@ error:
 	return bad_dma_address;
 }
 
-static void __iommu_free(struct iommu_table *tbl, dma_addr_t dma_addr,
+static void iommu_free(struct iommu_table *tbl, dma_addr_t dma_addr,
 	unsigned int npages)
 {
 	unsigned long entry;
@@ -359,12 +359,6 @@ static void __iommu_free(struct iommu_ta
 	spin_unlock_irqrestore(&tbl->it_lock, flags);
 }
 
-static void iommu_free(struct iommu_table *tbl, dma_addr_t dma_addr,
-	unsigned int npages)
-{
-	__iommu_free(tbl, dma_addr, npages);
-}
-
 static inline struct iommu_table *find_iommu_table(struct device *dev)
 {
 	struct pci_dev *pdev;
@@ -387,9 +381,14 @@ static inline struct iommu_table *find_i
 	return tbl;
 }
 
-static void __calgary_unmap_sg(struct iommu_table *tbl,
+static void calgary_unmap_sg(struct device *dev,
 	struct scatterlist *sglist, int nelems, int direction)
 {
+	struct iommu_table *tbl = find_iommu_table(dev);
+
+	if (!translate_phb(to_pci_dev(dev)))
+		return;
+
 	while (nelems--) {
 		unsigned int npages;
 		dma_addr_t dma = sglist->dma_address;
@@ -399,22 +398,11 @@ static void __calgary_unmap_sg(struct io
 			break;
 
 		npages = num_dma_pages(dma, dmalen);
-		__iommu_free(tbl, dma, npages);
+		iommu_free(tbl, dma, npages);
 		sglist++;
 	}
 }
 
-void calgary_unmap_sg(struct device *dev, struct scatterlist *sglist,
-		      int nelems, int direction)
-{
-	struct iommu_table *tbl = find_iommu_table(dev);
-
-	if (!translate_phb(to_pci_dev(dev)))
-		return;
-
-	__calgary_unmap_sg(tbl, sglist, nelems, direction);
-}
-
 static int calgary_nontranslate_map_sg(struct device* dev,
 	struct scatterlist *sg, int nelems, int direction)
 {
@@ -466,7 +454,7 @@ int calgary_map_sg(struct device *dev, s
 
 	return nelems;
 error:
-	__calgary_unmap_sg(tbl, sg, nelems, direction);
+	calgary_unmap_sg(dev, sg, nelems, direction);
 	for (i = 0; i < nelems; i++) {
 		sg[i].dma_address = bad_dma_address;
 		sg[i].dma_length = 0;
_

Patches currently in -mm which might be from muli@il.ibm.com are

origin.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
