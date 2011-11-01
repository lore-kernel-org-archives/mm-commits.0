From: akpm@linux-foundation.org
Subject: [merged] mm-change-isolate-mode-from-define-to-bitwise-type.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:07:42 -0700
Message-ID: <201111012107.pA1L7gQo002812@hpaq11.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:28653 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931Ab1KAVIl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:08:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan.kim@gmail.com, aarcange@redhat.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de, mhocko@suse.cz, riel@redhat.com, mm-co


The patch titled
     Subject: mm: change isolate mode from #define to bitwise type
has been removed from the -mm tree.  Its filename was
     mm-change-isolate-mode-from-define-to-bitwise-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Minchan Kim <minchan.kim@gmail.com>
Subject: mm: change isolate mode from #define to bitwise type

Change ISOLATE_XXX macro with bitwise isolate_mode_t type.  Normally,
macro isn't recommended as it's type-unsafe and making debugging harder as
symbol cannot be passed throught to the debugger.

Quote from Johannes
" Hmm, it would probably be cleaner to fully convert the isolation mode
into independent flags.  INACTIVE, ACTIVE, BOTH is currently a
tri-state among flags, which is a bit ugly."

This patch moves isolate mode from swap.h to mmzone.h by memcontrol.h

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/trace/postprocess/trace-vmscan-postprocess.pl |    8 +-
 include/linux/memcontrol.h                                  |    3 
 include/linux/mmzone.h                                      |    8 ++
 include/linux/swap.h                                        |    7 -
 include/trace/events/vmscan.h                               |    8 +-
 mm/compaction.c                                             |    3 
 mm/memcontrol.c                                             |    3 
 mm/vmscan.c                                                 |   37 +++++-----
 8 files changed, 43 insertions(+), 34 deletions(-)

diff -puN Documentation/trace/postprocess/trace-vmscan-postprocess.pl~mm-change-isolate-mode-from-define-to-bitwise-type Documentation/trace/postprocess/trace-vmscan-postprocess.pl
--- a/Documentation/trace/postprocess/trace-vmscan-postprocess.pl~mm-change-isolate-mode-from-define-to-bitwise-type
+++ a/Documentation/trace/postprocess/trace-vmscan-postprocess.pl
@@ -379,10 +379,10 @@ EVENT_PROCESS:
 
 			# To closer match vmstat scanning statistics, only count isolate_both
 			# and isolate_inactive as scanning. isolate_active is rotation
