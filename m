From: akpm@linux-foundation.org
Subject: - sched-document-sd-cpu-scheduler.patch removed from -mm tree
Date: Mon, 30 Apr 2007 11:48:15 -0700
Message-ID: <200704301848.l3UImFbo011819@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40472 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946615AbXD3StH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 14:49:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kernel@kolivas.org, mingo@elte.hu, nickpiggin@yahoo.com.au, suresh.b.siddha@intel.com, mm-commits@vger.kernel.org


The patch titled
     sched: document sd cpu scheduler
has been removed from the -mm tree.  Its filename was
     sched-document-sd-cpu-scheduler.patch

This patch was dropped because I need to clear the decks

------------------------------------------------------
Subject: sched: document sd cpu scheduler
From: Con Kolivas <kernel@kolivas.org>

Add comprehensive documentation of the Staircase Deadline cpu scheduler design.

Signed-off-by: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sched-design.txt |  240 ++++++++++++++++++++++++++++++-
 1 file changed, 234 insertions(+), 6 deletions(-)

diff -puN Documentation/sched-design.txt~sched-document-sd-cpu-scheduler Documentation/sched-design.txt
--- a/Documentation/sched-design.txt~sched-document-sd-cpu-scheduler
+++ a/Documentation/sched-design.txt
@@ -1,11 +1,14 @@
-		   Goals, Design and Implementation of the
-		      new ultra-scalable O(1) scheduler
+ Goals, Design and Implementation of the ultra-scalable O(1) scheduler by
+ Ingo Molnar and theStaircase Deadline cpu scheduler policy designed by
+ Con Kolivas.
 
 
-  This is an edited version of an email Ingo Molnar sent to
-  lkml on 4 Jan 2002.  It describes the goals, design, and
-  implementation of Ingo's new ultra-scalable O(1) scheduler.
-  Last Updated: 18 April 2002.
+  This was originally an edited version of an email Ingo Molnar sent to
+  lkml on 4 Jan 2002.  It describes the goals, design, and implementation
+  of Ingo's ultra-scalable O(1) scheduler. It now contains a description
+  of the Staircase Deadline priority scheduler that was built on this
+  design.
+  Last Updated: Tue Mar 27 2007
 
 
 Goal
@@ -163,3 +166,228 @@ certain code paths and data constructs. 
 code is smaller than the old one.
 
 	Ingo
