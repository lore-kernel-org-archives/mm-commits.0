From: akpm@linux-foundation.org
Subject: + intel-iommu-optimize-sg-map-unmap-calls.patch added to -mm tree
Date: Wed, 01 Aug 2007 16:45:58 -0700
Message-ID: <200708012345.l71NjwME023442@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39843 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755427AbXHAXqv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2007 19:46:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anil.s.keshavamurthy@intel.com, ak@suse.de, arjan@infradead.org, ashok.raj@intel.com, greg@kroah.com, suresh.b.siddha@intel.com


The patch titled
     intel-iommu: optimize sg map/unmap calls
has been added to the -mm tree.  Its filename is
     intel-iommu-optimize-sg-map-unmap-calls.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: intel-iommu: optimize sg map/unmap calls
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>

This patch adds PageSelectiveInvalidation support replacing existing
DomainSelectiveInvalidation for intel_{map/unmap}_sg() calls and also
enables to mapping one big contiguous DMA virtual address which is mapped
to discontiguous physical address for SG map/unmap calls.

"Doamin selective invalidations" wipes out the IOMMU address translation
cache based on domain ID where as "Page selective invalidations" wipes out
the IOMMU address translation cache for that address mask range which is
more cache friendly when compared to Domain selective invalidations.

Here is how it is done.
1) changes to iova.c
alloc_iova() now takes a bool size_aligned argument, which
when when set, returns the io virtual address that is
naturally aligned to 2 ^ x, where x is the order
of the size requested.

Returning this io vitual address which is naturally
aligned helps iommu to do the "page selective
invalidations" which is IOMMU cache friendly
over "domain selective invalidations".

2) Changes to driver/pci/intel-iommu.c
Clean up intel_{map/unmap}_{single/sg} () calls so that
s/g map/unamp calls is no more dependent on
intel_{map/unmap}_single()

intel_map_sg() now computes the total DMA virtual address
required and allocates the size aligned total DMA virtual address
and maps the discontiguous physical address to the allocated
contiguous DMA virtual address.

In the intel_unmap_sg() case since the DMA virtual address
is contiguous and size_aligned, PageSelectiveInvalidation
is used replacing earlier DomainSelectiveInvalidations.

Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: Greg KH <greg@kroah.com>
Cc: Ashok Raj <ashok.raj@intel.com>
Cc: Suresh B <suresh.b.siddha@intel.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/intel-iommu.c |  325 +++++++++++++++++++-----------------
 drivers/pci/iova.c        |   63 +++++-
 drivers/pci/iova.h        |    3 
 3 files changed, 231 insertions(+), 160 deletions(-)

diff -puN drivers/pci/intel-iommu.c~intel-iommu-optimize-sg-map-unmap-calls drivers/pci/intel-iommu.c
--- a/drivers/pci/intel-iommu.c~intel-iommu-optimize-sg-map-unmap-calls
+++ a/drivers/pci/intel-iommu.c
@@ -665,24 +665,10 @@ static int inline iommu_flush_iotlb_dsi(
 		non_present_entry_flush);
 }
 
