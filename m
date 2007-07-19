From: akpm@linux-foundation.org
Subject: - quicklist-support-for-x86_64.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:08:17 -0700
Message-ID: <200707192008.l6JK8HGg020443@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45887 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757157AbXGSUYO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:24:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, ak@suse.de, davem@davemloft.net, tony.luck@intel.com, wli@holomorphy.com, mm-commits@vger.kernel.org


The patch titled
     Quicklist support for x86_64
has been removed from the -mm tree.  Its filename was
     quicklist-support-for-x86_64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Quicklist support for x86_64
From: Christoph Lameter <clameter@sgi.com>

This adds caching of pgds and puds, pmds, pte.  That way we can avoid costly
zeroing and initialization of special mappings in the pgd.

A second quicklist is useful to separate out PGD handling.  We can carry the
initialized pgds over to the next process needing them.

Also clean up the pgd_list handling to use regular list macros.  There is no
need anymore to avoid the lru field.

Move the add/removal of the pgds to the pgdlist into the constructor /
destructor.  That way the implementation is congruent with i386.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Andi Kleen <ak@suse.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Acked-by: William Lee Irwin III <wli@holomorphy.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/Kconfig          |    8 +++
 arch/x86_64/kernel/process.c |    1 
 arch/x86_64/kernel/smp.c     |    2 
 include/asm-x86_64/pgalloc.h |   73 ++++++++++++++++++++++-----------
 include/asm-x86_64/pgtable.h |    1 
 5 files changed, 59 insertions(+), 26 deletions(-)

diff -puN arch/x86_64/Kconfig~quicklist-support-for-x86_64 arch/x86_64/Kconfig
--- a/arch/x86_64/Kconfig~quicklist-support-for-x86_64
+++ a/arch/x86_64/Kconfig
@@ -56,6 +56,14 @@ config ZONE_DMA
 	bool
 	default y
 
+config QUICKLIST
+	bool
+	default y
+
+config NR_QUICK
+	int
+	default 2
+
 config ISA
 	bool
 
diff -puN arch/x86_64/kernel/process.c~quicklist-support-for-x86_64 arch/x86_64/kernel/process.c
--- a/arch/x86_64/kernel/process.c~quicklist-support-for-x86_64
+++ a/arch/x86_64/kernel/process.c
@@ -207,6 +207,7 @@ void cpu_idle (void)
 			if (__get_cpu_var(cpu_idle_state))
 				__get_cpu_var(cpu_idle_state) = 0;
 
+			check_pgt_cache();
 			rmb();
 			idle = pm_idle;
 			if (!idle)
diff -puN arch/x86_64/kernel/smp.c~quicklist-support-for-x86_64 arch/x86_64/kernel/smp.c
--- a/arch/x86_64/kernel/smp.c~quicklist-support-for-x86_64
+++ a/arch/x86_64/kernel/smp.c
@@ -241,7 +241,7 @@ void flush_tlb_mm (struct mm_struct * mm
 	}
 	if (!cpus_empty(cpu_mask))
 		flush_tlb_others(cpu_mask, mm, FLUSH_ALL);
-
+	check_pgt_cache();
 	preempt_enable();
 }
 EXPORT_SYMBOL(flush_tlb_mm);
diff -puN include/asm-x86_64/pgalloc.h~quicklist-support-for-x86_64 include/asm-x86_64/pgalloc.h
--- a/include/asm-x86_64/pgalloc.h~quicklist-support-for-x86_64
+++ a/include/asm-x86_64/pgalloc.h
@@ -4,6 +4,10 @@
 #include <asm/pda.h>
 #include <linux/threads.h>
 #include <linux/mm.h>
+#include <linux/quicklist.h>
+
+#define QUICK_PGD 0	/* We preserve special mappings over free */
+#define QUICK_PT 1	/* Other page table pages that are zero on free */
 
 #define pmd_populate_kernel(mm, pmd, pte) \
 		set_pmd(pmd, __pmd(_PAGE_TABLE | __pa(pte)))
@@ -20,23 +24,23 @@ static inline void pmd_populate(struct m
 static inline void pmd_free(pmd_t *pmd)
 {
 	BUG_ON((unsigned long)pmd & (PAGE_SIZE-1));
-	free_page((unsigned long)pmd);
+	quicklist_free(QUICK_PT, NULL, pmd);
 }
 
 static inline pmd_t *pmd_alloc_one (struct mm_struct *mm, unsigned long addr)
 {
-	return (pmd_t *)get_zeroed_page(GFP_KERNEL|__GFP_REPEAT);
+	return (pmd_t *)quicklist_alloc(QUICK_PT, GFP_KERNEL|__GFP_REPEAT, NULL);
 }
 
 static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long addr)
 {
-	return (pud_t *)get_zeroed_page(GFP_KERNEL|__GFP_REPEAT);
+	return (pud_t *)quicklist_alloc(QUICK_PT, GFP_KERNEL|__GFP_REPEAT, NULL);
 }
 
 static inline void pud_free (pud_t *pud)
 {
 	BUG_ON((unsigned long)pud & (PAGE_SIZE-1));
-	free_page((unsigned long)pud);
+	quicklist_free(QUICK_PT, NULL, pud);
 }
 
 static inline void pgd_list_add(pgd_t *pgd)
