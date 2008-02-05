From: akpm@linux-foundation.org
Subject: - iommu-sg-merging-ia64-make-sba_iommu-respect-the-segment-size-limits.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:28:08 -0800
Message-ID: <200802052227.m15MRn76011832@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59779 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762722AbYBEWoR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:44:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tomof@acm.org, James.Bottomley@steeleye.com, fujita.tomonori@lab.ntt.co.jp, jeff@garzik.org, jens.axboe@oracle.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     iommu sg merging: IA64: make sba_iommu respect the segment size limits
has been removed from the -mm tree.  Its filename was
     iommu-sg-merging-ia64-make-sba_iommu-respect-the-segment-size-limits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iommu sg merging: IA64: make sba_iommu respect the segment size limits
From: FUJITA Tomonori <tomof@acm.org>

This patch makes sba iommu respect segment size limits when merging sg
lists.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Acked-by: Jens Axboe <jens.axboe@oracle.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/hp/common/sba_iommu.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN arch/ia64/hp/common/sba_iommu.c~iommu-sg-merging-ia64-make-sba_iommu-respect-the-segment-size-limits arch/ia64/hp/common/sba_iommu.c
--- a/arch/ia64/hp/common/sba_iommu.c~iommu-sg-merging-ia64-make-sba_iommu-respect-the-segment-size-limits
+++ a/arch/ia64/hp/common/sba_iommu.c
@@ -1265,7 +1265,7 @@ sba_fill_pdir(
  * the sglist do both.
  */
 static SBA_INLINE int
-sba_coalesce_chunks( struct ioc *ioc,
+sba_coalesce_chunks(struct ioc *ioc, struct device *dev,
 	struct scatterlist *startsg,
 	int nents)
 {
@@ -1275,6 +1275,7 @@ sba_coalesce_chunks( struct ioc *ioc,
 	struct scatterlist *dma_sg;        /* next DMA stream head */
 	unsigned long dma_offset, dma_len; /* start/len of DMA stream */
 	int n_mappings = 0;
+	unsigned int max_seg_size = dma_get_max_seg_size(dev);
 
 	while (nents > 0) {
 		unsigned long vaddr = (unsigned long) sba_sg_address(startsg);
@@ -1314,6 +1315,9 @@ sba_coalesce_chunks( struct ioc *ioc,
 			    > DMA_CHUNK_SIZE)
 				break;
 
+			if (dma_len + startsg->length > max_seg_size)
+				break;
+
 			/*
 			** Then look for virtually contiguous blocks.
 			**
@@ -1441,7 +1445,7 @@ int sba_map_sg(struct device *dev, struc
 	** w/o this association, we wouldn't have coherent DMA!
 	** Access to the virtual address is what forces a two pass algorithm.
 	*/
-	coalesced = sba_coalesce_chunks(ioc, sglist, nents);
+	coalesced = sba_coalesce_chunks(ioc, dev, sglist, nents);
 
 	/*
 	** Program the I/O Pdir
_

Patches currently in -mm which might be from tomof@acm.org are

origin.patch
