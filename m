From: akpm@linux-foundation.org
Subject: [merged] mm-rearrange-putback_inactive_pages.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:36:04 -0800
Message-ID: <20120113203605.0E48220004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:57647 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759132Ab2AMUgG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:36:06 -0500
Received: by mail-ee0-f74.google.com with SMTP id e50so23684eek.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:36:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, hannes@cmpxchg.org, kosaki.motohiro@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rearrange putback_inactive_pages
has been removed from the -mm tree.  Its filename was
     mm-rearrange-putback_inactive_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: rearrange putback_inactive_pages

There is sometimes confusion between the global putback_lru_pages() in
migrate.c and the static putback_lru_pages() in vmscan.c: rename the
latter putback_inactive_pages(): it helps shrink_inactive_list() rather as
move_active_pages_to_lru() helps shrink_active_list().

Remove unused scan_control arg from putback_inactive_pages() and from
update_isolated_counts().  Move clear_active_flags() inside
update_isolated_counts().  Move NR_ISOLATED accounting up into
shrink_inactive_list() itself, so the balance is clearer.

Do the spin_lock_irq() before calling putback_inactive_pages() and
spin_unlock_irq() after return from it, so that it better matches
update_isolated_counts() and move_active_pages_to_lru().

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   96 ++++++++++++++++++++++----------------------------
 1 file changed, 44 insertions(+), 52 deletions(-)

diff -puN mm/vmscan.c~mm-rearrange-putback_inactive_pages mm/vmscan.c
--- a/mm/vmscan.c~mm-rearrange-putback_inactive_pages
+++ a/mm/vmscan.c
@@ -1284,32 +1284,6 @@ static unsigned long isolate_lru_pages(u
 	return nr_taken;
 }
 
-/*
- * clear_active_flags() is a helper for shrink_active_list(), clearing
- * any active bits from the pages in the list.
- */
-static unsigned long clear_active_flags(struct list_head *page_list,
-					unsigned int *count)
-{
-	int nr_active = 0;
-	int lru;
-	struct page *page;
-
-	list_for_each_entry(page, page_list, lru) {
-		int numpages = hpage_nr_pages(page);
-		lru = page_lru_base_type(page);
-		if (PageActive(page)) {
-			lru += LRU_ACTIVE;
-			ClearPageActive(page);
-			nr_active += numpages;
-		}
-		if (count)
-			count[lru] += numpages;
-	}
-
-	return nr_active;
-}
-
 /**
  * isolate_lru_page - tries to isolate a page from its LRU list
  * @page: page to isolate from its LRU list
@@ -1383,26 +1357,21 @@ static int too_many_isolated(struct zone
 	return isolated > inactive;
 }
 
-/*
- * TODO: Try merging with migrations version of putback_lru_pages
- */
 static noinline_for_stack void
