From: akpm@linux-foundation.org
Subject: + badpage-simplify-page_alloc-flag-checkclear.patch added to -mm tree
Date: Tue, 02 Dec 2008 16:57:08 -0800
Message-ID: <200812030057.mB30v8DU024349@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39927 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755469AbYLCA7n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 19:59:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, cl@linux-foundation.org, mel@csn.ul.ie, nickpiggin@yahoo.com.au, riel@redhat.com


The patch titled
     badpage: simplify page_alloc flag check+clear
has been added to the -mm tree.  Its filename is
     badpage-simplify-page_alloc-flag-checkclear.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: badpage: simplify page_alloc flag check+clear
From: Hugh Dickins <hugh@veritas.com>

Simplify the PAGE_FLAGS checking and clearing when freeing and allocating
a page: check the same flags as before when freeing, clear ALL the flags
(unless PageReserved) when freeing, check ALL flags off when allocating.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   25 ++++++++-----------------
 mm/page_alloc.c            |   19 ++++++-------------
 2 files changed, 14 insertions(+), 30 deletions(-)

diff -puN include/linux/page-flags.h~badpage-simplify-page_alloc-flag-checkclear include/linux/page-flags.h
--- a/include/linux/page-flags.h~badpage-simplify-page_alloc-flag-checkclear
+++ a/include/linux/page-flags.h
@@ -375,31 +375,22 @@ static inline void __ClearPageTail(struc
 #define __PG_MLOCKED		0
 #endif
 
-#define PAGE_FLAGS	(1 << PG_lru   | 1 << PG_private   | 1 << PG_locked | \
-			 1 << PG_buddy | 1 << PG_writeback | \
-			 1 << PG_slab  | 1 << PG_swapcache | 1 << PG_active | \
-			 __PG_UNEVICTABLE | __PG_MLOCKED)
-
-/*
- * Flags checked in bad_page().  Pages on the free list should not have
- * these flags set.  It they are, there is a problem.
- */
-#define PAGE_FLAGS_CLEAR_WHEN_BAD (PAGE_FLAGS | \
-		1 << PG_reclaim | 1 << PG_dirty | 1 << PG_swapbacked)
-
 /*
  * Flags checked when a page is freed.  Pages being freed should not have
  * these flags set.  It they are, there is a problem.
  */
-#define PAGE_FLAGS_CHECK_AT_FREE (PAGE_FLAGS | 1 << PG_reserved)
+#define PAGE_FLAGS_CHECK_AT_FREE \
+	(1 << PG_lru   | 1 << PG_private   | 1 << PG_locked | \
+	 1 << PG_buddy | 1 << PG_writeback | 1 << PG_reserved | \
+	 1 << PG_slab  | 1 << PG_swapcache | 1 << PG_active | \
+	 __PG_UNEVICTABLE | __PG_MLOCKED)
 
 /*
  * Flags checked when a page is prepped for return by the page allocator.
- * Pages being prepped should not have these flags set.  It they are, there
- * is a problem.
+ * Pages being prepped should not have any flags set.  It they are set,
+ * there has been a kernel bug or struct page corruption.
  */
-#define PAGE_FLAGS_CHECK_AT_PREP (PAGE_FLAGS | \
-		1 << PG_reserved | 1 << PG_dirty | 1 << PG_swapbacked)
+#define PAGE_FLAGS_CHECK_AT_PREP	((1 << NR_PAGEFLAGS) - 1)
 
 #endif /* !__GENERATING_BOUNDS_H */
 #endif	/* PAGE_FLAGS_H */
diff -puN mm/page_alloc.c~badpage-simplify-page_alloc-flag-checkclear mm/page_alloc.c
--- a/mm/page_alloc.c~badpage-simplify-page_alloc-flag-checkclear
+++ a/mm/page_alloc.c
@@ -231,7 +231,6 @@ static void bad_page(struct page *page)
 	printk(KERN_EMERG "Trying to fix it up, but a reboot is needed\n"
 		KERN_EMERG "Backtrace:\n");
 	dump_stack();
-	page->flags &= ~PAGE_FLAGS_CLEAR_WHEN_BAD;
 	set_page_count(page, 0);
 	reset_page_mapcount(page);
 	page->mapping = NULL;
