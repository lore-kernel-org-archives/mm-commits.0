From: akpm@linux-foundation.org
Subject: + ptrace-reintroduce-__ptrace_detach-as-a-callee-of-ptrace_exit-fix.patch added to -mm tree
Date: Fri, 30 Jan 2009 12:48:57 -0800
Message-ID: <200901302048.n0UKmvKb015341@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56718 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752514AbZA3Ut4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 15:49:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, dvlasenk@redhat.com, jmarchan@redhat.com, roland@redhat.com


The patch titled
     ptrace-reintroduce-__ptrace_detach-as-a-callee-of-ptrace_exit fix
has been added to the -mm tree.  Its filename is
     ptrace-reintroduce-__ptrace_detach-as-a-callee-of-ptrace_exit-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
wait-prevent-exclusive-waiter-starvation.patch
linux-next.patch
pipe_rdwr_fasync-fix-the-error-handling-to-prevent-the-leak-crash.patch
get_mm_hiwater_xxx-trivial-s-define-inline.patch
getrusage-fill-ru_maxrss-value.patch
ptrace-kill-__ptrace_detach-fix-exit_state-check.patch
ptrace-simplify-ptrace_exit-ignoring_children-path.patch
ptrace-simplify-ptrace_exit-ignoring_children-pathpatch-fix.patch
ptrace-reintroduce-__ptrace_detach-as-a-callee-of-ptrace_exit.patch
ptrace-reintroduce-__ptrace_detach-as-a-callee-of-ptrace_exit-fix.patch
ptrace-fix-possible-zombie-leak-on-ptrace_detach.patch
reparent_thread-dont-call-kill_orphaned_pgrp-if-task_detached.patch
reparent_thread-fix-the-is-it-traced-check.patch
reparent_thread-fix-a-zombie-leak-if-sbin-init-ignores-sigchld.patch
forget_original_parent-cleanup-ptrace-pathes.patch
kthread-dont-looking-for-a-task-in-create_kthread-2.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
pids-improve-get_task_pid-to-fix-the-unsafe-sys_wait4-task_pgrp.patch
pids-refactor-vnr-nr_ns-helpers-to-make-them-safe.patch
pids-kill-now-unused-signal_struct-__pgrp-__session-and-friends.patch

