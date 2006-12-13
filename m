From: akpm@osdl.org
Subject: - sched-improve-migration-accuracy.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:54:35 -0800
Message-ID: <200612130654.kBD6sZv5030558@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57668 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965013AbWLMGyv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:54:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: efault@gmx.de, dwm@meer.net, kenneth.w.chen@intel.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     sched: improve migration accuracy
has been removed from the -mm tree.  Its filename was
     sched-improve-migration-accuracy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sched: improve migration accuracy
From: Mike Galbraith <efault@gmx.de>

Co-opt rq->timestamp_last_tick to maintain a cache_hot_time evaluation
reference timestamp at both tick and sched times to prevent said reference,
formerly rq->timestamp_last_tick, from being behind task->last_ran at
evaluation time, and to move said reference closer to current time on the
remote processor, intent being to improve cache hot evaluation and
timestamp adjustment accuracy for task migration.

Fix minor sched_time double accounting error which occurs when a task
passing through schedule() does not schedule off, and takes the next timer
tick.

[kenneth.w.chen@intel.com: cleanup]
Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Ken Chen <kenneth.w.chen@intel.com>
Cc: Don Mullis <dwm@meer.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/sched.c |   41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff -puN kernel/sched.c~sched-improve-migration-accuracy kernel/sched.c
--- a/kernel/sched.c~sched-improve-migration-accuracy
+++ a/kernel/sched.c
@@ -225,7 +225,8 @@ struct rq {
 	unsigned long nr_uninterruptible;
 
 	unsigned long expired_timestamp;
-	unsigned long long timestamp_last_tick;
+	/* Cached timestamp set by update_cpu_clock() */
+	unsigned long long most_recent_timestamp;
 	struct task_struct *curr, *idle;
 	unsigned long next_balance;
 	struct mm_struct *prev_mm;
@@ -944,8 +945,8 @@ static void activate_task(struct task_st
 	if (!local) {
 		/* Compensate for drifting sched_clock */
 		struct rq *this_rq = this_rq();
-		now = (now - this_rq->timestamp_last_tick)
-			+ rq->timestamp_last_tick;
+		now = (now - this_rq->most_recent_timestamp)
+			+ rq->most_recent_timestamp;
 	}
 #endif
 
@@ -1689,8 +1690,8 @@ void fastcall wake_up_new_task(struct ta
 		 * Not the local CPU - must adjust timestamp. This should
 		 * get optimised away in the !CONFIG_SMP case.
 		 */
-		p->timestamp = (p->timestamp - this_rq->timestamp_last_tick)
-					+ rq->timestamp_last_tick;
+		p->timestamp = (p->timestamp - this_rq->most_recent_timestamp)
+					+ rq->most_recent_timestamp;
 		__activate_task(p, rq);
 		if (TASK_PREEMPTS_CURR(p, rq))
 			resched_task(rq->curr);
@@ -2068,8 +2069,8 @@ static void pull_task(struct rq *src_rq,
 	set_task_cpu(p, this_cpu);
 	inc_nr_running(p, this_rq);
 	enqueue_task(p, this_array);
-	p->timestamp = (p->timestamp - src_rq->timestamp_last_tick)
-				+ this_rq->timestamp_last_tick;
+	p->timestamp = (p->timestamp - src_rq->most_recent_timestamp)
+				+ this_rq->most_recent_timestamp;
 	/*
 	 * Note that idle threads have a prio of MAX_PRIO, for this test
 	 * to be always true for them.
@@ -2105,10 +2106,15 @@ int can_migrate_task(struct task_struct 
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
 
-	if (task_hot(p, rq->timestamp_last_tick, sd))
+	if (task_hot(p, rq->most_recent_timestamp, sd))
 		return 0;
 	return 1;
 }
@@ -2206,11 +2212,6 @@ skip_queue:
 		goto skip_bitmap;
 	}
 
-#ifdef CONFIG_SCHEDSTATS
-	if (task_hot(tmp, busiest->timestamp_last_tick, sd))
-		schedstat_inc(sd, lb_hot_gained[idle]);
-#endif
-
 	pull_task(busiest, array, tmp, this_rq, dst_array, this_cpu);
 	pulled++;
 	rem_load_move -= tmp->load_weight;
@@ -2971,7 +2972,8 @@ EXPORT_PER_CPU_SYMBOL(kstat);
 static inline void
 update_cpu_clock(struct task_struct *p, struct rq *rq, unsigned long long now)
 {
-	p->sched_time += now - max(p->timestamp, rq->timestamp_last_tick);
+	p->sched_time += now - p->last_ran;
+	p->last_ran = rq->most_recent_timestamp = now;
 }
 
 /*
@@ -2984,8 +2986,7 @@ unsigned long long current_sched_time(co
 	unsigned long flags;
 
 	local_irq_save(flags);
-	ns = max(p->timestamp, task_rq(p)->timestamp_last_tick);
-	ns = p->sched_time + sched_clock() - ns;
+	ns = p->sched_time + sched_clock() - p->last_ran;
 	local_irq_restore(flags);
 
 	return ns;
@@ -3176,8 +3177,6 @@ void scheduler_tick(void)
 
 	update_cpu_clock(p, rq, now);
 
-	rq->timestamp_last_tick = now;
-
 	if (p == rq->idle)
 		/* Task on the idle queue */
 		wake_priority_sleeper(rq);
@@ -5032,8 +5031,8 @@ static int __migrate_task(struct task_st
 		 * afterwards, and pretending it was a local activate.
 		 * This way is cleaner and logically correct.
 		 */
-		p->timestamp = p->timestamp - rq_src->timestamp_last_tick
-				+ rq_dest->timestamp_last_tick;
+		p->timestamp = p->timestamp - rq_src->most_recent_timestamp
+				+ rq_dest->most_recent_timestamp;
 		deactivate_task(p, rq_src);
 		__activate_task(p, rq_dest);
 		if (TASK_PREEMPTS_CURR(p, rq_dest))
_

Patches currently in -mm which might be from efault@gmx.de are

origin.patch
readahead-call-scheme.patch

