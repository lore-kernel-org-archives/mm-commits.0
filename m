From: akpm@linux-foundation.org
Subject: [merged]
 mm-cma-change-cma_declare_contiguous-to-obey-coding-convention.patch
 removed from -mm tree
Date: Thu, 07 Aug 2014 13:04:09 -0700
Message-ID: <53e3dbb9.o/3o3x9AGDIMcl7U%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:45020 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333AbaHGUEK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:04:10 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so1175702pab.2
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:04:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, agraf@suse.de, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, gleb@kernel.org, m.szyprowski@samsung.com, mina86@mina86.com, minchan@kernel.org, paulus@samba.org, pbonzini@redhat.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, CMA: change cma_declare_contiguous() to obey coding convention
has been removed from the -mm tree.  Its filename was
     mm-cma-change-cma_declare_contiguous-to-obey-coding-convention.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm, CMA: change cma_declare_contiguous() to obey coding convention

Conventionally, we put output param to the end of param list and put the
'base' ahead of 'size', but cma_declare_contiguous() doesn't look like
that, so change it.

Additionally, move down cma_areas reference code to the position
where it is really needed.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Alexander Graf <agraf@suse.de>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Gleb Natapov <gleb@kernel.org>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kvm/book3s_hv_builtin.c |    4 ++--
 drivers/base/dma-contiguous.c        |    2 +-
 include/linux/cma.h                  |    2 +-
 mm/cma.c                             |   13 +++++++------
 4 files changed, 11 insertions(+), 10 deletions(-)

diff -puN arch/powerpc/kvm/book3s_hv_builtin.c~mm-cma-change-cma_declare_contiguous-to-obey-coding-convention arch/powerpc/kvm/book3s_hv_builtin.c
--- a/arch/powerpc/kvm/book3s_hv_builtin.c~mm-cma-change-cma_declare_contiguous-to-obey-coding-convention
+++ a/arch/powerpc/kvm/book3s_hv_builtin.c
@@ -185,8 +185,8 @@ void __init kvm_cma_reserve(void)
 			align_size = HPT_ALIGN_PAGES << PAGE_SHIFT;
 
 		align_size = max(kvm_rma_pages << PAGE_SHIFT, align_size);
-		cma_declare_contiguous(selected_size, 0, 0, align_size,
-			KVM_CMA_CHUNK_ORDER - PAGE_SHIFT, &kvm_cma, false);
+		cma_declare_contiguous(0, selected_size, 0, align_size,
+			KVM_CMA_CHUNK_ORDER - PAGE_SHIFT, false, &kvm_cma);
 	}
 }
 
diff -puN drivers/base/dma-contiguous.c~mm-cma-change-cma_declare_contiguous-to-obey-coding-convention drivers/base/dma-contiguous.c
--- a/drivers/base/dma-contiguous.c~mm-cma-change-cma_declare_contiguous-to-obey-coding-convention
+++ a/drivers/base/dma-contiguous.c
@@ -165,7 +165,7 @@ int __init dma_contiguous_reserve_area(p
 {
 	int ret;
 
-	ret = cma_declare_contiguous(size, base, limit, 0, 0, res_cma, fixed);
+	ret = cma_declare_contiguous(base, size, limit, 0, 0, fixed, res_cma);
 	if (ret)
 		return ret;
 
diff -puN include/linux/cma.h~mm-cma-change-cma_declare_contiguous-to-obey-coding-convention include/linux/cma.h
--- a/include/linux/cma.h~mm-cma-change-cma_declare_contiguous-to-obey-coding-convention
+++ a/include/linux/cma.h
@@ -21,7 +21,7 @@ extern unsigned long cma_get_size(struct
 extern int __init cma_declare_contiguous(phys_addr_t size,
 			phys_addr_t base, phys_addr_t limit,
 			phys_addr_t alignment, unsigned int order_per_bit,
-			struct cma **res_cma, bool fixed);
+			bool fixed, struct cma **res_cma);
 extern struct page *cma_alloc(struct cma *cma, int count, unsigned int align);
 extern bool cma_release(struct cma *cma, struct page *pages, int count);
 #endif
diff -puN mm/cma.c~mm-cma-change-cma_declare_contiguous-to-obey-coding-convention mm/cma.c
--- a/mm/cma.c~mm-cma-change-cma_declare_contiguous-to-obey-coding-convention
+++ a/mm/cma.c
@@ -141,13 +141,13 @@ core_initcall(cma_init_reserved_areas);
 
 /**
  * cma_declare_contiguous() - reserve custom contiguous area
- * @size: Size of the reserved area (in bytes),
  * @base: Base address of the reserved area optional, use 0 for any
+ * @size: Size of the reserved area (in bytes),
  * @limit: End address of the reserved memory (optional, 0 for any).
  * @alignment: Alignment for the CMA area, should be power of 2 or zero
  * @order_per_bit: Order of pages represented by one bit on bitmap.
- * @res_cma: Pointer to store the created cma region.
  * @fixed: hint about where to place the reserved area
+ * @res_cma: Pointer to store the created cma region.
  *
  * This function reserves memory from early allocator. It should be
  * called by arch specific code once the early allocator (memblock or bootmem)
@@ -157,12 +157,12 @@ core_initcall(cma_init_reserved_areas);
  * If @fixed is true, reserve contiguous area at exactly @base.  If false,
  * reserve in range from @base to @limit.
  */
-int __init cma_declare_contiguous(phys_addr_t size,
-			phys_addr_t base, phys_addr_t limit,
+int __init cma_declare_contiguous(phys_addr_t base,
+			phys_addr_t size, phys_addr_t limit,
 			phys_addr_t alignment, unsigned int order_per_bit,
-			struct cma **res_cma, bool fixed)
+			bool fixed, struct cma **res_cma)
 {
-	struct cma *cma = &cma_areas[cma_area_count];
+	struct cma *cma;
 	int ret = 0;
 
 	pr_debug("%s(size %lx, base %08lx, limit %08lx alignment %08lx)\n",
@@ -218,6 +218,7 @@ int __init cma_declare_contiguous(phys_a
 	 * Each reserved area must be initialised later, when more kernel
 	 * subsystems (like slab allocator) are available.
 	 */
+	cma = &cma_areas[cma_area_count];
 	cma->base_pfn = PFN_DOWN(base);
 	cma->count = size >> PAGE_SHIFT;
 	cma->order_per_bit = order_per_bit;
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
page-owners-correct-page-order-when-to-free-page.patch

