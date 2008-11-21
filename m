From: akpm@linux-foundation.org
Subject: + mm-add-setclearpageswapcache-stubs.patch added to -mm tree
Date: Fri, 21 Nov 2008 12:11:54 -0800
Message-ID: <200811212011.mALKBskF017644@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58083 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752888AbYKUUMD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Nov 2008 15:12:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, cl@linux-foundation.org, mel@csn.ul.ie, nickpiggin@yahoo.com.au


The patch titled
     mm: add Set,ClearPageSwapCache stubs
has been added to the -mm tree.  Its filename is
     mm-add-setclearpageswapcache-stubs.patch

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
Subject: mm: add Set,ClearPageSwapCache stubs
From: Hugh Dickins <hugh@veritas.com>

If we add NOOP stubs for SetPageSwapCache() and ClearPageSwapCache(), then
we can remove the #ifdef CONFIG_SWAPs from mm/migrate.c.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Acked-by: Christoph Lameter <cl@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    1 +
 mm/migrate.c               |    4 ----
 2 files changed, 1 insertion(+), 4 deletions(-)

diff -puN include/linux/page-flags.h~mm-add-setclearpageswapcache-stubs include/linux/page-flags.h
--- a/include/linux/page-flags.h~mm-add-setclearpageswapcache-stubs
+++ a/include/linux/page-flags.h
@@ -230,6 +230,7 @@ PAGEFLAG_FALSE(HighMem)
 PAGEFLAG(SwapCache, swapcache)
 #else
 PAGEFLAG_FALSE(SwapCache)
+	SETPAGEFLAG_NOOP(SwapCache) CLEARPAGEFLAG_NOOP(SwapCache)
 #endif
 
 #ifdef CONFIG_UNEVICTABLE_LRU
diff -puN mm/migrate.c~mm-add-setclearpageswapcache-stubs mm/migrate.c
--- a/mm/migrate.c~mm-add-setclearpageswapcache-stubs
+++ a/mm/migrate.c
@@ -300,12 +300,10 @@ static int migrate_page_move_mapping(str
 	 * Now we know that no one else is looking at the page.
 	 */
 	get_page(newpage);	/* add cache reference */
-#ifdef CONFIG_SWAP
 	if (PageSwapCache(page)) {
 		SetPageSwapCache(newpage);
 		set_page_private(newpage, page_private(page));
 	}
-#endif
 
 	radix_tree_replace_slot(pslot, newpage);
 
@@ -373,9 +371,7 @@ static void migrate_page_copy(struct pag
 
 	mlock_migrate_page(newpage, page);
 
-#ifdef CONFIG_SWAP
 	ClearPageSwapCache(page);
-#endif
 	ClearPagePrivate(page);
 	set_page_private(page, 0);
 	/* page->mapping contains a flag for PageAnon() */
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
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
memcg-handle-swap-caches.patch
memcg-handle-swap-caches-build-fix.patch
memcg-swap-cgroup-for-remembering-usage-fix-2.patch
memcg-swap-cgroup-for-remembering-usage-fix-3.patch
memcg-swap-cgroup-for-remembering-usage-fix-4.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
prio_tree-debugging-patch.patch

