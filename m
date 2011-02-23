From: akpm@linux-foundation.org
Subject: + mm-reclaim-invalidated-page-asap.patch added to -mm tree
Date: Wed, 23 Feb 2011 15:46:52 -0800
Message-ID: <201102232346.p1NNkqiL030731@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54249 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753549Ab1BWXso (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Feb 2011 18:48:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan.kim@gmail.com, aarcange@redhat.com, damentz@liquorix.net, fengguang.wu@intel.com, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, npiggin@kernel.dk, riel@redhat.com


The patch titled
     mm: Reclaim invalidated page ASAP
has been added to the -mm tree.  Its filename is
     mm-reclaim-invalidated-page-asap.patch

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
Subject: mm: Reclaim invalidated page ASAP
From: Minchan Kim <minchan.kim@gmail.com>

invalidate_mapping_pages is very big hint to reclaimer.  It means user
doesn't want to use the page any more.  So in order to prevent working set
page eviction, this patch move the page into tail of inactive list by
PG_reclaim.

Please, remember that pages in inactive list are working set as well as
active list.  If we don't move pages into inactive list's tail, pages near
by tail of inactive list can be evicted although we have a big clue about
useless pages.  It's totally bad.

Now PG_readahead/PG_reclaim is shared.  fe3cba17 added ClearPageReclaim
into clear_page_dirty_for_io for preventing fast reclaiming readahead
marker page.

In this series, PG_reclaim is used by invalidated page, too.  If VM find
the page is invalidated and it's dirty, it sets PG_reclaim to reclaim
asap.  Then, when the dirty page will be writeback,
clear_page_dirty_for_io will clear PG_reclaim unconditionally.  It
disturbs this serie's goal.

I think it's okay to clear PG_readahead when the page is dirty, not
writeback time.  So this patch moves ClearPageReadahead.  In v4,
ClearPageReadahead in set_page_dirty has a problem which is reported by
Steven Barrett.  It's due to compound page.  Some driver(ex, audio) calls
set_page_dirty with compound page which isn't on LRU.  but my patch does
ClearPageRelcaim on compound page.  In non-CONFIG_PAGEFLAGS_EXTENDED, it
breaks PageTail flag.

I think it doesn't affect THP and pass my test with THP enabling but Cced
Andrea for double check.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Reported-by: Steven Barrett <damentz@liquorix.net>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   12 +++++++++++-
 mm/swap.c           |   41 ++++++++++++++++++++++++++++++++++++++---
 2 files changed, 49 insertions(+), 4 deletions(-)

diff -puN mm/page-writeback.c~mm-reclaim-invalidated-page-asap mm/page-writeback.c
--- a/mm/page-writeback.c~mm-reclaim-invalidated-page-asap
+++ a/mm/page-writeback.c
@@ -1211,6 +1211,17 @@ int set_page_dirty(struct page *page)
 
 	if (likely(mapping)) {
 		int (*spd)(struct page *) = mapping->a_ops->set_page_dirty;
+		/*
+		 * readahead/lru_deactivate_page could remain
+		 * PG_readahead/PG_reclaim due to race with end_page_writeback
+		 * About readahead, if the page is written, the flags would be
+		 * reset. So no problem.
+		 * About lru_deactivate_page, if the page is redirty, the flag
+		 * will be reset. So no problem. but if the page is used by readahead
+		 * it will confuse readahead and make it restart the size rampup
+		 * process. But it's a trivial problem.
+		 */
+		ClearPageReclaim(page);
 #ifdef CONFIG_BLOCK
 		if (!spd)
 			spd = __set_page_dirty_buffers;
@@ -1266,7 +1277,6 @@ int clear_page_dirty_for_io(struct page 
 
 	BUG_ON(!PageLocked(page));
 
-	ClearPageReclaim(page);
 	if (mapping && mapping_cap_account_dirty(mapping)) {
 		/*
 		 * Yes, Virginia, this is indeed insane.
diff -puN mm/swap.c~mm-reclaim-invalidated-page-asap mm/swap.c
--- a/mm/swap.c~mm-reclaim-invalidated-page-asap
+++ a/mm/swap.c
@@ -354,26 +354,61 @@ void add_page_to_unevictable_list(struct
  * head of the list, rather than the tail, to give the flusher
  * threads some time to write it out, as this is much more
  * effective than the single-page writeout from reclaim.
+ *
+ * If the page isn't page_mapped and dirty/writeback, the page
+ * could reclaim asap using PG_reclaim.
+ *
+ * 1. active, mapped page -> none
+ * 2. active, dirty/writeback page -> inactive, head, PG_reclaim
+ * 3. inactive, mapped page -> none
+ * 4. inactive, dirty/writeback page -> inactive, head, PG_reclaim
+ * 5. inactive, clean -> inactive, tail
+ * 6. Others -> none
+ *
+ * In 4, why it moves inactive's head, the VM expects the page would
+ * be write it out by flusher threads as this is much more effective
+ * than the single-page writeout from reclaim.
  */
 static void lru_deactivate(struct page *page, struct zone *zone)
 {
 	int lru, file;
+	bool active;
 
-	if (!PageLRU(page) || !PageActive(page))
+	if (!PageLRU(page))
 		return;
 
 	/* Some processes are using the page */
 	if (page_mapped(page))
 		return;
 
+	active = PageActive(page);
+
 	file = page_is_file_cache(page);
 	lru = page_lru_base_type(page);
-	del_page_from_lru_list(zone, page, lru + LRU_ACTIVE);
+	del_page_from_lru_list(zone, page, lru + active);
 	ClearPageActive(page);
 	ClearPageReferenced(page);
 	add_page_to_lru_list(zone, page, lru);
-	__count_vm_event(PGDEACTIVATE);
 
+	if (PageWriteback(page) || PageDirty(page)) {
+		/*
+		 * PG_reclaim could be raced with end_page_writeback
+		 * It can make readahead confusing.  But race window
+		 * is _really_ small and  it's non-critical problem.
+		 */
+		SetPageReclaim(page);
+	} else {
+		/*
+		 * The page's writeback ends up during pagevec
+		 * We moves tha page into tail of inactive.
+		 */
+		list_move_tail(&page->lru, &zone->lru[lru].list);
+		mem_cgroup_rotate_reclaimable_page(page);
+		__count_vm_event(PGROTATED);
+	}
+
+	if (active)
+		__count_vm_event(PGDEACTIVATE);
 	update_page_reclaim_stat(zone, page, file, 0);
 }
 
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

linux-next.patch
mm-grab-rcu-read-lock-in-move_pages.patch
mm-vmscan-stop-reclaim-compaction-earlier-due-to-insufficient-progress-if-__gfp_repeat.patch
mm-vmscan-stop-reclaim-compaction-earlier-due-to-insufficient-progress-if-__gfp_repeat-v2.patch
mm-fix-dubious-code-in-__count_immobile_pages.patch
mm-vmap-area-cache.patch
mm-compaction-check-migrate_pagess-return-value-instead-of-list_empty.patch
mm-add-replace_page_cache_page-function-add-freepage-hook.patch
mm-introduce-delete_from_page_cache.patch
mm-hugetlbfs-change-remove_from_page_cache.patch
mm-shmem-change-remove_from_page_cache.patch
mm-truncate-change-remove_from_page_cache.patch
mm-good-bye-remove_from_page_cache.patch
mm-change-__remove_from_page_cache.patch
mm-deactivate-invalidated-pages.patch
memcg-move-memcg-reclaimable-page-into-tail-of-inactive-list.patch
mm-reclaim-invalidated-page-asap.patch
memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines.patch
memcg-soft-limit-reclaim-should-end-at-limit-not-below.patch
memcg-simplify-the-way-memory-limits-are-checked.patch
memcg-remove-unused-page-flag-bitfield-defines.patch
memcg-remove-impossible-conditional-when-committing.patch
memcg-remove-null-check-from-lookup_page_cgroup-result.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update-fix.patch
memcg-no-uncharged-pages-reach-page_cgroup_zoneinfo.patch
memcg-change-page_cgroup_zoneinfo-signature.patch
memcg-fold-__mem_cgroup_move_account-into-caller.patch
memcg-condense-page_cgroup-to-page-lookup-points.patch
memcg-remove-direct-page_cgroup-to-page-pointer.patch
memcg-remove-direct-page_cgroup-to-page-pointer-fix.patch
memcg-charged-pages-always-have-valid-per-memcg-zone-info.patch
memcg-remove-memcg-reclaim_param_lock.patch

