From: akpm@linux-foundation.org
Subject: +
 mm-cma-change-cma_declare_contiguous-to-obey-coding-convention.patch added
 to -mm tree
Date: Wed, 18 Jun 2014 13:53:17 -0700
Message-ID: <53a1fc3d.q6+EUx8M+Uenq/Af%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41771 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596AbaFRUxS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jun 2014 16:53:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, pbonzini@redhat.com, paulus@samba.org, minchan@kernel.org, mina86@mina86.com, m.szyprowski@samsung.com, gleb@kernel.org, benh@kernel.crashing.org, aneesh.kumar@linux.vnet.ibm.com, agraf@suse.de, iamjoonsoo.kim@lge.com


The patch titled
     Subject: mm, CMA: change cma_declare_contiguous() to obey coding convention
has been added to the -mm tree.  Its filename is
     mm-cma-change-cma_declare_contiguous-to-obey-coding-convention.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cma-change-cma_declare_contiguous-to-obey-coding-convention.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-change-cma_declare_contiguous-to-obey-coding-convention.patch

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
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
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
@@ -15,7 +15,7 @@ extern unsigned long cma_get_size(struct
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

