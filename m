From: akpm@linux-foundation.org
Subject: + memcg-use-new-logic-for-page-stat-accounting-fix-2.patch added to -mm tree
Date: Fri, 02 Mar 2012 14:29:47 -0800
Message-ID: <20120302222947.C757BA02FF@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:64672 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932193Ab2CBW3v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Mar 2012 17:29:51 -0500
Received: by laai8 with SMTP id i8so76295laa.1
        for <mm-commits@vger.kernel.org>; Fri, 02 Mar 2012 14:29:49 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, gthelen@google.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, yinghan@google.com


The patch titled
     Subject: memcg: fix deadlock by avoiding stat lock when anon
has been added to the -mm tree.  Its filename is
     memcg-use-new-logic-for-page-stat-accounting-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: memcg: fix deadlock by avoiding stat lock when anon

Fix deadlock in "memcg: use new logic for page stat accounting".

page_remove_rmap() first calls mem_cgroup_begin_update_page_stat(), which
may take move_lock_mem_cgroup(), unlocked at the end of page_remove_rmap()
by mem_cgroup_end_update_page_stat().

The PageAnon case never needs to mem_cgroup_dec_page_stat(page,
MEMCG_NR_FILE_MAPPED); but it often needs to mem_cgroup_uncharge_page(),
which does lock_page_cgroup(), while holding that move_lock_mem_cgroup(). 
Whereas mem_cgroup_move_account() calls move_lock_mem_cgroup() while
holding lock_page_cgroup().

Since mem_cgroup_begin and end are unnecessary here for PageAnon, simply
avoid the deadlock and wasted calls in that case.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Greg Thelen <gthelen@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ying Han <yinghan@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff -puN mm/rmap.c~memcg-use-new-logic-for-page-stat-accounting-fix-2 mm/rmap.c
--- a/mm/rmap.c~memcg-use-new-logic-for-page-stat-accounting-fix-2
+++ a/mm/rmap.c
@@ -1166,10 +1166,18 @@ void page_add_file_rmap(struct page *pag
  */
 void page_remove_rmap(struct page *page)
 {
+	bool anon = PageAnon(page);
 	bool locked;
 	unsigned long flags;
 
-	mem_cgroup_begin_update_page_stat(page, &locked, &flags);
+	/*
+	 * The anon case has no mem_cgroup page_stat to update; but may
+	 * uncharge_page() below, where the lock ordering can deadlock if
+	 * we hold the lock against page_stat move: so avoid it on anon.
+	 */
+	if (!anon)
+		mem_cgroup_begin_update_page_stat(page, &locked, &flags);
+
 	/* page still mapped by someone else? */
 	if (!atomic_add_negative(-1, &page->_mapcount))
 		goto out;
@@ -1181,7 +1189,7 @@ void page_remove_rmap(struct page *page)
 	 * not if it's in swapcache - there might be another pte slot
 	 * containing the swap entry, but page not yet written to swap.
 	 */
-	if ((!PageAnon(page) || PageSwapCache(page)) &&
+	if ((!anon || PageSwapCache(page)) &&
 	    page_test_and_clear_dirty(page_to_pfn(page), 1))
 		set_page_dirty(page);
 	/*
@@ -1190,7 +1198,7 @@ void page_remove_rmap(struct page *page)
 	 */
 	if (unlikely(PageHuge(page)))
 		goto out;
-	if (PageAnon(page)) {
+	if (anon) {
 		mem_cgroup_uncharge_page(page);
 		if (!PageTransHuge(page))
 			__dec_zone_page_state(page, NR_ANON_PAGES);
@@ -1211,7 +1219,8 @@ void page_remove_rmap(struct page *page)
 	 * faster for those pages still in swapcache.
 	 */
 out:
-	mem_cgroup_end_update_page_stat(page, &locked, &flags);
+	if (!anon)
+		mem_cgroup_end_update_page_stat(page, &locked, &flags);
 }
 
 /*
_
Subject: Subject: memcg: fix deadlock by avoiding stat lock when anon

Patches currently in -mm which might be from hughd@google.com are

linux-next.patch
memcg-fix-deadlock-by-inverting-lrucare-nesting.patch
memcg-fix-gpf-when-cgroup-removal-races-with-last-exit.patch
mm-add-rss-counters-consistency-check.patch
mm-vmscan-fix-misused-nr_reclaimed-in-shrink_mem_cgroup_zone.patch
make-swapin-readahead-skip-over-holes.patch
make-swapin-readahead-skip-over-holes-fix.patch
compact_pgdat-workaround-lockdep-warning-in-kswapd.patch
mm-vmscan-forcibly-scan-highmem-if-there-are-too-many-buffer_heads-pinning-highmem-fix.patch
mm-vmscan-forcibly-scan-highmem-if-there-are-too-many-buffer_heads-pinning-highmem-fix-fix.patch
mm-hugetlb-defer-freeing-pages-when-gathering-surplus-pages.patch
rmap-anon_vma_prepare-reduce-code-duplication-by-calling-anon_vma_chain_link.patch
mm-vmscan-handle-isolated-pages-with-lru-lock-released.patch
mm-hugetlb-bail-out-unmapping-after-serving-reference-page.patch
mm-hugetlb-cleanup-duplicated-code-in-unmapping-vm-range.patch
tmpfs-security-xattr-setting-on-inode-creation.patch
mm-fix-move-migrate_pages-race-on-task-struct.patch
ksm-clean-up-page_trans_compound_anon_split.patch
ksm-cleanup-introduce-ksm_check_mm.patch
ksm-cleanup-introduce-ksm_check_mm-fix.patch
hugetlbfs-drop-taking-inode-i_mutex-lock-from-hugetlbfs_read.patch
memcg-replace-mem_cont-by-mem_res_ctlr.patch
memcg-replace-mem-and-mem_cont-stragglers.patch
memcg-lru_size-instead-of-mem_cgroup_zstat.patch
memcg-enum-lru_list-lru.patch
memcg-remove-redundant-returns.patch
idr-make-idr_get_next-good-for-rcu_read_lock.patch
cgroup-revert-ss_id_lock-to-spinlock.patch
memcg-let-css_get_next-rely-upon-rcu_read_lock.patch
memcg-remove-pcg_cache-page_cgroup-flag.patch
memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes.patch
memcg-remove-pcg_cache-page_cgroup-flag-fix.patch
memcg-use-new-logic-for-page-stat-accounting-fix-2.patch
memcg-remove-pcg_file_mapped-fix-cosmetic-fix.patch
memcg-remove-pcg_file_mapped-fix-42.patch
prio_tree-debugging-patch.patch

