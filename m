From: akpm@google.com
Subject: [withdrawn] mm-compaction-compact-unevictable-pages.patch removed from -mm tree
Date: Thu, 06 Oct 2011 16:15:17 -0700
Message-ID: <201110062315.p96NFIq8007532@hpaq1.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:11294 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab1JFXPe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Oct 2011 19:15:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan.kim@gmail.com, jweiner@redhat.com, mgorman@suse.de, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: compact unevictable pages
has been removed from the -mm tree.  Its filename was
     mm-compaction-compact-unevictable-pages.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Minchan Kim <minchan.kim@gmail.com>
Subject: mm: compaction: compact unevictable pages

Presently compaction doesn't handle mlocked pages as it uses
__isolate_lru_page which doesn't consider unevicatable pages.  It is used
by just lumpy so it is pointless that it isolates unevictable pages.  

But the situation has changed.  Compaction can handle unevictable pages
and it can help getting big contiguos pages in memory whcih is fragmented
by many pinned pages with mlock.

I tested this patch with following scenario.

1. A : allocate 80% anon pages in system
2. B : allocate 20% mlocked page in system
/* Maybe, mlocked pages are located in low pfn address */
3. kill A /* high pfn address are free */
4. echo 1 > /proc/sys/vm/compact_memory

old:

compact_blocks_moved 251
compact_pages_moved 44

new:

compact_blocks_moved 258
compact_pages_moved 412

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <jweiner@redhat.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 include/linux/mmzone.h |    6 ++++--
 mm/compaction.c        |    3 ++-
 mm/vmscan.c            |    7 +------
 3 files changed, 7 insertions(+), 9 deletions(-)

diff -puN include/linux/mmzone.h~mm-compaction-compact-unevictable-pages include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-compaction-compact-unevictable-pages
+++ a/include/linux/mmzone.h
@@ -169,10 +169,12 @@ static inline int is_unevictable_lru(enu
 #define ISOLATE_INACTIVE	((__force isolate_mode_t)0x1)
 /* Isolate active pages */
 #define ISOLATE_ACTIVE		((__force isolate_mode_t)0x2)
+/* Isolate unevictable pages */
+#define ISOLATE_UNEVICTABLE	((__force isolate_mode_t)0x4)
 /* Isolate clean file */
-#define ISOLATE_CLEAN		((__force isolate_mode_t)0x4)
+#define ISOLATE_CLEAN		((__force isolate_mode_t)0x8)
 /* Isolate unmapped file */
-#define ISOLATE_UNMAPPED	((__force isolate_mode_t)0x8)
+#define ISOLATE_UNMAPPED	((__force isolate_mode_t)0x10)
 
 /* LRU Isolation modes. */
 typedef unsigned __bitwise__ isolate_mode_t;
diff -puN mm/compaction.c~mm-compaction-compact-unevictable-pages mm/compaction.c
--- a/mm/compaction.c~mm-compaction-compact-unevictable-pages
+++ a/mm/compaction.c
@@ -261,7 +261,8 @@ static isolate_migrate_t isolate_migrate
 	unsigned long last_pageblock_nr = 0, pageblock_nr;
 	unsigned long nr_scanned = 0, nr_isolated = 0;
 	struct list_head *migratelist = &cc->migratepages;
-	isolate_mode_t mode = ISOLATE_ACTIVE|ISOLATE_INACTIVE;
+	isolate_mode_t mode = ISOLATE_ACTIVE| ISOLATE_INACTIVE |
+				ISOLATE_UNEVICTABLE;
 
 	/* Do not scan outside zone boundaries */
 	low_pfn = max(cc->migrate_pfn, zone->zone_start_pfn);
diff -puN mm/vmscan.c~mm-compaction-compact-unevictable-pages mm/vmscan.c
--- a/mm/vmscan.c~mm-compaction-compact-unevictable-pages
+++ a/mm/vmscan.c
@@ -1038,12 +1038,7 @@ int __isolate_lru_page(struct page *page
 	if (!all_lru_mode && !!page_is_file_cache(page) != file)
 		return ret;
 
-	/*
-	 * When this function is being called for lumpy reclaim, we
-	 * initially look into all LRU pages, active, inactive and
-	 * unevictable; only give shrink_page_list evictable pages.
-	 */
-	if (PageUnevictable(page))
+	if (PageUnevictable(page) && !(mode & ISOLATE_UNEVICTABLE))
 		return ret;
 
 	ret = -EBUSY;
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

origin.patch
mm-compaction-trivial-clean-up-in-acct_isolated.patch
mm-change-isolate-mode-from-define-to-bitwise-type.patch
mm-change-isolate-mode-from-define-to-bitwise-type-fix.patch
mm-compaction-make-isolate_lru_page-filter-aware.patch
mm-compaction-make-isolate_lru_page-filter-aware-fix.patch
mm-zone_reclaim-make-isolate_lru_page-filter-aware.patch
mm-zone_reclaim-make-isolate_lru_page-filter-aware-fix.patch
mm-migration-clean-up-unmap_and_move.patch
vmscan-add-block-plug-for-page-reclaim.patch
mm-vmscan-drop-nr_force_scan-from-get_scan_count.patch
mm-vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
mm-vmscan-remove-dead-code-related-to-lumpy-reclaim-waiting-on-pages-under-writeback.patch
xfs-warn-if-direct-reclaim-tries-to-writeback-pages.patch
ext4-warn-if-direct-reclaim-tries-to-writeback-pages.patch
mm-vmscan-do-not-writeback-filesystem-pages-in-kswapd-except-in-high-priority.patch
mm-vmscan-throttle-reclaim-if-encountering-too-many-dirty-pages-under-writeback.patch
mm-vmscan-immediately-reclaim-end-of-lru-dirty-pages-when-writeback-completes.patch
vmscan-count-pages-into-balanced-for-zone-with-good-watermark.patch
vmscan-promote-shared-file-mapped-pages.patch
vmscan-activate-executable-pages-after-first-usage.patch
mm-add-free_hot_cold_page_list-helper.patch
mm-compaction-compact-unevictable-pages-checkpatch-fixes.patch
mm-compaction-accounting-fix.patch
kswapd-assign-new_order-and-new_classzone_idx-after-wakeup-in-sleeping.patch
thp-tail-page-refcounting-fix-5.patch
thp-tail-page-refcounting-fix-6.patch
mm-compaction-make-compact_zone_order-static.patch
mm-disable-user-interface-to-manually-rescue-unevictable-pages.patch
vmscan-add-barrier-to-prevent-evictable-page-in-unevictable-list.patch
memcg-skip-scanning-active-lists-based-on-individual-size.patch
memcg-skip-scanning-active-lists-based-on-individual-size-fix.patch

