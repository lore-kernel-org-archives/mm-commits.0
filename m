From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-support-madvisemadv_free.patch removed from
 -mm tree
Date: Mon, 02 Nov 2015 14:53:35 -0800
Message-ID: <5637e96f.m/GZmwrxZ3Z4jK90%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56010 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbbKBWxg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Nov 2015 17:53:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, chris@zankel.net, deller@gmx.de, fengguang.wu@intel.com, ink@jurassic.park.msu.ru, jejb@parisc-linux.org, kirill.shutemov@linux.intel.com, mhocko@suse.cz, mtk.manpages@gmail.com, ralf@linux-mips.org, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: support madvise(MADV_FREE)
has been removed from the -mm tree.  Its filename was
     mm-support-madvisemadv_free.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: support madvise(MADV_FREE)

Linux doesn't have an ability to free pages lazy while other OS already
have been supported that named by madvise(MADV_FREE).

The gain is clear that kernel can discard freed pages rather than swapping
out or OOM if memory pressure happens.

Without memory pressure, freed pages would be reused by userspace without
another additional overhead(ex, page fault + allocation + zeroing).

Jason Evans said:

: Facebook has been using MAP_UNINITIALIZED
: (https://lkml.org/lkml/2012/1/18/308) in some of its applications for
: several years, but there are operational costs to maintaining this
: out-of-tree in our kernel and in jemalloc, and we are anxious to retire it
: in favor of MADV_FREE.  When we first enabled MAP_UNINITIALIZED it
: increased throughput for much of our workload by ~5%, and although the
: benefit has decreased using newer hardware and kernels, there is still
: enough benefit that we cannot reasonably retire it without a replacement.
: 
: Aside from Facebook operations, there are numerous broadly used
: applications that would benefit from MADV_FREE.  The ones that immediately
: come to mind are redis, varnish, and MariaDB.  I don't have much insight
: into Android internals and development process, but I would hope to see
: MADV_FREE support eventually end up there as well to benefit applications
: linked with the integrated jemalloc.
: 
: jemalloc will use MADV_FREE once it becomes available in the Linux kernel.
: In fact, jemalloc already uses MADV_FREE or equivalent everywhere it's
: available: *BSD, OS X, Windows, and Solaris -- every platform except Linux
: (and AIX, but I'm not sure it even compiles on AIX).  The lack of
: MADV_FREE on Linux forced me down a long series of increasingly
: sophisticated heuristics for madvise() volume reduction, and even so this
: remains a common performance issue for people using jemalloc on Linux. 
: Please integrate MADV_FREE; many people will benefit substantially.

How it works:

When madvise syscall is called, VM clears dirty bit of ptes of the range. 
If memory pressure happens, VM checks dirty bit of page table and if it
found still "clean", it means it's a "lazyfree pages" so VM could discard
the page instead of swapping out.  Once there was store operation for the
page before VM peek a page to reclaim, dirty bit is set so VM can swap out
the page instead of discarding.

Firstly, heavy users would be general allocators(ex, jemalloc, tcmalloc
and hope glibc supports it) and jemalloc/tcmalloc already have supported
the feature for other OS(ex, FreeBSD)

barrios@blaptop:~/benchmark/ebizzy$ lscpu
Architecture:          x86_64
CPU op-mode(s):        32-bit, 64-bit
Byte Order:            Little Endian
CPU(s):                12
On-line CPU(s) list:   0-11
Thread(s) per core:    1
Core(s) per socket:    1
Socket(s):             12
NUMA node(s):          1
Vendor ID:             GenuineIntel
CPU family:            6
Model:                 2
Stepping:              3
CPU MHz:               3200.185
BogoMIPS:              6400.53
Virtualization:        VT-x
Hypervisor vendor:     KVM
Virtualization type:   full
L1d cache:             32K
L1i cache:             32K
L2 cache:              4096K
NUMA node0 CPU(s):     0-11
ebizzy benchmark(./ebizzy -S 10 -n 512)

Higher avg is better.

 vanilla-jemalloc		MADV_free-jemalloc

1 thread
records: 10			    records: 10
avg:	2961.90			    avg:   12069.70
std:	  71.96(2.43%)		    std:     186.68(1.55%)
max:	3070.00			    max:   12385.00
min:	2796.00			    min:   11746.00

2 thread
records: 10			    records: 10
avg:	5020.00			    avg:   17827.00
std:	 264.87(5.28%)		    std:     358.52(2.01%)
max:	5244.00			    max:   18760.00
min:	4251.00			    min:   17382.00

4 thread
records: 10			    records: 10
avg:	8988.80			    avg:   27930.80
std:	1175.33(13.08%)		    std:    3317.33(11.88%)
max:	9508.00			    max:   30879.00
min:	5477.00			    min:   21024.00

8 thread
records: 10			    records: 10
avg:   13036.50			    avg:   33739.40
std:	 170.67(1.31%)		    std:    5146.22(15.25%)
max:   13371.00			    max:   40572.00
min:   12785.00			    min:   24088.00

16 thread
records: 10			    records: 10
avg:   11092.40			    avg:   31424.20
std:	 710.60(6.41%)		    std:    3763.89(11.98%)
max:   12446.00			    max:   36635.00
min:	9949.00			    min:   25669.00

32 thread
records: 10			    records: 10
avg:   11067.00			    avg:   34495.80
std:	 971.06(8.77%)		    std:    2721.36(7.89%)
max:   12010.00			    max:   38598.00
min:	9002.00			    min:   30636.00

In summary, MADV_FREE is about much faster than MADV_DONTNEED.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
From: Minchan Kim <minchan@kernel.org>
Subject: mm: define MADV_FREE for some arches

Most architectures use asm-generic, but alpha, mips, parisc, xtensa
need their own definitions.

This patch defines MADV_FREE for them so it should fix build break
for their architectures.

Maybe, I should split and feed piecies to arch maintainers but
included here for mmotm convenience.

[kirill.shutemov@linux.intel.com: use vma_is_anonymous() to check for anon VMA]
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/uapi/asm/mman.h     |    1 
 arch/mips/include/uapi/asm/mman.h      |    1 
 arch/parisc/include/uapi/asm/mman.h    |    1 
 arch/xtensa/include/uapi/asm/mman.h    |    1 
 include/linux/rmap.h                   |    9 +
 include/linux/vm_event_item.h          |    1 
 include/uapi/asm-generic/mman-common.h |    1 
 mm/madvise.c                           |  137 +++++++++++++++++++++++
 mm/rmap.c                              |   39 ++++++
 mm/vmscan.c                            |   41 +++++-
 mm/vmstat.c                            |    1 
 11 files changed, 221 insertions(+), 12 deletions(-)

diff -puN include/linux/rmap.h~mm-support-madvisemadv_free include/linux/rmap.h
--- a/include/linux/rmap.h~mm-support-madvisemadv_free
+++ a/include/linux/rmap.h
@@ -85,6 +85,7 @@ enum ttu_flags {
 	TTU_UNMAP = 1,			/* unmap mode */
 	TTU_MIGRATION = 2,		/* migration mode */
 	TTU_MUNLOCK = 4,		/* munlock mode */
+	TTU_FREE = 8,			/* free mode */
 
 	TTU_IGNORE_MLOCK = (1 << 8),	/* ignore mlock */
 	TTU_IGNORE_ACCESS = (1 << 9),	/* don't age */
@@ -192,7 +193,8 @@ static inline void page_dup_rmap(struct
  * Called from mm/vmscan.c to handle paging out
  */
 int page_referenced(struct page *, int is_locked,
-			struct mem_cgroup *memcg, unsigned long *vm_flags);
+			struct mem_cgroup *memcg, unsigned long *vm_flags,
+			int *is_pte_dirty);
 
 #define TTU_ACTION(x) ((x) & TTU_ACTION_MASK)
 
@@ -269,9 +271,12 @@ int rmap_walk(struct page *page, struct
 
 static inline int page_referenced(struct page *page, int is_locked,
 				  struct mem_cgroup *memcg,
-				  unsigned long *vm_flags)
+				  unsigned long *vm_flags,
+				  int *is_pte_dirty)
 {
 	*vm_flags = 0;
+	if (is_pte_dirty)
+		*is_pte_dirty = 0;
 	return 0;
 }
 
diff -puN include/linux/vm_event_item.h~mm-support-madvisemadv_free include/linux/vm_event_item.h
--- a/include/linux/vm_event_item.h~mm-support-madvisemadv_free
+++ a/include/linux/vm_event_item.h
@@ -25,6 +25,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		FOR_ALL_ZONES(PGALLOC),
 		PGFREE, PGACTIVATE, PGDEACTIVATE,
 		PGFAULT, PGMAJFAULT,
+		PGLAZYFREED,
 		FOR_ALL_ZONES(PGREFILL),
 		FOR_ALL_ZONES(PGSTEAL_KSWAPD),
 		FOR_ALL_ZONES(PGSTEAL_DIRECT),
diff -puN include/uapi/asm-generic/mman-common.h~mm-support-madvisemadv_free include/uapi/asm-generic/mman-common.h
--- a/include/uapi/asm-generic/mman-common.h~mm-support-madvisemadv_free
+++ a/include/uapi/asm-generic/mman-common.h
@@ -39,6 +39,7 @@
 #define MADV_SEQUENTIAL	2		/* expect sequential page references */
 #define MADV_WILLNEED	3		/* will need these pages */
 #define MADV_DONTNEED	4		/* don't need these pages */
+#define MADV_FREE	5		/* free pages only if memory pressure */
 
 /* common parameters: try to keep these consistent across architectures */
 #define MADV_REMOVE	9		/* remove these pages & resources */
diff -puN mm/madvise.c~mm-support-madvisemadv_free mm/madvise.c
--- a/mm/madvise.c~mm-support-madvisemadv_free
+++ a/mm/madvise.c
@@ -20,6 +20,9 @@
 #include <linux/backing-dev.h>
 #include <linux/swap.h>
 #include <linux/swapops.h>
+#include <linux/mmu_notifier.h>
+
+#include <asm/tlb.h>
 
 /*
  * Any behaviour which results in changes to the vma->vm_flags needs to
@@ -32,6 +35,7 @@ static int madvise_need_mmap_write(int b
 	case MADV_REMOVE:
 	case MADV_WILLNEED:
 	case MADV_DONTNEED:
+	case MADV_FREE:
 		return 0;
 	default:
 		/* be safe, default to 1. list exceptions explicitly */
@@ -256,6 +260,130 @@ static long madvise_willneed(struct vm_a
 	return 0;
 }
 
+static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
+				unsigned long end, struct mm_walk *walk)
+
+{
+	struct mmu_gather *tlb = walk->private;
+	struct mm_struct *mm = tlb->mm;
+	struct vm_area_struct *vma = walk->vma;
+	spinlock_t *ptl;
+	pte_t *pte, ptent;
+	struct page *page;
+
+	split_huge_pmd(vma, addr, pmd);
+	if (pmd_trans_unstable(pmd))
+		return 0;
+
+	pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
+	arch_enter_lazy_mmu_mode();
+	for (; addr != end; pte++, addr += PAGE_SIZE) {
+		ptent = *pte;
+
+		if (!pte_present(ptent))
+			continue;
+
+		page = vm_normal_page(vma, addr, ptent);
+		if (!page)
+			continue;
+
+		if (PageSwapCache(page) || PageDirty(page)) {
+			if (!trylock_page(page))
+				continue;
+			/*
+			 * If page is shared with others, we couldn't clear
+			 * PG_dirty of the page.
+			 */
+			if (page_count(page) != 1 + !!PageSwapCache(page)) {
+				unlock_page(page);
+				continue;
+			}
+
+			if (PageSwapCache(page) && !try_to_free_swap(page)) {
+				unlock_page(page);
+				continue;
+			}
+
+			ClearPageDirty(page);
+			unlock_page(page);
+		}
+
+		/*
+		 * Some of architecture(ex, PPC) don't update TLB
+		 * with set_pte_at and tlb_remove_tlb_entry so for
+		 * the portability, remap the pte with old|clean
+		 * after pte clearing.
+		 */
+		ptent = ptep_get_and_clear_full(mm, addr, pte,
+						tlb->fullmm);
+		ptent = pte_mkold(ptent);
+		ptent = pte_mkclean(ptent);
+		set_pte_at(mm, addr, pte, ptent);
+		tlb_remove_tlb_entry(tlb, pte, addr);
+	}
+	arch_leave_lazy_mmu_mode();
+	pte_unmap_unlock(pte - 1, ptl);
+	cond_resched();
+	return 0;
+}
+
+static void madvise_free_page_range(struct mmu_gather *tlb,
+			     struct vm_area_struct *vma,
+			     unsigned long addr, unsigned long end)
+{
+	struct mm_walk free_walk = {
+		.pmd_entry = madvise_free_pte_range,
+		.mm = vma->vm_mm,
+		.private = tlb,
+	};
+
+	BUG_ON(addr >= end);
+	tlb_start_vma(tlb, vma);
+	walk_page_range(addr, end, &free_walk);
+	tlb_end_vma(tlb, vma);
+}
+
+static int madvise_free_single_vma(struct vm_area_struct *vma,
+			unsigned long start_addr, unsigned long end_addr)
+{
+	unsigned long start, end;
+	struct mm_struct *mm = vma->vm_mm;
+	struct mmu_gather tlb;
+
+	if (vma->vm_flags & (VM_LOCKED|VM_HUGETLB|VM_PFNMAP))
+		return -EINVAL;
+
+	/* MADV_FREE works for only anon vma at the moment */
+	if (!vma_is_anonymous(vma))
+		return -EINVAL;
+
+	start = max(vma->vm_start, start_addr);
+	if (start >= vma->vm_end)
+		return -EINVAL;
+	end = min(vma->vm_end, end_addr);
+	if (end <= vma->vm_start)
+		return -EINVAL;
+
+	lru_add_drain();
+	tlb_gather_mmu(&tlb, mm, start, end);
+	update_hiwater_rss(mm);
+
+	mmu_notifier_invalidate_range_start(mm, start, end);
+	madvise_free_page_range(&tlb, vma, start, end);
+	mmu_notifier_invalidate_range_end(mm, start, end);
+	tlb_finish_mmu(&tlb, start, end);
+
+	return 0;
+}
+
+static long madvise_free(struct vm_area_struct *vma,
+			     struct vm_area_struct **prev,
+			     unsigned long start, unsigned long end)
+{
+	*prev = vma;
+	return madvise_free_single_vma(vma, start, end);
+}
+
 /*
  * Application no longer needs these pages.  If the pages are dirty,
  * it's OK to just throw them away.  The app will be more careful about
@@ -379,6 +507,14 @@ madvise_vma(struct vm_area_struct *vma,
 		return madvise_remove(vma, prev, start, end);
 	case MADV_WILLNEED:
 		return madvise_willneed(vma, prev, start, end);
+	case MADV_FREE:
+		/*
+		 * XXX: In this implementation, MADV_FREE works like
+		 * MADV_DONTNEED on swapless system or full swap.
+		 */
+		if (get_nr_swap_pages() > 0)
+			return madvise_free(vma, prev, start, end);
+		/* passthrough */
 	case MADV_DONTNEED:
 		return madvise_dontneed(vma, prev, start, end);
 	default:
@@ -398,6 +534,7 @@ madvise_behavior_valid(int behavior)
 	case MADV_REMOVE:
 	case MADV_WILLNEED:
 	case MADV_DONTNEED:
+	case MADV_FREE:
 #ifdef CONFIG_KSM
 	case MADV_MERGEABLE:
 	case MADV_UNMERGEABLE:
diff -puN mm/rmap.c~mm-support-madvisemadv_free mm/rmap.c
--- a/mm/rmap.c~mm-support-madvisemadv_free
+++ a/mm/rmap.c
@@ -797,6 +797,7 @@ int page_mapped_in_vma(struct page *page
 }
 
 struct page_referenced_arg {
+	int dirtied;
 	int mapcount;
 	int referenced;
 	unsigned long vm_flags;
@@ -811,6 +812,7 @@ static int page_referenced_one(struct pa
 	struct mm_struct *mm = vma->vm_mm;
 	spinlock_t *ptl;
 	int referenced = 0;
+	int dirty = 0;
 	struct page_referenced_arg *pra = arg;
 
 	if (unlikely(PageTransHuge(page))) {
@@ -832,6 +834,11 @@ static int page_referenced_one(struct pa
 
 		if (pmdp_clear_flush_young_notify(vma, address, pmd))
 			referenced++;
+
+		/*
+		 * In this implmentation, MADV_FREE doesn't support THP free
+		 */
+		dirty++;
 		spin_unlock(ptl);
 	} else {
 		pte_t *pte;
@@ -861,6 +868,10 @@ static int page_referenced_one(struct pa
 			if (likely(!(vma->vm_flags & VM_SEQ_READ)))
 				referenced++;
 		}
+
+		if (pte_dirty(*pte))
+			dirty++;
+
 		pte_unmap_unlock(pte, ptl);
 	}
 
@@ -874,6 +885,9 @@ static int page_referenced_one(struct pa
 		pra->vm_flags |= vma->vm_flags;
 	}
 
+	if (dirty)
+		pra->dirtied++;
+
 	pra->mapcount--;
 	if (!pra->mapcount)
 		return SWAP_SUCCESS; /* To break the loop */
@@ -898,6 +912,7 @@ static bool invalid_page_referenced_vma(
  * @is_locked: caller holds lock on the page
  * @memcg: target memory cgroup
  * @vm_flags: collect encountered vma->vm_flags who actually referenced the page
+ * @is_pte_dirty: ptes which have marked dirty bit - used for lazyfree page
  *
  * Quick test_and_clear_referenced for all mappings to a page,
  * returns the number of ptes which referenced the page.
@@ -905,7 +920,8 @@ static bool invalid_page_referenced_vma(
 int page_referenced(struct page *page,
 		    int is_locked,
 		    struct mem_cgroup *memcg,
-		    unsigned long *vm_flags)
+		    unsigned long *vm_flags,
+		    int *is_pte_dirty)
 {
 	int ret;
 	int we_locked = 0;
@@ -920,6 +936,9 @@ int page_referenced(struct page *page,
 	};
 
 	*vm_flags = 0;
+	if (is_pte_dirty)
+		*is_pte_dirty = 0;
+
 	if (!page_mapped(page))
 		return 0;
 
@@ -947,6 +966,9 @@ int page_referenced(struct page *page,
 	if (we_locked)
 		unlock_page(page);
 
+	if (is_pte_dirty)
+		*is_pte_dirty = pra.dirtied;
+
 	return pra.referenced;
 }
 
@@ -1446,6 +1468,20 @@ static int try_to_unmap_one(struct page
 	} else if (PageAnon(page)) {
 		swp_entry_t entry = { .val = page_private(page) };
 		pte_t swp_pte;
+
+		if (flags & TTU_FREE) {
+			VM_BUG_ON_PAGE(PageSwapCache(page), page);
+			if (!PageDirty(page)) {
+				/* It's a freeable page by MADV_FREE */
+				dec_mm_counter(mm, MM_ANONPAGES);
+				goto discard;
+			} else {
+				set_pte_at(mm, address, pte, pteval);
+				ret = SWAP_FAIL;
+				goto out_unmap;
+			}
+		}
+
 		/*
 		 * Store the swap location in the pte.
 		 * See handle_pte_fault() ...
@@ -1471,6 +1507,7 @@ static int try_to_unmap_one(struct page
 	} else
 		dec_mm_counter(mm, MM_FILEPAGES);
 
+discard:
 	page_remove_rmap(page, false);
 	page_cache_release(page);
 
diff -puN mm/vmscan.c~mm-support-madvisemadv_free mm/vmscan.c
--- a/mm/vmscan.c~mm-support-madvisemadv_free
+++ a/mm/vmscan.c
@@ -791,13 +791,17 @@ enum page_references {
 };
 
 static enum page_references page_check_references(struct page *page,
-						  struct scan_control *sc)
+						  struct scan_control *sc,
+						  bool *freeable)
 {
 	int referenced_ptes, referenced_page;
 	unsigned long vm_flags;
+	int pte_dirty;
+
+	VM_BUG_ON_PAGE(!PageLocked(page), page);
 
 	referenced_ptes = page_referenced(page, 1, sc->target_mem_cgroup,
-					  &vm_flags);
+					  &vm_flags, &pte_dirty);
 	referenced_page = TestClearPageReferenced(page);
 
 	/*
@@ -838,6 +842,10 @@ static enum page_references page_check_r
 		return PAGEREF_KEEP;
 	}
 
+	if (PageAnon(page) && !pte_dirty && !PageSwapCache(page) &&
+			!PageDirty(page))
+		*freeable = true;
+
 	/* Reclaim if clean, defer dirty pages to writeback */
 	if (referenced_page && !PageSwapBacked(page))
 		return PAGEREF_RECLAIM_CLEAN;
@@ -906,6 +914,7 @@ static unsigned long shrink_page_list(st
 		int may_enter_fs;
 		enum page_references references = PAGEREF_RECLAIM_CLEAN;
 		bool dirty, writeback;
+		bool freeable = false;
 
 		cond_resched();
 
@@ -1028,7 +1037,8 @@ static unsigned long shrink_page_list(st
 		}
 
 		if (!force_reclaim)
-			references = page_check_references(page, sc);
+			references = page_check_references(page, sc,
+							&freeable);
 
 		switch (references) {
 		case PAGEREF_ACTIVATE:
@@ -1044,7 +1054,7 @@ static unsigned long shrink_page_list(st
 		 * Anonymous process memory has backing store?
 		 * Try to allocate it some swap space here.
 		 */
-		if (PageAnon(page) && !PageSwapCache(page)) {
+		if (PageAnon(page) && !PageSwapCache(page) && !freeable) {
 			if (!(sc->gfp_mask & __GFP_IO))
 				goto keep_locked;
 			if (!add_to_swap(page, page_list))
@@ -1059,9 +1069,9 @@ static unsigned long shrink_page_list(st
 		 * The page is mapped into the page tables of one or more
 		 * processes. Try to unmap it here.
 		 */
-		if (page_mapped(page) && mapping) {
-			switch (try_to_unmap(page,
-					ttu_flags|TTU_BATCH_FLUSH)) {
+		if (page_mapped(page) && (mapping || freeable)) {
+			switch (try_to_unmap(page, freeable ?
+					TTU_FREE : ttu_flags|TTU_BATCH_FLUSH)) {
 			case SWAP_FAIL:
 				goto activate_locked;
 			case SWAP_AGAIN:
@@ -1069,7 +1079,20 @@ static unsigned long shrink_page_list(st
 			case SWAP_MLOCK:
 				goto cull_mlocked;
 			case SWAP_SUCCESS:
-				; /* try to free the page below */
+				/* try to free the page below */
+				if (!freeable)
+					break;
+				/*
+				 * Freeable anon page doesn't have mapping
+				 * due to skipping of swapcache so we free
+				 * page in here rather than __remove_mapping.
+				 */
+				VM_BUG_ON_PAGE(PageSwapCache(page), page);
+				if (!page_freeze_refs(page, 1))
+					goto keep_locked;
+				__ClearPageLocked(page);
+				count_vm_event(PGLAZYFREED);
+				goto free_it;
 			}
 		}
 
@@ -1816,7 +1839,7 @@ static void shrink_active_list(unsigned
 		}
 
 		if (page_referenced(page, 0, sc->target_mem_cgroup,
-				    &vm_flags)) {
+				    &vm_flags, NULL)) {
 			nr_rotated += hpage_nr_pages(page);
 			/*
 			 * Identify referenced, file-backed active pages and
diff -puN mm/vmstat.c~mm-support-madvisemadv_free mm/vmstat.c
--- a/mm/vmstat.c~mm-support-madvisemadv_free
+++ a/mm/vmstat.c
@@ -781,6 +781,7 @@ const char * const vmstat_text[] = {
 
 	"pgfault",
 	"pgmajfault",
+	"pglazyfreed",
 
 	TEXTS_FOR_ZONES("pgrefill")
 	TEXTS_FOR_ZONES("pgsteal_kswapd")
diff -puN arch/alpha/include/uapi/asm/mman.h~mm-support-madvisemadv_free arch/alpha/include/uapi/asm/mman.h
--- a/arch/alpha/include/uapi/asm/mman.h~mm-support-madvisemadv_free
+++ a/arch/alpha/include/uapi/asm/mman.h
@@ -47,6 +47,7 @@
 #define MADV_WILLNEED	3		/* will need these pages */
 #define	MADV_SPACEAVAIL	5		/* ensure resources are available */
 #define MADV_DONTNEED	6		/* don't need these pages */
+#define MADV_FREE	7		/* free pages only if memory pressure */
 
 /* common/generic parameters */
 #define MADV_REMOVE	9		/* remove these pages & resources */
diff -puN arch/mips/include/uapi/asm/mman.h~mm-support-madvisemadv_free arch/mips/include/uapi/asm/mman.h
--- a/arch/mips/include/uapi/asm/mman.h~mm-support-madvisemadv_free
+++ a/arch/mips/include/uapi/asm/mman.h
@@ -73,6 +73,7 @@
 #define MADV_SEQUENTIAL 2		/* expect sequential page references */
 #define MADV_WILLNEED	3		/* will need these pages */
 #define MADV_DONTNEED	4		/* don't need these pages */
+#define MADV_FREE	5		/* free pages only if memory pressure */
 
 /* common parameters: try to keep these consistent across architectures */
 #define MADV_REMOVE	9		/* remove these pages & resources */
diff -puN arch/parisc/include/uapi/asm/mman.h~mm-support-madvisemadv_free arch/parisc/include/uapi/asm/mman.h
--- a/arch/parisc/include/uapi/asm/mman.h~mm-support-madvisemadv_free
+++ a/arch/parisc/include/uapi/asm/mman.h
@@ -43,6 +43,7 @@
 #define MADV_SPACEAVAIL 5               /* insure that resources are reserved */
 #define MADV_VPS_PURGE  6               /* Purge pages from VM page cache */
 #define MADV_VPS_INHERIT 7              /* Inherit parents page size */
+#define MADV_FREE	8		/* free pages only if memory pressure */
 
 /* common/generic parameters */
 #define MADV_REMOVE	9		/* remove these pages & resources */
diff -puN arch/xtensa/include/uapi/asm/mman.h~mm-support-madvisemadv_free arch/xtensa/include/uapi/asm/mman.h
--- a/arch/xtensa/include/uapi/asm/mman.h~mm-support-madvisemadv_free
+++ a/arch/xtensa/include/uapi/asm/mman.h
@@ -86,6 +86,7 @@
 #define MADV_SEQUENTIAL	2		/* expect sequential page references */
 #define MADV_WILLNEED	3		/* will need these pages */
 #define MADV_DONTNEED	4		/* don't need these pages */
+#define MADV_FREE	5		/* free pages only if memory pressure */
 
 /* common parameters: try to keep these consistent across architectures */
 #define MADV_REMOVE	9		/* remove these pages & resources */
_

Patches currently in -mm which might be from minchan@kernel.org are

x86-add-pmd_-for-thp.patch
sparc-add-pmd_-for-thp.patch
powerpc-add-pmd_-for-thp.patch
arm-add-pmd_mkclean-for-thp.patch
arm64-add-pmd_-for-thp.patch
mm-mark-stable-page-dirty-in-ksm.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-free-swp_entry-in-madvise_free.patch
mm-move-lazy-free-pages-to-inactive-list.patch