-static int iommu_get_alignment(u64 base, unsigned int size)
-{
-	int t = 0;
-	u64 end;
-
-	end = base + size - 1;
-	while (base != end) {
-		t++;
-		base >>= 1;
-		end >>= 1;
-	}
-	return t;
-}
-
 static int iommu_flush_iotlb_psi(struct intel_iommu *iommu, u16 did,
 	u64 addr, unsigned int pages, int non_present_entry_flush)
 {
-	unsigned int align;
+	unsigned int mask;
 
 	BUG_ON(addr & (~PAGE_MASK_4K));
 	BUG_ON(pages == 0);
@@ -696,16 +682,13 @@ static int iommu_flush_iotlb_psi(struct 
 	 * PSI requires page size to be 2 ^ x, and the base address is naturally
 	 * aligned to the size
 	 */
-	align = iommu_get_alignment(addr >> PAGE_SHIFT_4K, pages);
+	mask = ilog2(__roundup_pow_of_two(pages));
 	/* Fallback to domain selective flush if size is too big */
-	if (align > cap_max_amask_val(iommu->cap))
+	if (mask > cap_max_amask_val(iommu->cap))
 		return iommu_flush_iotlb_dsi(iommu, did,
 			non_present_entry_flush);
 
-	addr >>= PAGE_SHIFT_4K + align;
-	addr <<= PAGE_SHIFT_4K + align;
-
-	return __iommu_flush_iotlb(iommu, did, addr, align,
+	return __iommu_flush_iotlb(iommu, did, addr, mask,
 		DMA_TLB_PSI_FLUSH, non_present_entry_flush);
 }
 
@@ -1772,78 +1755,103 @@ static inline u64 aligned_size(u64 host_
 }
 
 struct iova *
-iommu_alloc_iova(struct dmar_domain *domain, void *host_addr, size_t size,
-		u64 start, u64 end)
+iommu_alloc_iova(struct dmar_domain *domain, size_t size, u64 end)
 {
-	u64 start_addr;
 	struct iova *piova;
 
 	/* Make sure it's in range */
-	if ((start > DOMAIN_MAX_ADDR(domain->gaw)) || end < start)
-		return NULL;
-
 	end = min_t(u64, DOMAIN_MAX_ADDR(domain->gaw), end);
-	start_addr = PAGE_ALIGN_4K(start);
-	size = aligned_size((u64)host_addr, size);
-	if (!size || (start_addr + size > end))
+	if (!size || (IOVA_START_ADDR + size > end))
 		return NULL;
 
 	piova = alloc_iova(&domain->iovad,
-			size >> PAGE_SHIFT_4K, IOVA_PFN(end));
-
+			size >> PAGE_SHIFT_4K, IOVA_PFN(end), 1);
 	return piova;
 }
 
-static dma_addr_t __intel_map_single(struct device *dev, void *addr,
-	size_t size, int dir, u64 *flush_addr, unsigned int *flush_size)
+static struct iova *
+__intel_alloc_iova(struct device *dev, struct dmar_domain *domain,
+		size_t size)
 {
-	struct dmar_domain *domain;
 	struct pci_dev *pdev = to_pci_dev(dev);
-	int ret;
-	int prot = 0;
 	struct iova *iova = NULL;
-	u64 start_addr;
-
-	addr = (void *)virt_to_phys(addr);
-
-	domain = get_domain_for_dev(pdev,
-			DEFAULT_DOMAIN_ADDRESS_WIDTH);
-	if (!domain) {
-		printk(KERN_ERR
-			"Allocating domain for %s failed", pci_name(pdev));
-		return 0;
-	}
-
-	start_addr = IOVA_START_ADDR;
 
 	if ((pdev->dma_mask <= DMA_32BIT_MASK) || (dmar_forcedac)) {
-		iova = iommu_alloc_iova(domain, addr, size, start_addr,
-			pdev->dma_mask);
+		iova = iommu_alloc_iova(domain, size, pdev->dma_mask);
 	} else  {
 		/*
 		 * First try to allocate an io virtual address in
 		 * DMA_32BIT_MASK and if that fails then try allocating
 		 * from higer range
 		 */
-		iova = iommu_alloc_iova(domain, addr, size, start_addr,
-			DMA_32BIT_MASK);
+		iova = iommu_alloc_iova(domain, size, DMA_32BIT_MASK);
 		if (!iova)
-			iova = iommu_alloc_iova(domain, addr, size, start_addr,
-			pdev->dma_mask);
+			iova = iommu_alloc_iova(domain, size, pdev->dma_mask);
 	}
 
 	if (!iova) {
 		printk(KERN_ERR"Allocating iova for %s failed", pci_name(pdev));
+		return NULL;
+	}
+
+	return iova;
+}
+
+static struct dmar_domain *
+get_valid_domain_for_dev(struct pci_dev *pdev)
+{
+	struct dmar_domain *domain;
+	int ret;
+
+	domain = get_domain_for_dev(pdev,
+			DEFAULT_DOMAIN_ADDRESS_WIDTH);
+	if (!domain) {
+		printk(KERN_ERR
+			"Allocating domain for %s failed", pci_name(pdev));
 		return 0;
 	}
 
 	/* make sure context mapping is ok */
 	if (unlikely(!domain_context_mapped(domain, pdev))) {
 		ret = domain_context_mapping(domain, pdev);
-		if (ret)
-			goto error;
+		if (ret) {
+			printk(KERN_ERR
+				"Domain context map for %s failed",
+				pci_name(pdev));
+			return 0;
+		}
 	}
 
+	return domain;
+}
+
+static dma_addr_t intel_map_single(struct device *hwdev, void *addr,
+	size_t size, int dir)
+{
+	struct pci_dev *pdev = to_pci_dev(hwdev);
+	int ret;
+	struct dmar_domain *domain;
+	unsigned long start_addr;
+	struct iova *iova;
+	int prot = 0;
+
+	BUG_ON(dir == DMA_NONE);
+	if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO)
+		return virt_to_bus(addr);
+
+	domain = get_valid_domain_for_dev(pdev);
+	if (!domain)
+		return 0;
+
+	addr = (void *)virt_to_phys(addr);
+	size = aligned_size((u64)addr, size);
+
+	iova = __intel_alloc_iova(hwdev, domain, size);
+	if (!iova)
+		goto error;
+
+	start_addr = iova->pfn_lo << PAGE_SHIFT_4K;
+
 	/*
 	 * Check if DMAR supports zero-length reads on write only
 	 * mappings..
@@ -1859,101 +1867,65 @@ static dma_addr_t __intel_map_single(str
 	 * might have two guest_addr mapping to the same host addr, but this
 	 * is not a big problem
 	 */
-	ret = domain_page_mapping(domain, iova->pfn_lo << PAGE_SHIFT_4K,
-		((u64)addr) & PAGE_MASK_4K,
-		(iova->pfn_hi - iova->pfn_lo + 1) << PAGE_SHIFT_4K, prot);
+	ret = domain_page_mapping(domain, start_addr,
+		((u64)addr) & PAGE_MASK_4K, size, prot);
 	if (ret)
 		goto error;
 
 	pr_debug("Device %s request: %lx@%llx mapping: %lx@%llx, dir %d\n",
 		pci_name(pdev), size, (u64)addr,
-		(iova->pfn_hi - iova->pfn_lo + 1) << PAGE_SHIFT_4K,
-		(u64)(iova->pfn_lo << PAGE_SHIFT_4K), dir);
+		size, (u64)start_addr, dir);
+
+	/* it's a non-present to present mapping */
+	ret = iommu_flush_iotlb_psi(domain->iommu, domain->id,
+			start_addr, size >> PAGE_SHIFT_4K, 1);
+	if (ret)
+		iommu_flush_write_buffer(domain->iommu);
+
+	return (start_addr + ((u64)addr & (~PAGE_MASK_4K)));
 
