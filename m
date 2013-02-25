From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-clarify-how-swappiness-highest-priority-memcg-interact.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:48:23 -0800
Message-ID: <20130225204823.DC1975A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:51913 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758578Ab3BYUsZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:48:25 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so345891ghb.1
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:48:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, mgorman@suse.de, mhocko@suse.cz, riel@redhat.com, satoru.moriya@hds.com, simon.jeons@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: clarify how swappiness, highest priority, memcg interact
has been removed from the -mm tree.  Its filename was
     mm-vmscan-clarify-how-swappiness-highest-priority-memcg-interact.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: vmscan: clarify how swappiness, highest priority, memcg interact

A swappiness of 0 has a slightly different meaning for global reclaim (may
swap if file cache really low) and memory cgroup reclaim (never swap,
ever).

In addition, global reclaim at highest priority will scan all LRU lists
equal to their size and ignore other balancing heuristics.  UNLESS
swappiness forbids swapping, then the lists are balanced based on recent
reclaim effectiveness.  UNLESS file cache is running low, then anonymous
pages are force-scanned.

This (total mess of a) behaviour is implicit and not obvious from the way
the code is organized.  At least make it apparent in the code flow and
document the conditions.  It will be it easier to come up with sane
semantics later.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Satoru Moriya <satoru.moriya@hds.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Simon Jeons <simon.jeons@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   39 ++++++++++++++++++++++++++++++---------
 1 file changed, 30 insertions(+), 9 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-clarify-how-swappiness-highest-priority-memcg-interact mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-clarify-how-swappiness-highest-priority-memcg-interact
+++ a/mm/vmscan.c
@@ -1656,7 +1656,6 @@ static void get_scan_count(struct lruvec
 	struct zone_reclaim_stat *reclaim_stat = &lruvec->reclaim_stat;
 	u64 fraction[2], denominator;
 	enum lru_list lru;
-	int noswap = 0;
 	bool force_scan = false;
 	struct zone *zone = lruvec_zone(lruvec);
 
@@ -1677,13 +1676,38 @@ static void get_scan_count(struct lruvec
 
 	/* If we have no swap space, do not bother scanning anon pages. */
 	if (!sc->may_swap || (nr_swap_pages <= 0)) {
-		noswap = 1;
 		fraction[0] = 0;
 		fraction[1] = 1;
 		denominator = 1;
 		goto out;
 	}
 
+	/*
+	 * Global reclaim will swap to prevent OOM even with no
+	 * swappiness, but memcg users want to use this knob to
+	 * disable swapping for individual groups completely when
+	 * using the memory controller's swap limit feature would be
+	 * too expensive.
+	 */
+	if (!global_reclaim(sc) && !vmscan_swappiness(sc)) {
+		fraction[0] = 0;
+		fraction[1] = 1;
+		denominator = 1;
+		goto out;
+	}
+
+	/*
+	 * Do not apply any pressure balancing cleverness when the
+	 * system is close to OOM, scan both anon and file equally
+	 * (unless the swappiness setting disagrees with swapping).
+	 */
+	if (!sc->priority && vmscan_swappiness(sc)) {
+		fraction[0] = 1;
+		fraction[1] = 1;
+		denominator = 1;
+		goto out;
+	}
+
 	anon  = get_lru_size(lruvec, LRU_ACTIVE_ANON) +
 		get_lru_size(lruvec, LRU_INACTIVE_ANON);
 	file  = get_lru_size(lruvec, LRU_ACTIVE_FILE) +
@@ -1765,13 +1789,10 @@ out:
 		unsigned long scan;
 
 		size = get_lru_size(lruvec, lru);
-		if (sc->priority || noswap || !vmscan_swappiness(sc)) {
-			scan = size >> sc->priority;
-			if (!scan && force_scan)
-				scan = min(size, SWAP_CLUSTER_MAX);
-			scan = div64_u64(scan * fraction[file], denominator);
-		} else
-			scan = size;
+		scan = size >> sc->priority;
+		if (!scan && force_scan)
+			scan = min(size, SWAP_CLUSTER_MAX);
+		scan = div64_u64(scan * fraction[file], denominator);
 		nr[lru] = scan;
 	}
 }
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-memmap_init_zone-performance-improvement.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch

