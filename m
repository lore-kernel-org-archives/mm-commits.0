From: akpm@linux-foundation.org
Subject: + pids-introduce-change_pid-helper.patch added to -mm tree
Date: Fri, 21 Mar 2008 15:12:23 -0700
Message-ID: <200803212212.m2LMCOwt012934@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56728 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752008AbYCUWNf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 18:13:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, ebiederm@xmission.com, roland@redhat.com, xemul@openvz.org


The patch titled
     pids: introduce change_pid() helper
has been added to the -mm tree.  Its filename is
     pids-introduce-change_pid-helper.patch

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
Subject: pids: introduce change_pid() helper
From: Oleg Nesterov <oleg@tv-sign.ru>

Based on Eric W. Biederman's idea.

Without tasklist_lock held task_session()/task_pgrp() can return NULL if the
caller races with setprgp()/setsid() which does detach_pid() + attach_pid(). 
This can happen even if task == current.

Intoduce the new helper, change_pid(), which should be used instead.  This way
the caller always sees the special pid != NULL, either old or new.

Also change the prototype of attach_pid(), it always returns 0 and nobody
check the returned value.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc:  "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pid.h |    6 ++++--
 kernel/pid.c        |   21 ++++++++++++++++-----
 2 files changed, 20 insertions(+), 7 deletions(-)

diff -puN include/linux/pid.h~pids-introduce-change_pid-helper include/linux/pid.h
--- a/include/linux/pid.h~pids-introduce-change_pid-helper
+++ a/include/linux/pid.h
@@ -89,9 +89,11 @@ extern struct pid *get_task_pid(struct t
  * attach_pid() and detach_pid() must be called with the tasklist_lock
  * write-held.
  */
-extern int attach_pid(struct task_struct *task, enum pid_type type,
-		      struct pid *pid);
+extern void attach_pid(struct task_struct *task, enum pid_type type,
+			struct pid *pid);
 extern void detach_pid(struct task_struct *task, enum pid_type);
+extern void change_pid(struct task_struct *task, enum pid_type,
+			struct pid *pid);
 extern void transfer_pid(struct task_struct *old, struct task_struct *new,
 			 enum pid_type);
 
diff -puN kernel/pid.c~pids-introduce-change_pid-helper kernel/pid.c
--- a/kernel/pid.c~pids-introduce-change_pid-helper
+++ a/kernel/pid.c
@@ -318,7 +318,7 @@ EXPORT_SYMBOL_GPL(find_pid);
 /*
  * attach_pid() must be called with the tasklist_lock write-held.
  */
-int attach_pid(struct task_struct *task, enum pid_type type,
+void attach_pid(struct task_struct *task, enum pid_type type,
 		struct pid *pid)
 {
 	struct pid_link *link;
@@ -326,11 +326,10 @@ int attach_pid(struct task_struct *task,
 	link = &task->pids[type];
 	link->pid = pid;
 	hlist_add_head_rcu(&link->node, &pid->tasks[type]);
-
-	return 0;
 }
 
-void detach_pid(struct task_struct *task, enum pid_type type)
+static void __change_pid(struct task_struct *task, enum pid_type type,
+			struct pid *new)
 {
 	struct pid_link *link;
 	struct pid *pid;
@@ -340,7 +339,7 @@ void detach_pid(struct task_struct *task
 	pid = link->pid;
 
 	hlist_del_rcu(&link->node);
-	link->pid = NULL;
+	link->pid = new;
 
 	for (tmp = PIDTYPE_MAX; --tmp >= 0; )
 		if (!hlist_empty(&pid->tasks[tmp]))
@@ -349,6 +348,18 @@ void detach_pid(struct task_struct *task
 	free_pid(pid);
 }
 
+void detach_pid(struct task_struct *task, enum pid_type type)
+{
+	__change_pid(task, type, NULL);
+}
+
+void change_pid(struct task_struct *task, enum pid_type type,
+		struct pid *pid)
+{
+	__change_pid(task, type, pid);
+	attach_pid(task, type, pid);
+}
+
 /* transfer_pid is an optimization of attach_pid(new), detach_pid(old) */
 void transfer_pid(struct task_struct *old, struct task_struct *new,
 			   enum pid_type type)
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
x86-handle_vm86_trap-cleanup.patch
git-hrt.patch
bsd_acct-plain-current-real_parent-access-is-not-always-safe.patch
bsd_acct-using-task_struct-tgid-is-not-right-in-pid-namespaces.patch
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

