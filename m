From: akpm@linux-foundation.org
Subject: - lazy-freeing-of-memory-through-madv_free.patch removed from -mm tree
Date: Tue, 29 May 2007 14:02:04 -0700
Message-ID: <200705292102.l4TL24al011407@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:40184 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757604AbXE2VCp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 17:02:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, a.p.zijlstra@chello.nl, drepper@redhat.com, hugh@veritas.com, mtk-manpages@gmx.net, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     lazy freeing of memory through MADV_FREE
has been removed from the -mm tree.  Its filename was
     lazy-freeing-of-memory-through-madv_free.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
Subject: lazy freeing of memory through MADV_FREE
From: Rik van Riel <riel@redhat.com>

Make it possible for applications to have the kernel free memory lazily. 
This reduces a repeated free/malloc cycle from freeing pages and allocating
them, to just marking them freeable.  If the application wants to reuse
them before the kernel needs the memory, not even a page fault will happen.

This patch, together with Ulrich's glibc change, increases MySQL sysbench
performance by a factor of 2 on my quad core test system.

Ulrich Drepper has test glibc RPMS for this functionality at:

     http://people.redhat.com/drepper/rpms

When the patch goes upstream, I will submit a small follow-up patch to revert
MADV_DONTNEED behaviour to what it did previously and have the new behaviour
trigger only on MADV_FREE: at that point people will have to get new test RPMs
of glibc.


When combined with Nick's "mm: madvise avoid exclusive mmap_sem", things get
better.

It turns out that Nick's patch does not improve peak performance much, but it
does prevent the decline when running with 16 threads on my quad core CPU!

We _definitely_ want both patches, there's a huge benefit in having them both.

Here are the transactions/seconds for each combination:

    vanilla   new glibc  madv_free kernel   madv_free + mmap_sem
threads

1     610         609             596                545
2    1032        1136            1196               1200
4    1070        1128            2014               2024
8    1000        1088            1665               2087
16    779        1073            1310               1999


There are two MADV variants that free pages, both do the exact same thing with
mapped file pages, but both do something slightly different with anonymous
pages.

MADV_DONTNEED will unmap file pages and free anonymous pages.  When a process
accesses anonymous memory at an address that was zapped with MADV_DONTNEED, it
will return fresh zero filled pages.

MADV_FREE will unmap file pages.  MADV_FREE on anonymous pages is interpreted
as a signal that the application no longer needs the data in the pages, and
they can be thrown away if the kernel needs the memory for something else. 
However, if the process accesses the memory again before the kernel needs it,
the process will simply get the original pages back.  If the kernel needed the
memory first, the process will get a fresh zero filled page like with
MADV_DONTNEED.

In short:
- both MADV_FREE and MADV_DONTNEED only unmap file pages
- after MADV_DONTNEED the application will always get back
   fresh zero filled anonymous pages when accessing the
   memory
- after MADV_FREE the application can either get back the
   original data (without a page fault) or zero filled
   anonymous memory

The Linux MADV_DONTNEED behavior is not POSIX compliant.  POSIX says that with
MADV_DONTNEED the application's data will be preserved.

Currently glibc simply ignores POSIX_MADV_DONTNEED requests from applications
on Linux.  Changing the behaviour which some Linux applications may rely on
might not be the best idea.

[akpm@linux-foundation.org: fixes]
Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-alpha/mman.h   |    1 +
 include/asm-generic/mman.h |    1 +
 include/asm-mips/mman.h    |    1 +
 include/asm-parisc/mman.h  |    1 +
 include/asm-sparc/mman.h   |    2 --
 include/asm-sparc64/mman.h |    2 --
 include/asm-xtensa/mman.h  |    1 +
 include/linux/mm.h         |    1 +
 include/linux/mm_inline.h  |    7 +++++++
 include/linux/page-flags.h |    7 +++++++
 include/linux/swap.h       |    1 +
 mm/madvise.c               |   11 +++++++++--
 mm/memory.c                |   32 ++++++++++++++++++++++++++++++--
 mm/page_alloc.c            |    4 ++++
 mm/rmap.c                  |   12 +++++++++++-
 mm/swap.c                  |   14 ++++++++++++++
 mm/vmscan.c                |   18 ++++++++++++++++++
 17 files changed, 107 insertions(+), 9 deletions(-)

diff -puN include/asm-alpha/mman.h~lazy-freeing-of-memory-through-madv_free include/asm-alpha/mman.h
--- a/include/asm-alpha/mman.h~lazy-freeing-of-memory-through-madv_free
+++ a/include/asm-alpha/mman.h
@@ -42,6 +42,7 @@
 #define MADV_WILLNEED	3		/* will need these pages */
 #define	MADV_SPACEAVAIL	5		/* ensure resources are available */
 #define MADV_DONTNEED	6		/* don't need these pages */
+#define MADV_FREE	7		/* don't need the pages or the data */
 
 /* common/generic parameters */
 #define MADV_REMOVE	9		/* remove these pages & resources */
diff -puN include/asm-generic/mman.h~lazy-freeing-of-memory-through-madv_free include/asm-generic/mman.h
--- a/include/asm-generic/mman.h~lazy-freeing-of-memory-through-madv_free
+++ a/include/asm-generic/mman.h
@@ -29,6 +29,7 @@
 #define MADV_SEQUENTIAL	2		/* expect sequential page references */
 #define MADV_WILLNEED	3		/* will need these pages */
 #define MADV_DONTNEED	4		/* don't need these pages */
+#define MADV_FREE	5		/* don't need the pages or the data */
 
 /* common parameters: try to keep these consistent across architectures */
 #define MADV_REMOVE	9		/* remove these pages & resources */
diff -puN include/asm-mips/mman.h~lazy-freeing-of-memory-through-madv_free include/asm-mips/mman.h
--- a/include/asm-mips/mman.h~lazy-freeing-of-memory-through-madv_free
+++ a/include/asm-mips/mman.h
@@ -65,6 +65,7 @@
 #define MADV_SEQUENTIAL	2		/* expect sequential page references */
 #define MADV_WILLNEED	3		/* will need these pages */
 #define MADV_DONTNEED	4		/* don't need these pages */
+#define MADV_FREE	5		/* don't need the pages or the data */
 
 /* common parameters: try to keep these consistent across architectures */
 #define MADV_REMOVE	9		/* remove these pages & resources */
diff -puN include/asm-parisc/mman.h~lazy-freeing-of-memory-through-madv_free include/asm-parisc/mman.h
--- a/include/asm-parisc/mman.h~lazy-freeing-of-memory-through-madv_free
+++ a/include/asm-parisc/mman.h
@@ -38,6 +38,7 @@
 #define MADV_SPACEAVAIL 5               /* insure that resources are reserved */
 #define MADV_VPS_PURGE  6               /* Purge pages from VM page cache */
 #define MADV_VPS_INHERIT 7              /* Inherit parents page size */
+#define MADV_FREE	8		/* don't need the pages or the data */
 
 /* common/generic parameters */
 #define MADV_REMOVE	9		/* remove these pages & resources */
diff -puN include/asm-sparc/mman.h~lazy-freeing-of-memory-through-madv_free include/asm-sparc/mman.h
--- a/include/asm-sparc/mman.h~lazy-freeing-of-memory-through-madv_free
+++ a/include/asm-sparc/mman.h
@@ -33,8 +33,6 @@
 #define MC_LOCKAS       5  /* Lock an entire address space of the calling process */
 #define MC_UNLOCKAS     6  /* Unlock entire address space of calling process */
 
-#define MADV_FREE	0x5		/* (Solaris) contents can be freed */
-
 #ifdef __KERNEL__
 #ifndef __ASSEMBLY__
 #define arch_mmap_check	sparc_mmap_check
diff -puN include/asm-sparc64/mman.h~lazy-freeing-of-memory-through-madv_free include/asm-sparc64/mman.h
--- a/include/asm-sparc64/mman.h~lazy-freeing-of-memory-through-madv_free
+++ a/include/asm-sparc64/mman.h
@@ -33,8 +33,6 @@
 #define MC_LOCKAS       5  /* Lock an entire address space of the calling process */
 #define MC_UNLOCKAS     6  /* Unlock entire address space of calling process */
 
-#define MADV_FREE	0x5		/* (Solaris) contents can be freed */
-
 #ifdef __KERNEL__
 #ifndef __ASSEMBLY__
 #define arch_mmap_check	sparc64_mmap_check
diff -puN include/asm-xtensa/mman.h~lazy-freeing-of-memory-through-madv_free include/asm-xtensa/mman.h
--- a/include/asm-xtensa/mman.h~lazy-freeing-of-memory-through-madv_free
+++ a/include/asm-xtensa/mman.h
@@ -72,6 +72,7 @@
 #define MADV_SEQUENTIAL	2		/* expect sequential page references */
 #define MADV_WILLNEED	3		/* will need these pages */
 #define MADV_DONTNEED	4		/* don't need these pages */
