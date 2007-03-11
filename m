From: akpm@linux-foundation.org
Subject: + sched-implement-rsdl-cpu-scheduler.patch added to -mm tree
Date: Sat, 10 Mar 2007 22:25:02 -0800
Message-ID: <200703110625.l2B6P2ap005865@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37790 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933238AbXCKGZb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Mar 2007 01:25:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kernel@kolivas.org, mingo@elte.hu, nickpiggin@yahoo.com.au, suresh.b.siddha@intel.com


The patch titled
     sched: implement rsdl cpu scheduler
has been added to the -mm tree.  Its filename is
     sched-implement-rsdl-cpu-scheduler.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sched: implement rsdl cpu scheduler
From: Con Kolivas <kernel@kolivas.org>

Implement the "Rotating Staircase DeadLine" RSDL cpu scheduler policy.

Rotating Staircase Deadline cpu scheduler policy
================================================

Design summary
==============

A novel design which incorporates a foreground-background descending priority
system (the staircase) with runqueue managed minor and major epochs (rotation
and deadline).

Features
========

A starvation free, strict fairness O(1) scalable design with interactivity as
good as the above restrictions can provide.  There is no interactivity
estimator, no sleep/run measurements and only simple fixed accounting.  The
design has strict enough a design and accounting that task behaviour can be
modelled and maximum scheduling latencies can be predicted by the virtual
deadline mechanism that manages runqueues.  The prime concern in this design
is to maintain fairness at all costs determined by nice level, yet to maintain
as good interactivity as can be allowed within the constraints of strict
fairness.

Design description
==================

RSDL works off the principle of providing each task a quota of runtime that it
is allowed to run at each priority level equal to its static priority (ie.
its nice level) and every priority below that.  When each task is queued, the
cpu that it is queued onto also keeps a record of that quota.  If the task
uses up its quota it is decremented one priority level.  Also, if the cpu
notices a quota full has been used for that priority level, it pushes
everything remaining at that priority level to the next lowest priority level.
 Once every runtime quota has been consumed of every priority level, a task is
queued on the "expired" array.  When no other tasks exist with quota, the
expired array is activated and fresh quotas are handed out.  This is all done
in O(1).

Design details
==============

Each cpu has its own runqueue which micromanages its own epochs, and each task
keeps a record of its own entitlement of cpu time.  Most of the rest of these
details apply to non-realtime tasks as rt task management is straight forward.

Each runqueue keeps a record of what major epoch it is up to in the
rq->prio_rotation field which is incremented on each major epoch.  It also
keeps a record of quota available to each priority value valid for that major
epoch in rq->prio_quota[].

Each task keeps a record of what major runqueue epoch it was last running on
in p->rotation.  It also keeps a record of what priority levels it has already
been allocated quota from during this epoch in a bitmap p->bitmap.

The only tunable that determines all other details is the RR_INTERVAL.  This
is set to 6ms (minimum on 1000HZ, higher at different HZ values).

All tasks are initially given a quota based on RR_INTERVAL.  This is equal to
RR_INTERVAL between nice values of 0 and 19, and progressively larger for nice
values from -1 to -20.  This is assigned to p->quota and only changes with
changes in nice level.

As a task is first queued, it checks in recalc_task_prio to see if it has run
at this runqueue's current priority rotation.  If it has not, it will have its
p->prio level set to equal its p->static_prio (nice level) and will be given a
p->time_slice equal to the p->quota, and has its allocation bitmap bit set in
p->bitmap for its static priority (nice value).  This quota is then also added
to the current runqueue's rq->prio_quota[p->prio].  It is then queued on the
current active priority array.

If a task has already been running during this major epoch, if it has
p->time_slice left and the rq->prio_quota for the task's p->prio still has
quota, it will be placed back on the active array, but no more quota will be
added to either the task or the runqueue quota.

If a task has been running during this major epoch, but does not have
p->time_slice left or the runqueue's prio_quota for this task's p->prio does
not have quota, it will find the next lowest priority in its bitmap that it
has not been allocated quota from.  It then gets the a full quota in
p->time_slice and adds that to the quota value for the relevant priority
rq->prio_quota.  It is then queued on the current active priority array at the
newly determined lower priority.

If a task has been running during this major epoch, and does not have any
entitlement left in p->bitmap and no time_slice left, it will have its bitmap
cleared, and be queued at its p->static_prio again, but on the expired
priority array.  No quota will be allocated until this task is scheduled.

When a task is queued, it has its static_prio bit set in the current
runqueue's rq->static_bitmap, and the relevant bit in the rq->dyn_bitmap.  In
order to minimise the number of bitmap lookups, the bitmap of queued tasks on
the expired array is at the end of the same bitmap as the active array.  The
number of tasks queued at the current static_prio is kept in
rq->prio_queued[].

During a scheduler_tick where a task is running, the p->time_slice is
decremented, and if it reaches zero then the recalc_task_prio is readjusted
and the task rescheduled.

During a task running tick, the runqueue prio_quota is also decremented.  If
it empties then a priority rotation occurs (a major or minor epoch).  If the
current runqueue's priority level is better than that of nice 19 tasks, a
minor rotation is performed, otherwise a major rotation will occur.

A minor rotation takes the remaining tasks at this priority level queue and
merges them with a list_splice_tail with the queue from the next lowest
priority level.  At this time, any tasks that have been merged will now have
invalid values in p->prio so this must be considered when dequeueing the task,
and for testing for preemption.

A major rotation takes the remaining tasks at this priority level queue and
merges them with a list_splice_tail with the best priority task running on the
expired array, and swaps the priority arrays.  The priority quotas are reset
at this time.  Any tasks that have been merged will now have invalid values in
p->array and possibly p->prio so this must be considered.  The
rq->prio_rotation is incremented at this time.

When a task is dequeued, the dyn_bitmap bit is unset only after testing that
the relevant queue is actually empty since p->prio may be inaccurate and no
hard accounting of the number of tasks at that level is possible.

When selecting a new task for scheduling, after the first dynamic bit is found
on the dyn_bitmap, it is checked to see that a task is really queued at that
priority or if it is a false positive due to the task being dequeued at a time
when its p->prio does not match which queue it is on after some form of
priority rotation.  This is a rare occurrence as it tends to only occur if a
task that is already waiting on a runqueue gets dequeued.  If the bitmap value
is in the expired array range, a major priority rotation is performed.  If the
chosen task has not been running during this major or minor rotation it has
new quota allocated at this time, and added to the runqueue's quota.

Modelling deadline behaviour
============================

As the accounting in this design is hard and not modified by sleep average
calculations or interactivity modifiers, it is possible to accurately predict
the maximum latency that a task may experience under different conditions.
This is a virtual deadline mechanism enforced by mandatory runqueue epochs,
and not by trying to keep complicated accounting of each task.

The maximum duration a task can run during one major epoch is determined by
its nice value.  Nice 0 tasks can run at 19 different priority levels for
RR_INTERVAL duration during each epoch (the equivalent of nice 0 to nice 19).
Nice 10 tasks can run at 9 priority levels for each epoch, and so on.

Therefore the maximum duration a runqueue epoch can take is determined by the
number of tasks running, and their nice level.  After that, the maximum
duration it can take before a task can wait before it get scheduled is
determined by the difference between its nice value and the nice value of the
highest priority task queued.

In the following examples, these are _worst case scenarios_ and would rarely
occur, but can be modelled nonetheless to determine the maximum possible
latency.

So for example, if two nice 0 tasks are running, and one has just expired as
another is activated for the first time receiving a full quota for this
runqueue rotation, the first task will wait:

nr_tasks * max_duration + nice_difference * rr_interval
1 * 19 * RR_INTERVAL + 0 = 114ms

In the presence of a nice 10 task, a nice 0 task would wait a maximum of
1 * 10 * RR_INTERVAL + 0 = 60ms

In the presence of a nice 0 task, a nice 10 task would wait a maximum of
1 * 19 * RR_INTERVAL + 9 * RR_INTERVAL = 168ms

Using a more complicated example, if there are 4 tasks running fully cpu
bound, one each at nice -20, nice 0, nice 10 and nice 19, we can calculate the
maximum latency possible for the nice 10 task.  Note that -20 tasks are
heavily biased for so this will be a long time, but can be modelled.

The nice -20 task has quota = RR_INTERVAL + 20*RR_INTERVAL = 21*RR_INTERVAL.
It can run at 39 priority levels so its maximum duration =
39 * 21 * RR_INTERVAL.
The nice 0 task works out to
19 * RR_INTERVAL
The nice 19 task works out to
RR_INTERVAL.

So major epoch can take up a maximum of
39 * 21 * RR_INTERVAL + 19 * RR_INTERVAL + RR_INTERVAL = 1229 * RR_INTERVAL;

Then before the nice 10 task will run, the nice -20 and nice 0 task will
run for 28 * 21 * RR_INTERVAL and 9 * RR_INTERVAL respectively for a total
of 597 * RR_INTERVAL.

This means the maximum duration a nice 10 task can wait in the presence of
these other tasks is 1826*RR_INTERVAL.  This is a long time of course and is
heavily penalised by the presence of nice -20 tasks which would not be part of
a normal environment.

While this section describes the maximum latency a task can have, this size
latencies will only be seen by fully cpu bound tasks.

Achieving interactivity
=======================

A requirement of this scheduler design was to achieve good interactivity
despite being a completely fair deadline based design.  The disadvantage of
designs that try to achieve interactivity is that they usually do so at the
expense of maintaining fairness.  As cpu speeds increase, the requirement for
some sort of metered unfairness towards interactive tasks becomes a less
desirable phenomenon, but low latency and fairness remains mandatory to good
interactive performance.

This design relies on the fact that interactive tasks, by their nature, sleep
often.  Most fair scheduling designs end up penalising such tasks indirectly
giving them less than their fair possible share because of the sleep, and have
to use a mechanism of bonusing their priority to offset this based on the
duration they sleep.  This becomes increasingly inaccurate as the number of
running tasks rises and more tasks spend time waiting on runqueues rather than
sleeping, and it is impossible to tell whether the task that's waiting on a
runqueue only intends to run for a short period and then sleep again after
than runqueue wait.  Furthermore, all such designs rely on a period of time to
pass to accumulate some form of statistic on the task before deciding on how
much to give them preference.  The shorter this period, the more rapidly
bursts of cpu ruin the interactive tasks behaviour.  The longer this period,
the longer it takes for interactive tasks to get low scheduling latencies and
fair cpu.

This design does not measure sleep time at all.  Interactive tasks that sleep
often will wake up having consumed very little if any of their quota for the
current major priority rotation.  The longer they have slept, the less likely
they are to even be on the current major priority rotation.  Once woken up,
though, they get to use up a their full quota for that epoch, whether part of
a quota remains or a full quota.  Overall, however, they can still only run as
much cpu time for that epoch as any other task of the same nice level.  This
means that two tasks behaving completely differently from fully cpu bound to
waking/sleeping extremely frequently will still get the same quota of cpu, but
the latter will be using its quota for that epoch in bursts rather than
continuously.  This guarantees that interactive tasks get the same amount of
cpu as cpu bound ones.

