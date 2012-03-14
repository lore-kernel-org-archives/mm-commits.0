From: akpm@linux-foundation.org
Subject: + watchdog-make-sure-the-watchdog-thread-gets-cpu-on-loaded-system.patch added to -mm tree
Date: Wed, 14 Mar 2012 16:21:06 -0700
Message-ID: <20120314232107.27CB4A0517@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:52885 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560Ab2CNXVI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Mar 2012 19:21:08 -0400
Received: by ggnd2 with SMTP id d2so419766ggn.1
        for <mm-commits@vger.kernel.org>; Wed, 14 Mar 2012 16:21:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, a.p.zijlstra@chello.nl, dzickus@redhat.com, mingo@elte.hu, msb@chromium.org


The patch titled
     Subject: watchdog: Make sure the watchdog thread gets CPU on loaded system
has been added to the -mm tree.  Its filename is
     watchdog-make-sure-the-watchdog-thread-gets-cpu-on-loaded-system.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: watchdog: Make sure the watchdog thread gets CPU on loaded system

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
Subject: Subject: watchdog: Make sure the watchdog thread gets CPU on loaded system

Patches currently in -mm which might be from mhocko@suse.cz are

linux-next.patch
mm-oom-avoid-looping-when-chosen-thread-detaches-its-mm.patch
mm-oom-fold-oom_kill_task-into-oom_kill_process.patch
mm-oom-do-not-emit-oom-killer-warning-if-chosen-thread-is-already-exiting.patch
mm-vmscan-fix-misused-nr_reclaimed-in-shrink_mem_cgroup_zone.patch
hugetlbfs-fix-hugetlb_get_unmapped_area.patch
hugetlb-try-to-search-again-if-it-is-really-needed.patch
hugetlb-try-to-search-again-if-it-is-really-needed-fix.patch
mm-do-not-reset-cached_hole_size-when-vma-is-unmapped.patch
mm-search-from-free_area_cache-for-the-bigger-size.patch
mm-hugetlb-defer-freeing-pages-when-gathering-surplus-pages.patch
mm-hugetlb-bail-out-unmapping-after-serving-reference-page.patch
mm-hugetlb-cleanup-duplicated-code-in-unmapping-vm-range.patch
mm-memcg-pass-charge-order-to-oom-killer.patch
memcg-replace-mem_cont-by-mem_res_ctlr.patch
memcg-replace-mem-and-mem_cont-stragglers.patch
memcg-lru_size-instead-of-mem_cgroup_zstat.patch
memcg-enum-lru_list-lru.patch
memcg-remove-redundant-returns.patch
memcg-remove-unnecessary-thp-check-in-page-stat-accounting.patch
memcg-remove-pcg_cache-page_cgroup-flag.patch
memcg-remove-export_symbolmem_cgroup_update_page_stat.patch
memcg-simplify-move_account-check.patch
memcg-remove-pcg_move_lock-flag-from-page_cgroup.patch
memcg-use-new-logic-for-page-stat-accounting.patch
memcg-use-new-logic-for-page-stat-accounting-fix-2.patch
memcg-remove-pcg_file_mapped.patch
memcg-remove-pcg_file_mapped-fix.patch
memcg-fix-performance-of-mem_cgroup_begin_update_page_stat.patch
memcg-fix-performance-of-mem_cgroup_begin_update_page_stat-fix.patch
watchdog-make-sure-the-watchdog-thread-gets-cpu-on-loaded-system.patch

