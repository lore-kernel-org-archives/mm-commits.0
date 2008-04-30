From: akpm@linux-foundation.org
Subject: - procfs-mem-permission-cleanup.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:45:47 -0700
Message-ID: <200804300545.m3U5jlJq029543@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49124 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757696AbYD3Fqn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:46:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, adobriyan@gmail.com, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     procfs: mem permission cleanup
has been removed from the -mm tree.  Its filename was
     procfs-mem-permission-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: procfs: mem permission cleanup
From: Roland McGrath <roland@redhat.com>

This cleans up the permission checks done for /proc/PID/mem i/o calls.  It
puts all the logic in a new function, check_mem_permission().

The old code repeated the (!MAY_PTRACE(task) || !ptrace_may_attach(task))
magical expression multiple times.  The new function does all that work in one
place, with clear comments.

The old code called security_ptrace() twice on successful checks, once in
MAY_PTRACE() and once in __ptrace_may_attach().  Now it's only called once,
and only if all other checks have succeeded.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   38 +++++++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 9 deletions(-)

diff -puN fs/proc/base.c~procfs-mem-permission-cleanup fs/proc/base.c
--- a/fs/proc/base.c~procfs-mem-permission-cleanup
+++ a/fs/proc/base.c
@@ -195,12 +195,32 @@ static int proc_root_link(struct inode *
 	return result;
 }
 
-#define MAY_PTRACE(task) \
-	(task == current || \
-	(task->parent == current && \
-	(task->ptrace & PT_PTRACED) && \
-	 (task_is_stopped_or_traced(task)) && \
-	 security_ptrace(current,task) == 0))
+/*
+ * Return zero if current may access user memory in @task, -error if not.
+ */
+static int check_mem_permission(struct task_struct *task)
+{
+	/*
+	 * A task can always look at itself, in case it chooses
+	 * to use system calls instead of load instructions.
+	 */
+	if (task == current)
+		return 0;
+
+	/*
+	 * If current is actively ptrace'ing, and would also be
+	 * permitted to freshly attach with ptrace now, permit it.
+	 */
+	if (task->parent == current && (task->ptrace & PT_PTRACED) &&
+	    task_is_stopped_or_traced(task) &&
+	    ptrace_may_attach(task))
+		return 0;
+
+	/*
+	 * Noone else is allowed.
+	 */
+	return -EPERM;
+}
 
 struct mm_struct *mm_for_maps(struct task_struct *task)
 {
@@ -722,7 +742,7 @@ static ssize_t mem_read(struct file * fi
 	if (!task)
 		goto out_no_task;
 
-	if (!MAY_PTRACE(task) || !ptrace_may_attach(task))
+	if (check_mem_permission(task))
 		goto out;
 
 	ret = -ENOMEM;
@@ -748,7 +768,7 @@ static ssize_t mem_read(struct file * fi
 
 		this_len = (count > PAGE_SIZE) ? PAGE_SIZE : count;
 		retval = access_process_vm(task, src, page, this_len, 0);
-		if (!retval || !MAY_PTRACE(task) || !ptrace_may_attach(task)) {
+		if (!retval || check_mem_permission(task)) {
 			if (!ret)
 				ret = -EIO;
 			break;
@@ -792,7 +812,7 @@ static ssize_t mem_write(struct file * f
 	if (!task)
 		goto out_no_task;
 
-	if (!MAY_PTRACE(task) || !ptrace_may_attach(task))
+	if (check_mem_permission(task))
 		goto out;
 
 	copied = -ENOMEM;
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
x86-ptrace-pebs-support.patch
x86-ptrace-pebs-support-warning-fix.patch
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
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
pids-de_thread-dont-clear-session-pgrp-pids-for-the-old-leader.patch
pids-introduce-change_pid-helper.patch
pids-sys_setpgid-use-change_pid-helper.patch
pids-__set_special_pids-use-change_pid-helper.patch
pids-sys_getsid-fix-unsafe-pid-usage-fix-possible-0-instead-of-esrch.patch
pids-sys_getpgid-fix-unsafe-pid-usage-s-tasklist-rcu.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