The other requirement of interactive tasks is also to obtain low latencies for
when they are scheduled.  Unlike fully cpu bound tasks and the maximum
latencies possible described in the modelling deadline behaviour section
above, tasks that sleep will wake up with quota available usually at the
current runqueue's priority_level or better.  This means that the most latency
they are likely to see is one RR_INTERVAL, and often they will preempt the
current task if it is not of a sleeping nature.  This then guarantees very low
latency for interactive tasks, and the lowest latencies for the least cpu
bound tasks.

Signed-off-by: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/init_task.h |    2 
 include/linux/sched.h     |   32 
 kernel/sched.c            | 1229 +++++++++++++++++-------------------
 3 files changed, 627 insertions(+), 636 deletions(-)

diff -puN include/linux/init_task.h~sched-implement-rsdl-cpu-scheduler include/linux/init_task.h
--- a/include/linux/init_task.h~sched-implement-rsdl-cpu-scheduler
+++ a/include/linux/init_task.h
@@ -102,6 +102,7 @@ extern struct group_info init_groups;
 	.prio		= MAX_PRIO-20,					\
 	.static_prio	= MAX_PRIO-20,					\
 	.normal_prio	= MAX_PRIO-20,					\
+	.rotation	= 0,						\
 	.policy		= SCHED_NORMAL,					\
 	.cpus_allowed	= CPU_MASK_ALL,					\
 	.mm		= NULL,						\
@@ -109,6 +110,7 @@ extern struct group_info init_groups;
 	.run_list	= LIST_HEAD_INIT(tsk.run_list),			\
 	.ioprio		= 0,						\
 	.time_slice	= HZ,						\
+	.quota		= HZ,						\
 	.tasks		= LIST_HEAD_INIT(tsk.tasks),			\
 	.ptrace_children= LIST_HEAD_INIT(tsk.ptrace_children),		\
 	.ptrace_list	= LIST_HEAD_INIT(tsk.ptrace_list),		\