-	*flush_addr = iova->pfn_lo << PAGE_SHIFT_4K;
-	*flush_size = (iova->pfn_hi - iova->pfn_lo + 1) << PAGE_SHIFT_4K;
-	return (iova->pfn_lo << PAGE_SHIFT_4K) + ((u64)addr & (~PAGE_MASK_4K));
 error:
-	__free_iova(&domain->iovad, iova);
+	if (iova)
+		__free_iova(&domain->iovad, iova);
 	printk(KERN_ERR"Device %s request: %lx@%llx dir %d --- failed\n",
 		pci_name(pdev), size, (u64)addr, dir);
 	return 0;
 }
 
-static dma_addr_t intel_map_single(struct device *hwdev, void *addr,
+static void intel_unmap_single(struct device *dev, dma_addr_t dev_addr,
 	size_t size, int dir)
 {
-	struct pci_dev *pdev = to_pci_dev(hwdev);
-	dma_addr_t ret;
-	struct dmar_domain *domain;
-	u64 flush_addr;
-	unsigned int flush_size;
-
-	BUG_ON(dir == DMA_NONE);
-	if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO)
-		return virt_to_bus(addr);
-
-	ret = __intel_map_single(hwdev, addr, size,
-			dir, &flush_addr, &flush_size);
-	if (ret) {
-		domain = find_domain(pdev);
-		/* it's a non-present to present mapping */
-		if (iommu_flush_iotlb_psi(domain->iommu, domain->id,
-				flush_addr, flush_size >> PAGE_SHIFT_4K, 1))
-			iommu_flush_write_buffer(domain->iommu);
-	}
-	return ret;
-}
-
-static void __intel_unmap_single(struct device *dev, dma_addr_t dev_addr,
-	size_t size, int dir, u64 *flush_addr, unsigned int *flush_size)
-{
-	struct dmar_domain *domain;
 	struct pci_dev *pdev = to_pci_dev(dev);
+	struct dmar_domain *domain;
+	unsigned long start_addr;
 	struct iova *iova;
 
+	if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO)
+		return;
 	domain = find_domain(pdev);
 	BUG_ON(!domain);
 
 	iova = find_iova(&domain->iovad, IOVA_PFN(dev_addr));
