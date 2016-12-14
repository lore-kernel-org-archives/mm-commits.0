From: akpm@linux-foundation.org
Subject: [patch 026/114] arch/sparc: add option to skip DMA sync as a part of map and unmap
Date: Wed, 14 Dec 2016 15:05:15 -0800
Message-ID: <5851d02b.r253ikKpW48XISVj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34500 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933477AbcLNXF1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 18:05:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, alexander.h.duyck@intel.com, davem@davemloft.net

From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: arch/sparc: add option to skip DMA sync as a part of map and unmap

This change allows us to pass DMA_ATTR_SKIP_CPU_SYNC which allows us to
avoid invoking cache line invalidation if the driver will just handle it
via a sync_for_cpu or sync_for_device call.

Link: http://lkml.kernel.org/r/20161110113544.76501.40008.stgit@ahduyck-blue-test.jf.intel.com
Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/kernel/iommu.c  |    4 ++--
 arch/sparc/kernel/ioport.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/sparc/kernel/iommu.c~arch-sparc-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap arch/sparc/kernel/iommu.c
--- a/arch/sparc/kernel/iommu.c~arch-sparc-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap
+++ a/arch/sparc/kernel/iommu.c
@@ -415,7 +415,7 @@ static void dma_4u_unmap_page(struct dev
 		ctx = (iopte_val(*base) & IOPTE_CONTEXT) >> 47UL;
 
 	/* Step 1: Kick data out of streaming buffers if necessary. */
-	if (strbuf->strbuf_enabled)
+	if (strbuf->strbuf_enabled && !(attrs & DMA_ATTR_SKIP_CPU_SYNC))
 		strbuf_flush(strbuf, iommu, bus_addr, ctx,
 			     npages, direction);
 
@@ -640,7 +640,7 @@ static void dma_4u_unmap_sg(struct devic
 		base = iommu->page_table + entry;
 
 		dma_handle &= IO_PAGE_MASK;
-		if (strbuf->strbuf_enabled)
+		if (strbuf->strbuf_enabled && !(attrs & DMA_ATTR_SKIP_CPU_SYNC))
 			strbuf_flush(strbuf, iommu, dma_handle, ctx,
 				     npages, direction);
 
diff -puN arch/sparc/kernel/ioport.c~arch-sparc-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap arch/sparc/kernel/ioport.c
--- a/arch/sparc/kernel/ioport.c~arch-sparc-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap
+++ a/arch/sparc/kernel/ioport.c
@@ -527,7 +527,7 @@ static dma_addr_t pci32_map_page(struct
 static void pci32_unmap_page(struct device *dev, dma_addr_t ba, size_t size,
 			     enum dma_data_direction dir, unsigned long attrs)
 {
-	if (dir != PCI_DMA_TODEVICE)
+	if (dir != PCI_DMA_TODEVICE && !(attrs & DMA_ATTR_SKIP_CPU_SYNC))
 		dma_make_coherent(ba, PAGE_ALIGN(size));
 }
 
@@ -572,7 +572,7 @@ static void pci32_unmap_sg(struct device
 	struct scatterlist *sg;
 	int n;
 
-	if (dir != PCI_DMA_TODEVICE) {
+	if (dir != PCI_DMA_TODEVICE && !(attrs & DMA_ATTR_SKIP_CPU_SYNC)) {
 		for_each_sg(sgl, sg, nents, n) {
 			dma_make_coherent(sg_phys(sg), PAGE_ALIGN(sg->length));
 		}
_
