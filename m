From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-save-work-scanning-almost-empty-lru-lists.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:48:20 -0800
Message-ID: <20130225204820.CDE8C5A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:50287 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758437Ab3BYUsY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:48:24 -0500
Received: by mail-yh0-f73.google.com with SMTP id 28so346694yhr.2
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:48:21 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, mgorman@suse.de, mhocko@suse.cz, riel@redhat.com, satoru.moriya@hds.com, simon.jeons@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: save work scanning (almost) empty LRU lists
has been removed from the -mm tree.  Its filename was
     mm-vmscan-save-work-scanning-almost-empty-lru-lists.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: vmscan: save work scanning (almost) empty LRU lists

In certain cases (kswapd reclaim, memcg target reclaim), a fixed minimum
amount of pages is scanned from the LRU lists on each iteration, to make
progress.

Do not make this minimum bigger than the respective LRU list size,
however, and save some busy work trying to isolate and reclaim pages that
are not there.

Empty LRU lists are quite common with memory cgroups in NUMA environments
because there exists a set of LRU lists for each zone for each memory
cgroup, while the memory of a single cgroup is expected to stay on just
one node.  The number of expected empty LRU lists is thus

  memcgs * (nodes - 1) * lru types

Each attempt to reclaim from an empty LRU list does expensive size
comparisons between lists, acquires the zone's lru lock etc.  Avoid that.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Satoru Moriya <satoru.moriya@hds.com>
Cc: Simon Jeons <simon.jeons@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    2 +-
 mm/vmscan.c          |   10 ++++++----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff -puN include/linux/swap.h~mm-vmscan-save-work-scanning-almost-empty-lru-lists include/linux/swap.h
--- a/include/linux/swap.h~mm-vmscan-save-work-scanning-almost-empty-lru-lists
+++ a/include/linux/swap.h
@@ -156,7 +156,7 @@ enum {
 	SWP_SCANNING	= (1 << 8),	/* refcount in scan_swap_map */
 };
 
-#define SWAP_CLUSTER_MAX 32
+#define SWAP_CLUSTER_MAX 32UL
 #define COMPACT_CLUSTER_MAX SWAP_CLUSTER_MAX
 
 /*
diff -puN mm/vmscan.c~mm-vmscan-save-work-scanning-almost-empty-lru-lists mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-save-work-scanning-almost-empty-lru-lists
+++ a/mm/vmscan.c
@@ -1761,15 +1761,17 @@ static void get_scan_count(struct lruvec
 out:
 	for_each_evictable_lru(lru) {
 		int file = is_file_lru(lru);
+		unsigned long size;
 		unsigned long scan;
 
-		scan = get_lru_size(lruvec, lru);
+		size = get_lru_size(lruvec, lru);
 		if (sc->priority || noswap || !vmscan_swappiness(sc)) {
-			scan >>= sc->priority;
+			scan = size >> sc->priority;
 			if (!scan && force_scan)
-				scan = SWAP_CLUSTER_MAX;
+				scan = min(size, SWAP_CLUSTER_MAX);
 			scan = div64_u64(scan * fraction[file], denominator);
-		}
+		} else
+			scan = size;
 		nr[lru] = scan;
 	}
 }
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-memmap_init_zone-performance-improvement.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch

