From: akpm@linux-foundation.org
Subject: + exit-wait-drop-tasklist_lock-before-psig-c-accounting.patch
 added to -mm tree
Date: Tue, 18 Nov 2014 14:47:45 -0800
Message-ID: <546bcc91.SYAVdwFxpO57NTR6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37582 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318AbaKRWrq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Nov 2014 17:47:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, atomlin@redhat.com, ebiederm@xmission.com, riel@redhat.com, stalexan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: exit: wait: drop tasklist_lock before psig->c* accounting
has been added to the -mm tree.  Its filename is
     exit-wait-drop-tasklist_lock-before-psig-c-accounting.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/exit-wait-drop-tasklist_lock-before-psig-c-accounting.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/exit-wait-drop-tasklist_lock-before-psig-c-accounting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: exit: wait: drop tasklist_lock before psig->c* accounting

wait_task_zombie() no longer needs tasklist_lock to accumulate the
psig->c* counters, we can drop it right after cmpxchg(exit_state).

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Sterling Alexander <stalexan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN kernel/exit.c~exit-wait-drop-tasklist_lock-before-psig-c-accounting kernel/exit.c
--- a/kernel/exit.c~exit-wait-drop-tasklist_lock-before-psig-c-accounting
+++ a/kernel/exit.c
@@ -1003,6 +1003,10 @@ static int wait_task_zombie(struct wait_
 		EXIT_TRACE : EXIT_DEAD;
 	if (cmpxchg(&p->exit_state, EXIT_ZOMBIE, state) != EXIT_ZOMBIE)
 		return 0;
+	/*
+	 * We own this thread, nobody else can reap it.
+	 */
+	read_unlock(&tasklist_lock);
 
 	/*
 	 * Check thread_group_leader() to exclude the traced sub-threads.
@@ -1062,12 +1066,6 @@ static int wait_task_zombie(struct wait_
 		spin_unlock_irq(&current->sighand->siglock);
 	}
 
-	/*
-	 * Now we are sure this task is interesting, and no other
-	 * thread can reap it because we its state == DEAD/TRACE.
-	 */
-	read_unlock(&tasklist_lock);
-
 	retval = wo->wo_rusage
 		? getrusage(p, RUSAGE_BOTH, wo->wo_rusage) : 0;
 	status = (p->signal->flags & SIGNAL_GROUP_EXIT)
_

Patches currently in -mm which might be from oleg@redhat.com are

mmfs-introduce-helpers-around-the-i_mmap_mutex.patch
mm-use-new-helper-functions-around-the-i_mmap_mutex.patch
mm-convert-i_mmap_mutex-to-rwsem.patch
mm-rmap-share-the-i_mmap_rwsem.patch
uprobes-share-the-i_mmap_rwsem.patch
mm-xip-share-the-i_mmap_rwsem.patch
mm-memory-failure-share-the-i_mmap_rwsem.patch
mm-nommu-share-the-i_mmap_rwsem.patch
mm-memoryc-share-the-i_mmap_rwsem.patch
remove-unnecessary-is_valid_nodemask.patch
proc-task_state-read-cred-group_info-outside-of-task_lock.patch
proc-task_state-deuglify-the-max_fds-calculation.patch
proc-task_state-move-the-main-seq_printf-outside-of-rcu_read_lock.patch
proc-task_state-ptrace_parent-doesnt-need-pid_alive-check.patch
sched_show_task-fix-unsafe-usage-of-real_parent.patch
exit-reparent-use-ptrace_entry-rather-than-sibling-for-exit_dead-tasks.patch
exit-reparent-cleanup-the-changing-of-parent.patch
exit-reparent-cleanup-the-changing-of-parent-fix.patch
exit-reparent-cleanup-the-usage-of-reparent_leader.patch
exit-ptrace-shift-reap-dead-code-from-exit_ptrace-to-forget_original_parent.patch
usermodehelper-dont-use-clone_vfork-for-____call_usermodehelper.patch
usermodehelper-kill-the-kmod_thread_locker-logic.patch
exit-wait-cleanup-the-ptrace_reparented-checks.patch
exit-wait-cleanup-the-ptrace_reparented-checks-fix.patch
exit-wait-dont-use-zombie-real_parent.patch
exit-wait-drop-tasklist_lock-before-psig-c-accounting.patch
exit-release_task-fix-the-comment-about-group-leader-accounting.patch
exit-proc-dont-try-to-flush-proc-tgid-task-tgid.patch
exit-reparent-fix-the-dead-parent-pr_set_child_subreaper-reparenting.patch
exit-reparent-fix-the-cross-namespace-pr_set_child_subreaper-reparenting.patch
exit-reparent-s-while_each_thread-for_each_thread-in-find_new_reaper.patch
exit-reparent-document-the-has_child_subreaper-checks.patch
exit-reparent-introduce-find_child_reaper.patch
exit-reparent-introduce-find_alive_thread.patch
linux-next.patch