+
+
+Staircase Deadline cpu scheduler policy
+================================================
+
+Design summary
+==============
+
+A novel design which incorporates a foreground-background descending priority
+system (the staircase) via a bandwidth allocation matrix according to nice
+level.
+
+
+Features
+========
+
+A starvation free, strict fairness O(1) scalable design with interactivity
+as good as the above restrictions can provide. There is no interactivity
+estimator, no sleep/run measurements and only simple fixed accounting.
+The design has strict enough a design and accounting that task behaviour
+can be modelled and maximum scheduling latencies can be predicted by
+the virtual deadline mechanism that manages runqueues. The prime concern
+in this design is to maintain fairness at all costs determined by nice level,
+yet to maintain as good interactivity as can be allowed within the
+constraints of strict fairness.
+
+
+Design description
+==================
+
+SD works off the principle of providing each task a quota of runtime that it is
+allowed to run at a number of priority levels determined by its static priority
+(ie. its nice level). If the task uses up its quota it has its priority
+decremented to the next level determined by a priority matrix. Once every
+runtime quota has been consumed of every priority level, a task is queued on the
+"expired" array. When no other tasks exist with quota, the expired array is
+activated and fresh quotas are handed out. This is all done in O(1).
+
+Design details
+==============
+
+Each task keeps a record of its own entitlement of cpu time. Most of the rest of
+these details apply to non-realtime tasks as rt task management is straight
+forward.
+
+Each runqueue keeps a record of what major epoch it is up to in the
+rq->prio_rotation field which is incremented on each major epoch. It also
+keeps a record of the current prio_level for each static priority task.
+
+Each task keeps a record of what major runqueue epoch it was last running
+on in p->rotation. It also keeps a record of what priority levels it has
+already been allocated quota from during this epoch in a bitmap p->bitmap.
+
+The only tunable that determines all other details is the RR_INTERVAL. This
+is set to 8ms, and is scaled gently upwards with more cpus. This value is
+tunable via a /proc interface.
+
+All tasks are initially given a quota based on RR_INTERVAL. This is equal to
+RR_INTERVAL between nice values of -6 and 0, half that size above nice 0, and
+progressively larger for nice values from -1 to -20. This is assigned to
+p->quota and only changes with changes in nice level.
+
+As a task is first queued, it checks in recalc_task_prio to see if it has run at
+this runqueue's current priority rotation. If it has not, it will have its
+p->prio level set according to the first slot in a "priority matrix" and will be
+given a p->time_slice equal to the p->quota, and has its allocation bitmap bit
+set in p->bitmap for this prio level. It is then queued on the current active
+priority array.
+
+If a task has already been running during this major epoch, and it has
+p->time_slice left and the rq->prio_quota for the task's p->prio still
+has quota, it will be placed back on the active array, but no more quota
+will be added.
+
+If a task has been running during this major epoch, but does not have
+p->time_slice left, it will find the next lowest priority in its bitmap that it
+has not been allocated quota from. It then gets the a full quota in
+p->time_slice. It is then queued on the current active priority array at the
+newly determined lower priority.
+
+If a task has been running during this major epoch, and does not have
+any entitlement left in p->bitmap and no time_slice left, it will have its
+bitmap cleared, and be queued at its best prio again, but on the expired
+priority array.
+
+When a task is queued, it has its relevant bit set in the array->prio_bitmap.
+
+p->time_slice is stored in nanosconds and is updated via update_cpu_clock on
+schedule() and scheduler_tick. If p->time_slice is below zero then the
+recalc_task_prio is readjusted and the task rescheduled.
+
+
+Priority Matrix
+===============
+
+In order to minimise the latencies between tasks of different nice levels
+running concurrently, the dynamic priority slots where different nice levels
+are queued are dithered instead of being sequential. What this means is that
+there are 40 priority slots where a task may run during one major rotation,
+and the allocation of slots is dependant on nice level. In the
+following table, a zero represents a slot where the task may run.
+
+nice -20 0000000000000000000000000000000000000000
+nice -10 1001000100100010001001000100010010001000
+nice   0 0101010101010101010101010101010101010101
+nice   5 1101011010110101101011010110101101011011
+nice  10 0110111011011101110110111011101101110111
+nice  15 0111110111111011111101111101111110111111
+nice  19 1111111111111111111011111111111111111111
+
+As can be seen, a nice -20 task runs in every priority slot whereas a nice 19
+task only runs one slot per major rotation. This dithered table allows for the
+smallest possible maximum latencies between tasks of varying nice levels, thus
+allowing vastly different nice levels to be used.
+
+SCHED_BATCH tasks are managed slightly differently, receiving only the top
+slots from its priority bitmap giving it equal cpu as SCHED_NORMAL, but
+slightly higher latencies.
+
+
+Modelling deadline behaviour
+============================
+
+As the accounting in this design is hard and not modified by sleep average
+calculations or interactivity modifiers, it is possible to accurately
+predict the maximum latency that a task may experience under different
+conditions. This is a virtual deadline mechanism enforced by mandatory
+timeslice expiration and not outside bandwidth measurement.
+
+The maximum duration a task can run during one major epoch is determined by its
+nice value. Nice 0 tasks can run at 19 different priority levels for RR_INTERVAL
+duration during each epoch. Nice 10 tasks can run at 9 priority levels for each
+epoch, and so on. The table in the priority matrix above demonstrates how this
+is enforced.
+
+Therefore the maximum duration a runqueue epoch can take is determined by
+the number of tasks running, and their nice level. After that, the maximum
+duration it can take before a task can wait before it get scheduled is
+determined by the position of its first slot on the matrix.
+
+In the following examples, these are _worst case scenarios_ and would rarely
+occur, but can be modelled nonetheless to determine the maximum possible
+latency.
+
+So for example, if two nice 0 tasks are running, and one has just expired as
+another is activated for the first time receiving a full quota for this
+runqueue rotation, the first task will wait:
+
+nr_tasks * max_duration + nice_difference * rr_interval
+1 * 19 * RR_INTERVAL + 0 = 152ms
+
+In the presence of a nice 10 task, a nice 0 task would wait a maximum of
+1 * 10 * RR_INTERVAL + 0 = 80ms
+
+In the presence of a nice 0 task, a nice 10 task would wait a maximum of
+1 * 19 * RR_INTERVAL + 1 * RR_INTERVAL = 160ms
+
+More useful than these values, though, are the average latencies which are
+a matter of determining the average distance between priority slots of
+different nice values and multiplying them by the tasks' quota. For example
+in the presence of a nice -10 task, a nice 0 task will wait either one or
+two slots. Given that nice -10 tasks have a quota 2.5 times the RR_INTERVAL,
+this means the latencies will alternate between 2.5 and 5 RR_INTERVALs or
+20 and 40ms respectively (on uniprocessor at 1000HZ).
+
+
+Achieving interactivity
+=======================
+
+A requirement of this scheduler design was to achieve good interactivity
+despite being a completely fair deadline based design. The disadvantage of
+designs that try to achieve interactivity is that they usually do so at
+the expense of maintaining fairness. As cpu speeds increase, the requirement
+for some sort of metered unfairness towards interactive tasks becomes a less
+desirable phenomenon, but low latency and fairness remains mandatory to
+good interactive performance.
+
+This design relies on the fact that interactive tasks, by their nature,
+sleep often. Most fair scheduling designs end up penalising such tasks
+indirectly giving them less than their fair possible share because of the
+sleep, and have to use a mechanism of bonusing their priority to offset
+this based on the duration they sleep. This becomes increasingly inaccurate
+as the number of running tasks rises and more tasks spend time waiting on
+runqueues rather than sleeping, and it is impossible to tell whether the
+task that's waiting on a runqueue only intends to run for a short period and
+then sleep again after than runqueue wait. Furthermore, all such designs rely
+on a period of time to pass to accumulate some form of statistic on the task
+before deciding on how much to give them preference. The shorter this period,
+the more rapidly bursts of cpu ruin the interactive tasks behaviour. The
+longer this period, the longer it takes for interactive tasks to get low
+scheduling latencies and fair cpu.
+
+This design does not measure sleep time at all. Interactive tasks that sleep
+often will wake up having consumed very little if any of their quota for
+the current major priority rotation. The longer they have slept, the less
+likely they are to even be on the current major priority rotation. Once
+woken up, though, they get to use up a their full quota for that epoch,
+whether part of a quota remains or a full quota. Overall, however, they
+can still only run as much cpu time for that epoch as any other task of the
+same nice level. This means that two tasks behaving completely differently
+from fully cpu bound to waking/sleeping extremely frequently will still
+get the same quota of cpu, but the latter will be using its quota for that
+epoch in bursts rather than continuously. This guarantees that interactive
+tasks get the same amount of cpu as cpu bound ones.
+
+The other requirement of interactive tasks is also to obtain low latencies
+for when they are scheduled. Unlike fully cpu bound tasks and the maximum
+latencies possible described in the modelling deadline behaviour section
+above, tasks that sleep will wake up with quota available usually at the
+current runqueue's priority_level or better. This means that the most latency
+they are likely to see is one RR_INTERVAL, and often they will preempt the
+current task if it is not of a sleeping nature. This then guarantees very
+low latency for interactive tasks, and the lowest latencies for the least
+cpu bound tasks.
+
+One of the potential disadvantages of a strict fairness design is that users
+may prefer a degree of unfairness towards certain tasks (such as a gui) and
+will notice the relative slowdown that occurs under load. As the dithered
+matrix minimises the latencies when differential nice levels are used, this
+can be countered by running a gui at a negative nice value such as -10 without
+causing adversely large latencies in nice 0 tasks.
+
+
+Tue Mar 27 2007
+Con Kolivas <kernel@kolivas.org>
_

Patches currently in -mm which might be from kernel@kolivas.org are

sched-fix-idle-load-balancing-in-softirqd-context-fix.patch
sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch
sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array-update.patch
sched-document-sd-cpu-scheduler.patch
sched-implement-staircase-deadline-scheduler-rework-priomatrix-doc.patch
sched-consolidate-sched_clock-drift-adjustments.patch
sched-consolidate-sched_clock-drift-adjustments-fix.patch
sched-implement-staircase-deadline-scheduler-docupdate.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
swap-prefetch-avoid-repeating-entry.patch
