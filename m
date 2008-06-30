From: akpm@linux-foundation.org
Subject: + workqueues-make-get_online_cpus-useable-for-work-func.patch added to -mm tree
Date: Mon, 30 Jun 2008 16:46:28 -0700
Message-ID: <200806302346.m5UNkToS031674@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54897 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754425AbYF3XsJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jun 2008 19:48:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, ego@in.ibm.com, heiko.carstens@de.ibm.com, maxk@qualcomm.com, menage@google.com, mingo@elte.hu, peterz@infradead.org, pj@sgi.com, schwidefsky@de.ibm.com, vegard.nossum@gmail.com


The patch titled
     workqueues: make get_online_cpus() useable for work->func()
has been added to the -mm tree.  Its filename is
     workqueues-make-get_online_cpus-useable-for-work-func.patch

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
Subject: workqueues: make get_online_cpus() useable for work->func()
From: Oleg Nesterov <oleg@tv-sign.ru>

workqueue_cpu_callback(CPU_DEAD) flushes cwq->thread under
cpu_maps_update_begin().  This means that the multithreaded workqueues
can't use get_online_cpus() due to the possible deadlock, very bad and
very old problem.

Introduce the new state, CPU_POST_DEAD, which is called after
cpu_hotplug_done() but before cpu_maps_update_done().

Change workqueue_cpu_callback() to use CPU_POST_DEAD instead of CPU_DEAD. 
This means that create/destroy functions can't rely on get_online_cpus()
any longer and should take cpu_add_remove_lock instead.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Paul Menage <menage@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/notifier.h |    2 ++
 kernel/cpu.c             |    5 +++++
 kernel/workqueue.c       |   18 +++++++++---------
 3 files changed, 16 insertions(+), 9 deletions(-)

diff -puN include/linux/notifier.h~workqueues-make-get_online_cpus-useable-for-work-func include/linux/notifier.h
--- a/include/linux/notifier.h~workqueues-make-get_online_cpus-useable-for-work-func
+++ a/include/linux/notifier.h
@@ -214,6 +214,8 @@ static inline int notifier_to_errno(int 
 #define CPU_DEAD		0x0007 /* CPU (unsigned)v dead */
 #define CPU_DYING		0x0008 /* CPU (unsigned)v not running any task,
 				        * not handling interrupts, soon dead */
+#define CPU_POST_DEAD		0x0009 /* CPU (unsigned)v dead, cpu_hotplug
+					* lock is dropped */
 
 /* Used for CPU hotplug events occuring while tasks are frozen due to a suspend
  * operation in progress
diff -puN kernel/cpu.c~workqueues-make-get_online_cpus-useable-for-work-func kernel/cpu.c
--- a/kernel/cpu.c~workqueues-make-get_online_cpus-useable-for-work-func
+++ a/kernel/cpu.c
@@ -277,6 +277,11 @@ out_allowed:
 	set_cpus_allowed_ptr(current, &old_allowed);
 out_release:
 	cpu_hotplug_done();
+	if (!err) {
+		if (raw_notifier_call_chain(&cpu_chain, CPU_POST_DEAD | mod,
+					    hcpu) == NOTIFY_BAD)
+			BUG();
+	}
 	return err;
 }
 
diff -puN kernel/workqueue.c~workqueues-make-get_online_cpus-useable-for-work-func kernel/workqueue.c
--- a/kernel/workqueue.c~workqueues-make-get_online_cpus-useable-for-work-func
+++ a/kernel/workqueue.c
@@ -791,7 +791,7 @@ struct workqueue_struct *__create_workqu
 		err = create_workqueue_thread(cwq, singlethread_cpu);
 		start_workqueue_thread(cwq, -1);
 	} else {
-		get_online_cpus();
+		cpu_maps_update_begin();
 		spin_lock(&workqueue_lock);
 		list_add(&wq->list, &workqueues);
 		spin_unlock(&workqueue_lock);
@@ -803,7 +803,7 @@ struct workqueue_struct *__create_workqu
 			err = create_workqueue_thread(cwq, cpu);
 			start_workqueue_thread(cwq, cpu);
 		}
-		put_online_cpus();
+		cpu_maps_update_done();
 	}
 
 	if (err) {
@@ -817,8 +817,8 @@ EXPORT_SYMBOL_GPL(__create_workqueue_key
 static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq)
 {
 	/*
-	 * Our caller is either destroy_workqueue() or CPU_DEAD,
-	 * get_online_cpus() protects cwq->thread.
+	 * Our caller is either destroy_workqueue() or CPU_POST_DEAD,
+	 * cpu_add_remove_lock protects cwq->thread.
 	 */
 	if (cwq->thread == NULL)
 		return;
@@ -828,7 +828,7 @@ static void cleanup_workqueue_thread(str
 
 	flush_cpu_workqueue(cwq);
 	/*
-	 * If the caller is CPU_DEAD and cwq->worklist was not empty,
+	 * If the caller is CPU_POST_DEAD and cwq->worklist was not empty,
 	 * a concurrent flush_workqueue() can insert a barrier after us.
 	 * However, in that case run_workqueue() won't return and check
 	 * kthread_should_stop() until it flushes all work_struct's.
@@ -852,14 +852,14 @@ void destroy_workqueue(struct workqueue_
 	const cpumask_t *cpu_map = wq_cpu_map(wq);
 	int cpu;
 
-	get_online_cpus();
+	cpu_maps_update_begin();
 	spin_lock(&workqueue_lock);
 	list_del(&wq->list);
 	spin_unlock(&workqueue_lock);
 
 	for_each_cpu_mask_nr(cpu, *cpu_map)
 		cleanup_workqueue_thread(per_cpu_ptr(wq->cpu_wq, cpu));
-	put_online_cpus();
+ 	cpu_maps_update_done();
 
 	free_percpu(wq->cpu_wq);
 	kfree(wq);
@@ -898,7 +898,7 @@ static int __devinit workqueue_cpu_callb
 
 		case CPU_UP_CANCELED:
 			start_workqueue_thread(cwq, -1);
-		case CPU_DEAD:
+		case CPU_POST_DEAD:
 			cleanup_workqueue_thread(cwq);
 			break;
 		}
@@ -906,7 +906,7 @@ static int __devinit workqueue_cpu_callb
 
 	switch (action) {
 	case CPU_UP_CANCELED:
-	case CPU_DEAD:
+	case CPU_POST_DEAD:
 		cpu_clear(cpu, cpu_populated_map);
 	}
 
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

get_user_pages-fix-possible-page-leak-on-oom.patch
migrate_timers-add-comment-use-spinlock_irq.patch
posix-timers-timer_delete-remove-the-bogus-it_process-=-null-check.patch
posix-timers-release_posix_timer-kill-the-bogus-put_task_struct-it_process.patch
signals-collect_signal-remove-the-unneeded-sigismember-check.patch
signals-collect_signal-simplify-the-still_pending-logic.patch
signals-change-collect_signal-to-return-void.patch
__exit_signal-dont-take-rcu-lock.patch
signals-dequeue_signal-dont-check-signal_group_exit-when-setting-signal_stop_dequeued.patch
signals-do_signal_stop-kill-the-signal_unkillable-check.patch
coredump-zap_threads-comments-use-while_each_thread.patch
signals-make-siginfo_t-si_utime-si_sstime-report-times-in-user_hz-not-hz.patch
kernel-signalc-change-vars-pid-and-tgid-types-to-pid_t.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
ptrace-give-more-respect-to-sigkill.patch
ptrace-never-sleep-in-task_traced-if-sigkilled.patch
ptrace-kill-may_ptrace_stop.patch
introduce-pf_kthread-flag.patch
kill-pf_borrowed_mm-in-favour-of-pf_kthread.patch
coredump-zap_threads-must-skip-kernel-threads.patch
coredump-elf_core_dump-skip-kernel-threads.patch
workqueues-insert_work-use-list_head-instead-of-int-tail.patch
workqueues-implement-flush_work.patch
workqueues-schedule_on_each_cpu-use-flush_work.patch
workqueues-make-get_online_cpus-useable-for-work-func.patch
s390-topology-dont-use-kthread-for-arch_reinit_sched_domains.patch
pidns-remove-now-unused-kill_proc-function.patch
pidns-remove-now-unused-find_pid-function.patch
pidns-remove-find_task_by_pid-unused-for-a-long-time.patch
distinct-tgid-tid-i-o-statistics.patch

