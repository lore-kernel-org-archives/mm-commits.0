From: akpm@linux-foundation.org
Subject: - workqueues-shrink-cpu_populated_map-when-cpu-dies.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:43:26 -0700
Message-ID: <200804300543.m3U5hQIX029317@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54723 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758260AbYD3FoD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:44:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     workqueues: shrink cpu_populated_map when CPU dies
has been removed from the -mm tree.  Its filename was
     workqueues-shrink-cpu_populated_map-when-cpu-dies.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: workqueues: shrink cpu_populated_map when CPU dies
From: Oleg Nesterov <oleg@tv-sign.ru>

When cpu_populated_map was introduced, it was supposed that cwq->thread can
survive after CPU_DEAD, that is why we never shrink cpu_populated_map.

This is not very nice, we can safely remove the already dead CPU from the map.
 The only required change is that destroy_workqueue() must hold the hotplug
lock until it destroys all cwq->thread's, to protect the cpu_populated_map. 
We could make the local copy of cpu mask and drop the lock, but
sizeof(cpumask_t) may be very large.

Also, fix the comment near queue_work().  Unless _cpu_down() happens we do
guarantee the cpu-affinity of the work_struct, and we have users which rely on
this.

[akpm@linux-foundation.org: repair comment]
Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff -puN kernel/workqueue.c~workqueues-shrink-cpu_populated_map-when-cpu-dies kernel/workqueue.c
--- a/kernel/workqueue.c~workqueues-shrink-cpu_populated_map-when-cpu-dies
+++ a/kernel/workqueue.c
@@ -158,8 +158,8 @@ static void __queue_work(struct cpu_work
  *
  * Returns 0 if @work was already on a queue, non-zero otherwise.
  *
- * We queue the work to the CPU it was submitted, but there is no
- * guarantee that it will be processed by that CPU.
+ * We queue the work to the CPU on which it was submitted, but if the CPU dies
+ * it can be processed by another CPU.
  */
 int queue_work(struct workqueue_struct *wq, struct work_struct *work)
 {
@@ -815,12 +815,12 @@ void destroy_workqueue(struct workqueue_
 	spin_lock(&workqueue_lock);
 	list_del(&wq->list);
 	spin_unlock(&workqueue_lock);
-	put_online_cpus();
 
 	for_each_cpu_mask(cpu, *cpu_map) {
 		cwq = per_cpu_ptr(wq->cpu_wq, cpu);
 		cleanup_workqueue_thread(cwq, cpu);
 	}
+	put_online_cpus();
 
 	free_percpu(wq->cpu_wq);
 	kfree(wq);
@@ -838,7 +838,6 @@ static int __devinit workqueue_cpu_callb
 	action &= ~CPU_TASKS_FROZEN;
 
 	switch (action) {
-
 	case CPU_UP_PREPARE:
 		cpu_set(cpu, cpu_populated_map);
 	}
@@ -866,6 +865,12 @@ static int __devinit workqueue_cpu_callb
 		}
 	}
 
+	switch (action) {
+	case CPU_UP_CANCELED:
+	case CPU_DEAD:
+		cpu_clear(cpu, cpu_populated_map);
+	}
+
 	return NOTIFY_OK;
 }
 
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
git-s390.patch
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
consolidate-checking-for-ignored-legacy-signals-simplify.patch
signals-do_signal_stop-use-signal_group_exit.patch
signals-do_group_exit-use-signal_group_exit-more-consistently.patch
lock_task_sighand-add-rcu-lock-unlock.patch
k_getrusage-dont-take-rcu_read_lock.patch
do_task_stat-dont-take-rcu_read_lock.patch
signals-consolidate-checks-for-whether-or-not-to-ignore-a-signal.patch
signals-clean-dequeue_signal-from-excess-checks-and-assignments.patch
signals-consolidate-send_sigqueue-and-send_group_sigqueue.patch
signals-cleanup-security_task_kill-usage-implementation.patch
signals-re-assign-cld_continued-notification-from-the-sender-to-reciever.patch
kill_pid_info-dont-take-now-unneeded-tasklist_lock.patch
handle_stop_signal-unify-partial-full-stop-handling.patch
handle_stop_signal-use-the-cached-p-signal-value.patch
get_signal_to_deliver-use-the-cached-signal-sighand-values.patch
signals-send_sigqueue-dont-take-rcu-lock.patch
signals-send_sigqueue-dont-forget-about-handle_stop_signal.patch
signals-__group_complete_signal-cache-the-value-of-p-signal.patch
signals-send_group_sigqueue-dont-take-tasklist_lock.patch
signals-move-handle_stop_signal-into-send_signal.patch
signals-do_tkill-dont-use-tasklist_lock.patch
signals-do_tkill-dont-use-tasklist_lock-comment.patch
signals-send_sig_info-dont-take-tasklist_lock.patch
signals-microoptimize-the-usage-of-curr_target.patch
signals-move-the-definition-of-__group_complete_signal-up.patch
signals-change-send_signal-do_send_sigqueue-to-take-boolean-group-parameter.patch
signals-use-__group_complete_signal-for-the-specific-signals-too.patch
signals-fold-complete_signal-into-send_signal-do_send_sigqueue.patch
signals-unify-send_sigqueue-send_group_sigqueue-completely.patch
signals-join-send_sigqueue-with-send_group_sigqueue.patch
signals-handle_stop_signal-dont-worry-about-sigkill.patch
signals-cleanup-the-usage-of-print_fatal_signal.patch
signals-fold-sig_ignored-into-handle_stop_signal.patch
signals-fold-sig_ignored-into-handle_stop_signal-comment.patch
signals-document-cld_continued-notification-mechanics.patch
signals-document-cld_continued-notification-mechanics-more.patch
signals-send_signal-be-paranoid-about-signalfd_notify.patch
signals-check_kill_permission-check-session-under-tasklist_lock.patch
signals-check_kill_permission-remove-tasklist_lock.patch
signals-fix-sbin-init-protection-from-unwanted-signals.patch
signals-de_thread-simplify-the-child_reaper-switching.patch
signals-allow-the-kernel-to-actually-kill-sbin-init.patch
signals-add-set_restore_sigmask.patch
signals-set_restore_sigmask-tif_sigpending.patch
signals-s390-renumber-tif_restore_sigmask.patch
signals-ia64-renumber-tif_restore_sigmask.patch
signals-use-have_set_restore_sigmask.patch
signals-x86-ts_restore_sigmask.patch
posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed.patch
ptrace-introduce-task_detached-helper.patch
reparent_thread-use-same_thread_group.patch
document-de_thread-with-exit_notify-connection.patch
ptrace-introduce-ptrace_reparented-helper.patch
ptrace-__ptrace_unlink-use-the-ptrace_reparented-helper.patch
ptrace-ptrace_attach-use-send_sig_info-instead-force_sig_specific.patch
ptrace-allow-to-ptrace-sbin-init.patch
workqueue-remove-redundant-function-invocation.patch
redo-locking-of-tty-pgrp.patch
resume-tty-on-susp-and-fix-crnl-order-in-n_tty-line-discipline.patch
tty_io-fix-remaining-pid-struct-locking.patch
tty_io-fix-remaining-pid-struct-locking-small-cleanup.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
pids-de_thread-dont-clear-session-pgrp-pids-for-the-old-leader.patch
pids-introduce-change_pid-helper.patch
pids-sys_setpgid-use-change_pid-helper.patch
pids-__set_special_pids-use-change_pid-helper.patch
pids-sys_getsid-fix-unsafe-pid-usage-fix-possible-0-instead-of-esrch.patch
pids-sys_getpgid-fix-unsafe-pid-usage-s-tasklist-rcu.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

