From: akpm@linux-foundation.org
Subject: + mm-compaction-prevent-kswapd-compacting-memory-to-reduce-cpu-usage.patch added to -mm tree
Date: Wed, 09 Mar 2011 14:17:25 -0800
Message-ID: <201103092217.p29MHPT5031068@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51088 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751405Ab1CIWY0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Mar 2011 17:24:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, arthur.marsh@internode.on.net, mel@csn.ul.ie, stable@kernel.org


The patch titled
     mm: compaction: prevent kswapd compacting memory to reduce CPU usage
has been added to the -mm tree.  Its filename is
     mm-compaction-prevent-kswapd-compacting-memory-to-reduce-cpu-usage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: compaction: prevent kswapd compacting memory to reduce CPU usage
From: Andrea Arcangeli <aarcange@redhat.com>

This patch reverts 5a03b051 ("thp: use compaction in kswapd for GFP_ATOMIC
order > 0") due to reports stating that kswapd CPU usage was higher and
IRQs were being disabled more frequently.  This was reported at
http://www.spinics.net/linux/fedora/alsa-user/msg09885.html.

Without this patch applied, CPU usage by kswapd hovers around the 20% mark
according to the tester (Arthur Marsh:
http://www.spinics.net/linux/fedora/alsa-user/msg09899.html).  With this
patch applied, it's around 2%.

The problem is not related to THP which specifies __GFP_NO_KSWAPD but is
triggered by high-order allocations hitting the low watermark for their
order and waking kswapd on kernels with CONFIG_COMPACTION set.  The most
common trigger for this is network cards configured for jumbo frames but
it's also possible it'll be triggered by fork-heavy workloads (order-1)
and some wireless cards which depend on order-1 allocations.

The symptoms for the user will be high CPU usage by kswapd in low-memory
situations which could be confused with another writeback problem.  While
a patch like 5a03b051 may be reintroduced in the future, this patch plays
it safe for now and reverts it.

[mel@csn.ul.ie: Beefed up the changelog]
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reported-by: Arthur Marsh <arthur.marsh@internode.on.net>
Tested-by: Arthur Marsh <arthur.marsh@internode.on.net>
Cc: <stable@kernel.org>		[2.6.38.1]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |    9 ++-------
 mm/compaction.c            |   24 +++---------------------
 mm/vmscan.c                |   18 +-----------------
 3 files changed, 6 insertions(+), 45 deletions(-)

diff -puN include/linux/compaction.h~mm-compaction-prevent-kswapd-compacting-memory-to-reduce-cpu-usage include/linux/compaction.h
--- a/include/linux/compaction.h~mm-compaction-prevent-kswapd-compacting-memory-to-reduce-cpu-usage
+++ a/include/linux/compaction.h
@@ -11,9 +11,6 @@
 /* The full zone was compacted */
 #define COMPACT_COMPLETE	3
 
-#define COMPACT_MODE_DIRECT_RECLAIM	0
-#define COMPACT_MODE_KSWAPD		1
-
 #ifdef CONFIG_COMPACTION
 extern int sysctl_compact_memory;
 extern int sysctl_compaction_handler(struct ctl_table *table, int write,
@@ -28,8 +25,7 @@ extern unsigned long try_to_compact_page
 			bool sync);
 extern unsigned long compaction_suitable(struct zone *zone, int order);
 extern unsigned long compact_zone_order(struct zone *zone, int order,
-					gfp_t gfp_mask, bool sync,
-					int compact_mode);
+					gfp_t gfp_mask, bool sync);
 
 /* Do not skip compaction more than 64 times */
 #define COMPACT_MAX_DEFER_SHIFT 6
@@ -74,8 +70,7 @@ static inline unsigned long compaction_s
 }
 
 static inline unsigned long compact_zone_order(struct zone *zone, int order,
-					       gfp_t gfp_mask, bool sync,
-					       int compact_mode)
+					       gfp_t gfp_mask, bool sync)
 {
 	return COMPACT_CONTINUE;
 }
diff -puN mm/compaction.c~mm-compaction-prevent-kswapd-compacting-memory-to-reduce-cpu-usage mm/compaction.c
--- a/mm/compaction.c~mm-compaction-prevent-kswapd-compacting-memory-to-reduce-cpu-usage
+++ a/mm/compaction.c
@@ -42,8 +42,6 @@ struct compact_control {
 	unsigned int order;		/* order a direct compactor needs */
 	int migratetype;		/* MOVABLE, RECLAIMABLE etc */
 	struct zone *zone;
-
-	int compact_mode;
 };
 
 static unsigned long release_freepages(struct list_head *freelist)
