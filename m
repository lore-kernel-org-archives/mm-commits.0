From: akpm@google.com
Subject: [to-be-updated] mm-compaction-accounting-fix.patch removed from -mm tree
Date: Thu, 06 Oct 2011 16:15:34 -0700
Message-ID: <201110062315.p96NFYkd017588@wpaz17.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:11410 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758991Ab1JFXPo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Oct 2011 19:15:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan.kim@gmail.com, jweiner@redhat.com, mgorman@suse.de, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: accounting fix
has been removed from the -mm tree.  Its filename was
     mm-compaction-accounting-fix.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Minchan Kim <minchan.kim@gmail.com>
Subject: mm: compaction: accounting fix

I saw the following accouting of compaction during test of the series.

compact_blocks_moved 251
compact_pages_moved 44

It's very awkward to me although it's possbile because it means we try to
compact 251 blocks but it just migrated 44 pages.  As further
investigation, I found isolate_migratepages doesn't isolate any pages but
it returns ISOLATE_SUCCESS and then, it just increases
compact_blocks_moved but doesn't increased compact_pages_moved.

This patch makes accouting of compaction works only in case of success of
isolation.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Acked-by: Johannes Weiner <jweiner@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN mm/compaction.c~mm-compaction-accounting-fix mm/compaction.c
--- a/mm/compaction.c~mm-compaction-accounting-fix
+++ a/mm/compaction.c
@@ -260,6 +260,7 @@ static isolate_migrate_t isolate_migrate
 	unsigned long low_pfn, end_pfn;
 	unsigned long last_pageblock_nr = 0, pageblock_nr;
 	unsigned long nr_scanned = 0, nr_isolated = 0;
+	isolate_migrate_t ret = ISOLATE_NONE;
 	struct list_head *migratelist = &cc->migratepages;
 	isolate_mode_t mode = ISOLATE_ACTIVE | ISOLATE_INACTIVE |
 				ISOLATE_UNEVICTABLE;
@@ -273,7 +274,7 @@ static isolate_migrate_t isolate_migrate
 	/* Do not cross the free scanner or scan within a memory hole */
 	if (end_pfn > cc->free_pfn || !pfn_valid(low_pfn)) {
 		cc->migrate_pfn = end_pfn;
-		return ISOLATE_NONE;
+		return ret;
 	}
 
 	/*
@@ -370,14 +371,17 @@ static isolate_migrate_t isolate_migrate
 			break;
 	}
 
-	acct_isolated(zone, cc);
+	if (cc->nr_migratepages > 0) {
+		acct_isolated(zone, cc);
+		ret = ISOLATE_SUCCESS;
+	}
 
 	spin_unlock_irq(&zone->lru_lock);
 	cc->migrate_pfn = low_pfn;
 
 	trace_mm_compaction_isolate_migratepages(nr_scanned, nr_isolated);
 
-	return ISOLATE_SUCCESS;
+	return ret;
 }
 
 /*
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
kswapd-assign-new_order-and-new_classzone_idx-after-wakeup-in-sleeping.patch
thp-tail-page-refcounting-fix-5.patch
thp-tail-page-refcounting-fix-6.patch
mm-compaction-make-compact_zone_order-static.patch
mm-disable-user-interface-to-manually-rescue-unevictable-pages.patch
vmscan-add-barrier-to-prevent-evictable-page-in-unevictable-list.patch
memcg-skip-scanning-active-lists-based-on-individual-size.patch
memcg-skip-scanning-active-lists-based-on-individual-size-fix.patch

