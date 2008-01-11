From: akpm@linux-foundation.org
Subject: + documentation-create-new-scheduler-subdirectory.patch added to -mm tree
Date: Fri, 11 Jan 2008 15:39:31 -0800
Message-ID: <200801112339.m0BNdWwd003779@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57508 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754313AbYAKXk0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jan 2008 18:40:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bfields@citi.umich.edu, mingo@elte.hu, randy.dunlap@oracle.com


The patch titled
     Documentation: create new scheduler/ subdirectory
has been added to the -mm tree.  Its filename is
     documentation-create-new-scheduler-subdirectory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation: create new scheduler/ subdirectory
From: "J. Bruce Fields" <bfields@citi.umich.edu>

The top-level Documentation/ directory is unmanageably large, so we
should take any obvious opportunities to move stuff into subdirectories.
These sched-*.txt files seem an obvious easy case.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Cc: Ingo Molnar <mingo@elte.hu>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/00-INDEX                        |   16 -
 Documentation/ABI/testing/sysfs-kernel-uids   |    2 
 Documentation/sched-arch.txt                  |   89 -------
 Documentation/sched-coding.txt                |  126 ----------
 Documentation/sched-design-CFS.txt            |  186 ----------------
 Documentation/sched-design.txt                |  165 --------------
 Documentation/sched-domains.txt               |   70 ------
 Documentation/sched-nice-design.txt           |  108 ---------
 Documentation/sched-stats.txt                 |  156 -------------
 Documentation/scheduler/00-INDEX              |   16 +
 Documentation/scheduler/sched-arch.txt        |   89 +++++++
 Documentation/scheduler/sched-coding.txt      |  126 ++++++++++
 Documentation/scheduler/sched-design-CFS.txt  |  186 ++++++++++++++++
 Documentation/scheduler/sched-design.txt      |  165 ++++++++++++++
 Documentation/scheduler/sched-domains.txt     |   70 ++++++
 Documentation/scheduler/sched-nice-design.txt |  108 +++++++++
 Documentation/scheduler/sched-stats.txt       |  156 +++++++++++++
 17 files changed, 919 insertions(+), 915 deletions(-)

diff -puN Documentation/00-INDEX~documentation-create-new-scheduler-subdirectory Documentation/00-INDEX
--- a/Documentation/00-INDEX~documentation-create-new-scheduler-subdirectory
+++ a/Documentation/00-INDEX
@@ -335,20 +335,8 @@ rtc.txt
 	- notes on how to use the Real Time Clock (aka CMOS clock) driver.
 s390/
 	- directory with info on using Linux on the IBM S390.
-sched-arch.txt
-	- CPU Scheduler implementation hints for architecture specific code.
-sched-coding.txt
-	- reference for various scheduler-related methods in the O(1) scheduler.
-sched-design.txt
-	- goals, design and implementation of the Linux O(1) scheduler.
-sched-design-CFS.txt
-	- goals, design and implementation of the Complete Fair Scheduler.
-sched-domains.txt
-	- information on scheduling domains.
-sched-nice-design.txt
-	- How and why the scheduler's nice levels are implemented.
-sched-stats.txt
-	- information on schedstats (Linux Scheduler Statistics).
+scheduler/
+	- directory with info on the scheduler.
 scsi/
 	- directory with info on Linux scsi support.
 serial/
diff -puN Documentation/ABI/testing/sysfs-kernel-uids~documentation-create-new-scheduler-subdirectory Documentation/ABI/testing/sysfs-kernel-uids
--- a/Documentation/ABI/testing/sysfs-kernel-uids~documentation-create-new-scheduler-subdirectory
+++ a/Documentation/ABI/testing/sysfs-kernel-uids
@@ -11,4 +11,4 @@ Description:
 		example would be, if User A has shares = 1024 and user
 		B has shares = 2048, User B will get twice the CPU
 		bandwidth user A will. For more details refer
