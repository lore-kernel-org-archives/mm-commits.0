From: akpm@linux-foundation.org
Subject: + slub-i386-support.patch added to -mm tree
Date: Thu, 26 Apr 2007 23:31:45 -0700
Message-ID: <200704270631.l3R6VjEf021336@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35769 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755399AbXD0Gbt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 02:31:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, wli@holomorphy.com


The patch titled
     SLUB: i386 support
has been added to the -mm tree.  Its filename is
     slub-i386-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SLUB: i386 support
From: Christoph Lameter <clameter@sgi.com>

SLUB cannot run on i386 at this point because i386 uses the page->private and
page->index field of slab pages for the pgd cache.

Make SLUB run on i386 by replacing the pgd slab cache with a quicklist.
Limit the changes as much as possible. Leave the improvised linked list in place
etc etc. This has been working here for a couple of weeks now.

Cc: William Lee Irwin III <wli@holomorphy.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/Kconfig          |    8 ++++----
 arch/i386/kernel/process.c |    1 +
 arch/i386/kernel/smp.c     |    2 +-
 arch/i386/mm/init.c        |    7 -------
 arch/i386/mm/pgtable.c     |   26 +++++++++++++++++---------
 include/asm-i386/pgalloc.h |    2 --
 include/asm-i386/pgtable.h |    5 ++---
 7 files changed, 25 insertions(+), 26 deletions(-)

diff -puN arch/i386/Kconfig~slub-i386-support arch/i386/Kconfig
--- a/arch/i386/Kconfig~slub-i386-support
+++ a/arch/i386/Kconfig
@@ -55,6 +55,10 @@ config ZONE_DMA
 	bool
 	default y
 
+config QUICKLIST
+	bool
+	default y
+
 config SBUS
 	bool
 
@@ -79,10 +83,6 @@ config ARCH_MAY_HAVE_PC_FDC
 	bool
 	default y
 
-config ARCH_USES_SLAB_PAGE_STRUCT
-	bool
-	default y
-
 config DMI
 	bool
 	default y
diff -puN arch/i386/kernel/process.c~slub-i386-support arch/i386/kernel/process.c
--- a/arch/i386/kernel/process.c~slub-i386-support
+++ a/arch/i386/kernel/process.c
@@ -187,6 +187,7 @@ void cpu_idle(void)
 			if (__get_cpu_var(cpu_idle_state))
 				__get_cpu_var(cpu_idle_state) = 0;
 
+			check_pgt_cache();
 			rmb();
 			idle = pm_idle;
 
diff -puN arch/i386/kernel/smp.c~slub-i386-support arch/i386/kernel/smp.c
--- a/arch/i386/kernel/smp.c~slub-i386-support
+++ a/arch/i386/kernel/smp.c
@@ -430,7 +430,7 @@ void flush_tlb_mm (struct mm_struct * mm
 	}
 	if (!cpus_empty(cpu_mask))
 		flush_tlb_others(cpu_mask, mm, TLB_FLUSH_ALL);
-
+	check_pgt_cache();
 	preempt_enable();
 }
 
diff -puN arch/i386/mm/init.c~slub-i386-support arch/i386/mm/init.c
--- a/arch/i386/mm/init.c~slub-i386-support
+++ a/arch/i386/mm/init.c
@@ -752,7 +752,6 @@ int remove_memory(u64 start, u64 size)
 EXPORT_SYMBOL_GPL(remove_memory);
 #endif
 
-struct kmem_cache *pgd_cache;
 struct kmem_cache *pmd_cache;
 
 void __init pgtable_cache_init(void)
@@ -779,12 +778,6 @@ void __init pgtable_cache_init(void)
 			pgd_size = PAGE_SIZE;
 		}
 	}
-	pgd_cache = kmem_cache_create("pgd",
-				pgd_size,
-				pgd_size,
-				0,
-				pgd_ctor,
-				(!SHARED_KERNEL_PMD) ? pgd_dtor : NULL);
 	if (!pgd_cache)
 		panic("pgtable_cache_init(): Cannot create pgd cache");
 }
diff -puN arch/i386/mm/pgtable.c~slub-i386-support arch/i386/mm/pgtable.c
--- a/arch/i386/mm/pgtable.c~slub-i386-support
+++ a/arch/i386/mm/pgtable.c
@@ -13,6 +13,7 @@
 #include <linux/pagemap.h>
 #include <linux/spinlock.h>
 #include <linux/module.h>
+#include <linux/quicklist.h>
 
 #include <asm/system.h>
 #include <asm/pgtable.h>
