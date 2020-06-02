From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 092/128] staging: media: ipu3: use vmap instead of
 reimplementing it
Date: Mon, 01 Jun 2020 21:50:28 -0700
Message-ID: <20200602045028.i2Z2r00tA%akpm@linux-foundation.org>
References: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbgFBEua (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 00:50:30 -0400
In-Reply-To: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: airlied@linux.ie, akpm@linux-foundation.org, benh@kernel.crashing.org, borntraeger@de.ibm.com, catalin.marinas@arm.com, christophe.leroy@c-s.fr, daniel.vetter@ffwll.ch, daniel@ffwll.ch, gor@linux.ibm.com, gregkh@linuxfoundation.org, haiyangz@microsoft.com, hannes@cmpxchg.org, hch@lst.de, heiko.carstens@de.ibm.com, kys@microsoft.com, labbott@redhat.com, linux-mm@kvack.org, mark.rutland@arm.com, mikelley@microsoft.com, minchan@kernel.org, mm-commits@vger.kernel.org, ngupta@vflare.org, paulus@ozlabs.org, peterz@infradead.org, robin.murphy@arm.com, sakari.ailus@linux.intel.com, sthemmin@microsoft.com, sumit.semwal@linaro.org, torvalds@linux-foundation.org, wei.liu@kernel.org, will@kernel.org, xiang@kernel.org

From: Christoph Hellwig <hch@lst.de>
Subject: staging: media: ipu3: use vmap instead of reimplementing it

Just use vmap instead of messing with vmalloc internals.

Link: http://lkml.kernel.org/r/20200414131348.444715-5-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Airlie <airlied@linux.ie>
Cc: Gao Xiang <xiang@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Michael Kelley <mikelley@microsoft.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/media/ipu3/ipu3-css-pool.h |    4 --
 drivers/staging/media/ipu3/ipu3-dmamap.c   |   30 +++++--------------
 2 files changed, 9 insertions(+), 25 deletions(-)

--- a/drivers/staging/media/ipu3/ipu3-css-pool.h~staging-media-ipu3-use-vmap-instead-of-reimplementing-it
+++ a/drivers/staging/media/ipu3/ipu3-css-pool.h
@@ -15,14 +15,12 @@ struct imgu_device;
  * @size:		size of the buffer in bytes.
  * @vaddr:		kernel virtual address.
  * @daddr:		iova dma address to access IPU3.
- * @vma:		private, a pointer to &struct vm_struct,
- *			used for imgu_dmamap_free.
  */
 struct imgu_css_map {
 	size_t size;
 	void *vaddr;
 	dma_addr_t daddr;
-	struct vm_struct *vma;
+	struct page **pages;
 };
 
 /**
--- a/drivers/staging/media/ipu3/ipu3-dmamap.c~staging-media-ipu3-use-vmap-instead-of-reimplementing-it
+++ a/drivers/staging/media/ipu3/ipu3-dmamap.c
@@ -96,6 +96,7 @@ void *imgu_dmamap_alloc(struct imgu_devi
 	unsigned long shift = iova_shift(&imgu->iova_domain);
 	struct device *dev = &imgu->pci_dev->dev;
 	size_t size = PAGE_ALIGN(len);
+	int count = size >> PAGE_SHIFT;
 	struct page **pages;
 	dma_addr_t iovaddr;
 	struct iova *iova;
@@ -114,7 +115,7 @@ void *imgu_dmamap_alloc(struct imgu_devi
 
 	/* Call IOMMU driver to setup pgt */
 	iovaddr = iova_dma_addr(&imgu->iova_domain, iova);
-	for (i = 0; i < size / PAGE_SIZE; ++i) {
+	for (i = 0; i < count; ++i) {
 		rval = imgu_mmu_map(imgu->mmu, iovaddr,
 				    page_to_phys(pages[i]), PAGE_SIZE);
 		if (rval)
@@ -123,33 +124,23 @@ void *imgu_dmamap_alloc(struct imgu_devi
 		iovaddr += PAGE_SIZE;
 	}
 
-	/* Now grab a virtual region */
-	map->vma = __get_vm_area(size, VM_USERMAP, VMALLOC_START, VMALLOC_END);
-	if (!map->vma)
+	map->vaddr = vmap(pages, count, VM_USERMAP, PAGE_KERNEL);
+	if (!map->vaddr)
 		goto out_unmap;
 
-	map->vma->pages = pages;
-	/* And map it in KVA */
-	if (map_vm_area(map->vma, PAGE_KERNEL, pages))
-		goto out_vunmap;
-
+	map->pages = pages;
 	map->size = size;
 	map->daddr = iova_dma_addr(&imgu->iova_domain, iova);
-	map->vaddr = map->vma->addr;
 
 	dev_dbg(dev, "%s: allocated %zu @ IOVA %pad @ VA %p\n", __func__,
-		size, &map->daddr, map->vma->addr);
-
-	return map->vma->addr;
+		size, &map->daddr, map->vaddr);
 
-out_vunmap:
-	vunmap(map->vma->addr);
+	return map->vaddr;
 
 out_unmap:
 	imgu_dmamap_free_buffer(pages, size);
 	imgu_mmu_unmap(imgu->mmu, iova_dma_addr(&imgu->iova_domain, iova),
 		       i * PAGE_SIZE);
-	map->vma = NULL;
 
 out_free_iova:
 	__free_iova(&imgu->iova_domain, iova);
@@ -177,8 +168,6 @@ void imgu_dmamap_unmap(struct imgu_devic
  */
 void imgu_dmamap_free(struct imgu_device *imgu, struct imgu_css_map *map)
 {
-	struct vm_struct *area = map->vma;
-
 	dev_dbg(&imgu->pci_dev->dev, "%s: freeing %zu @ IOVA %pad @ VA %p\n",
 		__func__, map->size, &map->daddr, map->vaddr);
 
@@ -187,11 +176,8 @@ void imgu_dmamap_free(struct imgu_device
 
 	imgu_dmamap_unmap(imgu, map);
 
-	if (WARN_ON(!area) || WARN_ON(!area->pages))
-		return;
