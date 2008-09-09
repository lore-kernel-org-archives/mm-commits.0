From: akpm@linux-foundation.org
Subject: + mm-define-use_split_ptlocks-rather-than-repeating-expression.patch added to -mm tree
Date: Tue, 09 Sep 2008 15:51:59 -0700
Message-ID: <200809092252.m89Mq0OU007458@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43344 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753000AbYIIWw1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Sep 2008 18:52:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, alex.nixon@citrix.com, hugh@veritas.com, jeremy.fitzhardinge@citrix.com, mingo@elte.hu


The patch titled
     mm: define USE_SPLIT_PTLOCKS rather than repeating expression
has been added to the -mm tree.  Its filename is
     mm-define-use_split_ptlocks-rather-than-repeating-expression.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: define USE_SPLIT_PTLOCKS rather than repeating expression
From: Jeremy Fitzhardinge <jeremy@goop.org>

Define USE_SPLIT_PTLOCKS as a constant expression rather than repeating
"NR_CPUS >= CONFIG_SPLIT_PTLOCK_CPUS" all over the place.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Alex Nixon <alex.nixon@citrix.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/xen/mmu.c       |    2 +-
 include/linux/mm.h       |    6 +++---
 include/linux/mm_types.h |   10 ++++++----
 include/linux/sched.h    |    6 +++---
 4 files changed, 13 insertions(+), 11 deletions(-)

