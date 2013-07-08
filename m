From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:24:45 -0700
Message-ID: <51db11fd.mMRCQK9zQ2Fkcrz4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50263 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab3GHTYq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:24:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zcalusic@bitsync.net, riel@redhat.com, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, jslaby@suse.cz, hannes@cmpxchg.org, dormando@rydia.net, Valdis.Kletnieks@vt.edu, mgorman@suse.de

Subject: [merged] mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback.patch removed from -mm tree
To: mgorman@suse.de,Valdis.Kletnieks@vt.edu,dormando@rydia.net,hannes@cmpxchg.org,jslaby@suse.cz,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,riel@redhat.com,zcalusic@bitsync.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:24:45 -0700


The patch titled
     Subject: mm: vmscan: block kswapd if it is encountering pages under writeback
has been removed from the -mm tree.  Its filename was
     mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: vmscan: block kswapd if it is encountering pages under writeback

Historically, kswapd used to congestion_wait() at higher priorities if it
was not making forward progress.  This made no sense as the failure to
make progress could be completely independent of IO.  It was later
replaced by wait_iff_congested() and removed entirely by commit 258401a6
(mm: don't wait on congested zones in balance_pgdat()) as it was
duplicating logic in shrink_inactive_list().

This is problematic.  If kswapd encounters many pages under writeback and
it continues to scan until it reaches the high watermark then it will
quickly skip over the pages under writeback and reclaim clean young pages
or push applications out to swap.

The use of wait_iff_congested() is not suited to kswapd as it will only
stall if the underlying BDI is really congested or a direct reclaimer was
unable to write to the underlying BDI.  kswapd bypasses the BDI congestion
as it sets PF_SWAPWRITE but even if this was taken into account then it
would cause direct reclaimers to stall on writeback which is not
desirable.

This patch sets a ZONE_WRITEBACK flag if direct reclaim or kswapd is
encountering too many pages under writeback.  If this flag is set and
kswapd encounters a PageReclaim page under writeback then it'll assume
that the LRU lists are being recycled too quickly before IO can complete
and block waiting for some IO to complete.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Tested-by: Zlatko Calusic <zcalusic@bitsync.net>
Cc: dormando <dormando@rydia.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    8 +++
 mm/vmscan.c            |   82 ++++++++++++++++++++++++++++-----------
 2 files changed, 68 insertions(+), 22 deletions(-)

diff -puN include/linux/mmzone.h~mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback
+++ a/include/linux/mmzone.h
@@ -499,6 +499,9 @@ typedef enum {
 					 * many dirty file pages at the tail
 					 * of the LRU.
 					 */
+	ZONE_WRITEBACK,			/* reclaim scanning has recently found
+					 * many pages under writeback
+					 */
 } zone_flags_t;
 
 static inline void zone_set_flag(struct zone *zone, zone_flags_t flag)
@@ -526,6 +529,11 @@ static inline int zone_is_reclaim_dirty(
 	return test_bit(ZONE_TAIL_LRU_DIRTY, &zone->flags);
 }
 
+static inline int zone_is_reclaim_writeback(const struct zone *zone)
+{
+	return test_bit(ZONE_WRITEBACK, &zone->flags);
+}
+
 static inline int zone_is_reclaim_locked(const struct zone *zone)
 {
 	return test_bit(ZONE_RECLAIM_LOCKED, &zone->flags);
diff -puN mm/vmscan.c~mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback
+++ a/mm/vmscan.c
@@ -724,25 +724,55 @@ static unsigned long shrink_page_list(st
 		may_enter_fs = (sc->gfp_mask & __GFP_FS) ||
 			(PageSwapCache(page) && (sc->gfp_mask & __GFP_IO));
 
+		/*
+		 * If a page at the tail of the LRU is under writeback, there
+		 * are three cases to consider.
+		 *
+		 * 1) If reclaim is encountering an excessive number of pages
+		 *    under writeback and this page is both under writeback and
+		 *    PageReclaim then it indicates that pages are being queued
+		 *    for IO but are being recycled through the LRU before the
+		 *    IO can complete. Waiting on the page itself risks an
+		 *    indefinite stall if it is impossible to writeback the
+		 *    page due to IO error or disconnected storage so instead
+		 *    block for HZ/10 or until some IO completes then clear the
+		 *    ZONE_WRITEBACK flag to recheck if the condition exists.
+		 *
+		 * 2) Global reclaim encounters a page, memcg encounters a
+		 *    page that is not marked for immediate reclaim or
+		 *    the caller does not have __GFP_IO. In this case mark
+		 *    the page for immediate reclaim and continue scanning.
+		 *
+		 *    __GFP_IO is checked  because a loop driver thread might
+		 *    enter reclaim, and deadlock if it waits on a page for
+		 *    which it is needed to do the write (loop masks off
+		 *    __GFP_IO|__GFP_FS for this reason); but more thought
+		 *    would probably show more reasons.
+		 *
+		 *    Don't require __GFP_FS, since we're not going into the
+		 *    FS, just waiting on its writeback completion. Worryingly,
+		 *    ext4 gfs2 and xfs allocate pages with
+		 *    grab_cache_page_write_begin(,,AOP_FLAG_NOFS), so testing
+		 *    may_enter_fs here is liable to OOM on them.
+		 *
+		 * 3) memcg encounters a page that is not already marked
+		 *    PageReclaim. memcg does not have any dirty pages
+		 *    throttling so we could easily OOM just because too many
+		 *    pages are in writeback and there is nothing else to
+		 *    reclaim. Wait for the writeback to complete.
+		 */
 		if (PageWriteback(page)) {
-			/*
-			 * memcg doesn't have any dirty pages throttling so we
-			 * could easily OOM just because too many pages are in
-			 * writeback and there is nothing else to reclaim.
-			 *
-			 * Check __GFP_IO, certainly because a loop driver
-			 * thread might enter reclaim, and deadlock if it waits
-			 * on a page for which it is needed to do the write
-			 * (loop masks off __GFP_IO|__GFP_FS for this reason);
-			 * but more thought would probably show more reasons.
-			 *
-			 * Don't require __GFP_FS, since we're not going into
-			 * the FS, just waiting on its writeback completion.
-			 * Worryingly, ext4 gfs2 and xfs allocate pages with
-			 * grab_cache_page_write_begin(,,AOP_FLAG_NOFS), so
-			 * testing may_enter_fs here is liable to OOM on them.
-			 */
-			if (global_reclaim(sc) ||
+			/* Case 1 above */
+			if (current_is_kswapd() &&
+			    PageReclaim(page) &&
+			    zone_is_reclaim_writeback(zone)) {
+				unlock_page(page);
+				congestion_wait(BLK_RW_ASYNC, HZ/10);
+				zone_clear_flag(zone, ZONE_WRITEBACK);
+				goto keep;
+
+			/* Case 2 above */
+			} else if (global_reclaim(sc) ||
 			    !PageReclaim(page) || !(sc->gfp_mask & __GFP_IO)) {
 				/*
 				 * This is slightly racy - end_page_writeback()
@@ -757,9 +787,13 @@ static unsigned long shrink_page_list(st
 				 */
 				SetPageReclaim(page);
 				nr_writeback++;
+
 				goto keep_locked;
+
+			/* Case 3 above */
+			} else {
+				wait_on_page_writeback(page);
 			}
-			wait_on_page_writeback(page);
 		}
 
 		if (!force_reclaim)
@@ -1374,8 +1408,10 @@ shrink_inactive_list(unsigned long nr_to
 	 *                     isolated page is PageWriteback
 	 */
 	if (nr_writeback && nr_writeback >=
-			(nr_taken >> (DEF_PRIORITY - sc->priority)))
+			(nr_taken >> (DEF_PRIORITY - sc->priority))) {
 		wait_iff_congested(zone, BLK_RW_ASYNC, HZ/10);
+		zone_set_flag(zone, ZONE_WRITEBACK);
+	}
 
 	/*
 	 * Similarly, if many dirty pages are encountered that are not
@@ -2669,8 +2705,8 @@ static bool prepare_kswapd_sleep(pg_data
  * the high watermark.
  *
  * Returns true if kswapd scanned at least the requested number of pages to
- * reclaim. This is used to determine if the scanning priority needs to be
- * raised.
+ * reclaim or if the lack of progress was due to pages under writeback.
+ * This is used to determine if the scanning priority needs to be raised.
  */
 static bool kswapd_shrink_zone(struct zone *zone,
 			       struct scan_control *sc,
@@ -2697,6 +2733,8 @@ static bool kswapd_shrink_zone(struct zo
 	if (nr_slab == 0 && !zone_reclaimable(zone))
 		zone->all_unreclaimable = 1;
 
+	zone_clear_flag(zone, ZONE_WRITEBACK);
+
 	return sc->nr_scanned >= sc->nr_to_reclaim;
 }
 
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch
fs-bump-inode-and-dentry-counters-to-long.patch
super-fix-calculation-of-shrinkable-objects-for-small-numbers.patch
dcache-convert-dentry_statnr_unused-to-per-cpu-counters.patch
dentry-move-to-per-sb-lru-locks.patch
dcache-remove-dentries-from-lru-before-putting-on-dispose-list.patch
mm-new-shrinker-api.patch
shrinker-convert-superblock-shrinkers-to-new-api.patch
list-add-a-new-lru-list-type.patch
inode-convert-inode-lru-list-to-generic-lru-list-code.patch
dcache-convert-to-use-new-lru-list-infrastructure.patch
list_lru-per-node-list-infrastructure.patch
list_lru-per-node-api.patch
shrinker-add-node-awareness.patch
vmscan-per-node-deferred-work.patch
fs-convert-inode-and-dentry-shrinking-to-be-node-aware.patch
xfs-convert-buftarg-lru-to-generic-code.patch
xfs-rework-buffer-dispose-list-tracking.patch
xfs-convert-dquot-cache-lru-to-list_lru.patch
fs-convert-fs-shrinkers-to-new-scan-count-api.patch
drivers-convert-shrinkers-to-new-count-scan-api.patch
i915-bail-out-earlier-when-shrinker-cannot-acquire-mutex.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api.patch
shrinker-kill-old-shrink-api.patch
list_lru-dynamically-adjust-node-arrays.patch
zbud-add-to-mm.patch
zswap-add-to-mm.patch
zswap-add-documentation.patch
mm-vmscan-do-not-continue-scanning-if-reclaim-was-aborted-for-compaction.patch
mm-vmscan-do-not-scale-writeback-pages-when-deciding-whether-to-set-zone_writeback.patch
mm-memmap_init_zone-performance-improvement.patch

