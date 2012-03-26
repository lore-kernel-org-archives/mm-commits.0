From: akpm@linux-foundation.org
Subject: + mm-push-lru-index-into-shrink_active_list.patch added to -mm tree
Date: Mon, 26 Mar 2012 16:56:21 -0700
Message-ID: <20120326235621.33FA0A0363@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:58332 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757802Ab2CZX4Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 19:56:24 -0400
Received: by lbbgj3 with SMTP id gj3so294226lbb.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 16:56:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, glommer@parallels.com, hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, minchan@kernel.org


The patch titled
     Subject: mm: push lru index into shrink_[in]active_list()
has been added to the -mm tree.  Its filename is
     mm-push-lru-index-into-shrink_active_list.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: mm: push lru index into shrink_[in]active_list()

Let's toss lru index through call stack to isolate_lru_pages(), this is
better than its reconstructing from individual bits.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Glauber Costa <glommer@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   41 +++++++++++++++++------------------------
 1 file changed, 17 insertions(+), 24 deletions(-)

diff -puN mm/vmscan.c~mm-push-lru-index-into-shrink_active_list mm/vmscan.c
--- a/mm/vmscan.c~mm-push-lru-index-into-shrink_active_list
+++ a/mm/vmscan.c
@@ -1127,15 +1127,14 @@ int __isolate_lru_page(struct page *page
  * @nr_scanned:	The number of pages that were scanned.
  * @sc:		The scan_control struct for this reclaim session
  * @mode:	One of the LRU isolation modes
- * @active:	True [1] if isolating active pages
- * @file:	True [1] if isolating file [!anon] pages
+ * @lru		LRU list id for isolating
  *
  * returns how many pages were moved onto *@dst.
  */
 static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 		struct mem_cgroup_zone *mz, struct list_head *dst,
 		unsigned long *nr_scanned, struct scan_control *sc,
-		isolate_mode_t mode, int active, int file)
+		isolate_mode_t mode, enum lru_list lru)
 {
 	struct lruvec *lruvec;
 	struct list_head *src;
@@ -1144,13 +1143,9 @@ static unsigned long isolate_lru_pages(u
 	unsigned long nr_lumpy_dirty = 0;
 	unsigned long nr_lumpy_failed = 0;
 	unsigned long scan;
-	int lru = LRU_BASE;
+	int file = is_file_lru(lru);
 
 	lruvec = mem_cgroup_zone_lruvec(mz->zone, mz->mem_cgroup);
-	if (active)
-		lru += LRU_ACTIVE;
-	if (file)
-		lru += LRU_FILE;
 	src = &lruvec->lists[lru];
 
 	for (scan = 0; scan < nr_to_scan && !list_empty(src); scan++) {
@@ -1487,7 +1482,7 @@ static inline bool should_reclaim_stall(
  */
 static noinline_for_stack unsigned long
 shrink_inactive_list(unsigned long nr_to_scan, struct mem_cgroup_zone *mz,
-		     struct scan_control *sc, int priority, int file)
+		     struct scan_control *sc, int priority, enum lru_list lru)
 {
 	LIST_HEAD(page_list);
 	unsigned long nr_scanned;
@@ -1498,6 +1493,7 @@ shrink_inactive_list(unsigned long nr_to
 	unsigned long nr_dirty = 0;
 	unsigned long nr_writeback = 0;
 	isolate_mode_t isolate_mode = ISOLATE_INACTIVE;
+	int file = is_file_lru(lru);
 	struct zone *zone = mz->zone;
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(mz);
 
@@ -1523,7 +1519,7 @@ shrink_inactive_list(unsigned long nr_to
 	spin_lock_irq(&zone->lru_lock);
 
 	nr_taken = isolate_lru_pages(nr_to_scan, mz, &page_list, &nr_scanned,
-				     sc, isolate_mode, 0, file);
+				     sc, isolate_mode, lru);
 	if (global_reclaim(sc)) {
 		zone->pages_scanned += nr_scanned;
 		if (current_is_kswapd())
@@ -1661,7 +1657,7 @@ static void move_active_pages_to_lru(str
 static void shrink_active_list(unsigned long nr_to_scan,
 			       struct mem_cgroup_zone *mz,
 			       struct scan_control *sc,
-			       int priority, int file)
+			       int priority, enum lru_list lru)
 {
 	unsigned long nr_taken;
 	unsigned long nr_scanned;
@@ -1673,6 +1669,7 @@ static void shrink_active_list(unsigned 
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(mz);
 	unsigned long nr_rotated = 0;
 	isolate_mode_t isolate_mode = ISOLATE_ACTIVE;
+	int file = is_file_lru(lru);
 	struct zone *zone = mz->zone;
 
 	lru_add_drain();
@@ -1687,17 +1684,14 @@ static void shrink_active_list(unsigned 
 	spin_lock_irq(&zone->lru_lock);
 
 	nr_taken = isolate_lru_pages(nr_to_scan, mz, &l_hold, &nr_scanned, sc,
-				     isolate_mode, 1, file);
+				     isolate_mode, lru);
 	if (global_reclaim(sc))
 		zone->pages_scanned += nr_scanned;
 
 	reclaim_stat->recent_scanned[file] += nr_taken;
 
 	__count_zone_vm_events(PGREFILL, zone, nr_scanned);
-	if (file)
-		__mod_zone_page_state(zone, NR_ACTIVE_FILE, -nr_taken);
-	else
-		__mod_zone_page_state(zone, NR_ACTIVE_ANON, -nr_taken);
+	__mod_zone_page_state(zone, NR_LRU_BASE + lru, -nr_taken);
 	__mod_zone_page_state(zone, NR_ISOLATED_ANON + file, nr_taken);
 	spin_unlock_irq(&zone->lru_lock);
 
@@ -1752,10 +1746,8 @@ static void shrink_active_list(unsigned 
 	 */
 	reclaim_stat->recent_rotated[file] += nr_rotated;
 
-	move_active_pages_to_lru(zone, &l_active, &l_hold,
-						LRU_ACTIVE + file * LRU_FILE);
-	move_active_pages_to_lru(zone, &l_inactive, &l_hold,
-						LRU_BASE   + file * LRU_FILE);
+	move_active_pages_to_lru(zone, &l_active, &l_hold, lru);
+	move_active_pages_to_lru(zone, &l_inactive, &l_hold, lru - LRU_ACTIVE);
 	__mod_zone_page_state(zone, NR_ISOLATED_ANON + file, -nr_taken);
 	spin_unlock_irq(&zone->lru_lock);
 
@@ -1855,11 +1847,11 @@ static unsigned long shrink_list(enum lr
 
 	if (is_active_lru(lru)) {
 		if (inactive_list_is_low(mz, file))
-			shrink_active_list(nr_to_scan, mz, sc, priority, file);
+			shrink_active_list(nr_to_scan, mz, sc, priority, lru);
 		return 0;
 	}
 
-	return shrink_inactive_list(nr_to_scan, mz, sc, priority, file);
+	return shrink_inactive_list(nr_to_scan, mz, sc, priority, lru);
 }
 
 static int vmscan_swappiness(struct mem_cgroup_zone *mz,
@@ -2110,7 +2102,8 @@ restart:
 	 * rebalance the anon lru active/inactive ratio.
 	 */
 	if (inactive_anon_is_low(mz))
-		shrink_active_list(SWAP_CLUSTER_MAX, mz, sc, priority, 0);
+		shrink_active_list(SWAP_CLUSTER_MAX, mz,
+				   sc, priority, LRU_ACTIVE_ANON);
 
 	/* reclaim/compaction might need reclaim to continue */
 	if (should_continue_reclaim(mz, nr_reclaimed,
@@ -2550,7 +2543,7 @@ static void age_active_anon(struct zone 
 
 		if (inactive_anon_is_low(&mz))
 			shrink_active_list(SWAP_CLUSTER_MAX, &mz,
-					   sc, priority, 0);
+					   sc, priority, LRU_ACTIVE_ANON);
 
 		memcg = mem_cgroup_iter(NULL, memcg, NULL);
 	} while (memcg);
_
Subject: Subject: mm: push lru index into shrink_[in]active_list()

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch
radix-tree-introduce-bit-optimized-iterator.patch
radix-tree-introduce-bit-optimized-iterator-v3.patch
radix-tree-introduce-bit-optimized-iterator-v3-fix.patch
radix-tree-rewrite-gang-lookup-with-using-iterator.patch
radix-tree-use-iterators-in-find_get_pages-functions.patch
linux-next.patch
mm-fix-page-faults-detection-in-swap-token-logic.patch
mm-memcg-scanning_global_lru-means-mem_cgroup_disabled.patch
mm-memcg-move-reclaim_stat-into-lruvec.patch
mm-push-lru-index-into-shrink_active_list.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
mm-mark-mm-inline-functions-as-__always_inline.patch
mm-remove-lru-type-checks-from-__isolate_lru_page.patch
mm-memcg-kill-mem_cgroup_lru_del.patch
mm-memcg-use-vm_swappiness-from-target-memory-cgroup.patch

