From: akpm@linux-foundation.org
Subject: - sparc64-add-the-segment-boundary-checking-to-iommus-while-merging-sg-entries.patch removed from -mm tree
Date: Mon, 31 Mar 2008 13:19:06 -0700
Message-ID: <200803312019.m2VKJ6bL024180@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47954 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754274AbYCaUTo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Mar 2008 16:19:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     sparc64: add the segment boundary checking to IOMMUs while merging SG entries
has been removed from the -mm tree.  Its filename was
     sparc64-add-the-segment-boundary-checking-to-iommus-while-merging-sg-entries.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sparc64: add the segment boundary checking to IOMMUs while merging SG entries
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Some IOMMUs allocate memory areas spanning LLD's segment boundary limit.  It
forces low level drivers to have a workaround to adjust scatter lists that the
IOMMU builds.  We are in the process of making all the IOMMUs respect the
segment boundary limits to remove such work around in LLDs.

SPARC64 IOMMUs were rewritten to use the IOMMU helper functions and the commit
89c94f2f70d093f59b55d3ea8042d13889169346 made the IOMMUs not allocate memory
areas spanning the segment boundary limit.

However, SPARC64 IOMMUs allocate memory areas first then try to merge them
(while some IOMMUs walk through all the sg entries to see how they can be
merged first and allocate memory areas).  So SPARC64 IOMMUs also need the
boundary limit checking when they try to merge sg entries.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc64/kernel/iommu.c        |   12 ++++++++++--
 arch/sparc64/kernel/iommu_common.h |   13 +++++++++++++
 arch/sparc64/kernel/pci_sun4v.c    |   12 ++++++++++--
 3 files changed, 33 insertions(+), 4 deletions(-)

