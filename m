From: akpm@linux-foundation.org
Subject: + arc-convert-to-dma_map_ops-fix.patch added to -mm tree
Date: Mon, 23 Nov 2015 14:43:24 -0800
Message-ID: <5653968c.9QStDLqDXNn4a9xt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56604 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbbKWWnZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Nov 2015 17:43:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, linux@roeck-us.net, mm-commits@vger.kernel.org


The patch titled
     Subject: arc: dma mapping fixes
has been added to the -mm tree.  Its filename is
     arc-convert-to-dma_map_ops-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arc-convert-to-dma_map_ops-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arc-convert-to-dma_map_ops-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: arc: dma mapping fixes

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/mm/dma.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/arc/mm/dma.c~arc-convert-to-dma_map_ops-fix arch/arc/mm/dma.c
--- a/arch/arc/mm/dma.c~arc-convert-to-dma_map_ops-fix
+++ a/arch/arc/mm/dma.c
@@ -46,7 +46,7 @@ static void *arc_dma_alloc(struct device
 	 *   (vs. always going to memory - thus are faster)
 	 */
 	if ((is_isa_arcv2() && ioc_exists) ||
-	    dma_get_attr(DMA_ATTR_NON_CONSISTENT, attrs)
+	    dma_get_attr(DMA_ATTR_NON_CONSISTENT, attrs))
 		return paddr;
 
 	/* This is kernel Virtual address (0x7000_0000 based) */
@@ -74,7 +74,7 @@ static void arc_dma_free(struct device *
 {
 	if (!(is_isa_arcv2() && ioc_exists) ||
 	    dma_get_attr(DMA_ATTR_NON_CONSISTENT, attrs))
-		iounmap((void __force __iomem *)kvaddr);
+		iounmap((void __force __iomem *)vaddr);
 
 	free_pages_exact((void *)dma_handle, size);
 }
@@ -135,7 +135,7 @@ static void arc_dma_sync_single_for_devi
 	_dma_cache_sync(dma_handle, size, DMA_TO_DEVICE);
 }
 
-static void arm_dma_sync_sg_for_cpu(struct device *dev,
+static void arc_dma_sync_sg_for_cpu(struct device *dev,
 		struct scatterlist *sglist, int nelems,
 		enum dma_data_direction dir)
 {
@@ -171,7 +171,7 @@ struct dma_map_ops arc_dma_ops = {
 	.sync_single_for_device	= arc_dma_sync_single_for_device,
 	.sync_single_for_cpu	= arc_dma_sync_single_for_cpu,
 	.sync_sg_for_cpu	= arc_dma_sync_sg_for_cpu,
-	.sync_sg_for_dev	= arc_dma_sync_sg_for_device,
+	.sync_sg_for_device	= arc_dma_sync_sg_for_device,
 	.dma_supported		= arc_dma_supported,
 };
 EXPORT_SYMBOL(arc_dma_ops);
_

Patches currently in -mm which might be from hch@lst.de are

dma-mapping-make-the-generic-coherent-dma-mmap-implementation-optional.patch
arc-convert-to-dma_map_ops.patch
arc-convert-to-dma_map_ops-fix.patch
avr32-convert-to-dma_map_ops.patch
blackfin-convert-to-dma_map_ops.patch
c6x-convert-to-dma_map_ops.patch
cris-convert-to-dma_map_ops.patch
nios2-convert-to-dma_map_ops.patch
frv-convert-to-dma_map_ops.patch
parisc-convert-to-dma_map_ops.patch
mn10300-convert-to-dma_map_ops.patch
m68k-convert-to-dma_map_ops.patch
metag-convert-to-dma_map_ops.patch
sparc-use-generic-dma_set_mask.patch
tile-uninline-dma_set_mask.patch
dma-mapping-always-provide-the-dma_map_ops-based-implementation.patch
dma-mapping-remove-asm-generic-dma-coherenth.patch

