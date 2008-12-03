From: akpm@linux-foundation.org
Subject: + badpage-keep-any-bad-page-out-of-circulation.patch added to -mm tree
Date: Tue, 02 Dec 2008 16:57:11 -0800
Message-ID: <200812030057.mB30vBAg024390@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39046 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751677AbYLCA7b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 19:59:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, cl@linux-foundation.org, mel@csn.ul.ie, nickpiggin@yahoo.com.au, riel@redhat.com


The patch titled
     badpage: keep any bad page out of circulation
has been added to the -mm tree.  Its filename is
     badpage-keep-any-bad-page-out-of-circulation.patch

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
Subject: badpage: keep any bad page out of circulation
From: Hugh Dickins <hugh@veritas.com>

Until now the bad_page() checkers have special-cased PageReserved, keeping
those pages out of circulation thereafter.  Now extend the special case to
all: we want to keep ANY page with bad state out of circulation - the
"free" page may well be in use by something.

Leave the bad state of those pages untouched, for examination by
debuggers; except for PageBuddy - leaving that set would risk bringing the
page back.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   52 +++++++++++++++++++++-------------------------
 1 file changed, 24 insertions(+), 28 deletions(-)

diff -puN mm/page_alloc.c~badpage-keep-any-bad-page-out-of-circulation mm/page_alloc.c
--- a/mm/page_alloc.c~badpage-keep-any-bad-page-out-of-circulation
+++ a/mm/page_alloc.c
@@ -231,9 +231,9 @@ static void bad_page(struct page *page)
 	printk(KERN_EMERG "Trying to fix it up, but a reboot is needed\n"
 		KERN_EMERG "Backtrace:\n");
 	dump_stack();
-	set_page_count(page, 0);
-	reset_page_mapcount(page);
-	page->mapping = NULL;
+
+	/* Leave bad fields for debug, except PageBuddy could make trouble */
+	__ClearPageBuddy(page);
 	add_taint(TAINT_BAD_PAGE);
 }
 
@@ -290,25 +290,31 @@ void prep_compound_gigantic_page(struct 
 }
 #endif
 
-static void destroy_compound_page(struct page *page, unsigned long order)
+static int destroy_compound_page(struct page *page, unsigned long order)
 {
 	int i;
 	int nr_pages = 1 << order;
+	int bad = 0;
 
-	if (unlikely(compound_order(page) != order))
+	if (unlikely(compound_order(page) != order) ||
+	    unlikely(!PageHead(page))) {
 		bad_page(page);
+		bad++;
+	}
 
-	if (unlikely(!PageHead(page)))
-			bad_page(page);
 	__ClearPageHead(page);
+
 	for (i = 1; i < nr_pages; i++) {
 		struct page *p = page + i;
 
-		if (unlikely(!PageTail(p) |
-				(p->first_page != page)))
+		if (unlikely(!PageTail(p) | (p->first_page != page))) {
 			bad_page(page);
+			bad++;
+		}
 		__ClearPageTail(p);
 	}
+
+	return bad;
 }
 
 static inline void prep_zero_page(struct page *page, int order, gfp_t gfp_flags)
@@ -428,7 +434,8 @@ static inline void __free_one_page(struc
 	int migratetype = get_pageblock_migratetype(page);
 
 	if (unlikely(PageCompound(page)))
-		destroy_compound_page(page, order);
+		if (unlikely(destroy_compound_page(page, order)))
+			return;
 
 	page_idx = page_to_pfn(page) & ((1 << MAX_ORDER) - 1);
 
@@ -465,15 +472,10 @@ static inline int free_pages_check(struc
 	if (unlikely(page_mapcount(page) |
 		(page->mapping != NULL)  |
 		(page_count(page) != 0)  |
-		(page->flags & PAGE_FLAGS_CHECK_AT_FREE)))
+		(page->flags & PAGE_FLAGS_CHECK_AT_FREE))) {
 		bad_page(page);
-	/*
-	 * For now, we report if PG_reserved was found set, but do not
-	 * clear it, and do not free the page.  But we shall soon need
-	 * to do more, for when the ZERO_PAGE count wraps negative.
-	 */
-	if (PageReserved(page))
 		return 1;
+	}
 	if (page->flags & PAGE_FLAGS_CHECK_AT_PREP)
 		page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
 	return 0;
@@ -521,11 +523,11 @@ static void __free_pages_ok(struct page 
 {
 	unsigned long flags;
 	int i;
-	int reserved = 0;
+	int bad = 0;
 
 	for (i = 0 ; i < (1 << order) ; ++i)
-		reserved += free_pages_check(page + i);
-	if (reserved)
+		bad += free_pages_check(page + i);
+	if (bad)
 		return;
 
 	if (!PageHighMem(page)) {
@@ -610,17 +612,11 @@ static int prep_new_page(struct page *pa
 	if (unlikely(page_mapcount(page) |
 		(page->mapping != NULL)  |
 		(page_count(page) != 0)  |
-		(page->flags & PAGE_FLAGS_CHECK_AT_PREP)))
+		(page->flags & PAGE_FLAGS_CHECK_AT_PREP))) {
 		bad_page(page);
-
-	/*
-	 * For now, we report if PG_reserved was found set, but do not
-	 * clear it, and do not allocate the page: as a safety net.
-	 */
-	if (PageReserved(page))
 		return 1;
+	}
 
-	page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
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

