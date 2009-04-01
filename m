From: akpm@linux-foundation.org
Subject: [merged] mm-introduce-for_each_populated_zone-macro.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:34:23 -0700
Message-ID: <200904011834.n31IYN8t007149@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59559 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933513AbZDASit (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:38:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     mm: introduce for_each_populated_zone() macro
has been removed from the -mm tree.  Its filename was
     mm-introduce-for_each_populated_zone-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: introduce for_each_populated_zone() macro
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Impact: cleanup

In almost cases, for_each_zone() is used with populated_zone().  It's
because almost function doesn't need memoryless node information. 
Therefore, for_each_populated_zone() can help to make code simplify.

This patch has no functional change.

[akpm@linux-foundation.org: small cleanup]
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h  |    8 ++++++++
 kernel/power/snapshot.c |    9 +++------
 kernel/power/swsusp.c   |   17 ++++++++---------
 mm/page_alloc.c         |   26 +++++---------------------
 mm/vmscan.c             |    4 +---
 mm/vmstat.c             |   11 ++---------
 6 files changed, 27 insertions(+), 48 deletions(-)

diff -puN include/linux/mmzone.h~mm-introduce-for_each_populated_zone-macro include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-introduce-for_each_populated_zone-macro
+++ a/include/linux/mmzone.h
@@ -806,6 +806,14 @@ extern struct zone *next_zone(struct zon
 	     zone;					\
 	     zone = next_zone(zone))
 
+#define for_each_populated_zone(zone)		        \
+	for (zone = (first_online_pgdat())->node_zones; \
+	     zone;					\
+	     zone = next_zone(zone))			\
+		if (!populated_zone(zone))		\
+			; /* do nothing */		\
+		else
+
 static inline struct zone *zonelist_zone(struct zoneref *zoneref)
 {
 	return zoneref->zone;
diff -puN kernel/power/snapshot.c~mm-introduce-for_each_populated_zone-macro kernel/power/snapshot.c
--- a/kernel/power/snapshot.c~mm-introduce-for_each_populated_zone-macro
+++ a/kernel/power/snapshot.c
@@ -321,13 +321,10 @@ static int create_mem_extents(struct lis
 
 	INIT_LIST_HEAD(list);
 
-	for_each_zone(zone) {
+	for_each_populated_zone(zone) {
 		unsigned long zone_start, zone_end;
 		struct mem_extent *ext, *cur, *aux;
 
-		if (!populated_zone(zone))
-			continue;
-
 		zone_start = zone->zone_start_pfn;
 		zone_end = zone->zone_start_pfn + zone->spanned_pages;
 
@@ -804,8 +801,8 @@ static unsigned int count_free_highmem_p
 	struct zone *zone;
 	unsigned int cnt = 0;
 
-	for_each_zone(zone)
-		if (populated_zone(zone) && is_highmem(zone))
+	for_each_populated_zone(zone)
+		if (is_highmem(zone))
 			cnt += zone_page_state(zone, NR_FREE_PAGES);
 
 	return cnt;
diff -puN kernel/power/swsusp.c~mm-introduce-for_each_populated_zone-macro kernel/power/swsusp.c
--- a/kernel/power/swsusp.c~mm-introduce-for_each_populated_zone-macro
+++ a/kernel/power/swsusp.c
@@ -229,17 +229,16 @@ int swsusp_shrink_memory(void)
 		size = count_data_pages() + PAGES_FOR_IO + SPARE_PAGES;
 		tmp = size;
 		size += highmem_size;
-		for_each_zone (zone)
-			if (populated_zone(zone)) {
-				tmp += snapshot_additional_pages(zone);
-				if (is_highmem(zone)) {
-					highmem_size -=
+		for_each_populated_zone(zone) {
+			tmp += snapshot_additional_pages(zone);
+			if (is_highmem(zone)) {
+				highmem_size -=
 					zone_page_state(zone, NR_FREE_PAGES);
-				} else {
-					tmp -= zone_page_state(zone, NR_FREE_PAGES);
-					tmp += zone->lowmem_reserve[ZONE_NORMAL];
-				}
+			} else {
+				tmp -= zone_page_state(zone, NR_FREE_PAGES);
+				tmp += zone->lowmem_reserve[ZONE_NORMAL];
 			}
+		}
 
 		if (highmem_size < 0)
 			highmem_size = 0;
diff -puN mm/page_alloc.c~mm-introduce-for_each_populated_zone-macro mm/page_alloc.c
--- a/mm/page_alloc.c~mm-introduce-for_each_populated_zone-macro
+++ a/mm/page_alloc.c
@@ -922,13 +922,10 @@ static void drain_pages(unsigned int cpu
 	unsigned long flags;
 	struct zone *zone;
 
-	for_each_zone(zone) {
+	for_each_populated_zone(zone) {
 		struct per_cpu_pageset *pset;
 		struct per_cpu_pages *pcp;
 
-		if (!populated_zone(zone))
-			continue;
-
 		pset = zone_pcp(zone, cpu);
 
 		pcp = &pset->pcp;
@@ -1879,10 +1876,7 @@ void show_free_areas(void)
 	int cpu;
 	struct zone *zone;
 
-	for_each_zone(zone) {
-		if (!populated_zone(zone))
-			continue;
-
+	for_each_populated_zone(zone) {
 		show_node(zone);
 		printk("%s per-cpu:\n", zone->name);
 
@@ -1922,12 +1916,9 @@ void show_free_areas(void)
 		global_page_state(NR_PAGETABLE),
 		global_page_state(NR_BOUNCE));
 
-	for_each_zone(zone) {
+	for_each_populated_zone(zone) {
 		int i;
 
-		if (!populated_zone(zone))
-			continue;
-
 		show_node(zone);
 		printk("%s"
 			" free:%lukB"
@@ -1967,12 +1958,9 @@ void show_free_areas(void)
 		printk("\n");
 	}
 
-	for_each_zone(zone) {
+	for_each_populated_zone(zone) {
  		unsigned long nr[MAX_ORDER], flags, order, total = 0;
 
-		if (!populated_zone(zone))
-			continue;
-
 		show_node(zone);
 		printk("%s: ", zone->name);
 
@@ -2784,11 +2772,7 @@ static int __cpuinit process_zones(int c
 
 	node_set_state(node, N_CPU);	/* this node has a cpu */
 
-	for_each_zone(zone) {
-
-		if (!populated_zone(zone))
-			continue;
-
+	for_each_populated_zone(zone) {
 		zone_pcp(zone, cpu) = kmalloc_node(sizeof(struct per_cpu_pageset),
 					 GFP_KERNEL, node);
 		if (!zone_pcp(zone, cpu))
diff -puN mm/vmscan.c~mm-introduce-for_each_populated_zone-macro mm/vmscan.c
--- a/mm/vmscan.c~mm-introduce-for_each_populated_zone-macro
+++ a/mm/vmscan.c
@@ -2061,11 +2061,9 @@ static unsigned long shrink_all_zones(un
 	struct zone *zone;
 	unsigned long ret = 0;
 
-	for_each_zone(zone) {
+	for_each_populated_zone(zone) {
 		enum lru_list l;
 
-		if (!populated_zone(zone))
-			continue;
 		if (zone_is_all_unreclaimable(zone) && prio != DEF_PRIORITY)
 			continue;
 
diff -puN mm/vmstat.c~mm-introduce-for_each_populated_zone-macro mm/vmstat.c
--- a/mm/vmstat.c~mm-introduce-for_each_populated_zone-macro
+++ a/mm/vmstat.c
@@ -135,11 +135,7 @@ static void refresh_zone_stat_thresholds
 	int cpu;
 	int threshold;
 
-	for_each_zone(zone) {
-
-		if (!zone->present_pages)
-			continue;
-
+	for_each_populated_zone(zone) {
 		threshold = calculate_threshold(zone);
 
 		for_each_online_cpu(cpu)
@@ -301,12 +297,9 @@ void refresh_cpu_vm_stats(int cpu)
 	int i;
 	int global_diff[NR_VM_ZONE_STAT_ITEMS] = { 0, };
 
-	for_each_zone(zone) {
+	for_each_populated_zone(zone) {
 		struct per_cpu_pageset *p;
 
-		if (!populated_zone(zone))
-			continue;
