From: akpm@linux-foundation.org
Subject: - iommu-sg-merging-parisc-make-iommu-respect-the-segment-size-limits.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:28:19 -0800
Message-ID: <200802052228.m15MS0tC011844@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42623 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762824AbYBEWow (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:44:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tomof@acm.org, James.Bottomley@steeleye.com, fujita.tomonori@lab.ntt.co.jp, grundler@parisc-linux.org, jeff@garzik.org, jens.axboe@oracle.com, kyle@mcmartin.ca, willy@debian.org, mm-c


The patch titled
     iommu sg merging: parisc: make iommu respect the segment size limits
has been removed from the -mm tree.  Its filename was
     iommu-sg-merging-parisc-make-iommu-respect-the-segment-size-limits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iommu sg merging: parisc: make iommu respect the segment size limits
From: FUJITA Tomonori <tomof@acm.org>

This patch makes iommu respect segment size limits when merging sg
lists.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Acked-by: Jens Axboe <jens.axboe@oracle.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Acked-by: Grant Grundler <grundler@parisc-linux.org>
Cc: Matthew Wilcox <willy@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parisc/ccio-dma.c      |    2 +-
 drivers/parisc/iommu-helpers.h |    7 ++++++-
 drivers/parisc/sba_iommu.c     |    2 +-
 3 files changed, 8 insertions(+), 3 deletions(-)

diff -puN drivers/parisc/ccio-dma.c~iommu-sg-merging-parisc-make-iommu-respect-the-segment-size-limits drivers/parisc/ccio-dma.c
--- a/drivers/parisc/ccio-dma.c~iommu-sg-merging-parisc-make-iommu-respect-the-segment-size-limits
+++ a/drivers/parisc/ccio-dma.c
@@ -941,7 +941,7 @@ ccio_map_sg(struct device *dev, struct s
 	** w/o this association, we wouldn't have coherent DMA!
 	** Access to the virtual address is what forces a two pass algorithm.
 	*/
-	coalesced = iommu_coalesce_chunks(ioc, sglist, nents, ccio_alloc_range);
+	coalesced = iommu_coalesce_chunks(ioc, dev, sglist, nents, ccio_alloc_range);
 
 	/*
 	** Program the I/O Pdir
diff -puN drivers/parisc/iommu-helpers.h~iommu-sg-merging-parisc-make-iommu-respect-the-segment-size-limits drivers/parisc/iommu-helpers.h
--- a/drivers/parisc/iommu-helpers.h~iommu-sg-merging-parisc-make-iommu-respect-the-segment-size-limits
+++ a/drivers/parisc/iommu-helpers.h
@@ -95,12 +95,14 @@ iommu_fill_pdir(struct ioc *ioc, struct 
 */
 
 static inline unsigned int
-iommu_coalesce_chunks(struct ioc *ioc, struct scatterlist *startsg, int nents,
+iommu_coalesce_chunks(struct ioc *ioc, struct device *dev,
+		      struct scatterlist *startsg, int nents,
 		      int (*iommu_alloc_range)(struct ioc *, size_t))
 {
 	struct scatterlist *contig_sg;	   /* contig chunk head */
 	unsigned long dma_offset, dma_len; /* start/len of DMA stream */
 	unsigned int n_mappings = 0;
+	unsigned int max_seg_size = dma_get_max_seg_size(dev);
 
 	while (nents > 0) {
 
@@ -142,6 +144,9 @@ iommu_coalesce_chunks(struct ioc *ioc, s
 					    IOVP_SIZE) > DMA_CHUNK_SIZE))
 				break;
 
+			if (startsg->length + dma_len > max_seg_size)
+				break;
+
 			/*
 			** Next see if we can append the next chunk (i.e.
 			** it must end on one page and begin on another
diff -puN drivers/parisc/sba_iommu.c~iommu-sg-merging-parisc-make-iommu-respect-the-segment-size-limits drivers/parisc/sba_iommu.c
--- a/drivers/parisc/sba_iommu.c~iommu-sg-merging-parisc-make-iommu-respect-the-segment-size-limits
+++ a/drivers/parisc/sba_iommu.c
@@ -946,7 +946,7 @@ sba_map_sg(struct device *dev, struct sc
 	** w/o this association, we wouldn't have coherent DMA!
 	** Access to the virtual address is what forces a two pass algorithm.
 	*/
-	coalesced = iommu_coalesce_chunks(ioc, sglist, nents, sba_alloc_range);
+	coalesced = iommu_coalesce_chunks(ioc, dev, sglist, nents, sba_alloc_range);
 
 	/*
 	** Program the I/O Pdir
_

Patches currently in -mm which might be from tomof@acm.org are

origin.patch
