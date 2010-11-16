From: akpm@linux-foundation.org
Subject: + vmscan-factor-out-kswapd-sleeping-logic-from-kswapd.patch added to -mm tree
Date: Tue, 16 Nov 2010 14:50:57 -0800
Message-ID: <201011162250.oAGMov4i012611@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37382 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756056Ab0KPWvw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Nov 2010 17:51:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie


The patch titled
     vmscan: factor out kswapd sleeping logic from kswapd()
has been added to the -mm tree.  Its filename is
     vmscan-factor-out-kswapd-sleeping-logic-from-kswapd.patch

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
@@ -2364,6 +2364,50 @@ out:
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
@@ -2382,7 +2426,7 @@ static int kswapd(void *p)
 	unsigned long order;
 	pg_data_t *pgdat = (pg_data_t*)p;
 	struct task_struct *tsk = current;
-	DEFINE_WAIT(wait);
+
 	struct reclaim_state reclaim_state = {
 		.reclaimed_slab = 0,
 	};
@@ -2414,7 +2458,6 @@ static int kswapd(void *p)
 		unsigned long new_order;
 		int ret;
 
-		prepare_to_wait(&pgdat->kswapd_wait, &wait, TASK_INTERRUPTIBLE);
 		new_order = pgdat->kswapd_max_order;
 		pgdat->kswapd_max_order = 0;
 		if (order < new_order) {
@@ -2424,52 +2467,9 @@ static int kswapd(void *p)
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
