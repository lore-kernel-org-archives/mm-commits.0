From: akpm@linux-foundation.org
Subject: + writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis-or-if-significant-congestion-is-not-being-encounted-in-the-current-zone-fix.patch added to -mm tree
Date: Mon, 20 Sep 2010 12:35:24 -0700
Message-ID: <201009201935.o8KJZOpG009099@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56002 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755090Ab0ITTgk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Sep 2010 15:36:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, axboe@kernel.dk, fengguang.wu@intel.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis-or-if-significant-congestion-is-not-being-encounted-in-the-current-zone-fix
has been added to the -mm tree.  Its filename is
     writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis-or-if-significant-congestion-is-not-being-encounted-in-the-current-zone-fix.patch

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
Subject: writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis-or-if-significant-congestion-is-not-being-encounted-in-the-current-zone-fix
From: Mel Gorman <mel@csn.ul.ie>

Based on feedback from Minchan Kim, I updated the patch
writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis-or-if-significant-congestion-is-not-being-encountered-in-the-current-zone.patch
currently in the mm tree in the following manner

1. Deleted the bdi_queue_status enum until such point as we distinguish
   between being unable to write to the IO queue and it being congested
2. Direct reclaimers consider congestion the first zone in the zonelist.
   In the mm version of the patch, it scans for a zone with the most
   pages in writeback. This made more sense for an earlier version of
   wait_iff_congested().

Tests did not show up any significant difference.  This patch should be
merged with
writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis-or-if-significant-congestion-is-not-being-encountered-in-the-current-zone.patch

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   57 ++++++++++----------------------------------------
 1 file changed, 12 insertions(+), 45 deletions(-)

diff -puN mm/vmscan.c~writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis-or-if-significant-congestion-is-not-being-encounted-in-the-current-zone-fix mm/vmscan.c
--- a/mm/vmscan.c~writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis-or-if-significant-congestion-is-not-being-encounted-in-the-current-zone-fix
+++ a/mm/vmscan.c
@@ -311,30 +311,20 @@ static inline int is_page_cache_freeable
 	return page_count(page) - page_has_private(page) == 2;
 }
 
-enum bdi_queue_status {
-	QUEUEWRITE_DENIED,
-	QUEUEWRITE_CONGESTED,
-	QUEUEWRITE_ALLOWED,
-};
-
-static enum bdi_queue_status may_write_to_queue(struct backing_dev_info *bdi,
+static int may_write_to_queue(struct backing_dev_info *bdi,
 			      struct scan_control *sc)
 {
-	enum bdi_queue_status ret = QUEUEWRITE_DENIED;
-
 	if (current->flags & PF_SWAPWRITE)
-		return QUEUEWRITE_ALLOWED;
+		return 1;
 	if (!bdi_write_congested(bdi))
-		return QUEUEWRITE_ALLOWED;
-	else
-		ret = QUEUEWRITE_CONGESTED;
+		return 1;
 	if (bdi == current->backing_dev_info)
-		return QUEUEWRITE_ALLOWED;
+		return 1;
 
 	/* lumpy reclaim for hugepage often need a lot of write */
 	if (sc->order > PAGE_ALLOC_COSTLY_ORDER)
-		return QUEUEWRITE_ALLOWED;
-	return ret;
+		return 1;
+	return 0;
 }
 
 /*
@@ -362,8 +352,6 @@ static void handle_write_error(struct ad
 typedef enum {
 	/* failed to write page out, page is locked */
 	PAGE_KEEP,
-	/* failed to write page out due to congestion, page is locked */
-	PAGE_KEEP_CONGESTED,
 	/* move page to the active list, page is locked */
 	PAGE_ACTIVATE,
 	/* page has been sent to the disk successfully, page is unlocked */
@@ -413,15 +401,8 @@ static pageout_t pageout(struct page *pa
 	}
 	if (mapping->a_ops->writepage == NULL)
 		return PAGE_ACTIVATE;
-	switch (may_write_to_queue(mapping->backing_dev_info, sc)) {
-	case QUEUEWRITE_CONGESTED:
-		return PAGE_KEEP_CONGESTED;
-	case QUEUEWRITE_DENIED:
-		disable_lumpy_reclaim_mode(sc);
+	if (!may_write_to_queue(mapping->backing_dev_info, sc))
 		return PAGE_KEEP;
-	case QUEUEWRITE_ALLOWED:
-		;
-	}
 
 	if (clear_page_dirty_for_io(page)) {
 		int res;
@@ -814,9 +795,8 @@ static unsigned long shrink_page_list(st
 
 			/* Page is dirty, try to write it out here */
 			switch (pageout(page, mapping, sc)) {
-			case PAGE_KEEP_CONGESTED:
-				nr_congested++;
 			case PAGE_KEEP:
+				nr_congested++;
 				goto keep_locked;
 			case PAGE_ACTIVATE:
 				goto activate_locked;
@@ -2017,24 +1997,11 @@ static unsigned long do_try_to_free_page
 		/* Take a nap, wait for some writeback to complete */
 		if (!sc->hibernation_mode && sc->nr_scanned &&
 		    priority < DEF_PRIORITY - 2) {
-			struct zone *active_zone = NULL;
-			unsigned long max_writeback = 0;
-			for_each_zone_zonelist(zone, z, zonelist,
-					gfp_zone(sc->gfp_mask)) {
-				unsigned long writeback;
-
-				/* Initialise for first zone */
-				if (active_zone == NULL)
-					active_zone = zone;
-
-				writeback = zone_page_state(zone, NR_WRITEBACK);
-				if (writeback > max_writeback) {
-					max_writeback = writeback;
-					active_zone = zone;
-				}
-			}
+			struct zone *preferred_zone;
 
-			wait_iff_congested(active_zone, BLK_RW_ASYNC, HZ/10);
+			first_zones_zonelist(zonelist, gfp_zone(sc->gfp_mask),
+							NULL, &preferred_zone);
+			wait_iff_congested(preferred_zone, BLK_RW_ASYNC, HZ/10);
 		}
 	}
 
_

Patches currently in -mm which might be from mel@csn.ul.ie are

include-linux-pageblock-flagsh-fix-set_pageblock_flags-macro-definiton.patch
mm-compaction-fix-compactpagefailed-counting.patch
memory-hotplug-fix-notifiers-return-value-check.patch
memory-hotplug-unify-is_removable-and-offline-detection-code.patch
mm-fix-typo-in-mmh-when-node_not_in_page_flags.patch
tracing-vmscan-add-trace-events-for-lru-list-shrinking.patch
writeback-account-for-time-spent-congestion_waited.patch
vmscan-synchronous-lumpy-reclaim-should-not-call-congestion_wait.patch
vmscan-narrow-the-scenarios-lumpy-reclaim-uses-synchrounous-reclaim.patch
vmscan-remove-dead-code-in-shrink_inactive_list.patch
vmscan-isolated_lru_pages-stop-neighbour-search-if-neighbour-cannot-be-isolated.patch
writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis.patch
writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis-or-if-significant-congestion-is-not-being-encountered-in-the-current-zone.patch
writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis-or-if-significant-congestion-is-not-being-encounted-in-the-current-zone-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
add-debugging-aid-for-memory-initialisation-problems.patch