@@ -397,10 +395,7 @@ static int compact_finished(struct zone 
 		return COMPACT_COMPLETE;
 
 	/* Compaction run is not finished if the watermark is not met */
-	if (cc->compact_mode != COMPACT_MODE_KSWAPD)
-		watermark = low_wmark_pages(zone);
-	else
-		watermark = high_wmark_pages(zone);
+	watermark = low_wmark_pages(zone);
 	watermark += (1 << cc->order);
 
 	if (!zone_watermark_ok(zone, cc->order, watermark, 0, 0))
@@ -413,15 +408,6 @@ static int compact_finished(struct zone 
 	if (cc->order == -1)
 		return COMPACT_CONTINUE;
 
-	/*
-	 * Generating only one page of the right order is not enough
-	 * for kswapd, we must continue until we're above the high
-	 * watermark as a pool for high order GFP_ATOMIC allocations
-	 * too.
-	 */
-	if (cc->compact_mode == COMPACT_MODE_KSWAPD)
-		return COMPACT_CONTINUE;
-
 	/* Direct compactor: Is a suitable page free? */
 	for (order = cc->order; order < MAX_ORDER; order++) {
 		/* Job done if page is free of the right migratetype */
@@ -543,8 +529,7 @@ static int compact_zone(struct zone *zon
 
 unsigned long compact_zone_order(struct zone *zone,
 				 int order, gfp_t gfp_mask,
-				 bool sync,
-				 int compact_mode)
+				 bool sync)
 {
 	struct compact_control cc = {
 		.nr_freepages = 0,
@@ -553,7 +538,6 @@ unsigned long compact_zone_order(struct 
 		.migratetype = allocflags_to_migratetype(gfp_mask),
 		.zone = zone,
 		.sync = sync,
-		.compact_mode = compact_mode,
 	};
 	INIT_LIST_HEAD(&cc.freepages);
 	INIT_LIST_HEAD(&cc.migratepages);
@@ -599,8 +583,7 @@ unsigned long try_to_compact_pages(struc
 								nodemask) {
 		int status;
 
-		status = compact_zone_order(zone, order, gfp_mask, sync,
-					    COMPACT_MODE_DIRECT_RECLAIM);
+		status = compact_zone_order(zone, order, gfp_mask, sync);
 		rc = max(status, rc);
 
 		/* If a normal allocation would succeed, stop compacting */
@@ -631,7 +614,6 @@ static int compact_node(int nid)
 			.nr_freepages = 0,
 			.nr_migratepages = 0,
 			.order = -1,
-			.compact_mode = COMPACT_MODE_DIRECT_RECLAIM,
 		};
 
 		zone = &pgdat->node_zones[zoneid];
diff -puN mm/vmscan.c~mm-compaction-prevent-kswapd-compacting-memory-to-reduce-cpu-usage mm/vmscan.c
--- a/mm/vmscan.c~mm-compaction-prevent-kswapd-compacting-memory-to-reduce-cpu-usage
+++ a/mm/vmscan.c
@@ -2397,7 +2397,6 @@ loop_again:
 		 * cause too much scanning of the lower zones.
 		 */
 		for (i = 0; i <= end_zone; i++) {
-			int compaction;
 			struct zone *zone = pgdat->node_zones + i;
 			int nr_slab;
 
@@ -2428,24 +2427,9 @@ loop_again:
 			sc.nr_reclaimed += reclaim_state->reclaimed_slab;
 			total_scanned += sc.nr_scanned;
 
-			compaction = 0;
-			if (order &&
-			    zone_watermark_ok(zone, 0,
-					       high_wmark_pages(zone),
-					      end_zone, 0) &&
-			    !zone_watermark_ok(zone, order,
-					       high_wmark_pages(zone),
-					       end_zone, 0)) {
-				compact_zone_order(zone,
-						   order,
-						   sc.gfp_mask, false,
-						   COMPACT_MODE_KSWAPD);
-				compaction = 1;
-			}
-
 			if (zone->all_unreclaimable)
 				continue;
-			if (!compaction && nr_slab == 0 &&
+			if (nr_slab == 0 &&
 			    !zone_reclaimable(zone))
 				zone->all_unreclaimable = 1;
 			/*
_

Patches currently in -mm which might be from aarcange@redhat.com are

x86-fix-pgd_lock-deadlock.patch
mm-compaction-prevent-kswapd-compacting-memory-to-reduce-cpu-usage.patch
mm-compaction-check-migrate_pagess-return-value-instead-of-list_empty.patch
mm-deactivate-invalidated-pages.patch
memcg-move-memcg-reclaimable-page-into-tail-of-inactive-list.patch
mm-reclaim-invalidated-page-asap.patch
pagewalk-only-split-huge-pages-when-necessary.patch
smaps-break-out-smaps_pte_entry-from-smaps_pte_range.patch
smaps-pass-pte-size-argument-in-to-smaps_pte_entry.patch
smaps-teach-smaps_pte_range-about-thp-pmds.patch
smaps-have-smaps-show-transparent-huge-pages.patch
mm-vmscan-kswapd-should-not-free-an-excessive-number-of-pages-when-balancing-small-zones.patch
mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-free-pages.patch
mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-pages-for-migration.patch
mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-pages-for-migration-fix.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix-fix.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix-fix-fix.patch
mm-add-__gfp_other_node-flag.patch
mm-use-__gfp_other_node-for-transparent-huge-pages.patch
mm-add-vm-counters-for-transparent-hugepages.patch
memcg-use-native-word-page-statistics-counters-fix-event-counter-breakage-with-thp.patch

