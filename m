From: akpm@linux-foundation.org
Subject: + ia64-fix-sba-iommu-to-handle-allocation-failure-properly.patch added to -mm tree
Date: Mon, 02 Nov 2009 22:55:05 -0800
Message-ID: <200911030655.nA36t5iH004529@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56417 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753248AbZKCGzi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Nov 2009 01:55:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, fenghua.yu@intel.com, tony.luck@intel.com


The patch titled
     ia64: fix SBA IOMMU to handle allocation failure properly
has been added to the -mm tree.  Its filename is
     ia64-fix-sba-iommu-to-handle-allocation-failure-properly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ia64: fix SBA IOMMU to handle allocation failure properly
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

It's possible that SBA IOMMU might fail to find I/O space under heavy
I/Os.  SBA IOMMU panics on allocation failure but it shouldn't; drivers
can handle the failure.  The majority of other IOMMU drivers don't panic
on allocation failure.

This patch fixes SBA IOMMU path to handle allocation failure properly.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/hp/common/sba_iommu.c |   38 ++++++++++++++++++++++--------
 1 file changed, 29 insertions(+), 9 deletions(-)

diff -puN arch/ia64/hp/common/sba_iommu.c~ia64-fix-sba-iommu-to-handle-allocation-failure-properly arch/ia64/hp/common/sba_iommu.c
--- a/arch/ia64/hp/common/sba_iommu.c~ia64-fix-sba-iommu-to-handle-allocation-failure-properly
+++ a/arch/ia64/hp/common/sba_iommu.c
@@ -677,12 +677,19 @@ sba_alloc_range(struct ioc *ioc, struct 
 			spin_unlock_irqrestore(&ioc->saved_lock, flags);
 
 			pide = sba_search_bitmap(ioc, dev, pages_needed, 0);
-			if (unlikely(pide >= (ioc->res_size << 3)))
-				panic(__FILE__ ": I/O MMU @ %p is out of mapping resources\n",
-				      ioc->ioc_hpa);
+			if (unlikely(pide >= (ioc->res_size << 3))) {
+				printk(KERN_WARNING "%s: I/O MMU @ %p is"
+				       "out of mapping resources, %u %u %lx\n",
+				       __func__, ioc->ioc_hpa, ioc->res_size,
+				       pages_needed, dma_get_seg_boundary(dev));
+				return -1;
+			}
 #else
-			panic(__FILE__ ": I/O MMU @ %p is out of mapping resources\n",
-			      ioc->ioc_hpa);
+			printk(KERN_WARNING "%s: I/O MMU @ %p is"
+			       "out of mapping resources, %u %u %lx\n",
+			       __func__, ioc->ioc_hpa, ioc->res_size,
+			       pages_needed, dma_get_seg_boundary(dev));
+			return -1;
 #endif
 		}
 	}
@@ -965,6 +972,8 @@ static dma_addr_t sba_map_page(struct de
 #endif
 
 	pide = sba_alloc_range(ioc, dev, size);
+	if (pide < 0)
+		return 0;
 
 	iovp = (dma_addr_t) pide << iovp_shift;
 
@@ -1320,6 +1329,7 @@ sba_coalesce_chunks(struct ioc *ioc, str
 	unsigned long dma_offset, dma_len; /* start/len of DMA stream */
 	int n_mappings = 0;
 	unsigned int max_seg_size = dma_get_max_seg_size(dev);
+	int idx;
 
 	while (nents > 0) {
 		unsigned long vaddr = (unsigned long) sba_sg_address(startsg);
@@ -1418,16 +1428,22 @@ sba_coalesce_chunks(struct ioc *ioc, str
 		vcontig_sg->dma_length = vcontig_len;
 		dma_len = (dma_len + dma_offset + ~iovp_mask) & iovp_mask;
 		ASSERT(dma_len <= DMA_CHUNK_SIZE);
-		dma_sg->dma_address = (dma_addr_t) (PIDE_FLAG
-			| (sba_alloc_range(ioc, dev, dma_len) << iovp_shift)
-			| dma_offset);
+		idx = sba_alloc_range(ioc, dev, dma_len);
+		if (idx < 0) {
+			dma_sg->dma_length = 0;
+			return -1;
+		}
+		dma_sg->dma_address = (dma_addr_t)(PIDE_FLAG | (idx << iovp_shift)
+						   | dma_offset);
 		n_mappings++;
 	}
 
 	return n_mappings;
 }
 
-
+static void sba_unmap_sg_attrs(struct device *dev, struct scatterlist *sglist,
+			       int nents, enum dma_data_direction dir,
+			       struct dma_attrs *attrs);
 /**
  * sba_map_sg - map Scatter/Gather list
  * @dev: instance of PCI owned by the driver that's asking.
@@ -1493,6 +1509,10 @@ static int sba_map_sg_attrs(struct devic
 	** Access to the virtual address is what forces a two pass algorithm.
 	*/
 	coalesced = sba_coalesce_chunks(ioc, dev, sglist, nents);
+	if (coalesced < 0) {
+		sba_unmap_sg_attrs(dev, sglist, nents, dir, attrs);
+		return 0;
+	}
 
 	/*
 	** Program the I/O Pdir
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

ia64-fix-sba-iommu-to-handle-allocation-failure-properly.patch
scsi-add-__init-__exit-macros-to-ibmvstgtc.patch
dma-mapping-fix-off-by-one-error-in-dma_capable.patch
bitmap-introduce-bitmap_set-bitmap_clear-bitmap_find_next_zero_area.patch
iommu-helper-use-bitmap-library.patch

