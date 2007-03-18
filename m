From: akpm@linux-foundation.org
Subject: + sched-document-rsdl-cpu-scheduler.patch added to -mm tree
Date: Sat, 17 Mar 2007 23:58:56 -0800
Message-ID: <200703180758.l2I7wu4T018521@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58924 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170AbXCRH7G (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 18 Mar 2007 03:59:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kernel@kolivas.org, mingo@elte.hu, nickpiggin@yahoo.com.au, suresh.b.siddha@intel.com


The patch titled
     sched: document rsdl cpu scheduler
has been added to the -mm tree.  Its filename is
     sched-document-rsdl-cpu-scheduler.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sched: document rsdl cpu scheduler
From: Con Kolivas <kernel@kolivas.org>

Add comprehensive documentation of the RSDL cpu scheduler design.

Signed-off-by: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sched-design.txt |  284 ++++++++++++++++++++++++++++++-
 1 file changed, 278 insertions(+), 6 deletions(-)

diff -puN Documentation/sched-design.txt~sched-document-rsdl-cpu-scheduler Documentation/sched-design.txt
--- a/Documentation/sched-design.txt~sched-document-rsdl-cpu-scheduler
+++ a/Documentation/sched-design.txt
@@ -1,11 +1,14 @@
-		   Goals, Design and Implementation of the
-		      new ultra-scalable O(1) scheduler
+ Goals, Design and Implementation of the ultra-scalable O(1) scheduler by
+ Ingo Molnar and the Rotating Staircase Deadline cpu scheduler policy
+ designed by Con Kolivas.
 
 
-  This is an edited version of an email Ingo Molnar sent to
-  lkml on 4 Jan 2002.  It describes the goals, design, and
-  implementation of Ingo's new ultra-scalable O(1) scheduler.
-  Last Updated: 18 April 2002.
+  This was originally an edited version of an email Ingo Molnar sent to
+  lkml on 4 Jan 2002.  It describes the goals, design, and implementation
+  of Ingo's ultra-scalable O(1) scheduler. It now contains a description
+  of the Rotating Staircase Deadline priority scheduler that was built on
+  this design.
+  Last Updated: Sun Feb 25 2007
 
 
 Goal
@@ -163,3 +166,272 @@ certain code paths and data constructs. 
 code is smaller than the old one.
 
 	Ingo
+
+
+Rotating Staircase Deadline cpu scheduler policy
+================================================
+
+Design summary
+==============
+
+A novel design which incorporates a foreground-background descending priority
+system (the staircase) with runqueue managed minor and major epochs (rotation
+and deadline).
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
+RSDL works off the principle of providing each task a quota of runtime that it
+is allowed to run at a number of priority levels determined by its static
+priority (ie. its nice level). When each task is queued, the cpu that it is
+queued onto also keeps a record of that quota. If the task uses up its quota it
+has its priority decremented to the next level. Also, if the cpu notices a quota
+full has been used for that priority level, it pushes everything remaining at
+that priority level to the next lowest priority level. Once every runtime quota
+has been consumed of every priority level, a task is queued on the "expired"
+array. When no other tasks exist with quota, the expired array is activated and
+fresh quotas are handed out. This is all done in O(1).
+
+
+Design details
+==============
+
+Each cpu has its own runqueue which micromanages its own epochs, and each
+task keeps a record of its own entitlement of cpu time. Most of the rest
+of these details apply to non-realtime tasks as rt task management is
+straight forward.
+
+Each runqueue keeps a record of what major epoch it is up to in the
+rq->prio_rotation field which is incremented on each major epoch. It also
+keeps a record of quota available to each priority value valid for that
+major epoch in rq->prio_quota[].
+
+Each task keeps a record of what major runqueue epoch it was last running
+on in p->rotation. It also keeps a record of what priority levels it has
+already been allocated quota from during this epoch in a bitmap p->bitmap.
+
+The only tunable that determines all other details is the RR_INTERVAL. This
+is set to 8ms (minimum on 1000HZ, higher at different HZ values), and is
+scaled gently upwards with more cpus.
+
+All tasks are initially given a quota based on RR_INTERVAL. This is equal to
+RR_INTERVAL between nice values of 0 and 19, and progressively larger for nice
+values from -1 to -20. This is to maintain a relationship of nice 19 having
+approximately 1/20th of the cpu of nice 0, and nice 0 having 1/20th the cpu of
+nice -20. This is assigned to p->quota and only changes with changes in nice
+level.
+
+As a task is first queued, it checks in recalc_task_prio to see if it has run at
+this runqueue's current priority rotation. If it has not, it will have its
+p->prio level set according to the first slot in a "priority matrix" and will be
+given a p->time_slice equal to the p->quota, and has its allocation bitmap bit
+set in p->bitmap for this prio level. This quota is then also added to the
+current runqueue's rq->prio_quota[p->prio]. It is then queued on the current
+active priority array.
+
+If a task has already been running during this major epoch, and it has
+p->time_slice left and the rq->prio_quota for the task's p->prio still
+has quota, it will be placed back on the active array, but no more quota
+will be added to either the task or the runqueue quota.
+
+If a task has been running during this major epoch, but does not have
+p->time_slice left or the runqueue's prio_quota for this task's p->prio
+does not have quota, it will find the next lowest priority in its bitmap
+that it has not been allocated quota from. It then gets the a full quota
+in p->time_slice and adds that to the quota value for the relevant priority
+rq->prio_quota. It is then queued on the current active priority array at
+the newly determined lower priority.
+
+If a task has been running during this major epoch, and does not have
+any entitlement left in p->bitmap and no time_slice left, it will have its
+bitmap cleared, and be queued at its p->static_prio again, but on the expired
+priority array. No quota will be allocated until this task is scheduled.
+
+When a task is queued, it has its relevant bit set in the array->prio_bitmap.
+
+During a scheduler_tick where a task is running, the p->time_slice is
+decremented, and if it reaches zero then the recalc_task_prio is readjusted
+and the task rescheduled.
+
+During a task running tick, the runqueue prio_quota is also decremented. If
+it empties then a priority rotation occurs (a major or minor epoch). If the
+current runqueue's priority level is better than that of nice 19 tasks, a
+minor rotation is performed, otherwise a major rotation will occur.
+
+A minor rotation takes the remaining tasks at this priority level queue and
+merges them with a list_splice_tail with the queue from the next lowest
+priority level. At this time, any tasks that have been merged will now
+have invalid values in p->prio so this must be considered when dequeueing
+and scheduling the task.
+
+A major rotation takes the remaining tasks at this priority level queue and
+merges them with a list_splice_tail with the best priority task running on
+the expired array, and swaps the priority arrays. The priority quotas are
+reset at this time. Any tasks that have been merged will now have invalid
+values in p->array and possibly p->prio so this must be considered. The
+rq->prio_rotation is incremented at this time.
+
+When a task is dequeued, the dyn_bitmap bit is unset only after testing
+that the relevant queue is actually empty since p->prio may be inaccurate
+and no hard accounting of the number of tasks at that level is possible.
+
+When selecting a new task for scheduling, after the first dynamic bit is found
+on the dyn_bitmap, it is checked to see that a task is really queued at that
+priority or if it is a false positive due to the task being dequeued at a time
+when its p->prio does not match which queue it is on after some form of priority
+rotation. This is a rare occurrence as it tends to only occur if a task that is
+already waiting on a runqueue gets dequeued. If no tasks remain on the active
+array, a major priority rotation is performed. If the chosen task has not been
+running during this major or minor rotation it has new quota allocated at this
+time, and added to the runqueue's quota.
+
+If a task finds itself merged at a priority level that it does not normally
+receive quota at (due to list merging) it will remove one of its normal
+priority slots to compensate.
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
+
+Modelling deadline behaviour
+============================
+
+As the accounting in this design is hard and not modified by sleep average
+calculations or interactivity modifiers, it is possible to accurately
+predict the maximum latency that a task may experience under different
+conditions. This is a virtual deadline mechanism enforced by mandatory
+runqueue epochs, and not by trying to keep complicated accounting of each
+task.
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
+Fri, 16 Mar 2007
+Con Kolivas <kernel@kolivas.org>
_

Patches currently in -mm which might be from kernel@kolivas.org are

sched-fix-idle-load-balancing-in-softirqd-context-fix.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
swap-prefetch-avoid-repeating-entry.patch
lists-add-list-splice-tail.patch
sched-remove-sleepavg-from-proc.patch
sched-remove-noninteractive-flag.patch
sched-dont-renice-kernel-threads.patch
sched-implement-rsdl-cpu-scheduler.patch
sched-document-rsdl-cpu-scheduler.patch
