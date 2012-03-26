From: akpm@linux-foundation.org
Subject: + mm-remove-lru-type-checks-from-__isolate_lru_page.patch added to -mm tree
Date: Mon, 26 Mar 2012 16:56:28 -0700
Message-ID: <20120326235628.4EB6AA0363@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:59684 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757854Ab2CZX4a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 19:56:30 -0400
Received: by eaaq10 with SMTP id q10so296109eaa.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 16:56:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, glommer@parallels.com, hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, minchan@kernel.org


The patch titled
     Subject: mm: remove lru type checks from __isolate_lru_page()
has been added to the -mm tree.  Its filename is
     mm-remove-lru-type-checks-from-__isolate_lru_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: mm: remove lru type checks from __isolate_lru_page()

After patch "mm: forbid lumpy-reclaim in shrink_active_list()" we can
completely remove anon/file and active/inactive lru type filters from
__isolate_lru_page(), because isolation for 0-order reclaim always
isolates pages from right lru list.  And pages-isolation for lumpy
shrink_inactive_list() or memory-compaction anyway allowed to isolate
pages from all evictable lru lists.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Glauber Costa <glommer@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   10 +++-------
 include/linux/swap.h   |    2 +-
 mm/compaction.c        |    4 ++--
 mm/vmscan.c            |   27 +++++----------------------
 4 files changed, 11 insertions(+), 32 deletions(-)

diff -puN include/linux/mmzone.h~mm-remove-lru-type-checks-from-__isolate_lru_page include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-remove-lru-type-checks-from-__isolate_lru_page
+++ a/include/linux/mmzone.h
@@ -183,16 +183,12 @@ struct lruvec {
 #define LRU_ALL_EVICTABLE (LRU_ALL_FILE | LRU_ALL_ANON)
 #define LRU_ALL	     ((1 << NR_LRU_LISTS) - 1)
 
-/* Isolate inactive pages */
-#define ISOLATE_INACTIVE	((__force isolate_mode_t)0x1)
-/* Isolate active pages */
-#define ISOLATE_ACTIVE		((__force isolate_mode_t)0x2)
 /* Isolate clean file */
-#define ISOLATE_CLEAN		((__force isolate_mode_t)0x4)
+#define ISOLATE_CLEAN		((__force isolate_mode_t)0x1)
 /* Isolate unmapped file */
-#define ISOLATE_UNMAPPED	((__force isolate_mode_t)0x8)
+#define ISOLATE_UNMAPPED	((__force isolate_mode_t)0x2)
 /* Isolate for asynchronous migration */
-#define ISOLATE_ASYNC_MIGRATE	((__force isolate_mode_t)0x10)
+#define ISOLATE_ASYNC_MIGRATE	((__force isolate_mode_t)0x4)
 
 /* LRU Isolation modes. */
 typedef unsigned __bitwise__ isolate_mode_t;
diff -puN include/linux/swap.h~mm-remove-lru-type-checks-from-__isolate_lru_page include/linux/swap.h
--- a/include/linux/swap.h~mm-remove-lru-type-checks-from-__isolate_lru_page
+++ a/include/linux/swap.h
@@ -253,7 +253,7 @@ static inline void lru_cache_add_file(st
 /* linux/mm/vmscan.c */
 extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 					gfp_t gfp_mask, nodemask_t *mask);
-extern int __isolate_lru_page(struct page *page, isolate_mode_t mode, int file);
+extern int __isolate_lru_page(struct page *page, isolate_mode_t mode);
 extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem,
 						  gfp_t gfp_mask, bool noswap);
 extern unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *mem,
diff -puN mm/compaction.c~mm-remove-lru-type-checks-from-__isolate_lru_page mm/compaction.c
--- a/mm/compaction.c~mm-remove-lru-type-checks-from-__isolate_lru_page
+++ a/mm/compaction.c
@@ -261,7 +261,7 @@ static isolate_migrate_t isolate_migrate
 	unsigned long last_pageblock_nr = 0, pageblock_nr;
 	unsigned long nr_scanned = 0, nr_isolated = 0;
 	struct list_head *migratelist = &cc->migratepages;
-	isolate_mode_t mode = ISOLATE_ACTIVE|ISOLATE_INACTIVE;
+	isolate_mode_t mode = 0;
 
 	/* Do not scan outside zone boundaries */
 	low_pfn = max(cc->migrate_pfn, zone->zone_start_pfn);
@@ -375,7 +375,7 @@ static isolate_migrate_t isolate_migrate
 			mode |= ISOLATE_ASYNC_MIGRATE;
 
 		/* Try isolate the page */
