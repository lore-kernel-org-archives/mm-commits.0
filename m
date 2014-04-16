From: akpm@linux-foundation.org
Subject: + intel-iommu-integrate-dma-cma.patch added to -mm tree
Date: Wed, 16 Apr 2014 12:44:48 -0700
Message-ID: <534eddb0.qGEpisnmfcRGCTt/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45436 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbaDPTot (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Apr 2014 15:44:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, tglx@linutronix.de, mingo@redhat.com, m.szyprowski@samsung.com, konrad.wilk@oracle.com, hpa@zytor.com, dwmw2@infradead.org, ddutile@redhat.com, andi@firstfloor.org, akinobu.mita@gmail.com

Subject: + intel-iommu-integrate-dma-cma.patch added to -mm tree
To: akinobu.mita@gmail.com,andi@firstfloor.org,ddutile@redhat.com,dwmw2@infradead.org,hpa@zytor.com,konrad.wilk@oracle.com,m.szyprowski@samsung.com,mingo@redhat.com,tglx@linutronix.de,yinghai@kernel.org
From: akpm@linux-foundation.org
Date: Wed, 16 Apr 2014 12:44:48 -0700


The patch titled
     Subject: intel-iommu: integrate DMA CMA
has been added to the -mm tree.  Its filename is
     intel-iommu-integrate-dma-cma.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/intel-iommu-integrate-dma-cma.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/intel-iommu-integrate-dma-cma.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: intel-iommu: integrate DMA CMA

This adds support for the DMA Contiguous Memory Allocator for intel-iommu.
 This change enables dma_alloc_coherent() to allocate big contiguous
memory.

It is achieved in the same way as nommu_dma_ops currently does, i.e. 
trying to allocate memory by dma_alloc_from_contiguous() and alloc_pages()
is used as a fallback.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Don Dutile <ddutile@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/iommu/intel-iommu.c |   32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff -puN drivers/iommu/intel-iommu.c~intel-iommu-integrate-dma-cma drivers/iommu/intel-iommu.c
--- a/drivers/iommu/intel-iommu.c~intel-iommu-integrate-dma-cma
+++ a/drivers/iommu/intel-iommu.c
@@ -3189,7 +3189,7 @@ static void *intel_alloc_coherent(struct
 				  dma_addr_t *dma_handle, gfp_t flags,
 				  struct dma_attrs *attrs)
 {
-	void *vaddr;
+	struct page *page = NULL;
 	int order;
 
 	size = PAGE_ALIGN(size);
@@ -3204,17 +3204,31 @@ static void *intel_alloc_coherent(struct
 			flags |= GFP_DMA32;
 	}
 
-	vaddr = (void *)__get_free_pages(flags, order);
-	if (!vaddr)
+	if (flags & __GFP_WAIT) {
+		unsigned int count = size >> PAGE_SHIFT;
+
+		page = dma_alloc_from_contiguous(dev, count, order);
+		if (page && iommu_no_mapping(dev) &&
+		    page_to_phys(page) + size > dev->coherent_dma_mask) {
+			dma_release_from_contiguous(dev, page, count);
+			page = NULL;
+		}
+	}
+
+	if (!page)
+		page = alloc_pages(flags, order);
+	if (!page)
 		return NULL;
-	memset(vaddr, 0, size);
+	memset(page_address(page), 0, size);
 
-	*dma_handle = __intel_map_single(dev, virt_to_bus(vaddr), size,
+	*dma_handle = __intel_map_single(dev, page_to_phys(page), size,
 					 DMA_BIDIRECTIONAL,
 					 dev->coherent_dma_mask);
 	if (*dma_handle)
-		return vaddr;
-	free_pages((unsigned long)vaddr, order);
+		return page_address(page);
+	if (!dma_release_from_contiguous(dev, page, size >> PAGE_SHIFT))
+		__free_pages(page, order);
+
 	return NULL;
 }
 
@@ -3222,12 +3236,14 @@ static void intel_free_coherent(struct d
 				dma_addr_t dma_handle, struct dma_attrs *attrs)
 {
 	int order;
+	struct page *page = virt_to_page(vaddr);
 
 	size = PAGE_ALIGN(size);
 	order = get_order(size);
 
 	intel_unmap_page(dev, dma_handle, size, DMA_BIDIRECTIONAL, NULL);
-	free_pages((unsigned long)vaddr, order);
+	if (!dma_release_from_contiguous(dev, page, size >> PAGE_SHIFT))
+		__free_pages(page, order);
 }
 
 static void intel_unmap_sg(struct device *dev, struct scatterlist *sglist,
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

x86-make-dma_alloc_coherent-return-zeroed-memory-if-cma-is-enabled.patch
x86-enable-dma-cma-with-swiotlb.patch
intel-iommu-integrate-dma-cma.patch
memblock-introduce-memblock_alloc_range.patch
cma-add-placement-specifier-for-cma=-kernel-parameter.patch

