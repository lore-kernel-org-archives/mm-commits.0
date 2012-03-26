From: akpm@linux-foundation.org
Subject: [merged] watchdog-make-sure-the-watchdog-thread-gets-cpu-on-loaded-system.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:28:30 -0700
Message-ID: <20120326192830.9196FA0560@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:34884 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab2CZT2d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:28:33 -0400
Received: by lbbgj3 with SMTP id gj3so288078lbb.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:28:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, a.p.zijlstra@chello.nl, dzickus@redhat.com, mingo@elte.hu, msb@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: make sure the watchdog thread gets CPU on loaded system
has been removed from the -mm tree.  Its filename was
     watchdog-make-sure-the-watchdog-thread-gets-cpu-on-loaded-system.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: watchdog: make sure the watchdog thread gets CPU on loaded system

If the system is loaded while hotplugging a CPU we might end up with a
bogus hardlockup detection.  This has been seen during LTP pounder test
executed in parallel with hotplug test.

The main problem is that enable_watchdog (called when CPU is brought up)
registers perf event which periodically checks per-cpu counter
(hrtimer_interrupts), updated from a hrtimer callback, but the hrtimer is
fired from the kernel thread.

This means that while we already do check for the hard lockup the kernel
thread might be sitting on the runqueue with zillions of tasks so there is
nobody to update the value we rely on and so we KABOOM.

Let's fix this by boosting the watchdog thread priority before we wake it
up rather than when it's already running.  This still doesn't handle a
case where we have the same amount of high prio FIFO tasks but that
doesn't seem to be common.  The current implementation doesn't handle that
case anyway so this is not worse at least.

Unfortunately, we cannot start perf counter from the watchdog thread
because we could miss a real lock up and also we cannot start the hrtimer
watchdog_enable because we there is no way (at least I don't know any) to
start a hrtimer from a different CPU.

[dzickus@redhat.com: fix compile issue with param]
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reviewed-by: Mandeep Singh Baines <msb@chromium.org>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN kernel/watchdog.c~watchdog-make-sure-the-watchdog-thread-gets-cpu-on-loaded-system kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-make-sure-the-watchdog-thread-gets-cpu-on-loaded-system
+++ a/kernel/watchdog.c
@@ -319,11 +319,9 @@ static enum hrtimer_restart watchdog_tim
  */
 static int watchdog(void *unused)
 {
-	struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
+	struct sched_param param = { .sched_priority = 0 };
 	struct hrtimer *hrtimer = &__raw_get_cpu_var(watchdog_hrtimer);
 
-	sched_setscheduler(current, SCHED_FIFO, &param);
-
 	/* initialize timestamp */
 	__touch_watchdog();
 
@@ -350,7 +348,6 @@ static int watchdog(void *unused)
 		set_current_state(TASK_INTERRUPTIBLE);
 	}
 	__set_current_state(TASK_RUNNING);
-	param.sched_priority = 0;
 	sched_setscheduler(current, SCHED_NORMAL, &param);
 	return 0;
 }
@@ -439,6 +436,7 @@ static int watchdog_enable(int cpu)
 
 	/* create the watchdog thread */
 	if (!p) {
+		struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
 		p = kthread_create_on_node(watchdog, NULL, cpu_to_node(cpu), "watchdog/%d", cpu);
 		if (IS_ERR(p)) {
 			printk(KERN_ERR "softlockup watchdog for %i failed\n", cpu);
@@ -450,6 +448,7 @@ static int watchdog_enable(int cpu)
 			}
 			goto out;
 		}
+		sched_setscheduler(p, SCHED_FIFO, &param);
 		kthread_bind(p, cpu);
 		per_cpu(watchdog_touch_ts, cpu) = 0;
 		per_cpu(softlockup_watchdog, cpu) = p;
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
memcg-change-behavior-of-moving-charges-at-task-move.patch
memcg-change-behavior-of-moving-charges-at-task-move-fix.patch
memcg-swap-mem_cgroup_move_swap_account-never-needs-fixup.patch
memcg-swap-use-mem_cgroup_uncharge_swap.patch

