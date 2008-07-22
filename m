From: akpm@linux-foundation.org
Subject: + workqueues-do-cpu_up_canceled-if-cpu_up_prepare-fails.patch added to -mm tree
Date: Tue, 22 Jul 2008 03:29:25 -0700
Message-ID: <200807221029.m6MATPB9023367@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55752 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752712AbYGVK3i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jul 2008 06:29:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, akinobu.mita@gmail.com


The patch titled
     workqueues: do CPU_UP_CANCELED if CPU_UP_PREPARE fails
has been added to the -mm tree.  Its filename is
     workqueues-do-cpu_up_canceled-if-cpu_up_prepare-fails.patch

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
Subject: workqueues: do CPU_UP_CANCELED if CPU_UP_PREPARE fails
From: Oleg Nesterov <oleg@tv-sign.ru>

The bug was pointed out by Akinobu Mita <akinobu.mita@gmail.com>, and this
patch is based on his original patch.

workqueue_cpu_callback(CPU_UP_PREPARE) expects that if it returns
NOTIFY_BAD, _cpu_up() will send CPU_UP_CANCELED then.

However, this is not true since

	"cpu hotplug: cpu: deliver CPU_UP_CANCELED only to NOTIFY_OKed callbacks with CPU_UP_PREPARE"
	commit: a0d8cdb652d35af9319a9e0fb7134de2a276c636

The callback which has returned NOTIFY_BAD will not receive
CPU_UP_CANCELED.  Change the code to fulfil the CPU_UP_CANCELED logic if
CPU_UP_PREPARE fails.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Reported-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN kernel/workqueue.c~workqueues-do-cpu_up_canceled-if-cpu_up_prepare-fails kernel/workqueue.c
--- a/kernel/workqueue.c~workqueues-do-cpu_up_canceled-if-cpu_up_prepare-fails
+++ a/kernel/workqueue.c
@@ -911,6 +911,7 @@ static int __devinit workqueue_cpu_callb
 	unsigned int cpu = (unsigned long)hcpu;
 	struct cpu_workqueue_struct *cwq;
 	struct workqueue_struct *wq;
+	int ret = NOTIFY_OK;
 
 	action &= ~CPU_TASKS_FROZEN;
 
@@ -918,7 +919,7 @@ static int __devinit workqueue_cpu_callb
 	case CPU_UP_PREPARE:
 		cpu_set(cpu, cpu_populated_map);
 	}
-
+undo:
 	list_for_each_entry(wq, &workqueues, list) {
 		cwq = per_cpu_ptr(wq->cpu_wq, cpu);
 
@@ -928,7 +929,9 @@ static int __devinit workqueue_cpu_callb
 				break;
 			printk(KERN_ERR "workqueue [%s] for %i failed\n",
 				wq->name, cpu);
-			return NOTIFY_BAD;
+			action = CPU_UP_CANCELED;
+			ret = NOTIFY_BAD;
+			goto undo;
 
 		case CPU_ONLINE:
 			start_workqueue_thread(cwq, cpu);
@@ -948,7 +951,7 @@ static int __devinit workqueue_cpu_callb
 		cpu_clear(cpu, cpu_populated_map);
 	}
 
-	return NOTIFY_OK;
+	return ret;
 }
 
 void __init init_workqueues(void)
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
linux-next.patch
migrate_timers-add-comment-use-spinlock_irq.patch
pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on.patch
pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on-cleanup.patch
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
signals-introduce-kill_pid_ns_info.patch
signals-introduce-kill_pid_ns_info-checkpatch-fixes.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
ptrace-give-more-respect-to-sigkill.patch
ptrace-simplify-ptrace_stop-sigkill_pending-path.patch
introduce-pf_kthread-flag.patch
kill-pf_borrowed_mm-in-favour-of-pf_kthread.patch
coredump-zap_threads-must-skip-kernel-threads.patch
coredump-elf_core_dump-skip-kernel-threads.patch
coredump-turn-mm-core_startup_done-into-the-pointer-to-struct-core_state.patch
coredump-move-mm-core_waiters-into-struct-core_state.patch
coredump-simplify-core_state-nr_threads-calculation.patch
coredump-turn-core_state-nr_threads-into-atomic_t.patch
coredump-make-mm-core_state-visible-to-core_dump.patch
coredump-construct-the-list-of-coredumping-threads-at-startup-time.patch
coredump-elf_core_dump-use-core_state-dumper-list.patch
coredump-elf_fdpic_core_dump-use-core_state-dumper-list.patch
coredump-kill-mm-core_done.patch
coredump-format_corename-fix-the-core_uses_pid-logic.patch
coredump-format_corename-fix-the-core_uses_pid-logic-checkpatch-fixes.patch
workqueues-insert_work-use-list_head-instead-of-int-tail.patch
workqueues-implement-flush_work.patch
workqueues-schedule_on_each_cpu-use-flush_work.patch
workqueues-make-get_online_cpus-useable-for-work-func.patch
workqueues-make-get_online_cpus-useable-for-work-func-fix.patch
s390-topology-dont-use-kthread-for-arch_reinit_sched_domains.patch
workqueues-lockdep-annotations-for-flush_work.patch
workqueues-queue_work-can-use-queue_work_on.patch
workqueues-schedule_on_each_cpu-can-use-schedule_work_on.patch
workqueues-do-cpu_up_canceled-if-cpu_up_prepare-fails.patch
pidns-remove-now-unused-kill_proc-function.patch
pidns-remove-now-unused-find_pid-function.patch
pidns-remove-find_task_by_pid-unused-for-a-long-time.patch
distinct-tgid-tid-i-o-statistics.patch
tracehook-add-linux-tracehookh.patch
tracehook-exec.patch
tracehook-unexport-ptrace_notify.patch
tracehook-exit.patch
tracehook-clone.patch
tracehook-vfork-done.patch
tracehook-release_task.patch
tracehook-tracehook_tracer_task.patch
tracehook-tracehook_expect_breakpoints.patch
tracehook-tracehook_signal_handler.patch
tracehook-tracehook_consider_ignored_signal.patch
tracehook-tracehook_consider_fatal_signal.patch
tracehook-syscall.patch
tracehook-get_signal_to_deliver.patch
tracehook-job-control.patch
tracehook-death.patch
tracehook-force-signal_pending.patch
tracehook-tif_notify_resume.patch
tracehook-asm-syscallh.patch
tracehook-config_have_arch_tracehook.patch
tracehook-wait_task_inactive.patch
task_current_syscall.patch
proc-pid-syscall.patch

