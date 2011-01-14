From: akpm@linux-foundation.org
Subject: [merged] mm-kswapd-treat-zone-all_unreclaimable-in-sleeping_prematurely-similar-to-balance_pgdat.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:46:03 -0800
Message-ID: <201101142248.p0EMmrxV005242@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59045 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753795Ab1ANWt3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:49:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, dave@linux.vnet.ibm.com, emunson@mgebm.net, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     mm: kswapd: treat zone->all_unreclaimable in sleeping_prematurely similar to balance_pgdat()
has been removed from the -mm tree.  Its filename was
     mm-kswapd-treat-zone-all_unreclaimable-in-sleeping_prematurely-similar-to-balance_pgdat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: kswapd: treat zone->all_unreclaimable in sleeping_prematurely similar to balance_pgdat()
From: Mel Gorman <mel@csn.ul.ie>

After DEF_PRIORITY, balance_pgdat() considers all_unreclaimable zones to
be balanced but sleeping_prematurely does not.  This can force kswapd to
stay awake longer than it should.  This patch fixes it.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Eric B Munson <emunson@mgebm.net>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Simon Kirby <sim@hostway.ca>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-kswapd-treat-zone-all_unreclaimable-in-sleeping_prematurely-similar-to-balance_pgdat mm/vmscan.c
--- a/mm/vmscan.c~mm-kswapd-treat-zone-all_unreclaimable-in-sleeping_prematurely-similar-to-balance_pgdat
+++ a/mm/vmscan.c
@@ -2244,8 +2244,16 @@ static bool sleeping_prematurely(pg_data
 		if (!populated_zone(zone))
 			continue;
 
-		if (zone->all_unreclaimable)
+		/*
+		 * balance_pgdat() skips over all_unreclaimable after
+		 * DEF_PRIORITY. Effectively, it considers them balanced so
+		 * they must be considered balanced here as well if kswapd
+		 * is to sleep
+		 */
+		if (zone->all_unreclaimable) {
+			balanced += zone->present_pages;
 			continue;
+		}
 
 		if (!zone_watermark_ok_safe(zone, order, high_wmark_pages(zone),
 								0, 0))
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
linux-next.patch
writeback-io-less-balance_dirty_pages.patch
writeback-consolidate-variable-names-in-balance_dirty_pages.patch
writeback-per-task-rate-limit-on-balance_dirty_pages.patch
writeback-per-task-rate-limit-on-balance_dirty_pages-fix.patch
writeback-prevent-duplicate-balance_dirty_pages_ratelimited-calls.patch
writeback-account-per-bdi-accumulated-written-pages.patch
writeback-bdi-write-bandwidth-estimation.patch
writeback-bdi-write-bandwidth-estimation-fix.patch
writeback-show-bdi-write-bandwidth-in-debugfs.patch
writeback-quit-throttling-when-bdi-dirty-pages-dropped-low.patch
writeback-reduce-per-bdi-dirty-threshold-ramp-up-time.patch
writeback-make-reasonable-gap-between-the-dirty-background-thresholds.patch
writeback-scale-down-max-throttle-bandwidth-on-concurrent-dirtiers.patch
writeback-add-trace-event-for-balance_dirty_pages.patch
writeback-make-nr_to_write-a-per-file-limit.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch
thp-add-pagetranscompound.patch
add-debugging-aid-for-memory-initialisation-problems.patch

