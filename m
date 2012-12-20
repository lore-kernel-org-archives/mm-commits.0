From: akpm@linux-foundation.org
Subject: + cma-use-unsigned-type-for-count-argument.patch added to -mm tree
Date: Thu, 20 Dec 2012 15:37:04 -0800
Message-ID: <20121220233705.3F6C882004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:44220 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab2LTXhG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Dec 2012 18:37:06 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so426043vbi.3
        for <mm-commits@vger.kernel.org>; Thu, 20 Dec 2012 15:37:05 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mina86@mina86.com, rientjes@google.com, rmk@arm.linux.org.uk


The patch titled
     Subject: cma: use unsigned type for count argument
has been added to the -mm tree.  Its filename is
     cma-use-unsigned-type-for-count-argument.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Nazarewicz <mina86@mina86.com>
Subject: cma: use unsigned type for count argument

Specifying negative size of buffer makes no sense and thus this commit
changes the type of the count argument to unsigned.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/dma-mapping.c      |   12 ++++++------
 drivers/base/dma-contiguous.c  |    6 +++---
 include/linux/dma-contiguous.h |    8 ++++----
 3 files changed, 13 insertions(+), 13 deletions(-)

diff -puN arch/arm/mm/dma-mapping.c~cma-use-unsigned-type-for-count-argument arch/arm/mm/dma-mapping.c
--- a/arch/arm/mm/dma-mapping.c~cma-use-unsigned-type-for-count-argument
+++ a/arch/arm/mm/dma-mapping.c
@@ -1038,9 +1038,9 @@ static struct page **__iommu_alloc_buffe
 					  gfp_t gfp, struct dma_attrs *attrs)
 {
 	struct page **pages;
-	int count = size >> PAGE_SHIFT;
-	int array_size = count * sizeof(struct page *);
-	int i = 0;
+	unsigned int count = size >> PAGE_SHIFT;
+	unsigned int array_size = count * sizeof(struct page *);
+	unsigned int i = 0;
 
 	if (array_size <= PAGE_SIZE)
 		pages = kzalloc(array_size, gfp);
@@ -1102,9 +1102,9 @@ error:
 static int __iommu_free_buffer(struct device *dev, struct page **pages,
 			       size_t size, struct dma_attrs *attrs)
 {
-	int count = size >> PAGE_SHIFT;
-	int array_size = count * sizeof(struct page *);
-	int i;
+	unsigned int count = size >> PAGE_SHIFT;
+	unsigned int array_size = count * sizeof(struct page *);
+	unsigned int i;
 
 	if (dma_get_attr(DMA_ATTR_FORCE_CONTIGUOUS, attrs)) {
 		dma_release_from_contiguous(dev, pages[0], count);
diff -puN drivers/base/dma-contiguous.c~cma-use-unsigned-type-for-count-argument drivers/base/dma-contiguous.c
--- a/drivers/base/dma-contiguous.c~cma-use-unsigned-type-for-count-argument
+++ a/drivers/base/dma-contiguous.c
@@ -303,7 +303,7 @@ err:
  * global one. Requires architecture specific get_dev_cma_area() helper
  * function.
  */
-struct page *dma_alloc_from_contiguous(struct device *dev, int count,
+struct page *dma_alloc_from_contiguous(struct device *dev, unsigned int count,
 				       unsigned int align)
 {
 	unsigned long mask, pfn, pageno, start = 0;
@@ -317,7 +317,7 @@ struct page *dma_alloc_from_contiguous(s
 	if (align > CONFIG_CMA_ALIGNMENT)
 		align = CONFIG_CMA_ALIGNMENT;
 
-	pr_debug("%s(cma %p, count %d, align %d)\n", __func__, (void *)cma,
+	pr_debug("%s(cma %p, count %u, align %u)\n", __func__, (void *)cma,
 		 count, align);
 
 	if (!count)
@@ -364,7 +364,7 @@ struct page *dma_alloc_from_contiguous(s
  * true otherwise.
  */
 bool dma_release_from_contiguous(struct device *dev, struct page *pages,
-				 int count)
+				 unsigned int count)
 {
 	struct cma *cma = dev_get_cma_area(dev);
 	unsigned long pfn;
diff -puN include/linux/dma-contiguous.h~cma-use-unsigned-type-for-count-argument include/linux/dma-contiguous.h
--- a/include/linux/dma-contiguous.h~cma-use-unsigned-type-for-count-argument
+++ a/include/linux/dma-contiguous.h
@@ -71,10 +71,10 @@ void dma_contiguous_reserve(phys_addr_t 
 int dma_declare_contiguous(struct device *dev, phys_addr_t size,
 			   phys_addr_t base, phys_addr_t limit);
 
-struct page *dma_alloc_from_contiguous(struct device *dev, int count,
+struct page *dma_alloc_from_contiguous(struct device *dev, unsigned int count,
 				       unsigned int order);
 bool dma_release_from_contiguous(struct device *dev, struct page *pages,
-				 int count);
+				 unsigned int count);
 
 #else
 
@@ -90,7 +90,7 @@ int dma_declare_contiguous(struct device
 }
 
 static inline
-struct page *dma_alloc_from_contiguous(struct device *dev, int count,
+struct page *dma_alloc_from_contiguous(struct device *dev, unsigned int count,
 				       unsigned int order)
 {
 	return NULL;
@@ -98,7 +98,7 @@ struct page *dma_alloc_from_contiguous(s
 
 static inline
 bool dma_release_from_contiguous(struct device *dev, struct page *pages,
-				 int count)
+				 unsigned int count)
 {
 	return false;
 }
_

Patches currently in -mm which might be from mina86@mina86.com are

origin.patch
mm-cma-warn-if-freed-memory-is-still-in-use.patch
mm-fix-zone_watermark_ok_safe-accounting-of-isolated-pages.patch
cma-make-putback_lru_pages-call-conditional.patch
cma-make-putback_lru_pages-call-conditional-fix.patch
cma-use-unsigned-type-for-count-argument.patch
cma-use-unsigned-type-for-count-argument-fix.patch

