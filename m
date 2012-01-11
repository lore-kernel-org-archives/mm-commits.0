From: akpm@linux-foundation.org
Subject: [merged] mm-vmscanc-consider-swap-space-when-deciding-whether-to-continue-reclaim.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:28:10 -0800
Message-ID: <20120111212811.003D81E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:58945 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933962Ab2AKV2M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:28:12 -0500
Received: by yhpp56 with SMTP id p56so153865yhp.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:28:11 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, aarcange@redhat.com, jweiner@redhat.com, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan.c: consider swap space when deciding whether to continue reclaim
has been removed from the -mm tree.  Its filename was
     mm-vmscanc-consider-swap-space-when-deciding-whether-to-continue-reclaim.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm/vmscan.c: consider swap space when deciding whether to continue reclaim

It's pointless to continue reclaiming when we have no swap space and lots
of anon pages in the inactive list.

Without this patch, it is possible when swap is disabled to continue
trying to reclaim when there are only anonymous pages in the system even
though that will not make any progress.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~mm-vmscanc-consider-swap-space-when-deciding-whether-to-continue-reclaim mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscanc-consider-swap-space-when-deciding-whether-to-continue-reclaim
+++ a/mm/vmscan.c
@@ -2000,8 +2000,9 @@ static inline bool should_continue_recla
 	 * inactive lists are large enough, continue reclaiming
 	 */
 	pages_for_compaction = (2UL << sc->order);
-	inactive_lru_pages = zone_nr_lru_pages(zone, sc, LRU_INACTIVE_ANON) +
-				zone_nr_lru_pages(zone, sc, LRU_INACTIVE_FILE);
+	inactive_lru_pages = zone_nr_lru_pages(zone, sc, LRU_INACTIVE_FILE);
+	if (nr_swap_pages > 0)
+		inactive_lru_pages += zone_nr_lru_pages(zone, sc, LRU_INACTIVE_ANON);
 	if (sc->nr_reclaimed < pages_for_compaction &&
 			inactive_lru_pages > pages_for_compaction)
 		return true;
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
mm-memcg-clean-up-fault-accounting-fix.patch
vmscan-trace-add-file-info-to-trace_mm_vmscan_lru_isolate.patch
mm-compaction-make-isolate_lru_page-filter-aware-again.patch
mm-compaction-introduce-sync-light-migration-for-use-by-compaction-fix.patch