-	if (!iova) {
-		*flush_size = 0;
+	if (!iova)
 		return;
-	}
-	pr_debug("Device %s unmapping: %lx@%llx\n",
-		pci_name(pdev),
-		(iova->pfn_hi - iova->pfn_lo + 1) << PAGE_SHIFT_4K,
-		(u64)(iova->pfn_lo << PAGE_SHIFT_4K));
-
-	*flush_addr = iova->pfn_lo << PAGE_SHIFT_4K;
-	*flush_size = (iova->pfn_hi - iova->pfn_lo + 1) << PAGE_SHIFT_4K;
-	/*  clear the whole page, not just dev_addr - (dev_addr + size) */
-	dma_pte_clear_range(domain, *flush_addr, *flush_addr + *flush_size);
-	/* free page tables */
-	dma_pte_free_pagetable(domain, *flush_addr, *flush_addr + *flush_size);
-	/* free iova */
-	__free_iova(&domain->iovad, iova);
-}
 
-static void intel_unmap_single(struct device *dev, dma_addr_t dev_addr,
-	size_t size, int dir)
-{
-	struct pci_dev *pdev = to_pci_dev(dev);
-	struct dmar_domain *domain;
-	u64 flush_addr;
-	unsigned int flush_size;
+	start_addr = iova->pfn_lo << PAGE_SHIFT_4K;
+	size = aligned_size((u64)dev_addr, size);
 
-	if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO)
-		return;
+	pr_debug("Device %s unmapping: %lx@%llx\n",
+		pci_name(pdev), size, (u64)start_addr);
 
-	domain = find_domain(pdev);
-	__intel_unmap_single(dev, dev_addr, size,
-		dir, &flush_addr, &flush_size);
-	if (flush_size == 0)
-		return;
-	if (iommu_flush_iotlb_psi(domain->iommu, domain->id, flush_addr,
-			flush_size >> PAGE_SHIFT_4K, 0))
+	/*  clear the whole page */
+	dma_pte_clear_range(domain, start_addr, start_addr + size);
+	/* free page tables */
+	dma_pte_free_pagetable(domain, start_addr, start_addr + size);
+
+	if (iommu_flush_iotlb_psi(domain->iommu, domain->id, start_addr,
+			size >> PAGE_SHIFT_4K, 0))
 		iommu_flush_write_buffer(domain->iommu);
