From: akpm@linux-foundation.org
Subject: [merged]
 arm64-add-atomic-pool-for-non-coherent-and-cma-allocations.patch removed
 from -mm tree
Date: Mon, 13 Oct 2014 11:19:13 -0700
Message-ID: <543c17a1.ezg3GNHfXspZiSra%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60245 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738AbaJMSTN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:19:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lauraa@codeaurora.org, arnd@arndb.de, catalin.marinas@arm.com, davidriley@chromium.org, linux@arm.linux.org.uk, olof@lixom.net, ritesh.harjani@gmail.com, thierry.reding@gmail.com, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: add atomic pool for non-coherent and CMA allocations
has been removed from the -mm tree.  Its filename was
     arm64-add-atomic-pool-for-non-coherent-and-cma-allocations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Laura Abbott <lauraa@codeaurora.org>
Subject: arm64: add atomic pool for non-coherent and CMA allocations

Neither CMA nor noncoherent allocations support atomic allocations.
Add a dedicated atomic pool to support this.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David Riley <davidriley@chromium.org>
Cc: Olof Johansson <olof@lixom.net>
Cc: Ritesh Harjain <ritesh.harjani@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig          |    1 
 arch/arm64/mm/dma-mapping.c |  164 ++++++++++++++++++++++++++++++----
 2 files changed, 146 insertions(+), 19 deletions(-)

diff -puN arch/arm64/Kconfig~arm64-add-atomic-pool-for-non-coherent-and-cma-allocations arch/arm64/Kconfig
--- a/arch/arm64/Kconfig~arm64-add-atomic-pool-for-non-coherent-and-cma-allocations
+++ a/arch/arm64/Kconfig
@@ -18,6 +18,7 @@ config ARM64
 	select COMMON_CLK
 	select CPU_PM if (SUSPEND || CPU_IDLE)
 	select DCACHE_WORD_ACCESS
+	select GENERIC_ALLOCATOR
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_CLOCKEVENTS_BROADCAST if SMP
 	select GENERIC_CPU_AUTOPROBE
diff -puN arch/arm64/mm/dma-mapping.c~arm64-add-atomic-pool-for-non-coherent-and-cma-allocations arch/arm64/mm/dma-mapping.c
--- a/arch/arm64/mm/dma-mapping.c~arm64-add-atomic-pool-for-non-coherent-and-cma-allocations
+++ a/arch/arm64/mm/dma-mapping.c
@@ -20,6 +20,7 @@
 #include <linux/gfp.h>
 #include <linux/export.h>
 #include <linux/slab.h>
+#include <linux/genalloc.h>
 #include <linux/dma-mapping.h>
 #include <linux/dma-contiguous.h>
 #include <linux/vmalloc.h>
@@ -38,6 +39,54 @@ static pgprot_t __get_dma_pgprot(struct
 	return prot;
 }
 
+static struct gen_pool *atomic_pool;
+
+#define DEFAULT_DMA_COHERENT_POOL_SIZE  SZ_256K
+static size_t atomic_pool_size = DEFAULT_DMA_COHERENT_POOL_SIZE;
+
+static int __init early_coherent_pool(char *p)
+{
+	atomic_pool_size = memparse(p, &p);
+	return 0;
+}
+early_param("coherent_pool", early_coherent_pool);
+
+static void *__alloc_from_pool(size_t size, struct page **ret_page)
+{
+	unsigned long val;
+	void *ptr = NULL;
+
+	if (!atomic_pool) {
+		WARN(1, "coherent pool not initialised!\n");
+		return NULL;
+	}
+
+	val = gen_pool_alloc(atomic_pool, size);
+	if (val) {
+		phys_addr_t phys = gen_pool_virt_to_phys(atomic_pool, val);
+
+		*ret_page = phys_to_page(phys);
+		ptr = (void *)val;
+	}
+
+	return ptr;
+}
+
+static bool __in_atomic_pool(void *start, size_t size)
+{
+	return addr_in_gen_pool(atomic_pool, (unsigned long)start, size);
+}
+
+static int __free_from_pool(void *start, size_t size)
+{
+	if (!__in_atomic_pool(start, size))
+		return 0;
+
+	gen_pool_free(atomic_pool, (unsigned long)start, size);
+
+	return 1;
+}
+
 static void *__dma_alloc_coherent(struct device *dev, size_t size,
 				  dma_addr_t *dma_handle, gfp_t flags,
 				  struct dma_attrs *attrs)
