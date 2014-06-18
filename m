From: akpm@linux-foundation.org
Subject: + cma-generalize-cma-reserved-area-management-functionality.patch added to -mm tree
Date: Wed, 18 Jun 2014 13:53:14 -0700
Message-ID: <53a1fc3a.rZVks+USg5QQORSD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41743 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755625AbaFRUxP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jun 2014 16:53:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, pbonzini@redhat.com, paulus@samba.org, minchan@kernel.org, mina86@mina86.com, m.szyprowski@samsung.com, gleb@kernel.org, benh@kernel.crashing.org, aneesh.kumar@linux.vnet.ibm.com, agraf@suse.de, iamjoonsoo.kim@lge.com


The patch titled
     Subject: CMA: generalize CMA reserved area management functionality
has been added to the -mm tree.  Its filename is
     cma-generalize-cma-reserved-area-management-functionality.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cma-generalize-cma-reserved-area-management-functionality.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cma-generalize-cma-reserved-area-management-functionality.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: CMA: generalize CMA reserved area management functionality

Currently, there are two users on CMA functionality, one is the DMA
subsystem and the other is the KVM on powerpc.  They have their own code
to manage CMA reserved area even if they looks really similar.  From my
guess, it is caused by some needs on bitmap management.  KVM side wants to
maintain bitmap not for 1 page, but for more size.  Eventually it use
bitmap where one bit represents 64 pages.

When I implement CMA related patches, I should change those two places to
apply my change and it seem to be painful to me.  I want to change this
situation and reduce future code management overhead through this patch.

This change could also help developer who want to use CMA in their new
feature development, since they can use CMA easily without copying &
pasting this reserved area management code.

In previous patches, we have prepared some features to generalize CMA
reserved area management and now it's time to do it.  This patch moves
core functions to mm/cma.c and change DMA APIs to use these functions.

There is no functional change in DMA APIs.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Acked-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Alexander Graf <agraf@suse.de>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Gleb Natapov <gleb@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/dma-mapping.c      |    1 
 drivers/base/Kconfig           |   10 
 drivers/base/dma-contiguous.c  |  280 --------------------------
 include/linux/cma.h            |   21 +
 include/linux/dma-contiguous.h |   11 -
 mm/Kconfig                     |   11 +
 mm/Makefile                    |    1 
 mm/cma.c                       |  333 +++++++++++++++++++++++++++++++
 8 files changed, 377 insertions(+), 291 deletions(-)

diff -puN arch/arm/mm/dma-mapping.c~cma-generalize-cma-reserved-area-management-functionality arch/arm/mm/dma-mapping.c
--- a/arch/arm/mm/dma-mapping.c~cma-generalize-cma-reserved-area-management-functionality
+++ a/arch/arm/mm/dma-mapping.c
@@ -26,6 +26,7 @@
 #include <linux/io.h>
 #include <linux/vmalloc.h>
 #include <linux/sizes.h>
+#include <linux/cma.h>
 
 #include <asm/memory.h>
 #include <asm/highmem.h>
diff -puN drivers/base/Kconfig~cma-generalize-cma-reserved-area-management-functionality drivers/base/Kconfig
--- a/drivers/base/Kconfig~cma-generalize-cma-reserved-area-management-functionality
+++ a/drivers/base/Kconfig
@@ -274,16 +274,6 @@ config CMA_ALIGNMENT
 
 	  If unsure, leave the default value "8".
 
-config CMA_AREAS
-	int "Maximum count of the CMA device-private areas"
-	default 7
-	help
-	  CMA allows to create CMA areas for particular devices. This parameter
-	  sets the maximum number of such device private CMA areas in the
-	  system.
-
-	  If unsure, leave the default value "7".
-
 endif
 
 endmenu
diff -puN drivers/base/dma-contiguous.c~cma-generalize-cma-reserved-area-management-functionality drivers/base/dma-contiguous.c
--- a/drivers/base/dma-contiguous.c~cma-generalize-cma-reserved-area-management-functionality
+++ a/drivers/base/dma-contiguous.c
@@ -24,25 +24,9 @@
 
 #include <linux/memblock.h>
 #include <linux/err.h>
-#include <linux/mm.h>
-#include <linux/mutex.h>
-#include <linux/page-isolation.h>
 #include <linux/sizes.h>
-#include <linux/slab.h>
-#include <linux/swap.h>
-#include <linux/mm_types.h>
 #include <linux/dma-contiguous.h>
-#include <linux/log2.h>
-
-struct cma {
-	unsigned long	base_pfn;
-	unsigned long	count;
-	unsigned long	*bitmap;
-	unsigned int order_per_bit; /* Order of pages represented by one bit */
-	struct mutex	lock;
-};
-
-struct cma *dma_contiguous_default_area;
+#include <linux/cma.h>
 
 #ifdef CONFIG_CMA_SIZE_MBYTES
 #define CMA_SIZE_MBYTES CONFIG_CMA_SIZE_MBYTES
@@ -50,6 +34,8 @@ struct cma *dma_contiguous_default_area;
 #define CMA_SIZE_MBYTES 0
 #endif
 
+struct cma *dma_contiguous_default_area;
+
 /*
  * Default global CMA area size can be defined in kernel's .config.
  * This is useful mainly for distro maintainers to create a kernel
@@ -156,169 +142,6 @@ void __init dma_contiguous_reserve(phys_
 	}
 }
 
-static DEFINE_MUTEX(cma_mutex);
-
-static unsigned long cma_bitmap_aligned_mask(struct cma *cma, int align_order)
-{
-	return (1UL << (align_order >> cma->order_per_bit)) - 1;
-}
-
-static unsigned long cma_bitmap_maxno(struct cma *cma)
-{
-	return cma->count >> cma->order_per_bit;
-}
-
-static unsigned long cma_bitmap_pages_to_bits(struct cma *cma,
-						unsigned long pages)
-{
-	return ALIGN(pages, 1UL << cma->order_per_bit) >> cma->order_per_bit;
-}
-
-static void cma_clear_bitmap(struct cma *cma, unsigned long pfn, int count)
-{
-	unsigned long bitmap_no, bitmap_count;
-
-	bitmap_no = (pfn - cma->base_pfn) >> cma->order_per_bit;
-	bitmap_count = cma_bitmap_pages_to_bits(cma, count);
-
-	mutex_lock(&cma->lock);
-	bitmap_clear(cma->bitmap, bitmap_no, bitmap_count);
-	mutex_unlock(&cma->lock);
-}
-
-static int __init cma_activate_area(struct cma *cma)
-{
-	int bitmap_size = BITS_TO_LONGS(cma_bitmap_maxno(cma)) * sizeof(long);
-	unsigned long base_pfn = cma->base_pfn, pfn = base_pfn;
-	unsigned i = cma->count >> pageblock_order;
-	struct zone *zone;
-
-	cma->bitmap = kzalloc(bitmap_size, GFP_KERNEL);
-
-	if (!cma->bitmap)
-		return -ENOMEM;
-
-	WARN_ON_ONCE(!pfn_valid(pfn));
-	zone = page_zone(pfn_to_page(pfn));
-
-	do {
-		unsigned j;
-		base_pfn = pfn;
-		for (j = pageblock_nr_pages; j; --j, pfn++) {
-			WARN_ON_ONCE(!pfn_valid(pfn));
-			/*
-			 * alloc_contig_range requires the pfn range
-			 * specified to be in the same zone. Make this
-			 * simple by forcing the entire CMA resv range
-			 * to be in the same zone.
-			 */
-			if (page_zone(pfn_to_page(pfn)) != zone)
-				goto err;
-		}
-		init_cma_reserved_pageblock(pfn_to_page(base_pfn));
-	} while (--i);
-
-	mutex_init(&cma->lock);
-	return 0;
-
-err:
-	kfree(cma->bitmap);
-	return -EINVAL;
-}
-
-static struct cma cma_areas[MAX_CMA_AREAS];
-static unsigned cma_area_count;
-
-static int __init cma_init_reserved_areas(void)
-{
-	int i;
-
-	for (i = 0; i < cma_area_count; i++) {
-		int ret = cma_activate_area(&cma_areas[i]);
-		if (ret)
-			return ret;
-	}
-
-	return 0;
-}
-core_initcall(cma_init_reserved_areas);
-
-static int __init __dma_contiguous_reserve_area(phys_addr_t size,
-			phys_addr_t base, phys_addr_t limit,
-			phys_addr_t alignment, unsigned int order_per_bit,
-			struct cma **res_cma, bool fixed)
-{
-	struct cma *cma = &cma_areas[cma_area_count];
-	int ret = 0;
-
-	pr_debug("%s(size %lx, base %08lx, limit %08lx alignment %08lx)\n",
-		__func__, (unsigned long)size, (unsigned long)base,
-		(unsigned long)limit, (unsigned long)alignment);
-
-	if (cma_area_count == ARRAY_SIZE(cma_areas)) {
-		pr_err("Not enough slots for CMA reserved regions!\n");
-		return -ENOSPC;
-	}
-
-	if (!size)
-		return -EINVAL;
-
-	if (alignment && !is_power_of_2(alignment))
-		return -EINVAL;
-
-	/*
-	 * Sanitise input arguments.
-	 * Pages both ends in CMA area could be merged into adjacent unmovable
-	 * migratetype page by page allocator's buddy algorithm. In the case,
-	 * you couldn't get a contiguous memory, which is not what we want.
-	 */
-	alignment = max(alignment,
-		(phys_addr_t)PAGE_SIZE << max(MAX_ORDER - 1, pageblock_order));
-	base = ALIGN(base, alignment);
-	size = ALIGN(size, alignment);
-	limit &= ~(alignment - 1);
-
-	/* size should be aligned with order_per_bit */
-	if (!IS_ALIGNED(size >> PAGE_SHIFT, 1 << order_per_bit))
-		return -EINVAL;
-
-	/* Reserve memory */
-	if (base && fixed) {
-		if (memblock_is_region_reserved(base, size) ||
-		    memblock_reserve(base, size) < 0) {
-			ret = -EBUSY;
-			goto err;
-		}
-	} else {
-		phys_addr_t addr = memblock_alloc_range(size, alignment, base,
-							limit);
-		if (!addr) {
-			ret = -ENOMEM;
-			goto err;
-		} else {
-			base = addr;
-		}
-	}
-
-	/*
-	 * Each reserved area must be initialised later, when more kernel
-	 * subsystems (like slab allocator) are available.
-	 */
-	cma->base_pfn = PFN_DOWN(base);
-	cma->count = size >> PAGE_SHIFT;
-	cma->order_per_bit = order_per_bit;
-	*res_cma = cma;
-	cma_area_count++;
-
-	pr_info("CMA: reserved %ld MiB at %08lx\n", (unsigned long)size / SZ_1M,
-		(unsigned long)base);
-	return 0;
-
-err:
-	pr_err("CMA: failed to reserve %ld MiB\n", (unsigned long)size / SZ_1M);
-	return ret;
-}
-
 /**
  * dma_contiguous_reserve_area() - reserve custom contiguous area
  * @size: Size of the reserved area (in bytes),
@@ -342,77 +165,17 @@ int __init dma_contiguous_reserve_area(p
 {
 	int ret;
 
-	ret = __dma_contiguous_reserve_area(size, base, limit, 0, 0,
-						res_cma, fixed);
+	ret = cma_declare_contiguous(size, base, limit, 0, 0, res_cma, fixed);
 	if (ret)
 		return ret;
 
 	/* Architecture specific contiguous memory fixup. */
