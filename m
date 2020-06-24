From: akpm@linux-foundation.org
Subject: + dma-remap-align-the-size-in-dma_common__remap.patch added
 to -mm tree
Date: Wed, 24 Jun 2020 15:30:02 -0700
Message-ID: <20200624223002.UbHIC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388711AbgFXWaE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Jun 2020 18:30:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, robin.murphy@arm.com, peterz@infradead.org, m.szyprowski@samsung.com, jean-philippe@linaro.org, hch@lst.de, bbhushan2@marvell.com, eric.auger@redhat.com


The patch titled
     Subject: kernel/dma/remap.c: align the size in dma_common_*_remap()
has been added to the -mm tree.  Its filename is
     dma-remap-align-the-size-in-dma_common__remap.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dma-remap-align-the-size-in-dma_common__remap.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dma-remap-align-the-size-in-dma_common__remap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

dma-remap-align-the-size-in-dma_common__remap.patch
