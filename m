From: akpm@linux-foundation.org
Subject: - slub-i386-support.patch removed from -mm tree
Date: Sat, 12 May 2007 22:14:58 -0700
Message-ID: <200705130514.l4D5Ew0t022735@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47472 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755384AbXEMFPJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 May 2007 01:15:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, wli@holomorphy.com, mm-commits@vger.kernel.org


The patch titled
     SLUB: i386 support
has been removed from the -mm tree.  Its filename was
     slub-i386-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SLUB: i386 support
From: Christoph Lameter <clameter@sgi.com>

SLUB cannot run on i386 at this point because i386 uses the page->private and
page->index field of slab pages for the pgd cache.

Make SLUB run on i386 by replacing the pgd slab cache with a quicklist.
Limit the changes as much as possible. Leave the improvised linked list in place
etc etc. This has been working here for a couple of weeks now.

Acked-by: William Lee Irwin III <wli@holomorphy.com>
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
@@ -186,6 +186,7 @@ void cpu_idle(void)
 			if (__get_cpu_var(cpu_idle_state))
 				__get_cpu_var(cpu_idle_state) = 0;
 
+			check_pgt_cache();
 			rmb();
 			idle = pm_idle;
 
diff -puN arch/i386/kernel/smp.c~slub-i386-support arch/i386/kernel/smp.c
--- a/arch/i386/kernel/smp.c~slub-i386-support
+++ a/arch/i386/kernel/smp.c
@@ -421,7 +421,7 @@ void flush_tlb_mm (struct mm_struct * mm
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
@@ -740,7 +740,6 @@ int remove_memory(u64 start, u64 size)
 EXPORT_SYMBOL_GPL(remove_memory);
 #endif
 
-struct kmem_cache *pgd_cache;
 struct kmem_cache *pmd_cache;
 
 void __init pgtable_cache_init(void)
@@ -764,12 +763,6 @@ void __init pgtable_cache_init(void)
 			pgd_size = PAGE_SIZE;
 		}
 	}
-	pgd_cache = kmem_cache_create("pgd",
-				pgd_size,
-				pgd_size,
-				SLAB_PANIC,
-				pgd_ctor,
-				(!SHARED_KERNEL_PMD) ? pgd_dtor : NULL);
 }
 
 /*
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

git-ubi.patch
quicklist-support-for-x86_64.patch
slab-allocators-drop-support-for-destructors.patch
remove-slab_ctor_constructor.patch
remove-constructor-from-buffer_head.patch
remove-slab_ctor_constructor-fix.patch
change-zonelist-order-zonelist-order-selection-logic.patch
change-zonelist-order-v6-zonelist-fix.patch
change-zonelist-order-auto-configuration.patch
change-zonelist-order-documentaion.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-reduce-antifrag-max-order.patch
slub-reduce-antifrag-max-order-use-antifrag-constant-instead-of-hardcoding-page-order.patch
define-percpu-smp-cacheline-align-interface.patch
call-percpu-smp-cacheline-algin-interface.patch
mm-implement-swap-prefetching.patch
revoke-core-code.patch
