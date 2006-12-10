From: akpm@osdl.org
Subject: - sched-improve-migration-accuracy-tidy.patch removed from -mm tree
Date: Sun, 10 Dec 2006 00:23:06 -0800
Message-ID: <200612100823.kBA8N6P3018770@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:33037 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760387AbWLJIXR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 03:23:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kenneth.w.chen@intel.com, efault@gmx.de, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     sched-improve-migration-accuracy tidy
has been removed from the -mm tree.  Its filename was
     sched-improve-migration-accuracy-tidy.patch

This patch was dropped because it was folded into sched-improve-migration-accuracy.patch

------------------------------------------------------
Subject: sched-improve-migration-accuracy tidy
From: "Chen, Kenneth W" <kenneth.w.chen@intel.com>

While we at it, let's clean up this hunk.  task_hot is evaluated twice in
the more common case of nr_balance_failed <= cache_nice_tries. We should
only test/increment relevant stats for forced migration.

Signed-off-by: Ken Chen <kenneth.w.chen@intel.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ken Chen <kenneth.w.chen@intel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/sched.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff -puN kernel/sched.c~sched-improve-migration-accuracy-tidy kernel/sched.c
--- a/kernel/sched.c~sched-improve-migration-accuracy-tidy
+++ a/kernel/sched.c
@@ -2106,8 +2106,13 @@ int can_migrate_task(struct task_struct 
 	 * 2) too many balance attempts have failed.
 	 */
 
-	if (sd->nr_balance_failed > sd->cache_nice_tries)
+	if (sd->nr_balance_failed > sd->cache_nice_tries) {
+#ifdef CONFIG_SCHEDSTATS
+		if (task_hot(p, rq->most_recent_timestamp, sd))
+			schedstat_inc(sd, lb_hot_gained[idle]);
+#endif
 		return 1;
+	}
 
 	if (task_hot(p, rq->most_recent_timestamp, sd))
 		return 0;
@@ -2207,11 +2212,6 @@ skip_queue:
 		goto skip_bitmap;
 	}
 
-#ifdef CONFIG_SCHEDSTATS
-	if (task_hot(tmp, busiest->most_recent_timestamp, sd))
-		schedstat_inc(sd, lb_hot_gained[idle]);
-#endif
-
 	pull_task(busiest, array, tmp, this_rq, dst_array, this_cpu);
 	pulled++;
 	rem_load_move -= tmp->load_weight;
_

Patches currently in -mm which might be from kenneth.w.chen@intel.com are

origin.patch
sched-avoid-taking-rq-lock-in-wake_priority_sleeper.patch
sched-remove-staggering-of-load-balancing.patch
sched-disable-interrupts-for-locking-in-load_balance.patch
sched-extract-load-calculation-from-rebalance_tick.patch
sched-move-idle-status-calculation-into-rebalance_tick.patch
sched-use-softirq-for-load-balancing.patch
sched-call-tasklet-less-frequently.patch
sched-add-option-to-serialize-load-balancing.patch
sched-improve-migration-accuracy.patch
sched-improve-migration-accuracy-tidy.patch
sched-remove-lb_stopbalance-counter.patch
sched-optimize-activate_task-for-rt-task.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch

