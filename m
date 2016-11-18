From: akpm@linux-foundation.org
Subject: +
 arch-sparc-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap.patch
 added to -mm tree
Date: Fri, 18 Nov 2016 15:30:51 -0800
Message-ID: <582f8f2b.ciUFunp9z8Atuvao%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42504 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753899AbcKRXaw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 18 Nov 2016 18:30:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexander.h.duyck@intel.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/sparc: add option to skip DMA sync as a part of map and unmap
has been added to the -mm tree.  Its filename is
     arch-sparc-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-sparc-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-sparc-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from alexander.h.duyck@intel.com are

arch-arc-add-option-to-skip-sync-on-dma-mapping.patch
arch-arm-add-option-to-skip-sync-on-dma-map-and-unmap.patch
arch-avr32-add-option-to-skip-sync-on-dma-map.patch
arch-blackfin-add-option-to-skip-sync-on-dma-map.patch
arch-c6x-add-option-to-skip-sync-on-dma-map-and-unmap.patch
arch-frv-add-option-to-skip-sync-on-dma-map.patch
arch-hexagon-add-option-to-skip-dma-sync-as-a-part-of-mapping.patch
arch-m68k-add-option-to-skip-dma-sync-as-a-part-of-mapping.patch
arch-metag-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap.patch
arch-microblaze-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap.patch
arch-mips-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap.patch
arch-nios2-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap.patch
arch-openrisc-add-option-to-skip-dma-sync-as-a-part-of-mapping.patch
arch-parisc-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap.patch
arch-powerpc-add-option-to-skip-dma-sync-as-a-part-of-mapping.patch
arch-sh-add-option-to-skip-dma-sync-as-a-part-of-mapping.patch
arch-sparc-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap.patch
arch-tile-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap.patch
arch-xtensa-add-option-to-skip-dma-sync-as-a-part-of-mapping.patch
dma-add-calls-for-dma_map_page_attrs-and-dma_unmap_page_attrs.patch
mm-add-support-for-releasing-multiple-instances-of-a-page.patch
igb-update-driver-to-make-use-of-dma_attr_skip_cpu_sync.patch
igb-update-code-to-better-handle-incrementing-page-count.patch