-			# isolate_inactive == 0
-			# isolate_active   == 1
-			# isolate_both     == 2
-			if ($isolate_mode != 1) {
+			# isolate_inactive == 1
+			# isolate_active   == 2
+			# isolate_both     == 3
+			if ($isolate_mode != 2) {
 				$perprocesspid{$process_pid}->{HIGH_NR_SCANNED} += $nr_scanned;
 			}
 			$perprocesspid{$process_pid}->{HIGH_NR_CONTIG_DIRTY} += $nr_contig_dirty;
diff -puN include/linux/memcontrol.h~mm-change-isolate-mode-from-define-to-bitwise-type include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-change-isolate-mode-from-define-to-bitwise-type
+++ a/include/linux/memcontrol.h
@@ -35,7 +35,8 @@ enum mem_cgroup_page_stat_item {
 extern unsigned long mem_cgroup_isolate_pages(unsigned long nr_to_scan,
 					struct list_head *dst,
 					unsigned long *scanned, int order,
-					int mode, struct zone *z,
+					isolate_mode_t mode,
+					struct zone *z,
 					struct mem_cgroup *mem_cont,
 					int active, int file);
 
diff -puN include/linux/mmzone.h~mm-change-isolate-mode-from-define-to-bitwise-type include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-change-isolate-mode-from-define-to-bitwise-type
+++ a/include/linux/mmzone.h
@@ -164,6 +164,14 @@ static inline int is_unevictable_lru(enu
 #define LRU_ALL_EVICTABLE (LRU_ALL_FILE | LRU_ALL_ANON)
 #define LRU_ALL	     ((1 << NR_LRU_LISTS) - 1)
 
+/* Isolate inactive pages */
+#define ISOLATE_INACTIVE	((__force isolate_mode_t)0x1)
+/* Isolate active pages */
+#define ISOLATE_ACTIVE		((__force isolate_mode_t)0x2)
+
+/* LRU Isolation modes. */
+typedef unsigned __bitwise__ isolate_mode_t;
+
 enum zone_watermarks {
 	WMARK_MIN,
 	WMARK_LOW,
diff -puN include/linux/swap.h~mm-change-isolate-mode-from-define-to-bitwise-type include/linux/swap.h
--- a/include/linux/swap.h~mm-change-isolate-mode-from-define-to-bitwise-type
+++ a/include/linux/swap.h
@@ -243,15 +243,10 @@ static inline void lru_cache_add_file(st
 	__lru_cache_add(page, LRU_INACTIVE_FILE);
 }
 
-/* LRU Isolation modes. */
-#define ISOLATE_INACTIVE 0	/* Isolate inactive pages. */
-#define ISOLATE_ACTIVE 1	/* Isolate active pages. */
-#define ISOLATE_BOTH 2		/* Isolate both active and inactive pages. */
-
 /* linux/mm/vmscan.c */
 extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 					gfp_t gfp_mask, nodemask_t *mask);
-extern int __isolate_lru_page(struct page *page, int mode, int file);
+extern int __isolate_lru_page(struct page *page, isolate_mode_t mode, int file);
 extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem,
 						  gfp_t gfp_mask, bool noswap);
 extern unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *mem,
diff -puN include/trace/events/vmscan.h~mm-change-isolate-mode-from-define-to-bitwise-type include/trace/events/vmscan.h
--- a/include/trace/events/vmscan.h~mm-change-isolate-mode-from-define-to-bitwise-type
+++ a/include/trace/events/vmscan.h
@@ -266,7 +266,7 @@ DECLARE_EVENT_CLASS(mm_vmscan_lru_isolat
 		unsigned long nr_lumpy_taken,
 		unsigned long nr_lumpy_dirty,
 		unsigned long nr_lumpy_failed,
-		int isolate_mode),
+		isolate_mode_t isolate_mode),
 
 	TP_ARGS(order, nr_requested, nr_scanned, nr_taken, nr_lumpy_taken, nr_lumpy_dirty, nr_lumpy_failed, isolate_mode),
 
@@ -278,7 +278,7 @@ DECLARE_EVENT_CLASS(mm_vmscan_lru_isolat
 		__field(unsigned long, nr_lumpy_taken)
 		__field(unsigned long, nr_lumpy_dirty)
 		__field(unsigned long, nr_lumpy_failed)
-		__field(int, isolate_mode)
+		__field(isolate_mode_t, isolate_mode)
 	),
 
 	TP_fast_assign(
@@ -312,7 +312,7 @@ DEFINE_EVENT(mm_vmscan_lru_isolate_templ
 		unsigned long nr_lumpy_taken,
 		unsigned long nr_lumpy_dirty,
 		unsigned long nr_lumpy_failed,
-		int isolate_mode),
+		isolate_mode_t isolate_mode),
 
 	TP_ARGS(order, nr_requested, nr_scanned, nr_taken, nr_lumpy_taken, nr_lumpy_dirty, nr_lumpy_failed, isolate_mode)
 
@@ -327,7 +327,7 @@ DEFINE_EVENT(mm_vmscan_lru_isolate_templ
 		unsigned long nr_lumpy_taken,
 		unsigned long nr_lumpy_dirty,
 		unsigned long nr_lumpy_failed,
-		int isolate_mode),
+		isolate_mode_t isolate_mode),
 
 	TP_ARGS(order, nr_requested, nr_scanned, nr_taken, nr_lumpy_taken, nr_lumpy_dirty, nr_lumpy_failed, isolate_mode)
 
diff -puN mm/compaction.c~mm-change-isolate-mode-from-define-to-bitwise-type mm/compaction.c
--- a/mm/compaction.c~mm-change-isolate-mode-from-define-to-bitwise-type
+++ a/mm/compaction.c
@@ -349,7 +349,8 @@ static isolate_migrate_t isolate_migrate
 		}
 
 		/* Try isolate the page */
-		if (__isolate_lru_page(page, ISOLATE_BOTH, 0) != 0)
+		if (__isolate_lru_page(page,
+				ISOLATE_ACTIVE|ISOLATE_INACTIVE, 0) != 0)
 			continue;
 
 		VM_BUG_ON(PageTransCompound(page));