@@ -468,16 +467,16 @@ static inline int free_pages_check(struc
 		(page_count(page) != 0)  |
 		(page->flags & PAGE_FLAGS_CHECK_AT_FREE)))
 		bad_page(page);
-	if (PageDirty(page))
-		__ClearPageDirty(page);
-	if (PageSwapBacked(page))
-		__ClearPageSwapBacked(page);
 	/*
 	 * For now, we report if PG_reserved was found set, but do not
 	 * clear it, and do not free the page.  But we shall soon need
 	 * to do more, for when the ZERO_PAGE count wraps negative.
 	 */
-	return PageReserved(page);
+	if (PageReserved(page))
+		return 1;
+	if (page->flags & PAGE_FLAGS_CHECK_AT_PREP)
+		page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
+	return 0;
 }
 
 /*
@@ -621,13 +620,7 @@ static int prep_new_page(struct page *pa
 	if (PageReserved(page))
 		return 1;
 
-	page->flags &= ~(1 << PG_uptodate | 1 << PG_error | 1 << PG_reclaim |
-			1 << PG_referenced | 1 << PG_arch_1 |
-			1 << PG_owner_priv_1 | 1 << PG_mappedtodisk
-#ifdef CONFIG_UNEVICTABLE_LRU
-			| 1 << PG_mlocked
-#endif
-			);
+	page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
 	set_page_private(page, 0);
 	set_page_refcounted(page);
 
_

Patches currently in -mm which might be from hugh@veritas.com are

ksym_symbol_len-fixes.patch
linux-next.patch
mm-dont-mark_page_accessed-in-shmem_fault.patch
mm-apply_to_range-call-pte-function-with-lazy-updates.patch
mm-remove-cgroup_mm_owner_callbacks.patch
mm-remove-aop_writepage_activate.patch
mm-remove-gfp_highuser_pagecache.patch
mm-add-setclearpageswapcache-stubs.patch
mm-replace-some-bug_ons-by-vm_bug_ons.patch
mm-add_active_or_unevictable-into-rmap.patch
mm-make-page_lock_anon_vma-static.patch
mm-further-cleanup-page_add_new_anon_rmap.patch
mm-gup-persist-for-write-permission.patch
mm-wp-lock-page-before-deciding-cow.patch
mm-reuse_swap_page-replaces-can_share_swap_page.patch
mm-try_to_free_swap-replaces-remove_exclusive_swap_page.patch
mm-try_to_unuse-check-removing-right-swap.patch
mm-remove-try_to_munlock-from-vmscan.patch
mm-remove-gfp_mask-from-add_to_swap.patch
mm-add-add_to_swap-stub.patch
mm-optimize-get_scan_ratio-for-no-swap.patch
swapfile-swapon-needs-larger-size-type.patch
swapfile-remove-swp_active-mask.patch
swapfile-remove-surplus-whitespace.patch
swapfile-remove-v0-swap-space-message.patch
swapfile-rearrange-scan-and-swap_info.patch
swapfile-swapon-use-discard-trim.patch
swapfile-swap-allocation-use-discard.patch
swapfile-swapon-randomize-if-nonrot.patch
swapfile-swap-allocation-cycle-if-nonrot.patch
swapfile-change-discard-pgoff_t-to-sector_t.patch
swapfile-change-discard-pgoff_t-to-sector_t-fix.patch
swapfile-let-others-seed-random.patch
badpage-simplify-page_alloc-flag-checkclear.patch
badpage-keep-any-bad-page-out-of-circulation.patch
badpage-replace-page_remove_rmap-eeek-and-bug.patch
badpage-vm_normal_page-use-print_bad_pte.patch
badpage-zap-print_bad_pte-on-swap-and-file.patch
badpage-remove-vma-from-page_remove_rmap.patch
badpage-ratelimit-print_bad_pte-and-bad_page.patch
badpage-kern_alert-bug-instead-of-kern_emerg.patch
memcg-handle-swap-caches.patch
memcg-handle-swap-caches-build-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
memcg-memswap-controller-core-swapcache-fixes.patch
prio_tree-debugging-patch.patch

