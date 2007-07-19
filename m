From: akpm@linux-foundation.org
Subject: - x86-64-calgary-abstract-how-we-find-the-iommu_table-for-a-device.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:09:11 -0700
Message-ID: <200707192009.l6JK9BHG020555@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57430 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761418AbXGSUQQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:16:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: muli@il.ibm.com, ak@suse.de, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     x86-64: Calgary: abstract how we find the iommu_table for a device
has been removed from the -mm tree.  Its filename was
     x86-64-calgary-abstract-how-we-find-the-iommu_table-for-a-device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86-64: Calgary: abstract how we find the iommu_table for a device
From: Muli Ben-Yehuda <muli@il.ibm.com>

... in preparation for doing it differently for CalIOC2.

Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/pci-calgary.c |   21 ++++++++++++++-------
 1 files changed, 14 insertions(+), 7 deletions(-)

diff -puN arch/x86_64/kernel/pci-calgary.c~x86-64-calgary-abstract-how-we-find-the-iommu_table-for-a-device arch/x86_64/kernel/pci-calgary.c
--- a/arch/x86_64/kernel/pci-calgary.c~x86-64-calgary-abstract-how-we-find-the-iommu_table-for-a-device
+++ a/arch/x86_64/kernel/pci-calgary.c
@@ -344,6 +344,15 @@ static void iommu_free(struct iommu_tabl
 	spin_unlock_irqrestore(&tbl->it_lock, flags);
 }
 
+static inline struct iommu_table *find_iommu_table(struct device *dev)
+{
+	struct iommu_table *tbl;
+
+	tbl = to_pci_dev(dev)->bus->self->sysdata;
+
+	return tbl;
+}
+
 static void __calgary_unmap_sg(struct iommu_table *tbl,
 	struct scatterlist *sglist, int nelems, int direction)
 {
@@ -365,7 +374,7 @@ void calgary_unmap_sg(struct device *dev
 		      int nelems, int direction)
 {
 	unsigned long flags;
-	struct iommu_table *tbl = to_pci_dev(dev)->bus->self->sysdata;
+	struct iommu_table *tbl = find_iommu_table(dev);
 
 	if (!translate_phb(to_pci_dev(dev)))
 		return;
@@ -394,7 +403,7 @@ static int calgary_nontranslate_map_sg(s
 int calgary_map_sg(struct device *dev, struct scatterlist *sg,
 	int nelems, int direction)
 {
-	struct iommu_table *tbl = to_pci_dev(dev)->bus->self->sysdata;
+	struct iommu_table *tbl = find_iommu_table(dev);
 	unsigned long flags;
 	unsigned long vaddr;
 	unsigned int npages;
@@ -448,7 +457,7 @@ dma_addr_t calgary_map_single(struct dev
 	dma_addr_t dma_handle = bad_dma_address;
 	unsigned long uaddr;
 	unsigned int npages;
-	struct iommu_table *tbl = to_pci_dev(dev)->bus->self->sysdata;
+	struct iommu_table *tbl = find_iommu_table(dev);
 
 	uaddr = (unsigned long)vaddr;
 	npages = num_dma_pages(uaddr, size);
@@ -464,7 +473,7 @@ dma_addr_t calgary_map_single(struct dev
 void calgary_unmap_single(struct device *dev, dma_addr_t dma_handle,
 	size_t size, int direction)
 {
-	struct iommu_table *tbl = to_pci_dev(dev)->bus->self->sysdata;
+	struct iommu_table *tbl = find_iommu_table(dev);
 	unsigned int npages;
 
 	if (!translate_phb(to_pci_dev(dev)))
@@ -480,9 +489,7 @@ void* calgary_alloc_coherent(struct devi
 	void *ret = NULL;
 	dma_addr_t mapping;
 	unsigned int npages, order;
-	struct iommu_table *tbl;
-
-	tbl = to_pci_dev(dev)->bus->self->sysdata;
+	struct iommu_table *tbl = find_iommu_table(dev);
 
 	size = PAGE_ALIGN(size); /* size rounded up to full pages */
 	npages = size >> PAGE_SHIFT;
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
