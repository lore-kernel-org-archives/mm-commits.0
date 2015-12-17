From: akpm@linux-foundation.org
Subject: +
 mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages.patch added to -mm tree
Date: Wed, 16 Dec 2015 16:00:08 -0800
Message-ID: <5671fb08.TiK7gL3rFxg6hm7X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34484 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636AbbLQAAJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Dec 2015 19:00:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: throttle on IO only when there are too many dirty and writeback pages
has been added to the -mm tree.  Its filename is
     mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

 mm/backing-dev.c |   19 +++----------------
 mm/page_alloc.c  |   36 +++++++++++++++++++++++++++++++++---
 2 files changed, 36 insertions(+), 19 deletions(-)

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
@@ -980,19 +979,7 @@ long wait_iff_congested(struct zone *zon
 	if (atomic_read(&nr_wb_congested[sync]) == 0 ||
 	    !test_bit(ZONE_CONGESTED, &zone->flags)) {
 
-		/*
-		 * Memory allocation/reclaim might be called from a WQ
-		 * context and the current implementation of the WQ
-		 * concurrency control doesn't recognize that a particular
-		 * WQ is congested if the worker thread is looping without
-		 * ever sleeping. Therefore we have to do a short sleep
-		 * here rather than calling cond_resched().
-		 */
-		if (current->flags & PF_WQ_WORKER)
-			schedule_timeout(1);
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
@@ -2999,8 +2999,9 @@ should_reclaim_retry(gfp_t gfp_mask, uns
 	 */
 	for_each_zone_zonelist_nodemask(zone, z, ac->zonelist, ac->high_zoneidx, ac->nodemask) {
 		unsigned long available;
+		unsigned long reclaimable;
 
-		available = zone_reclaimable_pages(zone);
+		available = reclaimable = zone_reclaimable_pages(zone);
 		available -= DIV_ROUND_UP(no_progress_loops * available, MAX_RECLAIM_RETRIES);
 		available += zone_page_state_snapshot(zone, NR_FREE_PAGES);
 
@@ -3009,8 +3010,37 @@ should_reclaim_retry(gfp_t gfp_mask, uns
 		 */
 		if (__zone_watermark_ok(zone, order, min_wmark_pages(zone),
 				ac->high_zoneidx, alloc_flags, available)) {
-			/* Wait for some write requests to complete then retry */
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

mm-get-rid-of-__alloc_pages_high_priority.patch
mm-do-not-loop-over-alloc_no_watermarks-without-triggering-reclaim.patch
mm-vmscan-consider-isolated-pages-in-zone_reclaimable_pages.patch
mm-allow-gfp_iofs-for-page_cache_read-page-cache-allocation.patch
mm-oom-give-__gfp_nofail-allocations-access-to-memory-reserves.patch
mm-oom-rework-oom-detection.patch
mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-5.patch