+#define MADV_FREE	5		/* don't need the pages or the data */
 
 /* common parameters: try to keep these consistent across architectures */
 #define MADV_REMOVE	9		/* remove these pages & resources */
diff -puN include/linux/mm.h~lazy-freeing-of-memory-through-madv_free include/linux/mm.h
--- a/include/linux/mm.h~lazy-freeing-of-memory-through-madv_free
+++ a/include/linux/mm.h
@@ -750,6 +750,7 @@ struct zap_details {
 	pgoff_t last_index;			/* Highest page->index to unmap */
 	spinlock_t *i_mmap_lock;		/* For unmap_mapping_range: */
 	unsigned long truncate_count;		/* Compare vm_truncate_count */
+	short madv_free;			/* MADV_FREE anonymous memory */
 };
 
 struct page *vm_normal_page(struct vm_area_struct *, unsigned long, pte_t);
diff -puN include/linux/mm_inline.h~lazy-freeing-of-memory-through-madv_free include/linux/mm_inline.h
--- a/include/linux/mm_inline.h~lazy-freeing-of-memory-through-madv_free
+++ a/include/linux/mm_inline.h
@@ -13,6 +13,13 @@ add_page_to_inactive_list(struct zone *z
 }
 
 static inline void
+add_page_to_inactive_list_tail(struct zone *zone, struct page *page)
+{
+	list_add_tail(&page->lru, &zone->inactive_list);
+	__inc_zone_state(zone, NR_INACTIVE);
+}
+
+static inline void
 del_page_from_active_list(struct zone *zone, struct page *page)
 {
 	list_del(&page->lru);
diff -puN include/linux/page-flags.h~lazy-freeing-of-memory-through-madv_free include/linux/page-flags.h
--- a/include/linux/page-flags.h~lazy-freeing-of-memory-through-madv_free
+++ a/include/linux/page-flags.h
@@ -90,6 +90,8 @@
 #define PG_reclaim		17	/* To be reclaimed asap */
 #define PG_buddy		19	/* Page is free, on buddy lists */
 
+#define PG_lazyfree		20	/* MADV_FREE potential throwaway */
+
 /* PG_owner_priv_1 users should have descriptive aliases */
 #define PG_checked		PG_owner_priv_1 /* Used by some filesystems */
 #define PG_pinned		PG_owner_priv_1	/* Xen pinned pagetable */
@@ -231,6 +233,11 @@ static inline void SetPageUptodate(struc
 #define ClearPageReclaim(page)	clear_bit(PG_reclaim, &(page)->flags)
 #define TestClearPageReclaim(page) test_and_clear_bit(PG_reclaim, &(page)->flags)
 
+#define PageLazyFree(page)	test_bit(PG_lazyfree, &(page)->flags)
+#define SetPageLazyFree(page)	set_bit(PG_lazyfree, &(page)->flags)
+#define ClearPageLazyFree(page)	clear_bit(PG_lazyfree, &(page)->flags)
+#define __ClearPageLazyFree(page) __clear_bit(PG_lazyfree, &(page)->flags)
+
 #define PageCompound(page)	test_bit(PG_compound, &(page)->flags)
 #define __SetPageCompound(page)	__set_bit(PG_compound, &(page)->flags)
 #define __ClearPageCompound(page) __clear_bit(PG_compound, &(page)->flags)
diff -puN include/linux/swap.h~lazy-freeing-of-memory-through-madv_free include/linux/swap.h
--- a/include/linux/swap.h~lazy-freeing-of-memory-through-madv_free
+++ a/include/linux/swap.h
@@ -181,6 +181,7 @@ extern unsigned int nr_free_pagecache_pa
 extern void FASTCALL(lru_cache_add(struct page *));
 extern void FASTCALL(lru_cache_add_active(struct page *));
 extern void FASTCALL(activate_page(struct page *));
+extern void FASTCALL(deactivate_tail_page(struct page *));
 extern void FASTCALL(mark_page_accessed(struct page *));
 extern void lru_add_drain(void);
 extern int lru_add_drain_all(void);
diff -puN mm/madvise.c~lazy-freeing-of-memory-through-madv_free mm/madvise.c
--- a/mm/madvise.c~lazy-freeing-of-memory-through-madv_free
+++ a/mm/madvise.c
@@ -23,6 +23,7 @@ static int madvise_need_mmap_write(int b
 	case MADV_REMOVE:
 	case MADV_WILLNEED:
 	case MADV_DONTNEED:
+	case MADV_FREE:
 		return 0;
 	default:
 		/* be safe, default to 1. list exceptions explicitly */
@@ -161,8 +162,12 @@ static long madvise_dontneed(struct vm_a
 			.last_index = ULONG_MAX,
 		};
 		zap_page_range(vma, start, end - start, &details);
-	} else
-		zap_page_range(vma, start, end - start, NULL);
+	} else {
+		struct zap_details details = {
+			.madv_free = 1,
+		};
+		zap_page_range(vma, start, end - start, &details);
+	}
 	return 0;
 }
 
