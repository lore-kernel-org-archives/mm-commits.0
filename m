From: akpm@linux-foundation.org
Subject: [merged] mm-clean-up-page_remove_rmap.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:37:58 -0700
Message-ID: <200909222037.n8MKbwCn000478@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54507 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752891AbZIVUmj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:42:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, fengguang.wu@intel.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: clean up page_remove_rmap()
has been removed from the -mm tree.  Its filename was
     mm-clean-up-page_remove_rmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: clean up page_remove_rmap()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

page_remove_rmap() has multiple PageAnon() tests and it has deep nesting.
Clean this up.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   57 +++++++++++++++++++++++++++-------------------------
 1 file changed, 30 insertions(+), 27 deletions(-)

diff -puN mm/rmap.c~mm-clean-up-page_remove_rmap mm/rmap.c
--- a/mm/rmap.c~mm-clean-up-page_remove_rmap
+++ a/mm/rmap.c
@@ -739,34 +739,37 @@ void page_dup_rmap(struct page *page, st
  */
 void page_remove_rmap(struct page *page)
 {
-	if (atomic_add_negative(-1, &page->_mapcount)) {
-		/*
-		 * Now that the last pte has gone, s390 must transfer dirty
-		 * flag from storage key to struct page.  We can usually skip
-		 * this if the page is anon, so about to be freed; but perhaps
-		 * not if it's in swapcache - there might be another pte slot
-		 * containing the swap entry, but page not yet written to swap.
-		 */
-		if ((!PageAnon(page) || PageSwapCache(page)) &&
-		    page_test_dirty(page)) {
-			page_clear_dirty(page);
-			set_page_dirty(page);
-		}
-		if (PageAnon(page))
-			mem_cgroup_uncharge_page(page);
-		__dec_zone_page_state(page,
-			PageAnon(page) ? NR_ANON_PAGES : NR_FILE_MAPPED);
-		mem_cgroup_update_mapped_file_stat(page, -1);
-		/*
-		 * It would be tidy to reset the PageAnon mapping here,
-		 * but that might overwrite a racing page_add_anon_rmap
-		 * which increments mapcount after us but sets mapping
-		 * before us: so leave the reset to free_hot_cold_page,
-		 * and remember that it's only reliable while mapped.
-		 * Leaving it set also helps swapoff to reinstate ptes
-		 * faster for those pages still in swapcache.
-		 */
+	/* page still mapped by someone else? */
+	if (!atomic_add_negative(-1, &page->_mapcount))
+		return;
+
+	/*
+	 * Now that the last pte has gone, s390 must transfer dirty
+	 * flag from storage key to struct page.  We can usually skip
+	 * this if the page is anon, so about to be freed; but perhaps
+	 * not if it's in swapcache - there might be another pte slot
+	 * containing the swap entry, but page not yet written to swap.
+	 */
+	if ((!PageAnon(page) || PageSwapCache(page)) && page_test_dirty(page)) {
+		page_clear_dirty(page);
+		set_page_dirty(page);
+	}
+	if (PageAnon(page)) {
+		mem_cgroup_uncharge_page(page);
+		__dec_zone_page_state(page, NR_ANON_PAGES);
+	} else {
+		__dec_zone_page_state(page, NR_FILE_MAPPED);
 	}
+	mem_cgroup_update_mapped_file_stat(page, -1);
+	/*
+	 * It would be tidy to reset the PageAnon mapping here,
+	 * but that might overwrite a racing page_add_anon_rmap
+	 * which increments mapcount after us but sets mapping
+	 * before us: so leave the reset to free_hot_cold_page,
+	 * and remember that it's only reliable while mapped.
+	 * Leaving it set also helps swapoff to reinstate ptes
+	 * faster for those pages still in swapcache.
+	 */
 }
 
 /*
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
linux-next.patch
revert-staging-android-lowmemorykillerc-fix-it-for-oom-move-oom_adj-value-from-task_struct-to-mm_struct.patch
readahead-add-blk_run_backing_dev.patch
oom-move-oom_adj-value-from-task_struct-to-signal_struct-fix.patch
mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch
getrusage-fill-ru_maxrss-value.patch
kcore-use-registerd-physmem-information-ia64-fix.patch
memory-controller-soft-limit-documentation-v9.patch
memory-controller-soft-limit-interface-v9.patch
memory-controller-soft-limit-organize-cgroups-v9.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
memory-controller-soft-limit-refactor-reclaim-flags-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling-fix.patch
memcg-improve-resource-counter-scalability.patch
memcg-improve-resource-counter-scalability-v5.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

