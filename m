From: akpm@linux-foundation.org
Subject: [patch 049/101] mm: vmstat: account per-zone stalls and pages
 skipped during reclaim
Date: Thu, 28 Jul 2016 15:46:59 -0700
Message-ID: <579a8b63.wZYrHJpo3kI8tVsf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57017 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbcG1WrB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 18:47:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mgorman@techsingularity.net, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com, mhocko@kernel.org, minchan@kernel.org, riel@surriel.com, vbabka@suse.cz

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm: vmstat: account per-zone stalls and pages skipped during reclaim

The vmstat allocstall was fairly useful in the general sense but
node-based LRUs change that.  It's important to know if a stall was for an
address-limited allocation request as this will require skipping pages
from other zones.  This patch adds pgstall_* counters to replace
allocstall.  The sum of the counters will equal the old allocstall so it
can be trivially recalculated.  A high number of address-limited
allocation requests may result in a lot of useless LRU scanning for
suitable pages.

As address-limited allocations require pages to be skipped, it's important
to know how much useless LRU scanning took place so this patch adds
pgskip* counters.  This yields the following model

1. The number of address-space limited stalls can be accounted for (pgstall)
2. The amount of useless work required to reclaim the data is accounted (pgskip)
3. The total number of scans is available from pgscan_kswapd and pgscan_direct
   so from that the ratio of useful to useless scans can be calculated.

[mgorman@techsingularity.net: s/pgstall/allocstall/]
  Link: http://lkml.kernel.org/r/1468404004-5085-3-git-send-email-mgorman@techsingularity.netLink: http://lkml.kernel.org/r/1467970510-21195-33-git-send-email-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vm_event_item.h |    4 +++-
 mm/vmscan.c                   |   15 +++++++++++++--
 mm/vmstat.c                   |    3 ++-
 3 files changed, 18 insertions(+), 4 deletions(-)

diff -puN include/linux/vm_event_item.h~mm-vmstat-account-per-zone-stalls-and-pages-skipped-during-reclaim include/linux/vm_event_item.h
--- a/include/linux/vm_event_item.h~mm-vmstat-account-per-zone-stalls-and-pages-skipped-during-reclaim
+++ a/include/linux/vm_event_item.h
@@ -23,6 +23,8 @@
 
 enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		FOR_ALL_ZONES(PGALLOC),
+		FOR_ALL_ZONES(ALLOCSTALL),
+		FOR_ALL_ZONES(PGSCAN_SKIP),
 		PGFREE, PGACTIVATE, PGDEACTIVATE,
 		PGFAULT, PGMAJFAULT,
 		PGLAZYFREED,
@@ -37,7 +39,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 #endif
 		PGINODESTEAL, SLABS_SCANNED, KSWAPD_INODESTEAL,
 		KSWAPD_LOW_WMARK_HIT_QUICKLY, KSWAPD_HIGH_WMARK_HIT_QUICKLY,
-		PAGEOUTRUN, ALLOCSTALL, PGROTATED,
+		PAGEOUTRUN, PGROTATED,
 		DROP_PAGECACHE, DROP_SLAB,
 #ifdef CONFIG_NUMA_BALANCING
 		NUMA_PTE_UPDATES,
diff -puN mm/vmscan.c~mm-vmstat-account-per-zone-stalls-and-pages-skipped-during-reclaim mm/vmscan.c
--- a/mm/vmscan.c~mm-vmstat-account-per-zone-stalls-and-pages-skipped-during-reclaim
+++ a/mm/vmscan.c
@@ -1394,6 +1394,7 @@ static unsigned long isolate_lru_pages(u
 	struct list_head *src = &lruvec->lists[lru];
 	unsigned long nr_taken = 0;
 	unsigned long nr_zone_taken[MAX_NR_ZONES] = { 0 };
+	unsigned long nr_skipped[MAX_NR_ZONES] = { 0, };
 	unsigned long scan, nr_pages;
 	LIST_HEAD(pages_skipped);
 
@@ -1408,6 +1409,7 @@ static unsigned long isolate_lru_pages(u
 
 		if (page_zonenum(page) > sc->reclaim_idx) {
 			list_move(&page->lru, &pages_skipped);
+			nr_skipped[page_zonenum(page)]++;
 			continue;
 		}
 
@@ -1436,8 +1438,17 @@ static unsigned long isolate_lru_pages(u
 	 * scanning would soon rescan the same pages to skip and put the
 	 * system at risk of premature OOM.
 	 */
-	if (!list_empty(&pages_skipped))
+	if (!list_empty(&pages_skipped)) {
+		int zid;
+
 		list_splice(&pages_skipped, src);
+		for (zid = 0; zid < MAX_NR_ZONES; zid++) {
+			if (!nr_skipped[zid])
+				continue;
+
+			__count_zid_vm_events(PGSCAN_SKIP, zid, nr_skipped[zid]);
+		}
+	}
 	*nr_scanned = scan;
 	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan, scan,
 				    nr_taken, mode, is_file_lru(lru));
@@ -2680,7 +2691,7 @@ retry:
 	delayacct_freepages_start();
 
 	if (global_reclaim(sc))
-		count_vm_event(ALLOCSTALL);
+		__count_zid_vm_events(ALLOCSTALL, sc->reclaim_idx, 1);
 
 	do {
 		vmpressure_prio(sc->gfp_mask, sc->target_mem_cgroup,
diff -puN mm/vmstat.c~mm-vmstat-account-per-zone-stalls-and-pages-skipped-during-reclaim mm/vmstat.c
--- a/mm/vmstat.c~mm-vmstat-account-per-zone-stalls-and-pages-skipped-during-reclaim
+++ a/mm/vmstat.c
@@ -983,6 +983,8 @@ const char * const vmstat_text[] = {
 	"pswpout",
 
 	TEXTS_FOR_ZONES("pgalloc")
+	TEXTS_FOR_ZONES("allocstall")
+	TEXTS_FOR_ZONES("pgskip")
 
 	"pgfree",
 	"pgactivate",
@@ -1008,7 +1010,6 @@ const char * const vmstat_text[] = {
 	"kswapd_low_wmark_hit_quickly",
 	"kswapd_high_wmark_hit_quickly",
 	"pageoutrun",
-	"allocstall",
 
 	"pgrotated",
 
_
