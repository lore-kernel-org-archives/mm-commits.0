From: akpm@linux-foundation.org
Subject: [merged] vmscan-handle-may_swap-more-strictly.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:36:29 -0700
Message-ID: <200906171836.n5HIaT9V002501@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39060 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754686AbZFQS4T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:56:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, minchan.kim@gmail.


The patch titled
     vmscan: handle may_swap more strictly
has been removed from the -mm tree.  Its filename was
     vmscan-handle-may_swap-more-strictly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: handle may_swap more strictly
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

Commit 2e2e425989080cc534fc0fca154cae515f971cf5 ("vmscan,memcg:
reintroduce sc->may_swap) add may_swap flag and handle it at
get_scan_ratio().

But the result of get_scan_ratio() is ignored when priority == 0, so anon
lru is scanned even if may_swap == 0 or nr_swap_pages == 0.  IMHO, this is
not an expected behavior.

As for memcg especially, because of this behavior many and many pages are
swapped-out just in vain when oom is invoked by mem+swap limit.

This patch is for handling may_swap flag more strictly.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN mm/vmscan.c~vmscan-handle-may_swap-more-strictly mm/vmscan.c
--- a/mm/vmscan.c~vmscan-handle-may_swap-more-strictly
+++ a/mm/vmscan.c
@@ -1430,13 +1430,6 @@ static void get_scan_ratio(struct zone *
 	unsigned long ap, fp;
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
 
-	/* If we have no swap space, do not bother scanning anon pages. */
-	if (!sc->may_swap || (nr_swap_pages <= 0)) {
-		percent[0] = 0;
-		percent[1] = 100;
-		return;
-	}
-
 	anon  = zone_nr_pages(zone, sc, LRU_ACTIVE_ANON) +
 		zone_nr_pages(zone, sc, LRU_INACTIVE_ANON);
 	file  = zone_nr_pages(zone, sc, LRU_ACTIVE_FILE) +
@@ -1534,15 +1527,22 @@ static void shrink_zone(int priority, st
 	enum lru_list l;
 	unsigned long nr_reclaimed = sc->nr_reclaimed;
 	unsigned long swap_cluster_max = sc->swap_cluster_max;
+	int noswap = 0;
 
-	get_scan_ratio(zone, sc, percent);
+	/* If we have no swap space, do not bother scanning anon pages. */
+	if (!sc->may_swap || (nr_swap_pages <= 0)) {
+		noswap = 1;
+		percent[0] = 0;
+		percent[1] = 100;
+	} else
+		get_scan_ratio(zone, sc, percent);
 
 	for_each_evictable_lru(l) {
 		int file = is_file_lru(l);
 		unsigned long scan;
 
 		scan = zone_nr_pages(zone, sc, l);
-		if (priority) {
+		if (priority || noswap) {
 			scan >>= priority;
 			scan = (scan * percent[file]) / 100;
 		}
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

origin.patch
memcg-add-file-based-rss-accounting.patch
memcg-add-file-based-rss-accounting-fix-mem_cgroup_update_mapped_file_stat-oops.patch
memcg-remove-mem_cgroup_cache_charge_swapin.patch
memcg-fix-swap-accounting.patch
memcg-fix-swap-accounting-update.patch
memcg-fix-behavior-under-memorylimit-equals-to-memswlimit.patch
memcg-add-interface-to-reset-limits.patch
memcg-fix-lru-rotation-in-isolate_pages.patch

