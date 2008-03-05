From: akpm@linux-foundation.org
Subject: + kill_pid_info-dont-take-now-unneeded-tasklist_lock.patch added to -mm tree
Date: Wed, 05 Mar 2008 15:33:53 -0800
Message-ID: <200803052333.m25NXrN2027367@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39663 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750875AbYCEXfS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 18:35:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, jkosina@suse.cz, roland@redhat.com


The patch titled
     kill_pid_info: don't take now unneeded tasklist_lock
has been added to the -mm tree.  Its filename is
     kill_pid_info-dont-take-now-unneeded-tasklist_lock.patch

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
Subject: kill_pid_info: don't take now unneeded tasklist_lock
From: Oleg Nesterov <oleg@tv-sign.ru>

Previously handle_stop_signal(SIGCONT) could drop ->siglock.  That is why
kill_pid_info(SIGCONT) takes tasklist_lock to make sure the target task can't
go away after unlock.  Not needed now.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/signal.h |    2 --
 kernel/signal.c        |    7 +------
 2 files changed, 1 insertion(+), 8 deletions(-)

diff -puN include/linux/signal.h~kill_pid_info-dont-take-now-unneeded-tasklist_lock include/linux/signal.h
--- a/include/linux/signal.h~kill_pid_info-dont-take-now-unneeded-tasklist_lock
+++ a/include/linux/signal.h
@@ -362,8 +362,6 @@ int unhandled_signal(struct task_struct 
 #define sig_kernel_stop(sig) \
 	(((sig) < SIGRTMIN) && siginmask(sig, SIG_KERNEL_STOP_MASK))
 
-#define sig_needs_tasklist(sig)	((sig) == SIGCONT)
-
 #define sig_user_defined(t, signr) \
 	(((t)->sighand->action[(signr)-1].sa.sa_handler != SIG_DFL) &&	\
 	 ((t)->sighand->action[(signr)-1].sa.sa_handler != SIG_IGN))
diff -puN kernel/signal.c~kill_pid_info-dont-take-now-unneeded-tasklist_lock kernel/signal.c
--- a/kernel/signal.c~kill_pid_info-dont-take-now-unneeded-tasklist_lock
+++ a/kernel/signal.c
@@ -1039,9 +1039,6 @@ int kill_pid_info(int sig, struct siginf
 	struct task_struct *p;
 
 	rcu_read_lock();
-	if (unlikely(sig_needs_tasklist(sig)))
-		read_lock(&tasklist_lock);
-
 retry:
 	p = pid_task(pid, PIDTYPE_PID);
 	if (p) {
@@ -1055,10 +1052,8 @@ retry:
 			 */
 			goto retry;
 	}
-
-	if (unlikely(sig_needs_tasklist(sig)))
-		read_unlock(&tasklist_lock);
 	rcu_read_unlock();
+
 	return error;
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
ptrace-introduce-task_detached-helper.patch
ptrace-introduce-ptrace_reparented-helper.patch
reparent_thread-use-same_thread_group.patch
document-de_thread-with-exit_notify-connection.patch
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

