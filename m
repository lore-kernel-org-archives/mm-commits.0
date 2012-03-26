From: akpm@linux-foundation.org
Subject: + mm-memcg-move-reclaim_stat-into-lruvec.patch added to -mm tree
Date: Mon, 26 Mar 2012 16:56:18 -0700
Message-ID: <20120326235618.4DD40A0363@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:48484 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757802Ab2CZX4T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 19:56:19 -0400
Received: by yenq2 with SMTP id q2so870429yen.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 16:56:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, glommer@parallels.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, khlebnikov@openvz.org, mhocko@suse.cz, minchan@kernel.org


The patch titled
     Subject: mm/memcg: move reclaim_stat into lruvec
has been added to the -mm tree.  Its filename is
     mm-memcg-move-reclaim_stat-into-lruvec.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/memcg: move reclaim_stat into lruvec

With mem_cgroup_disabled() now explicit, it becomes clear that the
zone_reclaim_stat structure actually belongs in lruvec, per-zone when
memcg is disabled but per-memcg per-zone when it's enabled.

We can delete mem_cgroup_get_reclaim_stat(), and change
update_page_reclaim_stat() to update just the one set of stats, the one
which get_scan_count() will actually use.

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: Glauber Costa <glommer@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    9 ---------
 include/linux/mmzone.h     |   29 ++++++++++++++---------------
 mm/memcontrol.c            |   27 +++++++--------------------
 mm/page_alloc.c            |    8 ++++----
 mm/swap.c                  |   14 ++++----------
 mm/vmscan.c                |    5 +----
 6 files changed, 30 insertions(+), 62 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcg-move-reclaim_stat-into-lruvec include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcg-move-reclaim_stat-into-lruvec
