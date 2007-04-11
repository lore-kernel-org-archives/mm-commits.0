From: akpm@linux-foundation.org
Subject: + sched-consolidate-sched_clock-drift-adjustments.patch added to -mm tree
Date: Wed, 11 Apr 2007 14:37:16 -0700
Message-ID: <200704112137.l3BLbGJ3015048@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33514 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965320AbXDKVhw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 17:37:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwalker@mvista.com, kernel@kolivas.org, mingo@elte.hu, nickpiggin@yahoo.com.au


The patch titled
     sched: consolidate sched_clock drift adjustments
has been added to the -mm tree.  Its filename is
     sched-consolidate-sched_clock-drift-adjustments.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

 kernel/sched.c |   31 ++++++++++++++++++++++---------
 1 files changed, 22 insertions(+), 9 deletions(-)

diff -puN kernel/sched.c~sched-consolidate-sched_clock-drift-adjustments kernel/sched.c
--- a/kernel/sched.c~sched-consolidate-sched_clock-drift-adjustments
+++ a/kernel/sched.c
@@ -658,6 +658,20 @@ sched_info_switch(struct task_struct *pr
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
+			 struct rq *to) { }
+#endif
+
 static inline int task_queued(struct task_struct *task)
 {
 	return !list_empty(&task->run_list);
@@ -1016,10 +1030,10 @@ static void activate_task(struct task_st
 
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
 
@@ -1740,8 +1754,8 @@ void fastcall wake_up_new_task(struct ta
 		 * Not the local CPU - must adjust timestamp. This should
 		 * get optimised away in the !CONFIG_SMP case.
 		 */
-		p->timestamp = (p->timestamp - this_rq->most_recent_timestamp)
-					+ rq->most_recent_timestamp;
+		p->timestamp =
+			sched_clock_drift_adjust(p->timestamp, this_rq, rq);
 		activate_task(p, rq, 0);
 		try_preempt(p, rq);
 
@@ -2116,8 +2130,7 @@ static void pull_task(struct rq *src_rq,
 	set_task_cpu(p, this_cpu);
 	inc_nr_running(p, this_rq);
 	enqueue_task(p, this_rq);
-	p->timestamp = (p->timestamp - src_rq->most_recent_timestamp)
-				+ this_rq->most_recent_timestamp;
+	p->timestamp = sched_clock_drift_adjust(p->timestamp, src_rq, this_rq);
 	try_preempt(p, this_rq);
 }
 
@@ -5055,8 +5068,8 @@ static int __migrate_task(struct task_st
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

i386-tsc-remove-xtime_locking-around-cpufreq-notifier.patch
clocksource-acpi_pm-trivial-comment-update.patch
sched-consolidate-sched_clock-drift-adjustments.patch
slim-make-and-config-stuff.patch
profile-likely-unlikely-macros.patch