diff -puN include/linux/sched.h~sched-implement-rsdl-cpu-scheduler include/linux/sched.h
--- a/include/linux/sched.h~sched-implement-rsdl-cpu-scheduler
+++ a/include/linux/sched.h
@@ -529,8 +529,9 @@ struct signal_struct {
 
 #define MAX_USER_RT_PRIO	100
 #define MAX_RT_PRIO		MAX_USER_RT_PRIO
+#define PRIO_RANGE		(40)
 
-#define MAX_PRIO		(MAX_RT_PRIO + 40)
+#define MAX_PRIO		(MAX_RT_PRIO + PRIO_RANGE)
 
 #define rt_prio(prio)		unlikely((prio) < MAX_RT_PRIO)
 #define rt_task(p)		rt_prio((p)->prio)
@@ -798,13 +799,6 @@ struct mempolicy;
 struct pipe_inode_info;
 struct uts_namespace;
 
-enum sleep_type {
-	SLEEP_NORMAL,
-	SLEEP_NONINTERACTIVE,
-	SLEEP_INTERACTIVE,
-	SLEEP_INTERRUPTED,
-};
-
 struct prio_array;
 
 struct task_struct {
@@ -824,20 +818,36 @@ struct task_struct {
 	int load_weight;	/* for niceness load balancing purposes */
 	int prio, static_prio, normal_prio;
 	struct list_head run_list;
+	DECLARE_BITMAP(bitmap, PRIO_RANGE + 1);
+	/*
+	 * This bitmap shows what priorities this task has received quota
+	 * from for this major priority rotation on its current runqueue.
+	 */
 	struct prio_array *array;
+	unsigned long rotation;
+	/* Which major runqueue rotation did this task run */
 
 	unsigned short ioprio;
 #ifdef CONFIG_BLK_DEV_IO_TRACE
 	unsigned int btrace_seq;
 #endif
-	unsigned long sleep_avg;
 	unsigned long long timestamp, last_ran;
 	unsigned long long sched_time; /* sched_clock time spent running */
-	enum sleep_type sleep_type;
 
 	unsigned int policy;
 	cpumask_t cpus_allowed;
-	unsigned int time_slice, first_time_slice;
+	unsigned int time_slice;
+	/*
+	 * How much this task is entitled to run at the current priority
+	 * before being requeued at a lower priority.
+	 */
+	unsigned int first_time_slice;
+	/* Is this the very first time_slice this task has ever run. */
+	unsigned int quota;
+	/*
+	 * How much this task contributes to the current priority queue
+	 * length
+	 */
 
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
 	struct sched_info sched_info;
diff -puN kernel/sched.c~sched-implement-rsdl-cpu-scheduler kernel/sched.c
--- a/kernel/sched.c~sched-implement-rsdl-cpu-scheduler
+++ a/kernel/sched.c
@@ -16,6 +16,7 @@
  *		by Davide Libenzi, preemptible kernel bits by Robert Love.
  *  2003-09-03	Interactivity tuning by Con Kolivas.
  *  2004-04-02	Scheduler domains code by Nick Piggin
+ *  2007-03-02	Rotating Staircase deadline scheduling policy by Con Kolivas
  */
 
 #include <linux/mm.h>
@@ -84,103 +85,27 @@ unsigned long long __attribute__((weak))
 #define USER_PRIO(p)		((p)-MAX_RT_PRIO)
 #define TASK_USER_PRIO(p)	USER_PRIO((p)->static_prio)
 #define MAX_USER_PRIO		(USER_PRIO(MAX_PRIO))
+#define SCHED_PRIO(p)		((p)+MAX_RT_PRIO)
+#define MAX_DYN_PRIO		(MAX_PRIO + PRIO_RANGE)
 
 /*
- * Some helpers for converting nanosecond timing to jiffy resolution
+ * Preemption needs to take into account that a low priority task can be
+ * at a higher prio due to list merging. Its priority is artificially
+ * elevated and it should be preempted if anything higher priority wakes up
+ * provided it is not a realtime comparison.
  */
-#define NS_TO_JIFFIES(TIME)	((TIME) / (1000000000 / HZ))
-#define JIFFIES_TO_NS(TIME)	((TIME) * (1000000000 / HZ))
+#define TASK_PREEMPTS_CURR(p, curr) \
+	(((p)->prio < (curr)->prio) || (((p)->prio == (curr)->prio) && \
+		((p)->static_prio < (curr)->static_prio && \
+			((curr)->static_prio > (curr)->prio)) && \
+				!rt_task(p)))
 
 /*
- * These are the 'tuning knobs' of the scheduler:
- *
- * Minimum timeslice is 5 msecs (or 1 jiffy, whichever is larger),
- * default timeslice is 100 msecs, maximum timeslice is 800 msecs.
- * Timeslices get refilled after they expire.
- */
-#define MIN_TIMESLICE		max(5 * HZ / 1000, 1)
-#define DEF_TIMESLICE		(100 * HZ / 1000)
-#define ON_RUNQUEUE_WEIGHT	 30
-#define CHILD_PENALTY		 95
-#define PARENT_PENALTY		100
-#define EXIT_WEIGHT		  3
-#define PRIO_BONUS_RATIO	 25
-#define MAX_BONUS		(MAX_USER_PRIO * PRIO_BONUS_RATIO / 100)
-#define INTERACTIVE_DELTA	  2
-#define MAX_SLEEP_AVG		(DEF_TIMESLICE * MAX_BONUS)
-#define STARVATION_LIMIT	(MAX_SLEEP_AVG)
-#define NS_MAX_SLEEP_AVG	(JIFFIES_TO_NS(MAX_SLEEP_AVG))
-
-/*
- * If a task is 'interactive' then we reinsert it in the active
- * array after it has expired its current timeslice. (it will not
- * continue to run immediately, it will still roundrobin with
- * other interactive tasks.)
- *
- * This part scales the interactivity limit depending on niceness.
- *
- * We scale it linearly, offset by the INTERACTIVE_DELTA delta.
- * Here are a few examples of different nice levels:
- *
- *  TASK_INTERACTIVE(-20): [1,1,1,1,1,1,1,1,1,0,0]
- *  TASK_INTERACTIVE(-10): [1,1,1,1,1,1,1,0,0,0,0]
- *  TASK_INTERACTIVE(  0): [1,1,1,1,0,0,0,0,0,0,0]
- *  TASK_INTERACTIVE( 10): [1,1,0,0,0,0,0,0,0,0,0]
- *  TASK_INTERACTIVE( 19): [0,0,0,0,0,0,0,0,0,0,0]
- *
- * (the X axis represents the possible -5 ... 0 ... +5 dynamic
- *  priority range a task can explore, a value of '1' means the
- *  task is rated interactive.)
- *
- * Ie. nice +19 tasks can never get 'interactive' enough to be
- * reinserted into the active array. And only heavily CPU-hog nice -20
- * tasks will be expired. Default nice 0 tasks are somewhere between,
- * it takes some effort for them to get interactive, but it's not
- * too hard.
+ * This is the time all tasks within the same priority round robin.
+ * Set to a minimum of 6ms.
  */
-
-#define CURRENT_BONUS(p) \
-	(NS_TO_JIFFIES((p)->sleep_avg) * MAX_BONUS / \
-		MAX_SLEEP_AVG)
-
-#define GRANULARITY	(10 * HZ / 1000 ? : 1)
-
-#ifdef CONFIG_SMP
-#define TIMESLICE_GRANULARITY(p)	(GRANULARITY * \
-		(1 << (((MAX_BONUS - CURRENT_BONUS(p)) ? : 1) - 1)) * \
-			num_online_cpus())
-#else
-#define TIMESLICE_GRANULARITY(p)	(GRANULARITY * \
-		(1 << (((MAX_BONUS - CURRENT_BONUS(p)) ? : 1) - 1)))
-#endif
-
-#define SCALE(v1,v1_max,v2_max) \
-	(v1) * (v2_max) / (v1_max)
-
-#define DELTA(p) \
-	(SCALE(TASK_NICE(p) + 20, 40, MAX_BONUS) - 20 * MAX_BONUS / 40 + \
-		INTERACTIVE_DELTA)
-
-#define TASK_INTERACTIVE(p) \
-	((p)->prio <= (p)->static_prio - DELTA(p))
-
-#define INTERACTIVE_SLEEP(p) \
-	(JIFFIES_TO_NS(MAX_SLEEP_AVG * \
-		(MAX_BONUS / 2 + DELTA((p)) + 1) / MAX_BONUS - 1))
-
-#define TASK_PREEMPTS_CURR(p, rq) \
-	((p)->prio < (rq)->curr->prio)
-
-#define SCALE_PRIO(x, prio) \
-	max(x * (MAX_PRIO - prio) / (MAX_USER_PRIO / 2), MIN_TIMESLICE)
-
-static unsigned int static_prio_timeslice(int static_prio)
-{
-	if (static_prio < NICE_TO_PRIO(0))
-		return SCALE_PRIO(DEF_TIMESLICE * 4, static_prio);
-	else
-		return SCALE_PRIO(DEF_TIMESLICE, static_prio);
-}
+#define RR_INTERVAL		((6 * HZ / 1001) + 1)
+#define DEF_TIMESLICE		(RR_INTERVAL * 20)
 
 #ifdef CONFIG_SMP
 /*
@@ -204,27 +129,11 @@ static inline void sg_inc_cpu_power(stru
 #endif
 
 /*
- * task_timeslice() scales user-nice values [ -20 ... 0 ... 19 ]
- * to time slice values: [800ms ... 100ms ... 5ms]
- *
- * The higher a thread's priority, the bigger timeslices
- * it gets during one round of execution. But even the lowest
- * priority thread gets MIN_TIMESLICE worth of execution time.
- */
-
-static inline unsigned int task_timeslice(struct task_struct *p)
-{
-	return static_prio_timeslice(p->static_prio);
-}
-
-/*
  * These are the runqueue data structures:
  */
-
 struct prio_array {
-	unsigned int nr_active;
-	DECLARE_BITMAP(bitmap, MAX_PRIO+1); /* include 1 bit for delimiter */
 	struct list_head queue[MAX_PRIO];
+	/* Tasks queued at each priority */
 };
 
 /*
@@ -260,14 +169,40 @@ struct rq {
 	 */
 	unsigned long nr_uninterruptible;
 
-	unsigned long expired_timestamp;
 	/* Cached timestamp set by update_cpu_clock() */
 	unsigned long long most_recent_timestamp;
 	struct task_struct *curr, *idle;
 	unsigned long next_balance;
 	struct mm_struct *prev_mm;
+
+	DECLARE_BITMAP(dyn_bitmap, MAX_DYN_PRIO + 1);
+	/*
+	 * The bitmap of priorities queued; The extra PRIO_RANGE at the end
+	 * is for a bitmap of expired tasks queued. This minimises the number
+	 * of bit lookups over prio_array swaps. The dynamic bits can have
+	 * false positives. Include 1 bit for delimiter.
+	 */
+
+	DECLARE_BITMAP(static_bitmap, MAX_PRIO);
+	/* The bitmap of all static priorities queued */
+
+	unsigned long prio_queued[MAX_PRIO];
+	/* The number of tasks at each static priority */
+
+	long prio_quota[PRIO_RANGE];
+	/*
+	 * The quota of ticks the runqueue runs at each dynamic priority
+	 * before cycling to the next priority.
+	 */
+
 	struct prio_array *active, *expired, arrays[2];
-	int best_expired_prio;
+
+	int prio_level;
+	/* The current dynamic priority level this runqueue is at */
+
+	unsigned long prio_rotation;
+	/* How many times we have rotated the priority queue */
+
 	atomic_t nr_iowait;
 
 #ifdef CONFIG_SMP
@@ -606,12 +541,9 @@ static inline struct rq *this_rq_lock(vo
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
 /*
  * Called when a process is dequeued from the active array and given
- * the cpu.  We should note that with the exception of interactive
- * tasks, the expired queue will become the active queue after the active
- * queue is empty, without explicitly dequeuing and requeuing tasks in the
- * expired queue.  (Interactive tasks may be requeued directly to the
- * active queue, thus delaying tasks in the expired queue from running;
- * see scheduler_tick()).
+ * the cpu.  We should note that the expired queue will become the active
+ * queue after the active queue is empty, without explicitly dequeuing and
+ * requeuing tasks in the expired queue.
  *
  * This function is only called from sched_info_arrive(), rather than
  * dequeue_task(). Even though a task may be queued and dequeued multiple
@@ -709,71 +641,181 @@ sched_info_switch(struct task_struct *pr
 #define sched_info_switch(t, next)	do { } while (0)
 #endif /* CONFIG_SCHEDSTATS || CONFIG_TASK_DELAY_ACCT */
 
+static inline int task_queued(struct task_struct *task)
+{
+	return !list_empty(&task->run_list);
+}
+
+static inline void set_task_entitlement(struct task_struct *p)
+{
+	__set_bit(USER_PRIO(p->prio), p->bitmap);
+
+	/*
+	 * In the case this task has been part of a merged list that has
+	 * made it to higher priority than it should be, we remove the
+	 * quota from its own priority since it will get a quota at this
+	 * priority.
+	 */
+	if (p->normal_prio < p->static_prio)
+		__set_bit(USER_PRIO(p->static_prio), p->bitmap);
+	p->time_slice = p->quota;
+}
+
 /*
- * Adding/removing a task to/from a priority array:
+ * Only the static_bitmap has hard accounting. The dynamic bits can have
+ * false positives. rt_tasks can only be on the active queue.
  */
-static void dequeue_task(struct task_struct *p, struct prio_array *array)
+static inline void set_dynamic_bit(struct task_struct *p, struct rq *rq)
 {
-	array->nr_active--;
-	list_del(&p->run_list);
-	if (list_empty(array->queue + p->prio))
-		__clear_bit(p->prio, array->bitmap);
+	if (p->array == rq->active)
+		__set_bit(p->prio, rq->dyn_bitmap);
+	else
+		__set_bit(p->prio + PRIO_RANGE, rq->dyn_bitmap);
 }
 
-static void enqueue_task(struct task_struct *p, struct prio_array *array)
+static inline void set_queue_bits(struct rq *rq, struct task_struct *p)
 {
-	sched_info_queued(p);
-	list_add_tail(&p->run_list, array->queue + p->prio);
-	__set_bit(p->prio, array->bitmap);
-	array->nr_active++;
-	p->array = array;
+	__set_bit(p->static_prio, rq->static_bitmap);
+	set_dynamic_bit(p, rq);
 }
 
 /*
- * Put task to the end of the run list without the overhead of dequeue
- * followed by enqueue.
+ * Removing from a runqueue. While we don't know with absolute certainty
+ * where this task really is, the p->array and p->prio are very likely
+ * so we check that queue to see if we can clear that bit to take some
+ * load off finding false positives in next_dynamic_task().
  */
-static void requeue_task(struct task_struct *p, struct prio_array *array)
+static void dequeue_task(struct task_struct *p, struct rq *rq)
 {
-	list_move_tail(&p->run_list, array->queue + p->prio);
+	list_del_init(&p->run_list);
+	if (!--rq->prio_queued[p->static_prio])
+		__clear_bit(p->static_prio, rq->static_bitmap);
+	if (list_empty(p->array->queue + p->prio)) {
+		int bitmap_prio = p->prio;
+
+		if (p->array == rq->expired)
+			bitmap_prio += PRIO_RANGE;
+		__clear_bit(bitmap_prio, rq->dyn_bitmap);
+	}
 }
 
-static inline void
-enqueue_task_head(struct task_struct *p, struct prio_array *array)
+/*
+ * The task is being queued on a fresh array so it has its entitlement
+ * bitmap cleared.
+ */
+static inline void task_new_array(struct task_struct *p, struct rq *rq)
+{
+	bitmap_zero(p->bitmap, PRIO_RANGE);
+	p->rotation = rq->prio_rotation;
+}
+
+static inline void queue_expired(struct task_struct *p, struct rq *rq)
+{
+	p->prio = p->normal_prio = p->static_prio;
+	p->array = rq->expired;
+	bitmap_zero(p->bitmap, PRIO_RANGE);
+	p->rotation = rq->prio_rotation;
+	p->time_slice = p->quota;
+}
+
+#define rq_quota(rq, prio)	((rq)->prio_quota[USER_PRIO(prio)])
+/*
+ * recalc_task_prio determines what prio a non rt_task will be
+ * queued at. If the task has already been running during this runqueue's
+ * major rotation (rq->prio_rotation) then it continues at the same
+ * priority if it has tick entitlement left. If it does not have entitlement
+ * left, it finds the next priority slot according to its nice value that it
+ * has not extracted quota from. If it has not run during this major
+ * rotation, it starts at its static priority and has its bitmap quota
+ * cleared. If it does not have any slots left it has all its slots reset and
+ * is queued on the expired at its static priority.
+ */
+static void recalc_task_prio(struct task_struct *p, struct rq *rq)
 {
-	list_add(&p->run_list, array->queue + p->prio);
-	__set_bit(p->prio, array->bitmap);
-	array->nr_active++;
+	struct prio_array *array = rq->active;
+	int queue_prio, search_prio;
+
+	if (p->rotation == rq->prio_rotation) {
+		if (p->array == array) {
+			if (p->time_slice && rq_quota(rq, p->prio))
+				return;
+		} else if (p->array == rq->expired) {
+			queue_expired(p, rq);
+			return;
+		} else
+			task_new_array(p, rq);
+	} else
+		task_new_array(p, rq);
+	search_prio = p->static_prio;
+
+	/*
+	 * SCHED_BATCH tasks never start at better priority than any other
+	 * task that is already running since they are flagged as latency
+	 * insensitive. This means they never cause greater latencies in other
+	 * non SCHED_BATCH tasks of the same nice level.
+	 */
+	if (unlikely(p->policy == SCHED_BATCH))
+		search_prio = max(p->static_prio, rq->prio_level);
+	queue_prio = SCHED_PRIO(find_next_zero_bit(p->bitmap, PRIO_RANGE,
+		     USER_PRIO(search_prio)));
+	if (queue_prio == MAX_PRIO) {
+		queue_expired(p, rq);
+		return;
+	}
+	rq_quota(rq, queue_prio) += p->quota;
+	p->prio = p->normal_prio = queue_prio;
 	p->array = array;
+	set_task_entitlement(p);
 }
 
 /*
- * __normal_prio - return the priority that is based on the static
- * priority but is modified by bonuses/penalties.
- *
- * We scale the actual sleep average [0 .... MAX_SLEEP_AVG]
- * into the -5 ... 0 ... +5 bonus/penalty range.
- *
- * We use 25% of the full 0...39 priority range so that:
- *
- * 1) nice +19 interactive tasks do not preempt nice 0 CPU hogs.
- * 2) nice -20 CPU hogs do not get preempted by nice 0 tasks.
- *
- * Both properties are important to certain workloads.
+ * Adding to a runqueue. The dynamic priority queue that it is added to is
+ * determined by the priority rotation of the runqueue it is being added to
+ * and the quota still available in the task in p->bitmap and p->time_slice
+ * (see recalc_task_prio above). The rq static_bitmap stores a list of
+ * the static priorities, and prio_queued the number of tasks stored at each
+ * p->static_prio level.
  */
+static inline void __enqueue_task(struct task_struct *p, struct rq *rq)
+{
+	if (rt_task(p))
+		p->array = rq->active;
+	else
+		recalc_task_prio(p, rq);
+	rq->prio_queued[p->static_prio]++;
 
-static inline int __normal_prio(struct task_struct *p)
+	sched_info_queued(p);
+	set_queue_bits(rq, p);
+}
+
+static void enqueue_task(struct task_struct *p, struct rq *rq)
 {
-	int bonus, prio;
+	__enqueue_task(p, rq);
+	list_add_tail(&p->run_list, p->array->queue + p->prio);
+}
 
-	bonus = CURRENT_BONUS(p) - MAX_BONUS / 2;
+static inline void enqueue_task_head(struct task_struct *p, struct rq *rq)
+{
+	__enqueue_task(p, rq);
+	list_add(&p->run_list, p->array->queue + p->prio);
+}
 
-	prio = p->static_prio - bonus;
-	if (prio < MAX_RT_PRIO)
-		prio = MAX_RT_PRIO;
-	if (prio > MAX_PRIO-1)
-		prio = MAX_PRIO-1;
-	return prio;
+/*
+ * requeue_task is only called when p->static_prio does not change. p->prio
+ * can change with dynamic tasks.
+ */
+static void requeue_task(struct task_struct *p, struct rq *rq,
+			 struct prio_array *old_array, int old_prio)
+{
+	list_move_tail(&p->run_list, p->array->queue + p->prio);
+	if (!rt_task(p)) {
+		if (list_empty(old_array->queue + old_prio)) {
+			if (old_array == rq->expired)
+				old_prio += PRIO_RANGE;
+			__clear_bit(old_prio, rq->dyn_bitmap);
+		}
+		set_dynamic_bit(p, rq);
+	}
 }
 
 /*
@@ -786,6 +828,20 @@ static inline int __normal_prio(struct t
  */
 
 /*
+ * task_timeslice - the total duration a task can run during one major
+ * rotation.
+ */
+static inline unsigned int task_timeslice(struct task_struct *p)
+{
+	unsigned int slice, rr;
+
+	slice = rr = p->quota;
+	if (likely(!rt_task(p)))
+		slice += (PRIO_RANGE - 1 - TASK_USER_PRIO(p)) * rr;
+	return slice;
+}
+
+/*
  * Assume: static_prio_timeslice(NICE_TO_PRIO(0)) == DEF_TIMESLICE
  * If static_prio_timeslice() is ever changed to break this assumption then
  * this code will need modification
@@ -793,10 +849,9 @@ static inline int __normal_prio(struct t
 #define TIME_SLICE_NICE_ZERO DEF_TIMESLICE
 #define LOAD_WEIGHT(lp) \
 	(((lp) * SCHED_LOAD_SCALE) / TIME_SLICE_NICE_ZERO)
-#define PRIO_TO_LOAD_WEIGHT(prio) \
-	LOAD_WEIGHT(static_prio_timeslice(prio))
-#define RTPRIO_TO_LOAD_WEIGHT(rp) \
-	(PRIO_TO_LOAD_WEIGHT(MAX_RT_PRIO) + LOAD_WEIGHT(rp))
+#define TASK_LOAD_WEIGHT(p)	LOAD_WEIGHT(task_timeslice(p))
+#define RTPRIO_TO_LOAD_WEIGHT(rp)	\
+	(LOAD_WEIGHT((RR_INTERVAL + 20 + (rp))))
 
 static void set_load_weight(struct task_struct *p)
 {
@@ -813,7 +868,7 @@ static void set_load_weight(struct task_
 #endif
 			p->load_weight = RTPRIO_TO_LOAD_WEIGHT(p->rt_priority);
 	} else
-		p->load_weight = PRIO_TO_LOAD_WEIGHT(p->static_prio);
+		p->load_weight = TASK_LOAD_WEIGHT(p);
 }
 
 static inline void
@@ -841,28 +896,35 @@ static inline void dec_nr_running(struct
 }
 
 /*
- * Calculate the expected normal priority: i.e. priority
- * without taking RT-inheritance into account. Might be
- * boosted by interactivity modifiers. Changes upon fork,
- * setprio syscalls, and whenever the interactivity
- * estimator recalculates.
+ * __activate_task - move a task to the runqueue.
  */
-static inline int normal_prio(struct task_struct *p)
+static inline void __activate_task(struct task_struct *p, struct rq *rq)
 {
-	int prio;
+	enqueue_task(p, rq);
+	inc_nr_running(p, rq);
+}
+
+/*
+ * __activate_idle_task - move idle task to the _front_ of runqueue.
+ */
+static inline void __activate_idle_task(struct task_struct *p, struct rq *rq)
+{
+	enqueue_task_head(p, rq);
+	inc_nr_running(p, rq);
+}
 
+static inline int normal_prio(struct task_struct *p)
+{
 	if (has_rt_policy(p))
-		prio = MAX_RT_PRIO-1 - p->rt_priority;
-	else
-		prio = __normal_prio(p);
-	return prio;
+		return MAX_RT_PRIO-1 - p->rt_priority;
+	/* Other tasks all have normal_prio set in recalc_task_prio */
+	return p->static_prio;
 }
 
 /*
  * Calculate the current priority, i.e. the priority
  * taken into account by the scheduler. This value might
- * be boosted by RT tasks, or might be boosted by
- * interactivity modifiers. Will be RT if the task got
+ * be boosted by RT tasks as it will be RT if the task got
  * RT-boosted. If not then it returns p->normal_prio.
  */
 static int effective_prio(struct task_struct *p)
@@ -879,111 +941,26 @@ static int effective_prio(struct task_st
 }
 
 /*
- * __activate_task - move a task to the runqueue.
+ * All tasks have quotas based on RR_INTERVAL. From nice 0 to 19 they are
+ * all equal to it and below zero they get progressively larger making their
+ * effective quota significantly larger. rt tasks all get RR_INTERVAL.
  */
-static void __activate_task(struct task_struct *p, struct rq *rq)
+static unsigned int rr_interval(struct task_struct *p)
 {
-	struct prio_array *target = rq->active;
-
-	if (batch_task(p))
-		target = rq->expired;
-	enqueue_task(p, target);
-	inc_nr_running(p, rq);
-}
-
-/*
- * __activate_idle_task - move idle task to the _front_ of runqueue.
- */
-static inline void __activate_idle_task(struct task_struct *p, struct rq *rq)
-{
-	enqueue_task_head(p, rq->active);
-	inc_nr_running(p, rq);
-}
-
-/*
- * Recalculate p->normal_prio and p->prio after having slept,
- * updating the sleep-average too:
- */
-static int recalc_task_prio(struct task_struct *p, unsigned long long now)
-{
-	/* Caller must always ensure 'now >= p->timestamp' */
-	unsigned long sleep_time = now - p->timestamp;
-
-	if (batch_task(p))
-		sleep_time = 0;
-
-	if (likely(sleep_time > 0)) {
-		/*
-		 * This ceiling is set to the lowest priority that would allow
-		 * a task to be reinserted into the active array on timeslice
-		 * completion.
-		 */
-		unsigned long ceiling = INTERACTIVE_SLEEP(p);
+	int nice = TASK_NICE(p);
 
-		if (p->mm && sleep_time > ceiling && p->sleep_avg < ceiling) {
-			/*
-			 * Prevents user tasks from achieving best priority
-			 * with one single large enough sleep.
-			 */
-			p->sleep_avg = ceiling;
-			/*
-			 * Using INTERACTIVE_SLEEP() as a ceiling places a
-			 * nice(0) task 1ms sleep away from promotion, and
-			 * gives it 700ms to round-robin with no chance of
-			 * being demoted.  This is more than generous, so
-			 * mark this sleep as non-interactive to prevent the
-			 * on-runqueue bonus logic from intervening should
-			 * this task not receive cpu immediately.
-			 */
-			p->sleep_type = SLEEP_NONINTERACTIVE;
-		} else {
-			/*
-			 * Tasks waking from uninterruptible sleep are
-			 * limited in their sleep_avg rise as they
-			 * are likely to be waiting on I/O
-			 */
-			if (p->sleep_type == SLEEP_NONINTERACTIVE && p->mm) {
-				if (p->sleep_avg >= ceiling)
-					sleep_time = 0;
-				else if (p->sleep_avg + sleep_time >=
-					 ceiling) {
-						p->sleep_avg = ceiling;
-						sleep_time = 0;
-				}
-			}
-
-			/*
-			 * This code gives a bonus to interactive tasks.
-			 *
-			 * The boost works by updating the 'average sleep time'
-			 * value here, based on ->timestamp. The more time a
-			 * task spends sleeping, the higher the average gets -
-			 * and the higher the priority boost gets as well.
-			 */
-			p->sleep_avg += sleep_time;
-
-		}
-		if (p->sleep_avg > NS_MAX_SLEEP_AVG)
-			p->sleep_avg = NS_MAX_SLEEP_AVG;
-	}
-
-	return effective_prio(p);
+	if (nice < 0 && !rt_task(p))
+		return RR_INTERVAL * (20 - nice) / 20;
+	return RR_INTERVAL;
 }
 
 /*
  * activate_task - move a task to the runqueue and do priority recalculation
- *
- * Update all the scheduling statistics stuff. (sleep average
- * calculation, priority modifiers, etc.)
  */
 static void activate_task(struct task_struct *p, struct rq *rq, int local)
 {
-	unsigned long long now;
-
-	if (rt_task(p))
-		goto out;
+	unsigned long long now = sched_clock();
 
-	now = sched_clock();
 #ifdef CONFIG_SMP
 	if (!local) {
 		/* Compensate for drifting sched_clock */
@@ -1004,32 +981,9 @@ static void activate_task(struct task_st
 				     (now - p->timestamp) >> 20);
 	}
 
-	p->prio = recalc_task_prio(p, now);
-
-	/*
-	 * This checks to make sure it's not an uninterruptible task
-	 * that is now waking up.
-	 */
-	if (p->sleep_type == SLEEP_NORMAL) {
-		/*
-		 * Tasks which were woken up by interrupts (ie. hw events)
-		 * are most likely of interactive nature. So we give them
-		 * the credit of extending their sleep time to the period
-		 * of time they spend on the runqueue, waiting for execution
-		 * on a CPU, first time around:
-		 */
-		if (in_interrupt())
-			p->sleep_type = SLEEP_INTERRUPTED;
-		else {
-			/*
-			 * Normal first-time wakeups get a credit too for
-			 * on-runqueue time, but it will be weighted down:
-			 */
-			p->sleep_type = SLEEP_INTERACTIVE;
-		}
-	}
+	p->quota = rr_interval(p);
+	p->prio = effective_prio(p);
 	p->timestamp = now;
-out:
 	__activate_task(p, rq);
 }
 
@@ -1039,8 +993,7 @@ out:
 static void deactivate_task(struct task_struct *p, struct rq *rq)
 {
 	dec_nr_running(p, rq);
-	dequeue_task(p, p->array);
-	p->array = NULL;
+	dequeue_task(p, rq);
 }
 
 /*
@@ -1133,7 +1086,7 @@ migrate_task(struct task_struct *p, int 
 	 * If the task is not on a runqueue (and not running), then
 	 * it is sufficient to simply update the task's cpu field.
 	 */
-	if (!p->array && !task_running(rq, p)) {
+	if (!task_queued(p) && !task_running(rq, p)) {
 		set_task_cpu(p, dest_cpu);
 		return 0;
 	}
@@ -1164,7 +1117,7 @@ void wait_task_inactive(struct task_stru
 repeat:
 	rq = task_rq_lock(p, &flags);
 	/* Must be off runqueue entirely, not preempted. */
-	if (unlikely(p->array || task_running(rq, p))) {
+	if (unlikely(task_queued(p) || task_running(rq, p))) {
 		/* If it's preempted, we yield.  It could be a while. */
 		preempted = !task_running(rq, p);
 		task_rq_unlock(rq, &flags);
@@ -1439,6 +1392,31 @@ static inline int wake_idle(int cpu, str
 }
 #endif
 
+/*
+ * We need to have a special definition for an idle runqueue when testing
+ * for preemption on CONFIG_HOTPLUG_CPU as the idle task may be scheduled as
+ * a realtime task in sched_idle_next.
+ */
+#ifdef CONFIG_HOTPLUG_CPU
+#define rq_idle(rq)	((rq)->curr == (rq)->idle && !rt_task((rq)->curr))
+#else
+#define rq_idle(rq)	((rq)->curr == (rq)->idle)
+#endif
+
+static inline int task_preempts_curr(struct task_struct *p, struct rq *rq)
+{
+	struct task_struct *curr = rq->curr;
+
+	return ((p->array == task_rq(p)->active &&
+		TASK_PREEMPTS_CURR(p, curr)) || rq_idle(rq));
+}
+
+static inline void try_preempt(struct task_struct *p, struct rq *rq)
+{
+	if (task_preempts_curr(p, rq))
+		resched_task(rq->curr);
+}
+
 /***
  * try_to_wake_up - wake up a thread
  * @p: the to-be-woken-up thread
@@ -1470,7 +1448,7 @@ static int try_to_wake_up(struct task_st
 	if (!(old_state & state))
 		goto out;
 
-	if (p->array)
+	if (task_queued(p))
 		goto out_running;
 
 	cpu = task_cpu(p);
@@ -1563,7 +1541,7 @@ out_set_cpu:
 		old_state = p->state;
 		if (!(old_state & state))
 			goto out;
-		if (p->array)
+		if (task_queued(p))
 			goto out_running;
 
 		this_cpu = smp_processor_id();
@@ -1572,26 +1550,10 @@ out_set_cpu:
 
 out_activate:
 #endif /* CONFIG_SMP */
-	if (old_state == TASK_UNINTERRUPTIBLE) {
+	if (old_state == TASK_UNINTERRUPTIBLE)
 		rq->nr_uninterruptible--;
-		/*
-		 * Tasks on involuntary sleep don't earn
-		 * sleep_avg beyond just interactive state.
-		 */
-		p->sleep_type = SLEEP_NONINTERACTIVE;
-	} else
 
 	/*
-	 * Tasks that have marked their sleep as noninteractive get
-	 * woken up with their sleep average not weighted in an
-	 * interactive way.
-	 */
-		if (old_state & TASK_NONINTERACTIVE)
-			p->sleep_type = SLEEP_NONINTERACTIVE;
-
-
-	activate_task(p, rq, cpu == this_cpu);
-	/*
 	 * Sync wakeups (i.e. those types of wakeups where the waker
 	 * has indicated that it will leave the CPU in short order)
 	 * don't trigger a preemption, if the woken up task will run on
@@ -1599,10 +1561,9 @@ out_activate:
 	 * the waker guarantees that the freshly woken up task is going
 	 * to be considered on this CPU.)
 	 */
-	if (!sync || cpu != this_cpu) {
-		if (TASK_PREEMPTS_CURR(p, rq))
-			resched_task(rq->curr);
-	}
+	activate_task(p, rq, cpu == this_cpu);
+	if (!sync || cpu != this_cpu)
+		try_preempt(p, rq);
 	success = 1;
 
 out_running:
@@ -1653,7 +1614,6 @@ void fastcall sched_fork(struct task_str
 	p->prio = current->normal_prio;
 
 	INIT_LIST_HEAD(&p->run_list);
-	p->array = NULL;
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
 	if (unlikely(sched_info_on()))
 		memset(&p->sched_info, 0, sizeof(p->sched_info));
@@ -1665,6 +1625,8 @@ void fastcall sched_fork(struct task_str
 	/* Want to start with kernel preemption disabled. */
 	task_thread_info(p)->preempt_count = 1;
 #endif
+	if (unlikely(p->policy == SCHED_FIFO))
+		goto out;
 	/*
 	 * Share the timeslice between parent and child, thus the
 	 * total amount of pending timeslices in the system doesn't change,
@@ -1679,16 +1641,17 @@ void fastcall sched_fork(struct task_str
 	p->first_time_slice = 1;
 	current->time_slice >>= 1;
 	p->timestamp = sched_clock();
-	if (unlikely(!current->time_slice)) {
+	if (!current->time_slice) {
 		/*
-		 * This case is rare, it happens when the parent has only
-		 * a single jiffy left from its timeslice. Taking the
-		 * runqueue lock is not a problem.
+		 * This case happens when the parent has only a single jiffy
+		 * left from its timeslice. Taking the runqueue lock is not
+		 * a problem.
 		 */
 		current->time_slice = 1;
 		task_running_tick(cpu_rq(cpu), current);
 	}
 	local_irq_enable();
+out:
 	put_cpu();
 }
 
@@ -1710,38 +1673,16 @@ void fastcall wake_up_new_task(struct ta
 	this_cpu = smp_processor_id();
 	cpu = task_cpu(p);
 
-	/*
-	 * We decrease the sleep average of forking parents
-	 * and children as well, to keep max-interactive tasks
-	 * from forking tasks that are max-interactive. The parent
-	 * (current) is done further down, under its lock.
-	 */
-	p->sleep_avg = JIFFIES_TO_NS(CURRENT_BONUS(p) *
-		CHILD_PENALTY / 100 * MAX_SLEEP_AVG / MAX_BONUS);
-
-	p->prio = effective_prio(p);
-
 	if (likely(cpu == this_cpu)) {
+		activate_task(p, rq, 1);
 		if (!(clone_flags & CLONE_VM)) {
 			/*
 			 * The VM isn't cloned, so we're in a good position to
 			 * do child-runs-first in anticipation of an exec. This
 			 * usually avoids a lot of COW overhead.
 			 */
-			if (unlikely(!current->array))
-				__activate_task(p, rq);
-			else {
-				p->prio = current->prio;
-				p->normal_prio = current->normal_prio;
-				list_add_tail(&p->run_list, &current->run_list);
-				p->array = current->array;
-				p->array->nr_active++;
-				inc_nr_running(p, rq);
-			}
 			set_need_resched();
-		} else
-			/* Run child last */
-			__activate_task(p, rq);
+		}
 		/*
 		 * We skip the following code due to cpu == this_cpu
 	 	 *
@@ -1758,19 +1699,16 @@ void fastcall wake_up_new_task(struct ta
 		 */
 		p->timestamp = (p->timestamp - this_rq->most_recent_timestamp)
 					+ rq->most_recent_timestamp;
-		__activate_task(p, rq);
-		if (TASK_PREEMPTS_CURR(p, rq))
-			resched_task(rq->curr);
+		activate_task(p, rq, 0);
+		try_preempt(p, rq);
 
 		/*
 		 * Parent and child are on different CPUs, now get the
-		 * parent runqueue to update the parent's ->sleep_avg:
+		 * parent runqueue to update the parent's ->flags:
 		 */
 		task_rq_unlock(rq, &flags);
 		this_rq = task_rq_lock(current, &flags);
 	}
-	current->sleep_avg = JIFFIES_TO_NS(CURRENT_BONUS(current) *
-		PARENT_PENALTY / 100 * MAX_SLEEP_AVG / MAX_BONUS);
 	task_rq_unlock(this_rq, &flags);
 }
 
@@ -1788,20 +1726,12 @@ void fastcall sched_exit(struct task_str
 	unsigned long flags;
 	struct rq *rq;
 
-	/*
-	 * If the child was a (relative-) CPU hog then decrease
-	 * the sleep_avg of the parent as well.
-	 */
 	rq = task_rq_lock(p->parent, &flags);
 	if (p->first_time_slice && task_cpu(p) == task_cpu(p->parent)) {
 		p->parent->time_slice += p->time_slice;
-		if (unlikely(p->parent->time_slice > task_timeslice(p)))
-			p->parent->time_slice = task_timeslice(p);
+		if (unlikely(p->parent->time_slice > p->quota))
+			p->parent->time_slice = p->quota;
 	}
-	if (p->sleep_avg < p->parent->sleep_avg)
-		p->parent->sleep_avg = p->parent->sleep_avg /
-		(EXIT_WEIGHT + 1) * EXIT_WEIGHT + p->sleep_avg /
-		(EXIT_WEIGHT + 1);
 	task_rq_unlock(rq, &flags);
 }
 
@@ -2135,21 +2065,23 @@ void sched_exec(void)
  */
 static void pull_task(struct rq *src_rq, struct prio_array *src_array,
 		      struct task_struct *p, struct rq *this_rq,
-		      struct prio_array *this_array, int this_cpu)
+		      int this_cpu)
 {
-	dequeue_task(p, src_array);
+	dequeue_task(p, src_rq);
 	dec_nr_running(p, src_rq);
 	set_task_cpu(p, this_cpu);
 	inc_nr_running(p, this_rq);
-	enqueue_task(p, this_array);
-	p->timestamp = (p->timestamp - src_rq->most_recent_timestamp)
-				+ this_rq->most_recent_timestamp;
+
 	/*
-	 * Note that idle threads have a prio of MAX_PRIO, for this test
-	 * to be always true for them.
+	 * If this task has already been running on src_rq this priority
+	 * cycle, make the new runqueue think it has been on its cycle
 	 */
-	if (TASK_PREEMPTS_CURR(p, this_rq))
-		resched_task(this_rq->curr);
+	if (p->rotation == src_rq->prio_rotation)
+		p->rotation = this_rq->prio_rotation;
+	enqueue_task(p, this_rq);
+	p->timestamp = (p->timestamp - src_rq->most_recent_timestamp)
+				+ this_rq->most_recent_timestamp;
+	try_preempt(p, this_rq);
 }
 
 /*
@@ -2192,8 +2124,6 @@ int can_migrate_task(struct task_struct 
 	return 1;
 }
 
-#define rq_best_prio(rq) min((rq)->curr->prio, (rq)->best_expired_prio)
-
 /*
  * move_tasks tries to move up to max_nr_move tasks and max_load_move weighted
  * load from busiest to this_rq, as part of a balancing operation within
@@ -2206,9 +2136,9 @@ static int move_tasks(struct rq *this_rq
 		      struct sched_domain *sd, enum idle_type idle,
 		      int *all_pinned)
 {
-	int idx, pulled = 0, pinned = 0, this_best_prio, best_prio,
+	int idx, test_idx, pulled = 0, pinned = 0, this_best_prio, best_prio,
 	    best_prio_seen, skip_for_load;
-	struct prio_array *array, *dst_array;
+	struct prio_array *array;
 	struct list_head *head, *curr;
 	struct task_struct *tmp;
 	long rem_load_move;
@@ -2218,8 +2148,8 @@ static int move_tasks(struct rq *this_rq
 
 	rem_load_move = max_load_move;
 	pinned = 1;
-	this_best_prio = rq_best_prio(this_rq);
-	best_prio = rq_best_prio(busiest);
+	this_best_prio = this_rq->curr->prio;
+	best_prio = busiest->curr->prio;
 	/*
 	 * Enable handling of the case where there is more than one task
 	 * with the best priority.   If the current running task is one
@@ -2233,32 +2163,35 @@ static int move_tasks(struct rq *this_rq
 	 * We first consider expired tasks. Those will likely not be
 	 * executed in the near future, and they are most likely to
 	 * be cache-cold, thus switching CPUs has the least effect
-	 * on them.
+	 * on them. This is done by starting the search at priority
+	 * MAX_PRIO since expired bits are MAX_PRIO...MAX_DYN_PRIO-1
 	 */
-	if (busiest->expired->nr_active) {
-		array = busiest->expired;
-		dst_array = this_rq->expired;
-	} else {
-		array = busiest->active;
-		dst_array = this_rq->active;
-	}
-
-new_array:
-	/* Start searching at priority 0: */
-	idx = 0;
+	array = busiest->expired;
+	test_idx = MAX_PRIO;
 skip_bitmap:
-	if (!idx)
-		idx = sched_find_first_bit(array->bitmap);
+	if (!test_idx)
+		idx = sched_find_first_bit(busiest->dyn_bitmap);
 	else
-		idx = find_next_bit(array->bitmap, MAX_PRIO, idx);
-	if (idx >= MAX_PRIO) {
-		if (array == busiest->expired && busiest->active->nr_active) {
+		idx = find_next_bit(busiest->dyn_bitmap, MAX_DYN_PRIO,
+		      test_idx);
+	if (idx >= MAX_DYN_PRIO) {
+		if (array == busiest->expired) {
 			array = busiest->active;
-			dst_array = this_rq->active;
-			goto new_array;
+			test_idx = 0;
+			goto skip_bitmap;
 		}
 		goto out;
 	}
+	test_idx = idx;
+	if (idx >= MAX_PRIO) {
+		if (array == busiest->active)
+			goto out;
+		idx -= PRIO_RANGE;
+	}
+	if (list_empty(array->queue + idx)) {
+		__clear_bit(test_idx, busiest->dyn_bitmap);
+		goto skip_bitmap;
+	}
 
 	head = array->queue + idx;
 	curr = head->prev;
@@ -2281,11 +2214,11 @@ skip_queue:
 		best_prio_seen |= idx == best_prio;
 		if (curr != head)
 			goto skip_queue;
-		idx++;
+		test_idx++;
 		goto skip_bitmap;
 	}
 
-	pull_task(busiest, array, tmp, this_rq, dst_array, this_cpu);
+	pull_task(busiest, array, tmp, this_rq, this_cpu);
 	pulled++;
 	rem_load_move -= tmp->load_weight;
 
@@ -2298,7 +2231,7 @@ skip_queue:
 			this_best_prio = idx;
 		if (curr != head)
 			goto skip_queue;
-		idx++;
+		test_idx++;
 		goto skip_bitmap;
 	}
 out:
@@ -3267,27 +3200,6 @@ unsigned long long current_sched_time(co
 }
 
 /*
- * We place interactive tasks back into the active array, if possible.
- *
- * To guarantee that this does not starve expired tasks we ignore the
- * interactivity of a task if the first expired task had to wait more
- * than a 'reasonable' amount of time. This deadline timeout is
- * load-dependent, as the frequency of array switched decreases with
- * increasing number of running tasks. We also ignore the interactivity
- * if a better static_prio task has expired:
- */
-static inline int expired_starving(struct rq *rq)
-{
-	if (rq->curr->static_prio > rq->best_expired_prio)
-		return 1;
-	if (!STARVATION_LIMIT || !rq->expired_timestamp)
-		return 0;
-	if (jiffies - rq->expired_timestamp > STARVATION_LIMIT * rq->nr_running)
-		return 1;
-	return 0;
-}
-
-/*
  * Account user cpu time to a process.
  * @p: the process that the cpu time gets accounted to
  * @hardirq_offset: the offset to subtract from hardirq_count()
@@ -3360,87 +3272,147 @@ void account_steal_time(struct task_stru
 		cpustat->steal = cputime64_add(cpustat->steal, tmp);
 }
 
-static void task_running_tick(struct rq *rq, struct task_struct *p)
+/*
+ * The task has used up its quota of running in this prio_level so it must be
+ * dropped a priority level, all managed by recalc_task_prio().
+ */
+static void task_expired_entitlement(struct rq *rq, struct task_struct *p)
 {
-	if (p->array != rq->active) {
-		/* Task has expired but was not scheduled yet */
-		set_tsk_need_resched(p);
+	struct prio_array *old_array;
+	int old_prio;
+
+	set_tsk_need_resched(p);
+	if (unlikely(p->first_time_slice))
+		p->first_time_slice = 0;
+	if (rt_task(p)) {
+		p->time_slice = p->quota;
 		return;
 	}
-	spin_lock(&rq->lock);
+	old_array = p->array;
+	old_prio = p->prio;
+	/* p->prio and p->array will be updated in recalc_task_prio */
+	recalc_task_prio(p, rq);
+	requeue_task(p, rq, old_array, old_prio);
+}
+
+/*
+ * A major priority rotation occurs when all priority quotas for this array
+ * have been exhausted.
+ */
+static inline void major_prio_rotation(struct rq *rq)
+{
+	struct prio_array *new_array = rq->expired;
+
+	rq->expired = rq->active;
+	rq->active = new_array;
+	rq->prio_rotation++;
+	bitmap_zero(rq->dyn_bitmap, MAX_DYN_PRIO);
+	bitmap_copy(rq->dyn_bitmap, rq->static_bitmap, MAX_PRIO);
+	__set_bit(MAX_DYN_PRIO, rq->dyn_bitmap);
+}
+
+/*
+ * This is the heart of the virtual deadline priority management.
+ *
+ * We have used up the quota allocated to this priority level so we rotate
+ * the prio_level of the runqueue to the next lowest priority. We merge any
+ * remaining tasks at this level current_queue with the next priority and
+ * reset this level's queue. MAX_PRIO - 1 is a special case where we perform
+ * a major rotation.
+ */
+static inline void rotate_runqueue_priority(struct rq *rq)
+{
+	int new_prio_level, remaining_quota;
+	struct prio_array *array;
+
 	/*
-	 * The task was running during this tick - update the
-	 * time slice counter. Note: we do not update a thread's
-	 * priority until it either goes to sleep or uses up its
-	 * timeslice. This makes it possible for interactive tasks
-	 * to use up their timeslices at their highest priority levels.
+	 * Make sure we don't have tasks still on the active array that
+	 * haven't run due to not preempting a lower priority task. This can
+	 * happen on list merging or smp balancing.
 	 */
-	if (rt_task(p)) {
+	if (unlikely(sched_find_first_bit(rq->dyn_bitmap) < rq->prio_level))
+		return;
+
+	remaining_quota = rq_quota(rq, rq->prio_level);
+	array = rq->active;
+	if (rq->prio_level > MAX_PRIO - 2) {
+		/* Major rotation required */
+		struct prio_array *new_queue = rq->expired;
+
 		/*
-		 * RR tasks need a special form of timeslice management.
-		 * FIFO tasks have no timeslices.
+		 * The static_bitmap gives us the highest p->static prio task
+		 * that is queued. This value is used as the prio after
+		 * the major rotation and all tasks remaining on this
+		 * active queue are moved there. This means tasks can end
+		 * up a p->prio better than their p->static_prio.
 		 */
-		if ((p->policy == SCHED_RR) && !--p->time_slice) {
-			p->time_slice = task_timeslice(p);
-			p->first_time_slice = 0;
-			set_tsk_need_resched(p);
-
-			/* put it at the end of the queue: */
-			requeue_task(p, rq->active);
+		new_prio_level = find_next_bit(rq->static_bitmap, MAX_PRIO,
+				 MAX_RT_PRIO);
+		if (!list_empty(array->queue + rq->prio_level)) {
+			list_splice_tail_init(array->queue + rq->prio_level,
+					 new_queue->queue + new_prio_level);
 		}
-		goto out_unlock;
+		memset(rq->prio_quota, 0, ARRAY_SIZE(rq->prio_quota));
+		major_prio_rotation(rq);
+	} else {
+		/* Minor rotation */
+		new_prio_level = rq->prio_level + 1;
+		__clear_bit(rq->prio_level, rq->dyn_bitmap);
+		if (!list_empty(array->queue + rq->prio_level)) {
+			list_splice_tail_init(array->queue + rq->prio_level,
+					 array->queue + new_prio_level);
+			__set_bit(new_prio_level, rq->dyn_bitmap);
+		}
+		rq_quota(rq, rq->prio_level) = 0;
 	}
-	if (!--p->time_slice) {
-		dequeue_task(p, rq->active);
-		set_tsk_need_resched(p);
-		p->prio = effective_prio(p);
-		p->time_slice = task_timeslice(p);
-		p->first_time_slice = 0;
+	rq->prio_level = new_prio_level;
+	/*
+	 * While we usually rotate with the rq quota being 0, it is possible
+	 * to be negative so we subtract any deficit from the new level.
+	 */
+	rq_quota(rq, new_prio_level) += remaining_quota;
+}
 
-		if (!rq->expired_timestamp)
-			rq->expired_timestamp = jiffies;
-		if (!TASK_INTERACTIVE(p) || expired_starving(rq)) {
-			enqueue_task(p, rq->expired);
-			if (p->static_prio < rq->best_expired_prio)
-				rq->best_expired_prio = p->static_prio;
-		} else
-			enqueue_task(p, rq->active);
-	} else {
-		/*
-		 * Prevent a too long timeslice allowing a task to monopolize
-		 * the CPU. We do this by splitting up the timeslice into
-		 * smaller pieces.
-		 *
-		 * Note: this does not mean the task's timeslices expire or
-		 * get lost in any way, they just might be preempted by
-		 * another task of equal priority. (one with higher
-		 * priority would have preempted this task already.) We
-		 * requeue this task to the end of the list on this priority
-		 * level, which is in essence a round-robin of tasks with
-		 * equal priority.
-		 *
-		 * This only applies to tasks in the interactive
-		 * delta range with at least TIMESLICE_GRANULARITY to requeue.
-		 */
-		if (TASK_INTERACTIVE(p) && !((task_timeslice(p) -
-			p->time_slice) % TIMESLICE_GRANULARITY(p)) &&
-			(p->time_slice >= TIMESLICE_GRANULARITY(p)) &&
-			(p->array == rq->active)) {
+static void task_running_tick(struct rq *rq, struct task_struct *p)
+{
+	if (unlikely(!task_queued(p))) {
+		/* Task has expired but was not scheduled yet */
+		set_tsk_need_resched(p);
+		return;
+	}
+	/* SCHED_FIFO tasks never run out of timeslice. */
+	if (unlikely(p->policy == SCHED_FIFO))
+		return;
 
-			requeue_task(p, rq->active);
-			set_tsk_need_resched(p);
-		}
+	spin_lock(&rq->lock);
+	/*
+	 * Accounting is performed by both the task and the runqueue. This
+	 * allows frequently sleeping tasks to get their proper quota of
+	 * cpu as the runqueue will have their quota still available at
+	 * the appropriate priority level. It also means frequently waking
+	 * tasks that might miss the scheduler_tick() will get forced down
+	 * priority regardless.
+	 */
+	if (!--p->time_slice)
+		task_expired_entitlement(rq, p);
+	/*
+	 * The rq quota can become negative due to a task being queued in
+	 * scheduler without any quota left at that priority level. It is
+	 * cheaper to allow it to run till this scheduler tick and then
+	 * subtract it from the quota of the merged queues.
+	 */
+	if (!rt_task(p) && --rq_quota(rq, rq->prio_level) <= 0) {
+		if (unlikely(p->first_time_slice))
+			p->first_time_slice = 0;
+		rotate_runqueue_priority(rq);
+		set_tsk_need_resched(p);
 	}
-out_unlock:
 	spin_unlock(&rq->lock);
 }
 
 /*
  * This function gets called by the timer code, with HZ frequency.
  * We call it with interrupts disabled.
- *
- * It also gets called by the fork code, when changing the parent's
- * timeslices.
  */
 void scheduler_tick(void)
 {
@@ -3499,10 +3471,100 @@ EXPORT_SYMBOL(sub_preempt_count);
 
 #endif
 
-static inline int interactive_sleep(enum sleep_type sleep_type)
+/*
+ * Leave this debugging in until we are certain all bitmap manipulations are
+ * working as desired since we can safely get out of this situation.
+ */
+static noinline int rq_bitmap_error(struct rq *rq)
+{
+	static int bitmap_error = 0;
+	struct prio_array *array;
+	struct list_head *queue;
+	int idx, test_idx;
+
+	printk(KERN_ERR
+	       "SCHEDULER BITMAP ERROR %d - attempting to reconstruct...\n",
+	       ++bitmap_error);
+	for (test_idx = MAX_RT_PRIO ; test_idx < MAX_DYN_PRIO ; test_idx++) {
+		if (test_idx < MAX_PRIO) {
+			idx = test_idx;
+			array = rq->active;
+		} else {
+			idx = test_idx - PRIO_RANGE;
+			array = rq->expired;
+		}
+		queue = array->queue + idx;
+		if (!list_empty(queue)) {
+			if (!test_bit(test_idx, rq->dyn_bitmap)) {
+				__set_bit(test_idx, rq->dyn_bitmap);
+			}
+		}
+	}
+	idx = find_next_bit(rq->dyn_bitmap, MAX_DYN_PRIO, MAX_RT_PRIO);
+	/* We hit a real bug. There is no way out of this */
+	BUG_ON(idx == MAX_DYN_PRIO);
+	return idx;
+}
+
+/*
+ * next_dynamic_task finds the next suitable dynamic task. As the dyn_bitmap
+ * contains all the active and expired dynamic tasks sequentially we only
+ * need to do one bitmap lookup.
+ */
+static inline struct task_struct *next_dynamic_task(struct rq *rq, int idx)
 {
-	return (sleep_type == SLEEP_INTERACTIVE ||
-		sleep_type == SLEEP_INTERRUPTED);
+	struct task_struct *next;
+	struct list_head *queue;
+	struct prio_array *array = rq->active;
+
+retry:
+	if (unlikely(idx == MAX_DYN_PRIO))
+		idx = rq_bitmap_error(rq);
+	if (idx >= MAX_PRIO) {
+		/*
+		 * We have selected a bit from the expired range so there are
+		 * no more tasks in the active array.
+		 */
+		major_prio_rotation(rq);
+		array = rq->active;
+		idx -= PRIO_RANGE;
+	}
+	if (unlikely(list_empty(array->queue + idx))) {
+		/*
+		 * This can happen because they are not always cleared on
+		 * dequeue_task since they may have been dequeued while
+		 * waiting on a runqueue and a rotation has occurred in the
+		 * interim. A very rare occurrence.
+		 */
+		__clear_bit(idx, rq->dyn_bitmap);
+		idx = find_next_bit(rq->dyn_bitmap, MAX_DYN_PRIO, idx + 1);
+		goto retry;
+	}
+	queue = array->queue + idx;
+	next = list_entry(queue->next, struct task_struct, run_list);
+	/*
+	 * When the task is chosen it is checked to see if its quota has been
+	 * added to this runqueue level which is only performed once per
+	 * level per major rotation for each running task.
+	 */
+	if (next->rotation != rq->prio_rotation) {
+			/* Task has moved during major rotation */
+			task_new_array(next, rq);
+			set_task_entitlement(next);
+			rq_quota(rq, idx) += next->quota;
+	} else if (!test_bit(USER_PRIO(idx), next->bitmap)) {
+			/* Task has moved during minor rotation */
+			set_task_entitlement(next);
+			rq_quota(rq, idx) += next->quota;
+	}
+	rq->prio_level = idx;
+	/*
+	 * next needs to have its prio and array reset here in case the
+	 * values are wrong due to priority rotation.
+	 */
+	next->prio = idx;
+	next->array = array;
+	return next;
 }
 
 /*
@@ -3511,13 +3573,11 @@ static inline int interactive_sleep(enum
 asmlinkage void __sched schedule(void)
 {
 	struct task_struct *prev, *next;
-	struct prio_array *array;
 	struct list_head *queue;
 	unsigned long long now;
-	unsigned long run_time;
-	int cpu, idx, new_prio;
 	long *switch_count;
 	struct rq *rq;
+	int cpu, idx;
 
 	/*
 	 * Test if we are atomic.  Since do_exit() needs to call into
@@ -3553,18 +3613,6 @@ need_resched_nonpreemptible:
 
 	schedstat_inc(rq, sched_cnt);
 	now = sched_clock();
-	if (likely((long long)(now - prev->timestamp) < NS_MAX_SLEEP_AVG)) {
-		run_time = now - prev->timestamp;
-		if (unlikely((long long)(now - prev->timestamp) < 0))
-			run_time = 0;
-	} else
-		run_time = NS_MAX_SLEEP_AVG;
-
-	/*
-	 * Tasks charged proportionately less run_time at high sleep_avg to
-	 * delay them losing their interactive status
-	 */
-	run_time /= (CURRENT_BONUS(prev) ? : 1);
 
 	spin_lock_irq(&rq->lock);
 
@@ -3586,46 +3634,17 @@ need_resched_nonpreemptible:
 		idle_balance(cpu, rq);
 		if (!rq->nr_running) {
 			next = rq->idle;
-			rq->expired_timestamp = 0;
 			goto switch_tasks;
 		}
 	}
 
-	array = rq->active;
-	if (unlikely(!array->nr_active)) {
-		/*
-		 * Switch the active and expired arrays.
-		 */
-		schedstat_inc(rq, sched_switch);
-		rq->active = rq->expired;
-		rq->expired = array;
-		array = rq->active;
-		rq->expired_timestamp = 0;
-		rq->best_expired_prio = MAX_PRIO;
+	idx = sched_find_first_bit(rq->dyn_bitmap);
+	if (!rt_prio(idx))
+		next = next_dynamic_task(rq, idx);
+	else {
+		queue = rq->active->queue + idx;
+		next = list_entry(queue->next, struct task_struct, run_list);
 	}
-
-	idx = sched_find_first_bit(array->bitmap);
-	queue = array->queue + idx;
-	next = list_entry(queue->next, struct task_struct, run_list);
-
-	if (!rt_task(next) && interactive_sleep(next->sleep_type)) {
-		unsigned long long delta = now - next->timestamp;
-		if (unlikely((long long)(now - next->timestamp) < 0))
-			delta = 0;
-
-		if (next->sleep_type == SLEEP_INTERACTIVE)
-			delta = delta * (ON_RUNQUEUE_WEIGHT * 128 / 100) / 128;
-
-		array = next->array;
-		new_prio = recalc_task_prio(next, next->timestamp + delta);
-
-		if (unlikely(next->prio != new_prio)) {
-			dequeue_task(next, array);
-			next->prio = new_prio;
-			enqueue_task(next, array);
-		}
-	}
-	next->sleep_type = SLEEP_NORMAL;
 switch_tasks:
 	if (next == rq->idle)
 		schedstat_inc(rq, sched_goidle);
@@ -3635,10 +3654,6 @@ switch_tasks:
 	rcu_qsctr_inc(task_cpu(prev));
 
 	update_cpu_clock(prev, rq, now);
-
-	prev->sleep_avg -= run_time;
-	if ((long)prev->sleep_avg <= 0)
-		prev->sleep_avg = 0;
 	prev->timestamp = prev->last_ran = now;
 
 	sched_info_switch(prev, next);
@@ -4074,29 +4089,21 @@ EXPORT_SYMBOL(sleep_on_timeout);
  */
 void rt_mutex_setprio(struct task_struct *p, int prio)
 {
-	struct prio_array *array;
 	unsigned long flags;
+	int queued, oldprio;
 	struct rq *rq;
-	int oldprio;
 
 	BUG_ON(prio < 0 || prio > MAX_PRIO);
 
 	rq = task_rq_lock(p, &flags);
 
 	oldprio = p->prio;
-	array = p->array;
-	if (array)
-		dequeue_task(p, array);
+	if ((queued = task_queued(p)))
+		dequeue_task(p, rq);
 	p->prio = prio;
 
-	if (array) {
-		/*
-		 * If changing to an RT priority then queue it
-		 * in the active array!
-		 */
-		if (rt_task(p))
-			array = rq->active;
-		enqueue_task(p, array);
+	if (queued) {
+		enqueue_task(p, rq);
 		/*
 		 * Reschedule if we are currently running on this runqueue and
 		 * our priority decreased, or if we are not currently running on
@@ -4105,8 +4112,8 @@ void rt_mutex_setprio(struct task_struct
 		if (task_running(rq, p)) {
 			if (p->prio > oldprio)
 				resched_task(rq->curr);
-		} else if (TASK_PREEMPTS_CURR(p, rq))
-			resched_task(rq->curr);
+		} else
+			try_preempt(p, rq);
 	}
 	task_rq_unlock(rq, &flags);
 }
@@ -4115,8 +4122,7 @@ void rt_mutex_setprio(struct task_struct
 
 void set_user_nice(struct task_struct *p, long nice)
 {
-	struct prio_array *array;
-	int old_prio, delta;
+	int queued, old_prio,delta;
 	unsigned long flags;
 	struct rq *rq;
 
@@ -4137,9 +4143,8 @@ void set_user_nice(struct task_struct *p
 		p->static_prio = NICE_TO_PRIO(nice);
 		goto out_unlock;
 	}
-	array = p->array;
-	if (array) {
-		dequeue_task(p, array);
+	if ((queued = task_queued(p))) {
+		dequeue_task(p, rq);
 		dec_raw_weighted_load(rq, p);
 	}
 
@@ -4149,8 +4154,8 @@ void set_user_nice(struct task_struct *p
 	p->prio = effective_prio(p);
 	delta = p->prio - old_prio;
 
-	if (array) {
-		enqueue_task(p, array);
+	if (queued) {
+		enqueue_task(p, rq);
 		inc_raw_weighted_load(rq, p);
 		/*
 		 * If the task increased its priority or is running and
@@ -4226,7 +4231,7 @@ asmlinkage long sys_nice(int increment)
  *
  * This is the priority value as seen by users in /proc.
  * RT tasks are offset by -200. Normal tasks are centered
- * around 0, value goes from -16 to +15.
+ * around 0, value goes from 0 to +19.
  */
 int task_prio(const struct task_struct *p)
 {
@@ -4273,18 +4278,13 @@ static inline struct task_struct *find_p
 /* Actually do priority change: must hold rq lock. */
 static void __setscheduler(struct task_struct *p, int policy, int prio)
 {
-	BUG_ON(p->array);
+	BUG_ON(task_queued(p));
 
 	p->policy = policy;
 	p->rt_priority = prio;
 	p->normal_prio = normal_prio(p);
 	/* we are holding p->pi_lock already */
 	p->prio = rt_mutex_getprio(p);
-	/*
-	 * SCHED_BATCH tasks are treated as perpetual CPU hogs:
-	 */
-	if (policy == SCHED_BATCH)
-		p->sleep_avg = 0;
 	set_load_weight(p);
 }
 
@@ -4299,8 +4299,7 @@ static void __setscheduler(struct task_s
 int sched_setscheduler(struct task_struct *p, int policy,
 		       struct sched_param *param)
 {
-	int retval, oldprio, oldpolicy = -1;
-	struct prio_array *array;
+	int queued, retval, oldprio, oldpolicy = -1;
 	unsigned long flags;
 	struct rq *rq;
 
@@ -4374,12 +4373,11 @@ recheck:
 		spin_unlock_irqrestore(&p->pi_lock, flags);
 		goto recheck;
 	}
-	array = p->array;
-	if (array)
+	if ((queued = task_queued(p)))
 		deactivate_task(p, rq);
 	oldprio = p->prio;
 	__setscheduler(p, policy, param->sched_priority);
-	if (array) {
+	if (queued) {
 		__activate_task(p, rq);
 		/*
 		 * Reschedule if we are currently running on this runqueue and
@@ -4389,8 +4387,8 @@ recheck:
 		if (task_running(rq, p)) {
 			if (p->prio > oldprio)
 				resched_task(rq->curr);
-		} else if (TASK_PREEMPTS_CURR(p, rq))
-			resched_task(rq->curr);
+		} else
+			try_preempt(p, rq);
 	}
 	__task_rq_unlock(rq);
 	spin_unlock_irqrestore(&p->pi_lock, flags);
@@ -4663,40 +4661,19 @@ asmlinkage long sys_sched_getaffinity(pi
  * sys_sched_yield - yield the current processor to other threads.
  *
  * This function yields the current CPU by moving the calling thread
- * to the expired array. If there are no other threads running on this
- * CPU then this function will return.
+ * to the end of its current priority queue. If there are no other
+ * threads running on this cpu this function will return.
  */
 asmlinkage long sys_sched_yield(void)
 {
 	struct rq *rq = this_rq_lock();
-	struct prio_array *array = current->array, *target = rq->expired;
+	struct task_struct *p = current;
 
 	schedstat_inc(rq, yld_cnt);
-	/*
-	 * We implement yielding by moving the task into the expired
-	 * queue.
-	 *
-	 * (special rule: RT tasks will just roundrobin in the active
-	 *  array.)
-	 */
-	if (rt_task(current))
-		target = rq->active;
-
-	if (array->nr_active == 1) {
-		schedstat_inc(rq, yld_act_empty);
-		if (!rq->expired->nr_active)
-			schedstat_inc(rq, yld_both_empty);
-	} else if (!rq->expired->nr_active)
-		schedstat_inc(rq, yld_exp_empty);
-
-	if (array != target) {
-		dequeue_task(current, array);
-		enqueue_task(current, target);
-	} else
-		/*
-		 * requeue_task is cheaper so perform that if possible.
-		 */
-		requeue_task(current, array);
+	if (rq->nr_running == 1)
+		schedstat_inc(rq, yld_both_empty);
+	else
+		list_move_tail(&p->run_list, p->array->queue + p->prio);
 
 	/*
 	 * Since we are going to call schedule() anyway, there's
@@ -5035,10 +5012,10 @@ void __cpuinit init_idle(struct task_str
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long flags;
 
+	bitmap_zero(idle->bitmap, PRIO_RANGE + 1);
 	idle->timestamp = sched_clock();
-	idle->sleep_avg = 0;
 	idle->array = NULL;
-	idle->prio = idle->normal_prio = MAX_PRIO;
+	idle->prio = idle->normal_prio = NICE_TO_PRIO(0);
 	idle->state = TASK_RUNNING;
 	idle->cpus_allowed = cpumask_of_cpu(cpu);
 	set_task_cpu(idle, cpu);
@@ -5157,7 +5134,7 @@ static int __migrate_task(struct task_st
 		goto out;
 
 	set_task_cpu(p, dest_cpu);
-	if (p->array) {
+	if (task_queued(p)) {
 		/*
 		 * Sync timestamp with rq_dest's before activating.
 		 * The same thing could be achieved by doing this step
@@ -5168,8 +5145,7 @@ static int __migrate_task(struct task_st
 				+ rq_dest->most_recent_timestamp;
 		deactivate_task(p, rq_src);
 		__activate_task(p, rq_dest);
-		if (TASK_PREEMPTS_CURR(p, rq_dest))
-			resched_task(rq_dest->curr);
+		try_preempt(p, rq_dest);
 	}
 	ret = 1;
 out:
@@ -5462,7 +5438,7 @@ migration_call(struct notifier_block *nf
 		/* Idle task back to normal (off runqueue, low prio) */
 		rq = task_rq_lock(rq->idle, &flags);
 		deactivate_task(rq->idle, rq);
-		rq->idle->static_prio = MAX_PRIO;
+		rq->idle->static_prio = NICE_TO_PRIO(0);
 		__setscheduler(rq->idle, SCHED_NORMAL, 0);
 		migrate_dead_tasks(cpu);
 		task_rq_unlock(rq, &flags);
@@ -6985,9 +6961,10 @@ void __init sched_init(void)
 		spin_lock_init(&rq->lock);
 		lockdep_set_class(&rq->lock, &rq->rq_lock_key);
 		rq->nr_running = 0;
+		rq->prio_rotation = 0;
+		rq->prio_level = MAX_RT_PRIO;
 		rq->active = rq->arrays;
 		rq->expired = rq->arrays + 1;
-		rq->best_expired_prio = MAX_PRIO;
 
 #ifdef CONFIG_SMP
 		rq->sd = NULL;
@@ -7002,14 +6979,17 @@ void __init sched_init(void)
 		atomic_set(&rq->nr_iowait, 0);
 
 		for (j = 0; j < 2; j++) {
+
 			array = rq->arrays + j;
-			for (k = 0; k < MAX_PRIO; k++) {
+			for (k = 0; k < MAX_PRIO; k++)
 				INIT_LIST_HEAD(array->queue + k);
-				__clear_bit(k, array->bitmap);
-			}
-			// delimiter for bitsearch
-			__set_bit(MAX_PRIO, array->bitmap);
 		}
+		for (k = 0; k < PRIO_RANGE; k++)
+			rq->prio_quota[k] = 0;
+		bitmap_zero(rq->dyn_bitmap, MAX_DYN_PRIO);
+		bitmap_zero(rq->static_bitmap, MAX_PRIO);
+		/* delimiter for bitsearch */
+		__set_bit(MAX_DYN_PRIO, rq->dyn_bitmap);
 		highest_cpu = i;
 	}
 
@@ -7067,10 +7047,10 @@ EXPORT_SYMBOL(__might_sleep);
 #ifdef CONFIG_MAGIC_SYSRQ
 void normalize_rt_tasks(void)
 {
-	struct prio_array *array;
 	struct task_struct *p;
 	unsigned long flags;
 	struct rq *rq;
+	int queued;
 
 	read_lock_irq(&tasklist_lock);
 	for_each_process(p) {
@@ -7080,11 +7060,10 @@ void normalize_rt_tasks(void)
 		spin_lock_irqsave(&p->pi_lock, flags);
 		rq = __task_rq_lock(p);
 
-		array = p->array;
-		if (array)
+		if ((queued = task_queued(p)))
 			deactivate_task(p, task_rq(p));
 		__setscheduler(p, SCHED_NORMAL, 0);
-		if (array) {
+		if (queued) {
 			__activate_task(p, task_rq(p));
 			resched_task(rq->curr);
 		}
_

Patches currently in -mm which might be from kernel@kolivas.org are

sched-fix-idle-load-balancing-in-softirqd-context-fix.patch
lists-add-list-splice-tail.patch
sched-remove-sleepavg-from-proc.patch
sched-remove-noninteractive-flag.patch
sched-implement-180-bit-sched-bitmap.patch
sched-dont-renice-kernel-threads.patch
sched-implement-rsdl-cpu-scheduler.patch
sched-document-rsdl-cpu-scheduler.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
swap-prefetch-avoid-repeating-entry.patch
