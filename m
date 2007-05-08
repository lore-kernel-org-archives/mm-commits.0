From: akpm@linux-foundation.org
Subject: - readahead-state-based-method-aging-accounting.patch removed from -mm tree
Date: Tue, 08 May 2007 01:13:59 -0700
Message-ID: <200705080814.l488DxrJ018942@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60698 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934634AbXEHIOt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 04:14:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     readahead: state based method - aging accounting
has been removed from the -mm tree.  Its filename was
     readahead-state-based-method-aging-accounting.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: readahead: state based method - aging accounting
From: Wu Fengguang <wfg@mail.ustc.edu.cn>

Collect info about the global available memory and its consumption speed.
The data are used by the stateful method to estimate the thrashing threshold.

They are the decisive factor of the correctness/accuracy of the resulting
read-ahead size.

The accountings are done on a per-node basis. On NUMA systems, it works for
the two common real-world schemes:
	- the reader process allocates caches in a node affined manner;
	- the reader process allocates caches _balancely_ from a set of nodes.

[clameter@sgi.com: Apply type enum zone_type]
[clameter@sgi.com: ZVC writeback: Fix mm and other issues]
Signed-off-by: Wu Fengguang <wfg@mail.ustc.edu.cn>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    3 +++
 mm/page_alloc.c        |   31 +++++++++++++++++++++++++++++++
 mm/vmscan.c            |    1 +
 3 files changed, 35 insertions(+)

diff -puN include/linux/mmzone.h~readahead-state-based-method-aging-accounting include/linux/mmzone.h
--- a/include/linux/mmzone.h~readahead-state-based-method-aging-accounting
+++ a/include/linux/mmzone.h
@@ -251,6 +251,7 @@ struct zone {
 	unsigned long		nr_scan_active;
 	unsigned long		nr_scan_inactive;
 	unsigned long		pages_scanned;	   /* since last reclaim */
+	unsigned long		total_scanned;	   /* accumulated, may overflow */
 	int			all_unreclaimable; /* All pages pinned */
 
 	/* A count of how many reclaimers are scanning this zone */
@@ -495,6 +496,8 @@ typedef struct pglist_data {
 
 void get_zone_counts(unsigned long *active, unsigned long *inactive,
 			unsigned long *free);
+unsigned long nr_free_inactive_pages_node(int nid);
+unsigned long nr_scanned_pages_node(int nid);
 void build_all_zonelists(void);
 void wakeup_kswapd(struct zone *zone, int order);
 int zone_watermark_ok(struct zone *z, int order, unsigned long mark,
diff -puN mm/page_alloc.c~readahead-state-based-method-aging-accounting mm/page_alloc.c
--- a/mm/page_alloc.c~readahead-state-based-method-aging-accounting
+++ a/mm/page_alloc.c
@@ -1769,6 +1769,37 @@ unsigned int nr_free_pagecache_pages(voi
 	return nr_free_zone_pages(gfp_zone(GFP_HIGH_MOVABLE));
 }
 
+/*
+ * Amount of free+inactive RAM in a node.
+ */
+unsigned long nr_free_inactive_pages_node(int nid)
+{
+	enum zone_type i;
+	unsigned long sum = node_page_state(nid, NR_FREE_PAGES)
+				+ node_page_state(nid, NR_INACTIVE);
+	struct zone *zones = NODE_DATA(nid)->node_zones;
+
+	for (i = 0; i < MAX_NR_ZONES; i++)
+		sum -= zones[i].pages_low;
+
+	return sum;
+}
+
+/*
+ * Accumulated scanned pages in a node.
+ */
+unsigned long nr_scanned_pages_node(int nid)
+{
+       enum zone_type i;
+       unsigned long sum = 0;
+       struct zone *zones = NODE_DATA(nid)->node_zones;
+
+       for (i = 0; i < MAX_NR_ZONES; i++)
+	       sum += zones[i].total_scanned;
+
+       return sum;
+}
+
 static inline void show_node(struct zone *zone)
 {
 	if (NUMA_BUILD)
diff -puN mm/vmscan.c~readahead-state-based-method-aging-accounting mm/vmscan.c
--- a/mm/vmscan.c~readahead-state-based-method-aging-accounting
+++ a/mm/vmscan.c
@@ -802,6 +802,7 @@ static unsigned long shrink_inactive_lis
 		__mod_zone_page_state(zone, NR_INACTIVE,
 						-(nr_taken - nr_active));
 		zone->pages_scanned += nr_scan;
+		zone->total_scanned += nr_scan;
 		spin_unlock_irq(&zone->lru_lock);
 
 		nr_scanned += nr_scan;
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
readahead-state-based-method-aging-accounting.patch
readahead-state-based-method-routines.patch
readahead-state-based-method.patch
readahead-state-based-method-check-node-id.patch
readahead-state-based-method-decouple-readahead_ratio-from-growth_limit.patch
readahead-state-based-method-cancel-lookahead-gracefully.patch
readahead-context-based-method.patch
readahead-initial-method-guiding-sizes.patch
readahead-initial-method-thrashing-guard-size.patch
readahead-initial-method-user-recommended-size.patch
readahead-initial-method.patch
readahead-backward-prefetching-method.patch
readahead-thrashing-recovery-method.patch
readahead-thrashing-recovery-method-check-unbalanced-aging.patch
readahead-thrashing-recovery-method-refill-holes.patch
readahead-call-scheme.patch
readahead-call-scheme-cleanup.patch
readahead-call-scheme-catch-thrashing-on-lookahead-time.patch
readahead-call-scheme-doc-fixes-for-readahead.patch
readahead-laptop-mode.patch
readahead-loop-case.patch
readahead-nfsd-case.patch
readahead-remove-parameter-ra_max-from-thrashing_recovery_readahead.patch
readahead-remove-parameter-ra_max-from-adjust_rala.patch
readahead-state-based-method-protect-against-tiny-size.patch
readahead-rename-state_based_readahead-to-clock_based_readahead.patch
readahead-account-i-o-block-times-for-stock-readahead.patch
readahead-rescue_pages-updates.patch
readahead-remove-noaction-shrink-events.patch
readahead-remove-size-limit-on-read_ahead_kb.patch
readahead-remove-size-limit-of-max_sectors_kb-on-read_ahead_kb.patch
readahead-partial-sendfile-fix.patch
readahead-turn-on-by-default.patch
