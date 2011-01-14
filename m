From: akpm@linux-foundation.org
Subject: [merged] mm-kswapd-reset-kswapd_max_order-and-classzone_idx-after-reading.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:46:01 -0800
Message-ID: <201101142248.p0EMmpT8005239@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35015 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753761Ab1ANWtX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:49:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, dave@linux.vnet.ibm.com, emunson@mgebm.net, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     mm: kswapd: reset kswapd_max_order and classzone_idx after reading
has been removed from the -mm tree.  Its filename was
     mm-kswapd-reset-kswapd_max_order-and-classzone_idx-after-reading.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: kswapd: reset kswapd_max_order and classzone_idx after reading
From: Mel Gorman <mel@csn.ul.ie>

When kswapd wakes up, it reads its order and classzone from pgdat and
calls balance_pgdat.  While its awake, it potentially reclaimes at a high
order and a low classzone index.  This might have been a once-off that was
not required by subsequent callers.  However, because the pgdat values
were not reset, they remain artifically high while balance_pgdat() is
running and potentially kswapd enters a second unnecessary reclaim cycle. 
Reset the pgdat order and classzone index after reading.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Eric B Munson <emunson@mgebm.net>
Cc: Simon Kirby <sim@hostway.ca>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/vmscan.c~mm-kswapd-reset-kswapd_max_order-and-classzone_idx-after-reading mm/vmscan.c
--- a/mm/vmscan.c~mm-kswapd-reset-kswapd_max_order-and-classzone_idx-after-reading
+++ a/mm/vmscan.c
@@ -2653,6 +2653,8 @@ static int kswapd(void *p)
 			kswapd_try_to_sleep(pgdat, order);
 			order = pgdat->kswapd_max_order;
 			classzone_idx = pgdat->classzone_idx;
+			pgdat->kswapd_max_order = 0;
+			pgdat->classzone_idx = MAX_NR_ZONES - 1;
 		}
 
 		ret = try_to_freeze();
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

