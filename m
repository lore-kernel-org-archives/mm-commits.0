From: akpm@linux-foundation.org
Subject: + sched-implement-staircase-deadline-scheduler-ymf-accounting-fixes.patch added to -mm tree
Date: Sat, 21 Apr 2007 21:13:06 -0700
Message-ID: <200704220413.l3M4D6F3019313@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47477 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964988AbXDVENR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 22 Apr 2007 00:13:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kernel@kolivas.org, w@1wt.eu


The patch titled
     : implement staircase deadline scheduler ymf accounting fixes
has been added to the -mm tree.  Its filename is
     sched-implement-staircase-deadline-scheduler-ymf-accounting-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: : implement staircase deadline scheduler ymf accounting fixes
From: Con Kolivas <kernel@kolivas.org>

SMP balancing broke on converting time_slice to usecs.

update_cpu_clock is unnecessarily complex and doesn't allow sub usec values.

Thanks to Willy Tarreau <w@1wt.eu> for picking up SMP idle anomalies.

Signed-off-by: Con Kolivas <kernel@kolivas.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |   42 +++++++++++++++++-------------------------
 1 file changed, 17 insertions(+), 25 deletions(-)

diff -puN kernel/sched.c~sched-implement-staircase-deadline-scheduler-ymf-accounting-fixes kernel/sched.c
--- a/kernel/sched.c~sched-implement-staircase-deadline-scheduler-ymf-accounting-fixes
+++ a/kernel/sched.c
@@ -89,12 +89,10 @@ unsigned long long __attribute__((weak))
 #define SCHED_PRIO(p)		((p)+MAX_RT_PRIO)
 
 /* Some helpers for converting to/from various scales.*/
-#define NS_TO_JIFFIES(TIME)	((TIME) / (1000000000 / HZ))
 #define JIFFIES_TO_NS(TIME)	((TIME) * (1000000000 / HZ))
+#define MS_TO_NS(TIME)		((TIME) * 1000000)
 #define MS_TO_US(TIME)		((TIME) * 1000)
-/* Can return 0 */
-#define MS_TO_JIFFIES(TIME)	((TIME) * HZ / 1000)
-#define JIFFIES_TO_MS(TIME)	((TIME) * 1000 / HZ)
+#define US_TO_MS(TIME)		((TIME) / 1000)
 
 #define TASK_PREEMPTS_CURR(p, curr)	((p)->prio < (curr)->prio)
 
