From: akpm@linux-foundation.org
Subject: + exec-rt-sub-thread-can-livelock-and-monopolize-cpu-on-exec.patch added to -mm tree
Date: Mon, 20 Aug 2007 13:58:52 -0700
Message-ID: <200708202058.l7KKwqWt022981@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52445 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752104AbXHTU7t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 16:59:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com


The patch titled
     exec: RT sub-thread can livelock and monopolize CPU on exec
has been added to the -mm tree.  Its filename is
     exec-rt-sub-thread-can-livelock-and-monopolize-cpu-on-exec.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: exec: RT sub-thread can livelock and monopolize CPU on exec
From: Oleg Nesterov <oleg@tv-sign.ru>

de_thread() yields waiting for ->group_leader to be a zombie. This deadlocks
if an rt-prio execer shares the same cpu with ->group_leader. Change the code
to use ->group_exit_task/notify_count mechanics.

This patch certainly uglifies the code, perhaps someone can suggest something
better.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c     |   28 +++++++++++++++-------------
 kernel/exit.c |   10 +++++++---
 2 files changed, 22 insertions(+), 16 deletions(-)

diff -puN fs/exec.c~exec-rt-sub-thread-can-livelock-and-monopolize-cpu-on-exec fs/exec.c
--- a/fs/exec.c~exec-rt-sub-thread-can-livelock-and-monopolize-cpu-on-exec
+++ a/fs/exec.c
@@ -801,16 +801,15 @@ static int de_thread(struct task_struct 
 			hrtimer_restart(&sig->real_timer);
 		spin_lock_irq(lock);
 	}
+
+	sig->notify_count = count;
+	sig->group_exit_task = tsk;
 	while (atomic_read(&sig->count) > count) {
-		sig->group_exit_task = tsk;
-		sig->notify_count = count;
 		__set_current_state(TASK_UNINTERRUPTIBLE);
 		spin_unlock_irq(lock);
 		schedule();
 		spin_lock_irq(lock);
 	}
-	sig->group_exit_task = NULL;
-	sig->notify_count = 0;
 	spin_unlock_irq(lock);
 
 	/*
@@ -819,14 +818,17 @@ static int de_thread(struct task_struct 
 	 * and to assume its PID:
 	 */
 	if (!thread_group_leader(tsk)) {
-		/*
-		 * Wait for the thread group leader to be a zombie.
-		 * It should already be zombie at this point, most
-		 * of the time.
-		 */
 		leader = tsk->group_leader;
-		while (leader->exit_state != EXIT_ZOMBIE)
-			yield();
+
+		sig->notify_count = -1;
+		for (;;) {
+			write_lock_irq(&tasklist_lock);
+			if (likely(leader->exit_state))
+				break;
+			__set_current_state(TASK_UNINTERRUPTIBLE);
+			write_unlock_irq(&tasklist_lock);
+			schedule();
+		}
 
 		/*
 		 * The only record we have of the real-time age of a
@@ -840,8 +842,6 @@ static int de_thread(struct task_struct 
 		 */
 		tsk->start_time = leader->start_time;
 
-		write_lock_irq(&tasklist_lock);
-
 		BUG_ON(leader->tgid != tsk->tgid);
 		BUG_ON(tsk->pid == tsk->tgid);
 		/*
@@ -874,6 +874,8 @@ static int de_thread(struct task_struct 
 		write_unlock_irq(&tasklist_lock);
         }
 
+	sig->group_exit_task = NULL;
+	sig->notify_count = 0;
 	/*
 	 * There may be one thread left which is just exiting,
 	 * but it's safe to stop telling the group to kill themselves.
diff -puN kernel/exit.c~exec-rt-sub-thread-can-livelock-and-monopolize-cpu-on-exec kernel/exit.c
--- a/kernel/exit.c~exec-rt-sub-thread-can-livelock-and-monopolize-cpu-on-exec
+++ a/kernel/exit.c
@@ -101,10 +101,9 @@ static void __exit_signal(struct task_st
 		 * If there is any task waiting for the group exit
 		 * then notify it:
 		 */
-		if (sig->group_exit_task && atomic_read(&sig->count) == sig->notify_count) {
+		if (sig->group_exit_task && atomic_read(&sig->count) == sig->notify_count)
 			wake_up_process(sig->group_exit_task);
-			sig->group_exit_task = NULL;
-		}
+
 		if (tsk == sig->curr_target)
 			sig->curr_target = next_thread(tsk);
 		/*
@@ -835,6 +834,11 @@ static void exit_notify(struct task_stru
 		state = EXIT_DEAD;
 	tsk->exit_state = state;
 
+	if (thread_group_leader(tsk) &&
+	    tsk->signal->notify_count < 0 &&
+	    tsk->signal->group_exit_task)
+		wake_up_process(tsk->signal->group_exit_task);
+
 	write_unlock_irq(&tasklist_lock);
 
 	list_for_each_safe(_p, _n, &ptrace_dead) {
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
posix-timers-fix-creation-race.patch
signalfd-fix-interaction-with-posix-timers.patch
signalfd-make-it-group-wide-fix-posix-timers-scheduling.patch
exec-kill-unsafe-bug_onsig-count-checks.patch
git-dvb.patch
rt-ptracer-can-monopolize-cpu-was-cpu-hotplug-and-real-time.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
do_sys_poll-simplify-playing-with-on-stack-data.patch
do_sys_poll-simplify-playing-with-on-stack-data-fix.patch
do_poll-return-eintr-when-signalled.patch
pi-futex-set-pf_exiting-without-taking-pi_lock.patch
do_sigaction-remove-now-unneeded-recalc_sigpending.patch
handle-the-multi-threaded-inits-exit-properly.patch
wait_task_zombie-remove-unneeded-child-signal-check.patch
wait_task_zombie-fix-2-3-races-vs-forget_original_parent.patch
exit_notify-dont-take-tasklist-for-tif_sigpending-re-targeting.patch
zap_other_threads-dont-optimize-thread_group_empty-case.patch
wait_task_zombie-dont-fight-with-non-existing-race-with-a-dying-ptracee.patch
__group_complete_signal-eliminate-unneeded-wakeup-of-group_exit_task.patch
use-erestart_restartblock-if-poll-is-interrupted-by-a-signal.patch
exec-simplify-sighand-switching.patch
exec-simplify-the-new-sighand-allocation.patch
exec-consolidate-2-fast-paths.patch
exec-rt-sub-thread-can-livelock-and-monopolize-cpu-on-exec.patch
cpu-hotplug-slab-cleanup-cpuup_callback.patch
cpu-hotplug-slab-fix-memory-leak-in-cpu-hotplug-error-path.patch
cpu-hotplug-cpu-deliver-cpu_up_canceled-only-to-notify_oked-callbacks-with-cpu_up_prepare.patch
cpu-hotplug-topology-remove-topology_dev_map.patch
cpu-hotplug-thermal_throttle-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-msr-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-cpuid-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-mce-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling-fix-a-section-mismatch-warning.patch
make-access-to-tasks-nsproxy-lighter.patch
workqueue-debug-flushing-deadlocks-with-lockdep.patch
workqueue-debug-work-related-deadlocks-with-lockdep.patch
pid-namespaces-rework-forget_original_parent.patch
pid-namespaces-move-exit_task_namespaces.patch
pid-namespaces-introduce-ms_kernmount-flag.patch
pid-namespaces-prepare-proc_flust_task-to-flush-entries-from-multiple-proc-trees.patch
pid-namespaces-introduce-struct-upid.patch
pid-namespaces-add-support-for-pid-namespaces-hierarchy.patch
pid-namespaces-make-alloc_pid-free_pid-and-put_pid-work-with-struct-upid.patch
pid-namespaces-helpers-to-obtain-pid-numbers.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids.patch
pid-namespaces-move-alloc_pid-lower-in-copy_process.patch
pid-namespaces-make-proc-have-multiple-superblocks-one-for-each-namespace.patch
pid-namespaces-miscelaneous-preparations-for-pid-namespaces.patch
pid-namespaces-allow-cloning-of-new-namespace.patch
pid-namespaces-allow-cloning-of-new-namespace-fix-check-for-return-value-of-create_pid_namespace.patch
pid-namespaces-make-proc_flush_task-actually-from-entries-from-multiple-namespaces.patch
pid-namespaces-initialize-the-namespaces-proc_mnt.patch
pid-namespaces-create-a-slab-cache-for-struct-pid_namespace.patch
pid-namespaces-allow-signalling-container-init.patch
pid-namespaces-destroy-pid-namespace-on-inits-death.patch
pid-namespaces-changes-to-show-virtual-ids-to-user.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix-the-return-value-of-sys_set_tid_address.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual.patch
pid-namespaces-remove-the-struct-pid-unneeded-fields.patch
isolate-some-explicit-usage-of-task-tgid.patch
