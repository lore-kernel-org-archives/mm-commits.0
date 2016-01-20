From: akpm@linux-foundation.org
Subject: [folded-merged] arc-convert-to-dma_map_ops-fix-2.patch removed
 from -mm tree
Date: Wed, 20 Jan 2016 14:37:47 -0800
Message-ID: <56a00c3b.O71H0UzG3mMn3uDI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42149 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032AbcATWhs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jan 2016 17:37:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgupta@synopsys.com, CARLOS.PALMINHA@synopsys.com, borntraeger@de.ibm.com, hch@lst.de, jroedel@suse.de, sebott@linux.vnet.ibm.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: ARC: dma mapping fixes #2
has been removed from the -mm tree.  Its filename was
     arc-convert-to-dma_map_ops-fix-2.patch

This patch was dropped because it was folded into arc-convert-to-dma_map_ops.patch

------------------------------------------------------
From: Vineet Gupta <vgupta@synopsys.com>
Subject: ARC: dma mapping fixes #2

Carlos Palminha reported linux-next boot broken for ARC.

(1) dma_map_single() would recursively call itself

| #define dma_map_single(d, a, s, r) dma_map_single_attrs(d, a, s, r, NULL)
| dma_map_single_attrs
|   ops->map_page
|     arc_dma_map_page
|        dma_map_single

(2) arc_dma_free() to iounmap if memory is coherent

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Reported-by: Carlos Palminha <CARLOS.PALMINHA@synopsys.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/mm/dma.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN arch/arc/mm/dma.c~arc-convert-to-dma_map_ops-fix-2 arch/arc/mm/dma.c
--- a/arch/arc/mm/dma.c~arc-convert-to-dma_map_ops-fix-2
+++ a/arch/arc/mm/dma.c
@@ -72,8 +72,8 @@ static void *arc_dma_alloc(struct device
 static void arc_dma_free(struct device *dev, size_t size, void *vaddr,
 		dma_addr_t dma_handle, struct dma_attrs *attrs)
 {
-	if (!(is_isa_arcv2() && ioc_exists) ||
-	    dma_get_attr(DMA_ATTR_NON_CONSISTENT, attrs))
+	if (!dma_get_attr(DMA_ATTR_NON_CONSISTENT, attrs) &&
+	    !(is_isa_arcv2() && ioc_exists))
 		iounmap((void __force __iomem *)vaddr);
 
 	free_pages_exact((void *)dma_handle, size);
@@ -107,7 +107,8 @@ static dma_addr_t arc_dma_map_page(struc
 		struct dma_attrs *attrs)
 {
 	unsigned long paddr = page_to_phys(page) + offset;
-	return dma_map_single(dev, (void *)paddr, size, dir);
+	_dma_cache_sync(paddr, size, dir);
+	return (dma_addr_t)paddr;
 }
 
 static int arc_dma_map_sg(struct device *dev, struct scatterlist *sg,
_

Patches currently in -mm which might be from vgupta@synopsys.com are

arc-convert-to-dma_map_ops.patch

