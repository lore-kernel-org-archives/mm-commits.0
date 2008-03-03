From: akpm@linux-foundation.org
Subject: + document-de_thread-with-exit_notify-connection.patch added to -mm tree
Date: Mon, 03 Mar 2008 00:31:24 -0800
Message-ID: <200803030831.m238VOeF006881@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59883 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753840AbYCCIco (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 03:32:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com


The patch titled
     document de_thread() with exit_notify() connection
has been added to the -mm tree.  Its filename is
     document-de_thread-with-exit_notify-connection.patch

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
Subject: document de_thread() with exit_notify() connection
From: Oleg Nesterov <oleg@tv-sign.ru>

Add a couple of small comments, it is not easy to see what this code does.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c     |    2 +-
 kernel/exit.c |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/exec.c~document-de_thread-with-exit_notify-connection fs/exec.c
--- a/fs/exec.c~document-de_thread-with-exit_notify-connection
+++ a/fs/exec.c
@@ -802,7 +802,7 @@ static int de_thread(struct task_struct 
 	if (!thread_group_leader(tsk)) {
 		leader = tsk->group_leader;
 
-		sig->notify_count = -1;
+		sig->notify_count = -1;	/* for exit_notify() */
 		for (;;) {
 			write_lock_irq(&tasklist_lock);
 			if (likely(leader->exit_state))
diff -puN kernel/exit.c~document-de_thread-with-exit_notify-connection kernel/exit.c
--- a/kernel/exit.c~document-de_thread-with-exit_notify-connection
+++ a/kernel/exit.c
@@ -811,6 +811,7 @@ static void exit_notify(struct task_stru
 		state = EXIT_DEAD;
 	tsk->exit_state = state;
 
+	/* mt-exec, de_thread() is waiting for us */
 	if (thread_group_leader(tsk) &&
 	    tsk->signal->notify_count < 0 &&
 	    tsk->signal->group_exit_task)
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

git-hrt.patch
kthread-call-wake_up_process-without-the-lock-being-held.patch
documentation-atomic_add_unless-doesnt-imply-mb-on-failure-fix.patch
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
introduce-kill_orphaned_pgrp-helper.patch
will_become_orphaned_pgrp-partially-fix-insufficient-exit_state-check.patch
exit_notify-fix-kill_orphaned_pgrp-usage-with-mt-exit.patch
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
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
procfs-task-exe-symlink-fix-2.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

