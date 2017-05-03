From: akpm@linux-foundation.org
Subject: [patch 014/102] mm: delete NR_PAGES_SCANNED and
 pgdat_reclaimable()
Date: Wed, 03 May 2017 14:52:10 -0700
Message-ID: <20170503215210.a2BRUkWvy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47286 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752226AbdECVwL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:52:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, hejianet@gmail.com, hillf.zj@alibaba-inc.com, mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: delete NR_PAGES_SCANNED and pgdat_reclaimable()

NR_PAGES_SCANNED counts number of pages scanned since the last page free
event in the allocator.  This was used primarily to measure the
reclaimability of zones and nodes, and determine when reclaim should give
up on them.  In that role, it has been replaced in the preceding patches
by a different mechanism.

Being implemented as an efficient vmstat counter, it was automatically
exported to userspace as well.  It's however unlikely that anyone outside
the kernel is using this counter in any meaningful way.

Remove the counter and the unused pgdat_reclaimable().

Link: http://lkml.kernel.org/r/20170228214007.5621-8-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Jia He <hejianet@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    1 -
 mm/internal.h          |    1 -
 mm/page_alloc.c        |   11 -----------
 mm/vmscan.c            |    9 ---------
 mm/vmstat.c            |   22 +++-------------------
 5 files changed, 3 insertions(+), 41 deletions(-)

