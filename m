From: akpm@linux-foundation.org
Subject: - simplify-cpu_hotplug_begin-put_online_cpus.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:43:30 -0700
Message-ID: <200804300543.m3U5hUjo029323@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48676 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755664AbYD3For (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:44:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, dipankar@in.ibm.com, ego@in.ibm.com, mingo@elte.hu, vatsa@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     simplify cpu_hotplug_begin()/put_online_cpus()
has been removed from the -mm tree.  Its filename was
     simplify-cpu_hotplug_begin-put_online_cpus.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: simplify cpu_hotplug_begin()/put_online_cpus()
From: Oleg Nesterov <oleg@tv-sign.ru>

cpu_hotplug_begin() must be always called under cpu_add_remove_lock, this
means that only one process can be cpu_hotplug.active_writer.  So we don't
need the cpu_hotplug.writer_queue, we can wake up the ->active_writer
directly.

Also, fix the comment.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Acked-by: Gautham R Shenoy <ego@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpu.c |   30 ++++++++++--------------------
 1 file changed, 10 insertions(+), 20 deletions(-)

diff -puN kernel/cpu.c~simplify-cpu_hotplug_begin-put_online_cpus kernel/cpu.c
--- a/kernel/cpu.c~simplify-cpu_hotplug_begin-put_online_cpus
+++ a/kernel/cpu.c
@@ -33,17 +33,13 @@ static struct {
 	 * an ongoing cpu hotplug operation.
 	 */
 	int refcount;
-	wait_queue_head_t writer_queue;
 } cpu_hotplug;
 
-#define writer_exists() (cpu_hotplug.active_writer != NULL)
-
 void __init cpu_hotplug_init(void)
 {
 	cpu_hotplug.active_writer = NULL;
 	mutex_init(&cpu_hotplug.lock);
 	cpu_hotplug.refcount = 0;
-	init_waitqueue_head(&cpu_hotplug.writer_queue);
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
@@ -65,11 +61,8 @@ void put_online_cpus(void)
 	if (cpu_hotplug.active_writer == current)
 		return;
 	mutex_lock(&cpu_hotplug.lock);
-	cpu_hotplug.refcount--;
-
-	if (unlikely(writer_exists()) && !cpu_hotplug.refcount)
-		wake_up(&cpu_hotplug.writer_queue);
-
+	if (!--cpu_hotplug.refcount && unlikely(cpu_hotplug.active_writer))
+		wake_up_process(cpu_hotplug.active_writer);
 	mutex_unlock(&cpu_hotplug.lock);
 
 }
@@ -98,8 +91,8 @@ void cpu_maps_update_done(void)
  * Note that during a cpu-hotplug operation, the new readers, if any,
  * will be blocked by the cpu_hotplug.lock
  *
- * Since cpu_maps_update_begin is always called after invoking
- * cpu_maps_update_begin, we can be sure that only one writer is active.
+ * Since cpu_hotplug_begin() is always called after invoking
+ * cpu_maps_update_begin(), we can be sure that only one writer is active.
  *
  * Note that theoretically, there is a possibility of a livelock:
  * - Refcount goes to zero, last reader wakes up the sleeping
@@ -115,19 +108,16 @@ void cpu_maps_update_done(void)
  */
 static void cpu_hotplug_begin(void)
 {
-	DECLARE_WAITQUEUE(wait, current);
-
-	mutex_lock(&cpu_hotplug.lock);
-
 	cpu_hotplug.active_writer = current;
-	add_wait_queue_exclusive(&cpu_hotplug.writer_queue, &wait);
-	while (cpu_hotplug.refcount) {
-		set_current_state(TASK_UNINTERRUPTIBLE);
+
+	for (;;) {
+		mutex_lock(&cpu_hotplug.lock);
+		if (likely(!cpu_hotplug.refcount))
+			break;
+		__set_current_state(TASK_UNINTERRUPTIBLE);
 		mutex_unlock(&cpu_hotplug.lock);
 		schedule();
-		mutex_lock(&cpu_hotplug.lock);
 	}
-	remove_wait_queue_locked(&cpu_hotplug.writer_queue, &wait);
 }
 
 static void cpu_hotplug_done(void)
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