diff -puN mm/memcontrol.c~mm-change-isolate-mode-from-define-to-bitwise-type mm/memcontrol.c
--- a/mm/memcontrol.c~mm-change-isolate-mode-from-define-to-bitwise-type
+++ a/mm/memcontrol.c
@@ -1185,7 +1185,8 @@ mem_cgroup_get_reclaim_stat_from_page(st
 unsigned long mem_cgroup_isolate_pages(unsigned long nr_to_scan,
 					struct list_head *dst,
 					unsigned long *scanned, int order,
-					int mode, struct zone *z,
+					isolate_mode_t mode,
+					struct zone *z,
 					struct mem_cgroup *mem_cont,
 					int active, int file)
 {
diff -puN mm/vmscan.c~mm-change-isolate-mode-from-define-to-bitwise-type mm/vmscan.c
--- a/mm/vmscan.c~mm-change-isolate-mode-from-define-to-bitwise-type
+++ a/mm/vmscan.c
@@ -1012,23 +1012,27 @@ keep_lumpy:
  *
  * returns 0 on success, -ve errno on failure.
  */
-int __isolate_lru_page(struct page *page, int mode, int file)
+int __isolate_lru_page(struct page *page, isolate_mode_t mode, int file)
 {
+	bool all_lru_mode;
 	int ret = -EINVAL;
 
 	/* Only take pages on the LRU. */
 	if (!PageLRU(page))
 		return ret;
 
+	all_lru_mode = (mode & (ISOLATE_ACTIVE|ISOLATE_INACTIVE)) ==
+		(ISOLATE_ACTIVE|ISOLATE_INACTIVE);
+
 	/*
 	 * When checking the active state, we need to be sure we are
 	 * dealing with comparible boolean values.  Take the logical not
 	 * of each.
 	 */
-	if (mode != ISOLATE_BOTH && (!PageActive(page) != !mode))
+	if (!all_lru_mode && !PageActive(page) != !(mode & ISOLATE_ACTIVE))
 		return ret;
 
-	if (mode != ISOLATE_BOTH && page_is_file_cache(page) != file)
+	if (!all_lru_mode && !!page_is_file_cache(page) != file)
 		return ret;
 
 	/*
@@ -1076,7 +1080,8 @@ int __isolate_lru_page(struct page *page
  */
 static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 		struct list_head *src, struct list_head *dst,
-		unsigned long *scanned, int order, int mode, int file)
+		unsigned long *scanned, int order, isolate_mode_t mode,
+		int file)
 {
 	unsigned long nr_taken = 0;
 	unsigned long nr_lumpy_taken = 0;
@@ -1201,8 +1206,8 @@ static unsigned long isolate_lru_pages(u
 static unsigned long isolate_pages_global(unsigned long nr,
 					struct list_head *dst,
 					unsigned long *scanned, int order,
-					int mode, struct zone *z,
-					int active, int file)
+					isolate_mode_t mode,
+					struct zone *z,	int active, int file)
 {
 	int lru = LRU_BASE;
 	if (active)
@@ -1448,6 +1453,7 @@ shrink_inactive_list(unsigned long nr_to
 	unsigned long nr_taken;
 	unsigned long nr_anon;
 	unsigned long nr_file;
+	isolate_mode_t reclaim_mode = ISOLATE_INACTIVE;
 
 	while (unlikely(too_many_isolated(zone, file, sc))) {
 		congestion_wait(BLK_RW_ASYNC, HZ/10);
@@ -1458,15 +1464,15 @@ shrink_inactive_list(unsigned long nr_to
 	}
 
 	set_reclaim_mode(priority, sc, false);
+	if (sc->reclaim_mode & RECLAIM_MODE_LUMPYRECLAIM)
+		reclaim_mode |= ISOLATE_ACTIVE;
+
 	lru_add_drain();
 	spin_lock_irq(&zone->lru_lock);
 
 	if (scanning_global_lru(sc)) {
-		nr_taken = isolate_pages_global(nr_to_scan,
-			&page_list, &nr_scanned, sc->order,
-			sc->reclaim_mode & RECLAIM_MODE_LUMPYRECLAIM ?
-					ISOLATE_BOTH : ISOLATE_INACTIVE,
-			zone, 0, file);
+		nr_taken = isolate_pages_global(nr_to_scan, &page_list,
+			&nr_scanned, sc->order, reclaim_mode, zone, 0, file);
 		zone->pages_scanned += nr_scanned;
 		if (current_is_kswapd())
 			__count_zone_vm_events(PGSCAN_KSWAPD, zone,
@@ -1475,12 +1481,9 @@ shrink_inactive_list(unsigned long nr_to
 			__count_zone_vm_events(PGSCAN_DIRECT, zone,
 					       nr_scanned);
 	} else {
-		nr_taken = mem_cgroup_isolate_pages(nr_to_scan,
-			&page_list, &nr_scanned, sc->order,
-			sc->reclaim_mode & RECLAIM_MODE_LUMPYRECLAIM ?
-					ISOLATE_BOTH : ISOLATE_INACTIVE,
-			zone, sc->mem_cgroup,
-			0, file);
+		nr_taken = mem_cgroup_isolate_pages(nr_to_scan, &page_list,
+			&nr_scanned, sc->order, reclaim_mode, zone,
+			sc->mem_cgroup, 0, file);
 		/*
 		 * mem_cgroup_isolate_pages() keeps track of
 		 * scanned pages on its own.
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

origin.patch
vmscan-promote-shared-file-mapped-pages.patch
vmscan-activate-executable-pages-after-first-usage.patch
mm-add-free_hot_cold_page_list-helper.patch
thp-tail-page-refcounting-fix-5.patch
memcg-skip-scanning-active-lists-based-on-individual-size.patch
memcg-skip-scanning-active-lists-based-on-individual-size-fix.patch

