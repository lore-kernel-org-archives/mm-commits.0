From: akpm@linux-foundation.org
Subject: + ptrace-simplify-ptrace_exit-ignoring_children-path.patch added to -mm tree
Date: Thu, 29 Jan 2009 00:43:51 -0800
Message-ID: <200901290843.n0T8hpmi002940@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37119 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752908AbZA2Ioi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Jan 2009 03:44:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, dvlasenk@redhat.com, jmarchan@redhat.com, roland@redhat.com


The patch titled
     ptrace: simplify ptrace_exit()->ignoring_children() path
has been added to the -mm tree.  Its filename is
     ptrace-simplify-ptrace_exit-ignoring_children-path.patch

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
Subject: ptrace: simplify ptrace_exit()->ignoring_children() path
From: Oleg Nesterov <oleg@redhat.com>

ignoring_children() takes parent->sighand->siglock and checks
k_sigaction[SIGCHLD] atomically.  But this buys nothing, we can't get the
"really" wrong result even if we race with sigaction(SIGCHLD).  If we read
the "stale" sa_handler/sa_flags we can pretend it was changed right after
the check.

Remove spin_lock(->siglock), and kill "int ign" which caches the result of
ignoring_children() which becomes rather trivial.

Perhaps it makes sense to export this helper, do_notify_parent() can use
it too.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

diff -puN kernel/exit.c~ptrace-simplify-ptrace_exit-ignoring_children-path kernel/exit.c
--- a/kernel/exit.c~ptrace-simplify-ptrace_exit-ignoring_children-path
+++ a/kernel/exit.c
@@ -729,20 +729,12 @@ static void exit_mm(struct task_struct *
 }
 
 /*
- * Return nonzero if @parent's children should reap themselves.
- *
- * Called with write_lock_irq(&tasklist_lock) held.
+ * Return nonzero if childs should reap themselves.
  */
-static int ignoring_children(struct task_struct *parent)
+static int ignoring_children(struct sighand_struct *sigh)
 {
-	int ret;
-	struct sighand_struct *psig = parent->sighand;
-	unsigned long flags;
-	spin_lock_irqsave(&psig->siglock, flags);
-	ret = (psig->action[SIGCHLD-1].sa.sa_handler == SIG_IGN ||
-	       (psig->action[SIGCHLD-1].sa.sa_flags & SA_NOCLDWAIT));
-	spin_unlock_irqrestore(&psig->siglock, flags);
-	return ret;
+	return	sigh->action[SIGCHLD-1].sa.sa_handler == SIG_IGN ||
+		sigh->action[SIGCHLD-1].sa.sa_flags & SA_NOCLDWAIT;
 }
 
 /*
@@ -754,7 +746,6 @@ static int ignoring_children(struct task
 static void ptrace_exit(struct task_struct *parent, struct list_head *dead)
 {
 	struct task_struct *p, *n;
-	int ign = -1;
 
 	list_for_each_entry_safe(p, n, &parent->ptraced, ptrace_entry) {
 		__ptrace_unlink(p);
@@ -776,12 +767,8 @@ static void ptrace_exit(struct task_stru
 		if (!task_detached(p) && thread_group_empty(p)) {
 			if (!same_thread_group(p->real_parent, parent))
 				do_notify_parent(p, p->exit_signal);
-			else {
-				if (ign < 0)
-					ign = ignoring_children(parent);
-				if (ign)
-					p->exit_signal = -1;
-			}
+			else if (ignoring_children(parent->sighand))
+				p->exit_signal = -1;
 		}
 
 		if (task_detached(p)) {
_

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
wait-prevent-exclusive-waiter-starvation.patch
pipe_rdwr_fasync-fix-the-error-handling-to-prevent-the-leak-crash.patch
get_mm_hiwater_xxx-trivial-s-define-inline.patch
getrusage-fill-ru_maxrss-value.patch
ptrace-kill-__ptrace_detach-fix-exit_state-check.patch
ptrace-simplify-ptrace_exit-ignoring_children-path.patch
ptrace-reintroduce-__ptrace_detach-as-a-callee-of-ptrace_exit.patch
ptrace-fix-possible-zombie-leak-on-ptrace_detach.patch
kthread-dont-looking-for-a-task-in-create_kthread-2.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
pids-improve-get_task_pid-to-fix-the-unsafe-sys_wait4-task_pgrp.patch
pids-refactor-vnr-nr_ns-helpers-to-make-them-safe.patch
pids-kill-now-unused-signal_struct-__pgrp-__session-and-friends.patch