@@ -205,8 +206,6 @@ void pmd_ctor(void *pmd, struct kmem_cac
  * against pageattr.c; it is the unique case in which a valid change
  * of kernel pagetables can't be lazily synchronized by vmalloc faults.
  * vmalloc faults work because attached pagetables are never freed.
- * The locking scheme was chosen on the basis of manfred's
- * recommendations and having no core impact whatsoever.
  * -- wli
  */
 DEFINE_SPINLOCK(pgd_lock);
@@ -232,9 +231,11 @@ static inline void pgd_list_del(pgd_t *p
 		set_page_private(next, (unsigned long)pprev);
 }
 
+
+
 #if (PTRS_PER_PMD == 1)
 /* Non-PAE pgd constructor */
-void pgd_ctor(void *pgd, struct kmem_cache *cache, unsigned long unused)
+void pgd_ctor(void *pgd)
 {
 	unsigned long flags;
 
@@ -256,7 +257,7 @@ void pgd_ctor(void *pgd, struct kmem_cac
 }
 #else  /* PTRS_PER_PMD > 1 */
 /* PAE pgd constructor */
-void pgd_ctor(void *pgd, struct kmem_cache *cache, unsigned long unused)
+void pgd_ctor(void *pgd)
 {
 	/* PAE, kernel PMD may be shared */
 
@@ -275,11 +276,12 @@ void pgd_ctor(void *pgd, struct kmem_cac
 }
 #endif	/* PTRS_PER_PMD */
 
-void pgd_dtor(void *pgd, struct kmem_cache *cache, unsigned long unused)
+void pgd_dtor(void *pgd)
 {
 	unsigned long flags; /* can be called from interrupt context */
 
-	BUG_ON(SHARED_KERNEL_PMD);
+	if (SHARED_KERNEL_PMD)
+		return;
 
 	paravirt_release_pd(__pa(pgd) >> PAGE_SHIFT);
 	spin_lock_irqsave(&pgd_lock, flags);
@@ -321,7 +323,7 @@ static void pmd_cache_free(pmd_t *pmd, i
 pgd_t *pgd_alloc(struct mm_struct *mm)
 {
 	int i;
-	pgd_t *pgd = kmem_cache_alloc(pgd_cache, GFP_KERNEL);
+	pgd_t *pgd = quicklist_alloc(0, GFP_KERNEL, pgd_ctor);
 
 	if (PTRS_PER_PMD == 1 || !pgd)
 		return pgd;
@@ -344,7 +346,7 @@ out_oom:
 		paravirt_release_pd(__pa(pmd) >> PAGE_SHIFT);
 		pmd_cache_free(pmd, i);
 	}
-	kmem_cache_free(pgd_cache, pgd);
+	quicklist_free(0, pgd_dtor, pgd);
 	return NULL;
 }
 
@@ -361,5 +363,11 @@ void pgd_free(pgd_t *pgd)
 			pmd_cache_free(pmd, i);
 		}
 	/* in the non-PAE case, free_pgtables() clears user pgd entries */
-	kmem_cache_free(pgd_cache, pgd);
+	quicklist_free(0, pgd_dtor, pgd);
 }
+
+void check_pgt_cache(void)
+{
+	quicklist_trim(0, pgd_dtor, 25, 16);
+}
+
diff -puN include/asm-i386/pgalloc.h~slub-i386-support include/asm-i386/pgalloc.h
--- a/include/asm-i386/pgalloc.h~slub-i386-support
+++ a/include/asm-i386/pgalloc.h
@@ -65,6 +65,4 @@ do {									\
 #define pud_populate(mm, pmd, pte)	BUG()
 #endif
 
-#define check_pgt_cache()	do { } while (0)
-
 #endif /* _I386_PGALLOC_H */
diff -puN include/asm-i386/pgtable.h~slub-i386-support include/asm-i386/pgtable.h
--- a/include/asm-i386/pgtable.h~slub-i386-support
+++ a/include/asm-i386/pgtable.h
@@ -35,17 +35,16 @@ struct vm_area_struct;
 #define ZERO_PAGE(vaddr) (virt_to_page(empty_zero_page))
 extern unsigned long empty_zero_page[1024];
 extern pgd_t swapper_pg_dir[1024];
-extern struct kmem_cache *pgd_cache;
 extern struct kmem_cache *pmd_cache;
 extern spinlock_t pgd_lock;
 extern struct page *pgd_list;
+void check_pgt_cache(void);
 
 void pmd_ctor(void *, struct kmem_cache *, unsigned long);
-void pgd_ctor(void *, struct kmem_cache *, unsigned long);
-void pgd_dtor(void *, struct kmem_cache *, unsigned long);
 void pgtable_cache_init(void);
 void paging_init(void);
 
+
 /*
  * The Linux x86 paging architecture is 'compile-time dual-mode', it
  * implements both the traditional 2-level x86 page tables and the
_

Patches currently in -mm which might be from clameter@sgi.com are

slab-introduce-krealloc.patch
slab-introduce-krealloc-fix.patch
ia64-sn-xpc-convert-to-use-kthread-api-fix.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
slab-ensure-cache_alloc_refill-terminates.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch
slab-use-num_possible_cpus-in-enable_cpucache.patch
extend-print_symbol-capability-fix.patch
extend-print_symbol-capability-fix-fix.patch
i386-use-page-allocator-to-allocate-thread_info-structure.patch
slub-core.patch
slub-fix-numa-bootstrap.patch
slub-use-correct-flags-to-check-for-dma-cache.patch
slub-treat-slab_hwcache_align-as-a-mininum-and-not-as-the-alignment.patch
slub-core-minor-fixes.patch
slub-core-use-enum-for-tracking-modes-instead-of-integers.patch
slub-core-fix-another-numa-bootstrap-issue.patch
slub-core-fix-object-counting.patch
slub-core-drop-version-number.patch
slub-core-tidy.patch
slub-core-tidy-2.patch
slub-core-tidy-3.patch
slub-core-tidy-4.patch
slub-core-tidy-5.patch
slub-core-tidy-6.patch
slub-core-tidy-7.patch
slub-core-tidy-8.patch
slub-core-tidy-9.patch
slub-core-we-do-not-need-ifdef-config_smp-around-bit-spinlocks.patch
slub-core-printk-facility-level-cleanup.patch
slub-core-kmem_cache_close-is-static-and-should-not-be-exported.patch
slub-core-add-explanation-for-defrag_ratio-=-100.patch
slub-core-add-explanation-for-locking.patch
slub-core-add-explanation-for-locking-fix.patch
slub-core-explain-the-64k-limits.patch
slub-core-explain-sizing-of-slabs-in-detail.patch
slub-core-explain-sizing-of-slabs-in-detail-fix.patch
slub-core-add-checks-for-interrupts-disabled.patch
slub-core-use-__print_symbol-instead-of-kallsyms_lookup.patch
slub-core-missing-inlines-and-statics.patch
slub-fix-cpu-slab-flushing-behavior-so-that-counters-match.patch
slub-extract-finish_bootstrap-function-for-clean-sysfs-boot.patch
slub-core-fix-kmem_cache_destroy.patch
slub-core-fix-validation.patch
slub-core-add-after-object-padding.patch
slub-core-resiliency-fixups.patch
slub-core-resiliency-fixups-fix.patch
slub-core-resiliency-test.patch
slub-core-update-cpu-after-new_slab.patch
slub-core-fix-sysfs-directory-handling.patch
slub-core-conform-more-to-slabs-slab_hwcache_align-behavior.patch
slub-core-reduce-the-order-of-allocations-to-avoid-fragmentation.patch
make-page-private-usable-in-compound-pages-v1.patch
make-page-private-usable-in-compound-pages-v1-hugetlb-fix.patch
optimize-compound_head-by-avoiding-a-shared-page.patch
add-virt_to_head_page-and-consolidate-code-in-slab-and-slub.patch
slub-fix-object-tracking.patch
slub-enable-tracking-of-full-slabs.patch
slub-enable-tracking-of-full-slabs-fix.patch
slub-enable-tracking-of-full-slabs-add-checks-for-interrupts-disabled.patch
slub-validation-of-slabs-metadata-and-guard-zones.patch
slub-validation-of-slabs-metadata-and-guard-zones-fix-pageerror-checks-during-validation.patch
slub-validation-of-slabs-metadata-and-guard-zones-remove-duplicate-vm_bug_on.patch
slub-add-min_partial.patch
slub-add-ability-to-list-alloc--free-callers-per-slab.patch
slub-add-ability-to-list-alloc--free-callers-per-slab-tidy.patch
slub-free-slabs-and-sort-partial-slab-lists-in-kmem_cache_shrink.patch
slub-remove-object-activities-out-of-checking-functions.patch
slub-user-documentation.patch
slub-user-documentation-fix.patch
slub-add-slabinfo-tool.patch
slub-add-slabinfo-tool-update-slabinfoc.patch
slub-major-slabinfo-update.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-i386-support.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
quicklists-for-page-table-pages.patch
quicklists-for-page-table-pages-avoid-useless-virt_to_page-conversion.patch
quicklists-for-page-table-pages-avoid-useless-virt_to_page-conversion-fix.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
quicklist-support-for-sparc64.patch
slab-allocators-remove-obsolete-slab_must_hwcache_align.patch
kmem_cache-simplify-slab-cache-creation.patch
slab-allocators-remove-slab_debug_initial-flag.patch
slab-allocators-remove-slab_debug_initial-flag-locks-fix.patch
slab-allocators-remove-multiple-alignment-specifications.patch
slab-allocators-remove-slab_ctor_atomic.patch
fault-injection-fix-failslab-with-config_numa.patch
mm-fix-handling-of-panic_on_oom-when-cpusets-are-in-use.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
revoke-core-code-slab-allocators-remove-slab_debug_initial-flag-revoke.patch
readahead-state-based-method-aging-accounting.patch
