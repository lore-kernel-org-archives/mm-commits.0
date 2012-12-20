From: akpm@linux-foundation.org
Subject: + mm-vmscan-save-work-scanning-almost-empty-lru-lists.patch added to -mm tree
Date: Wed, 19 Dec 2012 16:11:13 -0800
Message-ID: <20121220001114.658C782004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:56549 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab2LTALP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 19:11:15 -0500
Received: by mail-gg0-f201.google.com with SMTP id o6so305659ggm.0
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 16:11:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, hughd@google.com, mgorman@suse.de, mhocko@suse.cz, riel@redhat.com, satoru.moriya@hds.com, simon.jeons@gmail.com


The patch titled
     Subject: mm: vmscan: save work scanning (almost) empty LRU lists
has been added to the -mm tree.  Its filename is
     mm-vmscan-save-work-scanning-almost-empty-lru-lists.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-fix-calculation-of-dirtyable-memory.patch
mm-memcg-only-evict-file-pages-when-we-have-plenty.patch
mm-vmscan-save-work-scanning-almost-empty-lru-lists.patch
mm-vmscan-clarify-how-swappiness-highest-priority-memcg-interact.patch
mm-vmscan-improve-comment-on-low-page-cache-handling.patch
mm-vmscan-clean-up-get_scan_count.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-reduce-rmap-overhead-for-ex-ksm-page-copies-created-on-swap-faults.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
mm-memmap_init_zone-performance-improvement.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch

