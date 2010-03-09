From: akpm@linux-foundation.org
Subject: [merged] vmscan-get_scan_ratio-cleanup.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:03:23 -0800
Message-ID: <201003091903.o29J3NTK030964@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34401 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755612Ab0CITDm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:03:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: get_scan_ratio() cleanup
has been removed from the -mm tree.  Its filename was
     vmscan-get_scan_ratio-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: get_scan_ratio() cleanup
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

The get_scan_ratio() should have all scan-ratio related calculations. 
Thus, this patch move some calculation into get_scan_ratio.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff -puN mm/vmscan.c~vmscan-get_scan_ratio-cleanup mm/vmscan.c
--- a/mm/vmscan.c~vmscan-get_scan_ratio-cleanup
+++ a/mm/vmscan.c
@@ -1501,6 +1501,13 @@ static void get_scan_ratio(struct zone *
 	unsigned long ap, fp;
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
 
+	/* If we have no swap space, do not bother scanning anon pages. */
+	if (!sc->may_swap || (nr_swap_pages <= 0)) {
+		percent[0] = 0;
+		percent[1] = 100;
+		return;
+	}
+
 	anon  = zone_nr_lru_pages(zone, sc, LRU_ACTIVE_ANON) +
 		zone_nr_lru_pages(zone, sc, LRU_INACTIVE_ANON);
 	file  = zone_nr_lru_pages(zone, sc, LRU_ACTIVE_FILE) +
@@ -1598,22 +1605,20 @@ static void shrink_zone(int priority, st
 	unsigned long nr_reclaimed = sc->nr_reclaimed;
 	unsigned long nr_to_reclaim = sc->nr_to_reclaim;
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
-	int noswap = 0;
 
-	/* If we have no swap space, do not bother scanning anon pages. */
-	if (!sc->may_swap || (nr_swap_pages <= 0)) {
-		noswap = 1;
-		percent[0] = 0;
-		percent[1] = 100;
-	} else
-		get_scan_ratio(zone, sc, percent);
+	get_scan_ratio(zone, sc, percent);
 
 	for_each_evictable_lru(l) {
 		int file = is_file_lru(l);
 		unsigned long scan;
 
+		if (percent[file] == 0) {
+			nr[l] = 0;
+			continue;
+		}
+
 		scan = zone_nr_lru_pages(zone, sc, l);
-		if (priority || noswap) {
+		if (priority) {
 			scan >>= priority;
 			scan = (scan * percent[file]) / 100;
 		}
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

prctl-add-pr_set_proctitle_area-option-for-prctl.patch
mm-introduce-dump_page-and-print-symbolic-flag-names.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
memcg-move-charges-of-anonymous-swap-fix-2.patch
sysctl-clean-up-vm-related-variable-declarations.patch
sysctl-clean-up-vm-related-variable-declarations-fix.patch
reiser4.patch

