From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-clean-up-get_scan_count.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:48:29 -0800
Message-ID: <20130225204829.A18945A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:45530 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758700Ab3BYUsd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:48:33 -0500
Received: by mail-qe0-f74.google.com with SMTP id 1so120536qee.3
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:48:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, mgorman@suse.de, mhocko@suse.cz, riel@redhat.com, satoru.moriya@hds.com, simon.jeons@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: clean up get_scan_count()
has been removed from the -mm tree.  Its filename was
     mm-vmscan-clean-up-get_scan_count.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: vmscan: clean up get_scan_count()

Reclaim pressure balance between anon and file pages is calculated through
a tuple of numerators and a shared denominator.

Exceptional cases that want to force-scan anon or file pages configure the
numerators and denominator such that one list is preferred, which is not
necessarily the most obvious way:

    fraction[0] = 1;
    fraction[1] = 0;
    denominator = 1;
    goto out;

Make this easier by making the force-scan cases explicit and use the
fractionals only in case they are calculated from reclaim history.

[akpm@linux-foundation.org: avoid using unintialized_var()]
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Satoru Moriya <satoru.moriya@hds.com>
Cc: Simon Jeons <simon.jeons@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   65 +++++++++++++++++++++++++++++++++-----------------
 1 file changed, 44 insertions(+), 21 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-clean-up-get_scan_count mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-clean-up-get_scan_count
+++ a/mm/vmscan.c
@@ -1638,6 +1638,13 @@ static int vmscan_swappiness(struct scan
 	return mem_cgroup_swappiness(sc->target_mem_cgroup);
 }
 
+enum scan_balance {
+	SCAN_EQUAL,
+	SCAN_FRACT,
+	SCAN_ANON,
+	SCAN_FILE,
+};
+
 /*
  * Determine how aggressively the anon and file LRU lists should be
  * scanned.  The relative value of each set of LRU lists is determined
@@ -1650,14 +1657,16 @@ static int vmscan_swappiness(struct scan
 static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
 			   unsigned long *nr)
 {
-	unsigned long anon, file, free;
+	struct zone_reclaim_stat *reclaim_stat = &lruvec->reclaim_stat;
+	u64 fraction[2];
+	u64 denominator = 0;	/* gcc */
+	struct zone *zone = lruvec_zone(lruvec);
 	unsigned long anon_prio, file_prio;
+	enum scan_balance scan_balance;
+	unsigned long anon, file, free;
+	bool force_scan = false;
 	unsigned long ap, fp;
-	struct zone_reclaim_stat *reclaim_stat = &lruvec->reclaim_stat;
-	u64 fraction[2], denominator;
 	enum lru_list lru;
-	bool force_scan = false;
-	struct zone *zone = lruvec_zone(lruvec);
 
 	/*
 	 * If the zone or memcg is small, nr[l] can be 0.  This
@@ -1676,9 +1685,7 @@ static void get_scan_count(struct lruvec
 
 	/* If we have no swap space, do not bother scanning anon pages. */
 	if (!sc->may_swap || (nr_swap_pages <= 0)) {
-		fraction[0] = 0;
-		fraction[1] = 1;
-		denominator = 1;
+		scan_balance = SCAN_FILE;
 		goto out;
 	}
 
@@ -1690,9 +1697,7 @@ static void get_scan_count(struct lruvec
 	 * too expensive.
 	 */
 	if (!global_reclaim(sc) && !vmscan_swappiness(sc)) {
-		fraction[0] = 0;
-		fraction[1] = 1;
-		denominator = 1;
+		scan_balance = SCAN_FILE;
 		goto out;
 	}
 
@@ -1702,9 +1707,7 @@ static void get_scan_count(struct lruvec
 	 * (unless the swappiness setting disagrees with swapping).
 	 */
 	if (!sc->priority && vmscan_swappiness(sc)) {
-		fraction[0] = 1;
-		fraction[1] = 1;
-		denominator = 1;
+		scan_balance = SCAN_EQUAL;
 		goto out;
 	}
 
@@ -1722,9 +1725,7 @@ static void get_scan_count(struct lruvec
 	if (global_reclaim(sc)) {
 		free = zone_page_state(zone, NR_FREE_PAGES);
 		if (unlikely(file + free <= high_wmark_pages(zone))) {
-			fraction[0] = 1;
-			fraction[1] = 0;
-			denominator = 1;
+			scan_balance = SCAN_ANON;
 			goto out;
 		}
 	}
@@ -1734,12 +1735,12 @@ static void get_scan_count(struct lruvec
 	 * anything from the anonymous working set right now.
 	 */
 	if (!inactive_file_is_low(lruvec)) {
-		fraction[0] = 0;
-		fraction[1] = 1;
-		denominator = 1;
+		scan_balance = SCAN_FILE;
 		goto out;
 	}
 
+	scan_balance = SCAN_FRACT;
+
 	/*
 	 * With swappiness at 100, anonymous and file have the same priority.
 	 * This scanning priority is essentially the inverse of IO cost.
@@ -1792,9 +1793,31 @@ out:
 
 		size = get_lru_size(lruvec, lru);
 		scan = size >> sc->priority;
+
 		if (!scan && force_scan)
 			scan = min(size, SWAP_CLUSTER_MAX);
-		scan = div64_u64(scan * fraction[file], denominator);
+
+		switch (scan_balance) {
+		case SCAN_EQUAL:
+			/* Scan lists relative to size */
+			break;
+		case SCAN_FRACT:
+			/*
+			 * Scan types proportional to swappiness and
+			 * their relative recent reclaim efficiency.
+			 */
+			scan = div64_u64(scan * fraction[file], denominator);
+			break;
+		case SCAN_FILE:
+		case SCAN_ANON:
+			/* Scan one type exclusively */
+			if ((scan_balance == SCAN_FILE) != file)
+				scan = 0;
+			break;
+		default:
+			/* Look ma, no brain */
+			BUG();
+		}
 		nr[lru] = scan;
 	}
 }
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-memmap_init_zone-performance-improvement.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch

