From: akpm@linux-foundation.org
Subject: + iommu-sg-merging-ppc-make-iommu-respect-the-segment-size-limits.patch added to -mm tree
Date: Thu, 15 Nov 2007 14:05:23 -0800
Message-ID: <200711152205.lAFM5NQQ018091@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44565 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754841AbXKOWcy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 17:32:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tomof@acm.org, James.Bottomley@steeleye.com, benh@kernel.crashing.org, fujita.tomonori@lab.ntt.co.jp, jeff@garzik.org, jens.axboe@oracle.com, paulus@samba.org


The patch titled
     iommu sg merging: ppc: make iommu respect the segment size limits
has been added to the -mm tree.  Its filename is
     iommu-sg-merging-ppc-make-iommu-respect-the-segment-size-limits.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: iommu sg merging: ppc: make iommu respect the segment size limits
From: FUJITA Tomonori <tomof@acm.org>

This patch makes iommu respect segment size limits when merging sg
lists.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/dma_64.c |    2 +-
 arch/powerpc/kernel/iommu.c  |    8 ++++++--
 include/asm-powerpc/iommu.h  |    2 +-
 3 files changed, 8 insertions(+), 4 deletions(-)

diff -puN arch/powerpc/kernel/dma_64.c~iommu-sg-merging-ppc-make-iommu-respect-the-segment-size-limits arch/powerpc/kernel/dma_64.c
--- a/arch/powerpc/kernel/dma_64.c~iommu-sg-merging-ppc-make-iommu-respect-the-segment-size-limits
+++ a/arch/powerpc/kernel/dma_64.c
@@ -68,7 +68,7 @@ static void dma_iommu_unmap_single(struc
 static int dma_iommu_map_sg(struct device *dev, struct scatterlist *sglist,
 			    int nelems, enum dma_data_direction direction)
 {
-	return iommu_map_sg(dev->archdata.dma_data, sglist, nelems,
+	return iommu_map_sg(dev, sglist, nelems,
 			    device_to_mask(dev), direction);
 }
 
diff -puN arch/powerpc/kernel/iommu.c~iommu-sg-merging-ppc-make-iommu-respect-the-segment-size-limits arch/powerpc/kernel/iommu.c
--- a/arch/powerpc/kernel/iommu.c~iommu-sg-merging-ppc-make-iommu-respect-the-segment-size-limits
+++ a/arch/powerpc/kernel/iommu.c
@@ -270,15 +270,17 @@ static void iommu_free(struct iommu_tabl
 	spin_unlock_irqrestore(&(tbl->it_lock), flags);
 }
 
-int iommu_map_sg(struct iommu_table *tbl, struct scatterlist *sglist,
+int iommu_map_sg(struct device *dev, struct scatterlist *sglist,
 		 int nelems, unsigned long mask,
 		 enum dma_data_direction direction)
 {
+	struct iommu_table *tbl = dev->archdata.dma_data;
 	dma_addr_t dma_next = 0, dma_addr;
 	unsigned long flags;
 	struct scatterlist *s, *outs, *segstart;
 	int outcount, incount, i;
 	unsigned long handle;
+	unsigned int max_seg_size;
 
 	BUG_ON(direction == DMA_NONE);
 
@@ -297,6 +299,7 @@ int iommu_map_sg(struct iommu_table *tbl
 
 	spin_lock_irqsave(&(tbl->it_lock), flags);
 
+	max_seg_size = dma_get_max_seg_size(dev);
 	for_each_sg(sglist, s, nelems, i) {
 		unsigned long vaddr, npages, entry, slen;
 
@@ -338,7 +341,8 @@ int iommu_map_sg(struct iommu_table *tbl
 			/* We cannot merge if:
 			 * - allocated dma_addr isn't contiguous to previous allocation
 			 */
-			if (novmerge || (dma_addr != dma_next)) {
+			if (novmerge || (dma_addr != dma_next) ||
+			    (outs->dma_length + s->length > max_seg_size)) {
 				/* Can't merge: create a new segment */
 				segstart = s;
 				outcount++;
diff -puN include/asm-powerpc/iommu.h~iommu-sg-merging-ppc-make-iommu-respect-the-segment-size-limits include/asm-powerpc/iommu.h
--- a/include/asm-powerpc/iommu.h~iommu-sg-merging-ppc-make-iommu-respect-the-segment-size-limits
+++ a/include/asm-powerpc/iommu.h
@@ -80,7 +80,7 @@ extern void iommu_free_table(struct devi
 extern struct iommu_table *iommu_init_table(struct iommu_table * tbl,
 					    int nid);
 
-extern int iommu_map_sg(struct iommu_table *tbl, struct scatterlist *sglist,
+extern int iommu_map_sg(struct device *dev, struct scatterlist *sglist,
 			int nelems, unsigned long mask,
 			enum dma_data_direction direction);
 extern void iommu_unmap_sg(struct iommu_table *tbl, struct scatterlist *sglist,
_

Patches currently in -mm which might be from tomof@acm.org are

git-scsi-misc.patch
iommu-sg-merging-add-device_dma_parameters-structure.patch
iommu-sg-merging-pci-add-device_dma_parameters-support.patch
iommu-sg-merging-x86-make-pci-gart-iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-ppc-make-iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-ia64-make-sba_iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-alpha-make-pci_iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-sparc64-make-iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-parisc-make-iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-call-blk_queue_segment_boundary-in-__scsi_alloc_queue.patch
iommu-sg-merging-sata_inic162x-use-pci_set_dma_max_seg_size.patch
iommu-sg-merging-aacraid-use-pci_set_dma_max_seg_size.patch
