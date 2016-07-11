From: akpm@linux-foundation.org
Subject: + dma-mapping-remove-dma_get_attr.patch added to -mm tree
Date: Mon, 11 Jul 2016 15:15:35 -0700
Message-ID: <57841a87.9DYtG8R40Ote/SUI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43729 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932075AbcGKWPg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jul 2016 18:15:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, egtvedt@samfundet.no, robin.murphy@arm.com, vgupta@synopsys.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dma-mapping: remove dma_get_attr
has been added to the -mm tree.  Its filename is
     dma-mapping-remove-dma_get_attr.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dma-mapping-remove-dma_get_attr.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dma-mapping-remove-dma_get_attr.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: dma-mapping: remove dma_get_attr

After switching DMA attributes to unsigned long it is easier to just
compare the bits.

Link: http://lkml.kernel.org/r/1467275171-6298-43-git-send-email-k.kozlowski@samsung.com
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Hans-Christian Noren Egtvedt <egtvedt@samfundet.no> [avr32]
Acked-by: Vineet Gupta <vgupta@synopsys.com> [arc]
Acked-by: Robin Murphy <robin.murphy@arm.com> [arm64 and dma-iommu]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DMA-API.txt                      |    4 -
 arch/arc/mm/dma.c                              |    4 -
 arch/arm/mm/dma-mapping.c                      |   36 +++++++--------
 arch/arm/xen/mm.c                              |    4 -
 arch/arm64/mm/dma-mapping.c                    |   10 ++--
 arch/avr32/mm/dma-coherent.c                   |    4 -
 arch/ia64/sn/pci/pci_dma.c                     |   10 ----
 arch/metag/kernel/dma.c                        |    2 
 arch/mips/mm/dma-default.c                     |    6 +-
 arch/openrisc/kernel/dma.c                     |    4 -
 arch/parisc/kernel/pci-dma.c                   |    2 
 arch/powerpc/platforms/cell/iommu.c            |   12 ++---
 drivers/gpu/drm/rockchip/rockchip_drm_gem.c    |    2 
 drivers/iommu/dma-iommu.c                      |    2 
 drivers/media/v4l2-core/videobuf2-dma-contig.c |    2 
 include/linux/dma-mapping.h                    |   10 ----
 16 files changed, 47 insertions(+), 67 deletions(-)

