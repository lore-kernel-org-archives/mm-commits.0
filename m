From: akpm@linux-foundation.org
Subject: - cfs-scheduler-v14-rc2-mm1.patch removed from -mm tree
Date: Tue, 10 Jul 2007 12:49:47 -0700
Message-ID: <200707101949.l6AJnloe026190@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46904 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759168AbXGJTzE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Jul 2007 15:55:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     CFS scheduler: v14
has been removed from the -mm tree.  Its filename was
     cfs-scheduler-v14-rc2-mm1.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: CFS scheduler: v14
From: Ingo Molnar <mingo@elte.hu>

CFS -v14:

 - increase sleeper-fairness (Mike Galbraith, me)

 - CFS documentation fixes (Pranith Kumar D)

 - increased the default rescheduling granularity to 3msecs on UP,
   6 msecs on 2-way systems

 - small update_curr() precision fix

 - added an overview section to Documentation/sched-design-CFS.txt

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sched-design-CFS.txt |   98 +++++++++++++++------------
 kernel/sched_fair.c                |   73 +++++++++++++++++---
 2 files changed, 117 insertions(+), 54 deletions(-)

diff -puN Documentation/sched-design-CFS.txt~cfs-scheduler-v14-rc2-mm1 Documentation/sched-design-CFS.txt
--- a/Documentation/sched-design-CFS.txt~cfs-scheduler-v14-rc2-mm1
+++ a/Documentation/sched-design-CFS.txt
@@ -1,20 +1,59 @@
-[announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
 
-i'm pleased to announce the first release of the "Modular Scheduler Core
-and Completely Fair Scheduler [CFS]" patchset:
+This is the CFS scheduler.
 
-   http://redhat.com/~mingo/cfs-scheduler/
+80% of CFS's design can be summed up in a single sentence: CFS basically
+models an "ideal, precise multi-tasking CPU" on real hardware.
 
-This project is a complete rewrite of the Linux task scheduler. My goal
-is to address various feature requests and to fix deficiencies in the
-vanilla scheduler that were suggested/found in the past few years, both
-for desktop scheduling and for server scheduling workloads.
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
 
-[ QuickStart: apply the patch, recompile, reboot. The new scheduler
-  will be active by default and all tasks will default to the
-  SCHED_NORMAL interactive scheduling class. ]
-
-Highlights are:
+Some implementation details:
 
  - the introduction of Scheduling Classes: an extensible hierarchy of
    scheduler modules. These modules encapsulate scheduling policy
@@ -25,7 +64,7 @@ Highlights are:
    replacement for the vanilla scheduler's SCHED_OTHER interactivity
    code.
 
-   i'd like to give credit to Con Kolivas for the general approach here:
+   I'd like to give credit to Con Kolivas for the general approach here:
    he has proven via RSDL/SD that 'fair scheduling' is possible and that
    it results in better desktop scheduling. Kudos Con!
 
@@ -53,7 +92,7 @@ Highlights are:
    setting suitable for desktop workloads. SCHED_BATCH is handled by the
    CFS scheduler module too.
 
-   due to its design, the CFS scheduler is not prone to any of the
+   Due to its design, the CFS scheduler is not prone to any of the
    'attacks' that exist today against the heuristics of the stock
    scheduler: fiftyp.c, thud.c, chew.c, ring-test.c, massive_intr.c all
    work fine and do not impact interactivity and produce the expected
@@ -63,7 +102,7 @@ Highlights are:
    SCHED_BATCH: both types of workloads should be isolated much more
    agressively than under the vanilla scheduler.
 
-   ( another rdetail: due to nanosec accounting and timeline sorting,
+   ( another detail: due to nanosec accounting and timeline sorting,
      sched_yield() support is very simple under CFS, and in fact under
      CFS sched_yield() behaves much better than under any other
      scheduler i have tested so far. )
@@ -78,30 +117,3 @@ Highlights are:
    iterators of the scheduling modules are used. The balancing code got
    quite a bit simpler as a result.
 
-the core scheduler got smaller by more than 700 lines:
-
- kernel/sched.c | 1454 ++++++++++++++++------------------------------------------------
- 1 file changed, 372 insertions(+), 1082 deletions(-)
-
-and even adding all the scheduling modules, the total size impact is
-relatively small:
-
- 18 files changed, 1454 insertions(+), 1133 deletions(-)
-
-most of the increase is due to extensive comments. The kernel size
-impact is in fact a small negative:
-
-   text    data     bss     dec     hex filename
-  23366    4001      24   27391    6aff kernel/sched.o.vanilla
-  24159    2705      56   26920    6928 kernel/sched.o.CFS
-
-(this is mainly due to the benefit of getting rid of the expired array
-and its data structure overhead.)
-
-thanks go to Thomas Gleixner and Arjan van de Ven for review of this
-patchset.
-
-as usual, any sort of feedback, bugreports, fixes and suggestions are
-more than welcome,
-
-	Ingo
diff -puN kernel/sched_fair.c~cfs-scheduler-v14-rc2-mm1 kernel/sched_fair.c
--- a/kernel/sched_fair.c~cfs-scheduler-v14-rc2-mm1
+++ a/kernel/sched_fair.c
@@ -16,11 +16,11 @@
  * number of CPUs. (i.e. factor 2x on 2-way systems, 3x on 4-way
  * systems, 4x on 8-way systems, 5x on 16-way systems, etc.)
  */
-unsigned int sysctl_sched_granularity __read_mostly = 1000000000/HZ;
+unsigned int sysctl_sched_granularity __read_mostly = 3000000000ULL/HZ;
 
 /*
  * Wake-up granularity.
- * (default: 1 msec, units: nanoseconds)
+ * (default: 0, units: nanoseconds)
  *
  * This option delays the preemption effects of decoupled workloads
  * and reduces their over-scheduling. Synchronous workloads will still
@@ -28,9 +28,9 @@ unsigned int sysctl_sched_granularity __
  */
 unsigned int sysctl_sched_wakeup_granularity __read_mostly = 0;
 
-unsigned int sysctl_sched_runtime_limit __read_mostly = 2000000000/HZ;
+unsigned int sysctl_sched_runtime_limit __read_mostly = 6000000000ULL/HZ;
 
-unsigned int sysctl_sched_load_smoothing __read_mostly = 0;
+unsigned int sysctl_sched_load_smoothing __read_mostly = 8 | 16 | 32;
 
 /*
  * sys_sched_yield unfairness bug workaround switch.
@@ -192,8 +192,8 @@ static inline void update_curr(struct rq
 	u64 delta_exec, delta_fair, delta_mine;
 	struct task_struct *curr = rq->curr;
 
-	if (curr->sched_class != &fair_sched_class || curr == rq->idle
-			|| !curr->on_rq)
+	if (curr->sched_class != &fair_sched_class ||
+			!rq->raw_weighted_load || curr == rq->idle)
 		return;
 	/*
 	 * Get the amount of time the current task was running
@@ -384,6 +384,50 @@ update_stats_curr_end(struct rq *rq, str
 	p->exec_start = 0;
 }
 
+long div64_s(s64 divident, unsigned long divisor)
+{
+	u64 tmp;
+
+	if (divident < 0) {
+		tmp = -divident;
+		do_div(tmp, divisor);
+		return -(s64)tmp;
+	} else {
+		tmp = divident;
+		do_div(tmp, divisor);
+		return (s64)tmp;
+	}
+}
+
+/*
+ * A task gets added back to the runnable tasks and gets
+ * a small credit for the CPU time it missed out on while
+ * it slept, so fix up all other runnable task's wait_runtime
+ * so that the sum stays constant (around 0).
+ *
+ * Instead of looping over all runnable tasks in an O(N)
+ * manner we move the fair clock back by a proportional
+ * amount of the new wait_runtime this task adds to the pool.
+ */
+static void distribute_fair_add(struct rq *rq, s64 delta)
+{
+	struct task_struct *curr = rq->curr;
+	s64 delta_fair = 0;
+
+	if (!(sysctl_sched_load_smoothing & 32))
+		return;
+
+	if (rq->nr_running) {
+		delta_fair = div64_s(delta, rq->nr_running);
+		/*
+		 * The currently running task's next wait_runtime value does
+		 * not depend on the fair_clock, so fix it up explicitly:
+		 */
+		add_wait_runtime(rq, curr, -delta_fair);
+		rq->fair_clock -= delta_fair;
+	}
+}
+
 /**************************************************************/
 /* Scheduling class queueing methods:
  */
@@ -391,7 +435,7 @@ update_stats_curr_end(struct rq *rq, str
 static void enqueue_sleeper(struct rq *rq, struct task_struct *p)
 {
 	unsigned long load = get_rq_load(rq);
-	u64 delta_fair = 0;
+	s64 delta_fair, prev_runtime;
 
 	if (!(sysctl_sched_load_smoothing & 16))
 		goto out;
@@ -404,12 +448,19 @@ static void enqueue_sleeper(struct rq *r
 	 * Fix up delta_fair with the effect of us running
 	 * during the whole sleep period:
 	 */
-	if (sysctl_sched_load_smoothing & 8) {
-		delta_fair = delta_fair * load;
-		do_div(delta_fair, load + p->load_weight);
-	}
+	if (sysctl_sched_load_smoothing & 8)
+		delta_fair = div64_s(delta_fair * load, load + p->load_weight);
 
+	prev_runtime = p->wait_runtime;
 	__add_wait_runtime(rq, p, delta_fair);
+	delta_fair = p->wait_runtime - prev_runtime;
+
+	/*
+	 * We move the fair clock back by a load-proportional
+	 * amount of the new wait_runtime this task adds to
+	 * the 'pool':
+	 */
+	distribute_fair_add(rq, delta_fair);
 
 out:
 	rq->wait_runtime += p->wait_runtime;
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
git-acpi.patch
git-kvm.patch
git-selinux.patch
git-s390.patch
x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
tick-management-spread-timer-interrupt.patch
highres-improve-debug-output.patch
hrtimer-speedup-hrtimer_enqueue.patch
pcspkr-use-the-global-pit-lock.patch
ntp-move-the-cmos-update-code-into-ntpc.patch
i386-pit-stop-only-when-in-periodic-or-oneshot-mode.patch
i386-remove-volatile-in-apicc.patch
i386-hpet-assumes-boot-cpu-is-0.patch
i386-move-pit-function-declarations-and-constants-to-correct-header-file.patch
x86_64-untangle-asm-hpeth-from-asm-timexh.patch
x86_64-use-generic-cmos-update.patch
x86_64-remove-dead-code-and-other-janitor-work-in-tscc.patch
x86_64-fix-apic-typo.patch
x86_64-convert-to-cleckevents.patch
acpi-remove-the-useless-ifdef-code.patch
x86_64-hpet-restore-vread.patch
x86_64-restore-restore-nohpet-cmdline.patch
x86_64-block-irq-balancing-for-timer.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-enable-high-resolution-timers-and-dynticks.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
ich-force-hpet-make-generic-time-capable-of-switching-broadcast-timer.patch
ich-force-hpet-restructure-hpet-generic-clock-code.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable.patch
ich-force-hpet-late-initialization-of-hpet-after-quirk.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable.patch
ich-force-hpet-ich5-fix-a-bug-with-suspend-resume.patch
ich-force-hpet-add-ich7_0-pciid-to-quirk-list.patch
geode-mfgpt-clock-event-device-support.patch
i386-ioapic-remove-old-irq-balancing-debug-cruft.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
add-generic-exit-time-stack-depth-checking-to-config_debug_stack_usage.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
introduce-write_trylock_irqsave.patch
use-write_trylock_irqsave-in-ptrace_attach.patch
introduce-boot-based-time.patch
use-boot-based-time-for-process-start-time-and-boot-time.patch
fix-stop_machine_run-problem-with-naughty-real-time-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch
pie-randomization.patch
vdso-print-fatal-signals.patch
remove-clockevents_releaserequest_device.patch
add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats.patch
introduce-o_cloexec-take-2.patch
o_cloexec-for-scm_rights.patch
improve-behaviour-of-spurious-irq-detect.patch
allow-softlockup-to-be-runtime-disabled.patch
sys_time-speedup.patch
futex-tidy-up-the-code-v2.patch
modules-remove-modlist_lock.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
fix-raw_spinlock_t-vs-lockdep.patch
lockdep-sanitise-config_prove_locking.patch
lockdep-reduce-the-ifdeffery.patch
lockstat-core-infrastructure.patch
lockstat-human-readability-tweaks.patch
lockstat-hook-into-spinlock_t-rwlock_t-rwsem-and-mutex.patch
lockdep-various-fixes.patch
lockdep-fixup-sk_callback_lock-annotation.patch
lockstat-measure-lock-bouncing.patch
lockstat-better-class-name-representation.patch
lockdep-debugging-give-stacktrace-for-init_error.patch
stacktrace-fix-header-file-for-config_stacktrace.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
kmap_atomic-debugging.patch
random-warning-squishes.patch
