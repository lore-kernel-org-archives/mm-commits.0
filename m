From: akpm@linux-foundation.org
Subject: [merged]
 mm-cma-fix-incorrect-type-conversion-for-size-during-dma-allocation.patch
 removed from -mm tree
Date: Fri, 30 Oct 2015 12:44:34 -0700
Message-ID: <5633c8a2.pGAaoChVzYrMst84%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42012 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758403AbbJ3Tof (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 30 Oct 2015 15:44:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rvaswani@codeaurora.org, gregkh@linuxfoundation.org, m.szyprowski@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma: fix incorrect type conversion for size during dma allocation
has been removed from the -mm tree.  Its filename was
     mm-cma-fix-incorrect-type-conversion-for-size-during-dma-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rohit Vaswani <rvaswani@codeaurora.org>
Subject: mm: cma: fix incorrect type conversion for size during dma allocation

This was found during userspace fuzzing test when a large size dma cma
allocation is made by driver(like ion) through userspace.

 show_stack+0x10/0x1c
 dump_stack+0x74/0xc8
 kasan_report_error+0x2b0/0x408
 kasan_report+0x34/0x40
 __asan_storeN+0x15c/0x168
 memset+0x20/0x44
 __dma_alloc_coherent+0x114/0x18c

Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/dma-contiguous.c  |    2 +-
 include/linux/cma.h            |    2 +-
 include/linux/dma-contiguous.h |    4 ++--
 mm/cma.c                       |    4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/base/dma-contiguous.c~mm-cma-fix-incorrect-type-conversion-for-size-during-dma-allocation drivers/base/dma-contiguous.c
--- a/drivers/base/dma-contiguous.c~mm-cma-fix-incorrect-type-conversion-for-size-during-dma-allocation
+++ a/drivers/base/dma-contiguous.c
@@ -187,7 +187,7 @@ int __init dma_contiguous_reserve_area(p
  * global one. Requires architecture specific dev_get_cma_area() helper
  * function.
  */
-struct page *dma_alloc_from_contiguous(struct device *dev, int count,
+struct page *dma_alloc_from_contiguous(struct device *dev, size_t count,
 				       unsigned int align)
 {
 	if (align > CONFIG_CMA_ALIGNMENT)
diff -puN include/linux/cma.h~mm-cma-fix-incorrect-type-conversion-for-size-during-dma-allocation include/linux/cma.h
--- a/include/linux/cma.h~mm-cma-fix-incorrect-type-conversion-for-size-during-dma-allocation
+++ a/include/linux/cma.h
@@ -26,6 +26,6 @@ extern int __init cma_declare_contiguous
 extern int cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
 					unsigned int order_per_bit,
 					struct cma **res_cma);
-extern struct page *cma_alloc(struct cma *cma, unsigned int count, unsigned int align);
+extern struct page *cma_alloc(struct cma *cma, size_t count, unsigned int align);
 extern bool cma_release(struct cma *cma, const struct page *pages, unsigned int count);
 #endif
diff -puN include/linux/dma-contiguous.h~mm-cma-fix-incorrect-type-conversion-for-size-during-dma-allocation include/linux/dma-contiguous.h
--- a/include/linux/dma-contiguous.h~mm-cma-fix-incorrect-type-conversion-for-size-during-dma-allocation
+++ a/include/linux/dma-contiguous.h
@@ -111,7 +111,7 @@ static inline int dma_declare_contiguous
 	return ret;
 }
 
-struct page *dma_alloc_from_contiguous(struct device *dev, int count,
+struct page *dma_alloc_from_contiguous(struct device *dev, size_t count,
 				       unsigned int order);
 bool dma_release_from_contiguous(struct device *dev, struct page *pages,
 				 int count);
@@ -144,7 +144,7 @@ int dma_declare_contiguous(struct device
 }
 
 static inline
-struct page *dma_alloc_from_contiguous(struct device *dev, int count,
+struct page *dma_alloc_from_contiguous(struct device *dev, size_t count,
 				       unsigned int order)
 {
 	return NULL;
diff -puN mm/cma.c~mm-cma-fix-incorrect-type-conversion-for-size-during-dma-allocation mm/cma.c
--- a/mm/cma.c~mm-cma-fix-incorrect-type-conversion-for-size-during-dma-allocation
+++ a/mm/cma.c
@@ -361,7 +361,7 @@ err:
  * This function allocates part of contiguous memory on specific
  * contiguous memory area.
  */
-struct page *cma_alloc(struct cma *cma, unsigned int count, unsigned int align)
+struct page *cma_alloc(struct cma *cma, size_t count, unsigned int align)
 {
 	unsigned long mask, offset, pfn, start = 0;
 	unsigned long bitmap_maxno, bitmap_no, bitmap_count;
@@ -371,7 +371,7 @@ struct page *cma_alloc(struct cma *cma,
 	if (!cma || !cma->count)
 		return NULL;
 
-	pr_debug("%s(cma %p, count %d, align %d)\n", __func__, (void *)cma,
+	pr_debug("%s(cma %p, count %zu, align %d)\n", __func__, (void *)cma,
 		 count, align);
 
 	if (!count)
_

Patches currently in -mm which might be from rvaswani@codeaurora.org are