@@ -902,29 +900,28 @@ static void requeue_task(struct task_str
 
 /*
  * task_timeslice - the total duration a task can run during one major
- * rotation. Returns value in jiffies.
+ * rotation. Returns value in milliseconds as the smallest value can be 1.
  */
-static inline int task_timeslice(struct task_struct *p)
+static int task_timeslice(struct task_struct *p)
 {
-	int slice;
+	int slice = p->quota;	/* quota is in us */
 
-	slice = NS_TO_JIFFIES(p->quota);
 	if (!rt_task(p))
 		slice += (PRIO_RANGE - 1 - TASK_USER_PRIO(p)) * slice;
-	return slice;
+	return US_TO_MS(slice);
 }
 
 /*
  * Assume: static_prio_timeslice(NICE_TO_PRIO(0)) == DEF_TIMESLICE
  * If static_prio_timeslice() is ever changed to break this assumption then
- * this code will need modification
+ * this code will need modification. Scaled as multiples of milliseconds.
  */
 #define TIME_SLICE_NICE_ZERO DEF_TIMESLICE
 #define LOAD_WEIGHT(lp) \
 	(((lp) * SCHED_LOAD_SCALE) / TIME_SLICE_NICE_ZERO)
 #define TASK_LOAD_WEIGHT(p)	LOAD_WEIGHT(task_timeslice(p))
 #define RTPRIO_TO_LOAD_WEIGHT(rp)	\
-	(LOAD_WEIGHT((MS_TO_JIFFIES(rr_interval) + 20 + (rp))))
+	(LOAD_WEIGHT((rr_interval + 20 + (rp))))
 
 static void set_load_weight(struct task_struct *p)
 {
@@ -3263,32 +3260,27 @@ static void
 update_cpu_clock(struct task_struct *p, struct rq *rq, unsigned long long now,
 		 int tick)
 {
-	cputime64_t time_diff = now - p->last_ran;
-	const unsigned int min_diff = 1000;
-	int us_time_diff;
+	long time_diff = now - p->last_ran;
 
 	if (tick) {
 		/*
 		 * Called from scheduler_tick() there should be less than two
 		 * jiffies worth, and not negative/overflow.
 		 */
-		if (time_diff > JIFFIES_TO_NS(2) || time_diff < min_diff)
+		if (time_diff > JIFFIES_TO_NS(2) || time_diff < 0)
 			time_diff = JIFFIES_TO_NS(1);
 	} else {
 		/*
 		 * Called from context_switch there should be less than one
-		 * jiffy worth, and not negative/overflowed. In the case when
-		 * sched_clock fails to return high resolution values this
-		 * also ensures at least 1 min_diff gets banked.
+		 * jiffy worth, and not negative/overflow. There should be
+		 * some time banked here so use a nominal 1ms.
 		 */
-		if (time_diff > JIFFIES_TO_NS(1) || time_diff < min_diff)
-			time_diff = min_diff;
+		if (time_diff > JIFFIES_TO_NS(1) || time_diff < 1)
+			time_diff = 1000;
 	}
 	/* time_slice accounting is done in usecs to avoid overflow on 32bit */
-	us_time_diff = time_diff;
-	us_time_diff /= 1000;
 	if (p != rq->idle && p->policy != SCHED_FIFO)
-		p->time_slice -= us_time_diff;
+		p->time_slice -= time_diff / 1000;
 	p->sched_time += time_diff;
 	p->last_ran = rq->most_recent_timestamp = now;
 }
@@ -4868,8 +4860,8 @@ long sys_sched_rr_get_interval(pid_t pid
 	if (retval)
 		goto out_unlock;
 
-	jiffies_to_timespec(p->policy == SCHED_FIFO ?
-				0 : task_timeslice(p), &t);
+	t = ns_to_timespec(p->policy == SCHED_FIFO ? 0 :
+			   MS_TO_NS(task_timeslice(p)));
 	read_unlock(&tasklist_lock);
 	retval = copy_to_user(interval, &t, sizeof(t)) ? -EFAULT : 0;
 out_nounlock:
_

Patches currently in -mm which might be from kernel@kolivas.org are

sched-fix-idle-load-balancing-in-softirqd-context-fix.patch
sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch
sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array-update.patch
sched-dont-renice-kernel-threads.patch
sched-remove-sleepavg-from-proc.patch
revert-sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch
sched-implement-staircase-deadline-cpu-scheduler.patch
sched-implement-staircase-deadline-cpu-scheduler-misc-fixes.patch
sched-implement-staircase-deadline-cpu-scheduler-staircase-improvements.patch
sched-implement-staircase-deadline-cpu-scheduler-improvements-fix.patch
sched-implement-staircase-deadline-cpu-scheduler-avoid-redundant-reschedule-in-set_user_nice.patch
sched-implement-staircase-deadline-cpu-scheduler-tweak.patch
sched-implement-staircase-deadline-scheduler-rework-priomatrix.patch
sched-implement-staircase-deadline-scheduler-further-improvements-1.patch
sched-implement-staircase-deadline-scheduler-timeslice-fixes.patch
sched-implement-staircase-scheduler-yaf-fix.patch
sched-implement-staircase-deadline-scheduler-ymf-accounting-fixes.patch
sched-increase-ksoftirqd-priority.patch
sched-remove-noninteractive-flag.patch
sched-document-sd-cpu-scheduler.patch
sched-implement-staircase-deadline-scheduler-rework-priomatrix-doc.patch
sched-consolidate-sched_clock-drift-adjustments.patch
sched-implement-staircase-deadline-scheduler-docupdate.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
swap-prefetch-avoid-repeating-entry.patch
