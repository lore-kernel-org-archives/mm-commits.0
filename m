From: akpm@linux-foundation.org
Subject: + will_become_orphaned_pgrp-partially-fix-insufficient-exit_state-check.patch added to -mm tree
Date: Mon, 03 Mar 2008 00:11:10 -0800
Message-ID: <200803030811.m238BAwr006148@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32880 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751107AbYCCIMj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 03:12:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, mingo@elte.hu, roland@redhat.com


The patch titled
     pgrp: will_become_orphaned_pgrp: partially fix insufficient ->exit_state check
has been added to the -mm tree.  Its filename is
     will_become_orphaned_pgrp-partially-fix-insufficient-exit_state-check.patch

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
Subject: pgrp: will_become_orphaned_pgrp: partially fix insufficient ->exit_state check
From: Oleg Nesterov <oleg@tv-sign.ru>

p->exit_state != 0 doesn't mean this process is dead, it may have sub-threads.
 Change the code to use "p->exit_state && thread_group_empty(p)" instead.

Without this patch, ^Z doesn't deliver SIGTSTP to the foreground process if
the main thread has exited.

However, the new check is not perfect too.  There is a window when
exit_notify() drops tasklist and before release_task().  Suppose that the last
(non-leader) thread exits.  This means that entire group exits, but
thread_group_empty() is not true yet.

As Eric pointed out, is_global_init() is wrong as well, but I did not dare to
do other changes.

Just for the record, has_stopped_jobs() is absolutely wrong too.  But we can't
fix it now, we should first fix SIGNAL_STOP_STOPPED issues.

And.  Even with this patch ^Z doesn't play well with the dead main thread. 
The task is stopped correctly but do_wait(WSTOPPED) can't see it.  This is
another unrelated issue, will be (hopefully) fixed separately.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff -puN kernel/exit.c~will_become_orphaned_pgrp-partially-fix-insufficient-exit_state-check kernel/exit.c
--- a/kernel/exit.c~will_become_orphaned_pgrp-partially-fix-insufficient-exit_state-check
+++ a/kernel/exit.c
@@ -214,20 +214,19 @@ struct pid *session_of_pgrp(struct pid *
 static int will_become_orphaned_pgrp(struct pid *pgrp, struct task_struct *ignored_task)
 {
 	struct task_struct *p;
-	int ret = 1;
 
 	do_each_pid_task(pgrp, PIDTYPE_PGID, p) {
-		if (p == ignored_task
-				|| p->exit_state
-				|| is_global_init(p->real_parent))
+		if ((p == ignored_task) ||
+		    (p->exit_state && thread_group_empty(p)) ||
+		    is_global_init(p->real_parent))
 			continue;
+
 		if (task_pgrp(p->real_parent) != pgrp &&
-		    task_session(p->real_parent) == task_session(p)) {
-			ret = 0;
-			break;
-		}
+		    task_session(p->real_parent) == task_session(p))
+			return 0;
 	} while_each_pid_task(pgrp, PIDTYPE_PGID, p);
-	return ret;	/* (sighing) "Often!" */
+
+	return 1;
 }
 
 int is_current_pgrp_orphaned(void)
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

