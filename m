From: akpm@linux-foundation.org
Subject: - sched-implement-staircase-deadline-scheduler-load-weight-fix.patch removed from -mm tree
Date: Mon, 30 Apr 2007 11:48:06 -0700
Message-ID: <200704301848.l3UIm6hh011810@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46126 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946605AbXD3SsQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 14:48:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kernel@kolivas.org, w@1wt.eu, mm-commits@vger.kernel.org


The patch titled
     sched: implement staircase deadline scheduler load weight fix
has been removed from the -mm tree.  Its filename was
     sched-implement-staircase-deadline-scheduler-load-weight-fix.patch

This patch was dropped because I need to clear the decks

------------------------------------------------------
Subject: sched: implement staircase deadline scheduler load weight fix
From: Con Kolivas <kernel@kolivas.org>

The task load_weight needs to be set every time the quota is set and wasn't
being set in activate_task which assumed it would not have changed.  Due to
changes in where the default rr_interval is set on SMP this assumption
failed.  Also if one were to change rr_interval on the fly it would break
again.

set_load_weight was unnecessarily complex in the relationship as it could
be simply set to the task_timeslice in milliseconds.  It also would not
scale enough to pick up nice 19 tasks and could give them 0 weight with a
small enough rr_interval.

Thanks to Willy Tarreau <w@1wt.eu> for spotting more smp balancing problems.

Signed-off-by: Con Kolivas <kernel@kolivas.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |   36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff -puN kernel/sched.c~sched-implement-staircase-deadline-scheduler-load-weight-fix kernel/sched.c
--- a/kernel/sched.c~sched-implement-staircase-deadline-scheduler-load-weight-fix
+++ a/kernel/sched.c
@@ -103,8 +103,6 @@ unsigned long long __attribute__((weak))
  */
 int rr_interval __read_mostly = 8;
 
-#define DEF_TIMESLICE		(rr_interval * 20)
-
 /*
  * This contains a bitmap for each dynamic priority level with empty slots
  * for the valid priorities each different nice level can have. It allows
@@ -912,16 +910,11 @@ static int task_timeslice(struct task_st
 }
 
 /*
- * Assume: static_prio_timeslice(NICE_TO_PRIO(0)) == DEF_TIMESLICE
- * If static_prio_timeslice() is ever changed to break this assumption then
- * this code will need modification. Scaled as multiples of milliseconds.
- */
-#define TIME_SLICE_NICE_ZERO DEF_TIMESLICE
-#define LOAD_WEIGHT(lp) \
-	(((lp) * SCHED_LOAD_SCALE) / TIME_SLICE_NICE_ZERO)
-#define TASK_LOAD_WEIGHT(p)	LOAD_WEIGHT(task_timeslice(p))
-#define RTPRIO_TO_LOAD_WEIGHT(rp)	\
-	(LOAD_WEIGHT((rr_interval + 20 + (rp))))
+ * The load weight is basically the task_timeslice in ms. Realtime tasks are
+ * special cased to be proportionately larger than nice -20 by their
+ * rt_priority. The weight for rt tasks can only be arbitrary at best.
+ */
+#define RTPRIO_TO_LOAD_WEIGHT(rp)	(rr_interval * 20 * (40 + rp))
 
 static void set_load_weight(struct task_struct *p)
 {
@@ -938,7 +931,7 @@ static void set_load_weight(struct task_
 #endif
 			p->load_weight = RTPRIO_TO_LOAD_WEIGHT(p->rt_priority);
 	} else
-		p->load_weight = TASK_LOAD_WEIGHT(p);
+		p->load_weight = task_timeslice(p);
 }
 
 static inline void
@@ -1021,7 +1014,7 @@ static int effective_prio(struct task_st
  * nice -20 = 10 * rr_interval. nice 1-19 = rr_interval / 2.
  * Value returned is in microseconds.
  */
-static unsigned int rr_quota(struct task_struct *p)
+static inline unsigned int rr_quota(struct task_struct *p)
 {
 	int nice = TASK_NICE(p), rr = rr_interval;
 
@@ -1035,6 +1028,13 @@ static unsigned int rr_quota(struct task
 	return MS_TO_US(rr);
 }
 
+/* Every time we set the quota we need to set the load weight */
+static void set_quota(struct task_struct *p)
+{
+	p->quota = rr_quota(p);
+	set_load_weight(p);
+}
+
 /*
  * activate_task - move a task to the runqueue and do priority recalculation
  */
@@ -1062,7 +1062,7 @@ static void activate_task(struct task_st
 				     (now - p->timestamp) >> 20);
 	}
 
-	p->quota = rr_quota(p);
+	set_quota(p);
 	p->prio = effective_prio(p);
 	p->timestamp = now;
 	__activate_task(p, rq);
@@ -4114,8 +4114,7 @@ void set_user_nice(struct task_struct *p
 	p->static_prio = NICE_TO_PRIO(nice);
 	old_prio = p->prio;
 	p->prio = effective_prio(p);
-	p->quota = rr_quota(p);
-	set_load_weight(p);
+	set_quota(p);
 	delta = p->prio - old_prio;
 
 	if (queued) {
@@ -4252,8 +4251,7 @@ static void __setscheduler(struct task_s
 	p->normal_prio = normal_prio(p);
 	/* we are holding p->pi_lock already */
 	p->prio = rt_mutex_getprio(p);
-	p->quota = rr_quota(p);
-	set_load_weight(p);
+	set_quota(p);
 }
 
 /**
_

Patches currently in -mm which might be from kernel@kolivas.org are

sched-fix-idle-load-balancing-in-softirqd-context-fix.patch
sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch
sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array-update.patch
sched-implement-staircase-deadline-scheduler-load-weight-fix.patch
sched-increase-ksoftirqd-priority.patch
sched-remove-noninteractive-flag.patch
sched-document-sd-cpu-scheduler.patch
sched-implement-staircase-deadline-scheduler-rework-priomatrix-doc.patch
sched-consolidate-sched_clock-drift-adjustments.patch
sched-consolidate-sched_clock-drift-adjustments-fix.patch
sched-implement-staircase-deadline-scheduler-docupdate.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
swap-prefetch-avoid-repeating-entry.patch