+
+	/* free iova */
+	__free_iova(&domain->iovad, iova);
 }
 
 static void * intel_alloc_coherent(struct device *hwdev, size_t size,
@@ -1990,28 +1962,46 @@ static void intel_free_coherent(struct d
 	free_pages((unsigned long)vaddr, order);
 }
 
+#define SG_ENT_VIRT_ADDRESS(sg)	(page_address((sg)->page) + (sg)->offset)
 static void intel_unmap_sg(struct device *hwdev, struct scatterlist *sg,
 	int nelems, int dir)
 {
 	int i;
 	struct pci_dev *pdev = to_pci_dev(hwdev);
 	struct dmar_domain *domain;
-	u64 flush_addr;
-	unsigned int flush_size;
+	unsigned long start_addr;
+	struct iova *iova;
+	size_t size = 0;
+	void *addr;
 
 	if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO)
 		return;
 
 	domain = find_domain(pdev);
-	for (i = 0; i < nelems; i++, sg++)
-		__intel_unmap_single(hwdev, sg->dma_address,
-			sg->dma_length, dir, &flush_addr, &flush_size);
 
-	if (iommu_flush_iotlb_dsi(domain->iommu, domain->id, 0))
+	iova = find_iova(&domain->iovad, IOVA_PFN(sg[0].dma_address));
+	if (!iova)
+		return;
+	for (i = 0; i < nelems; i++, sg++) {
+		addr = SG_ENT_VIRT_ADDRESS(sg);
+		size += aligned_size((u64)addr, sg->length);
+	}
+
+	start_addr = iova->pfn_lo << PAGE_SHIFT_4K;
+
+	/*  clear the whole page */
+	dma_pte_clear_range(domain, start_addr, start_addr + size);
+	/* free page tables */
+	dma_pte_free_pagetable(domain, start_addr, start_addr + size);
+
+	if (iommu_flush_iotlb_psi(domain->iommu, domain->id, start_addr,
+			size >> PAGE_SHIFT_4K, 0))
 		iommu_flush_write_buffer(domain->iommu);
+
+	/* free iova */
+	__free_iova(&domain->iovad, iova);
 }
 