@@ -234,7 +239,9 @@ madvise_vma(struct vm_area_struct *vma, 
 		error = madvise_willneed(vma, prev, start, end);
 		break;
 
+	/* FIXME: POSIX says that MADV_DONTNEED cannot throw away data. */
 	case MADV_DONTNEED:
+	case MADV_FREE:
 		error = madvise_dontneed(vma, prev, start, end);
 		break;
 
diff -puN mm/memory.c~lazy-freeing-of-memory-through-madv_free mm/memory.c
--- a/mm/memory.c~lazy-freeing-of-memory-through-madv_free
+++ a/mm/memory.c
@@ -432,6 +432,7 @@ copy_one_pte(struct mm_struct *dst_mm, s
 	unsigned long vm_flags = vma->vm_flags;
 	pte_t pte = *src_pte;
 	struct page *page;
+	int dirty = 0;
 
 	/* pte contains position in swap or file, so copy. */
 	if (unlikely(!pte_present(pte))) {
@@ -466,6 +467,7 @@ copy_one_pte(struct mm_struct *dst_mm, s
 	 * in the parent and the child
 	 */
 	if (is_cow_mapping(vm_flags)) {
+		dirty = pte_dirty(pte);
 		ptep_set_wrprotect(src_mm, addr, src_pte);
 		pte = pte_wrprotect(pte);
 	}
@@ -483,6 +485,8 @@ copy_one_pte(struct mm_struct *dst_mm, s
 		get_page(page);
 		page_dup_rmap(page, vma, addr);
 		rss[!!PageAnon(page)]++;
+		if (dirty && PageLazyFree(page))
+			ClearPageLazyFree(page);
 	}
 
 out_set_pte:
@@ -661,6 +665,28 @@ static unsigned long zap_pte_range(struc
 				    (page->index < details->first_index ||
 				     page->index > details->last_index))
 					continue;
+
+				/*
+				 * MADV_FREE is used to lazily recycle
+				 * anon memory.  The process no longer
+				 * needs the data and wants to avoid IO.
+				 */
+				if (details->madv_free && PageAnon(page)) {
+					if (unlikely(PageSwapCache(page)) &&
+					    !TestSetPageLocked(page)) {
+						remove_exclusive_swap_page(page);
+						unlock_page(page);
+					}
+					ptep_test_and_clear_dirty(vma, addr, pte);
+					ptep_test_and_clear_young(vma, addr, pte);
+					SetPageLazyFree(page);
+					if (PageActive(page))
+						deactivate_tail_page(page);
+					/* tlb_remove_page frees it again */
+					get_page(page);
+					tlb_remove_page(tlb, page);
+					continue;
+				}
 			}
 			ptent = ptep_get_and_clear_full(mm, addr, pte,
 							tlb->fullmm);
@@ -689,7 +715,8 @@ static unsigned long zap_pte_range(struc
 		 * If details->check_mapping, we leave swap entries;
 		 * if details->nonlinear_vma, we leave file entries.
 		 */
-		if (unlikely(details))
+		if (unlikely(details && (details->check_mapping ||
+				details->nonlinear_vma)))
 			continue;
 		if (!pte_file(ptent))
 			free_swap_and_cache(pte_to_swp_entry(ptent));
@@ -755,7 +782,8 @@ static unsigned long unmap_page_range(st
 	pgd_t *pgd;
 	unsigned long next;
 
-	if (details && !details->check_mapping && !details->nonlinear_vma)
+	if (details && !details->check_mapping && !details->nonlinear_vma
+			&& !details->madv_free)
 		details = NULL;
 
 	BUG_ON(addr >= end);
diff -puN mm/page_alloc.c~lazy-freeing-of-memory-through-madv_free mm/page_alloc.c
--- a/mm/page_alloc.c~lazy-freeing-of-memory-through-madv_free
+++ a/mm/page_alloc.c
@@ -206,6 +206,7 @@ static void bad_page(struct page *page)
 			1 << PG_slab    |
 			1 << PG_swapcache |
 			1 << PG_writeback |
+			1 << PG_lazyfree |
 			1 << PG_buddy );
 	set_page_count(page, 0);
 	reset_page_mapcount(page);
@@ -452,6 +453,8 @@ static inline int free_pages_check(struc
 		bad_page(page);
 	if (PageDirty(page))
 		__ClearPageDirty(page);
+	if (PageLazyFree(page))
+		__ClearPageLazyFree(page);
 	/*
 	 * For now, we report if PG_reserved was found set, but do not
 	 * clear it, and do not free the page.  But we shall soon need
@@ -598,6 +601,7 @@ static int prep_new_page(struct page *pa
 			1 << PG_swapcache |
 			1 << PG_writeback |
 			1 << PG_reserved |
+			1 << PG_lazyfree |
 			1 << PG_buddy ))))
 		bad_page(page);
 
diff -puN mm/rmap.c~lazy-freeing-of-memory-through-madv_free mm/rmap.c
--- a/mm/rmap.c~lazy-freeing-of-memory-through-madv_free
+++ a/mm/rmap.c
@@ -714,7 +714,17 @@ static int try_to_unmap_one(struct page 
 	/* Update high watermark before we lower rss */
 	update_hiwater_rss(mm);
 
-	if (PageAnon(page)) {
+	/* MADV_FREE is used to lazily free memory from userspace. */
+	if (PageLazyFree(page) && !migration) {
+		if (unlikely(pte_dirty(pteval))) {
+			/* There is new data in the page.  Reinstate it. */
+			set_pte_at(mm, address, pte, pteval);
+			ret = SWAP_FAIL;
+			goto out_unmap;
+		}
+		/* Throw the page away. */
+		dec_mm_counter(mm, anon_rss);
+	} else if (PageAnon(page)) {
 		swp_entry_t entry = { .val = page_private(page) };
 
 		if (PageSwapCache(page)) {
diff -puN mm/swap.c~lazy-freeing-of-memory-through-madv_free mm/swap.c
--- a/mm/swap.c~lazy-freeing-of-memory-through-madv_free
+++ a/mm/swap.c
@@ -151,6 +151,20 @@ void fastcall activate_page(struct page 
 	spin_unlock_irq(&zone->lru_lock);
 }
 
+void fastcall deactivate_tail_page(struct page *page)
+{
+	struct zone *zone = page_zone(page);
+
+	spin_lock_irq(&zone->lru_lock);
+	if (PageLRU(page) && PageActive(page)) {
+		del_page_from_active_list(zone, page);
+		ClearPageActive(page);
+		add_page_to_inactive_list_tail(zone, page);
+		__count_vm_event(PGDEACTIVATE);
+	}
+	spin_unlock_irq(&zone->lru_lock);
+}
+
 /*
  * Mark a page as having seen activity.
  *
diff -puN mm/vmscan.c~lazy-freeing-of-memory-through-madv_free mm/vmscan.c
--- a/mm/vmscan.c~lazy-freeing-of-memory-through-madv_free
+++ a/mm/vmscan.c
@@ -469,6 +469,24 @@ static unsigned long shrink_page_list(st
 
 		sc->nr_scanned++;
 
+		/*
+		 * MADV_DONTNEED pages get reclaimed lazily, unless the
+		 * process reuses them before we get to them.
+		 */
+		if (PageLazyFree(page)) {
+			switch (try_to_unmap(page, 0)) {
+			case SWAP_FAIL:
+				ClearPageLazyFree(page);
+				goto activate_locked;
+			case SWAP_AGAIN:
+				ClearPageLazyFree(page);
+				goto keep_locked;
+			case SWAP_SUCCESS:
+				ClearPageLazyFree(page);
+				goto free_it;
+			}
+		}
+
 		if (!sc->may_swap && page_mapped(page))
 			goto keep_locked;
 
_

Patches currently in -mm which might be from riel@redhat.com are

vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
lazy-freeing-of-memory-through-madv_free.patch
restore-madv_dontneed-to-its-original-linux-behaviour.patch
