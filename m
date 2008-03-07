From: akpm@linux-foundation.org
Subject: + signals-send_sig_info-dont-take-tasklist_lock.patch added to -mm tree
Date: Fri, 07 Mar 2008 03:14:22 -0800
Message-ID: <200803071114.m27BEMgG019240@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35141 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757359AbYCGLPx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Mar 2008 06:15:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com


The patch titled
     signals: send_sig_info: don't take tasklist_lock
has been added to the -mm tree.  Its filename is
     signals-send_sig_info-dont-take-tasklist_lock.patch

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
Subject: signals: send_sig_info: don't take tasklist_lock
From: Oleg Nesterov <oleg@tv-sign.ru>

The comment in send_sig_info() is wrong, tasklist_lock can't help.

The caller must ensure the task can't go away, otherwise ->sighand can be NULL
even before we take the lock.

p->sighand could be changed by exec(), but I can't imagine how it is possible
to prevent exit(), but not exec().

Since the things seem to work, I assume all callers are correct.  However,
drm_vbl_send_signals() looks broken.  block_all_signals() which is solely used
by drm is definitely broken.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff -puN kernel/signal.c~signals-send_sig_info-dont-take-tasklist_lock kernel/signal.c
--- a/kernel/signal.c~signals-send_sig_info-dont-take-tasklist_lock
+++ a/kernel/signal.c
@@ -1138,8 +1138,7 @@ static int kill_something_info(int sig, 
  */
 
 /*
- * These two are the most common entry points.  They send a signal
- * just to the specific thread.
+ * The caller must ensure the task can't exit.
  */
 int
 send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
@@ -1154,17 +1153,9 @@ send_sig_info(int sig, struct siginfo *i
 	if (!valid_signal(sig))
 		return -EINVAL;
 
-	/*
-	 * We need the tasklist lock even for the specific
-	 * thread case (when we don't need to follow the group
-	 * lists) in order to avoid races with "p->sighand"
-	 * going away or changing from under us.
-	 */
-	read_lock(&tasklist_lock);  
 	spin_lock_irqsave(&p->sighand->siglock, flags);
 	ret = specific_send_sig_info(sig, info, p);
 	spin_unlock_irqrestore(&p->sighand->siglock, flags);
-	read_unlock(&tasklist_lock);
 	return ret;
 }
 
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

git-hrt.patch
kthread-call-wake_up_process-without-the-lock-being-held.patch
mmap_region-cleanup-the-final-vma_merge-related-code.patch
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
ptrace-introduce-task_detached-helper.patch
reparent_thread-use-same_thread_group.patch
document-de_thread-with-exit_notify-connection.patch
ptrace-introduce-ptrace_reparented-helper.patch
ptrace-__ptrace_unlink-use-the-ptrace_reparented-helper.patch
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
put_pid-make-sure-we-dont-free-the-live-pid.patch

