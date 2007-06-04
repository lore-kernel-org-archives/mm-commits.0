From: akpm@linux-foundation.org
Subject: + x86-64-calgary-abstract-how-we-find-the-iommu_table-for-a-device.patch added to -mm tree
Date: Mon, 04 Jun 2007 11:54:03 -0700
Message-ID: <200706041854.l54Is3F1010918@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49341 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758552AbXFDSym (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jun 2007 14:54:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: muli@il.ibm.com, ak@suse.de


The patch titled
     x86-64: Calgary: abstract how we find the iommu_table for a device
has been added to the -mm tree.  Its filename is
     x86-64-calgary-abstract-how-we-find-the-iommu_table-for-a-device.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86-64: Calgary: abstract how we find the iommu_table for a device
From: Muli Ben-Yehuda <muli@il.ibm.com>

... in preparation for doing it differently for CalIOC2.

Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Andi Kleen <ak@suse.de>
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

x86-64-calgary-generalize-calgary_increase_split_completion_timeout.patch
x86-64-calgary-update-copyright-notice.patch
x86-64-calgary-introduce-handle_quirks-for-various-chipset-quirks.patch
x86-64-calgary-introduce-chipset-specific-ops.patch
x86-64-calgary-introduce-chipset-specific-ops-fix.patch
x86-64-calgary-abstract-how-we-find-the-iommu_table-for-a-device.patch
x86-64-calgary-introduce-calioc2-support.patch
x86-64-calgary-add-chip_ops-and-a-quirk-function-for-calioc2.patch
x86-64-calgary-add-chip_ops-and-a-quirk-function-for-calioc2-fix.patch
x86-64-calgary-implement-calioc2-tce-cache-flush-sequence.patch
x86-64-calgary-make-dump_error_regs-a-chip-op.patch
x86-64-calgary-grab-plssr-too-when-a-dma-error-occurs.patch
x86-64-calgary-reserve-tces-with-the-same-address-as-mem-regions.patch
x86-64-calgary-reserve-tces-with-the-same-address-as-mem-regions-fix.patch
x86-64-calgary-cleanup-of-unneeded-macros.patch
x86-64-calgary-tabify-and-trim-trailing-whitespace.patch
x86-64-calgary-only-reserve-the-first-1mb-of-io-space-for-calioc2.patch
x86-64-calgary-tidy-up-debug-printks.patch
oss-trident-massive-whitespace-removal.patch
oss-trident-fix-locking-around-write_voice_regs.patch
oss-trident-replace-deprecated-pci_find_device-with-pci_get_device.patch
