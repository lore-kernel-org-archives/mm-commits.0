From: akpm@linux-foundation.org
Subject: + ptrace-simplify-ptrace_exit-ignoring_children-pathpatch-fix.patch added to -mm tree
Date: Fri, 30 Jan 2009 12:47:57 -0800
Message-ID: <200901302047.n0UKlwtF014048@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35798 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751618AbZA3Usn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 15:48:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, dvlasenk@redhat.com, jmarchan@redhat.com, roland@redhat.com


The patch titled
     ptrace-simplify-ptrace_exit-ignoring_children-pathpatch fix
has been added to the -mm tree.  Its filename is
     ptrace-simplify-ptrace_exit-ignoring_children-pathpatch-fix.patch

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
Subject: ptrace-simplify-ptrace_exit-ignoring_children-pathpatch fix
From: Oleg Nesterov <oleg@redhat.com>

Somehow I didn't even try to think about false _negative_, and it is
possible without ->siglock.

If we race with sigaction() which changes ->action[SIGCHLD]

	from:	{ .sa_handler = SIG_IGN, .sa_flags = 0 }
	to:	{ .sa_handler = handler, .sa_flags = SA_NOCLDWAIT }

we can read the stores out of order, and ignoring_children() may
return the wrong "false". Nothing really bad can happen, and the
race is mostly theoretical, but still this is not right.

[PATCH 2/4] ptrace: simplify ptrace_exit()->ignoring_children() path

In order to avoid the unnecessary ignoring_children() calls, ptrace_exit()
uses "int ign" to cache the returned value.

This makes sense because ptrace_exit() works with the list of tracees, but
the next patche changes this code to work with individual threads.

Remove this optimization, I don't think it is common to exit with a lot of
attached EXIT_ZOMBIE tracees. And this makes the code a bit simpler.

Also remove _irqsave/_irqrestore, this code always runs with irqs disabled.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN kernel/exit.c~ptrace-simplify-ptrace_exit-ignoring_children-pathpatch-fix kernel/exit.c
--- a/kernel/exit.c~ptrace-simplify-ptrace_exit-ignoring_children-pathpatch-fix
+++ a/kernel/exit.c
@@ -729,12 +729,16 @@ static void exit_mm(struct task_struct *
 }
 
 /*
- * Return nonzero if childs should reap themselves.
+ * Called with irqs disabled, returns true if childs should reap themselves.
  */
 static int ignoring_children(struct sighand_struct *sigh)
 {
-	return	sigh->action[SIGCHLD-1].sa.sa_handler == SIG_IGN ||
-		sigh->action[SIGCHLD-1].sa.sa_flags & SA_NOCLDWAIT;
+	int ret;
+	spin_lock(&sigh->siglock);
+	ret = (sigh->action[SIGCHLD-1].sa.sa_handler == SIG_IGN) ||
+	      (sigh->action[SIGCHLD-1].sa.sa_flags & SA_NOCLDWAIT);
+	spin_unlock(&sigh->siglock);
+	return ret;
 }
 
 /*
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