-		Documentation/sched-design-CFS.txt
+		Documentation/scheduler/sched-design-CFS.txt
diff -puN Documentation/sched-arch.txt~documentation-create-new-scheduler-subdirectory /dev/null
--- a/Documentation/sched-arch.txt
+++ /dev/null
@@ -1,89 +0,0 @@
-	CPU Scheduler implementation hints for architecture specific code
-
-	Nick Piggin, 2005
-
-Context switch
-==============
-1. Runqueue locking
-By default, the switch_to arch function is called with the runqueue
-locked. This is usually not a problem unless switch_to may need to
-take the runqueue lock. This is usually due to a wake up operation in
-the context switch. See include/asm-ia64/system.h for an example.
-
-To request the scheduler call switch_to with the runqueue unlocked,
-you must `#define __ARCH_WANT_UNLOCKED_CTXSW` in a header file
-(typically the one where switch_to is defined).
-
-Unlocked context switches introduce only a very minor performance
-penalty to the core scheduler implementation in the CONFIG_SMP case.
-
-2. Interrupt status
-By default, the switch_to arch function is called with interrupts
-disabled. Interrupts may be enabled over the call if it is likely to
-introduce a significant interrupt latency by adding the line
-`#define __ARCH_WANT_INTERRUPTS_ON_CTXSW` in the same place as for
-unlocked context switches. This define also implies
-`__ARCH_WANT_UNLOCKED_CTXSW`. See include/asm-arm/system.h for an
-example.
-
-
-CPU idle
-========
-Your cpu_idle routines need to obey the following rules:
-
-1. Preempt should now disabled over idle routines. Should only
-   be enabled to call schedule() then disabled again.
-
-2. need_resched/TIF_NEED_RESCHED is only ever set, and will never
-   be cleared until the running task has called schedule(). Idle
-   threads need only ever query need_resched, and may never set or
-   clear it.
-
-3. When cpu_idle finds (need_resched() == 'true'), it should call
-   schedule(). It should not call schedule() otherwise.
-
-4. The only time interrupts need to be disabled when checking
-   need_resched is if we are about to sleep the processor until
-   the next interrupt (this doesn't provide any protection of
-   need_resched, it prevents losing an interrupt).
-
-	4a. Common problem with this type of sleep appears to be:
-	        local_irq_disable();
-	        if (!need_resched()) {
-	                local_irq_enable();
-	                *** resched interrupt arrives here ***
-	                __asm__("sleep until next interrupt");
-	        }
-
-5. TIF_POLLING_NRFLAG can be set by idle routines that do not
-   need an interrupt to wake them up when need_resched goes high.
-   In other words, they must be periodically polling need_resched,
-   although it may be reasonable to do some background work or enter
-   a low CPU priority.
-
-   	5a. If TIF_POLLING_NRFLAG is set, and we do decide to enter
-	    an interrupt sleep, it needs to be cleared then a memory
-	    barrier issued (followed by a test of need_resched with
-	    interrupts disabled, as explained in 3).
-
-arch/i386/kernel/process.c has examples of both polling and
-sleeping idle functions.
-
-
-Possible arch/ problems
-=======================
-
-Possible arch problems I found (and either tried to fix or didn't):
-
-h8300 - Is such sleeping racy vs interrupts? (See #4a).
-        The H8/300 manual I found indicates yes, however disabling IRQs
-        over the sleep mean only NMIs can wake it up, so can't fix easily
-        without doing spin waiting.
-
-ia64 - is safe_halt call racy vs interrupts? (does it sleep?) (See #4a)
-
-sh64 - Is sleeping racy vs interrupts? (See #4a)
-
-sparc - IRQs on at this point(?), change local_irq_save to _disable.
-      - TODO: needs secondary CPUs to disable preempt (See #1)
-
diff -puN Documentation/sched-coding.txt~documentation-create-new-scheduler-subdirectory /dev/null
--- a/Documentation/sched-coding.txt
+++ /dev/null
@@ -1,126 +0,0 @@
-     Reference for various scheduler-related methods in the O(1) scheduler
-		Robert Love <rml@tech9.net>, MontaVista Software
-
-
-Note most of these methods are local to kernel/sched.c - this is by design.
-The scheduler is meant to be self-contained and abstracted away.  This document
-is primarily for understanding the scheduler, not interfacing to it.  Some of
-the discussed interfaces, however, are general process/scheduling methods.
-They are typically defined in include/linux/sched.h.
-
-
-Main Scheduling Methods
------------------------
-
-void load_balance(runqueue_t *this_rq, int idle)
-	Attempts to pull tasks from one cpu to another to balance cpu usage,
-	if needed.  This method is called explicitly if the runqueues are
-	imbalanced or periodically by the timer tick.  Prior to calling,
-	the current runqueue must be locked and interrupts disabled.
-
-void schedule()
-	The main scheduling function.  Upon return, the highest priority
-	process will be active.
-
-
-Locking
--------
-
-Each runqueue has its own lock, rq->lock.  When multiple runqueues need
-to be locked, lock acquires must be ordered by ascending &runqueue value.
-
-A specific runqueue is locked via
-
-	task_rq_lock(task_t pid, unsigned long *flags)
-
-which disables preemption, disables interrupts, and locks the runqueue pid is
-running on.  Likewise,
-
-	task_rq_unlock(task_t pid, unsigned long *flags)
-
-unlocks the runqueue pid is running on, restores interrupts to their previous
-state, and reenables preemption.
-
-The routines
-
-	double_rq_lock(runqueue_t *rq1, runqueue_t *rq2)
-
-and
-
-	double_rq_unlock(runqueue_t *rq1, runqueue_t *rq2)
-
-safely lock and unlock, respectively, the two specified runqueues.  They do
-not, however, disable and restore interrupts.  Users are required to do so
-manually before and after calls.
-
-
-Values
-------
-
-MAX_PRIO
-	The maximum priority of the system, stored in the task as task->prio.
-	Lower priorities are higher.  Normal (non-RT) priorities range from
-	MAX_RT_PRIO to (MAX_PRIO - 1).
-MAX_RT_PRIO
-	The maximum real-time priority of the system.  Valid RT priorities
-	range from 0 to (MAX_RT_PRIO - 1).
-MAX_USER_RT_PRIO
-	The maximum real-time priority that is exported to user-space.  Should
-	always be equal to or less than MAX_RT_PRIO.  Setting it less allows
-	kernel threads to have higher priorities than any user-space task.
-MIN_TIMESLICE
-MAX_TIMESLICE
-	Respectively, the minimum and maximum timeslices (quanta) of a process.
-
-Data
-----
-
-struct runqueue
-	The main per-CPU runqueue data structure.
-struct task_struct
-	The main per-process data structure.
-
-
-General Methods
----------------
-
-cpu_rq(cpu)
-	Returns the runqueue of the specified cpu.
-this_rq()
-	Returns the runqueue of the current cpu.
-task_rq(pid)
-	Returns the runqueue which holds the specified pid.
-cpu_curr(cpu)
-	Returns the task currently running on the given cpu.
-rt_task(pid)
-	Returns true if pid is real-time, false if not.
-
-
-Process Control Methods
------------------------
-
-void set_user_nice(task_t *p, long nice)
-	Sets the "nice" value of task p to the given value.
-int setscheduler(pid_t pid, int policy, struct sched_param *param)
-	Sets the scheduling policy and parameters for the given pid.
-int set_cpus_allowed(task_t *p, unsigned long new_mask)
-	Sets a given task's CPU affinity and migrates it to a proper cpu.
-	Callers must have a valid reference to the task and assure the
-	task not exit prematurely.  No locks can be held during the call.
-set_task_state(tsk, state_value)
-	Sets the given task's state to the given value.
-set_current_state(state_value)
-	Sets the current task's state to the given value.
-void set_tsk_need_resched(struct task_struct *tsk)
-	Sets need_resched in the given task.
-void clear_tsk_need_resched(struct task_struct *tsk)
-	Clears need_resched in the given task.
-void set_need_resched()
-	Sets need_resched in the current task.
-void clear_need_resched()
-	Clears need_resched in the current task.
-int need_resched()
-	Returns true if need_resched is set in the current task, false
-	otherwise.
-yield()
-	Place the current process at the end of the runqueue and call schedule.
diff -puN Documentation/sched-design-CFS.txt~documentation-create-new-scheduler-subdirectory /dev/null
--- a/Documentation/sched-design-CFS.txt
+++ /dev/null
@@ -1,186 +0,0 @@
-
-This is the CFS scheduler.
-
-80% of CFS's design can be summed up in a single sentence: CFS basically
-models an "ideal, precise multi-tasking CPU" on real hardware.
-
-"Ideal multi-tasking CPU" is a (non-existent  :-))  CPU that has 100%
-physical power and which can run each task at precise equal speed, in
-parallel, each at 1/nr_running speed. For example: if there are 2 tasks
-running then it runs each at 50% physical power - totally in parallel.
-
-On real hardware, we can run only a single task at once, so while that
-one task runs, the other tasks that are waiting for the CPU are at a
-disadvantage - the current task gets an unfair amount of CPU time. In
-CFS this fairness imbalance is expressed and tracked via the per-task
-p->wait_runtime (nanosec-unit) value. "wait_runtime" is the amount of
-time the task should now run on the CPU for it to become completely fair
-and balanced.
-
-( small detail: on 'ideal' hardware, the p->wait_runtime value would
-  always be zero - no task would ever get 'out of balance' from the
-  'ideal' share of CPU time. )
-
-CFS's task picking logic is based on this p->wait_runtime value and it
-is thus very simple: it always tries to run the task with the largest
-p->wait_runtime value. In other words, CFS tries to run the task with
-the 'gravest need' for more CPU time. So CFS always tries to split up
-CPU time between runnable tasks as close to 'ideal multitasking
-hardware' as possible.
-
-Most of the rest of CFS's design just falls out of this really simple
-concept, with a few add-on embellishments like nice levels,
-multiprocessing and various algorithm variants to recognize sleepers.
-
-In practice it works like this: the system runs a task a bit, and when
-the task schedules (or a scheduler tick happens) the task's CPU usage is
-'accounted for': the (small) time it just spent using the physical CPU
-is deducted from p->wait_runtime. [minus the 'fair share' it would have
-gotten anyway]. Once p->wait_runtime gets low enough so that another
-task becomes the 'leftmost task' of the time-ordered rbtree it maintains
-(plus a small amount of 'granularity' distance relative to the leftmost
-task so that we do not over-schedule tasks and trash the cache) then the
-new leftmost task is picked and the current task is preempted.
-
-The rq->fair_clock value tracks the 'CPU time a runnable task would have
-fairly gotten, had it been runnable during that time'. So by using
-rq->fair_clock values we can accurately timestamp and measure the
-'expected CPU time' a task should have gotten. All runnable tasks are
-sorted in the rbtree by the "rq->fair_clock - p->wait_runtime" key, and
-CFS picks the 'leftmost' task and sticks to it. As the system progresses
-forwards, newly woken tasks are put into the tree more and more to the
-right - slowly but surely giving a chance for every task to become the
-'leftmost task' and thus get on the CPU within a deterministic amount of
-time.
-
-Some implementation details:
-
- - the introduction of Scheduling Classes: an extensible hierarchy of
-   scheduler modules. These modules encapsulate scheduling policy
-   details and are handled by the scheduler core without the core
-   code assuming about them too much.
-
- - sched_fair.c implements the 'CFS desktop scheduler': it is a
-   replacement for the vanilla scheduler's SCHED_OTHER interactivity
-   code.
-
-   I'd like to give credit to Con Kolivas for the general approach here:
-   he has proven via RSDL/SD that 'fair scheduling' is possible and that
-   it results in better desktop scheduling. Kudos Con!
-
-   The CFS patch uses a completely different approach and implementation
-   from RSDL/SD. My goal was to make CFS's interactivity quality exceed
-   that of RSDL/SD, which is a high standard to meet :-) Testing
-   feedback is welcome to decide this one way or another. [ and, in any
-   case, all of SD's logic could be added via a kernel/sched_sd.c module
-   as well, if Con is interested in such an approach. ]
-
-   CFS's design is quite radical: it does not use runqueues, it uses a
-   time-ordered rbtree to build a 'timeline' of future task execution,
-   and thus has no 'array switch' artifacts (by which both the vanilla
-   scheduler and RSDL/SD are affected).
-
-   CFS uses nanosecond granularity accounting and does not rely on any
-   jiffies or other HZ detail. Thus the CFS scheduler has no notion of
-   'timeslices' and has no heuristics whatsoever. There is only one
-   central tunable (you have to switch on CONFIG_SCHED_DEBUG):
-
-         /proc/sys/kernel/sched_granularity_ns
-
-   which can be used to tune the scheduler from 'desktop' (low
-   latencies) to 'server' (good batching) workloads. It defaults to a
-   setting suitable for desktop workloads. SCHED_BATCH is handled by the
-   CFS scheduler module too.
-
-   Due to its design, the CFS scheduler is not prone to any of the
-   'attacks' that exist today against the heuristics of the stock
-   scheduler: fiftyp.c, thud.c, chew.c, ring-test.c, massive_intr.c all
-   work fine and do not impact interactivity and produce the expected
-   behavior.
-
-   the CFS scheduler has a much stronger handling of nice levels and
-   SCHED_BATCH: both types of workloads should be isolated much more
-   agressively than under the vanilla scheduler.
-
-   ( another detail: due to nanosec accounting and timeline sorting,
-     sched_yield() support is very simple under CFS, and in fact under
-     CFS sched_yield() behaves much better than under any other
-     scheduler i have tested so far. )
-
- - sched_rt.c implements SCHED_FIFO and SCHED_RR semantics, in a simpler
-   way than the vanilla scheduler does. It uses 100 runqueues (for all
-   100 RT priority levels, instead of 140 in the vanilla scheduler)
-   and it needs no expired array.
-
- - reworked/sanitized SMP load-balancing: the runqueue-walking
-   assumptions are gone from the load-balancing code now, and
-   iterators of the scheduling modules are used. The balancing code got
-   quite a bit simpler as a result.
-
-
-Group scheduler extension to CFS
-================================
-
-Normally the scheduler operates on individual tasks and strives to provide
-fair CPU time to each task. Sometimes, it may be desirable to group tasks
-and provide fair CPU time to each such task group. For example, it may
-be desirable to first provide fair CPU time to each user on the system
-and then to each task belonging to a user.
-
-CONFIG_FAIR_GROUP_SCHED strives to achieve exactly that. It lets
-SCHED_NORMAL/BATCH tasks be be grouped and divides CPU time fairly among such
-groups. At present, there are two (mutually exclusive) mechanisms to group
-tasks for CPU bandwidth control purpose:
-
-	- Based on user id (CONFIG_FAIR_USER_SCHED)
-		In this option, tasks are grouped according to their user id.
-	- Based on "cgroup" pseudo filesystem (CONFIG_FAIR_CGROUP_SCHED)
-		This options lets the administrator create arbitrary groups
-		of tasks, using the "cgroup" pseudo filesystem. See
-		Documentation/cgroups.txt for more information about this
-		filesystem.
-
-Only one of these options to group tasks can be chosen and not both.
-
-Group scheduler tunables:
-
-When CONFIG_FAIR_USER_SCHED is defined, a directory is created in sysfs for
-each new user and a "cpu_share" file is added in that directory.
-
-	# cd /sys/kernel/uids
-	# cat 512/cpu_share		# Display user 512's CPU share
-	1024
-	# echo 2048 > 512/cpu_share	# Modify user 512's CPU share
-	# cat 512/cpu_share		# Display user 512's CPU share
-	2048
-	#
-
-CPU bandwidth between two users are divided in the ratio of their CPU shares.
-For ex: if you would like user "root" to get twice the bandwidth of user
-"guest", then set the cpu_share for both the users such that "root"'s
-cpu_share is twice "guest"'s cpu_share
-
-
-When CONFIG_FAIR_CGROUP_SCHED is defined, a "cpu.shares" file is created
-for each group created using the pseudo filesystem. See example steps
-below to create task groups and modify their CPU share using the "cgroups"
-pseudo filesystem
-
-	# mkdir /dev/cpuctl
-	# mount -t cgroup -ocpu none /dev/cpuctl
-	# cd /dev/cpuctl
-
-	# mkdir multimedia	# create "multimedia" group of tasks
-	# mkdir browser		# create "browser" group of tasks
-
-	# #Configure the multimedia group to receive twice the CPU bandwidth
-	# #that of browser group
-
-	# echo 2048 > multimedia/cpu.shares
-	# echo 1024 > browser/cpu.shares
-
-	# firefox &	# Launch firefox and move it to "browser" group
-	# echo <firefox_pid> > browser/tasks
-
-	# #Launch gmplayer (or your favourite movie player)
-	# echo <movie_player_pid> > multimedia/tasks
diff -puN Documentation/sched-design.txt~documentation-create-new-scheduler-subdirectory /dev/null
--- a/Documentation/sched-design.txt
+++ /dev/null
@@ -1,165 +0,0 @@
-		   Goals, Design and Implementation of the
-		      new ultra-scalable O(1) scheduler
-
-
-  This is an edited version of an email Ingo Molnar sent to
-  lkml on 4 Jan 2002.  It describes the goals, design, and
-  implementation of Ingo's new ultra-scalable O(1) scheduler.
-  Last Updated: 18 April 2002.
-
-
-Goal
-====
-
-The main goal of the new scheduler is to keep all the good things we know
-and love about the current Linux scheduler:
-
- - good interactive performance even during high load: if the user
-   types or clicks then the system must react instantly and must execute
-   the user tasks smoothly, even during considerable background load.
-
- - good scheduling/wakeup performance with 1-2 runnable processes.
-
- - fairness: no process should stay without any timeslice for any
-   unreasonable amount of time. No process should get an unjustly high
-   amount of CPU time.
-
- - priorities: less important tasks can be started with lower priority,
-   more important tasks with higher priority.
-
- - SMP efficiency: no CPU should stay idle if there is work to do.
-
- - SMP affinity: processes which run on one CPU should stay affine to
-   that CPU. Processes should not bounce between CPUs too frequently.
-
- - plus additional scheduler features: RT scheduling, CPU binding.
-
-and the goal is also to add a few new things:
-
- - fully O(1) scheduling. Are you tired of the recalculation loop
-   blowing the L1 cache away every now and then? Do you think the goodness
-   loop is taking a bit too long to finish if there are lots of runnable
-   processes? This new scheduler takes no prisoners: wakeup(), schedule(),
-   the timer interrupt are all O(1) algorithms. There is no recalculation
-   loop. There is no goodness loop either.
-
- - 'perfect' SMP scalability. With the new scheduler there is no 'big'
-   runqueue_lock anymore - it's all per-CPU runqueues and locks - two
-   tasks on two separate CPUs can wake up, schedule and context-switch
-   completely in parallel, without any interlocking. All
-   scheduling-relevant data is structured for maximum scalability.
-
- - better SMP affinity. The old scheduler has a particular weakness that
-   causes the random bouncing of tasks between CPUs if/when higher
-   priority/interactive tasks, this was observed and reported by many
-   people. The reason is that the timeslice recalculation loop first needs
-   every currently running task to consume its timeslice. But when this
-   happens on eg. an 8-way system, then this property starves an
-   increasing number of CPUs from executing any process. Once the last
-   task that has a timeslice left has finished using up that timeslice,
-   the recalculation loop is triggered and other CPUs can start executing
-   tasks again - after having idled around for a number of timer ticks.
-   The more CPUs, the worse this effect.
-
-   Furthermore, this same effect causes the bouncing effect as well:
-   whenever there is such a 'timeslice squeeze' of the global runqueue,
-   idle processors start executing tasks which are not affine to that CPU.
-   (because the affine tasks have finished off their timeslices already.)
-
-   The new scheduler solves this problem by distributing timeslices on a
-   per-CPU basis, without having any global synchronization or
-   recalculation.
-
- - batch scheduling. A significant proportion of computing-intensive tasks
-   benefit from batch-scheduling, where timeslices are long and processes
-   are roundrobin scheduled. The new scheduler does such batch-scheduling
-   of the lowest priority tasks - so nice +19 jobs will get
-   'batch-scheduled' automatically. With this scheduler, nice +19 jobs are
-   in essence SCHED_IDLE, from an interactiveness point of view.
-
- - handle extreme loads more smoothly, without breakdown and scheduling
-   storms.
-
- - O(1) RT scheduling. For those RT folks who are paranoid about the
-   O(nr_running) property of the goodness loop and the recalculation loop.
-
- - run fork()ed children before the parent. Andrea has pointed out the
-   advantages of this a few months ago, but patches for this feature
-   do not work with the old scheduler as well as they should,
-   because idle processes often steal the new child before the fork()ing
-   CPU gets to execute it.
-
-
-Design
-======
-
-The core of the new scheduler contains the following mechanisms:
-
- - *two* priority-ordered 'priority arrays' per CPU. There is an 'active'
-   array and an 'expired' array. The active array contains all tasks that
-   are affine to this CPU and have timeslices left. The expired array
-   contains all tasks which have used up their timeslices - but this array
-   is kept sorted as well. The active and expired array is not accessed
-   directly, it's accessed through two pointers in the per-CPU runqueue
-   structure. If all active tasks are used up then we 'switch' the two
-   pointers and from now on the ready-to-go (former-) expired array is the
-   active array - and the empty active array serves as the new collector
-   for expired tasks.
-
- - there is a 64-bit bitmap cache for array indices. Finding the highest
-   priority task is thus a matter of two x86 BSFL bit-search instructions.
-
-the split-array solution enables us to have an arbitrary number of active
-and expired tasks, and the recalculation of timeslices can be done
-immediately when the timeslice expires. Because the arrays are always
-access through the pointers in the runqueue, switching the two arrays can
-be done very quickly.
-
-this is a hybride priority-list approach coupled with roundrobin
-scheduling and the array-switch method of distributing timeslices.
-
- - there is a per-task 'load estimator'.
-
-one of the toughest things to get right is good interactive feel during
-heavy system load. While playing with various scheduler variants i found
-that the best interactive feel is achieved not by 'boosting' interactive
-tasks, but by 'punishing' tasks that want to use more CPU time than there
-is available. This method is also much easier to do in an O(1) fashion.
-
-to establish the actual 'load' the task contributes to the system, a
-complex-looking but pretty accurate method is used: there is a 4-entry
-'history' ringbuffer of the task's activities during the last 4 seconds.
-This ringbuffer is operated without much overhead. The entries tell the
-scheduler a pretty accurate load-history of the task: has it used up more
-CPU time or less during the past N seconds. [the size '4' and the interval
-of 4x 1 seconds was found by lots of experimentation - this part is
-flexible and can be changed in both directions.]
-
-the penalty a task gets for generating more load than the CPU can handle
-is a priority decrease - there is a maximum amount to this penalty
-relative to their static priority, so even fully CPU-bound tasks will
-observe each other's priorities, and will share the CPU accordingly.
-
-the SMP load-balancer can be extended/switched with additional parallel
-computing and cache hierarchy concepts: NUMA scheduling, multi-core CPUs
-can be supported easily by changing the load-balancer. Right now it's
-tuned for my SMP systems.
-
-i skipped the prev->mm == next->mm advantage - no workload i know of shows
-any sensitivity to this. It can be added back by sacrificing O(1)
-schedule() [the current and one-lower priority list can be searched for a
-that->mm == current->mm condition], but costs a fair number of cycles
-during a number of important workloads, so i wanted to avoid this as much
-as possible.
-
-- the SMP idle-task startup code was still racy and the new scheduler
-triggered this. So i streamlined the idle-setup code a bit. We do not call
-into schedule() before all processors have started up fully and all idle
-threads are in place.
-
-- the patch also cleans up a number of aspects of sched.c - moves code
-into other areas of the kernel where it's appropriate, and simplifies
-certain code paths and data constructs. As a result, the new scheduler's
-code is smaller than the old one.
-
-	Ingo
diff -puN Documentation/sched-domains.txt~documentation-create-new-scheduler-subdirectory /dev/null
--- a/Documentation/sched-domains.txt
+++ /dev/null
@@ -1,70 +0,0 @@
-Each CPU has a "base" scheduling domain (struct sched_domain). These are
-accessed via cpu_sched_domain(i) and this_sched_domain() macros. The domain
-hierarchy is built from these base domains via the ->parent pointer. ->parent
-MUST be NULL terminated, and domain structures should be per-CPU as they
-are locklessly updated.
-
-Each scheduling domain spans a number of CPUs (stored in the ->span field).
-A domain's span MUST be a superset of it child's span (this restriction could
-be relaxed if the need arises), and a base domain for CPU i MUST span at least
-i. The top domain for each CPU will generally span all CPUs in the system
-although strictly it doesn't have to, but this could lead to a case where some
-CPUs will never be given tasks to run unless the CPUs allowed mask is
-explicitly set. A sched domain's span means "balance process load among these
-CPUs".
-
-Each scheduling domain must have one or more CPU groups (struct sched_group)
-which are organised as a circular one way linked list from the ->groups
-pointer. The union of cpumasks of these groups MUST be the same as the
-domain's span. The intersection of cpumasks from any two of these groups
-MUST be the empty set. The group pointed to by the ->groups pointer MUST
-contain the CPU to which the domain belongs. Groups may be shared among
-CPUs as they contain read only data after they have been set up.
-
-Balancing within a sched domain occurs between groups. That is, each group
-is treated as one entity. The load of a group is defined as the sum of the
-load of each of its member CPUs, and only when the load of a group becomes
-out of balance are tasks moved between groups.
-
-In kernel/sched.c, rebalance_tick is run periodically on each CPU. This
-function takes its CPU's base sched domain and checks to see if has reached
-its rebalance interval. If so, then it will run load_balance on that domain.
-rebalance_tick then checks the parent sched_domain (if it exists), and the
-parent of the parent and so forth.
-
-*** Implementing sched domains ***
-The "base" domain will "span" the first level of the hierarchy. In the case
-of SMT, you'll span all siblings of the physical CPU, with each group being
-a single virtual CPU.
-
-In SMP, the parent of the base domain will span all physical CPUs in the
-node. Each group being a single physical CPU. Then with NUMA, the parent
-of the SMP domain will span the entire machine, with each group having the
-cpumask of a node. Or, you could do multi-level NUMA or Opteron, for example,
-might have just one domain covering its one NUMA level.
-
-The implementor should read comments in include/linux/sched.h:
-struct sched_domain fields, SD_FLAG_*, SD_*_INIT to get an idea of
-the specifics and what to tune.
-
-For SMT, the architecture must define CONFIG_SCHED_SMT and provide a
-cpumask_t cpu_sibling_map[NR_CPUS], where cpu_sibling_map[i] is the mask of
-all "i"'s siblings as well as "i" itself.
-
-Architectures may retain the regular override the default SD_*_INIT flags
-while using the generic domain builder in kernel/sched.c if they wish to
-retain the traditional SMT->SMP->NUMA topology (or some subset of that). This
-can be done by #define'ing ARCH_HASH_SCHED_TUNE.
-
-Alternatively, the architecture may completely override the generic domain
-builder by #define'ing ARCH_HASH_SCHED_DOMAIN, and exporting your
-arch_init_sched_domains function. This function will attach domains to all
-CPUs using cpu_attach_domain.
-
-Implementors should change the line
-#undef SCHED_DOMAIN_DEBUG
-to
-#define SCHED_DOMAIN_DEBUG
-in kernel/sched.c as this enables an error checking parse of the sched domains
-which should catch most possible errors (described above). It also prints out
-the domain structure in a visual format.
diff -puN Documentation/sched-nice-design.txt~documentation-create-new-scheduler-subdirectory /dev/null
--- a/Documentation/sched-nice-design.txt
+++ /dev/null
@@ -1,108 +0,0 @@
-This document explains the thinking about the revamped and streamlined
-nice-levels implementation in the new Linux scheduler.
-
-Nice levels were always pretty weak under Linux and people continuously
-pestered us to make nice +19 tasks use up much less CPU time.
-
-Unfortunately that was not that easy to implement under the old
-scheduler, (otherwise we'd have done it long ago) because nice level
-support was historically coupled to timeslice length, and timeslice
-units were driven by the HZ tick, so the smallest timeslice was 1/HZ.
-
-In the O(1) scheduler (in 2003) we changed negative nice levels to be
-much stronger than they were before in 2.4 (and people were happy about
-that change), and we also intentionally calibrated the linear timeslice
-rule so that nice +19 level would be _exactly_ 1 jiffy. To better
-understand it, the timeslice graph went like this (cheesy ASCII art
-alert!):
-
-
-                   A
-             \     | [timeslice length]
-              \    |
-               \   |
-                \  |
-                 \ |
-                  \|___100msecs
-                   |^ . _
-                   |      ^ . _
-                   |            ^ . _
- -*----------------------------------*-----> [nice level]
- -20               |                +19
-                   |
-                   |
-
-So that if someone wanted to really renice tasks, +19 would give a much
-bigger hit than the normal linear rule would do. (The solution of
-changing the ABI to extend priorities was discarded early on.)
-
-This approach worked to some degree for some time, but later on with
-HZ=1000 it caused 1 jiffy to be 1 msec, which meant 0.1% CPU usage which
-we felt to be a bit excessive. Excessive _not_ because it's too small of
-a CPU utilization, but because it causes too frequent (once per
-millisec) rescheduling. (and would thus trash the cache, etc. Remember,
-this was long ago when hardware was weaker and caches were smaller, and
-people were running number crunching apps at nice +19.)
-
-So for HZ=1000 we changed nice +19 to 5msecs, because that felt like the
-right minimal granularity - and this translates to 5% CPU utilization.
-But the fundamental HZ-sensitive property for nice+19 still remained,
-and we never got a single complaint about nice +19 being too _weak_ in
-terms of CPU utilization, we only got complaints about it (still) being
-too _strong_ :-)
-
-To sum it up: we always wanted to make nice levels more consistent, but
-within the constraints of HZ and jiffies and their nasty design level
-coupling to timeslices and granularity it was not really viable.
-
-The second (less frequent but still periodically occuring) complaint
-about Linux's nice level support was its assymetry around the origo
-(which you can see demonstrated in the picture above), or more
-accurately: the fact that nice level behavior depended on the _absolute_
-nice level as well, while the nice API itself is fundamentally
-"relative":
-
-   int nice(int inc);
-
-   asmlinkage long sys_nice(int increment)
-
-(the first one is the glibc API, the second one is the syscall API.)
-Note that the 'inc' is relative to the current nice level. Tools like
-bash's "nice" command mirror this relative API.
-
-With the old scheduler, if you for example started a niced task with +1
-and another task with +2, the CPU split between the two tasks would
-depend on the nice level of the parent shell - if it was at nice -10 the
-CPU split was different than if it was at +5 or +10.
-
-A third complaint against Linux's nice level support was that negative
-nice levels were not 'punchy enough', so lots of people had to resort to
-run audio (and other multimedia) apps under RT priorities such as
-SCHED_FIFO. But this caused other problems: SCHED_FIFO is not starvation
-proof, and a buggy SCHED_FIFO app can also lock up the system for good.
-
-The new scheduler in v2.6.23 addresses all three types of complaints:
-
-To address the first complaint (of nice levels being not "punchy"
-enough), the scheduler was decoupled from 'time slice' and HZ concepts
-(and granularity was made a separate concept from nice levels) and thus
-it was possible to implement better and more consistent nice +19
-support: with the new scheduler nice +19 tasks get a HZ-independent
-1.5%, instead of the variable 3%-5%-9% range they got in the old
-scheduler.
-
-To address the second complaint (of nice levels not being consistent),
-the new scheduler makes nice(1) have the same CPU utilization effect on
-tasks, regardless of their absolute nice levels. So on the new
-scheduler, running a nice +10 and a nice 11 task has the same CPU
-utilization "split" between them as running a nice -5 and a nice -4
-task. (one will get 55% of the CPU, the other 45%.) That is why nice
-levels were changed to be "multiplicative" (or exponential) - that way
-it does not matter which nice level you start out from, the 'relative
-result' will always be the same.
-
-The third complaint (of negative nice levels not being "punchy" enough
-and forcing audio apps to run under the more dangerous SCHED_FIFO
-scheduling policy) is addressed by the new scheduler almost
-automatically: stronger negative nice levels are an automatic
-side-effect of the recalibrated dynamic range of nice levels.
diff -puN Documentation/sched-stats.txt~documentation-create-new-scheduler-subdirectory /dev/null
--- a/Documentation/sched-stats.txt
+++ /dev/null
@@ -1,156 +0,0 @@
-Version 14 of schedstats includes support for sched_domains, which hit the
-mainline kernel in 2.6.20 although it is identical to the stats from version
-12 which was in the kernel from 2.6.13-2.6.19 (version 13 never saw a kernel
-release).  Some counters make more sense to be per-runqueue; other to be
-per-domain.  Note that domains (and their associated information) will only
-be pertinent and available on machines utilizing CONFIG_SMP.
-
-In version 14 of schedstat, there is at least one level of domain
-statistics for each cpu listed, and there may well be more than one
-domain.  Domains have no particular names in this implementation, but
-the highest numbered one typically arbitrates balancing across all the
-cpus on the machine, while domain0 is the most tightly focused domain,
-sometimes balancing only between pairs of cpus.  At this time, there
-are no architectures which need more than three domain levels. The first
-field in the domain stats is a bit map indicating which cpus are affected
-by that domain.
-
-These fields are counters, and only increment.  Programs which make use
-of these will need to start with a baseline observation and then calculate
-the change in the counters at each subsequent observation.  A perl script
-which does this for many of the fields is available at
-
-    http://eaglet.rain.com/rick/linux/schedstat/
-
-Note that any such script will necessarily be version-specific, as the main
-reason to change versions is changes in the output format.  For those wishing
-to write their own scripts, the fields are described here.
-
-CPU statistics
---------------
-cpu<N> 1 2 3 4 5 6 7 8 9 10 11 12
-
-NOTE: In the sched_yield() statistics, the active queue is considered empty
-    if it has only one process in it, since obviously the process calling
-    sched_yield() is that process.
-
-First four fields are sched_yield() statistics:
-     1) # of times both the active and the expired queue were empty
-     2) # of times just the active queue was empty
-     3) # of times just the expired queue was empty
-     4) # of times sched_yield() was called
-
-Next three are schedule() statistics:
-     5) # of times we switched to the expired queue and reused it
-     6) # of times schedule() was called
-     7) # of times schedule() left the processor idle
-
-Next two are try_to_wake_up() statistics:
-     8) # of times try_to_wake_up() was called
-     9) # of times try_to_wake_up() was called to wake up the local cpu
-
-Next three are statistics describing scheduling latency:
-    10) sum of all time spent running by tasks on this processor (in jiffies)
-    11) sum of all time spent waiting to run by tasks on this processor (in
-        jiffies)
-    12) # of timeslices run on this cpu
-
-
-Domain statistics
------------------
-One of these is produced per domain for each cpu described. (Note that if
-CONFIG_SMP is not defined, *no* domains are utilized and these lines
-will not appear in the output.)
-
-domain<N> <cpumask> 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36
-
-The first field is a bit mask indicating what cpus this domain operates over.
-
-The next 24 are a variety of load_balance() statistics in grouped into types
-of idleness (idle, busy, and newly idle):
-
-     1) # of times in this domain load_balance() was called when the
-        cpu was idle
-     2) # of times in this domain load_balance() checked but found
-        the load did not require balancing when the cpu was idle
-     3) # of times in this domain load_balance() tried to move one or
-        more tasks and failed, when the cpu was idle
-     4) sum of imbalances discovered (if any) with each call to
-        load_balance() in this domain when the cpu was idle
-     5) # of times in this domain pull_task() was called when the cpu
-        was idle
-     6) # of times in this domain pull_task() was called even though
-        the target task was cache-hot when idle
-     7) # of times in this domain load_balance() was called but did
-        not find a busier queue while the cpu was idle
-     8) # of times in this domain a busier queue was found while the
-        cpu was idle but no busier group was found
-
-     9) # of times in this domain load_balance() was called when the
-        cpu was busy
-    10) # of times in this domain load_balance() checked but found the
-        load did not require balancing when busy
-    11) # of times in this domain load_balance() tried to move one or
-        more tasks and failed, when the cpu was busy
-    12) sum of imbalances discovered (if any) with each call to
-        load_balance() in this domain when the cpu was busy
-    13) # of times in this domain pull_task() was called when busy
-    14) # of times in this domain pull_task() was called even though the
-        target task was cache-hot when busy
-    15) # of times in this domain load_balance() was called but did not
-        find a busier queue while the cpu was busy
-    16) # of times in this domain a busier queue was found while the cpu
-        was busy but no busier group was found
-
-    17) # of times in this domain load_balance() was called when the
-        cpu was just becoming idle
-    18) # of times in this domain load_balance() checked but found the
-        load did not require balancing when the cpu was just becoming idle
-    19) # of times in this domain load_balance() tried to move one or more
-        tasks and failed, when the cpu was just becoming idle
-    20) sum of imbalances discovered (if any) with each call to
-        load_balance() in this domain when the cpu was just becoming idle
-    21) # of times in this domain pull_task() was called when newly idle
-    22) # of times in this domain pull_task() was called even though the
-        target task was cache-hot when just becoming idle
-    23) # of times in this domain load_balance() was called but did not
-        find a busier queue while the cpu was just becoming idle
-    24) # of times in this domain a busier queue was found while the cpu
-        was just becoming idle but no busier group was found
-
-   Next three are active_load_balance() statistics:
-    25) # of times active_load_balance() was called
-    26) # of times active_load_balance() tried to move a task and failed
-    27) # of times active_load_balance() successfully moved a task
-
-   Next three are sched_balance_exec() statistics:
-    28) sbe_cnt is not used
-    29) sbe_balanced is not used
-    30) sbe_pushed is not used
-
-   Next three are sched_balance_fork() statistics:
-    31) sbf_cnt is not used
-    32) sbf_balanced is not used
-    33) sbf_pushed is not used
-
-   Next three are try_to_wake_up() statistics:
-    34) # of times in this domain try_to_wake_up() awoke a task that
-        last ran on a different cpu in this domain
-    35) # of times in this domain try_to_wake_up() moved a task to the
-        waking cpu because it was cache-cold on its own cpu anyway
-    36) # of times in this domain try_to_wake_up() started passive balancing
-
-/proc/<pid>/schedstat
-----------------
-schedstats also adds a new /proc/<pid/schedstat file to include some of
-the same information on a per-process level.  There are three fields in
-this file correlating for that process to:
-     1) time spent on the cpu
-     2) time spent waiting on a runqueue
-     3) # of timeslices run on this cpu
-
-A program could be easily written to make use of these extra fields to
-report on how well a particular process or set of processes is faring
-under the scheduler's policies.  A simple version of such a program is
-available at
-    http://eaglet.rain.com/rick/linux/schedstat/v12/latency.c
diff -puN /dev/null Documentation/scheduler/00-INDEX
--- /dev/null
+++ a/Documentation/scheduler/00-INDEX
@@ -0,0 +1,16 @@
+00-INDEX
+	- this file.
+sched-arch.txt
+	- CPU Scheduler implementation hints for architecture specific code.
+sched-coding.txt
+	- reference for various scheduler-related methods in the O(1) scheduler.
+sched-design.txt
+	- goals, design and implementation of the Linux O(1) scheduler.
+sched-design-CFS.txt
+	- goals, design and implementation of the Complete Fair Scheduler.
+sched-domains.txt
+	- information on scheduling domains.
+sched-nice-design.txt
+	- How and why the scheduler's nice levels are implemented.
+sched-stats.txt
+	- information on schedstats (Linux Scheduler Statistics).
diff -puN /dev/null Documentation/scheduler/sched-arch.txt
--- /dev/null
+++ a/Documentation/scheduler/sched-arch.txt
@@ -0,0 +1,89 @@
+	CPU Scheduler implementation hints for architecture specific code
+
+	Nick Piggin, 2005
+
+Context switch
+==============
+1. Runqueue locking
+By default, the switch_to arch function is called with the runqueue
+locked. This is usually not a problem unless switch_to may need to
+take the runqueue lock. This is usually due to a wake up operation in
+the context switch. See include/asm-ia64/system.h for an example.
+
+To request the scheduler call switch_to with the runqueue unlocked,
+you must `#define __ARCH_WANT_UNLOCKED_CTXSW` in a header file
+(typically the one where switch_to is defined).
+
+Unlocked context switches introduce only a very minor performance
+penalty to the core scheduler implementation in the CONFIG_SMP case.
+
+2. Interrupt status
+By default, the switch_to arch function is called with interrupts
+disabled. Interrupts may be enabled over the call if it is likely to
+introduce a significant interrupt latency by adding the line
+`#define __ARCH_WANT_INTERRUPTS_ON_CTXSW` in the same place as for
+unlocked context switches. This define also implies
+`__ARCH_WANT_UNLOCKED_CTXSW`. See include/asm-arm/system.h for an
+example.
+
+
+CPU idle
+========
+Your cpu_idle routines need to obey the following rules:
+
+1. Preempt should now disabled over idle routines. Should only
+   be enabled to call schedule() then disabled again.
+
+2. need_resched/TIF_NEED_RESCHED is only ever set, and will never
+   be cleared until the running task has called schedule(). Idle
+   threads need only ever query need_resched, and may never set or
+   clear it.
+
+3. When cpu_idle finds (need_resched() == 'true'), it should call
+   schedule(). It should not call schedule() otherwise.
+
+4. The only time interrupts need to be disabled when checking
+   need_resched is if we are about to sleep the processor until
+   the next interrupt (this doesn't provide any protection of
+   need_resched, it prevents losing an interrupt).
+
+	4a. Common problem with this type of sleep appears to be:
+	        local_irq_disable();
+	        if (!need_resched()) {
+	                local_irq_enable();
+	                *** resched interrupt arrives here ***
+	                __asm__("sleep until next interrupt");
+	        }
+
+5. TIF_POLLING_NRFLAG can be set by idle routines that do not
+   need an interrupt to wake them up when need_resched goes high.
+   In other words, they must be periodically polling need_resched,
+   although it may be reasonable to do some background work or enter
+   a low CPU priority.
+
+   	5a. If TIF_POLLING_NRFLAG is set, and we do decide to enter
+	    an interrupt sleep, it needs to be cleared then a memory
+	    barrier issued (followed by a test of need_resched with
+	    interrupts disabled, as explained in 3).
+
+arch/i386/kernel/process.c has examples of both polling and
+sleeping idle functions.
+
+
+Possible arch/ problems
+=======================
+
+Possible arch problems I found (and either tried to fix or didn't):
+
+h8300 - Is such sleeping racy vs interrupts? (See #4a).
+        The H8/300 manual I found indicates yes, however disabling IRQs
+        over the sleep mean only NMIs can wake it up, so can't fix easily
+        without doing spin waiting.
+
+ia64 - is safe_halt call racy vs interrupts? (does it sleep?) (See #4a)
+
+sh64 - Is sleeping racy vs interrupts? (See #4a)
+
+sparc - IRQs on at this point(?), change local_irq_save to _disable.
+      - TODO: needs secondary CPUs to disable preempt (See #1)
+
diff -puN /dev/null Documentation/scheduler/sched-coding.txt
--- /dev/null
+++ a/Documentation/scheduler/sched-coding.txt
@@ -0,0 +1,126 @@
+     Reference for various scheduler-related methods in the O(1) scheduler
+		Robert Love <rml@tech9.net>, MontaVista Software
+
+
+Note most of these methods are local to kernel/sched.c - this is by design.
+The scheduler is meant to be self-contained and abstracted away.  This document
+is primarily for understanding the scheduler, not interfacing to it.  Some of
+the discussed interfaces, however, are general process/scheduling methods.
+They are typically defined in include/linux/sched.h.
+
+
+Main Scheduling Methods
+-----------------------
+
+void load_balance(runqueue_t *this_rq, int idle)
+	Attempts to pull tasks from one cpu to another to balance cpu usage,
+	if needed.  This method is called explicitly if the runqueues are
+	imbalanced or periodically by the timer tick.  Prior to calling,
+	the current runqueue must be locked and interrupts disabled.
+
+void schedule()
+	The main scheduling function.  Upon return, the highest priority
+	process will be active.
+
+
+Locking
+-------
+
+Each runqueue has its own lock, rq->lock.  When multiple runqueues need
+to be locked, lock acquires must be ordered by ascending &runqueue value.
+
+A specific runqueue is locked via
+
+	task_rq_lock(task_t pid, unsigned long *flags)
+
+which disables preemption, disables interrupts, and locks the runqueue pid is
+running on.  Likewise,
+
+	task_rq_unlock(task_t pid, unsigned long *flags)
+
+unlocks the runqueue pid is running on, restores interrupts to their previous
+state, and reenables preemption.
+
+The routines
+
+	double_rq_lock(runqueue_t *rq1, runqueue_t *rq2)
+
+and
+
+	double_rq_unlock(runqueue_t *rq1, runqueue_t *rq2)
+
+safely lock and unlock, respectively, the two specified runqueues.  They do
+not, however, disable and restore interrupts.  Users are required to do so
+manually before and after calls.
+
+
+Values
+------
+
+MAX_PRIO
+	The maximum priority of the system, stored in the task as task->prio.
+	Lower priorities are higher.  Normal (non-RT) priorities range from
+	MAX_RT_PRIO to (MAX_PRIO - 1).
+MAX_RT_PRIO
+	The maximum real-time priority of the system.  Valid RT priorities
+	range from 0 to (MAX_RT_PRIO - 1).
+MAX_USER_RT_PRIO
+	The maximum real-time priority that is exported to user-space.  Should
+	always be equal to or less than MAX_RT_PRIO.  Setting it less allows
+	kernel threads to have higher priorities than any user-space task.
+MIN_TIMESLICE
+MAX_TIMESLICE
+	Respectively, the minimum and maximum timeslices (quanta) of a process.
+
+Data
+----
+
+struct runqueue
+	The main per-CPU runqueue data structure.
+struct task_struct
+	The main per-process data structure.
+
+
+General Methods
+---------------
+
+cpu_rq(cpu)
+	Returns the runqueue of the specified cpu.
+this_rq()
+	Returns the runqueue of the current cpu.
+task_rq(pid)
+	Returns the runqueue which holds the specified pid.
+cpu_curr(cpu)
+	Returns the task currently running on the given cpu.
+rt_task(pid)
+	Returns true if pid is real-time, false if not.
+
+
+Process Control Methods
+-----------------------
+
+void set_user_nice(task_t *p, long nice)
+	Sets the "nice" value of task p to the given value.
+int setscheduler(pid_t pid, int policy, struct sched_param *param)
+	Sets the scheduling policy and parameters for the given pid.
+int set_cpus_allowed(task_t *p, unsigned long new_mask)
+	Sets a given task's CPU affinity and migrates it to a proper cpu.
+	Callers must have a valid reference to the task and assure the
+	task not exit prematurely.  No locks can be held during the call.
+set_task_state(tsk, state_value)
+	Sets the given task's state to the given value.
+set_current_state(state_value)
+	Sets the current task's state to the given value.
+void set_tsk_need_resched(struct task_struct *tsk)
+	Sets need_resched in the given task.
+void clear_tsk_need_resched(struct task_struct *tsk)
+	Clears need_resched in the given task.
+void set_need_resched()
+	Sets need_resched in the current task.
+void clear_need_resched()
+	Clears need_resched in the current task.
+int need_resched()
+	Returns true if need_resched is set in the current task, false
+	otherwise.
+yield()
+	Place the current process at the end of the runqueue and call schedule.
diff -puN /dev/null Documentation/scheduler/sched-design-CFS.txt
--- /dev/null
+++ a/Documentation/scheduler/sched-design-CFS.txt
@@ -0,0 +1,186 @@
+
+This is the CFS scheduler.
+
+80% of CFS's design can be summed up in a single sentence: CFS basically
+models an "ideal, precise multi-tasking CPU" on real hardware.
+
+"Ideal multi-tasking CPU" is a (non-existent  :-))  CPU that has 100%
+physical power and which can run each task at precise equal speed, in
+parallel, each at 1/nr_running speed. For example: if there are 2 tasks
+running then it runs each at 50% physical power - totally in parallel.
+
+On real hardware, we can run only a single task at once, so while that
+one task runs, the other tasks that are waiting for the CPU are at a
+disadvantage - the current task gets an unfair amount of CPU time. In
+CFS this fairness imbalance is expressed and tracked via the per-task
+p->wait_runtime (nanosec-unit) value. "wait_runtime" is the amount of
+time the task should now run on the CPU for it to become completely fair
+and balanced.
+
+( small detail: on 'ideal' hardware, the p->wait_runtime value would
+  always be zero - no task would ever get 'out of balance' from the
+  'ideal' share of CPU time. )
+
+CFS's task picking logic is based on this p->wait_runtime value and it
+is thus very simple: it always tries to run the task with the largest
+p->wait_runtime value. In other words, CFS tries to run the task with
+the 'gravest need' for more CPU time. So CFS always tries to split up
+CPU time between runnable tasks as close to 'ideal multitasking
+hardware' as possible.
+
+Most of the rest of CFS's design just falls out of this really simple
+concept, with a few add-on embellishments like nice levels,
+multiprocessing and various algorithm variants to recognize sleepers.
+
+In practice it works like this: the system runs a task a bit, and when
+the task schedules (or a scheduler tick happens) the task's CPU usage is
+'accounted for': the (small) time it just spent using the physical CPU
+is deducted from p->wait_runtime. [minus the 'fair share' it would have
+gotten anyway]. Once p->wait_runtime gets low enough so that another
+task becomes the 'leftmost task' of the time-ordered rbtree it maintains
+(plus a small amount of 'granularity' distance relative to the leftmost
+task so that we do not over-schedule tasks and trash the cache) then the
+new leftmost task is picked and the current task is preempted.
+
+The rq->fair_clock value tracks the 'CPU time a runnable task would have
+fairly gotten, had it been runnable during that time'. So by using
+rq->fair_clock values we can accurately timestamp and measure the
+'expected CPU time' a task should have gotten. All runnable tasks are
+sorted in the rbtree by the "rq->fair_clock - p->wait_runtime" key, and
+CFS picks the 'leftmost' task and sticks to it. As the system progresses
+forwards, newly woken tasks are put into the tree more and more to the
+right - slowly but surely giving a chance for every task to become the
+'leftmost task' and thus get on the CPU within a deterministic amount of
+time.
+
+Some implementation details:
+
+ - the introduction of Scheduling Classes: an extensible hierarchy of
+   scheduler modules. These modules encapsulate scheduling policy
+   details and are handled by the scheduler core without the core
+   code assuming about them too much.
+
+ - sched_fair.c implements the 'CFS desktop scheduler': it is a
+   replacement for the vanilla scheduler's SCHED_OTHER interactivity
+   code.
+
+   I'd like to give credit to Con Kolivas for the general approach here:
+   he has proven via RSDL/SD that 'fair scheduling' is possible and that
+   it results in better desktop scheduling. Kudos Con!
+
+   The CFS patch uses a completely different approach and implementation
+   from RSDL/SD. My goal was to make CFS's interactivity quality exceed
+   that of RSDL/SD, which is a high standard to meet :-) Testing
+   feedback is welcome to decide this one way or another. [ and, in any
+   case, all of SD's logic could be added via a kernel/sched_sd.c module
+   as well, if Con is interested in such an approach. ]
+
+   CFS's design is quite radical: it does not use runqueues, it uses a
+   time-ordered rbtree to build a 'timeline' of future task execution,
+   and thus has no 'array switch' artifacts (by which both the vanilla
+   scheduler and RSDL/SD are affected).
+
+   CFS uses nanosecond granularity accounting and does not rely on any
+   jiffies or other HZ detail. Thus the CFS scheduler has no notion of
+   'timeslices' and has no heuristics whatsoever. There is only one
+   central tunable (you have to switch on CONFIG_SCHED_DEBUG):
+
+         /proc/sys/kernel/sched_granularity_ns
+
+   which can be used to tune the scheduler from 'desktop' (low
+   latencies) to 'server' (good batching) workloads. It defaults to a
+   setting suitable for desktop workloads. SCHED_BATCH is handled by the
+   CFS scheduler module too.
+
+   Due to its design, the CFS scheduler is not prone to any of the
+   'attacks' that exist today against the heuristics of the stock
+   scheduler: fiftyp.c, thud.c, chew.c, ring-test.c, massive_intr.c all
+   work fine and do not impact interactivity and produce the expected
+   behavior.
+
+   the CFS scheduler has a much stronger handling of nice levels and
+   SCHED_BATCH: both types of workloads should be isolated much more
+   agressively than under the vanilla scheduler.
+
+   ( another detail: due to nanosec accounting and timeline sorting,
+     sched_yield() support is very simple under CFS, and in fact under
+     CFS sched_yield() behaves much better than under any other
+     scheduler i have tested so far. )
+
+ - sched_rt.c implements SCHED_FIFO and SCHED_RR semantics, in a simpler
+   way than the vanilla scheduler does. It uses 100 runqueues (for all
+   100 RT priority levels, instead of 140 in the vanilla scheduler)
+   and it needs no expired array.
+
+ - reworked/sanitized SMP load-balancing: the runqueue-walking
+   assumptions are gone from the load-balancing code now, and
+   iterators of the scheduling modules are used. The balancing code got
+   quite a bit simpler as a result.
+
+
+Group scheduler extension to CFS
+================================
+
+Normally the scheduler operates on individual tasks and strives to provide
+fair CPU time to each task. Sometimes, it may be desirable to group tasks
+and provide fair CPU time to each such task group. For example, it may
+be desirable to first provide fair CPU time to each user on the system
+and then to each task belonging to a user.
+
+CONFIG_FAIR_GROUP_SCHED strives to achieve exactly that. It lets
+SCHED_NORMAL/BATCH tasks be be grouped and divides CPU time fairly among such
+groups. At present, there are two (mutually exclusive) mechanisms to group
+tasks for CPU bandwidth control purpose:
+
+	- Based on user id (CONFIG_FAIR_USER_SCHED)
+		In this option, tasks are grouped according to their user id.
+	- Based on "cgroup" pseudo filesystem (CONFIG_FAIR_CGROUP_SCHED)
+		This options lets the administrator create arbitrary groups
+		of tasks, using the "cgroup" pseudo filesystem. See
+		Documentation/cgroups.txt for more information about this
+		filesystem.
+
+Only one of these options to group tasks can be chosen and not both.
+
+Group scheduler tunables:
+
+When CONFIG_FAIR_USER_SCHED is defined, a directory is created in sysfs for
+each new user and a "cpu_share" file is added in that directory.
+
+	# cd /sys/kernel/uids
+	# cat 512/cpu_share		# Display user 512's CPU share
+	1024
+	# echo 2048 > 512/cpu_share	# Modify user 512's CPU share
+	# cat 512/cpu_share		# Display user 512's CPU share
+	2048
+	#
+
+CPU bandwidth between two users are divided in the ratio of their CPU shares.
+For ex: if you would like user "root" to get twice the bandwidth of user
+"guest", then set the cpu_share for both the users such that "root"'s
+cpu_share is twice "guest"'s cpu_share
+
+
+When CONFIG_FAIR_CGROUP_SCHED is defined, a "cpu.shares" file is created
+for each group created using the pseudo filesystem. See example steps
+below to create task groups and modify their CPU share using the "cgroups"
+pseudo filesystem
+
+	# mkdir /dev/cpuctl
+	# mount -t cgroup -ocpu none /dev/cpuctl
+	# cd /dev/cpuctl
+
+	# mkdir multimedia	# create "multimedia" group of tasks
+	# mkdir browser		# create "browser" group of tasks
+
+	# #Configure the multimedia group to receive twice the CPU bandwidth
+	# #that of browser group
+
+	# echo 2048 > multimedia/cpu.shares
+	# echo 1024 > browser/cpu.shares
+
+	# firefox &	# Launch firefox and move it to "browser" group
+	# echo <firefox_pid> > browser/tasks
+
+	# #Launch gmplayer (or your favourite movie player)
+	# echo <movie_player_pid> > multimedia/tasks
diff -puN /dev/null Documentation/scheduler/sched-design.txt
--- /dev/null
+++ a/Documentation/scheduler/sched-design.txt
@@ -0,0 +1,165 @@
+		   Goals, Design and Implementation of the
+		      new ultra-scalable O(1) scheduler
+
+
+  This is an edited version of an email Ingo Molnar sent to
+  lkml on 4 Jan 2002.  It describes the goals, design, and
+  implementation of Ingo's new ultra-scalable O(1) scheduler.
+  Last Updated: 18 April 2002.
+
+
+Goal
+====
+
+The main goal of the new scheduler is to keep all the good things we know
+and love about the current Linux scheduler:
+
+ - good interactive performance even during high load: if the user
+   types or clicks then the system must react instantly and must execute
+   the user tasks smoothly, even during considerable background load.
+
+ - good scheduling/wakeup performance with 1-2 runnable processes.
+
+ - fairness: no process should stay without any timeslice for any
+   unreasonable amount of time. No process should get an unjustly high
+   amount of CPU time.
+
+ - priorities: less important tasks can be started with lower priority,
+   more important tasks with higher priority.
+
+ - SMP efficiency: no CPU should stay idle if there is work to do.
+
+ - SMP affinity: processes which run on one CPU should stay affine to
+   that CPU. Processes should not bounce between CPUs too frequently.
+
+ - plus additional scheduler features: RT scheduling, CPU binding.
+
+and the goal is also to add a few new things:
+
+ - fully O(1) scheduling. Are you tired of the recalculation loop
+   blowing the L1 cache away every now and then? Do you think the goodness
+   loop is taking a bit too long to finish if there are lots of runnable
+   processes? This new scheduler takes no prisoners: wakeup(), schedule(),
+   the timer interrupt are all O(1) algorithms. There is no recalculation
+   loop. There is no goodness loop either.
+
+ - 'perfect' SMP scalability. With the new scheduler there is no 'big'
+   runqueue_lock anymore - it's all per-CPU runqueues and locks - two
+   tasks on two separate CPUs can wake up, schedule and context-switch
+   completely in parallel, without any interlocking. All
+   scheduling-relevant data is structured for maximum scalability.
+
+ - better SMP affinity. The old scheduler has a particular weakness that
+   causes the random bouncing of tasks between CPUs if/when higher
+   priority/interactive tasks, this was observed and reported by many
+   people. The reason is that the timeslice recalculation loop first needs
+   every currently running task to consume its timeslice. But when this
+   happens on eg. an 8-way system, then this property starves an
+   increasing number of CPUs from executing any process. Once the last
+   task that has a timeslice left has finished using up that timeslice,
+   the recalculation loop is triggered and other CPUs can start executing
+   tasks again - after having idled around for a number of timer ticks.
+   The more CPUs, the worse this effect.
+
+   Furthermore, this same effect causes the bouncing effect as well:
+   whenever there is such a 'timeslice squeeze' of the global runqueue,
+   idle processors start executing tasks which are not affine to that CPU.
+   (because the affine tasks have finished off their timeslices already.)
+
+   The new scheduler solves this problem by distributing timeslices on a
+   per-CPU basis, without having any global synchronization or
+   recalculation.
+
+ - batch scheduling. A significant proportion of computing-intensive tasks
+   benefit from batch-scheduling, where timeslices are long and processes
+   are roundrobin scheduled. The new scheduler does such batch-scheduling
+   of the lowest priority tasks - so nice +19 jobs will get
+   'batch-scheduled' automatically. With this scheduler, nice +19 jobs are
+   in essence SCHED_IDLE, from an interactiveness point of view.
+
+ - handle extreme loads more smoothly, without breakdown and scheduling
+   storms.
+
+ - O(1) RT scheduling. For those RT folks who are paranoid about the
+   O(nr_running) property of the goodness loop and the recalculation loop.
+
+ - run fork()ed children before the parent. Andrea has pointed out the
+   advantages of this a few months ago, but patches for this feature
+   do not work with the old scheduler as well as they should,
+   because idle processes often steal the new child before the fork()ing
+   CPU gets to execute it.
+
+
+Design
+======
+
+The core of the new scheduler contains the following mechanisms:
+
+ - *two* priority-ordered 'priority arrays' per CPU. There is an 'active'
+   array and an 'expired' array. The active array contains all tasks that
+   are affine to this CPU and have timeslices left. The expired array
+   contains all tasks which have used up their timeslices - but this array
+   is kept sorted as well. The active and expired array is not accessed
+   directly, it's accessed through two pointers in the per-CPU runqueue
+   structure. If all active tasks are used up then we 'switch' the two
+   pointers and from now on the ready-to-go (former-) expired array is the
+   active array - and the empty active array serves as the new collector
+   for expired tasks.
+
+ - there is a 64-bit bitmap cache for array indices. Finding the highest
+   priority task is thus a matter of two x86 BSFL bit-search instructions.
+
+the split-array solution enables us to have an arbitrary number of active
+and expired tasks, and the recalculation of timeslices can be done
+immediately when the timeslice expires. Because the arrays are always
+access through the pointers in the runqueue, switching the two arrays can
+be done very quickly.
+
+this is a hybride priority-list approach coupled with roundrobin
+scheduling and the array-switch method of distributing timeslices.
+
+ - there is a per-task 'load estimator'.
+
+one of the toughest things to get right is good interactive feel during
+heavy system load. While playing with various scheduler variants i found
+that the best interactive feel is achieved not by 'boosting' interactive
+tasks, but by 'punishing' tasks that want to use more CPU time than there
+is available. This method is also much easier to do in an O(1) fashion.
+
+to establish the actual 'load' the task contributes to the system, a
+complex-looking but pretty accurate method is used: there is a 4-entry
+'history' ringbuffer of the task's activities during the last 4 seconds.
+This ringbuffer is operated without much overhead. The entries tell the
+scheduler a pretty accurate load-history of the task: has it used up more
+CPU time or less during the past N seconds. [the size '4' and the interval
+of 4x 1 seconds was found by lots of experimentation - this part is
+flexible and can be changed in both directions.]
+
+the penalty a task gets for generating more load than the CPU can handle
+is a priority decrease - there is a maximum amount to this penalty
+relative to their static priority, so even fully CPU-bound tasks will
+observe each other's priorities, and will share the CPU accordingly.
+
+the SMP load-balancer can be extended/switched with additional parallel
+computing and cache hierarchy concepts: NUMA scheduling, multi-core CPUs
+can be supported easily by changing the load-balancer. Right now it's
+tuned for my SMP systems.
+
+i skipped the prev->mm == next->mm advantage - no workload i know of shows
+any sensitivity to this. It can be added back by sacrificing O(1)
+schedule() [the current and one-lower priority list can be searched for a
+that->mm == current->mm condition], but costs a fair number of cycles
+during a number of important workloads, so i wanted to avoid this as much
+as possible.
+
+- the SMP idle-task startup code was still racy and the new scheduler
+triggered this. So i streamlined the idle-setup code a bit. We do not call
+into schedule() before all processors have started up fully and all idle
+threads are in place.
+
+- the patch also cleans up a number of aspects of sched.c - moves code
+into other areas of the kernel where it's appropriate, and simplifies
+certain code paths and data constructs. As a result, the new scheduler's
+code is smaller than the old one.
+
+	Ingo
diff -puN /dev/null Documentation/scheduler/sched-domains.txt
--- /dev/null
+++ a/Documentation/scheduler/sched-domains.txt
@@ -0,0 +1,70 @@
+Each CPU has a "base" scheduling domain (struct sched_domain). These are
+accessed via cpu_sched_domain(i) and this_sched_domain() macros. The domain
+hierarchy is built from these base domains via the ->parent pointer. ->parent
+MUST be NULL terminated, and domain structures should be per-CPU as they
+are locklessly updated.
+
+Each scheduling domain spans a number of CPUs (stored in the ->span field).
+A domain's span MUST be a superset of it child's span (this restriction could
+be relaxed if the need arises), and a base domain for CPU i MUST span at least
+i. The top domain for each CPU will generally span all CPUs in the system
+although strictly it doesn't have to, but this could lead to a case where some
+CPUs will never be given tasks to run unless the CPUs allowed mask is
+explicitly set. A sched domain's span means "balance process load among these
+CPUs".
+
+Each scheduling domain must have one or more CPU groups (struct sched_group)
+which are organised as a circular one way linked list from the ->groups
+pointer. The union of cpumasks of these groups MUST be the same as the
+domain's span. The intersection of cpumasks from any two of these groups
+MUST be the empty set. The group pointed to by the ->groups pointer MUST
+contain the CPU to which the domain belongs. Groups may be shared among
+CPUs as they contain read only data after they have been set up.
+
+Balancing within a sched domain occurs between groups. That is, each group
+is treated as one entity. The load of a group is defined as the sum of the
+load of each of its member CPUs, and only when the load of a group becomes
+out of balance are tasks moved between groups.
+
+In kernel/sched.c, rebalance_tick is run periodically on each CPU. This
+function takes its CPU's base sched domain and checks to see if has reached
+its rebalance interval. If so, then it will run load_balance on that domain.
+rebalance_tick then checks the parent sched_domain (if it exists), and the
+parent of the parent and so forth.
+
+*** Implementing sched domains ***
+The "base" domain will "span" the first level of the hierarchy. In the case
+of SMT, you'll span all siblings of the physical CPU, with each group being
+a single virtual CPU.
+
+In SMP, the parent of the base domain will span all physical CPUs in the
+node. Each group being a single physical CPU. Then with NUMA, the parent
+of the SMP domain will span the entire machine, with each group having the
+cpumask of a node. Or, you could do multi-level NUMA or Opteron, for example,
+might have just one domain covering its one NUMA level.
+
+The implementor should read comments in include/linux/sched.h:
+struct sched_domain fields, SD_FLAG_*, SD_*_INIT to get an idea of
+the specifics and what to tune.
+
+For SMT, the architecture must define CONFIG_SCHED_SMT and provide a
+cpumask_t cpu_sibling_map[NR_CPUS], where cpu_sibling_map[i] is the mask of
+all "i"'s siblings as well as "i" itself.
+
+Architectures may retain the regular override the default SD_*_INIT flags
+while using the generic domain builder in kernel/sched.c if they wish to
+retain the traditional SMT->SMP->NUMA topology (or some subset of that). This
+can be done by #define'ing ARCH_HASH_SCHED_TUNE.
+
+Alternatively, the architecture may completely override the generic domain
+builder by #define'ing ARCH_HASH_SCHED_DOMAIN, and exporting your
+arch_init_sched_domains function. This function will attach domains to all
+CPUs using cpu_attach_domain.
+
+Implementors should change the line
+#undef SCHED_DOMAIN_DEBUG
+to
+#define SCHED_DOMAIN_DEBUG
+in kernel/sched.c as this enables an error checking parse of the sched domains
+which should catch most possible errors (described above). It also prints out
+the domain structure in a visual format.
diff -puN /dev/null Documentation/scheduler/sched-nice-design.txt
--- /dev/null
+++ a/Documentation/scheduler/sched-nice-design.txt
@@ -0,0 +1,108 @@
+This document explains the thinking about the revamped and streamlined
+nice-levels implementation in the new Linux scheduler.
+
+Nice levels were always pretty weak under Linux and people continuously
+pestered us to make nice +19 tasks use up much less CPU time.
+
+Unfortunately that was not that easy to implement under the old
+scheduler, (otherwise we'd have done it long ago) because nice level
+support was historically coupled to timeslice length, and timeslice
+units were driven by the HZ tick, so the smallest timeslice was 1/HZ.
+
+In the O(1) scheduler (in 2003) we changed negative nice levels to be
+much stronger than they were before in 2.4 (and people were happy about
+that change), and we also intentionally calibrated the linear timeslice
+rule so that nice +19 level would be _exactly_ 1 jiffy. To better
+understand it, the timeslice graph went like this (cheesy ASCII art
+alert!):
+
+
+                   A
+             \     | [timeslice length]
+              \    |
+               \   |
+                \  |
+                 \ |
+                  \|___100msecs
+                   |^ . _
+                   |      ^ . _
+                   |            ^ . _
+ -*----------------------------------*-----> [nice level]
+ -20               |                +19
+                   |
+                   |
+
+So that if someone wanted to really renice tasks, +19 would give a much
+bigger hit than the normal linear rule would do. (The solution of
+changing the ABI to extend priorities was discarded early on.)
+
+This approach worked to some degree for some time, but later on with
+HZ=1000 it caused 1 jiffy to be 1 msec, which meant 0.1% CPU usage which
+we felt to be a bit excessive. Excessive _not_ because it's too small of
+a CPU utilization, but because it causes too frequent (once per
+millisec) rescheduling. (and would thus trash the cache, etc. Remember,
+this was long ago when hardware was weaker and caches were smaller, and
+people were running number crunching apps at nice +19.)
+
+So for HZ=1000 we changed nice +19 to 5msecs, because that felt like the
+right minimal granularity - and this translates to 5% CPU utilization.
+But the fundamental HZ-sensitive property for nice+19 still remained,
+and we never got a single complaint about nice +19 being too _weak_ in
+terms of CPU utilization, we only got complaints about it (still) being
+too _strong_ :-)
+
+To sum it up: we always wanted to make nice levels more consistent, but
+within the constraints of HZ and jiffies and their nasty design level
+coupling to timeslices and granularity it was not really viable.
+
+The second (less frequent but still periodically occuring) complaint
+about Linux's nice level support was its assymetry around the origo
+(which you can see demonstrated in the picture above), or more
+accurately: the fact that nice level behavior depended on the _absolute_
+nice level as well, while the nice API itself is fundamentally
+"relative":
+
+   int nice(int inc);
+
+   asmlinkage long sys_nice(int increment)
+
+(the first one is the glibc API, the second one is the syscall API.)
+Note that the 'inc' is relative to the current nice level. Tools like
+bash's "nice" command mirror this relative API.
+
+With the old scheduler, if you for example started a niced task with +1
+and another task with +2, the CPU split between the two tasks would
+depend on the nice level of the parent shell - if it was at nice -10 the
+CPU split was different than if it was at +5 or +10.
+
+A third complaint against Linux's nice level support was that negative
+nice levels were not 'punchy enough', so lots of people had to resort to
+run audio (and other multimedia) apps under RT priorities such as
+SCHED_FIFO. But this caused other problems: SCHED_FIFO is not starvation
+proof, and a buggy SCHED_FIFO app can also lock up the system for good.
+
+The new scheduler in v2.6.23 addresses all three types of complaints:
+
+To address the first complaint (of nice levels being not "punchy"
+enough), the scheduler was decoupled from 'time slice' and HZ concepts
+(and granularity was made a separate concept from nice levels) and thus
+it was possible to implement better and more consistent nice +19
+support: with the new scheduler nice +19 tasks get a HZ-independent
+1.5%, instead of the variable 3%-5%-9% range they got in the old
+scheduler.
+
+To address the second complaint (of nice levels not being consistent),
+the new scheduler makes nice(1) have the same CPU utilization effect on
+tasks, regardless of their absolute nice levels. So on the new
+scheduler, running a nice +10 and a nice 11 task has the same CPU
+utilization "split" between them as running a nice -5 and a nice -4
+task. (one will get 55% of the CPU, the other 45%.) That is why nice
+levels were changed to be "multiplicative" (or exponential) - that way
+it does not matter which nice level you start out from, the 'relative
+result' will always be the same.
+
+The third complaint (of negative nice levels not being "punchy" enough
+and forcing audio apps to run under the more dangerous SCHED_FIFO
+scheduling policy) is addressed by the new scheduler almost
+automatically: stronger negative nice levels are an automatic
+side-effect of the recalibrated dynamic range of nice levels.
diff -puN /dev/null Documentation/scheduler/sched-stats.txt
--- /dev/null
+++ a/Documentation/scheduler/sched-stats.txt
@@ -0,0 +1,156 @@
+Version 14 of schedstats includes support for sched_domains, which hit the
+mainline kernel in 2.6.20 although it is identical to the stats from version
+12 which was in the kernel from 2.6.13-2.6.19 (version 13 never saw a kernel
+release).  Some counters make more sense to be per-runqueue; other to be
+per-domain.  Note that domains (and their associated information) will only
+be pertinent and available on machines utilizing CONFIG_SMP.
+
+In version 14 of schedstat, there is at least one level of domain
+statistics for each cpu listed, and there may well be more than one
+domain.  Domains have no particular names in this implementation, but
+the highest numbered one typically arbitrates balancing across all the
+cpus on the machine, while domain0 is the most tightly focused domain,
+sometimes balancing only between pairs of cpus.  At this time, there
+are no architectures which need more than three domain levels. The first
+field in the domain stats is a bit map indicating which cpus are affected
+by that domain.
+
+These fields are counters, and only increment.  Programs which make use
+of these will need to start with a baseline observation and then calculate
+the change in the counters at each subsequent observation.  A perl script
+which does this for many of the fields is available at
+
+    http://eaglet.rain.com/rick/linux/schedstat/
+
+Note that any such script will necessarily be version-specific, as the main
+reason to change versions is changes in the output format.  For those wishing
+to write their own scripts, the fields are described here.
+
+CPU statistics
+--------------
+cpu<N> 1 2 3 4 5 6 7 8 9 10 11 12
+
+NOTE: In the sched_yield() statistics, the active queue is considered empty
+    if it has only one process in it, since obviously the process calling
+    sched_yield() is that process.
+
+First four fields are sched_yield() statistics:
+     1) # of times both the active and the expired queue were empty
+     2) # of times just the active queue was empty
+     3) # of times just the expired queue was empty
+     4) # of times sched_yield() was called
+
+Next three are schedule() statistics:
+     5) # of times we switched to the expired queue and reused it
+     6) # of times schedule() was called
+     7) # of times schedule() left the processor idle
+
+Next two are try_to_wake_up() statistics:
+     8) # of times try_to_wake_up() was called
+     9) # of times try_to_wake_up() was called to wake up the local cpu
+
+Next three are statistics describing scheduling latency:
+    10) sum of all time spent running by tasks on this processor (in jiffies)
+    11) sum of all time spent waiting to run by tasks on this processor (in
+        jiffies)
+    12) # of timeslices run on this cpu
+
+
+Domain statistics
+-----------------
+One of these is produced per domain for each cpu described. (Note that if
+CONFIG_SMP is not defined, *no* domains are utilized and these lines
+will not appear in the output.)
+
+domain<N> <cpumask> 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36
+
+The first field is a bit mask indicating what cpus this domain operates over.
+
+The next 24 are a variety of load_balance() statistics in grouped into types
+of idleness (idle, busy, and newly idle):
+
+     1) # of times in this domain load_balance() was called when the
+        cpu was idle
+     2) # of times in this domain load_balance() checked but found
+        the load did not require balancing when the cpu was idle
+     3) # of times in this domain load_balance() tried to move one or
+        more tasks and failed, when the cpu was idle
+     4) sum of imbalances discovered (if any) with each call to
+        load_balance() in this domain when the cpu was idle
+     5) # of times in this domain pull_task() was called when the cpu
+        was idle
+     6) # of times in this domain pull_task() was called even though
+        the target task was cache-hot when idle
+     7) # of times in this domain load_balance() was called but did
+        not find a busier queue while the cpu was idle
+     8) # of times in this domain a busier queue was found while the
+        cpu was idle but no busier group was found
+
+     9) # of times in this domain load_balance() was called when the
+        cpu was busy
+    10) # of times in this domain load_balance() checked but found the
+        load did not require balancing when busy
+    11) # of times in this domain load_balance() tried to move one or
+        more tasks and failed, when the cpu was busy
+    12) sum of imbalances discovered (if any) with each call to
+        load_balance() in this domain when the cpu was busy
+    13) # of times in this domain pull_task() was called when busy
+    14) # of times in this domain pull_task() was called even though the
+        target task was cache-hot when busy
+    15) # of times in this domain load_balance() was called but did not
+        find a busier queue while the cpu was busy
+    16) # of times in this domain a busier queue was found while the cpu
+        was busy but no busier group was found
+
+    17) # of times in this domain load_balance() was called when the
+        cpu was just becoming idle
+    18) # of times in this domain load_balance() checked but found the
+        load did not require balancing when the cpu was just becoming idle
+    19) # of times in this domain load_balance() tried to move one or more
+        tasks and failed, when the cpu was just becoming idle
+    20) sum of imbalances discovered (if any) with each call to
+        load_balance() in this domain when the cpu was just becoming idle
+    21) # of times in this domain pull_task() was called when newly idle
+    22) # of times in this domain pull_task() was called even though the
+        target task was cache-hot when just becoming idle
+    23) # of times in this domain load_balance() was called but did not
+        find a busier queue while the cpu was just becoming idle
+    24) # of times in this domain a busier queue was found while the cpu
+        was just becoming idle but no busier group was found
+
+   Next three are active_load_balance() statistics:
+    25) # of times active_load_balance() was called
+    26) # of times active_load_balance() tried to move a task and failed
+    27) # of times active_load_balance() successfully moved a task
+
+   Next three are sched_balance_exec() statistics:
+    28) sbe_cnt is not used
+    29) sbe_balanced is not used
+    30) sbe_pushed is not used
+
+   Next three are sched_balance_fork() statistics:
+    31) sbf_cnt is not used
+    32) sbf_balanced is not used
+    33) sbf_pushed is not used
+
+   Next three are try_to_wake_up() statistics:
+    34) # of times in this domain try_to_wake_up() awoke a task that
+        last ran on a different cpu in this domain
+    35) # of times in this domain try_to_wake_up() moved a task to the
+        waking cpu because it was cache-cold on its own cpu anyway
+    36) # of times in this domain try_to_wake_up() started passive balancing
+
+/proc/<pid>/schedstat
+----------------
+schedstats also adds a new /proc/<pid/schedstat file to include some of
+the same information on a per-process level.  There are three fields in
+this file correlating for that process to:
+     1) time spent on the cpu
+     2) time spent waiting on a runqueue
+     3) # of timeslices run on this cpu
+
+A program could be easily written to make use of these extra fields to
+report on how well a particular process or set of processes is faring
+under the scheduler's policies.  A simple version of such a program is
+available at
+    http://eaglet.rain.com/rick/linux/schedstat/v12/latency.c
_

Patches currently in -mm which might be from bfields@citi.umich.edu are

git-nfs.patch
git-nfsd.patch
documentation-move-dnotifytxt-to-filesystems.patch
documentation-move-sharedsubtreestxt-to-filesystems.patch
documentation-create-new-scheduler-subdirectory.patch
reporting-bugs-cc-the-mailing-list-too.patch
use-struct-path-in-struct-svc_export.patch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
reiser4.patch