@@ -50,7 +99,7 @@ static void *__dma_alloc_coherent(struct
 	if (IS_ENABLED(CONFIG_ZONE_DMA) &&
 	    dev->coherent_dma_mask <= DMA_BIT_MASK(32))
 		flags |= GFP_DMA;
-	if (IS_ENABLED(CONFIG_DMA_CMA)) {
+	if (IS_ENABLED(CONFIG_DMA_CMA) && (flags & __GFP_WAIT)) {
 		struct page *page;
 
 		size = PAGE_ALIGN(size);
@@ -70,50 +119,54 @@ static void __dma_free_coherent(struct d
 				void *vaddr, dma_addr_t dma_handle,
 				struct dma_attrs *attrs)
 {
+	bool freed;
+	phys_addr_t paddr = dma_to_phys(dev, dma_handle);
+
 	if (dev == NULL) {
 		WARN_ONCE(1, "Use an actual device structure for DMA allocation\n");
 		return;
 	}
 
-	if (IS_ENABLED(CONFIG_DMA_CMA)) {
-		phys_addr_t paddr = dma_to_phys(dev, dma_handle);
-
-		dma_release_from_contiguous(dev,
+	freed = dma_release_from_contiguous(dev,
 					phys_to_page(paddr),
 					size >> PAGE_SHIFT);
-	} else {
+	if (!freed)
 		swiotlb_free_coherent(dev, size, vaddr, dma_handle);
-	}
 }
 
 static void *__dma_alloc_noncoherent(struct device *dev, size_t size,
 				     dma_addr_t *dma_handle, gfp_t flags,
 				     struct dma_attrs *attrs)
 {
-	struct page *page, **map;
+	struct page *page;
 	void *ptr, *coherent_ptr;
-	int order, i;
 
 	size = PAGE_ALIGN(size);
-	order = get_order(size);
+
+	if (!(flags & __GFP_WAIT)) {
+		struct page *page = NULL;
+		void *addr = __alloc_from_pool(size, &page);
+
+		if (addr)
+			*dma_handle = phys_to_dma(dev, page_to_phys(page));
+
+		return addr;
+
+	}
 
 	ptr = __dma_alloc_coherent(dev, size, dma_handle, flags, attrs);
 	if (!ptr)
 		goto no_mem;
-	map = kmalloc(sizeof(struct page *) << order, flags & ~GFP_DMA);
-	if (!map)
-		goto no_map;
 
 	/* remove any dirty cache lines on the kernel alias */
 	__dma_flush_range(ptr, ptr + size);
 
 	/* create a coherent mapping */
 	page = virt_to_page(ptr);
-	for (i = 0; i < (size >> PAGE_SHIFT); i++)
-		map[i] = page + i;
-	coherent_ptr = vmap(map, size >> PAGE_SHIFT, VM_MAP,
-			    __get_dma_pgprot(attrs, __pgprot(PROT_NORMAL_NC), false));
-	kfree(map);
+	coherent_ptr = dma_common_contiguous_remap(page, size, VM_USERMAP,
+				__get_dma_pgprot(attrs,
+					__pgprot(PROT_NORMAL_NC), false),
+					NULL);
 	if (!coherent_ptr)
 		goto no_map;
 
@@ -132,6 +185,8 @@ static void __dma_free_noncoherent(struc
 {
 	void *swiotlb_addr = phys_to_virt(dma_to_phys(dev, dma_handle));
 
+	if (__free_from_pool(vaddr, size))
+		return;
 	vunmap(vaddr);
 	__dma_free_coherent(dev, size, swiotlb_addr, dma_handle, attrs);
 }
@@ -307,6 +362,67 @@ EXPORT_SYMBOL(coherent_swiotlb_dma_ops);
 
 extern int swiotlb_late_init_with_default_size(size_t default_size);
 
+static int __init atomic_pool_init(void)
+{
+	pgprot_t prot = __pgprot(PROT_NORMAL_NC);
+	unsigned long nr_pages = atomic_pool_size >> PAGE_SHIFT;
+	struct page *page;
+	void *addr;
+	unsigned int pool_size_order = get_order(atomic_pool_size);
+
+	if (dev_get_cma_area(NULL))
+		page = dma_alloc_from_contiguous(NULL, nr_pages,
+							pool_size_order);
+	else
+		page = alloc_pages(GFP_DMA, pool_size_order);
+
+	if (page) {
+		int ret;
+		void *page_addr = page_address(page);
+
+		memset(page_addr, 0, atomic_pool_size);
+		__dma_flush_range(page_addr, page_addr + atomic_pool_size);
+
+		atomic_pool = gen_pool_create(PAGE_SHIFT, -1);
+		if (!atomic_pool)
+			goto free_page;
+
+		addr = dma_common_contiguous_remap(page, atomic_pool_size,
+					VM_USERMAP, prot, atomic_pool_init);
+
+		if (!addr)
+			goto destroy_genpool;
+
+		ret = gen_pool_add_virt(atomic_pool, (unsigned long)addr,
+					page_to_phys(page),
+					atomic_pool_size, -1);
+		if (ret)
+			goto remove_mapping;
+
+		gen_pool_set_algo(atomic_pool,
+				  gen_pool_first_fit_order_align,
+				  (void *)PAGE_SHIFT);
+
+		pr_info("DMA: preallocated %zu KiB pool for atomic allocations\n",
+			atomic_pool_size / 1024);
+		return 0;
+	}
+	goto out;
+
+remove_mapping:
+	dma_common_free_remap(addr, atomic_pool_size, VM_USERMAP);
+destroy_genpool:
+	gen_pool_destroy(atomic_pool);
+	atomic_pool = NULL;
+free_page:
+	if (!dma_release_from_contiguous(NULL, page, nr_pages))
+		__free_pages(page, pool_size_order);
+out:
+	pr_err("DMA: failed to allocate %zu KiB pool for atomic coherent allocation\n",
+		atomic_pool_size / 1024);
+	return -ENOMEM;
+}
+
 static int __init swiotlb_late_init(void)
 {
 	size_t swiotlb_size = min(SZ_64M, MAX_ORDER_NR_PAGES << PAGE_SHIFT);
@@ -315,7 +431,17 @@ static int __init swiotlb_late_init(void
 
 	return swiotlb_late_init_with_default_size(swiotlb_size);
 }
-arch_initcall(swiotlb_late_init);
+
+static int __init arm64_dma_init(void)
+{
+	int ret = 0;
+
+	ret |= swiotlb_late_init();
+	ret |= atomic_pool_init();
+
+	return ret;
+}
+arch_initcall(arm64_dma_init);
 
 #define PREALLOC_DMA_DEBUG_ENTRIES	4096
 
_

Patches currently in -mm which might be from lauraa@codeaurora.org are

origin.patch
drivers-dma-coherent-add-initialization-from-device-tree.patch
drivers-dma-coherent-add-initialization-from-device-tree-fix.patch
drivers-dma-coherent-add-initialization-from-device-tree-fix-fix.patch
drivers-dma-coherent-add-initialization-from-device-tree-checkpatch-fixes.patch
drivers-dma-contiguous-add-initialization-from-device-tree.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