diff -puN include/linux/mmzone.h~mm-delete-nr_pages_scanned-and-pgdat_reclaimable include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-delete-nr_pages_scanned-and-pgdat_reclaimable
+++ a/include/linux/mmzone.h
@@ -149,7 +149,6 @@ enum node_stat_item {
 	NR_UNEVICTABLE,		/*  "     "     "   "       "         */
 	NR_ISOLATED_ANON,	/* Temporary isolated pages from anon lru */
 	NR_ISOLATED_FILE,	/* Temporary isolated pages from file lru */
-	NR_PAGES_SCANNED,	/* pages scanned since last reclaim */
 	WORKINGSET_REFAULT,
 	WORKINGSET_ACTIVATE,
 	WORKINGSET_NODERECLAIM,
diff -puN mm/internal.h~mm-delete-nr_pages_scanned-and-pgdat_reclaimable mm/internal.h
--- a/mm/internal.h~mm-delete-nr_pages_scanned-and-pgdat_reclaimable
+++ a/mm/internal.h
@@ -91,7 +91,6 @@ extern unsigned long highest_memmap_pfn;
  */
 extern int isolate_lru_page(struct page *page);
 extern void putback_lru_page(struct page *page);
-extern bool pgdat_reclaimable(struct pglist_data *pgdat);
 
 /*
  * in mm/rmap.c:
diff -puN mm/page_alloc.c~mm-delete-nr_pages_scanned-and-pgdat_reclaimable mm/page_alloc.c
--- a/mm/page_alloc.c~mm-delete-nr_pages_scanned-and-pgdat_reclaimable
+++ a/mm/page_alloc.c
@@ -1090,14 +1090,10 @@ static void free_pcppages_bulk(struct zo
 {
 	int migratetype = 0;
 	int batch_free = 0;
-	unsigned long nr_scanned;
 	bool isolated_pageblocks;
 
 	spin_lock(&zone->lock);
 	isolated_pageblocks = has_isolate_pageblock(zone);
-	nr_scanned = node_page_state(zone->zone_pgdat, NR_PAGES_SCANNED);
-	if (nr_scanned)
-		__mod_node_page_state(zone->zone_pgdat, NR_PAGES_SCANNED, -nr_scanned);
 
 	while (count) {
 		struct page *page;
@@ -1150,12 +1146,7 @@ static void free_one_page(struct zone *z
 				unsigned int order,
 				int migratetype)
 {
-	unsigned long nr_scanned;
 	spin_lock(&zone->lock);
-	nr_scanned = node_page_state(zone->zone_pgdat, NR_PAGES_SCANNED);
-	if (nr_scanned)
-		__mod_node_page_state(zone->zone_pgdat, NR_PAGES_SCANNED, -nr_scanned);
-
 	if (unlikely(has_isolate_pageblock(zone) ||
 		is_migrate_isolate(migratetype))) {
 		migratetype = get_pfnblock_migratetype(page, pfn);
@@ -4504,7 +4495,6 @@ void show_free_areas(unsigned int filter
 #endif
 			" writeback_tmp:%lukB"
 			" unstable:%lukB"
-			" pages_scanned:%lu"
 			" all_unreclaimable? %s"
 			"\n",
 			pgdat->node_id,
@@ -4527,7 +4517,6 @@ void show_free_areas(unsigned int filter
 #endif
 			K(node_page_state(pgdat, NR_WRITEBACK_TEMP)),
 			K(node_page_state(pgdat, NR_UNSTABLE_NFS)),
-			node_page_state(pgdat, NR_PAGES_SCANNED),
 			pgdat->kswapd_failures >= MAX_RECLAIM_RETRIES ?
 				"yes" : "no");
 	}
diff -puN mm/vmscan.c~mm-delete-nr_pages_scanned-and-pgdat_reclaimable mm/vmscan.c
--- a/mm/vmscan.c~mm-delete-nr_pages_scanned-and-pgdat_reclaimable
+++ a/mm/vmscan.c
@@ -230,12 +230,6 @@ unsigned long pgdat_reclaimable_pages(st
 	return nr;
 }
 
-bool pgdat_reclaimable(struct pglist_data *pgdat)
-{
-	return node_page_state_snapshot(pgdat, NR_PAGES_SCANNED) <
-		pgdat_reclaimable_pages(pgdat) * 6;
-}
-
 /**
  * lruvec_lru_size -  Returns the number of pages on the given LRU list.
  * @lruvec: lru vector
@@ -1750,7 +1744,6 @@ shrink_inactive_list(unsigned long nr_to
 	reclaim_stat->recent_scanned[file] += nr_taken;
 
 	if (global_reclaim(sc)) {
-		__mod_node_page_state(pgdat, NR_PAGES_SCANNED, nr_scanned);
 		if (current_is_kswapd())
 			__count_vm_events(PGSCAN_KSWAPD, nr_scanned);
 		else
@@ -1953,8 +1946,6 @@ static void shrink_active_list(unsigned
 	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, nr_taken);
 	reclaim_stat->recent_scanned[file] += nr_taken;
 
-	if (global_reclaim(sc))
-		__mod_node_page_state(pgdat, NR_PAGES_SCANNED, nr_scanned);
 	__count_vm_events(PGREFILL, nr_scanned);
 
 	spin_unlock_irq(&pgdat->lru_lock);
diff -puN mm/vmstat.c~mm-delete-nr_pages_scanned-and-pgdat_reclaimable mm/vmstat.c
--- a/mm/vmstat.c~mm-delete-nr_pages_scanned-and-pgdat_reclaimable
+++ a/mm/vmstat.c
@@ -954,7 +954,6 @@ const char * const vmstat_text[] = {
 	"nr_unevictable",
 	"nr_isolated_anon",
 	"nr_isolated_file",
-	"nr_pages_scanned",
 	"workingset_refault",
 	"workingset_activate",
 	"workingset_nodereclaim",
@@ -1378,7 +1377,6 @@ static void zoneinfo_show_print(struct s
 		   "\n        min      %lu"
 		   "\n        low      %lu"
 		   "\n        high     %lu"
-		   "\n   node_scanned  %lu"
 		   "\n        spanned  %lu"
 		   "\n        present  %lu"
 		   "\n        managed  %lu",
@@ -1386,7 +1384,6 @@ static void zoneinfo_show_print(struct s
 		   min_wmark_pages(zone),
 		   low_wmark_pages(zone),
 		   high_wmark_pages(zone),
-		   node_page_state(zone->zone_pgdat, NR_PAGES_SCANNED),
 		   zone->spanned_pages,
 		   zone->present_pages,
 		   zone->managed_pages);
@@ -1586,22 +1583,9 @@ int vmstat_refresh(struct ctl_table *tab
 	for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++) {
 		val = atomic_long_read(&vm_zone_stat[i]);
 		if (val < 0) {
-			switch (i) {
-			case NR_PAGES_SCANNED:
-				/*
-				 * This is often seen to go negative in
-				 * recent kernels, but not to go permanently
-				 * negative.  Whilst it would be nicer not to
-				 * have exceptions, rooting them out would be
-				 * another task, of rather low priority.
-				 */
-				break;
-			default:
-				pr_warn("%s: %s %ld\n",
-					__func__, vmstat_text[i], val);
-				err = -EINVAL;
-				break;
-			}
+			pr_warn("%s: %s %ld\n",
+				__func__, vmstat_text[i], val);
+			err = -EINVAL;
 		}
 	}
 	if (err)
_
