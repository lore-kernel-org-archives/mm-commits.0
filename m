From: akpm@linux-foundation.org
Subject: [merged] dma-cma-support-arbitrary-bitmap-granularity.patch
 removed from -mm tree
Date: Thu, 07 Aug 2014 13:04:01 -0700
Message-ID: <53e3dbb1.TXEdpvuUwGf4c/C1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:49666 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755062AbaHGUEC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:04:02 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so1177172pab.1
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:04:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, agraf@suse.de, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, gleb@kernel.org, m.szyprowski@samsung.com, mina86@mina86.com, minchan@kernel.org, paulus@samba.org, pbonzini@redhat.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: DMA, CMA: support arbitrary bitmap granularity
has been removed from the -mm tree.  Its filename was
     dma-cma-support-arbitrary-bitmap-granularity.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: DMA, CMA: support arbitrary bitmap granularity

PPC KVM's CMA area management requires arbitrary bitmap granularity, since
they want to reserve very large memory and manage this region with bitmap
that one bit for several pages to reduce management overheads.  So support
arbitrary bitmap granularity for following generalization.

[akpm@linux-foundation.org: s/1/1UL/]
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Acked-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Alexander Graf <agraf@suse.de>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Gleb Natapov <gleb@kernel.org>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/dma-contiguous.c |   77 ++++++++++++++++++++++----------
 1 file changed, 53 insertions(+), 24 deletions(-)

diff -puN drivers/base/dma-contiguous.c~dma-cma-support-arbitrary-bitmap-granularity drivers/base/dma-contiguous.c
--- a/drivers/base/dma-contiguous.c~dma-cma-support-arbitrary-bitmap-granularity
+++ a/drivers/base/dma-contiguous.c
@@ -38,6 +38,7 @@ struct cma {
 	unsigned long	base_pfn;
 	unsigned long	count;
 	unsigned long	*bitmap;
+	unsigned int order_per_bit; /* Order of pages represented by one bit */
 	struct mutex	lock;
 };
 
@@ -157,9 +158,37 @@ void __init dma_contiguous_reserve(phys_
 
 static DEFINE_MUTEX(cma_mutex);
 
+static unsigned long cma_bitmap_aligned_mask(struct cma *cma, int align_order)
+{
+	return (1UL << (align_order >> cma->order_per_bit)) - 1;
+}
+
+static unsigned long cma_bitmap_maxno(struct cma *cma)
+{
+	return cma->count >> cma->order_per_bit;
+}
+
+static unsigned long cma_bitmap_pages_to_bits(struct cma *cma,
+						unsigned long pages)
+{
+	return ALIGN(pages, 1UL << cma->order_per_bit) >> cma->order_per_bit;
+}
+
+static void cma_clear_bitmap(struct cma *cma, unsigned long pfn, int count)
+{
+	unsigned long bitmap_no, bitmap_count;
+
+	bitmap_no = (pfn - cma->base_pfn) >> cma->order_per_bit;
+	bitmap_count = cma_bitmap_pages_to_bits(cma, count);
+
+	mutex_lock(&cma->lock);
+	bitmap_clear(cma->bitmap, bitmap_no, bitmap_count);
+	mutex_unlock(&cma->lock);
+}
+
 static int __init cma_activate_area(struct cma *cma)
 {
-	int bitmap_size = BITS_TO_LONGS(cma->count) * sizeof(long);
+	int bitmap_size = BITS_TO_LONGS(cma_bitmap_maxno(cma)) * sizeof(long);
 	unsigned long base_pfn = cma->base_pfn, pfn = base_pfn;
 	unsigned i = cma->count >> pageblock_order;
 	struct zone *zone;
@@ -215,9 +244,9 @@ static int __init cma_init_reserved_area
 core_initcall(cma_init_reserved_areas);
 
 static int __init __dma_contiguous_reserve_area(phys_addr_t size,
-				phys_addr_t base, phys_addr_t limit,
-				phys_addr_t alignment,
-				struct cma **res_cma, bool fixed)
+			phys_addr_t base, phys_addr_t limit,
+			phys_addr_t alignment, unsigned int order_per_bit,
+			struct cma **res_cma, bool fixed)
 {
 	struct cma *cma = &cma_areas[cma_area_count];
 	int ret = 0;
@@ -249,6 +278,10 @@ static int __init __dma_contiguous_reser
 	size = ALIGN(size, alignment);
 	limit &= ~(alignment - 1);
 
+	/* size should be aligned with order_per_bit */
+	if (!IS_ALIGNED(size >> PAGE_SHIFT, 1 << order_per_bit))
+		return -EINVAL;
+
 	/* Reserve memory */
 	if (base && fixed) {
 		if (memblock_is_region_reserved(base, size) ||
@@ -273,6 +306,7 @@ static int __init __dma_contiguous_reser
 	 */
 	cma->base_pfn = PFN_DOWN(base);
 	cma->count = size >> PAGE_SHIFT;
+	cma->order_per_bit = order_per_bit;
 	*res_cma = cma;
 	cma_area_count++;
 
@@ -308,7 +342,7 @@ int __init dma_contiguous_reserve_area(p
 {
 	int ret;
 
-	ret = __dma_contiguous_reserve_area(size, base, limit, 0,
+	ret = __dma_contiguous_reserve_area(size, base, limit, 0, 0,
 						res_cma, fixed);
 	if (ret)
 		return ret;
@@ -320,17 +354,11 @@ int __init dma_contiguous_reserve_area(p
 	return 0;
 }
 
-static void clear_cma_bitmap(struct cma *cma, unsigned long pfn, int count)
-{
-	mutex_lock(&cma->lock);
-	bitmap_clear(cma->bitmap, pfn - cma->base_pfn, count);
-	mutex_unlock(&cma->lock);
-}
-
 static struct page *__dma_alloc_from_contiguous(struct cma *cma, int count,
 				       unsigned int align)
 {
-	unsigned long mask, pfn, pageno, start = 0;
+	unsigned long mask, pfn, start = 0;
+	unsigned long bitmap_maxno, bitmap_no, bitmap_count;
 	struct page *page = NULL;
 	int ret;
 
@@ -343,18 +371,19 @@ static struct page *__dma_alloc_from_con
 	if (!count)
 		return NULL;
 
-	mask = (1 << align) - 1;
-
+	mask = cma_bitmap_aligned_mask(cma, align);
+	bitmap_maxno = cma_bitmap_maxno(cma);
+	bitmap_count = cma_bitmap_pages_to_bits(cma, count);
 
 	for (;;) {
 		mutex_lock(&cma->lock);
-		pageno = bitmap_find_next_zero_area(cma->bitmap, cma->count,
-						    start, count, mask);
-		if (pageno >= cma->count) {
+		bitmap_no = bitmap_find_next_zero_area(cma->bitmap,
+				bitmap_maxno, start, bitmap_count, mask);
+		if (bitmap_no >= bitmap_maxno) {
 			mutex_unlock(&cma->lock);
 			break;
 		}
-		bitmap_set(cma->bitmap, pageno, count);
+		bitmap_set(cma->bitmap, bitmap_no, bitmap_count);
 		/*
 		 * It's safe to drop the lock here. We've marked this region for
 		 * our exclusive use. If the migration fails we will take the
@@ -362,7 +391,7 @@ static struct page *__dma_alloc_from_con
 		 */
 		mutex_unlock(&cma->lock);
 
-		pfn = cma->base_pfn + pageno;
+		pfn = cma->base_pfn + (bitmap_no << cma->order_per_bit);
 		mutex_lock(&cma_mutex);
 		ret = alloc_contig_range(pfn, pfn + count, MIGRATE_CMA);
 		mutex_unlock(&cma_mutex);
@@ -370,14 +399,14 @@ static struct page *__dma_alloc_from_con
 			page = pfn_to_page(pfn);
 			break;
 		} else if (ret != -EBUSY) {
-			clear_cma_bitmap(cma, pfn, count);
+			cma_clear_bitmap(cma, pfn, count);
 			break;
 		}
-		clear_cma_bitmap(cma, pfn, count);
+		cma_clear_bitmap(cma, pfn, count);
 		pr_debug("%s(): memory range at %p is busy, retrying\n",
 			 __func__, pfn_to_page(pfn));
 		/* try again with a bit different memory target */
-		start = pageno + mask + 1;
+		start = bitmap_no + mask + 1;
 	}
 
 	pr_debug("%s(): returned %p\n", __func__, page);
@@ -424,7 +453,7 @@ static bool __dma_release_from_contiguou
 	VM_BUG_ON(pfn + count > cma->base_pfn + cma->count);
 
 	free_contig_range(pfn, count);
-	clear_cma_bitmap(cma, pfn, count);
+	cma_clear_bitmap(cma, pfn, count);
 
 	return true;
 }
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
page-owners-correct-page-order-when-to-free-page.patch