@@ -57,41 +61,57 @@ static inline void pgd_list_del(pgd_t *p
 	spin_unlock(&pgd_lock);
 }
 
-static inline pgd_t *pgd_alloc(struct mm_struct *mm)
+static inline void pgd_ctor(void *x)
 {
 	unsigned boundary;
-	pgd_t *pgd = (pgd_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT);
-	if (!pgd)
-		return NULL;
-	pgd_list_add(pgd);
+	pgd_t *pgd = x;
+	struct page *page = virt_to_page(pgd);
+
 	/*
 	 * Copy kernel pointers in from init.
-	 * Could keep a freelist or slab cache of those because the kernel
-	 * part never changes.
 	 */
 	boundary = pgd_index(__PAGE_OFFSET);
-	memset(pgd, 0, boundary * sizeof(pgd_t));
 	memcpy(pgd + boundary,
-	       init_level4_pgt + boundary,
-	       (PTRS_PER_PGD - boundary) * sizeof(pgd_t));
+		init_level4_pgt + boundary,
+		(PTRS_PER_PGD - boundary) * sizeof(pgd_t));
+
+	spin_lock(&pgd_lock);
+	list_add(&page->lru, &pgd_list);
+	spin_unlock(&pgd_lock);
+}
+
+static inline void pgd_dtor(void *x)
+{
+	pgd_t *pgd = x;
+	struct page *page = virt_to_page(pgd);
+
+        spin_lock(&pgd_lock);
+	list_del(&page->lru);
+	spin_unlock(&pgd_lock);
+}
+
+static inline pgd_t *pgd_alloc(struct mm_struct *mm)
+{
+	pgd_t *pgd = (pgd_t *)quicklist_alloc(QUICK_PGD,
+		GFP_KERNEL|__GFP_REPEAT, pgd_ctor);
 	return pgd;
 }
 
 static inline void pgd_free(pgd_t *pgd)
 {
 	BUG_ON((unsigned long)pgd & (PAGE_SIZE-1));
-	pgd_list_del(pgd);
-	free_page((unsigned long)pgd);
+	quicklist_free(QUICK_PGD, pgd_dtor, pgd);
 }
 
 static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
 {
-	return (pte_t *)get_zeroed_page(GFP_KERNEL|__GFP_REPEAT);
+	return (pte_t *)quicklist_alloc(QUICK_PT, GFP_KERNEL|__GFP_REPEAT, NULL);
 }
 
 static inline struct page *pte_alloc_one(struct mm_struct *mm, unsigned long address)
 {
-	void *p = (void *)get_zeroed_page(GFP_KERNEL|__GFP_REPEAT);
+	void *p = (void *)quicklist_alloc(QUICK_PT, GFP_KERNEL|__GFP_REPEAT, NULL);
+
 	if (!p)
 		return NULL;
 	return virt_to_page(p);
@@ -103,17 +123,22 @@ static inline struct page *pte_alloc_one
 static inline void pte_free_kernel(pte_t *pte)
 {
 	BUG_ON((unsigned long)pte & (PAGE_SIZE-1));
-	free_page((unsigned long)pte); 
+	quicklist_free(QUICK_PT, NULL, pte);
 }
 
 static inline void pte_free(struct page *pte)
 {
-	__free_page(pte);
-} 
+	quicklist_free_page(QUICK_PT, NULL, pte);
+}
 
-#define __pte_free_tlb(tlb,pte) tlb_remove_page((tlb),(pte))
+#define __pte_free_tlb(tlb,pte) quicklist_free_page(QUICK_PT, NULL,(pte))
 
-#define __pmd_free_tlb(tlb,x)   tlb_remove_page((tlb),virt_to_page(x))
-#define __pud_free_tlb(tlb,x)   tlb_remove_page((tlb),virt_to_page(x))
+#define __pmd_free_tlb(tlb,x)   quicklist_free(QUICK_PT, NULL, (x))
+#define __pud_free_tlb(tlb,x)   quicklist_free(QUICK_PT, NULL, (x))
 
+static inline void check_pgt_cache(void)
+{
+	quicklist_trim(QUICK_PGD, pgd_dtor, 25, 16);
+	quicklist_trim(QUICK_PT, NULL, 25, 16);
+}
 #endif /* _X86_64_PGALLOC_H */
diff -puN include/asm-x86_64/pgtable.h~quicklist-support-for-x86_64 include/asm-x86_64/pgtable.h
--- a/include/asm-x86_64/pgtable.h~quicklist-support-for-x86_64
+++ a/include/asm-x86_64/pgtable.h
@@ -409,7 +409,6 @@ extern int kern_addr_valid(unsigned long
 #define HAVE_ARCH_UNMAPPED_AREA
 
 #define pgtable_cache_init()   do { } while (0)
-#define check_pgt_cache()      do { } while (0)
 
 #define PAGE_AGP    PAGE_KERNEL_NOCACHE
 #define HAVE_PAGE_AGP 1
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
pa-risc-use-page-allocator-instead-of-slab-allocator.patch
slob-reduce-list-scanning.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-reduce-antifrag-max-order.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
memory-unplug-v7-migration-by-kernel.patch
memory-unplug-v7-isolate_lru_page-fix.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-cpuset-zero-malloc-fix-for-new-containers.patch
page-owner-tracking-leak-detector.patch
