From: akpm@linux-foundation.org
Subject: + dma-cma-separate-core-cma-management-codes-from-dma-apis.patch
 added to -mm tree
Date: Wed, 18 Jun 2014 13:53:10 -0700
Message-ID: <53a1fc36.1nTF7dBbfE/VUGl6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41700 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268AbaFRUxL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jun 2014 16:53:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, pbonzini@redhat.com, paulus@samba.org, minchan@kernel.org, mina86@mina86.com, m.szyprowski@samsung.com, gleb@kernel.org, benh@kernel.crashing.org, aneesh.kumar@linux.vnet.ibm.com, agraf@suse.de, iamjoonsoo.kim@lge.com


The patch titled
     Subject: DMA, CMA: separate core CMA management codes from DMA APIs
has been added to the -mm tree.  Its filename is
     dma-cma-separate-core-cma-management-codes-from-dma-apis.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dma-cma-separate-core-cma-management-codes-from-dma-apis.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dma-cma-separate-core-cma-management-codes-from-dma-apis.patch

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
Subject: DMA, CMA: separate core CMA management codes from DMA APIs

To prepare future generalization work on CMA area management code, we need
to separate core CMA management codes from DMA APIs.  We will extend these
core functions to cover requirements of PPC KVM's CMA area management
functionality in following patches.  This separation helps us not to touch
DMA APIs while extending core functions.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Alexander Graf <agraf@suse.de>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Gleb Natapov <gleb@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/dma-contiguous.c |  125 +++++++++++++++++++-------------
 1 file changed, 77 insertions(+), 48 deletions(-)

diff -puN drivers/base/dma-contiguous.c~dma-cma-separate-core-cma-management-codes-from-dma-apis drivers/base/dma-contiguous.c
--- a/drivers/base/dma-contiguous.c~dma-cma-separate-core-cma-management-codes-from-dma-apis
+++ a/drivers/base/dma-contiguous.c
@@ -213,26 +213,9 @@ static int __init cma_init_reserved_area
 }
 core_initcall(cma_init_reserved_areas);
 