-#define SG_ENT_VIRT_ADDRESS(sg)	(page_address((sg)->page) + (sg)->offset)
 static int intel_nontranslate_map_sg(struct device *hddev,
 	struct scatterlist *sg, int nelems, int dir)
 {
@@ -2031,33 +2021,76 @@ static int intel_map_sg(struct device *h
 {
 	void *addr;
 	int i;
-	dma_addr_t dma_handle;
 	struct pci_dev *pdev = to_pci_dev(hwdev);
 	struct dmar_domain *domain;
-	u64 flush_addr;
-	unsigned int flush_size;
+	size_t size = 0;
+	int prot = 0;
+	size_t offset = 0;
+	struct iova *iova = NULL;
+	int ret;
+	struct scatterlist *orig_sg = sg;
+	unsigned long start_addr;
 
 	BUG_ON(dir == DMA_NONE);
 	if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO)
 		return intel_nontranslate_map_sg(hwdev, sg, nelems, dir);
 
+	domain = get_valid_domain_for_dev(pdev);
+	if (!domain)
+		return 0;
+
 	for (i = 0; i < nelems; i++, sg++) {
 		addr = SG_ENT_VIRT_ADDRESS(sg);
-		dma_handle = __intel_map_single(hwdev, addr,
-				sg->length, dir, &flush_addr, &flush_size);
-		if (!dma_handle) {
-			intel_unmap_sg(hwdev, sg - i, i, dir);
-			sg[0].dma_length = 0;
+		addr = (void *)virt_to_phys(addr);
+		size += aligned_size((u64)addr, sg->length);
+	}
+
+	iova = __intel_alloc_iova(hwdev, domain, size);
+	if (!iova) {
+		orig_sg->dma_length = 0;
+		return 0;
+	}
+
+	/*
+	 * Check if DMAR supports zero-length reads on write only
+	 * mappings..
+	 */
+	if (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL || \
+			!cap_zlr(domain->iommu->cap))
+		prot |= DMA_PTE_READ;
+	if (dir == DMA_FROM_DEVICE || dir == DMA_BIDIRECTIONAL)
+		prot |= DMA_PTE_WRITE;
+
+	start_addr = iova->pfn_lo << PAGE_SHIFT_4K;
+	offset = 0;
+	sg = orig_sg;
+	for (i = 0; i < nelems; i++, sg++) {
+		addr = SG_ENT_VIRT_ADDRESS(sg);
+		addr = (void *)virt_to_phys(addr);
+		size = aligned_size((u64)addr, sg->length);
+		ret = domain_page_mapping(domain, start_addr + offset,
+			((u64)addr) & PAGE_MASK_4K,
+			size, prot);
+		if (ret) {
+			/*  clear the page */
+			dma_pte_clear_range(domain, start_addr,
+				  start_addr + offset);
+			/* free page tables */
+			dma_pte_free_pagetable(domain, start_addr,
+				  start_addr + offset);
+			/* free iova */
+			__free_iova(&domain->iovad, iova);
 			return 0;
 		}
-		sg->dma_address = dma_handle;
+		sg->dma_address = start_addr + offset +
+				((u64)addr & (~PAGE_MASK_4K));
 		sg->dma_length = sg->length;
+		offset += size;
 	}
 
-	domain = find_domain(pdev);
-
 	/* it's a non-present to present mapping */
-	if (iommu_flush_iotlb_dsi(domain->iommu, domain->id, 1))
+	if (iommu_flush_iotlb_psi(domain->iommu, domain->id,
+			start_addr, offset >> PAGE_SHIFT_4K, 1))
 		iommu_flush_write_buffer(domain->iommu);
 	return nelems;
 }
diff -puN drivers/pci/iova.c~intel-iommu-optimize-sg-map-unmap-calls drivers/pci/iova.c
--- a/drivers/pci/iova.c~intel-iommu-optimize-sg-map-unmap-calls
+++ a/drivers/pci/iova.c
@@ -57,12 +57,28 @@ __cached_rbnode_delete_update(struct iov
 		iovad->cached32_node = rb_next(&free->node);
 }
 
-static int __alloc_iova_range(struct iova_domain *iovad,
-	unsigned long size, unsigned long limit_pfn, struct iova *new)
+/* Computes the padding size required, to make the
+ * the start address naturally aligned on its size
+ */
+static int
+iova_get_pad_size(int size, unsigned int limit_pfn)
+{
+	unsigned int pad_size = 0;
+	unsigned int order = ilog2(size);
+
+	if (order)
+		pad_size = (limit_pfn + 1) % (1 << order);
+
+	return pad_size;
+}
+
+static int __alloc_iova_range(struct iova_domain *iovad, unsigned long size,
+		unsigned long limit_pfn, struct iova *new, bool size_aligned)
 {
 	struct rb_node *curr = NULL;
 	unsigned long flags;
 	unsigned long saved_pfn;
+	unsigned int pad_size = 0;
 
 	/* Walk the tree backwards */
 	spin_lock_irqsave(&iovad->iova_rbtree_lock, flags);
@@ -72,22 +88,32 @@ static int __alloc_iova_range(struct iov
 		struct iova *curr_iova = container_of(curr, struct iova, node);
 		if (limit_pfn < curr_iova->pfn_lo)
 			goto move_left;
-		if (limit_pfn < curr_iova->pfn_hi)
+		else if (limit_pfn < curr_iova->pfn_hi)
 			goto adjust_limit_pfn;
-		if ((curr_iova->pfn_hi + size) <= limit_pfn)
-			break;	/* found a free slot */
+		else {
+			if (size_aligned)
+				pad_size = iova_get_pad_size(size, limit_pfn);
+			if ((curr_iova->pfn_hi + size + pad_size) <= limit_pfn)
+				break;	/* found a free slot */
+		}
 adjust_limit_pfn:
 		limit_pfn = curr_iova->pfn_lo - 1;
 move_left:
 		curr = rb_prev(curr);
 	}
 
-	if ((!curr) && !(IOVA_START_PFN + size <= limit_pfn)) {
-		spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
-		return -ENOMEM;
+	if (!curr) {
+		if (size_aligned)
+			pad_size = iova_get_pad_size(size, limit_pfn);
+		if ((IOVA_START_PFN + size + pad_size) > limit_pfn) {
+			spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
+			return -ENOMEM;
+		}
 	}
-	new->pfn_hi = limit_pfn;
-	new->pfn_lo = limit_pfn - size + 1;
+
+	/* pfn_lo will point to size aligned address if size_aligned is set */
+	new->pfn_lo = limit_pfn - (size + pad_size) + 1;
+	new->pfn_hi = new->pfn_lo + size - 1;
 
 	spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
 	return 0;
@@ -119,12 +145,16 @@ iova_insert_rbtree(struct rb_root *root,
  * @iovad - iova domain in question
  * @size - size of page frames to allocate
  * @limit_pfn - max limit address
+ * @size_aligned - set if size_aligned address range is required
  * This function allocates an iova in the range limit_pfn to IOVA_START_PFN
- * looking from limit_pfn instead from IOVA_START_PFN.
+ * looking from limit_pfn instead from IOVA_START_PFN. If the size_aligned
+ * flag is set then the allocated address iova->pfn_lo will be naturally
+ * aligned on roundup_power_of_two(size).
  */
 struct iova *
 alloc_iova(struct iova_domain *iovad, unsigned long size,
-	unsigned long limit_pfn)
+	unsigned long limit_pfn,
+	bool size_aligned)
 {
 	unsigned long flags;
 	struct iova *new_iova;
@@ -134,8 +164,15 @@ alloc_iova(struct iova_domain *iovad, un
 	if (!new_iova)
 		return NULL;
 
+	/* If size aligned is set then round the size to
+	 * to next power of two.
+	 */
+	if (size_aligned)
+		size = __roundup_pow_of_two(size);
+
 	spin_lock_irqsave(&iovad->iova_alloc_lock, flags);
-	ret = __alloc_iova_range(iovad, size, limit_pfn, new_iova);
+	ret = __alloc_iova_range(iovad, size, limit_pfn, new_iova,
+			size_aligned);
 
 	if (ret) {
 		spin_unlock_irqrestore(&iovad->iova_alloc_lock, flags);
diff -puN drivers/pci/iova.h~intel-iommu-optimize-sg-map-unmap-calls drivers/pci/iova.h
--- a/drivers/pci/iova.h~intel-iommu-optimize-sg-map-unmap-calls
+++ a/drivers/pci/iova.h
@@ -51,7 +51,8 @@ void free_iova_mem(struct iova *iova);
 void free_iova(struct iova_domain *iovad, unsigned long pfn);
 void __free_iova(struct iova_domain *iovad, struct iova *iova);
 struct iova *alloc_iova(struct iova_domain *iovad, unsigned long size,
-	unsigned long limit_pfn);
+	unsigned long limit_pfn,
+	bool size_aligned);
 struct iova *reserve_iova(struct iova_domain *iovad, unsigned long pfn_lo,
 	unsigned long pfn_hi);
 void copy_reserved_iova(struct iova_domain *from, struct iova_domain *to);
_

Patches currently in -mm which might be from anil.s.keshavamurthy@intel.com are

optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-gfx-workaround-kconfig-fix.patch
intel-iommu-iommu-floppy-workaround.patch
intel-iommu-iommu-floppy-workaround-kconfig-fix.patch
intel-iommu-optimize-sg-map-unmap-calls.patch
