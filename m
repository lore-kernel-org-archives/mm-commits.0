From: akpm@linux-foundation.org
Subject: + signals-de_thread-simplify-the-child_reaper-switching.patch added to -mm tree
Date: Mon, 24 Mar 2008 15:24:14 -0700
Message-ID: <200803242224.m2OMOEv0028418@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44328 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753326AbYCXWZ0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Mar 2008 18:25:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com


The patch titled
     signals: de_thread: simplify the ->child_reaper switching
has been added to the -mm tree.  Its filename is
     signals-de_thread-simplify-the-child_reaper-switching.patch

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
Subject: signals: de_thread: simplify the ->child_reaper switching
From: Oleg Nesterov <oleg@tv-sign.ru>

Now that we rely on SIGNAL_UNKILLABLE flag, de_thread() doesn't need the nasty
hack to kill the old ->child_reaper during the mt-exec.

This also means we can avoid taking tasklist_lock around zap_other_threads().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff -puN fs/exec.c~signals-de_thread-simplify-the-child_reaper-switching fs/exec.c
--- a/fs/exec.c~signals-de_thread-simplify-the-child_reaper-switching
+++ a/fs/exec.c
@@ -765,9 +765,7 @@ static int de_thread(struct task_struct 
 
 	/*
 	 * Kill all other threads in the thread group.
-	 * We must hold tasklist_lock to call zap_other_threads.
 	 */
-	read_lock(&tasklist_lock);
 	spin_lock_irq(lock);
 	if (signal_group_exit(sig)) {
 		/*
@@ -775,21 +773,10 @@ static int de_thread(struct task_struct 
 		 * return so that the signal is processed.
 		 */
 		spin_unlock_irq(lock);
-		read_unlock(&tasklist_lock);
 		return -EAGAIN;
 	}
-
-	/*
-	 * child_reaper ignores SIGKILL, change it now.
-	 * Reparenting needs write_lock on tasklist_lock,
-	 * so it is safe to do it under read_lock.
-	 */
-	if (unlikely(tsk->group_leader == task_child_reaper(tsk)))
-		task_active_pid_ns(tsk)->child_reaper = tsk;
-
 	sig->group_exit_task = tsk;
 	zap_other_threads(tsk);
-	read_unlock(&tasklist_lock);
 
 	/* Account for the thread group leader hanging around: */
 	count = thread_group_leader(tsk) ? 1 : 2;
@@ -820,6 +807,8 @@ static int de_thread(struct task_struct 
 			schedule();
 		}
 
+		if (unlikely(task_child_reaper(tsk) == leader))
+			task_active_pid_ns(tsk)->child_reaper = tsk;
 		/*
 		 * The only record we have of the real-time age of a
 		 * process, regardless of execs it's done, is start_time.
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
bsd_acct-plain-current-real_parent-access-is-not-always-safe.patch
bsd_acct-using-task_struct-tgid-is-not-right-in-pid-namespaces.patch
x86-handle_vm86_trap-cleanup.patch
git-hrt.patch
mmap_region-cleanup-the-final-vma_merge-related-code.patch
kthread-call-wake_up_process-without-the-lock-being-held.patch
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
ptrace-introduce-task_detached-helper.patch
reparent_thread-use-same_thread_group.patch
document-de_thread-with-exit_notify-connection.patch
ptrace-introduce-ptrace_reparented-helper.patch
ptrace-__ptrace_unlink-use-the-ptrace_reparented-helper.patch
ptrace-ptrace_attach-use-send_sig_info-instead-force_sig_specific.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
cleanup_workqueue_thread-remove-the-unneeded-cpu-parameter.patch
simplify-cpu_hotplug_begin-put_online_cpus.patch
redo-locking-of-tty-pgrp.patch
resume-tty-on-susp-and-fix-crnl-order-in-n_tty-line-discipline.patch
tty_io-fix-remaining-pid-struct-locking.patch
tty_io-fix-remaining-pid-struct-locking-small-cleanup.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
procfs-task-exe-symlink-fix-2.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
pids-de_thread-dont-clear-session-pgrp-pids-for-the-old-leader.patch
pids-introduce-change_pid-helper.patch
pids-sys_setpgid-use-change_pid-helper.patch
pids-__set_special_pids-use-change_pid-helper.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

