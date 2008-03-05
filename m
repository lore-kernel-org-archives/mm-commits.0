From: akpm@linux-foundation.org
Subject: - iommu-parisc-pass-struct-device-to-iommu_alloc_range.patch removed from -mm tree
Date: Tue, 04 Mar 2008 23:46:16 -0800
Message-ID: <200803050746.m257kGP5021749@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52273 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760280AbYCEHtC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 02:49:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, grundler@parisc-linux.org, kyle@parisc-linux.org, matthew@wil.cx, mm-commits@vger.kernel.org


The patch titled
     iommu: parisc: pass struct device to iommu_alloc_range
has been removed from the -mm tree.  Its filename was
     iommu-parisc-pass-struct-device-to-iommu_alloc_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iommu: parisc: pass struct device to iommu_alloc_range
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

This adds struct device argument to sba_alloc_range and ccio_alloc_range, a
preparation for modifications to fix the IOMMU segment boundary problem.  This
change enables ccio_alloc_range to access to LLD's segment boundary limits.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Kyle McMartin <kyle@parisc-linux.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Grant Grundler <grundler@parisc-linux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parisc/ccio-dma.c      |    4 ++--
 drivers/parisc/iommu-helpers.h |    6 +++---
 drivers/parisc/sba_iommu.c     |    4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/parisc/ccio-dma.c~iommu-parisc-pass-struct-device-to-iommu_alloc_range drivers/parisc/ccio-dma.c
--- a/drivers/parisc/ccio-dma.c~iommu-parisc-pass-struct-device-to-iommu_alloc_range
+++ a/drivers/parisc/ccio-dma.c
@@ -341,7 +341,7 @@ static int ioc_count;
  * of available pages for the requested size.
  */
 static int
-ccio_alloc_range(struct ioc *ioc, size_t size)
+ccio_alloc_range(struct ioc *ioc, struct device *dev, size_t size)
 {
 	unsigned int pages_needed = size >> IOVP_SHIFT;
 	unsigned int res_idx;
@@ -760,7 +760,7 @@ ccio_map_single(struct device *dev, void
 	ioc->msingle_pages += size >> IOVP_SHIFT;
 #endif
 
-	idx = ccio_alloc_range(ioc, size);
+	idx = ccio_alloc_range(ioc, dev, size);
 	iovp = (dma_addr_t)MKIOVP(idx);
 
 	pdir_start = &(ioc->pdir_base[idx]);
diff -puN drivers/parisc/iommu-helpers.h~iommu-parisc-pass-struct-device-to-iommu_alloc_range drivers/parisc/iommu-helpers.h
--- a/drivers/parisc/iommu-helpers.h~iommu-parisc-pass-struct-device-to-iommu_alloc_range
+++ a/drivers/parisc/iommu-helpers.h
@@ -96,8 +96,8 @@ iommu_fill_pdir(struct ioc *ioc, struct 
 
 static inline unsigned int
 iommu_coalesce_chunks(struct ioc *ioc, struct device *dev,
-		      struct scatterlist *startsg, int nents,
-		      int (*iommu_alloc_range)(struct ioc *, size_t))
+		struct scatterlist *startsg, int nents,
+		int (*iommu_alloc_range)(struct ioc *, struct device *, size_t))
 {
 	struct scatterlist *contig_sg;	   /* contig chunk head */
 	unsigned long dma_offset, dma_len; /* start/len of DMA stream */
@@ -166,7 +166,7 @@ iommu_coalesce_chunks(struct ioc *ioc, s
 		dma_len = ALIGN(dma_len + dma_offset, IOVP_SIZE);
 		sg_dma_address(contig_sg) =
 			PIDE_FLAG 
-			| (iommu_alloc_range(ioc, dma_len) << IOVP_SHIFT)
+			| (iommu_alloc_range(ioc, dev, dma_len) << IOVP_SHIFT)
 			| dma_offset;
 		n_mappings++;
 	}
diff -puN drivers/parisc/sba_iommu.c~iommu-parisc-pass-struct-device-to-iommu_alloc_range drivers/parisc/sba_iommu.c
--- a/drivers/parisc/sba_iommu.c~iommu-parisc-pass-struct-device-to-iommu_alloc_range
+++ a/drivers/parisc/sba_iommu.c
@@ -404,7 +404,7 @@ sba_search_bitmap(struct ioc *ioc, unsig
  * resource bit map.
  */
 static int
-sba_alloc_range(struct ioc *ioc, size_t size)
+sba_alloc_range(struct ioc *ioc, struct device *dev, size_t size)
 {
 	unsigned int pages_needed = size >> IOVP_SHIFT;
 #ifdef SBA_COLLECT_STATS
@@ -710,7 +710,7 @@ sba_map_single(struct device *dev, void 
 	ioc->msingle_calls++;
 	ioc->msingle_pages += size >> IOVP_SHIFT;
 #endif
-	pide = sba_alloc_range(ioc, size);
+	pide = sba_alloc_range(ioc, dev, size);
 	iovp = (dma_addr_t) pide << IOVP_SHIFT;
 
 	DBG_RUN("%s() 0x%p -> 0x%lx\n",
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

parisc-fix-a-overflow-bug-on-32bit-architectures.patch
git-scsi-misc.patch
mpt-fusion-dont-oops-if-numphys==0.patch

