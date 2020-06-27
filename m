From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged]
 dma-remap-align-the-size-in-dma_common__remap.patch removed from -mm tree
Date: Fri, 26 Jun 2020 20:32:55 -0700
Message-ID: <20200627033255.NqCum2Rc1%akpm@linux-foundation.org>
References: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbgF0Dc4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Jun 2020 23:32:56 -0400
In-Reply-To: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bbhushan2@marvell.com, eric.auger@redhat.com, hch@lst.de, jean-philippe@linaro.org, m.szyprowski@samsung.com, mm-commits@vger.kernel.org, peterz@infradead.org, robin.murphy@arm.com


The patch titled
     Subject: kernel/dma/remap.c: align the size in dma_common_*_remap()
has been removed from the -mm tree.  Its filename was
     dma-remap-align-the-size-in-dma_common__remap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Eric Auger <eric.auger@redhat.com>
Subject: kernel/dma/remap.c: align the size in dma_common_*_remap()

Running a guest with a virtio-iommu protecting virtio devices is broken
since commit 515e5b6d90d4 ("dma-mapping: use vmap insted of reimplementing
it").  Before the conversion, the size was page aligned in
__get_vm_area_node().  Doing so fixes the regression.

Link: http://lkml.kernel.org/r/20200622202320.1331-1-eric.auger@redhat.com
Fixes: 515e5b6d90d4 ("dma-mapping: use vmap insted of reimplementing it")
Signed-off-by: Eric Auger <eric.auger@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: Bharat Bhushan <bbhushan2@marvell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/dma/remap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/dma/remap.c~dma-remap-align-the-size-in-dma_common__remap
+++ a/kernel/dma/remap.c
@@ -24,7 +24,7 @@ void *dma_common_pages_remap(struct page
 {
 	void *vaddr;
 
-	vaddr = vmap(pages, size >> PAGE_SHIFT, VM_DMA_COHERENT, prot);
+	vaddr = vmap(pages, PAGE_ALIGN(size) >> PAGE_SHIFT, VM_DMA_COHERENT, prot);
 	if (vaddr)
 		find_vm_area(vaddr)->pages = pages;
 	return vaddr;
@@ -37,7 +37,7 @@ void *dma_common_pages_remap(struct page
 void *dma_common_contiguous_remap(struct page *page, size_t size,
 			pgprot_t prot, const void *caller)
 {
-	int count = size >> PAGE_SHIFT;
+	int count = PAGE_ALIGN(size) >> PAGE_SHIFT;
 	struct page **pages;
 	void *vaddr;
 	int i;
_

Patches currently in -mm which might be from eric.auger@redhat.com are
