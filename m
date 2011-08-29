From: akpm@linux-foundation.org
Subject: + mm-compaction-accounting-fix.patch added to -mm tree
Date: Mon, 29 Aug 2011 13:44:20 -0700
Message-ID: <201108292044.p7TKiKlo025380@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55128 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754718Ab1H2UpA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Aug 2011 16:45:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan.kim@gmail.com, jweiner@redhat.com, mgorman@suse.de, riel@redhat.com


The patch titled
     mm: compaction: accounting fix
has been added to the -mm tree.  Its filename is
     mm-compaction-accounting-fix.patch

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
Subject: mm: compaction: accounting fix
From: Minchan Kim <minchan.kim@gmail.com>

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
Cc: Johannes Weiner <jweiner@redhat.com>
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
mm-compaction-compact-unevictable-pages-checkpatch-fixes.patch
mm-compaction-accounting-fix.patch