diff -puN arch/sparc64/kernel/iommu.c~sparc64-add-the-segment-boundary-checking-to-iommus-while-merging-sg-entries arch/sparc64/kernel/iommu.c
--- a/arch/sparc64/kernel/iommu.c~sparc64-add-the-segment-boundary-checking-to-iommus-while-merging-sg-entries
+++ a/arch/sparc64/kernel/iommu.c
@@ -516,9 +516,11 @@ static int dma_4u_map_sg(struct device *
 	unsigned long flags, handle, prot, ctx;
 	dma_addr_t dma_next = 0, dma_addr;
 	unsigned int max_seg_size;
+	unsigned long seg_boundary_size;
 	int outcount, incount, i;
 	struct strbuf *strbuf;
 	struct iommu *iommu;
+	unsigned long base_shift;
 
 	BUG_ON(direction == DMA_NONE);
 
@@ -549,8 +551,11 @@ static int dma_4u_map_sg(struct device *
 	outs->dma_length = 0;
 
 	max_seg_size = dma_get_max_seg_size(dev);
+	seg_boundary_size = ALIGN(dma_get_seg_boundary(dev) + 1,
+				  IO_PAGE_SIZE) >> IO_PAGE_SHIFT;
+	base_shift = iommu->page_table_map_base >> IO_PAGE_SHIFT;
 	for_each_sg(sglist, s, nelems, i) {
-		unsigned long paddr, npages, entry, slen;
+		unsigned long paddr, npages, entry, out_entry = 0, slen;
 		iopte_t *base;
 
 		slen = s->length;
@@ -593,7 +598,9 @@ static int dma_4u_map_sg(struct device *
 			 * - allocated dma_addr isn't contiguous to previous allocation
 			 */
 			if ((dma_addr != dma_next) ||
-			    (outs->dma_length + s->length > max_seg_size)) {
+			    (outs->dma_length + s->length > max_seg_size) ||
+			    (is_span_boundary(out_entry, base_shift,
+					      seg_boundary_size, outs, s))) {
 				/* Can't merge: create a new segment */
 				segstart = s;
 				outcount++;
@@ -607,6 +614,7 @@ static int dma_4u_map_sg(struct device *
 			/* This is a new segment, fill entries */
 			outs->dma_address = dma_addr;
 			outs->dma_length = slen;
+			out_entry = entry;
 		}
 
 		/* Calculate next page pointer for contiguous check */
diff -puN arch/sparc64/kernel/iommu_common.h~sparc64-add-the-segment-boundary-checking-to-iommus-while-merging-sg-entries arch/sparc64/kernel/iommu_common.h
--- a/arch/sparc64/kernel/iommu_common.h~sparc64-add-the-segment-boundary-checking-to-iommus-while-merging-sg-entries
+++ a/arch/sparc64/kernel/iommu_common.h
@@ -12,6 +12,7 @@
 #include <linux/mm.h>
 #include <linux/scatterlist.h>
 #include <linux/device.h>
+#include <linux/iommu-helper.h>
 
 #include <asm/iommu.h>
 #include <asm/scatterlist.h>
@@ -58,6 +59,18 @@ static inline unsigned long calc_npages(
 	return npages;
 }
 
+static inline int is_span_boundary(unsigned long entry,
+				   unsigned long shift,
+				   unsigned long boundary_size,
+				   struct scatterlist *outs,
+				   struct scatterlist *sg)
+{
+	unsigned long paddr = SG_ENT_PHYS_ADDRESS(outs);
+	int nr = iommu_num_pages(paddr, outs->dma_length + sg->length);
+
+	return iommu_is_span_boundary(entry, nr, shift, boundary_size);
+}
+
 extern unsigned long iommu_range_alloc(struct device *dev,
 				       struct iommu *iommu,
 				       unsigned long npages,
diff -puN arch/sparc64/kernel/pci_sun4v.c~sparc64-add-the-segment-boundary-checking-to-iommus-while-merging-sg-entries arch/sparc64/kernel/pci_sun4v.c
--- a/arch/sparc64/kernel/pci_sun4v.c~sparc64-add-the-segment-boundary-checking-to-iommus-while-merging-sg-entries
+++ a/arch/sparc64/kernel/pci_sun4v.c
@@ -335,8 +335,10 @@ static int dma_4v_map_sg(struct device *
 	unsigned long flags, handle, prot;
 	dma_addr_t dma_next = 0, dma_addr;
 	unsigned int max_seg_size;
+	unsigned long seg_boundary_size;
 	int outcount, incount, i;
 	struct iommu *iommu;
+	unsigned long base_shift;
 	long err;
 
 	BUG_ON(direction == DMA_NONE);
@@ -362,8 +364,11 @@ static int dma_4v_map_sg(struct device *
 	iommu_batch_start(dev, prot, ~0UL);
 
 	max_seg_size = dma_get_max_seg_size(dev);
+	seg_boundary_size = ALIGN(dma_get_seg_boundary(dev) + 1,
+				  IO_PAGE_SIZE) >> IO_PAGE_SHIFT;
+	base_shift = iommu->page_table_map_base >> IO_PAGE_SHIFT;
 	for_each_sg(sglist, s, nelems, i) {
-		unsigned long paddr, npages, entry, slen;
+		unsigned long paddr, npages, entry, out_entry = 0, slen;
 
 		slen = s->length;
 		/* Sanity check */
@@ -406,7 +411,9 @@ static int dma_4v_map_sg(struct device *
 			 * - allocated dma_addr isn't contiguous to previous allocation
 			 */
 			if ((dma_addr != dma_next) ||
-			    (outs->dma_length + s->length > max_seg_size)) {
+			    (outs->dma_length + s->length > max_seg_size) ||
+			    (is_span_boundary(out_entry, base_shift,
+					      seg_boundary_size, outs, s))) {
 				/* Can't merge: create a new segment */
 				segstart = s;
 				outcount++;
@@ -420,6 +427,7 @@ static int dma_4v_map_sg(struct device *
 			/* This is a new segment, fill entries */
 			outs->dma_address = dma_addr;
 			outs->dma_length = slen;
+			out_entry = entry;
 		}
 
 		/* Calculate next page pointer for contiguous check */
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

lib-swiotlbc-avoid-endless-loops-fix.patch
ia64-make-iommu-respect-the-segment-boundary-limits.patch
git-scsi-misc.patch
drivers-scsi-hptiopc-fix-build-warning.patch
git-sparc64.patch
lib-swiotlbc-cleanups.patch

