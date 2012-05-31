From: akpm@linux-foundation.org
Subject: [merged] mm-add-link-from-struct-lruvec-to-struct-zone.patch removed from -mm tree
Date: Thu, 31 May 2012 12:17:17 -0700
Message-ID: <20120531191717.663BDA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:42805 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932980Ab2EaTRS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:17:18 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so134652ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:17:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add link from struct lruvec to struct zone
has been removed from the -mm tree.  Its filename was
     mm-add-link-from-struct-lruvec-to-struct-zone.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: mm: add link from struct lruvec to struct zone

This is the first stage of struct mem_cgroup_zone removal.  Further
patches replace struct mem_cgroup_zone with a pointer to struct lruvec.

If CONFIG_CGROUP_MEM_RES_CTLR=n lruvec_zone() is just container_of().

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   14 ++++++++++++++
 mm/memcontrol.c        |    4 +---
 mm/mmzone.c            |   14 ++++++++++++++
 mm/page_alloc.c        |    8 +-------
 4 files changed, 30 insertions(+), 10 deletions(-)

diff -puN include/linux/mmzone.h~mm-add-link-from-struct-lruvec-to-struct-zone include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-add-link-from-struct-lruvec-to-struct-zone
+++ a/include/linux/mmzone.h
@@ -201,6 +201,9 @@ struct zone_reclaim_stat {
 struct lruvec {
 	struct list_head lists[NR_LRU_LISTS];
 	struct zone_reclaim_stat reclaim_stat;
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR
+	struct zone *zone;
+#endif
 };
 
 /* Mask used at gathering information at once (see memcontrol.c) */
@@ -729,6 +732,17 @@ extern int init_currently_empty_zone(str
 				     unsigned long size,
 				     enum memmap_context context);
 
+extern void lruvec_init(struct lruvec *lruvec, struct zone *zone);
+
+static inline struct zone *lruvec_zone(struct lruvec *lruvec)
+{
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR
+	return lruvec->zone;
+#else
+	return container_of(lruvec, struct zone, lruvec);
+#endif
+}
+
 #ifdef CONFIG_HAVE_MEMORY_PRESENT
 void memory_present(int nid, unsigned long start, unsigned long end);
 #else
diff -puN mm/memcontrol.c~mm-add-link-from-struct-lruvec-to-struct-zone mm/memcontrol.c
--- a/mm/memcontrol.c~mm-add-link-from-struct-lruvec-to-struct-zone
+++ a/mm/memcontrol.c
@@ -4738,7 +4738,6 @@ static int alloc_mem_cgroup_per_zone_inf
 {
 	struct mem_cgroup_per_node *pn;
 	struct mem_cgroup_per_zone *mz;
-	enum lru_list lru;
 	int zone, tmp = node;
 	/*
 	 * This routine is called against possible nodes.
@@ -4756,8 +4755,7 @@ static int alloc_mem_cgroup_per_zone_inf
 
 	for (zone = 0; zone < MAX_NR_ZONES; zone++) {
 		mz = &pn->zoneinfo[zone];
-		for_each_lru(lru)
-			INIT_LIST_HEAD(&mz->lruvec.lists[lru]);
+		lruvec_init(&mz->lruvec, &NODE_DATA(node)->node_zones[zone]);
 		mz->usage_in_excess = 0;
 		mz->on_tree = false;
 		mz->memcg = memcg;
diff -puN mm/mmzone.c~mm-add-link-from-struct-lruvec-to-struct-zone mm/mmzone.c
--- a/mm/mmzone.c~mm-add-link-from-struct-lruvec-to-struct-zone
+++ a/mm/mmzone.c
@@ -86,3 +86,17 @@ int memmap_valid_within(unsigned long pf
 	return 1;
 }
 #endif /* CONFIG_ARCH_HAS_HOLES_MEMORYMODEL */
+
+void lruvec_init(struct lruvec *lruvec, struct zone *zone)
+{
+	enum lru_list lru;
+
+	memset(lruvec, 0, sizeof(struct lruvec));
+
+	for_each_lru(lru)
+		INIT_LIST_HEAD(&lruvec->lists[lru]);
+
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR
+	lruvec->zone = zone;
+#endif
+}
diff -puN mm/page_alloc.c~mm-add-link-from-struct-lruvec-to-struct-zone mm/page_alloc.c
--- a/mm/page_alloc.c~mm-add-link-from-struct-lruvec-to-struct-zone
+++ a/mm/page_alloc.c
@@ -4358,7 +4358,6 @@ static void __paginginit free_area_init_
 	for (j = 0; j < MAX_NR_ZONES; j++) {
 		struct zone *zone = pgdat->node_zones + j;
 		unsigned long size, realsize, memmap_pages;
-		enum lru_list lru;
 
 		size = zone_spanned_pages_in_node(nid, j, zones_size);
 		realsize = size - zone_absent_pages_in_node(nid, j,
@@ -4408,12 +4407,7 @@ static void __paginginit free_area_init_
 		zone->zone_pgdat = pgdat;
 
 		zone_pcp_init(zone);
-		for_each_lru(lru)
-			INIT_LIST_HEAD(&zone->lruvec.lists[lru]);
-		zone->lruvec.reclaim_stat.recent_rotated[0] = 0;
-		zone->lruvec.reclaim_stat.recent_rotated[1] = 0;
-		zone->lruvec.reclaim_stat.recent_scanned[0] = 0;
-		zone->lruvec.reclaim_stat.recent_scanned[1] = 0;
+		lruvec_init(&zone->lruvec, zone);
 		zap_zone_vm_stats(zone);
 		zone->flags = 0;
 		if (!size)
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch
linux-next.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
proc-report-file-anon-bit-in-proc-pid-pagemap.patch
proc-smaps-carefully-handle-migration-entries.patch
proc-smaps-show-amount-of-nonlinear-ptes-in-vma.patch
proc-smaps-show-amount-of-hwpoison-pages.patch
fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch

