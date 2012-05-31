From: akpm@linux-foundation.org
Subject: [merged] mm-remove-lru-type-checks-from-__isolate_lru_page.patch removed from -mm tree
Date: Thu, 31 May 2012 12:16:58 -0700
Message-ID: <20120531191658.77808A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:34772 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932967Ab2EaTRA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 May 2012 15:17:00 -0400
Received: by mail-lpp01m010-f74.google.com with SMTP id r15so75709lag.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:16:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, glommer@parallels.com, hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove lru type checks from __isolate_lru_page()
has been removed from the -mm tree.  Its filename was
     mm-remove-lru-type-checks-from-__isolate_lru_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
 mm/vmscan.c            |   23 ++++-------------------
 4 files changed, 10 insertions(+), 29 deletions(-)

diff -puN include/linux/mmzone.h~mm-remove-lru-type-checks-from-__isolate_lru_page include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-remove-lru-type-checks-from-__isolate_lru_page
+++ a/include/linux/mmzone.h
@@ -209,16 +209,12 @@ struct lruvec {
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
@@ -251,7 +251,7 @@ static inline void lru_cache_add_file(st
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
@@ -226,7 +226,7 @@ isolate_migratepages_range(struct zone *
 	unsigned long last_pageblock_nr = 0, pageblock_nr;
 	unsigned long nr_scanned = 0, nr_isolated = 0;
 	struct list_head *migratelist = &cc->migratepages;
-	isolate_mode_t mode = ISOLATE_ACTIVE|ISOLATE_INACTIVE;
+	isolate_mode_t mode = 0;
 
 	/*
 	 * Ensure that there are not too many pages isolated from the LRU
@@ -329,7 +329,7 @@ isolate_migratepages_range(struct zone *
 			mode |= ISOLATE_ASYNC_MIGRATE;
 
 		/* Try isolate the page */
-		if (__isolate_lru_page(page, mode, 0) != 0)
+		if (__isolate_lru_page(page, mode) != 0)
 			continue;
 
 		VM_BUG_ON(PageTransCompound(page));
diff -puN mm/vmscan.c~mm-remove-lru-type-checks-from-__isolate_lru_page mm/vmscan.c
--- a/mm/vmscan.c~mm-remove-lru-type-checks-from-__isolate_lru_page
+++ a/mm/vmscan.c
@@ -949,29 +949,14 @@ keep:
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
 	/* Do not give back unevictable pages for compaction */
 	if (PageUnevictable(page))
 		return ret;
@@ -1070,7 +1055,7 @@ static unsigned long isolate_lru_pages(u
 
 		VM_BUG_ON(!PageLRU(page));
 
-		switch (__isolate_lru_page(page, mode, file)) {
+		switch (__isolate_lru_page(page, mode)) {
 		case 0:
 			mem_cgroup_lru_del(page);
 			list_move(&page->lru, dst);
@@ -1282,7 +1267,7 @@ shrink_inactive_list(unsigned long nr_to
 	unsigned long nr_file;
 	unsigned long nr_dirty = 0;
 	unsigned long nr_writeback = 0;
-	isolate_mode_t isolate_mode = ISOLATE_INACTIVE;
+	isolate_mode_t isolate_mode = 0;
 	int file = is_file_lru(lru);
 	struct zone *zone = mz->zone;
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(mz);
@@ -1452,7 +1437,7 @@ static void shrink_active_list(unsigned 
 	struct page *page;
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(mz);
 	unsigned long nr_rotated = 0;
-	isolate_mode_t isolate_mode = ISOLATE_ACTIVE;
+	isolate_mode_t isolate_mode = 0;
 	int file = is_file_lru(lru);
 	struct zone *zone = mz->zone;
 
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

