From: akpm@linux-foundation.org
Subject: - sched-consolidate-sched_clock-drift-adjustments.patch removed from -mm tree
Date: Mon, 30 Apr 2007 11:48:22 -0700
Message-ID: <200704301848.l3UImM6f011825@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46147 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946612AbXD3Ssq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 14:48:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, kernel@kolivas.org, mingo@elte.hu, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     sched: consolidate sched_clock drift adjustments
has been removed from the -mm tree.  Its filename was
     sched-consolidate-sched_clock-drift-adjustments.patch

This patch was dropped because I need to clear the decks

------------------------------------------------------
Subject: sched: consolidate sched_clock drift adjustments
From: Daniel Walker <dwalker@mvista.com>

No functional changes ..

I created sched_clock_drift_adjust() which holds similar code from I also
added an explicit ifdef on CONFIG_SMP, the comments seemed to suggest it
wasn't needed, but it can't hurt to make it explicit.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Con Kolivas <kernel@kolivas.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |   34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff -puN kernel/sched.c~sched-consolidate-sched_clock-drift-adjustments kernel/sched.c
--- a/kernel/sched.c~sched-consolidate-sched_clock-drift-adjustments
+++ a/kernel/sched.c
@@ -666,6 +666,23 @@ sched_info_switch(struct task_struct *pr
 #define sched_info_switch(t, next)	do { } while (0)
 #endif /* CONFIG_SCHEDSTATS || CONFIG_TASK_DELAY_ACCT */
 
+#ifdef CONFIG_SMP
+static inline unsigned long long
+sched_clock_drift_adjust(unsigned long long timestamp, struct rq *from,
+			 struct rq *to)
+{
+	return (timestamp - from->most_recent_timestamp)
+		+ to->most_recent_timestamp;
+}
+#else
+static inline unsigned long long
+sched_clock_drift_adjust(unsigned long long timestamp, struct rq *from,
+			 struct rq *to)
+{
+	return timestamp
+}
+#endif
+
 static inline int task_queued(struct task_struct *task)
 {
 	return !list_empty(&task->run_list);
@@ -1044,10 +1061,10 @@ static void activate_task(struct task_st
 
 #ifdef CONFIG_SMP
 	if (!local) {
-		/* Compensate for drifting sched_clock */
 		struct rq *this_rq = this_rq();
-		now = (now - this_rq->most_recent_timestamp)
-			+ rq->most_recent_timestamp;
+
+		/* Compensate for drifting sched_clock */
+		now = sched_clock_drift_adjust(now, this_rq, rq);
 	}
 #endif
 
@@ -1775,8 +1792,8 @@ void fastcall wake_up_new_task(struct ta
 		 * Not the local CPU - must adjust timestamp. This should
 		 * get optimised away in the !CONFIG_SMP case.
 		 */
-		p->timestamp = (p->timestamp - this_rq->most_recent_timestamp)
-					+ rq->most_recent_timestamp;
+		p->timestamp =
+			sched_clock_drift_adjust(p->timestamp, this_rq, rq);
 		activate_task(p, rq, 0);
 		try_preempt(p, rq);
 
@@ -2151,8 +2168,7 @@ static void pull_task(struct rq *src_rq,
 	set_task_cpu(p, this_cpu);
 	inc_nr_running(p, this_rq);
 	enqueue_task(p, this_rq);
-	p->timestamp = (p->timestamp - src_rq->most_recent_timestamp)
-				+ this_rq->most_recent_timestamp;
+	p->timestamp = sched_clock_drift_adjust(p->timestamp, src_rq, this_rq);
 	try_preempt(p, this_rq);
 }
 
@@ -5086,8 +5102,8 @@ static int __migrate_task(struct task_st
 		 * afterwards, and pretending it was a local activate.
 		 * This way is cleaner and logically correct.
 		 */
-		p->timestamp = p->timestamp - rq_src->most_recent_timestamp
-				+ rq_dest->most_recent_timestamp;
+		p->timestamp =
+			sched_clock_drift_adjust(p->timestamp, rq_src, rq_dest);
 		deactivate_task(p, rq_src);
 		__activate_task(p, rq_dest);
 		try_preempt(p, rq_dest);
_

Patches currently in -mm which might be from dwalker@mvista.com are

origin.patch
git-acpi.patch
sched-consolidate-sched_clock-drift-adjustments.patch
sched-consolidate-sched_clock-drift-adjustments-fix.patch
slim-make-and-config-stuff.patch
profile-likely-unlikely-macros.patch
