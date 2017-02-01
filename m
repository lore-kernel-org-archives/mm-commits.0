From: akpm@linux-foundation.org
Subject: + mm-wire-up-gfp-flag-passing-in-dma_alloc_from_contiguous.patch
 added to -mm tree
Date: Tue, 31 Jan 2017 16:58:56 -0800
Message-ID: <589132d0.2Src/tXjTV8d0+ku%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42670 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750830AbdBAA7Q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2017 19:59:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: l.stach@pengutronix.de, agraf@suse.com, catalin.marinas@arm.com, chris@zankel.net, iamjoonsoo.kim@lge.com, mhocko@suse.com, pbonzini@redhat.com, ralf@linux-mips.org, rkrcmar@redhat.com, vbabka@suse.cz, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: wire up GFP flag passing in dma_alloc_from_contiguous
has been added to the -mm tree.  Its filename is
     mm-wire-up-gfp-flag-passing-in-dma_alloc_from_contiguous.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-wire-up-gfp-flag-passing-in-dma_alloc_from_contiguous.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-wire-up-gfp-flag-passing-in-dma_alloc_from_contiguous.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lucas Stach <l.stach@pengutronix.de>
Subject: mm: wire up GFP flag passing in dma_alloc_from_contiguous

The callers of the DMA alloc functions already provide the proper context
GFP flags.  Make sure to pass them through to the CMA allocator, to make
the CMA compaction context aware.

Link: http://lkml.kernel.org/r/20170127172328.18574-3-l.stach@pengutronix.de
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Radim Krcmar <rkrcmar@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Alexander Graf <agraf@suse.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/dma-mapping.c      |   16 +++++++++-------
 arch/arm64/mm/dma-mapping.c    |    4 ++--
 arch/mips/mm/dma-default.c     |    4 ++--
 arch/x86/kernel/pci-dma.c      |    3 ++-
 arch/xtensa/kernel/pci-dma.c   |    3 ++-
 drivers/base/dma-contiguous.c  |    5 +++--
 drivers/iommu/amd_iommu.c      |    2 +-
 drivers/iommu/intel-iommu.c    |    2 +-
 include/linux/dma-contiguous.h |    4 ++--
 9 files changed, 24 insertions(+), 19 deletions(-)

diff -puN arch/arm/mm/dma-mapping.c~mm-wire-up-gfp-flag-passing-in-dma_alloc_from_contiguous arch/arm/mm/dma-mapping.c
--- a/arch/arm/mm/dma-mapping.c~mm-wire-up-gfp-flag-passing-in-dma_alloc_from_contiguous
+++ a/arch/arm/mm/dma-mapping.c
@@ -349,7 +349,7 @@ static void __dma_free_buffer(struct pag
 static void *__alloc_from_contiguous(struct device *dev, size_t size,
 				     pgprot_t prot, struct page **ret_page,
 				     const void *caller, bool want_vaddr,
-				     int coherent_flag);
+				     int coherent_flag, gfp_t gfp);
 
 static void *__alloc_remap_buffer(struct device *dev, size_t size, gfp_t gfp,
 				 pgprot_t prot, struct page **ret_page,
@@ -420,7 +420,8 @@ static int __init atomic_pool_init(void)
 	 */
 	if (dev_get_cma_area(NULL))
 		ptr = __alloc_from_contiguous(NULL, atomic_pool_size, prot,
-				      &page, atomic_pool_init, true, NORMAL);
+				      &page, atomic_pool_init, true, NORMAL,
+				      GFP_KERNEL);
 	else
 		ptr = __alloc_remap_buffer(NULL, atomic_pool_size, gfp, prot,
 					   &page, atomic_pool_init, true);
@@ -594,14 +595,14 @@ static int __free_from_pool(void *start,
 static void *__alloc_from_contiguous(struct device *dev, size_t size,
 				     pgprot_t prot, struct page **ret_page,
 				     const void *caller, bool want_vaddr,
-				     int coherent_flag)
+				     int coherent_flag, gfp_t gfp)
 {
 	unsigned long order = get_order(size);
 	size_t count = size >> PAGE_SHIFT;
 	struct page *page;
 	void *ptr = NULL;
 
-	page = dma_alloc_from_contiguous(dev, count, order);
+	page = dma_alloc_from_contiguous(dev, count, order, gfp);
 	if (!page)
 		return NULL;
 
@@ -655,7 +656,7 @@ static inline pgprot_t __get_dma_pgprot(
 #define __get_dma_pgprot(attrs, prot)				__pgprot(0)
 #define __alloc_remap_buffer(dev, size, gfp, prot, ret, c, wv)	NULL
 #define __alloc_from_pool(size, ret_page)			NULL
-#define __alloc_from_contiguous(dev, size, prot, ret, c, wv, coherent_flag)	NULL
+#define __alloc_from_contiguous(dev, size, prot, ret, c, wv, coherent_flag, gfp)	NULL
 #define __free_from_pool(cpu_addr, size)			do { } while (0)
 #define __free_from_contiguous(dev, page, cpu_addr, size, wv)	do { } while (0)
 #define __dma_free_remap(cpu_addr, size)			do { } while (0)
@@ -697,7 +698,8 @@ static void *cma_allocator_alloc(struct
 {
 	return __alloc_from_contiguous(args->dev, args->size, args->prot,
 				       ret_page, args->caller,
-				       args->want_vaddr, args->coherent_flag);
+				       args->want_vaddr, args->coherent_flag,
+				       args->gfp);
 }
 
 static void cma_allocator_free(struct arm_dma_free_args *args)
@@ -1293,7 +1295,7 @@ static struct page **__iommu_alloc_buffe
 		unsigned long order = get_order(size);
 		struct page *page;
 
-		page = dma_alloc_from_contiguous(dev, count, order);
+		page = dma_alloc_from_contiguous(dev, count, order, gfp);
 		if (!page)
 			goto error;
 
diff -puN arch/arm64/mm/dma-mapping.c~mm-wire-up-gfp-flag-passing-in-dma_alloc_from_contiguous arch/arm64/mm/dma-mapping.c
--- a/arch/arm64/mm/dma-mapping.c~mm-wire-up-gfp-flag-passing-in-dma_alloc_from_contiguous
+++ a/arch/arm64/mm/dma-mapping.c
@@ -107,7 +107,7 @@ static void *__dma_alloc_coherent(struct
 		void *addr;
 
 		page = dma_alloc_from_contiguous(dev, size >> PAGE_SHIFT,
-							get_order(size));
+						 get_order(size), flags);
 		if (!page)
 			return NULL;
 
@@ -379,7 +379,7 @@ static int __init atomic_pool_init(void)
 
 	if (dev_get_cma_area(NULL))
 		page = dma_alloc_from_contiguous(NULL, nr_pages,
-							pool_size_order);
+						 pool_size_order, GFP_KERNEL);
 	else
 		page = alloc_pages(GFP_DMA, pool_size_order);
 
diff -puN arch/mips/mm/dma-default.c~mm-wire-up-gfp-flag-passing-in-dma_alloc_from_contiguous arch/mips/mm/dma-default.c
--- a/arch/mips/mm/dma-default.c~mm-wire-up-gfp-flag-passing-in-dma_alloc_from_contiguous
+++ a/arch/mips/mm/dma-default.c
@@ -148,8 +148,8 @@ static void *mips_dma_alloc_coherent(str
 	gfp = massage_gfp_flags(dev, gfp);
 
 	if (IS_ENABLED(CONFIG_DMA_CMA) && gfpflags_allow_blocking(gfp))
-		page = dma_alloc_from_contiguous(dev,
-					count, get_order(size));
+		page = dma_alloc_from_contiguous(dev, count, get_order(size),
+						 gfp);
 	if (!page)
 		page = alloc_pages(gfp, get_order(size));
 
diff -puN arch/x86/kernel/pci-dma.c~mm-wire-up-gfp-flag-passing-in-dma_alloc_from_contiguous arch/x86/kernel/pci-dma.c
--- a/arch/x86/kernel/pci-dma.c~mm-wire-up-gfp-flag-passing-in-dma_alloc_from_contiguous
+++ a/arch/x86/kernel/pci-dma.c
@@ -91,7 +91,8 @@ again:
 	page = NULL;
 	/* CMA can be used only in the context which permits sleeping */
 	if (gfpflags_allow_blocking(flag)) {
-		page = dma_alloc_from_contiguous(dev, count, get_order(size));
+		page = dma_alloc_from_contiguous(dev, count, get_order(size),
+						 flag);
 		if (page && page_to_phys(page) + size > dma_mask) {
 			dma_release_from_contiguous(dev, page, count);
 			page = NULL;
diff -puN arch/xtensa/kernel/pci-dma.c~mm-wire-up-gfp-flag-passing-in-dma_alloc_from_contiguous arch/xtensa/kernel/pci-dma.c
--- a/arch/xtensa/kernel/pci-dma.c~mm-wire-up-gfp-flag-passing-in-dma_alloc_from_contiguous
+++ a/arch/xtensa/kernel/pci-dma.c
@@ -158,7 +158,8 @@ static void *xtensa_dma_alloc(struct dev
 		flag |= GFP_DMA;
 
 	if (gfpflags_allow_blocking(flag))
-		page = dma_alloc_from_contiguous(dev, count, get_order(size));
+		page = dma_alloc_from_contiguous(dev, count, get_order(size),
+						 flag);
 
 	if (!page)
 		page = alloc_pages(flag, get_order(size));
diff -puN drivers/base/dma-contiguous.c~mm-wire-up-gfp-flag-passing-in-dma_alloc_from_contiguous drivers/base/dma-contiguous.c
--- a/drivers/base/dma-contiguous.c~mm-wire-up-gfp-flag-passing-in-dma_alloc_from_contiguous
+++ a/drivers/base/dma-contiguous.c
@@ -181,6 +181,7 @@ int __init dma_contiguous_reserve_area(p
  * @dev:   Pointer to device for which the allocation is performed.
  * @count: Requested number of pages.
  * @align: Requested alignment of pages (in PAGE_SIZE order).
+ * @gfp_mask: GFP flags to use for this allocation.
  *
  * This function allocates memory buffer for specified device. It uses
  * device specific contiguous memory area if available or the default
@@ -188,12 +189,12 @@ int __init dma_contiguous_reserve_area(p
  * function.
  */
 struct page *dma_alloc_from_contiguous(struct device *dev, size_t count,
-				       unsigned int align)
+				       unsigned int align, gfp_t gfp_mask)
 {
 	if (align > CONFIG_CMA_ALIGNMENT)
 		align = CONFIG_CMA_ALIGNMENT;
 
-	return cma_alloc(dev_get_cma_area(dev), count, align, GFP_KERNEL);
+	return cma_alloc(dev_get_cma_area(dev), count, align, gfp_mask);
 }
 
 /**
diff -puN drivers/iommu/amd_iommu.c~mm-wire-up-gfp-flag-passing-in-dma_alloc_from_contiguous drivers/iommu/amd_iommu.c
--- a/drivers/iommu/amd_iommu.c~mm-wire-up-gfp-flag-passing-in-dma_alloc_from_contiguous
+++ a/drivers/iommu/amd_iommu.c
@@ -2668,7 +2668,7 @@ static void *alloc_coherent(struct devic
 			return NULL;
 
 		page = dma_alloc_from_contiguous(dev, size >> PAGE_SHIFT,
-						 get_order(size));
+						 get_order(size), flag);
 		if (!page)
 			return NULL;
 	}
diff -puN drivers/iommu/intel-iommu.c~mm-wire-up-gfp-flag-passing-in-dma_alloc_from_contiguous drivers/iommu/intel-iommu.c
--- a/drivers/iommu/intel-iommu.c~mm-wire-up-gfp-flag-passing-in-dma_alloc_from_contiguous
+++ a/drivers/iommu/intel-iommu.c
@@ -3827,7 +3827,7 @@ static void *intel_alloc_coherent(struct
 	if (gfpflags_allow_blocking(flags)) {
 		unsigned int count = size >> PAGE_SHIFT;
 
-		page = dma_alloc_from_contiguous(dev, count, order);
+		page = dma_alloc_from_contiguous(dev, count, order, flags);
 		if (page && iommu_no_mapping(dev) &&
 		    page_to_phys(page) + size > dev->coherent_dma_mask) {
 			dma_release_from_contiguous(dev, page, count);
diff -puN include/linux/dma-contiguous.h~mm-wire-up-gfp-flag-passing-in-dma_alloc_from_contiguous include/linux/dma-contiguous.h
--- a/include/linux/dma-contiguous.h~mm-wire-up-gfp-flag-passing-in-dma_alloc_from_contiguous
+++ a/include/linux/dma-contiguous.h
@@ -112,7 +112,7 @@ static inline int dma_declare_contiguous
 }
 
 struct page *dma_alloc_from_contiguous(struct device *dev, size_t count,
-				       unsigned int order);
+				       unsigned int order, gfp_t gfp_mask);
 bool dma_release_from_contiguous(struct device *dev, struct page *pages,
 				 int count);
 
@@ -145,7 +145,7 @@ int dma_declare_contiguous(struct device
 
 static inline
 struct page *dma_alloc_from_contiguous(struct device *dev, size_t count,
-				       unsigned int order)
+				       unsigned int order, gfp_t gfp_mask)
 {
 	return NULL;
 }
_

Patches currently in -mm which might be from l.stach@pengutronix.de are

mm-alloc_contig_range-allow-to-specify-gfp-mask.patch
mm-cma_alloc-allow-to-specify-gfp-mask.patch
mm-wire-up-gfp-flag-passing-in-dma_alloc_from_contiguous.patch