-	dma_contiguous_early_fixup(PFN_PHYS((*res_cma)->base_pfn),
-				(*res_cma)->count << PAGE_SHIFT);
+	dma_contiguous_early_fixup(cma_get_base(*res_cma),
+				cma_get_size(*res_cma));
 
 	return 0;
 }
 
-static struct page *__dma_alloc_from_contiguous(struct cma *cma, int count,
-				       unsigned int align)
-{
-	unsigned long mask, pfn, start = 0;
-	unsigned long bitmap_maxno, bitmap_no, bitmap_count;
-	struct page *page = NULL;
-	int ret;
-
-	if (!cma || !cma->count)
-		return NULL;
-
-	pr_debug("%s(cma %p, count %d, align %d)\n", __func__, (void *)cma,
-		 count, align);
-
-	if (!count)
-		return NULL;
-
-	mask = cma_bitmap_aligned_mask(cma, align);
-	bitmap_maxno = cma_bitmap_maxno(cma);
-	bitmap_count = cma_bitmap_pages_to_bits(cma, count);
-
-	for (;;) {
-		mutex_lock(&cma->lock);
-		bitmap_no = bitmap_find_next_zero_area(cma->bitmap,
-				bitmap_maxno, start, bitmap_count, mask);
-		if (bitmap_no >= bitmap_maxno) {
-			mutex_unlock(&cma->lock);
-			break;
-		}
-		bitmap_set(cma->bitmap, bitmap_no, bitmap_count);
-		/*
-		 * It's safe to drop the lock here. We've marked this region for
-		 * our exclusive use. If the migration fails we will take the
-		 * lock again and unmark it.
-		 */
-		mutex_unlock(&cma->lock);
-
-		pfn = cma->base_pfn + (bitmap_no << cma->order_per_bit);
-		mutex_lock(&cma_mutex);
-		ret = alloc_contig_range(pfn, pfn + count, MIGRATE_CMA);
-		mutex_unlock(&cma_mutex);
-		if (ret == 0) {
-			page = pfn_to_page(pfn);
-			break;
-		} else if (ret != -EBUSY) {
-			cma_clear_bitmap(cma, pfn, count);
-			break;
-		}
-		cma_clear_bitmap(cma, pfn, count);
-		pr_debug("%s(): memory range at %p is busy, retrying\n",
-			 __func__, pfn_to_page(pfn));
-		/* try again with a bit different memory target */
-		start = bitmap_no + mask + 1;
-	}
-
-	pr_debug("%s(): returned %p\n", __func__, page);
-	return page;
-}
-
 /**
  * dma_alloc_from_contiguous() - allocate pages from contiguous area
  * @dev:   Pointer to device for which the allocation is performed.
@@ -427,35 +190,10 @@ static struct page *__dma_alloc_from_con
 struct page *dma_alloc_from_contiguous(struct device *dev, int count,
 				       unsigned int align)
 {
-	struct cma *cma = dev_get_cma_area(dev);
-
 	if (align > CONFIG_CMA_ALIGNMENT)
 		align = CONFIG_CMA_ALIGNMENT;
 
-	return __dma_alloc_from_contiguous(cma, count, align);
-}
-
-static bool __dma_release_from_contiguous(struct cma *cma, struct page *pages,
-				 int count)
-{
-	unsigned long pfn;
-
-	if (!cma || !pages)
-		return false;
-
-	pr_debug("%s(page %p)\n", __func__, (void *)pages);
-
-	pfn = page_to_pfn(pages);
-
-	if (pfn < cma->base_pfn || pfn >= cma->base_pfn + cma->count)
-		return false;
-
-	VM_BUG_ON(pfn + count > cma->base_pfn + cma->count);
-
-	free_contig_range(pfn, count);
-	cma_clear_bitmap(cma, pfn, count);
-
-	return true;
+	return cma_alloc(dev_get_cma_area(dev), count, align);
 }
 
 /**
@@ -471,7 +209,5 @@ static bool __dma_release_from_contiguou
 bool dma_release_from_contiguous(struct device *dev, struct page *pages,
 				 int count)
 {
-	struct cma *cma = dev_get_cma_area(dev);
-
-	return __dma_release_from_contiguous(cma, pages, count);
+	return cma_release(dev_get_cma_area(dev), pages, count);
 }
diff -puN /dev/null include/linux/cma.h
--- /dev/null
+++ a/include/linux/cma.h
@@ -0,0 +1,21 @@
+#ifndef __CMA_H__
+#define __CMA_H__
+
+/*
+ * There is always at least global CMA area and a few optional
+ * areas configured in kernel .config.
+ */
+#define MAX_CMA_AREAS	(1 + CONFIG_CMA_AREAS)
+
+struct cma;
+
+extern phys_addr_t cma_get_base(struct cma *cma);
+extern unsigned long cma_get_size(struct cma *cma);
+
+extern int __init cma_declare_contiguous(phys_addr_t size,
+			phys_addr_t base, phys_addr_t limit,
+			phys_addr_t alignment, unsigned int order_per_bit,
+			struct cma **res_cma, bool fixed);
+extern struct page *cma_alloc(struct cma *cma, int count, unsigned int align);
+extern bool cma_release(struct cma *cma, struct page *pages, int count);
+#endif
diff -puN include/linux/dma-contiguous.h~cma-generalize-cma-reserved-area-management-functionality include/linux/dma-contiguous.h
--- a/include/linux/dma-contiguous.h~cma-generalize-cma-reserved-area-management-functionality
+++ a/include/linux/dma-contiguous.h
@@ -53,18 +53,13 @@
 
 #ifdef __KERNEL__
 
