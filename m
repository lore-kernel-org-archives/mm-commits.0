From: akpm@linux-foundation.org
Subject: [merged] mm-thp-remove-compound_lock.patch removed from -mm tree
Date: Tue, 19 Jan 2016 12:02:02 -0800
Message-ID: <569e963a.eVM7aS8at18j93Ts%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42797 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756843AbcASUCD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:02:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, sasha.levin@oracle.com, steve.capper@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, thp: remove compound_lock()
has been removed from the -mm tree.  Its filename was
     mm-thp-remove-compound_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm, thp: remove compound_lock()

We are going to use migration entries to stabilize page counts. It means
we don't need compound_lock() for that.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Tested-by: Sasha Levin <sasha.levin@oracle.com>
Tested-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Steve Capper <steve.capper@linaro.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h         |   35 -----------------------------------
 include/linux/page-flags.h |   12 +-----------
 mm/debug.c                 |    3 ---
 mm/memcontrol.c            |   11 +++--------
 4 files changed, 4 insertions(+), 57 deletions(-)

diff -puN include/linux/mm.h~mm-thp-remove-compound_lock include/linux/mm.h
--- a/include/linux/mm.h~mm-thp-remove-compound_lock
+++ a/include/linux/mm.h
@@ -410,41 +410,6 @@ static inline int is_vmalloc_or_module_a
 
 extern void kvfree(const void *addr);
 
-static inline void compound_lock(struct page *page)
-{
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	VM_BUG_ON_PAGE(PageSlab(page), page);
-	bit_spin_lock(PG_compound_lock, &page->flags);
-#endif
-}
-
-static inline void compound_unlock(struct page *page)
-{
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	VM_BUG_ON_PAGE(PageSlab(page), page);
-	bit_spin_unlock(PG_compound_lock, &page->flags);
-#endif
-}
-
-static inline unsigned long compound_lock_irqsave(struct page *page)
-{
-	unsigned long uninitialized_var(flags);
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	local_irq_save(flags);
-	compound_lock(page);
-#endif
-	return flags;
-}
-
-static inline void compound_unlock_irqrestore(struct page *page,
-					      unsigned long flags)
-{
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	compound_unlock(page);
-	local_irq_restore(flags);
-#endif
-}
-
 /*
  * The atomic page->_mapcount, starts from -1: so that transitions
  * both from it and to it can be tracked, using atomic_inc_and_test
diff -puN include/linux/page-flags.h~mm-thp-remove-compound_lock include/linux/page-flags.h
--- a/include/linux/page-flags.h~mm-thp-remove-compound_lock
+++ a/include/linux/page-flags.h
@@ -101,9 +101,6 @@ enum pageflags {
 #ifdef CONFIG_MEMORY_FAILURE
 	PG_hwpoison,		/* hardware poisoned page. Don't touch */
 #endif
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	PG_compound_lock,
-#endif
 #if defined(CONFIG_IDLE_PAGE_TRACKING) && defined(CONFIG_64BIT)
 	PG_young,
 	PG_idle,
@@ -613,12 +610,6 @@ static inline void ClearPageSlabPfmemall
 #define __PG_MLOCKED		0
 #endif
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-#define __PG_COMPOUND_LOCK		(1 << PG_compound_lock)
-#else
-#define __PG_COMPOUND_LOCK		0
-#endif
-
 /*
  * Flags checked when a page is freed.  Pages being freed should not have
  * these flags set.  It they are, there is a problem.
@@ -628,8 +619,7 @@ static inline void ClearPageSlabPfmemall
 	 1 << PG_private | 1 << PG_private_2 | \
 	 1 << PG_writeback | 1 << PG_reserved | \
 	 1 << PG_slab	 | 1 << PG_swapcache | 1 << PG_active | \
-	 1 << PG_unevictable | __PG_MLOCKED | \
-	 __PG_COMPOUND_LOCK)
+	 1 << PG_unevictable | __PG_MLOCKED)
 
 /*
  * Flags checked when a page is prepped for return by the page allocator.
diff -puN mm/debug.c~mm-thp-remove-compound_lock mm/debug.c
--- a/mm/debug.c~mm-thp-remove-compound_lock
+++ a/mm/debug.c
@@ -40,9 +40,6 @@ static const struct trace_print_flags pa
 #ifdef CONFIG_MEMORY_FAILURE
 	{1UL << PG_hwpoison,		"hwpoison"	},
 #endif
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	{1UL << PG_compound_lock,	"compound_lock"	},
-#endif
 #if defined(CONFIG_IDLE_PAGE_TRACKING) && defined(CONFIG_64BIT)
 	{1UL << PG_young,		"young"		},
 	{1UL << PG_idle,		"idle"		},
diff -puN mm/memcontrol.c~mm-thp-remove-compound_lock mm/memcontrol.c
--- a/mm/memcontrol.c~mm-thp-remove-compound_lock
+++ a/mm/memcontrol.c
@@ -2433,9 +2433,7 @@ void __memcg_kmem_uncharge(struct page *
 
 /*
  * Because tail pages are not marked as "used", set it. We're under
- * zone->lru_lock, 'splitting on pmd' and compound_lock.
- * charge/uncharge will be never happen and move_account() is done under
- * compound_lock(), so we don't have to take care of races.
+ * zone->lru_lock and migration entries setup in all page mappings.
  */
 void mem_cgroup_split_huge_fixup(struct page *head)
 {
@@ -4507,9 +4505,7 @@ static struct page *mc_handle_file_pte(s
  * @from: mem_cgroup which the page is moved from.
  * @to:	mem_cgroup which the page is moved to. @from != @to.
  *
- * The caller must confirm following.
- * - page is not on LRU (isolate_page() is useful.)
- * - compound_lock is held when nr_pages > 1
+ * The caller must make sure the page is not on LRU (isolate_page() is useful.)
  *
  * This function doesn't do "charge" to new cgroup and doesn't do "uncharge"
  * from old cgroup.
@@ -4868,8 +4864,7 @@ static int mem_cgroup_move_charge_pte_ra
 	struct page *page;
 
 	/*
-	 * We don't take compound_lock() here but no race with splitting thp
-	 * happens because:
+	 * No race with splitting thp happens because:
 	 *  - if pmd_trans_huge_lock() returns 1, the relevant thp is not
 	 *    under splitting, which means there's no concurrent thp split,
 	 *  - if another thread runs into split_huge_page() just after we
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

thp-update-documentation.patch
thp-allow-mlocked-thp-again.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting.patch
thp-add-debugfs-handle-to-split-all-huge-pages.patch
thp-increase-split_huge_page-success-rate.patch
thp-fix-split_huge_page-after-mremap-of-thp.patch
memblock-fix-section-mismatch.patch
mm-fix-locking-order-in-mm_take_all_locks.patch
mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

