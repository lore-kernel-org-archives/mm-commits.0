From: akpm@linux-foundation.org
Subject: [folded] ptrace-reintroduce-__ptrace_detach-as-a-callee-of-ptrace_exit-fix.patch removed from -mm tree
Date: Thu, 02 Apr 2009 16:21:05 -0700
Message-ID: <200904022321.n32NL5eY011209@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52162 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755202AbZDBXYz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Apr 2009 19:24:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, dvlasenk@redhat.com, jmarchan@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ptrace-reintroduce-__ptrace_detach-as-a-callee-of-ptrace_exit fix
has been removed from the -mm tree.  Its filename was
     ptrace-reintroduce-__ptrace_detach-as-a-callee-of-ptrace_exit-fix.patch

This patch was dropped because it was folded into ptrace-reintroduce-__ptrace_detach-as-a-callee-of-ptrace_exit.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace-reintroduce-__ptrace_detach-as-a-callee-of-ptrace_exit fix
From: Oleg Nesterov <oleg@redhat.com>

Re-diff + update the comments.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN kernel/exit.c~ptrace-reintroduce-__ptrace_detach-as-a-callee-of-ptrace_exit-fix kernel/exit.c
--- a/kernel/exit.c~ptrace-reintroduce-__ptrace_detach-as-a-callee-of-ptrace_exit-fix
+++ a/kernel/exit.c
@@ -752,8 +752,7 @@ int __ptrace_detach(struct task_struct *
 	 * If it's a zombie, our attachedness prevented normal
 	 * parent notification or self-reaping.  Do notification
 	 * now if it would have happened earlier.  If it should
-	 * reap itself, add it to the @dead list.  We can't call
-	 * release_task() here because we already hold tasklist_lock.
+	 * reap itself we return true.
 	 *
 	 * If it's our own child, there is no notification to do.
 	 * But if our normal children self-reap, then this child
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
do_wait-fix-waiting-for-the-group-stop-with-the-dead-leader.patch
signals-remove-handler-parameter-to-tracehook-functions.patch
signals-protect-init-from-unwanted-signals-more.patch
ptrace-kill-__ptrace_detach-fix-exit_state-check.patch
ptrace-simplify-ptrace_exit-ignoring_children-path.patch
ptrace-reintroduce-__ptrace_detach-as-a-callee-of-ptrace_exit.patch
ptrace-reintroduce-__ptrace_detach-as-a-callee-of-ptrace_exit-fix.patch
ptrace-fix-possible-zombie-leak-on-ptrace_detach.patch
reparent_thread-dont-call-kill_orphaned_pgrp-if-task_detached.patch
reparent_thread-fix-the-is-it-traced-check.patch
reparent_thread-fix-a-zombie-leak-if-sbin-init-ignores-sigchld.patch
forget_original_parent-split-out-the-un-ptrace-part.patch
forget_original_parent-do-not-abuse-child-ptrace_entry.patch
forget_original_parent-do-not-abuse-child-ptrace_entry-fix.patch
tracehook_notify_death-use-task_detached-helper.patch
ptrace_detach-the-wrong-wakeup-breaks-the-erestartxxx-logic.patch
ptrace_untrace-fix-the-signal_stop_stopped-check.patch
workqueue-avoid-recursion-in-run_workqueue.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu.patch
pids-improve-get_task_pid-to-fix-the-unsafe-sys_wait4-task_pgrp.patch
pids-refactor-vnr-nr_ns-helpers-to-make-them-safe.patch
pids-kill-now-unused-signal_struct-__pgrp-__session-and-friends.patch
linux-next.patch
getrusage-fill-ru_maxrss-value.patch
signals-split-do_tkill.patch
signals-implement-sys_rt_tgsigqueueinfo.patch
x86-hookup-sys_rt_tgsigqueueinfo.patch
signals-tracehook_notify_jctl-change.patch

