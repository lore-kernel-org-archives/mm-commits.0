From: akpm@linux-foundation.org
Subject: + mm-delete-nr_pages_scanned-and-pgdat_reclaimable.patch added to -mm tree
Date: Tue, 28 Feb 2017 15:53:34 -0800
Message-ID: <58b60d7e.Hxqd0LPETyW2rRU9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34532 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751450AbdCAB4Q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 20:56:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hejianet@gmail.com, mgorman@suse.de, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: delete NR_PAGES_SCANNED and pgdat_reclaimable()
has been added to the -mm tree.  Its filename is
     mm-delete-nr_pages_scanned-and-pgdat_reclaimable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-delete-nr_pages_scanned-and-pgdat_reclaimable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-delete-nr_pages_scanned-and-pgdat_reclaimable.patch

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
Subject: mm: delete NR_PAGES_SCANNED and pgdat_reclaimable()

NR_PAGES_SCANNED counts number of pages scanned since the last page free
event in the allocator.  This was used primarily to measure the
reclaimability of zones and nodes, and determine when reclaim should give
up on them.  In that role, it has been replaced in the preceeding patches
by a different mechanism.

Being implemented as an efficient vmstat counter, it was automatically
exported to userspace as well.  It's however unlikely that anyone outside
the kernel is using this counter in any meaningful way.

Remove the counter and the unused pgdat_reclaimable().

Link: http://lkml.kernel.org/r/20170228214007.5621-8-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jia He <hejianet@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    1 -
 mm/internal.h          |    1 -
 mm/page_alloc.c        |   15 +++------------
 mm/vmscan.c            |    9 ---------
 mm/vmstat.c            |   22 +++-------------------
 5 files changed, 6 insertions(+), 42 deletions(-)

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
@@ -1088,15 +1088,11 @@ static void free_pcppages_bulk(struct zo
 {
 	int migratetype = 0;
 	int batch_free = 0;
-	unsigned long nr_scanned, flags;
+	unsigned long flags;
 	bool isolated_pageblocks;
 
 	spin_lock_irqsave(&zone->lock, flags);
 	isolated_pageblocks = has_isolate_pageblock(zone);
-	nr_scanned = node_page_state(zone->zone_pgdat, NR_PAGES_SCANNED);
-	if (nr_scanned)
-		__mod_node_page_state(zone->zone_pgdat, NR_PAGES_SCANNED, -nr_scanned);
-
 	while (count) {
 		struct page *page;
 		struct list_head *list;
@@ -1148,13 +1144,10 @@ static void free_one_page(struct zone *z
 				unsigned int order,
 				int migratetype)
 {
-	unsigned long nr_scanned, flags;
+	unsigned long flags;
+
 	spin_lock_irqsave(&zone->lock, flags);
 	__count_vm_events(PGFREE, 1 << order);
-	nr_scanned = node_page_state(zone->zone_pgdat, NR_PAGES_SCANNED);
-	if (nr_scanned)
-		__mod_node_page_state(zone->zone_pgdat, NR_PAGES_SCANNED, -nr_scanned);
-
 	if (unlikely(has_isolate_pageblock(zone) ||
 		is_migrate_isolate(migratetype))) {
 		migratetype = get_pfnblock_migratetype(page, pfn);
@@ -4497,7 +4490,6 @@ void show_free_areas(unsigned int filter
 #endif
 			" writeback_tmp:%lukB"
 			" unstable:%lukB"
-			" pages_scanned:%lu"
 			" all_unreclaimable? %s"
 			"\n",
 			pgdat->node_id,
@@ -4520,7 +4512,6 @@ void show_free_areas(unsigned int filter
 			K(node_page_state(pgdat, NR_SHMEM)),
 			K(node_page_state(pgdat, NR_WRITEBACK_TEMP)),
 			K(node_page_state(pgdat, NR_UNSTABLE_NFS)),
-			node_page_state(pgdat, NR_PAGES_SCANNED),
 			pgdat->kswapd_failures >= MAX_RECLAIM_RETRIES ?
 				"yes" : "no");
 	}
diff -puN mm/vmscan.c~mm-delete-nr_pages_scanned-and-pgdat_reclaimable mm/vmscan.c
--- a/mm/vmscan.c~mm-delete-nr_pages_scanned-and-pgdat_reclaimable
+++ a/mm/vmscan.c
@@ -229,12 +229,6 @@ unsigned long pgdat_reclaimable_pages(st
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
@@ -1749,7 +1743,6 @@ shrink_inactive_list(unsigned long nr_to
 	reclaim_stat->recent_scanned[file] += nr_taken;
 
 	if (global_reclaim(sc)) {
-		__mod_node_page_state(pgdat, NR_PAGES_SCANNED, nr_scanned);
 		if (current_is_kswapd())
 			__count_vm_events(PGSCAN_KSWAPD, nr_scanned);
 		else
@@ -1952,8 +1945,6 @@ static void shrink_active_list(unsigned
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
@@ -1375,7 +1374,6 @@ static void zoneinfo_show_print(struct s
 		   "\n        min      %lu"
 		   "\n        low      %lu"
 		   "\n        high     %lu"
-		   "\n   node_scanned  %lu"
 		   "\n        spanned  %lu"
 		   "\n        present  %lu"
 		   "\n        managed  %lu",
@@ -1383,7 +1381,6 @@ static void zoneinfo_show_print(struct s
 		   min_wmark_pages(zone),
 		   low_wmark_pages(zone),
 		   high_wmark_pages(zone),
-		   node_page_state(zone->zone_pgdat, NR_PAGES_SCANNED),
 		   zone->spanned_pages,
 		   zone->present_pages,
 		   zone->managed_pages);
@@ -1584,22 +1581,9 @@ int vmstat_refresh(struct ctl_table *tab
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

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-fix-100%-cpu-kswapd-busyloop-on-unreclaimable-nodes.patch
mm-fix-check-for-reclaimable-pages-in-pf_memalloc-reclaim-throttling.patch
mm-remove-seemingly-spurious-reclaimability-check-from-laptop_mode-gating.patch
mm-remove-unnecessary-reclaimability-check-from-numa-balancing-target.patch
mm-dont-avoid-high-priority-reclaim-on-unreclaimable-nodes.patch
mm-dont-avoid-high-priority-reclaim-on-memcg-limit-reclaim.patch
mm-delete-nr_pages_scanned-and-pgdat_reclaimable.patch
revert-mm-vmscan-account-for-skipped-pages-as-a-partial-scan.patch
mm-remove-unnecessary-back-off-function-when-retrying-page-reclaim.patch

