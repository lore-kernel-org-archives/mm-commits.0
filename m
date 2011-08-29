From: akpm@linux-foundation.org
Subject: + mm-compaction-compact-unevictable-pages.patch added to -mm tree
Date: Mon, 29 Aug 2011 13:42:26 -0700
Message-ID: <201108292042.p7TKgQnU025280@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50418 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754711Ab1H2UnE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Aug 2011 16:43:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan.kim@gmail.com, jweiner@redhat.com, mgorman@suse.de, riel@redhat.com


The patch titled
     mm: compaction: compact unevictable pages
has been added to the -mm tree.  Its filename is
     mm-compaction-compact-unevictable-pages.patch

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
Subject: mm: compaction: compact unevictable pages
From: Minchan Kim <minchan.kim@gmail.com>

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
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    6 ++++--
 mm/compaction.c        |    3 ++-
 mm/vmscan.c            |    7 +------
 3 files changed, 7 insertions(+), 9 deletions(-)

diff -puN include/linux/mmzone.h~compaction-compact-unevictable-page include/linux/mmzone.h
--- a/include/linux/mmzone.h~compaction-compact-unevictable-page
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
diff -puN mm/compaction.c~compaction-compact-unevictable-page mm/compaction.c
--- a/mm/compaction.c~compaction-compact-unevictable-page
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
diff -puN mm/vmscan.c~compaction-compact-unevictable-page mm/vmscan.c
--- a/mm/vmscan.c~compaction-compact-unevictable-page
+++ a/mm/vmscan.c
@@ -1039,12 +1039,7 @@ int __isolate_lru_page(struct page *page
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

mm-mempolicyc-fix-pgoff-in-mbind-vma-merge.patch
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
mm-compaction-compact-unevictable-pages.patch