-/**
- * dma_contiguous_reserve_area() - reserve custom contiguous area
- * @size: Size of the reserved area (in bytes),
- * @base: Base address of the reserved area optional, use 0 for any
- * @limit: End address of the reserved memory (optional, 0 for any).
- * @res_cma: Pointer to store the created cma region.
- * @fixed: hint about where to place the reserved area
- *
- * This function reserves memory from early allocator. It should be
- * called by arch specific code once the early allocator (memblock or bootmem)
- * has been activated and all other subsystems have already allocated/reserved
- * memory. This function allows to create custom reserved areas for specific
- * devices.
- *
- * If @fixed is true, reserve contiguous area at exactly @base.  If false,
- * reserve in range from @base to @limit.
- */
-int __init dma_contiguous_reserve_area(phys_addr_t size, phys_addr_t base,
-				       phys_addr_t limit, struct cma **res_cma,
-				       bool fixed)
+static int __init __dma_contiguous_reserve_area(phys_addr_t size,
+				phys_addr_t base, phys_addr_t limit,
+				struct cma **res_cma, bool fixed)
 {
 	struct cma *cma = &cma_areas[cma_area_count];
 	phys_addr_t alignment;
@@ -286,15 +269,47 @@ int __init dma_contiguous_reserve_area(p
 
 	pr_info("CMA: reserved %ld MiB at %08lx\n", (unsigned long)size / SZ_1M,
 		(unsigned long)base);
-
-	/* Architecture specific contiguous memory fixup. */
-	dma_contiguous_early_fixup(base, size);
 	return 0;
+
 err:
 	pr_err("CMA: failed to reserve %ld MiB\n", (unsigned long)size / SZ_1M);
 	return ret;
 }
 
+/**
+ * dma_contiguous_reserve_area() - reserve custom contiguous area
+ * @size: Size of the reserved area (in bytes),
+ * @base: Base address of the reserved area optional, use 0 for any
+ * @limit: End address of the reserved memory (optional, 0 for any).
+ * @res_cma: Pointer to store the created cma region.
+ * @fixed: hint about where to place the reserved area
+ *
+ * This function reserves memory from early allocator. It should be
+ * called by arch specific code once the early allocator (memblock or bootmem)
+ * has been activated and all other subsystems have already allocated/reserved
+ * memory. This function allows to create custom reserved areas for specific
+ * devices.
+ *
+ * If @fixed is true, reserve contiguous area at exactly @base.  If false,
+ * reserve in range from @base to @limit.
+ */
+int __init dma_contiguous_reserve_area(phys_addr_t size, phys_addr_t base,
+				       phys_addr_t limit, struct cma **res_cma,
+				       bool fixed)
+{
+	int ret;
+
+	ret = __dma_contiguous_reserve_area(size, base, limit, res_cma, fixed);
+	if (ret)
+		return ret;
+
+	/* Architecture specific contiguous memory fixup. */
+	dma_contiguous_early_fixup(PFN_PHYS((*res_cma)->base_pfn),
+				(*res_cma)->count << PAGE_SHIFT);
+
+	return 0;
+}
+
 static void clear_cma_bitmap(struct cma *cma, unsigned long pfn, int count)
 {
 	mutex_lock(&cma->lock);
@@ -302,31 +317,16 @@ static void clear_cma_bitmap(struct cma
 	mutex_unlock(&cma->lock);
 }
 
-/**
- * dma_alloc_from_contiguous() - allocate pages from contiguous area
- * @dev:   Pointer to device for which the allocation is performed.
- * @count: Requested number of pages.
- * @align: Requested alignment of pages (in PAGE_SIZE order).
- *
- * This function allocates memory buffer for specified device. It uses
- * device specific contiguous memory area if available or the default
- * global one. Requires architecture specific dev_get_cma_area() helper
- * function.
- */
-struct page *dma_alloc_from_contiguous(struct device *dev, int count,
+static struct page *__dma_alloc_from_contiguous(struct cma *cma, int count,
 				       unsigned int align)
 {
 	unsigned long mask, pfn, pageno, start = 0;
-	struct cma *cma = dev_get_cma_area(dev);
 	struct page *page = NULL;
 	int ret;
 
 	if (!cma || !cma->count)
 		return NULL;
 
-	if (align > CONFIG_CMA_ALIGNMENT)
-		align = CONFIG_CMA_ALIGNMENT;
-
 	pr_debug("%s(cma %p, count %d, align %d)\n", __func__, (void *)cma,
 		 count, align);
 
@@ -375,19 +375,30 @@ struct page *dma_alloc_from_contiguous(s
 }
 
 /**
- * dma_release_from_contiguous() - release allocated pages
- * @dev:   Pointer to device for which the pages were allocated.
- * @pages: Allocated pages.
- * @count: Number of allocated pages.
+ * dma_alloc_from_contiguous() - allocate pages from contiguous area
+ * @dev:   Pointer to device for which the allocation is performed.
+ * @count: Requested number of pages.
+ * @align: Requested alignment of pages (in PAGE_SIZE order).
  *
- * This function releases memory allocated by dma_alloc_from_contiguous().
- * It returns false when provided pages do not belong to contiguous area and
- * true otherwise.
+ * This function allocates memory buffer for specified device. It uses
+ * device specific contiguous memory area if available or the default
+ * global one. Requires architecture specific dev_get_cma_area() helper
+ * function.
  */
-bool dma_release_from_contiguous(struct device *dev, struct page *pages,
-				 int count)
+struct page *dma_alloc_from_contiguous(struct device *dev, int count,
+				       unsigned int align)
 {
 	struct cma *cma = dev_get_cma_area(dev);
+
+	if (align > CONFIG_CMA_ALIGNMENT)
+		align = CONFIG_CMA_ALIGNMENT;
+
+	return __dma_alloc_from_contiguous(cma, count, align);
+}
+
+static bool __dma_release_from_contiguous(struct cma *cma, struct page *pages,
+				 int count)
+{
 	unsigned long pfn;
 
 	if (!cma || !pages)
@@ -407,3 +418,21 @@ bool dma_release_from_contiguous(struct
 
 	return true;
 }
+
+/**
+ * dma_release_from_contiguous() - release allocated pages
+ * @dev:   Pointer to device for which the pages were allocated.
+ * @pages: Allocated pages.
+ * @count: Number of allocated pages.
+ *
+ * This function releases memory allocated by dma_alloc_from_contiguous().
+ * It returns false when provided pages do not belong to contiguous area and
+ * true otherwise.
+ */
+bool dma_release_from_contiguous(struct device *dev, struct page *pages,
+				 int count)
+{
+	struct cma *cma = dev_get_cma_area(dev);
+
+	return __dma_release_from_contiguous(cma, pages, count);
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