diff -puN arch/x86/xen/mmu.c~mm-define-use_split_ptlocks-rather-than-repeating-expression arch/x86/xen/mmu.c
--- a/arch/x86/xen/mmu.c~mm-define-use_split_ptlocks-rather-than-repeating-expression
+++ a/arch/x86/xen/mmu.c
@@ -746,7 +746,7 @@ static spinlock_t *xen_pte_lock(struct p
 {
 	spinlock_t *ptl = NULL;
 
-#if NR_CPUS >= CONFIG_SPLIT_PTLOCK_CPUS
+#if USE_SPLIT_PTLOCKS
 	ptl = __pte_lockptr(page);
 	spin_lock(ptl);
 #endif
diff -puN include/linux/mm.h~mm-define-use_split_ptlocks-rather-than-repeating-expression include/linux/mm.h
--- a/include/linux/mm.h~mm-define-use_split_ptlocks-rather-than-repeating-expression
+++ a/include/linux/mm.h
@@ -919,7 +919,7 @@ static inline pmd_t *pmd_alloc(struct mm
 }
 #endif /* CONFIG_MMU && !__ARCH_HAS_4LEVEL_HACK */
 
-#if NR_CPUS >= CONFIG_SPLIT_PTLOCK_CPUS
+#if USE_SPLIT_PTLOCKS
 /*
  * We tuck a spinlock to guard each pagetable page into its struct page,
  * at page->private, with BUILD_BUG_ON to make sure that this will not
@@ -932,14 +932,14 @@ static inline pmd_t *pmd_alloc(struct mm
 } while (0)
 #define pte_lock_deinit(page)	((page)->mapping = NULL)
 #define pte_lockptr(mm, pmd)	({(void)(mm); __pte_lockptr(pmd_page(*(pmd)));})
-#else
+#else	/* !USE_SPLIT_PTLOCKS */
 /*
  * We use mm->page_table_lock to guard all pagetable pages of the mm.
  */
 #define pte_lock_init(page)	do {} while (0)
 #define pte_lock_deinit(page)	do {} while (0)
 #define pte_lockptr(mm, pmd)	({(void)(pmd); &(mm)->page_table_lock;})
-#endif /* NR_CPUS < CONFIG_SPLIT_PTLOCK_CPUS */
+#endif /* USE_SPLIT_PTLOCKS */
 
 static inline void pgtable_page_ctor(struct page *page)
 {
diff -puN include/linux/mm_types.h~mm-define-use_split_ptlocks-rather-than-repeating-expression include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-define-use_split_ptlocks-rather-than-repeating-expression
+++ a/include/linux/mm_types.h
@@ -21,11 +21,13 @@
 
 struct address_space;
 
-#if NR_CPUS >= CONFIG_SPLIT_PTLOCK_CPUS
+#define USE_SPLIT_PTLOCKS	(NR_CPUS >= CONFIG_SPLIT_PTLOCK_CPUS)
+
+#if USE_SPLIT_PTLOCKS
 typedef atomic_long_t mm_counter_t;
-#else  /* NR_CPUS < CONFIG_SPLIT_PTLOCK_CPUS */
+#else  /* !USE_SPLIT_PTLOCKS */
 typedef unsigned long mm_counter_t;
-#endif /* NR_CPUS < CONFIG_SPLIT_PTLOCK_CPUS */
+#endif /* !USE_SPLIT_PTLOCKS */
 
 /*
  * Each physical page in the system has a struct page associated with
@@ -65,7 +67,7 @@ struct page {
 						 * see PAGE_MAPPING_ANON below.
 						 */
 	    };
-#if NR_CPUS >= CONFIG_SPLIT_PTLOCK_CPUS
+#if USE_SPLIT_PTLOCKS
 	    spinlock_t ptl;
 #endif
 	    struct kmem_cache *slab;	/* SLUB: Pointer to slab */
diff -puN include/linux/sched.h~mm-define-use_split_ptlocks-rather-than-repeating-expression include/linux/sched.h
--- a/include/linux/sched.h~mm-define-use_split_ptlocks-rather-than-repeating-expression
+++ a/include/linux/sched.h
@@ -352,7 +352,7 @@ arch_get_unmapped_area_topdown(struct fi
 extern void arch_unmap_area(struct mm_struct *, unsigned long);
 extern void arch_unmap_area_topdown(struct mm_struct *, unsigned long);
 
-#if NR_CPUS >= CONFIG_SPLIT_PTLOCK_CPUS
+#if USE_SPLIT_PTLOCKS
 /*
  * The mm counters are not protected by its page_table_lock,
  * so must be incremented atomically.
@@ -363,7 +363,7 @@ extern void arch_unmap_area_topdown(stru
 #define inc_mm_counter(mm, member) atomic_long_inc(&(mm)->_##member)
 #define dec_mm_counter(mm, member) atomic_long_dec(&(mm)->_##member)
 
-#else  /* NR_CPUS < CONFIG_SPLIT_PTLOCK_CPUS */
+#else  /* !USE_SPLIT_PTLOCKS */
 /*
  * The mm counters are protected by its page_table_lock,
  * so can be incremented directly.
@@ -374,7 +374,7 @@ extern void arch_unmap_area_topdown(stru
 #define inc_mm_counter(mm, member) (mm)->_##member++
 #define dec_mm_counter(mm, member) (mm)->_##member--
 
-#endif /* NR_CPUS < CONFIG_SPLIT_PTLOCK_CPUS */
+#endif /* !USE_SPLIT_PTLOCKS */
 
 #define get_mm_rss(mm)					\
 	(get_mm_counter(mm, file_rss) + get_mm_counter(mm, anon_rss))
_

Patches currently in -mm which might be from jeremy@goop.org are

origin.patch
linux-next.patch
x86-pgd_cdtor-cleanup.patch
x86-adjust-vmalloc_sync_all-for-xen-2nd-try.patch
mm-define-use_split_ptlocks-rather-than-repeating-expression.patch
xen-fix-pinning-when-not-using-split-pte-locks.patch
mm-rewrite-vmap-layer.patch
mm-rewrite-vmap-layer-fix.patch
mm-rewrite-vmap-layer-fix-fix.patch
mm-rewrite-vmap-layer-fix-fix-fix.patch
add-phys_addr_t-for-holding-physical-addresses.patch
make-pfn_phys-explicitly-return-phys_addr_t.patch
redefine-resource_size_t-as-phys_addr_t.patch
drivers-net-xen-netfrontc-use-div_round_up.patch