+#include <linux/device.h>
+
 struct cma;
 struct page;
-struct device;
 
 #ifdef CONFIG_DMA_CMA
 
-/*
- * There is always at least global CMA area and a few optional device
- * private areas configured in kernel .config.
- */
-#define MAX_CMA_AREAS	(1 + CONFIG_CMA_AREAS)
-
 extern struct cma *dma_contiguous_default_area;
 
 static inline struct cma *dev_get_cma_area(struct device *dev)
@@ -123,8 +118,6 @@ bool dma_release_from_contiguous(struct
 
 #else
 
-#define MAX_CMA_AREAS	(0)
-
 static inline struct cma *dev_get_cma_area(struct device *dev)
 {
 	return NULL;
diff -puN mm/Kconfig~cma-generalize-cma-reserved-area-management-functionality mm/Kconfig
--- a/mm/Kconfig~cma-generalize-cma-reserved-area-management-functionality
+++ a/mm/Kconfig
@@ -508,6 +508,17 @@ config CMA_DEBUG
 	  processing calls such as dma_alloc_from_contiguous().
 	  This option does not affect warning and error messages.
 
+config CMA_AREAS
+	int "Maximum count of the CMA areas"
+	depends on CMA
+	default 7
+	help
+	  CMA allows to create CMA areas for particular purpose, mainly,
+	  used as device private area. This parameter sets the maximum
+	  number of CMA area in the system.
+
+	  If unsure, leave the default value "7".
+
 config ZBUD
 	tristate
 	default n
diff -puN mm/Makefile~cma-generalize-cma-reserved-area-management-functionality mm/Makefile
--- a/mm/Makefile~cma-generalize-cma-reserved-area-management-functionality
+++ a/mm/Makefile
@@ -62,3 +62,4 @@ obj-$(CONFIG_MEMORY_ISOLATION) += page_i
 obj-$(CONFIG_ZBUD)	+= zbud.o
 obj-$(CONFIG_ZSMALLOC)	+= zsmalloc.o
 obj-$(CONFIG_GENERIC_EARLY_IOREMAP) += early_ioremap.o
+obj-$(CONFIG_CMA)	+= cma.o
diff -puN /dev/null mm/cma.c
--- /dev/null
+++ a/mm/cma.c
@@ -0,0 +1,333 @@
+/*
+ * Contiguous Memory Allocator
+ *
+ * Copyright (c) 2010-2011 by Samsung Electronics.
+ * Copyright IBM Corporation, 2013
+ * Copyright LG Electronics Inc., 2014
+ * Written by:
+ *	Marek Szyprowski <m.szyprowski@samsung.com>
+ *	Michal Nazarewicz <mina86@mina86.com>
+ *	Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
+ *	Joonsoo Kim <iamjoonsoo.kim@lge.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of the
+ * License or (at your optional) any later version of the license.
+ */
+
+#define pr_fmt(fmt) "cma: " fmt
+
+#ifdef CONFIG_CMA_DEBUG
+#ifndef DEBUG
+#  define DEBUG
+#endif
+#endif
+
+#include <linux/memblock.h>
+#include <linux/err.h>
+#include <linux/mm.h>
+#include <linux/mutex.h>
+#include <linux/sizes.h>
+#include <linux/slab.h>
+#include <linux/log2.h>
+#include <linux/cma.h>
+
+struct cma {
+	unsigned long	base_pfn;
+	unsigned long	count;
+	unsigned long	*bitmap;
+	unsigned int order_per_bit; /* Order of pages represented by one bit */
+	struct mutex	lock;
+};
+
+static struct cma cma_areas[MAX_CMA_AREAS];
+static unsigned cma_area_count;
+static DEFINE_MUTEX(cma_mutex);
+
+phys_addr_t cma_get_base(struct cma *cma)
+{
+	return PFN_PHYS(cma->base_pfn);
+}
+
+unsigned long cma_get_size(struct cma *cma)
+{
+	return cma->count << PAGE_SHIFT;
+}
+
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
+static int __init cma_activate_area(struct cma *cma)
+{
+	int bitmap_size = BITS_TO_LONGS(cma_bitmap_maxno(cma)) * sizeof(long);
+	unsigned long base_pfn = cma->base_pfn, pfn = base_pfn;
+	unsigned i = cma->count >> pageblock_order;
+	struct zone *zone;
+
+	cma->bitmap = kzalloc(bitmap_size, GFP_KERNEL);
+
+	if (!cma->bitmap)
+		return -ENOMEM;
+
+	WARN_ON_ONCE(!pfn_valid(pfn));
+	zone = page_zone(pfn_to_page(pfn));
+
+	do {
+		unsigned j;
+
+		base_pfn = pfn;
+		for (j = pageblock_nr_pages; j; --j, pfn++) {
+			WARN_ON_ONCE(!pfn_valid(pfn));
+			/*
+			 * alloc_contig_range requires the pfn range
+			 * specified to be in the same zone. Make this
+			 * simple by forcing the entire CMA resv range
+			 * to be in the same zone.
+			 */
+			if (page_zone(pfn_to_page(pfn)) != zone)
+				goto err;
+		}
+		init_cma_reserved_pageblock(pfn_to_page(base_pfn));
+	} while (--i);
+
+	mutex_init(&cma->lock);
+	return 0;
+
+err:
+	kfree(cma->bitmap);
+	return -EINVAL;
+}
+
+static int __init cma_init_reserved_areas(void)
+{
+	int i;
+
+	for (i = 0; i < cma_area_count; i++) {
+		int ret = cma_activate_area(&cma_areas[i]);
+
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+core_initcall(cma_init_reserved_areas);
+
+/**
+ * cma_declare_contiguous() - reserve custom contiguous area
+ * @size: Size of the reserved area (in bytes),
+ * @base: Base address of the reserved area optional, use 0 for any
+ * @limit: End address of the reserved memory (optional, 0 for any).
+ * @alignment: Alignment for the CMA area, should be power of 2 or zero
+ * @order_per_bit: Order of pages represented by one bit on bitmap.
+ * @res_cma: Pointer to store the created cma region.
+ * @fixed: hint about where to place the reserved area
+ *
+ * This function reserves memory from early allocator. It should be
+ * called by arch specific code once the early allocator (memblock or bootmem)
+ * has been activated and all other subsystems have already allocated/reserved
+ * memory. This function allows to create custom reserved areas.
+ *
+ * If @fixed is true, reserve contiguous area at exactly @base.  If false,
+ * reserve in range from @base to @limit.
+ */
+int __init cma_declare_contiguous(phys_addr_t size,
+			phys_addr_t base, phys_addr_t limit,
+			phys_addr_t alignment, unsigned int order_per_bit,
+			struct cma **res_cma, bool fixed)
+{
+	struct cma *cma = &cma_areas[cma_area_count];
+	int ret = 0;
+
+	pr_debug("%s(size %lx, base %08lx, limit %08lx alignment %08lx)\n",
+		__func__, (unsigned long)size, (unsigned long)base,
+		(unsigned long)limit, (unsigned long)alignment);
+
+	if (cma_area_count == ARRAY_SIZE(cma_areas)) {
+		pr_err("Not enough slots for CMA reserved regions!\n");
+		return -ENOSPC;
+	}
+
+	if (!size)
+		return -EINVAL;
+
+	if (alignment && !is_power_of_2(alignment))
+		return -EINVAL;
+
+	/*
+	 * Sanitise input arguments.
+	 * Pages both ends in CMA area could be merged into adjacent unmovable
+	 * migratetype page by page allocator's buddy algorithm. In the case,
+	 * you couldn't get a contiguous memory, which is not what we want.
+	 */
+	alignment = max(alignment,
+		(phys_addr_t)PAGE_SIZE << max(MAX_ORDER - 1, pageblock_order));
+	base = ALIGN(base, alignment);
+	size = ALIGN(size, alignment);
+	limit &= ~(alignment - 1);
+
+	/* size should be aligned with order_per_bit */
+	if (!IS_ALIGNED(size >> PAGE_SHIFT, 1 << order_per_bit))
+		return -EINVAL;
+
+	/* Reserve memory */
+	if (base && fixed) {
+		if (memblock_is_region_reserved(base, size) ||
+		    memblock_reserve(base, size) < 0) {
+			ret = -EBUSY;
+			goto err;
+		}
+	} else {
+		phys_addr_t addr = memblock_alloc_range(size, alignment, base,
+							limit);
+		if (!addr) {
+			ret = -ENOMEM;
+			goto err;
+		} else {
+			base = addr;
+		}
+	}
+
+	/*
+	 * Each reserved area must be initialised later, when more kernel
+	 * subsystems (like slab allocator) are available.
+	 */
+	cma->base_pfn = PFN_DOWN(base);
+	cma->count = size >> PAGE_SHIFT;
+	cma->order_per_bit = order_per_bit;
+	*res_cma = cma;
+	cma_area_count++;
+
+	pr_info("CMA: reserved %ld MiB at %08lx\n", (unsigned long)size / SZ_1M,
+		(unsigned long)base);
+	return 0;
+
+err:
+	pr_err("CMA: failed to reserve %ld MiB\n", (unsigned long)size / SZ_1M);
+	return ret;
+}
+
+/**
+ * cma_alloc() - allocate pages from contiguous area
+ * @cma:   Contiguous memory region for which the allocation is performed.
+ * @count: Requested number of pages.
+ * @align: Requested alignment of pages (in PAGE_SIZE order).
+ *
+ * This function allocates part of contiguous memory on specific
+ * contiguous memory area.
+ */
+struct page *cma_alloc(struct cma *cma, int count, unsigned int align)
+{
+	unsigned long mask, pfn, start = 0;
+	unsigned long bitmap_maxno, bitmap_no, bitmap_count;
+	struct page *page = NULL;
+	int ret;
+
+	if (!cma || !cma->count)
+		return NULL;
+
+	pr_debug("%s(cma %p, count %d, align %d)\n", __func__, (void *)cma,
+		 count, align);
+
+	if (!count)
+		return NULL;
+
+	mask = cma_bitmap_aligned_mask(cma, align);
+	bitmap_maxno = cma_bitmap_maxno(cma);
+	bitmap_count = cma_bitmap_pages_to_bits(cma, count);
+
+	for (;;) {
+		mutex_lock(&cma->lock);
+		bitmap_no = bitmap_find_next_zero_area(cma->bitmap,
+				bitmap_maxno, start, bitmap_count, mask);
+		if (bitmap_no >= bitmap_maxno) {
+			mutex_unlock(&cma->lock);
+			break;
+		}
+		bitmap_set(cma->bitmap, bitmap_no, bitmap_count);
+		/*
+		 * It's safe to drop the lock here. We've marked this region for
+		 * our exclusive use. If the migration fails we will take the
+		 * lock again and unmark it.
+		 */
+		mutex_unlock(&cma->lock);
+
+		pfn = cma->base_pfn + (bitmap_no << cma->order_per_bit);
+		mutex_lock(&cma_mutex);
+		ret = alloc_contig_range(pfn, pfn + count, MIGRATE_CMA);
+		mutex_unlock(&cma_mutex);
+		if (ret == 0) {
+			page = pfn_to_page(pfn);
+			break;
+		} else if (ret != -EBUSY) {
+			cma_clear_bitmap(cma, pfn, count);
+			break;
+		}
+		cma_clear_bitmap(cma, pfn, count);
+		pr_debug("%s(): memory range at %p is busy, retrying\n",
+			 __func__, pfn_to_page(pfn));
+		/* try again with a bit different memory target */
+		start = bitmap_no + mask + 1;
+	}
+
+	pr_debug("%s(): returned %p\n", __func__, page);
+	return page;
+}
+
+/**
+ * cma_release() - release allocated pages
+ * @cma:   Contiguous memory region for which the allocation is performed.
+ * @pages: Allocated pages.
+ * @count: Number of allocated pages.
+ *
+ * This function releases memory allocated by alloc_cma().
+ * It returns false when provided pages do not belong to contiguous area and
+ * true otherwise.
+ */
+bool cma_release(struct cma *cma, struct page *pages, int count)
+{
+	unsigned long pfn;
+
+	if (!cma || !pages)
+		return false;
+
+	pr_debug("%s(page %p)\n", __func__, (void *)pages);
+
+	pfn = page_to_pfn(pages);
+
+	if (pfn < cma->base_pfn || pfn >= cma->base_pfn + cma->count)
+		return false;
+
+	VM_BUG_ON(pfn + count > cma->base_pfn + cma->count);
+
+	free_contig_range(pfn, count);
+	cma_clear_bitmap(cma, pfn, count);
+
+	return true;
+}
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

slab-maintainer-update.patch
slab-fix-oops-when-reading-proc-slab_allocators.patch
mm-slabc-add-__init-to-init_lock_keys.patch
slab-common-add-functions-for-kmem_cache_node-access.patch
slub-use-new-node-functions.patch
slub-use-new-node-functions-fix.patch
slab-use-get_node-and-kmem_cache_node-functions.patch
slab-use-get_node-and-kmem_cache_node-functions-fix.patch
mm-slabh-wrap-the-whole-file-with-guarding-macro.patch
vmalloc-use-rcu-list-iterator-to-reduce-vmap_area_lock-contention.patch
memcg-cleanup-memcg_cache_params-refcnt-usage.patch
memcg-destroy-kmem-caches-when-last-slab-is-freed.patch
memcg-mark-caches-that-belong-to-offline-memcgs-as-dead.patch
slub-dont-fail-kmem_cache_shrink-if-slab-placement-optimization-fails.patch
slub-make-slab_free-non-preemptable.patch
memcg-wait-for-kfrees-to-finish-before-destroying-cache.patch
slub-make-dead-memcg-caches-discard-free-slabs-immediately.patch
slab-do-not-keep-free-objects-slabs-on-dead-memcg-caches.patch
dma-cma-fix-possible-memory-leak.patch
dma-cma-separate-core-cma-management-codes-from-dma-apis.patch
dma-cma-support-alignment-constraint-on-cma-region.patch
dma-cma-support-arbitrary-bitmap-granularity.patch
dma-cma-support-arbitrary-bitmap-granularity-fix.patch
cma-generalize-cma-reserved-area-management-functionality.patch
ppc-kvm-cma-use-general-cma-reserved-area-management-framework.patch
mm-cma-clean-up-cma-allocation-error-path.patch
mm-cma-change-cma_declare_contiguous-to-obey-coding-convention.patch
mm-cma-clean-up-log-message.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
page-owners-correct-page-order-when-to-free-page.patch