-		if (__isolate_lru_page(page, mode, 0) != 0)
+		if (__isolate_lru_page(page, mode) != 0)
 			continue;
 
 		VM_BUG_ON(PageTransCompound(page));
diff -puN mm/vmscan.c~mm-remove-lru-type-checks-from-__isolate_lru_page mm/vmscan.c
--- a/mm/vmscan.c~mm-remove-lru-type-checks-from-__isolate_lru_page
+++ a/mm/vmscan.c
@@ -1028,29 +1028,14 @@ keep_lumpy:
  *
  * returns 0 on success, -ve errno on failure.
  */
-int __isolate_lru_page(struct page *page, isolate_mode_t mode, int file)
+int __isolate_lru_page(struct page *page, isolate_mode_t mode)
 {
-	bool all_lru_mode;
 	int ret = -EINVAL;
 
 	/* Only take pages on the LRU. */
 	if (!PageLRU(page))
 		return ret;
 
-	all_lru_mode = (mode & (ISOLATE_ACTIVE|ISOLATE_INACTIVE)) ==
-		(ISOLATE_ACTIVE|ISOLATE_INACTIVE);
-
-	/*
-	 * When checking the active state, we need to be sure we are
-	 * dealing with comparible boolean values.  Take the logical not
-	 * of each.
-	 */
-	if (!all_lru_mode && !PageActive(page) != !(mode & ISOLATE_ACTIVE))
-		return ret;
-
-	if (!all_lru_mode && !!page_is_file_cache(page) != file)
-		return ret;
-
 	/*
 	 * When this function is being called for lumpy reclaim, we
 	 * initially look into all LRU pages, active, inactive and
@@ -1160,7 +1145,7 @@ static unsigned long isolate_lru_pages(u
 
 		VM_BUG_ON(!PageLRU(page));
 
-		switch (__isolate_lru_page(page, mode, file)) {
+		switch (__isolate_lru_page(page, mode)) {
 		case 0:
 			mem_cgroup_lru_del(page);
 			list_move(&page->lru, dst);
@@ -1218,7 +1203,7 @@ static unsigned long isolate_lru_pages(u
 			    !PageSwapCache(cursor_page))
 				break;
 
-			if (__isolate_lru_page(cursor_page, mode, file) == 0) {
+			if (__isolate_lru_page(cursor_page, mode) == 0) {
 				unsigned int isolated_pages;
 
 				mem_cgroup_lru_del(cursor_page);
@@ -1492,7 +1477,7 @@ shrink_inactive_list(unsigned long nr_to
 	unsigned long nr_file;
 	unsigned long nr_dirty = 0;
 	unsigned long nr_writeback = 0;
-	isolate_mode_t isolate_mode = ISOLATE_INACTIVE;
+	isolate_mode_t isolate_mode = 0;
 	int file = is_file_lru(lru);
 	struct zone *zone = mz->zone;
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(mz);
@@ -1506,8 +1491,6 @@ shrink_inactive_list(unsigned long nr_to
 	}
 
 	set_reclaim_mode(priority, sc, false);
-	if (sc->reclaim_mode & RECLAIM_MODE_LUMPYRECLAIM)
-		isolate_mode |= ISOLATE_ACTIVE;
 
 	lru_add_drain();
 
@@ -1668,7 +1651,7 @@ static void shrink_active_list(unsigned 
 	struct page *page;
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(mz);
 	unsigned long nr_rotated = 0;
-	isolate_mode_t isolate_mode = ISOLATE_ACTIVE;
+	isolate_mode_t isolate_mode = 0;
 	int file = is_file_lru(lru);
 	struct zone *zone = mz->zone;
 
_
Subject: Subject: mm: remove lru type checks from __isolate_lru_page()

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch
radix-tree-introduce-bit-optimized-iterator.patch
radix-tree-introduce-bit-optimized-iterator-v3.patch
radix-tree-introduce-bit-optimized-iterator-v3-fix.patch
radix-tree-rewrite-gang-lookup-with-using-iterator.patch
radix-tree-use-iterators-in-find_get_pages-functions.patch
linux-next.patch
mm-fix-page-faults-detection-in-swap-token-logic.patch
mm-memcg-scanning_global_lru-means-mem_cgroup_disabled.patch
mm-memcg-move-reclaim_stat-into-lruvec.patch
mm-push-lru-index-into-shrink_active_list.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
mm-mark-mm-inline-functions-as-__always_inline.patch
mm-remove-lru-type-checks-from-__isolate_lru_page.patch
mm-memcg-kill-mem_cgroup_lru_del.patch
mm-memcg-use-vm_swappiness-from-target-memory-cgroup.patch

