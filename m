From: akpm@linux-foundation.org
Subject: +
 mm-vmscan-only-allocate-and-reclaim-from-zones-with-pages-managed-by-the-buddy-allocator.patch added to -mm tree
Date: Wed, 31 Aug 2016 13:09:53 -0700
Message-ID: <57c73991.iV+r+lEEGWwClBh/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48728 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759021AbcHaUJ4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Aug 2016 16:09:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, mhocko@suse.com, srikar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmscan: only allocate and reclaim from zones with pages managed by the buddy allocator
has been added to the -mm tree.  Its filename is
     mm-vmscan-only-allocate-and-reclaim-from-zones-with-pages-managed-by-the-buddy-allocator.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-only-allocate-and-reclaim-from-zones-with-pages-managed-by-the-buddy-allocator.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-only-allocate-and-reclaim-from-zones-with-pages-managed-by-the-buddy-allocator.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, vmscan: only allocate and reclaim from zones with pages managed by the buddy allocator

Firmware Assisted Dump (FA_DUMP) on ppc64 reserves substantial amounts of
memory when booting a secondary kernel.  Srikar Dronamraju reported that
multiple nodes may have no memory managed by the buddy allocator but still
return true for populated_zone().

Commit 1d82de618ddd ("mm, vmscan: make kswapd reclaim in terms of nodes")
was reported to cause kswapd to spin at 100% CPU usage when fadump was
enabled.  The old code happened to deal with the situation of a populated
node with zero free pages by co-incidence but the current code tries to
reclaim populated zones without realising that is impossible.

We cannot just convert populated_zone() as many existing users really need
to check for present_pages.  This patch introduces a managed_zone() helper
and uses it in the few cases where it is critical that the check is made
for managed pages -- zonelist construction and page reclaim.

Link: http://lkml.kernel.org/r/20160831195104.GB8119@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reported-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Tested-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   16 ++++++++++++++--
 mm/page_alloc.c        |    4 ++--
 mm/vmscan.c            |   22 +++++++++++-----------
 3 files changed, 27 insertions(+), 15 deletions(-)

diff -puN include/linux/mmzone.h~mm-vmscan-only-allocate-and-reclaim-from-zones-with-pages-managed-by-the-buddy-allocator include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-vmscan-only-allocate-and-reclaim-from-zones-with-pages-managed-by-the-buddy-allocator
+++ a/include/linux/mmzone.h
@@ -828,9 +828,21 @@ unsigned long __init node_memmap_size_by
  */
 #define zone_idx(zone)		((zone) - (zone)->zone_pgdat->node_zones)
 
-static inline int populated_zone(struct zone *zone)
+/*
+ * Returns true if a zone has pages managed by the buddy allocator.
+ * All the reclaim decisions have to use this function rather than
+ * populated_zone(). If the whole zone is reserved then we can easily
+ * end up with populated_zone() && !managed_zone().
+ */
+static inline bool managed_zone(struct zone *zone)
+{
+	return zone->managed_pages;
+}
+
+/* Returns true if a zone has memory */
+static inline bool populated_zone(struct zone *zone)
 {
-	return (!!zone->present_pages);
+	return zone->present_pages;
 }
 
 extern int movable_zone;
