From: akpm@linux-foundation.org
Subject: [merged] vmscan-factor-out-kswapd-sleeping-logic-from-kswapd.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:44:39 -0800
Message-ID: <201101142247.p0EMlTTh004997@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41306 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752800Ab1ANWry (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:47:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     vmscan: factor out kswapd sleeping logic from kswapd()
has been removed from the -mm tree.  Its filename was
     vmscan-factor-out-kswapd-sleeping-logic-from-kswapd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: factor out kswapd sleeping logic from kswapd()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Currently, kswapd() has deep nesting and is slightly hard to read.  Clean
this up.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   92 +++++++++++++++++++++++++-------------------------
 1 file changed, 46 insertions(+), 46 deletions(-)

diff -puN mm/vmscan.c~vmscan-factor-out-kswapd-sleeping-logic-from-kswapd mm/vmscan.c
--- a/mm/vmscan.c~vmscan-factor-out-kswapd-sleeping-logic-from-kswapd
+++ a/mm/vmscan.c
@@ -2371,6 +2371,50 @@ out:
 	return sc.nr_reclaimed;
 }
 
+static void kswapd_try_to_sleep(pg_data_t *pgdat, int order)
+{
+	long remaining = 0;
+	DEFINE_WAIT(wait);
+
+	if (freezing(current) || kthread_should_stop())
+		return;
+
+	prepare_to_wait(&pgdat->kswapd_wait, &wait, TASK_INTERRUPTIBLE);
+
+	/* Try to sleep for a short interval */
+	if (!sleeping_prematurely(pgdat, order, remaining)) {
+		remaining = schedule_timeout(HZ/10);
+		finish_wait(&pgdat->kswapd_wait, &wait);
+		prepare_to_wait(&pgdat->kswapd_wait, &wait, TASK_INTERRUPTIBLE);
+	}
+
+	/*
+	 * After a short sleep, check if it was a premature sleep. If not, then
+	 * go fully to sleep until explicitly woken up.
+	 */
+	if (!sleeping_prematurely(pgdat, order, remaining)) {
+		trace_mm_vmscan_kswapd_sleep(pgdat->node_id);
+
+		/*
+		 * vmstat counters are not perfectly accurate and the estimated
+		 * value for counters such as NR_FREE_PAGES can deviate from the
+		 * true value by nr_online_cpus * threshold. To avoid the zone
+		 * watermarks being breached while under pressure, we reduce the
+		 * per-cpu vmstat threshold while kswapd is awake and restore
+		 * them before going back to sleep.
+		 */
+		set_pgdat_percpu_threshold(pgdat, calculate_normal_threshold);
+		schedule();
+		set_pgdat_percpu_threshold(pgdat, calculate_pressure_threshold);
+	} else {
+		if (remaining)
+			count_vm_event(KSWAPD_LOW_WMARK_HIT_QUICKLY);
+		else
+			count_vm_event(KSWAPD_HIGH_WMARK_HIT_QUICKLY);
+	}
+	finish_wait(&pgdat->kswapd_wait, &wait);
+}
+
 /*
  * The background pageout daemon, started as a kernel thread
  * from the init process.
@@ -2389,7 +2433,7 @@ static int kswapd(void *p)
 	unsigned long order;
 	pg_data_t *pgdat = (pg_data_t*)p;
 	struct task_struct *tsk = current;
-	DEFINE_WAIT(wait);
+
 	struct reclaim_state reclaim_state = {
 		.reclaimed_slab = 0,
 	};
@@ -2421,7 +2465,6 @@ static int kswapd(void *p)
 		unsigned long new_order;
 		int ret;
 
-		prepare_to_wait(&pgdat->kswapd_wait, &wait, TASK_INTERRUPTIBLE);
 		new_order = pgdat->kswapd_max_order;
 		pgdat->kswapd_max_order = 0;
 		if (order < new_order) {
@@ -2431,52 +2474,9 @@ static int kswapd(void *p)
 			 */
 			order = new_order;
 		} else {
-			if (!freezing(current) && !kthread_should_stop()) {
-				long remaining = 0;
-
-				/* Try to sleep for a short interval */
-				if (!sleeping_prematurely(pgdat, order, remaining)) {
-					remaining = schedule_timeout(HZ/10);
-					finish_wait(&pgdat->kswapd_wait, &wait);
-					prepare_to_wait(&pgdat->kswapd_wait, &wait, TASK_INTERRUPTIBLE);
-				}
-
-				/*
-				 * After a short sleep, check if it was a
-				 * premature sleep. If not, then go fully
-				 * to sleep until explicitly woken up
-				 */
-				if (!sleeping_prematurely(pgdat, order, remaining)) {
-					trace_mm_vmscan_kswapd_sleep(pgdat->node_id);
-
-					/*
-					 * vmstat counters are not perfectly
-					 * accurate and the estimated value
-					 * for counters such as NR_FREE_PAGES
-					 * can deviate from the true value by
-					 * nr_online_cpus * threshold. To
-					 * avoid the zone watermarks being
-					 * breached while under pressure, we
-					 * reduce the per-cpu vmstat threshold
-					 * while kswapd is awake and restore
-					 * them before going back to sleep.
-					 */
-					set_pgdat_percpu_threshold(pgdat,
-						calculate_normal_threshold);
-					schedule();
-					set_pgdat_percpu_threshold(pgdat,
-						calculate_pressure_threshold);
-				} else {
-					if (remaining)
-						count_vm_event(KSWAPD_LOW_WMARK_HIT_QUICKLY);
-					else
-						count_vm_event(KSWAPD_HIGH_WMARK_HIT_QUICKLY);
-				}
-			}
-
+			kswapd_try_to_sleep(pgdat, order);
 			order = pgdat->kswapd_max_order;
 		}
-		finish_wait(&pgdat->kswapd_wait, &wait);
 
 		ret = try_to_freeze();
 		if (kthread_should_stop())
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
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
mm-deactivate-invalidated-pages.patch
mm-deactivate-invalidated-pages-fix.patch

