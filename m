From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages.patch removed from -mm tree
Date: Tue, 05 Apr 2016 14:19:04 -0700
Message-ID: <57042bc8.YE4ZJIX0xZFV80qL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52570 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784AbcDEVTF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2016 17:19:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: throttle on IO only when there are too many dirty and writeback pages
has been removed from the -mm tree.  Its filename was
     mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm: throttle on IO only when there are too many dirty and writeback pages

wait_iff_congested has been used to throttle allocator before it retried
another round of direct reclaim to allow the writeback to make some
progress and prevent reclaim from looping over dirty/writeback pages
without making any progress.  We used to do congestion_wait before
0e093d99763e ("writeback: do not sleep on the congestion queue if there
are no congested BDIs or if significant congestion is not being
encountered in the current zone") but that led to undesirable stalls and
sleeping for the full timeout even when the BDI wasn't congested.  Hence
wait_iff_congested was used instead.  But it seems that even
wait_iff_congested doesn't work as expected.  We might have a small file
LRU list with all pages dirty/writeback and yet the bdi is not congested
so this is just a cond_resched in the end and can end up triggering pre
mature OOM.

This patch replaces the unconditional wait_iff_congested by
congestion_wait which is executed only if we _know_ that the last round of
direct reclaim didn't make any progress and dirty+writeback pages are more
than a half of the reclaimable pages on the zone which might be usable for
our target allocation.  This shouldn't reintroduce stalls fixed by
0e093d99763e because congestion_wait is called only when we are getting
hopeless when sleeping is a better choice than OOM with many pages under
IO.

We have to preserve logic introduced by "mm, vmstat: allow WQ concurrency
to discover memory reclaim doesn't make any progress" into the
__alloc_pages_slowpath now that wait_iff_congested is not used anymore. 
As the only remaining user of wait_iff_congested is shrink_inactive_list
we can remove the WQ specific short sleep from wait_iff_congested because
the sleep is needed to be done only once in the allocation retry cycle.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |   20 +++-----------------
 mm/page_alloc.c  |   36 +++++++++++++++++++++++++++++++++---
 2 files changed, 36 insertions(+), 20 deletions(-)

diff -puN mm/backing-dev.c~mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages mm/backing-dev.c
--- a/mm/backing-dev.c~mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages
+++ a/mm/backing-dev.c
@@ -957,9 +957,8 @@ EXPORT_SYMBOL(congestion_wait);
  * jiffies for either a BDI to exit congestion of the given @sync queue
  * or a write to complete.
  *
- * In the absence of zone congestion, a short sleep or a cond_resched is
- * performed to yield the processor and to allow other subsystems to make
- * a forward progress.
+ * In the absence of zone congestion, cond_resched() is called to yield
+ * the processor if necessary but otherwise does not sleep.
  *
  * The return value is 0 if the sleep is for the full timeout. Otherwise,
  * it is the number of jiffies that were still remaining when the function
@@ -979,20 +978,7 @@ long wait_iff_congested(struct zone *zon
 	 */
 	if (atomic_read(&nr_wb_congested[sync]) == 0 ||
 	    !test_bit(ZONE_CONGESTED, &zone->flags)) {
-
-		/*
-		 * Memory allocation/reclaim might be called from a WQ
-		 * context and the current implementation of the WQ
-		 * concurrency control doesn't recognize that a particular
-		 * WQ is congested if the worker thread is looping without
-		 * ever sleeping. Therefore we have to do a short sleep
-		 * here rather than calling cond_resched().
-		 */
-		if (current->flags & PF_WQ_WORKER)
-			schedule_timeout_uninterruptible(1);
-		else
-			cond_resched();
-
+		cond_resched();
 		/* In case we scheduled, work out time remaining */
 		ret = timeout - (jiffies - start);
 		if (ret < 0)
diff -puN mm/page_alloc.c~mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages mm/page_alloc.c
--- a/mm/page_alloc.c~mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages
+++ a/mm/page_alloc.c
@@ -3192,8 +3192,9 @@ should_reclaim_retry(gfp_t gfp_mask, uns
 	for_each_zone_zonelist_nodemask(zone, z, ac->zonelist,
 			ac->high_zoneidx, ac->nodemask) {
 		unsigned long available;
+		unsigned long reclaimable;
 
-		available = zone_reclaimable_pages(zone);
+		available = reclaimable = zone_reclaimable_pages(zone);
 		available -= DIV_ROUND_UP(no_progress_loops * available,
 					  MAX_RECLAIM_RETRIES);
 		available += zone_page_state_snapshot(zone, NR_FREE_PAGES);
@@ -3204,8 +3205,37 @@ should_reclaim_retry(gfp_t gfp_mask, uns
 		 */
 		if (__zone_watermark_ok(zone, order, min_wmark_pages(zone),
 				ac->high_zoneidx, alloc_flags, available)) {
-			/* Wait for some writes to complete then retry */
-			wait_iff_congested(zone, BLK_RW_ASYNC, HZ/50);
+			unsigned long writeback;
+			unsigned long dirty;
+
+			writeback = zone_page_state_snapshot(zone, NR_WRITEBACK);
+			dirty = zone_page_state_snapshot(zone, NR_FILE_DIRTY);
+
+			/*
+			 * If we didn't make any progress and have a lot of
+			 * dirty + writeback pages then we should wait for
+			 * an IO to complete to slow down the reclaim and
+			 * prevent from pre mature OOM
+			 */
+			if (!did_some_progress && 2*(writeback + dirty) > reclaimable) {
+				congestion_wait(BLK_RW_ASYNC, HZ/10);
+				return true;
+			}
+
+			/*
+			 * Memory allocation/reclaim might be called from a WQ
+			 * context and the current implementation of the WQ
+			 * concurrency control doesn't recognize that
+			 * a particular WQ is congested if the worker thread is
+			 * looping without ever sleeping. Therefore we have to
+			 * do a short sleep here rather than calling
+			 * cond_resched().
+			 */
+			if (current->flags & PF_WQ_WORKER)
+				schedule_timeout(1);
+			else
+				cond_resched();
+
 			return true;
 		}
 	}
_

Patches currently in -mm which might be from mhocko@suse.com are

include-linux-nodemaskh-create-next_node_in-helper-fix.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations.patch