diff -puN mm/page_alloc.c~mm-vmscan-only-allocate-and-reclaim-from-zones-with-pages-managed-by-the-buddy-allocator mm/page_alloc.c
--- a/mm/page_alloc.c~mm-vmscan-only-allocate-and-reclaim-from-zones-with-pages-managed-by-the-buddy-allocator
+++ a/mm/page_alloc.c
@@ -4360,7 +4360,7 @@ static int build_zonelists_node(pg_data_
 	do {
 		zone_type--;
 		zone = pgdat->node_zones + zone_type;
-		if (populated_zone(zone)) {
+		if (managed_zone(zone)) {
 			zoneref_set_zone(zone,
 				&zonelist->_zonerefs[nr_zones++]);
 			check_highest_zone(zone_type);
@@ -4598,7 +4598,7 @@ static void build_zonelists_in_zone_orde
 		for (j = 0; j < nr_nodes; j++) {
 			node = node_order[j];
 			z = &NODE_DATA(node)->node_zones[zone_type];
-			if (populated_zone(z)) {
+			if (managed_zone(z)) {
 				zoneref_set_zone(z,
 					&zonelist->_zonerefs[pos++]);
 				check_highest_zone(zone_type);
diff -puN mm/vmscan.c~mm-vmscan-only-allocate-and-reclaim-from-zones-with-pages-managed-by-the-buddy-allocator mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-only-allocate-and-reclaim-from-zones-with-pages-managed-by-the-buddy-allocator
+++ a/mm/vmscan.c
@@ -1665,7 +1665,7 @@ static bool inactive_reclaimable_pages(s
 
 	for (zid = sc->reclaim_idx; zid >= 0; zid--) {
 		zone = &pgdat->node_zones[zid];
-		if (!populated_zone(zone))
+		if (!managed_zone(zone))
 			continue;
 
 		if (zone_page_state_snapshot(zone, NR_ZONE_LRU_BASE +
@@ -2036,7 +2036,7 @@ static bool inactive_list_is_low(struct
 		struct zone *zone = &pgdat->node_zones[zid];
 		unsigned long inactive_zone, active_zone;
 
-		if (!populated_zone(zone))
+		if (!managed_zone(zone))
 			continue;
 
 		inactive_zone = zone_page_state(zone,
@@ -2171,7 +2171,7 @@ static void get_scan_count(struct lruvec
 
 		for (z = 0; z < MAX_NR_ZONES; z++) {
 			struct zone *zone = &pgdat->node_zones[z];
-			if (!populated_zone(zone))
+			if (!managed_zone(zone))
 				continue;
 
 			total_high_wmark += high_wmark_pages(zone);
@@ -2510,7 +2510,7 @@ static inline bool should_continue_recla
 	/* If compaction would go ahead or the allocation would succeed, stop */
 	for (z = 0; z <= sc->reclaim_idx; z++) {
 		struct zone *zone = &pgdat->node_zones[z];
-		if (!populated_zone(zone))
+		if (!managed_zone(zone))
 			continue;
 
 		switch (compaction_suitable(zone, sc->order, 0, sc->reclaim_idx)) {
@@ -2840,7 +2840,7 @@ static bool pfmemalloc_watermark_ok(pg_d
 
 	for (i = 0; i <= ZONE_NORMAL; i++) {
 		zone = &pgdat->node_zones[i];
-		if (!populated_zone(zone) ||
+		if (!managed_zone(zone) ||
 		    pgdat_reclaimable_pages(pgdat) == 0)
 			continue;
 
@@ -3141,7 +3141,7 @@ static bool prepare_kswapd_sleep(pg_data
 	for (i = 0; i <= classzone_idx; i++) {
 		struct zone *zone = pgdat->node_zones + i;
 
-		if (!populated_zone(zone))
+		if (!managed_zone(zone))
 			continue;
 
 		if (!zone_balanced(zone, order, classzone_idx))
@@ -3169,7 +3169,7 @@ static bool kswapd_shrink_node(pg_data_t
 	sc->nr_to_reclaim = 0;
 	for (z = 0; z <= sc->reclaim_idx; z++) {
 		zone = pgdat->node_zones + z;
-		if (!populated_zone(zone))
+		if (!managed_zone(zone))
 			continue;
 
 		sc->nr_to_reclaim += max(high_wmark_pages(zone), SWAP_CLUSTER_MAX);
@@ -3242,7 +3242,7 @@ static int balance_pgdat(pg_data_t *pgda
 		if (buffer_heads_over_limit) {
 			for (i = MAX_NR_ZONES - 1; i >= 0; i--) {
 				zone = pgdat->node_zones + i;
-				if (!populated_zone(zone))
+				if (!managed_zone(zone))
 					continue;
 
 				sc.reclaim_idx = i;
@@ -3262,7 +3262,7 @@ static int balance_pgdat(pg_data_t *pgda
 		 */
 		for (i = classzone_idx; i >= 0; i--) {
 			zone = pgdat->node_zones + i;
-			if (!populated_zone(zone))
+			if (!managed_zone(zone))
 				continue;
 
 			if (zone_balanced(zone, sc.order, classzone_idx))
@@ -3508,7 +3508,7 @@ void wakeup_kswapd(struct zone *zone, in
 	pg_data_t *pgdat;
 	int z;
 
-	if (!populated_zone(zone))
+	if (!managed_zone(zone))
 		return;
 
 	if (!cpuset_zone_allowed(zone, GFP_KERNEL | __GFP_HARDWALL))
@@ -3522,7 +3522,7 @@ void wakeup_kswapd(struct zone *zone, in
 	/* Only wake kswapd if all zones are unbalanced */
 	for (z = 0; z <= classzone_idx; z++) {
 		zone = pgdat->node_zones + z;
-		if (!populated_zone(zone))
+		if (!managed_zone(zone))
 			continue;
 
 		if (zone_balanced(zone, order, classzone_idx))
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-vmscan-only-allocate-and-reclaim-from-zones-with-pages-managed-by-the-buddy-allocator.patch