diff -puN Documentation/DMA-API.txt~dma-mapping-remove-dma_get_attr Documentation/DMA-API.txt
--- a/Documentation/DMA-API.txt~dma-mapping-remove-dma_get_attr
+++ a/Documentation/DMA-API.txt
@@ -422,9 +422,7 @@ void whizco_dma_map_sg_attrs(struct devi
 			     unsigned long attrs)
 {
 	....
-	int foo =  dma_get_attr(DMA_ATTR_FOO, attrs);
-	....
-	if (foo)
+	if (attrs & DMA_ATTR_FOO)
 		/* twizzle the frobnozzle */
 	....
 
diff -puN arch/arc/mm/dma.c~dma-mapping-remove-dma_get_attr arch/arc/mm/dma.c
--- a/arch/arc/mm/dma.c~dma-mapping-remove-dma_get_attr
+++ a/arch/arc/mm/dma.c
@@ -46,7 +46,7 @@ static void *arc_dma_alloc(struct device
 	 *   (vs. always going to memory - thus are faster)
 	 */
 	if ((is_isa_arcv2() && ioc_exists) ||
-	    dma_get_attr(DMA_ATTR_NON_CONSISTENT, attrs))
+	    (attrs & DMA_ATTR_NON_CONSISTENT))
 		need_coh = 0;
 
 	/*
@@ -95,7 +95,7 @@ static void arc_dma_free(struct device *
 	struct page *page = virt_to_page(dma_handle);
 	int is_non_coh = 1;
 
-	is_non_coh = dma_get_attr(DMA_ATTR_NON_CONSISTENT, attrs) ||
+	is_non_coh = (attrs & DMA_ATTR_NON_CONSISTENT) ||
 			(is_isa_arcv2() && ioc_exists);
 
 	if (PageHighMem(page) || !is_non_coh)
diff -puN arch/arm/mm/dma-mapping.c~dma-mapping-remove-dma_get_attr arch/arm/mm/dma-mapping.c
--- a/arch/arm/mm/dma-mapping.c~dma-mapping-remove-dma_get_attr
+++ a/arch/arm/mm/dma-mapping.c
@@ -126,7 +126,7 @@ static dma_addr_t arm_dma_map_page(struc
 	     unsigned long offset, size_t size, enum dma_data_direction dir,
 	     unsigned long attrs)
 {
-	if (!dma_get_attr(DMA_ATTR_SKIP_CPU_SYNC, attrs))
+	if ((attrs & DMA_ATTR_SKIP_CPU_SYNC) == 0)
 		__dma_page_cpu_to_dev(page, offset, size, dir);
 	return pfn_to_dma(dev, page_to_pfn(page)) + offset;
 }
@@ -155,7 +155,7 @@ static dma_addr_t arm_coherent_dma_map_p
 static void arm_dma_unmap_page(struct device *dev, dma_addr_t handle,
 		size_t size, enum dma_data_direction dir, unsigned long attrs)
 {
-	if (!dma_get_attr(DMA_ATTR_SKIP_CPU_SYNC, attrs))
+	if ((attrs & DMA_ATTR_SKIP_CPU_SYNC) == 0)
 		__dma_page_dev_to_cpu(pfn_to_page(dma_to_pfn(dev, handle)),
 				      handle & ~PAGE_MASK, size, dir);
 }
@@ -622,9 +622,9 @@ static void __free_from_contiguous(struc
 
 static inline pgprot_t __get_dma_pgprot(unsigned long attrs, pgprot_t prot)
 {
-	prot = dma_get_attr(DMA_ATTR_WRITE_COMBINE, attrs) ?
-			    pgprot_writecombine(prot) :
-			    pgprot_dmacoherent(prot);
+	prot = (attrs & DMA_ATTR_WRITE_COMBINE) ?
+			pgprot_writecombine(prot) :
+			pgprot_dmacoherent(prot);
 	return prot;
 }
 
@@ -744,7 +744,7 @@ static void *__dma_alloc(struct device *
 		.gfp = gfp,
 		.prot = prot,
 		.caller = caller,
-		.want_vaddr = !dma_get_attr(DMA_ATTR_NO_KERNEL_MAPPING, attrs),
+		.want_vaddr = ((attrs & DMA_ATTR_NO_KERNEL_MAPPING) == 0),
 	};
 
 #ifdef CONFIG_DMA_API_DEBUG
@@ -887,7 +887,7 @@ static void __arm_dma_free(struct device
 		.size = PAGE_ALIGN(size),
 		.cpu_addr = cpu_addr,
 		.page = page,
-		.want_vaddr = !dma_get_attr(DMA_ATTR_NO_KERNEL_MAPPING, attrs),
+		.want_vaddr = ((attrs & DMA_ATTR_NO_KERNEL_MAPPING) == 0),
 	};
 
 	buf = arm_dma_buffer_find(cpu_addr);
@@ -1267,7 +1267,7 @@ static struct page **__iommu_alloc_buffe
 	if (!pages)
 		return NULL;
 
-	if (dma_get_attr(DMA_ATTR_FORCE_CONTIGUOUS, attrs))
+	if (attrs & DMA_ATTR_FORCE_CONTIGUOUS)
 	{
 		unsigned long order = get_order(size);
 		struct page *page;
@@ -1285,7 +1285,7 @@ static struct page **__iommu_alloc_buffe
 	}
 
 	/* Go straight to 4K chunks if caller says it's OK. */
-	if (dma_get_attr(DMA_ATTR_ALLOC_SINGLE_PAGES, attrs))
+	if (attrs & DMA_ATTR_ALLOC_SINGLE_PAGES)
 		order_idx = ARRAY_SIZE(iommu_order_array) - 1;
 
 	/*
@@ -1346,7 +1346,7 @@ static int __iommu_free_buffer(struct de
 	int count = size >> PAGE_SHIFT;
 	int i;
 
-	if (dma_get_attr(DMA_ATTR_FORCE_CONTIGUOUS, attrs)) {
+	if (attrs & DMA_ATTR_FORCE_CONTIGUOUS) {
 		dma_release_from_contiguous(dev, pages[0], count);
 	} else {
 		for (i = 0; i < count; i++)
@@ -1445,7 +1445,7 @@ static struct page **__iommu_get_pages(v
 	if (__in_atomic_pool(cpu_addr, PAGE_SIZE))
 		return __atomic_get_pages(cpu_addr);
 
-	if (dma_get_attr(DMA_ATTR_NO_KERNEL_MAPPING, attrs))
+	if (attrs & DMA_ATTR_NO_KERNEL_MAPPING)
 		return cpu_addr;
 
 	area = find_vm_area(cpu_addr);
@@ -1512,7 +1512,7 @@ static void *arm_iommu_alloc_attrs(struc
 	if (*handle == DMA_ERROR_CODE)
 		goto err_buffer;
 
-	if (dma_get_attr(DMA_ATTR_NO_KERNEL_MAPPING, attrs))
+	if (attrs & DMA_ATTR_NO_KERNEL_MAPPING)
 		return pages;
 
 	addr = __iommu_alloc_remap(pages, size, gfp, prot,
@@ -1583,7 +1583,7 @@ void arm_iommu_free_attrs(struct device
 		return;
 	}
 
-	if (!dma_get_attr(DMA_ATTR_NO_KERNEL_MAPPING, attrs)) {
+	if ((attrs & DMA_ATTR_NO_KERNEL_MAPPING) == 0) {
 		dma_common_free_remap(cpu_addr, size,
 			VM_ARM_DMA_CONSISTENT | VM_USERMAP);
 	}
@@ -1653,8 +1653,7 @@ static int __map_sg_chunk(struct device
 		phys_addr_t phys = page_to_phys(sg_page(s));
 		unsigned int len = PAGE_ALIGN(s->offset + s->length);
 
-		if (!is_coherent &&
-			!dma_get_attr(DMA_ATTR_SKIP_CPU_SYNC, attrs))
+		if (!is_coherent && (attrs & DMA_ATTR_SKIP_CPU_SYNC) == 0)
 			__dma_page_cpu_to_dev(sg_page(s), s->offset, s->length, dir);
 
 		prot = __dma_direction_to_prot(dir);
@@ -1767,8 +1766,7 @@ static void __iommu_unmap_sg(struct devi
 		if (sg_dma_len(s))
 			__iommu_remove_mapping(dev, sg_dma_address(s),
 					       sg_dma_len(s));
-		if (!is_coherent &&
-		    !dma_get_attr(DMA_ATTR_SKIP_CPU_SYNC, attrs))
+		if (!is_coherent && (attrs & DMA_ATTR_SKIP_CPU_SYNC) == 0)
 			__dma_page_dev_to_cpu(sg_page(s), s->offset,
 					      s->length, dir);
 	}
@@ -1892,7 +1890,7 @@ static dma_addr_t arm_iommu_map_page(str
 	     unsigned long offset, size_t size, enum dma_data_direction dir,
 	     unsigned long attrs)
 {
-	if (!dma_get_attr(DMA_ATTR_SKIP_CPU_SYNC, attrs))
+	if ((attrs & DMA_ATTR_SKIP_CPU_SYNC) == 0)
 		__dma_page_cpu_to_dev(page, offset, size, dir);
 
 	return arm_coherent_iommu_map_page(dev, page, offset, size, dir, attrs);
@@ -1943,7 +1941,7 @@ static void arm_iommu_unmap_page(struct
 	if (!iova)
 		return;
 
-	if (!dma_get_attr(DMA_ATTR_SKIP_CPU_SYNC, attrs))
+	if ((attrs & DMA_ATTR_SKIP_CPU_SYNC) == 0)
 		__dma_page_dev_to_cpu(page, offset, size, dir);
 
 	iommu_unmap(mapping->domain, iova, len);
diff -puN arch/arm/xen/mm.c~dma-mapping-remove-dma_get_attr arch/arm/xen/mm.c
--- a/arch/arm/xen/mm.c~dma-mapping-remove-dma_get_attr
+++ a/arch/arm/xen/mm.c
@@ -102,7 +102,7 @@ void __xen_dma_map_page(struct device *h
 {
 	if (is_device_dma_coherent(hwdev))
 		return;
-	if (dma_get_attr(DMA_ATTR_SKIP_CPU_SYNC, attrs))
+	if (attrs & DMA_ATTR_SKIP_CPU_SYNC)
 		return;
 
 	__xen_dma_page_cpu_to_dev(hwdev, dev_addr, size, dir);
@@ -115,7 +115,7 @@ void __xen_dma_unmap_page(struct device
 {
 	if (is_device_dma_coherent(hwdev))
 		return;
-	if (dma_get_attr(DMA_ATTR_SKIP_CPU_SYNC, attrs))
+	if (attrs & DMA_ATTR_SKIP_CPU_SYNC)
 		return;
 
 	__xen_dma_page_dev_to_cpu(hwdev, handle, size, dir);
diff -puN arch/arm64/mm/dma-mapping.c~dma-mapping-remove-dma_get_attr arch/arm64/mm/dma-mapping.c
--- a/arch/arm64/mm/dma-mapping.c~dma-mapping-remove-dma_get_attr
+++ a/arch/arm64/mm/dma-mapping.c
@@ -32,7 +32,7 @@
 static pgprot_t __get_dma_pgprot(unsigned long attrs, pgprot_t prot,
 				 bool coherent)
 {
-	if (!coherent || dma_get_attr(DMA_ATTR_WRITE_COMBINE, attrs))
+	if (!coherent || (attrs & DMA_ATTR_WRITE_COMBINE))
 		return pgprot_writecombine(prot);
 	return prot;
 }
@@ -701,7 +701,7 @@ static dma_addr_t __iommu_map_page(struc
 	dma_addr_t dev_addr = iommu_dma_map_page(dev, page, offset, size, prot);
 
 	if (!iommu_dma_mapping_error(dev, dev_addr) &&
-	    !dma_get_attr(DMA_ATTR_SKIP_CPU_SYNC, attrs))
+	    (attrs & DMA_ATTR_SKIP_CPU_SYNC) == 0)
 		__iommu_sync_single_for_device(dev, dev_addr, size, dir);
 
 	return dev_addr;
@@ -711,7 +711,7 @@ static void __iommu_unmap_page(struct de
 			       size_t size, enum dma_data_direction dir,
 			       unsigned long attrs)
 {
-	if (!dma_get_attr(DMA_ATTR_SKIP_CPU_SYNC, attrs))
+	if ((attrs & DMA_ATTR_SKIP_CPU_SYNC) == 0)
 		__iommu_sync_single_for_cpu(dev, dev_addr, size, dir);
 
 	iommu_dma_unmap_page(dev, dev_addr, size, dir, attrs);
@@ -751,7 +751,7 @@ static int __iommu_map_sg_attrs(struct d
 {
 	bool coherent = is_device_dma_coherent(dev);
 
-	if (!dma_get_attr(DMA_ATTR_SKIP_CPU_SYNC, attrs))
+	if ((attrs & DMA_ATTR_SKIP_CPU_SYNC) == 0)
 		__iommu_sync_sg_for_device(dev, sgl, nelems, dir);
 
 	return iommu_dma_map_sg(dev, sgl, nelems,
@@ -763,7 +763,7 @@ static void __iommu_unmap_sg_attrs(struc
 				   enum dma_data_direction dir,
 				   unsigned long attrs)
 {
-	if (!dma_get_attr(DMA_ATTR_SKIP_CPU_SYNC, attrs))
+	if ((attrs & DMA_ATTR_SKIP_CPU_SYNC) == 0)
 		__iommu_sync_sg_for_cpu(dev, sgl, nelems, dir);
 
 	iommu_dma_unmap_sg(dev, sgl, nelems, dir, attrs);
diff -puN arch/avr32/mm/dma-coherent.c~dma-mapping-remove-dma_get_attr arch/avr32/mm/dma-coherent.c
--- a/arch/avr32/mm/dma-coherent.c~dma-mapping-remove-dma_get_attr
+++ a/arch/avr32/mm/dma-coherent.c
@@ -109,7 +109,7 @@ static void *avr32_dma_alloc(struct devi
 		return NULL;
 	phys = page_to_phys(page);
 
-	if (dma_get_attr(DMA_ATTR_WRITE_COMBINE, attrs)) {
+	if (attrs & DMA_ATTR_WRITE_COMBINE) {
 		/* Now, map the page into P3 with write-combining turned on */
 		*handle = phys;
 		return __ioremap(phys, size, _PAGE_BUFFER);
@@ -123,7 +123,7 @@ static void avr32_dma_free(struct device
 {
 	struct page *page;
 
-	if (dma_get_attr(DMA_ATTR_WRITE_COMBINE, attrs)) {
+	if (attrs & DMA_ATTR_WRITE_COMBINE) {
 		iounmap(cpu_addr);
 
 		page = phys_to_page(handle);
diff -puN arch/ia64/sn/pci/pci_dma.c~dma-mapping-remove-dma_get_attr arch/ia64/sn/pci/pci_dma.c
--- a/arch/ia64/sn/pci/pci_dma.c~dma-mapping-remove-dma_get_attr
+++ a/arch/ia64/sn/pci/pci_dma.c
@@ -183,14 +183,11 @@ static dma_addr_t sn_dma_map_page(struct
 	unsigned long phys_addr;
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct sn_pcibus_provider *provider = SN_PCIDEV_BUSPROVIDER(pdev);
-	int dmabarr;
-
-	dmabarr = dma_get_attr(DMA_ATTR_WRITE_BARRIER, attrs);
 
 	BUG_ON(!dev_is_pci(dev));
 
 	phys_addr = __pa(cpu_addr);
-	if (dmabarr)
+	if (attrs & DMA_ATTR_WRITE_BARRIER)
 		dma_addr = provider->dma_map_consistent(pdev, phys_addr,
 							size, SN_DMA_ADDR_PHYS);
 	else
@@ -280,9 +277,6 @@ static int sn_dma_map_sg(struct device *
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct sn_pcibus_provider *provider = SN_PCIDEV_BUSPROVIDER(pdev);
 	int i;
-	int dmabarr;
-
-	dmabarr = dma_get_attr(DMA_ATTR_WRITE_BARRIER, attrs);
 
 	BUG_ON(!dev_is_pci(dev));
 
@@ -292,7 +286,7 @@ static int sn_dma_map_sg(struct device *
 	for_each_sg(sgl, sg, nhwentries, i) {
 		dma_addr_t dma_addr;
 		phys_addr = SG_ENT_PHYS_ADDRESS(sg);
-		if (dmabarr)
+		if (attrs & DMA_ATTR_WRITE_BARRIER)
 			dma_addr = provider->dma_map_consistent(pdev,
 								phys_addr,
 								sg->length,
diff -puN arch/metag/kernel/dma.c~dma-mapping-remove-dma_get_attr arch/metag/kernel/dma.c
--- a/arch/metag/kernel/dma.c~dma-mapping-remove-dma_get_attr
+++ a/arch/metag/kernel/dma.c
@@ -337,7 +337,7 @@ static int metag_dma_mmap(struct device
 	struct metag_vm_region *c;
 	int ret = -ENXIO;
 
-	if (dma_get_attr(DMA_ATTR_WRITE_COMBINE, attrs))
+	if (attrs & DMA_ATTR_WRITE_COMBINE)
 		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
 	else
 		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
diff -puN arch/mips/mm/dma-default.c~dma-mapping-remove-dma_get_attr arch/mips/mm/dma-default.c
--- a/arch/mips/mm/dma-default.c~dma-mapping-remove-dma_get_attr
+++ a/arch/mips/mm/dma-default.c
@@ -141,7 +141,7 @@ static void *mips_dma_alloc_coherent(str
 	 * XXX: seems like the coherent and non-coherent implementations could
 	 * be consolidated.
 	 */
-	if (dma_get_attr(DMA_ATTR_NON_CONSISTENT, attrs))
+	if (attrs & DMA_ATTR_NON_CONSISTENT)
 		return mips_dma_alloc_noncoherent(dev, size, dma_handle, gfp);
 
 	gfp = massage_gfp_flags(dev, gfp);
@@ -182,7 +182,7 @@ static void mips_dma_free_coherent(struc
 	unsigned int count = PAGE_ALIGN(size) >> PAGE_SHIFT;
 	struct page *page = NULL;
 
-	if (dma_get_attr(DMA_ATTR_NON_CONSISTENT, attrs)) {
+	if (attrs & DMA_ATTR_NON_CONSISTENT) {
 		mips_dma_free_noncoherent(dev, size, vaddr, dma_handle);
 		return;
 	}
@@ -214,7 +214,7 @@ static int mips_dma_mmap(struct device *
 
 	pfn = page_to_pfn(virt_to_page((void *)addr));
 
-	if (dma_get_attr(DMA_ATTR_WRITE_COMBINE, attrs))
+	if (attrs & DMA_ATTR_WRITE_COMBINE)
 		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
 	else
 		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
diff -puN arch/openrisc/kernel/dma.c~dma-mapping-remove-dma_get_attr arch/openrisc/kernel/dma.c
--- a/arch/openrisc/kernel/dma.c~dma-mapping-remove-dma_get_attr
+++ a/arch/openrisc/kernel/dma.c
@@ -100,7 +100,7 @@ or1k_dma_alloc(struct device *dev, size_
 
 	va = (unsigned long)page;
 
-	if (!dma_get_attr(DMA_ATTR_NON_CONSISTENT, attrs)) {
+	if ((attrs & DMA_ATTR_NON_CONSISTENT) == 0) {
 		/*
 		 * We need to iterate through the pages, clearing the dcache for
 		 * them and setting the cache-inhibit bit.
@@ -124,7 +124,7 @@ or1k_dma_free(struct device *dev, size_t
 		.mm = &init_mm
 	};
 
-	if (!dma_get_attr(DMA_ATTR_NON_CONSISTENT, attrs)) {
+	if ((attrs & DMA_ATTR_NON_CONSISTENT) == 0) {
 		/* walk_page_range shouldn't be able to fail here */
 		WARN_ON(walk_page_range(va, va + size, &walk));
 	}
diff -puN arch/parisc/kernel/pci-dma.c~dma-mapping-remove-dma_get_attr arch/parisc/kernel/pci-dma.c
--- a/arch/parisc/kernel/pci-dma.c~dma-mapping-remove-dma_get_attr
+++ a/arch/parisc/kernel/pci-dma.c
@@ -581,7 +581,7 @@ static void *pcx_dma_alloc(struct device
 {
 	void *addr;
 
-	if (!dma_get_attr(DMA_ATTR_NON_CONSISTENT, attrs))
+	if ((attrs & DMA_ATTR_NON_CONSISTENT) == 0)
 		return NULL;
 
 	addr = (void *)__get_free_pages(flag, get_order(size));
diff -puN arch/powerpc/platforms/cell/iommu.c~dma-mapping-remove-dma_get_attr arch/powerpc/platforms/cell/iommu.c
--- a/arch/powerpc/platforms/cell/iommu.c~dma-mapping-remove-dma_get_attr
+++ a/arch/powerpc/platforms/cell/iommu.c
@@ -193,7 +193,7 @@ static int tce_build_cell(struct iommu_t
 	base_pte = CBE_IOPTE_PP_W | CBE_IOPTE_PP_R | CBE_IOPTE_M |
 		CBE_IOPTE_SO_RW | (window->ioid & CBE_IOPTE_IOID_Mask);
 #endif
-	if (unlikely(dma_get_attr(DMA_ATTR_WEAK_ORDERING, attrs)))
+	if (unlikely(attrs & DMA_ATTR_WEAK_ORDERING))
 		base_pte &= ~CBE_IOPTE_SO_RW;
 
 	io_pte = (unsigned long *)tbl->it_base + (index - tbl->it_offset);
@@ -600,7 +600,7 @@ static dma_addr_t dma_fixed_map_page(str
 				     enum dma_data_direction direction,
 				     unsigned long attrs)
 {
-	if (iommu_fixed_is_weak == dma_get_attr(DMA_ATTR_WEAK_ORDERING, attrs))
+	if (iommu_fixed_is_weak == (attrs & DMA_ATTR_WEAK_ORDERING))
 		return dma_direct_ops.map_page(dev, page, offset, size,
 					       direction, attrs);
 	else
@@ -613,7 +613,7 @@ static void dma_fixed_unmap_page(struct
 				 size_t size, enum dma_data_direction direction,
 				 unsigned long attrs)
 {
-	if (iommu_fixed_is_weak == dma_get_attr(DMA_ATTR_WEAK_ORDERING, attrs))
+	if (iommu_fixed_is_weak == (attrs & DMA_ATTR_WEAK_ORDERING))
 		dma_direct_ops.unmap_page(dev, dma_addr, size, direction,
 					  attrs);
 	else
@@ -625,7 +625,7 @@ static int dma_fixed_map_sg(struct devic
 			   int nents, enum dma_data_direction direction,
 			   unsigned long attrs)
 {
-	if (iommu_fixed_is_weak == dma_get_attr(DMA_ATTR_WEAK_ORDERING, attrs))
+	if (iommu_fixed_is_weak == (attrs & DMA_ATTR_WEAK_ORDERING))
 		return dma_direct_ops.map_sg(dev, sg, nents, direction, attrs);
 	else
 		return ppc_iommu_map_sg(dev, cell_get_iommu_table(dev), sg,
@@ -637,7 +637,7 @@ static void dma_fixed_unmap_sg(struct de
 			       int nents, enum dma_data_direction direction,
 			       unsigned long attrs)
 {
-	if (iommu_fixed_is_weak == dma_get_attr(DMA_ATTR_WEAK_ORDERING, attrs))
+	if (iommu_fixed_is_weak == (attrs & DMA_ATTR_WEAK_ORDERING))
 		dma_direct_ops.unmap_sg(dev, sg, nents, direction, attrs);
 	else
 		ppc_iommu_unmap_sg(cell_get_iommu_table(dev), sg, nents,
@@ -1162,7 +1162,7 @@ static int __init setup_iommu_fixed(char
 	pciep = of_find_node_by_type(NULL, "pcie-endpoint");
 
 	if (strcmp(str, "weak") == 0 || (pciep && strcmp(str, "strong") != 0))
-		iommu_fixed_is_weak = 1;
+		iommu_fixed_is_weak = DMA_ATTR_WEAK_ORDERING;
 
 	of_node_put(pciep);
 
diff -puN drivers/gpu/drm/rockchip/rockchip_drm_gem.c~dma-mapping-remove-dma_get_attr drivers/gpu/drm/rockchip/rockchip_drm_gem.c
--- a/drivers/gpu/drm/rockchip/rockchip_drm_gem.c~dma-mapping-remove-dma_get_attr
+++ a/drivers/gpu/drm/rockchip/rockchip_drm_gem.c
@@ -273,7 +273,7 @@ void *rockchip_gem_prime_vmap(struct drm
 {
 	struct rockchip_gem_object *rk_obj = to_rockchip_obj(obj);
 
-	if (dma_get_attr(DMA_ATTR_NO_KERNEL_MAPPING, rk_obj->dma_attrs))
+	if (rk_obj->dma_attrs & DMA_ATTR_NO_KERNEL_MAPPING)
 		return NULL;
 
 	return rk_obj->kvaddr;
diff -puN drivers/iommu/dma-iommu.c~dma-mapping-remove-dma_get_attr drivers/iommu/dma-iommu.c
--- a/drivers/iommu/dma-iommu.c~dma-mapping-remove-dma_get_attr
+++ a/drivers/iommu/dma-iommu.c
@@ -306,7 +306,7 @@ struct page **iommu_dma_alloc(struct dev
 	} else {
 		size = ALIGN(size, min_size);
 	}
-	if (dma_get_attr(DMA_ATTR_ALLOC_SINGLE_PAGES, attrs))
+	if (attrs & DMA_ATTR_ALLOC_SINGLE_PAGES)
 		alloc_sizes = min_size;
 
 	count = PAGE_ALIGN(size) >> PAGE_SHIFT;
diff -puN drivers/media/v4l2-core/videobuf2-dma-contig.c~dma-mapping-remove-dma_get_attr drivers/media/v4l2-core/videobuf2-dma-contig.c
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c~dma-mapping-remove-dma_get_attr
+++ a/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -160,7 +160,7 @@ static void *vb2_dc_alloc(void *alloc_ct
 		return ERR_PTR(-ENOMEM);
 	}
 
-	if (!dma_get_attr(DMA_ATTR_NO_KERNEL_MAPPING, &buf->attrs))
+	if ((buf->attrs & DMA_ATTR_NO_KERNEL_MAPPING) == 0)
 		buf->vaddr = buf->cookie;
 
 	/* Prevent the device from being released while the buffer is used */
diff -puN include/linux/dma-mapping.h~dma-mapping-remove-dma_get_attr include/linux/dma-mapping.h
--- a/include/linux/dma-mapping.h~dma-mapping-remove-dma_get_attr
+++ a/include/linux/dma-mapping.h
@@ -101,16 +101,6 @@ static inline int is_device_dma_capable(
 	return dev->dma_mask != NULL && *dev->dma_mask != DMA_MASK_NONE;
 }
 
-/**
- * dma_get_attr - check for a specific attribute
- * @attr: attribute to look for
- * @attrs: attributes to check within
- */
-static inline bool dma_get_attr(unsigned long attr, unsigned long attrs)
-{
-	return !!(attr & attrs);
-}
-
 #ifdef CONFIG_HAVE_GENERIC_DMA_COHERENT
 /*
  * These three functions are only for dma allocator.
_

Patches currently in -mm which might be from k.kozlowski@samsung.com are

dma-mapping-use-unsigned-long-for-dma_attrs.patch
alpha-dma-mapping-use-unsigned-long-for-dma_attrs.patch
arc-dma-mapping-use-unsigned-long-for-dma_attrs.patch
arm-dma-mapping-use-unsigned-long-for-dma_attrs.patch
arm64-dma-mapping-use-unsigned-long-for-dma_attrs.patch
avr32-dma-mapping-use-unsigned-long-for-dma_attrs.patch
blackfin-dma-mapping-use-unsigned-long-for-dma_attrs.patch
c6x-dma-mapping-use-unsigned-long-for-dma_attrs.patch
cris-dma-mapping-use-unsigned-long-for-dma_attrs.patch
frv-dma-mapping-use-unsigned-long-for-dma_attrs.patch
drm-exynos-dma-mapping-use-unsigned-long-for-dma_attrs.patch
drm-mediatek-dma-mapping-use-unsigned-long-for-dma_attrs.patch
drm-msm-dma-mapping-use-unsigned-long-for-dma_attrs.patch
drm-nouveau-dma-mapping-use-unsigned-long-for-dma_attrs.patch
drm-rockship-dma-mapping-use-unsigned-long-for-dma_attrs.patch
infiniband-dma-mapping-use-unsigned-long-for-dma_attrs.patch
iommu-dma-mapping-use-unsigned-long-for-dma_attrs.patch
xen-dma-mapping-use-unsigned-long-for-dma_attrs.patch
swiotlb-dma-mapping-use-unsigned-long-for-dma_attrs.patch
powerpc-dma-mapping-use-unsigned-long-for-dma_attrs.patch
video-dma-mapping-use-unsigned-long-for-dma_attrs.patch
x86-dma-mapping-use-unsigned-long-for-dma_attrs.patch
iommu-intel-dma-mapping-use-unsigned-long-for-dma_attrs.patch
h8300-dma-mapping-use-unsigned-long-for-dma_attrs.patch
hexagon-dma-mapping-use-unsigned-long-for-dma_attrs.patch
ia64-dma-mapping-use-unsigned-long-for-dma_attrs.patch
m68k-dma-mapping-use-unsigned-long-for-dma_attrs.patch
metag-dma-mapping-use-unsigned-long-for-dma_attrs.patch
microblaze-dma-mapping-use-unsigned-long-for-dma_attrs.patch
mips-dma-mapping-use-unsigned-long-for-dma_attrs.patch
mn10300-dma-mapping-use-unsigned-long-for-dma_attrs.patch
nios2-dma-mapping-use-unsigned-long-for-dma_attrs.patch
openrisc-dma-mapping-use-unsigned-long-for-dma_attrs.patch
parisc-dma-mapping-use-unsigned-long-for-dma_attrs.patch
misc-mic-dma-mapping-use-unsigned-long-for-dma_attrs.patch
s390-dma-mapping-use-unsigned-long-for-dma_attrs.patch
sh-dma-mapping-use-unsigned-long-for-dma_attrs.patch
sparc-dma-mapping-use-unsigned-long-for-dma_attrs.patch
tile-dma-mapping-use-unsigned-long-for-dma_attrs.patch
unicore32-dma-mapping-use-unsigned-long-for-dma_attrs.patch
xtensa-dma-mapping-use-unsigned-long-for-dma_attrs.patch
dma-mapping-remove-dma_get_attr.patch
dma-mapping-document-the-dma-attributes-next-to-the-declaration.patch
dma-mapping-constify-attrs-passed-to-dma_get_attr.patch
arm-dma-mapping-constify-attrs-passed-to-internal-functions.patch
arm64-dma-mapping-constify-attrs-passed-to-internal-functions.patch

