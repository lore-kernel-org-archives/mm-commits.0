From: akpm@linux-foundation.org
Subject: [merged]
 arch-parisc-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap.patch
 removed from -mm tree
Date: Thu, 15 Dec 2016 10:45:46 -0800
Message-ID: <5852e4da.+wgOB5Jpm7jU+j8R%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48750 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754517AbcLOSqu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2016 13:46:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexander.h.duyck@intel.com, deller@gmx.de, jejb@parisc-linux.org, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/parisc: add option to skip DMA sync as a part of map and unmap
has been removed from the -mm tree.  Its filename was
     arch-parisc-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: arch/parisc: add option to skip DMA sync as a part of map and unmap

This change allows us to pass DMA_ATTR_SKIP_CPU_SYNC which allows us to
avoid invoking cache line invalidation if the driver will just handle it
via a sync_for_cpu or sync_for_device call.

Link: http://lkml.kernel.org/r/20161110113529.76501.44762.stgit@ahduyck-blue-test.jf.intel.com
Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/kernel/pci-dma.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff -puN arch/parisc/kernel/pci-dma.c~arch-parisc-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap arch/parisc/kernel/pci-dma.c
--- a/arch/parisc/kernel/pci-dma.c~arch-parisc-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap
+++ a/arch/parisc/kernel/pci-dma.c
@@ -459,7 +459,9 @@ static dma_addr_t pa11_dma_map_page(stru
 	void *addr = page_address(page) + offset;
 	BUG_ON(direction == DMA_NONE);
 
-	flush_kernel_dcache_range((unsigned long) addr, size);
+	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC))
+		flush_kernel_dcache_range((unsigned long) addr, size);
+
 	return virt_to_phys(addr);
 }
 
@@ -469,8 +471,11 @@ static void pa11_dma_unmap_page(struct d
 {
 	BUG_ON(direction == DMA_NONE);
 
+	if (attrs & DMA_ATTR_SKIP_CPU_SYNC)
+		return;
+
 	if (direction == DMA_TO_DEVICE)
-	    return;
+		return;
 
 	/*
 	 * For PCI_DMA_FROMDEVICE this flush is not necessary for the
@@ -479,7 +484,6 @@ static void pa11_dma_unmap_page(struct d
 	 */
 
 	flush_kernel_dcache_range((unsigned long) phys_to_virt(dma_handle), size);
-	return;
 }
 
 static int pa11_dma_map_sg(struct device *dev, struct scatterlist *sglist,
@@ -496,6 +500,10 @@ static int pa11_dma_map_sg(struct device
 
 		sg_dma_address(sg) = (dma_addr_t) virt_to_phys(vaddr);
 		sg_dma_len(sg) = sg->length;
+
+		if (attrs & DMA_ATTR_SKIP_CPU_SYNC)
+			continue;
+
 		flush_kernel_dcache_range(vaddr, sg->length);
 	}
 	return nents;
@@ -510,14 +518,16 @@ static void pa11_dma_unmap_sg(struct dev
 
 	BUG_ON(direction == DMA_NONE);
 
+	if (attrs & DMA_ATTR_SKIP_CPU_SYNC)
+		return;
+
 	if (direction == DMA_TO_DEVICE)
-	    return;
+		return;
 
 	/* once we do combining we'll need to use phys_to_virt(sg_dma_address(sglist)) */
 
 	for_each_sg(sglist, sg, nents, i)
 		flush_kernel_vmap_range(sg_virt(sg), sg->length);
-	return;
 }
 
 static void pa11_dma_sync_single_for_cpu(struct device *dev,
_

Patches currently in -mm which might be from alexander.h.duyck@intel.com are


