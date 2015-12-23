From: akpm@linux-foundation.org
Subject: + arc-convert-to-dma_map_ops-fix-2.patch added to -mm tree
Date: Wed, 23 Dec 2015 12:13:06 -0800
Message-ID: <567b0052.d5tMnuqjBKBV+MYD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40466 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934071AbbLWUNH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Dec 2015 15:13:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgupta@synopsys.com, CARLOS.PALMINHA@synopsys.com, hch@lst.de, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: ARC: dma mapping fixes #2
has been added to the -mm tree.  Its filename is
     arc-convert-to-dma_map_ops-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arc-convert-to-dma_map_ops-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arc-convert-to-dma_map_ops-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

arc-convert-to-dma_map_ops-fix-2.patch