+++ a/include/linux/memcontrol.h
@@ -121,8 +121,6 @@ int mem_cgroup_inactive_file_is_low(stru
 int mem_cgroup_select_victim_node(struct mem_cgroup *memcg);
 unsigned long mem_cgroup_zone_nr_lru_pages(struct mem_cgroup *memcg,
 					int nid, int zid, unsigned int lrumask);
-struct zone_reclaim_stat *mem_cgroup_get_reclaim_stat(struct mem_cgroup *memcg,
-						      struct zone *zone);
 struct zone_reclaim_stat*
 mem_cgroup_get_reclaim_stat_from_page(struct page *page);
 extern void mem_cgroup_print_oom_info(struct mem_cgroup *memcg,
@@ -351,13 +349,6 @@ mem_cgroup_zone_nr_lru_pages(struct mem_
 	return 0;
 }
 
-
-static inline struct zone_reclaim_stat*
-mem_cgroup_get_reclaim_stat(struct mem_cgroup *memcg, struct zone *zone)
-{
-	return NULL;
-}
-
 static inline struct zone_reclaim_stat*
 mem_cgroup_get_reclaim_stat_from_page(struct page *page)
 {
diff -puN include/linux/mmzone.h~mm-memcg-move-reclaim_stat-into-lruvec include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-memcg-move-reclaim_stat-into-lruvec
+++ a/include/linux/mmzone.h
@@ -159,8 +159,22 @@ static inline int is_unevictable_lru(enu
 	return (lru == LRU_UNEVICTABLE);
 }
 
+struct zone_reclaim_stat {
+	/*
+	 * The pageout code in vmscan.c keeps track of how many of the
+	 * mem/swap backed and file backed pages are refeferenced.
+	 * The higher the rotated/scanned ratio, the more valuable
+	 * that cache is.
+	 *
+	 * The anon LRU stats live in [0], file LRU stats in [1]
+	 */
+	unsigned long		recent_rotated[2];
+	unsigned long		recent_scanned[2];
+};
+
 struct lruvec {
 	struct list_head lists[NR_LRU_LISTS];
+	struct zone_reclaim_stat reclaim_stat;
 };
 
 /* Mask used at gathering information at once (see memcontrol.c) */
@@ -287,19 +301,6 @@ enum zone_type {
 #error ZONES_SHIFT -- too many zones configured adjust calculation
 #endif
 
-struct zone_reclaim_stat {
-	/*
-	 * The pageout code in vmscan.c keeps track of how many of the
-	 * mem/swap backed and file backed pages are refeferenced.
-	 * The higher the rotated/scanned ratio, the more valuable
-	 * that cache is.
-	 *
-	 * The anon LRU stats live in [0], file LRU stats in [1]
-	 */
-	unsigned long		recent_rotated[2];
-	unsigned long		recent_scanned[2];
-};
-
 struct zone {
 	/* Fields commonly accessed by the page allocator */
 
@@ -374,8 +375,6 @@ struct zone {
 	spinlock_t		lru_lock;
 	struct lruvec		lruvec;
 
-	struct zone_reclaim_stat reclaim_stat;
-
 	unsigned long		pages_scanned;	   /* since last reclaim */
 	unsigned long		flags;		   /* zone flags, see below */
 
diff -puN mm/memcontrol.c~mm-memcg-move-reclaim_stat-into-lruvec mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-move-reclaim_stat-into-lruvec
+++ a/mm/memcontrol.c
@@ -138,7 +138,6 @@ struct mem_cgroup_per_zone {
 
 	struct mem_cgroup_reclaim_iter reclaim_iter[DEF_PRIORITY + 1];
 
-	struct zone_reclaim_stat reclaim_stat;
 	struct rb_node		tree_node;	/* RB tree node */
 	unsigned long long	usage_in_excess;/* Set to the value by which */
 						/* the soft limit is exceeded*/
@@ -1233,16 +1232,6 @@ int mem_cgroup_inactive_file_is_low(stru
 	return (active > inactive);
 }
 
-struct zone_reclaim_stat *mem_cgroup_get_reclaim_stat(struct mem_cgroup *memcg,
-						      struct zone *zone)
-{
-	int nid = zone_to_nid(zone);
-	int zid = zone_idx(zone);
-	struct mem_cgroup_per_zone *mz = mem_cgroup_zoneinfo(memcg, nid, zid);
-
-	return &mz->reclaim_stat;
-}
-
 struct zone_reclaim_stat *
 mem_cgroup_get_reclaim_stat_from_page(struct page *page)
 {
@@ -1258,7 +1247,7 @@ mem_cgroup_get_reclaim_stat_from_page(st
 	/* Ensure pc->mem_cgroup is visible after reading PCG_USED. */
 	smp_rmb();
 	mz = page_cgroup_zoneinfo(pc->mem_cgroup, page);
-	return &mz->reclaim_stat;
+	return &mz->lruvec.reclaim_stat;
 }
 
 #define mem_cgroup_from_res_counter(counter, member)	\
@@ -4187,21 +4176,19 @@ static int mem_control_stat_show(struct 
 	{
 		int nid, zid;
 		struct mem_cgroup_per_zone *mz;
+		struct zone_reclaim_stat *rstat;
 		unsigned long recent_rotated[2] = {0, 0};
 		unsigned long recent_scanned[2] = {0, 0};
 
 		for_each_online_node(nid)
 			for (zid = 0; zid < MAX_NR_ZONES; zid++) {
 				mz = mem_cgroup_zoneinfo(memcg, nid, zid);
+				rstat = &mz->lruvec.reclaim_stat;
 
-				recent_rotated[0] +=
-					mz->reclaim_stat.recent_rotated[0];
-				recent_rotated[1] +=
-					mz->reclaim_stat.recent_rotated[1];
-				recent_scanned[0] +=
-					mz->reclaim_stat.recent_scanned[0];
-				recent_scanned[1] +=
-					mz->reclaim_stat.recent_scanned[1];
+				recent_rotated[0] += rstat->recent_rotated[0];
+				recent_rotated[1] += rstat->recent_rotated[1];
+				recent_scanned[0] += rstat->recent_scanned[0];
+				recent_scanned[1] += rstat->recent_scanned[1];
 			}
 		cb->fill(cb, "recent_rotated_anon", recent_rotated[0]);
 		cb->fill(cb, "recent_rotated_file", recent_rotated[1]);
diff -puN mm/page_alloc.c~mm-memcg-move-reclaim_stat-into-lruvec mm/page_alloc.c
--- a/mm/page_alloc.c~mm-memcg-move-reclaim_stat-into-lruvec
+++ a/mm/page_alloc.c
@@ -4370,10 +4370,10 @@ static void __paginginit free_area_init_
 		zone_pcp_init(zone);
 		for_each_lru(lru)
 			INIT_LIST_HEAD(&zone->lruvec.lists[lru]);
-		zone->reclaim_stat.recent_rotated[0] = 0;
-		zone->reclaim_stat.recent_rotated[1] = 0;
-		zone->reclaim_stat.recent_scanned[0] = 0;
-		zone->reclaim_stat.recent_scanned[1] = 0;
+		zone->lruvec.reclaim_stat.recent_rotated[0] = 0;
+		zone->lruvec.reclaim_stat.recent_rotated[1] = 0;
+		zone->lruvec.reclaim_stat.recent_scanned[0] = 0;
+		zone->lruvec.reclaim_stat.recent_scanned[1] = 0;
 		zap_zone_vm_stats(zone);
 		zone->flags = 0;
 		if (!size)
diff -puN mm/swap.c~mm-memcg-move-reclaim_stat-into-lruvec mm/swap.c
--- a/mm/swap.c~mm-memcg-move-reclaim_stat-into-lruvec
+++ a/mm/swap.c
@@ -279,21 +279,15 @@ void rotate_reclaimable_page(struct page
 static void update_page_reclaim_stat(struct zone *zone, struct page *page,
 				     int file, int rotated)
 {
-	struct zone_reclaim_stat *reclaim_stat = &zone->reclaim_stat;
-	struct zone_reclaim_stat *memcg_reclaim_stat;
+	struct zone_reclaim_stat *reclaim_stat;
 
-	memcg_reclaim_stat = mem_cgroup_get_reclaim_stat_from_page(page);
+	reclaim_stat = mem_cgroup_get_reclaim_stat_from_page(page);
+	if (!reclaim_stat)
+		reclaim_stat = &zone->lruvec.reclaim_stat;
 
 	reclaim_stat->recent_scanned[file]++;
 	if (rotated)
 		reclaim_stat->recent_rotated[file]++;
-
-	if (!memcg_reclaim_stat)
-		return;
-
-	memcg_reclaim_stat->recent_scanned[file]++;
-	if (rotated)
-		memcg_reclaim_stat->recent_rotated[file]++;
 }
 
 static void __activate_page(struct page *page, void *arg)
diff -puN mm/vmscan.c~mm-memcg-move-reclaim_stat-into-lruvec mm/vmscan.c
--- a/mm/vmscan.c~mm-memcg-move-reclaim_stat-into-lruvec
+++ a/mm/vmscan.c
@@ -173,10 +173,7 @@ static bool global_reclaim(struct scan_c
 
 static struct zone_reclaim_stat *get_reclaim_stat(struct mem_cgroup_zone *mz)
 {
-	if (!mem_cgroup_disabled())
-		return mem_cgroup_get_reclaim_stat(mz->mem_cgroup, mz->zone);
-
-	return &mz->zone->reclaim_stat;
+	return &mem_cgroup_zone_lruvec(mz->zone, mz->mem_cgroup)->reclaim_stat;
 }
 
 static unsigned long zone_nr_lru_pages(struct mem_cgroup_zone *mz,
_
Subject: Subject: mm/memcg: move reclaim_stat into lruvec

Patches currently in -mm which might be from hughd@google.com are

origin.patch
mm-for-fs-add-truncate_pagecache_range.patch
mm-thp-fixup-pmd_trans_unstable-locations.patch
swapon-check-validity-of-swap_flags.patch
radix-tree-introduce-bit-optimized-iterator.patch
radix-tree-introduce-bit-optimized-iterator-v3.patch
radix-tree-introduce-bit-optimized-iterator-v3-fix.patch
radix-tree-rewrite-gang-lookup-with-using-iterator.patch
radix-tree-use-iterators-in-find_get_pages-functions.patch
linux-next.patch
memcg-fix-change-behavior-of-shared-anon-at-moving-task.patch
memcg-swap-mem_cgroup_move_swap_account-never-needs-fixup.patch
memcg-swap-use-mem_cgroup_uncharge_swap.patch
mm-memcg-scanning_global_lru-means-mem_cgroup_disabled.patch
mm-memcg-move-reclaim_stat-into-lruvec.patch
mm-push-lru-index-into-shrink_active_list.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
mm-mark-mm-inline-functions-as-__always_inline.patch
mm-remove-lru-type-checks-from-__isolate_lru_page.patch
mm-memcg-kill-mem_cgroup_lru_del.patch
mm-memcg-use-vm_swappiness-from-target-memory-cgroup.patch
prio_tree-debugging-patch.patch

