From: akpm@linux-foundation.org
Subject: - x86-64-calgary-fix-calgary=disable=busnum-for-calioc2.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:08:07 -0700
Message-ID: <200710180708.l9I787UO031835@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37381 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759522AbXJRHIU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:08:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: muli@il.ibm.com, bernarde@br.ibm.com, mm-commits@vger.kernel.org


The patch titled
     x86-64: Calgary - fix calgary=disable=<busnum> for CalIOC2
has been removed from the -mm tree.  Its filename was
     x86-64-calgary-fix-calgary=disable=busnum-for-calioc2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86-64: Calgary - fix calgary=disable=<busnum> for CalIOC2
From: Muli Ben-Yehuda <muli@il.ibm.com>

The old check we used based on dev->bus->number is wrong for devices on
CalIOC2.  Instead look whether we have an IOMMU table for that bus - if not,
translation is disabled.

Thanks to Murillo Fernandes Bernardes <bernarde@br.ibm.com> for spotting,
suggesting a fix and testing.

Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
Acked-by: Murillo Fernandes Bernardes <bernarde@br.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/pci-calgary.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff -puN arch/x86_64/kernel/pci-calgary.c~x86-64-calgary-fix-calgary=disable=busnum-for-calioc2 arch/x86_64/kernel/pci-calgary.c
--- a/arch/x86/kernel/pci-calgary_64.c~x86-64-calgary-fix-calgary=disable=busnum-for-calioc2
+++ a/arch/x86/kernel/pci-calgary_64.c
@@ -222,6 +222,12 @@ static inline unsigned int num_dma_pages
 	return npages;
 }
 
+static inline int translation_enabled(struct iommu_table *tbl)
+{
+	/* only PHBs with translation enabled have an IOMMU table */
+	return (tbl != NULL);
+}
+
 static inline int translate_phb(struct pci_dev* dev)
 {
 	int disabled = bus_info[dev->bus->number].translation_disabled;
@@ -388,7 +394,7 @@ static void calgary_unmap_sg(struct devi
 	struct scatterlist *s;
 	int i;
 
-	if (!translate_phb(to_pci_dev(dev)))
+	if (!translation_enabled(tbl))
 		return;
 
 	for_each_sg(sglist, s, nelems, i) {
@@ -428,7 +434,7 @@ static int calgary_map_sg(struct device 
 	unsigned long entry;
 	int i;
 
-	if (!translate_phb(to_pci_dev(dev)))
+	if (!translation_enabled(tbl))
 		return calgary_nontranslate_map_sg(dev, sg, nelems, direction);
 
 	for_each_sg(sg, s, nelems, i) {
@@ -474,7 +480,7 @@ static dma_addr_t calgary_map_single(str
 	uaddr = (unsigned long)vaddr;
 	npages = num_dma_pages(uaddr, size);
 
-	if (translate_phb(to_pci_dev(dev)))
+	if (translation_enabled(tbl))
 		dma_handle = iommu_alloc(tbl, vaddr, npages, direction);
 	else
 		dma_handle = virt_to_bus(vaddr);
@@ -488,7 +494,7 @@ static void calgary_unmap_single(struct 
 	struct iommu_table *tbl = find_iommu_table(dev);
 	unsigned int npages;
 
-	if (!translate_phb(to_pci_dev(dev)))
+	if (!translation_enabled(tbl))
 		return;
 
 	npages = num_dma_pages(dma_handle, size);
@@ -513,7 +519,7 @@ static void* calgary_alloc_coherent(stru
 		goto error;
 	memset(ret, 0, size);
 
-	if (translate_phb(to_pci_dev(dev))) {
+	if (translation_enabled(tbl)) {
 		/* set up tces to cover the allocated range */
 		mapping = iommu_alloc(tbl, ret, npages, DMA_BIDIRECTIONAL);
 		if (mapping == bad_dma_address)
_

Patches currently in -mm which might be from muli@il.ibm.com are

origin.patch
unify-dma_bit_mask-definitions-v31.patch
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
