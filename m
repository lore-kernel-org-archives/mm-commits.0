From: akpm@linux-foundation.org
Subject: + x86-64-calgary-fold-in-redundant-functions.patch added to -mm tree
Date: Wed, 11 Jul 2007 17:42:56 -0700
Message-ID: <200707120042.l6C0guZi030792@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45952 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763755AbXGLAnI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jul 2007 20:43:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: muli@il.ibm.com, ak@suse.de


The patch titled
     x86-64: Calgary - fold in redundant functions
has been added to the -mm tree.  Its filename is
     x86-64-calgary-fold-in-redundant-functions.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

x86-64-calgary-generalize-calgary_increase_split_completion_timeout.patch
x86-64-calgary-update-copyright-notice.patch
x86-64-calgary-introduce-handle_quirks-for-various-chipset-quirks.patch
x86-64-calgary-introduce-chipset-specific-ops.patch
x86-64-calgary-abstract-how-we-find-the-iommu_table-for-a-device.patch
x86-64-calgary-introduce-calioc2-support.patch
x86-64-calgary-add-chip_ops-and-a-quirk-function-for-calioc2.patch
x86-64-calgary-implement-calioc2-tce-cache-flush-sequence.patch
x86-64-calgary-make-dump_error_regs-a-chip-op.patch
x86-64-calgary-grab-plssr-too-when-a-dma-error-occurs.patch
x86-64-calgary-reserve-tces-with-the-same-address-as-mem-regions.patch
x86-64-calgary-cleanup-of-unneeded-macros.patch
x86-64-calgary-tabify-and-trim-trailing-whitespace.patch
x86-64-calgary-only-reserve-the-first-1mb-of-io-space-for-calioc2.patch
x86-64-calgary-tidy-up-debug-printks.patch
x86-64-calgary-fix-few-style-problems-pointed-out-by-checkpatchpl.patch
x86-64-calgary-tighten-up-the-bitmap-locking.patch
x86-64-calgary-fold-in-redundant-functions.patch
x86_64-calgary-change-_map_single-etc-to-static.patch
x86-64-disable-the-gart-in-shutdown.patch
x86_84-move-iommu-declaration-from-proto-to-iommuh.patch
oss-trident-massive-whitespace-removal.patch
oss-trident-fix-locking-around-write_voice_regs.patch
oss-trident-replace-deprecated-pci_find_device-with-pci_get_device.patch
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