-putback_lru_pages(struct mem_cgroup_zone *mz, struct scan_control *sc,
-		  unsigned long nr_anon, unsigned long nr_file,
-		  struct list_head *page_list)
+putback_inactive_pages(struct mem_cgroup_zone *mz,
+		       struct list_head *page_list)
 {
-	struct page *page;
-	LIST_HEAD(pages_to_free);
-	struct zone *zone = mz->zone;
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(mz);
+	struct zone *zone = mz->zone;
+	LIST_HEAD(pages_to_free);
 
 	/*
 	 * Put back any unfreeable pages.
 	 */
-	spin_lock(&zone->lru_lock);
 	while (!list_empty(page_list)) {
+		struct page *page = lru_to_page(page_list);
 		int lru;
-		page = lru_to_page(page_list);
+
 		VM_BUG_ON(PageLRU(page));
 		list_del(&page->lru);
 		if (unlikely(!page_evictable(page, NULL))) {
@@ -1432,26 +1401,40 @@ putback_lru_pages(struct mem_cgroup_zone
 				list_add(&page->lru, &pages_to_free);
 		}
 	}
-	__mod_zone_page_state(zone, NR_ISOLATED_ANON, -nr_anon);
-	__mod_zone_page_state(zone, NR_ISOLATED_FILE, -nr_file);
 
-	spin_unlock_irq(&zone->lru_lock);
-	free_hot_cold_page_list(&pages_to_free, 1);
+	/*
+	 * To save our caller's stack, now use input list for pages to free.
+	 */
+	list_splice(&pages_to_free, page_list);
 }
 
 static noinline_for_stack void
 update_isolated_counts(struct mem_cgroup_zone *mz,
-		       struct scan_control *sc,
+		       struct list_head *page_list,
 		       unsigned long *nr_anon,
-		       unsigned long *nr_file,
-		       struct list_head *isolated_list)
+		       unsigned long *nr_file)
 {
-	unsigned long nr_active;
+	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(mz);
 	struct zone *zone = mz->zone;
 	unsigned int count[NR_LRU_LISTS] = { 0, };
-	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(mz);
+	unsigned long nr_active = 0;
+	struct page *page;
+	int lru;
+
+	/*
+	 * Count pages and clear active flags
+	 */
+	list_for_each_entry(page, page_list, lru) {
+		int numpages = hpage_nr_pages(page);
+		lru = page_lru_base_type(page);
+		if (PageActive(page)) {
+			lru += LRU_ACTIVE;
+			ClearPageActive(page);
+			nr_active += numpages;
+		}
+		count[lru] += numpages;
+	}
 
-	nr_active = clear_active_flags(isolated_list, count);
 	__count_vm_events(PGDEACTIVATE, nr_active);
 
 	__mod_zone_page_state(zone, NR_ACTIVE_FILE,
@@ -1465,8 +1448,6 @@ update_isolated_counts(struct mem_cgroup
 
 	*nr_anon = count[LRU_ACTIVE_ANON] + count[LRU_INACTIVE_ANON];
 	*nr_file = count[LRU_ACTIVE_FILE] + count[LRU_INACTIVE_FILE];
-	__mod_zone_page_state(zone, NR_ISOLATED_ANON, *nr_anon);
-	__mod_zone_page_state(zone, NR_ISOLATED_FILE, *nr_file);
 
 	reclaim_stat->recent_scanned[0] += *nr_anon;
 	reclaim_stat->recent_scanned[1] += *nr_file;
@@ -1571,7 +1552,10 @@ shrink_inactive_list(unsigned long nr_to
 		return 0;
 	}
 
-	update_isolated_counts(mz, sc, &nr_anon, &nr_file, &page_list);
+	update_isolated_counts(mz, &page_list, &nr_anon, &nr_file);
+
+	__mod_zone_page_state(zone, NR_ISOLATED_ANON, nr_anon);
+	__mod_zone_page_state(zone, NR_ISOLATED_FILE, nr_file);
 
 	spin_unlock_irq(&zone->lru_lock);
 
@@ -1585,12 +1569,20 @@ shrink_inactive_list(unsigned long nr_to
 					priority, &nr_dirty, &nr_writeback);
 	}
 
-	local_irq_disable();
+	spin_lock_irq(&zone->lru_lock);
+
 	if (current_is_kswapd())
 		__count_vm_events(KSWAPD_STEAL, nr_reclaimed);
 	__count_zone_vm_events(PGSTEAL, zone, nr_reclaimed);
 
-	putback_lru_pages(mz, sc, nr_anon, nr_file, &page_list);
+	putback_inactive_pages(mz, &page_list);
+
+	__mod_zone_page_state(zone, NR_ISOLATED_ANON, -nr_anon);
+	__mod_zone_page_state(zone, NR_ISOLATED_FILE, -nr_file);
+
+	spin_unlock_irq(&zone->lru_lock);
+
+	free_hot_cold_page_list(&page_list, 1);
 
 	/*
 	 * If reclaim is isolating dirty pages under writeback, it implies
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
linux-next.patch
prio_tree-debugging-patch.patch

