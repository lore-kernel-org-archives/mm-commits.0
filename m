From: akpm@linux-foundation.org
Subject: + ptrace-reintroduce-__ptrace_detach-as-a-callee-of-ptrace_exit.patch added to -mm tree
Date: Thu, 29 Jan 2009 00:43:53 -0800
Message-ID: <200901290843.n0T8hrJh002987@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51269 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752118AbZA2Ioi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Jan 2009 03:44:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, dvlasenk@redhat.com, jmarchan@redhat.com, roland@redhat.com


The patch titled
     ptrace: reintroduce __ptrace_detach() as a callee of ptrace_exit()
has been added to the -mm tree.  Its filename is
     ptrace-reintroduce-__ptrace_detach-as-a-callee-of-ptrace_exit.patch

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
Subject: ptrace: reintroduce __ptrace_detach() as a callee of ptrace_exit()
From: Oleg Nesterov <oleg@redhat.com>

No functional changes, preparation for the next patch.

Move the "should we release this child" logic into the separate handler,
__ptrace_detach().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   63 +++++++++++++++++++++++++-----------------------
 1 file changed, 34 insertions(+), 29 deletions(-)

diff -puN kernel/exit.c~ptrace-reintroduce-__ptrace_detach-as-a-callee-of-ptrace_exit kernel/exit.c
--- a/kernel/exit.c~ptrace-reintroduce-__ptrace_detach-as-a-callee-of-ptrace_exit
+++ a/kernel/exit.c
@@ -737,6 +737,39 @@ static int ignoring_children(struct sigh
 		sigh->action[SIGCHLD-1].sa.sa_flags & SA_NOCLDWAIT;
 }
 
+/* Returns nonzero if the tracee should be released. */
+int __ptrace_detach(struct task_struct *tracer, struct task_struct *p)
+{
+	__ptrace_unlink(p);
+
+	if (p->exit_state != EXIT_ZOMBIE)
+		return 0;
+	/*
+	 * If it's a zombie, our attachedness prevented normal
+	 * parent notification or self-reaping.  Do notification
+	 * now if it would have happened earlier.  If it should
+	 * reap itself, add it to the @dead list.  We can't call
+	 * release_task() here because we already hold tasklist_lock.
+	 *
+	 * If it's our own child, there is no notification to do.
+	 * But if our normal children self-reap, then this child
+	 * was prevented by ptrace and we must reap it now.
+	 */
+	if (!task_detached(p) && thread_group_empty(p)) {
+		if (!same_thread_group(p->real_parent, tracer))
+			do_notify_parent(p, p->exit_signal);
+		else if (ignoring_children(tracer->sighand))
+			p->exit_signal = -1;
+	}
+
+	if (!task_detached(p))
+		return 0;
+
+	/* Mark it as in the process of being reaped. */
+	p->exit_state = EXIT_DEAD;
+	return 1;
+}
+
 /*
  * Detach all tasks we were using ptrace on.
  * Any that need to be release_task'd are put on the @dead list.
@@ -748,36 +781,8 @@ static void ptrace_exit(struct task_stru
 	struct task_struct *p, *n;
 
 	list_for_each_entry_safe(p, n, &parent->ptraced, ptrace_entry) {
-		__ptrace_unlink(p);
-
-		if (p->exit_state != EXIT_ZOMBIE)
-			continue;
-
-		/*
-		 * If it's a zombie, our attachedness prevented normal
-		 * parent notification or self-reaping.  Do notification
-		 * now if it would have happened earlier.  If it should
-		 * reap itself, add it to the @dead list.  We can't call
-		 * release_task() here because we already hold tasklist_lock.
-		 *
-		 * If it's our own child, there is no notification to do.
-		 * But if our normal children self-reap, then this child
-		 * was prevented by ptrace and we must reap it now.
-		 */
-		if (!task_detached(p) && thread_group_empty(p)) {
-			if (!same_thread_group(p->real_parent, parent))
-				do_notify_parent(p, p->exit_signal);
-			else if (ignoring_children(parent->sighand))
-				p->exit_signal = -1;
-		}
-
-		if (task_detached(p)) {
-			/*
-			 * Mark it as in the process of being reaped.
-			 */
-			p->exit_state = EXIT_DEAD;
+		if (__ptrace_detach(parent, p))
 			list_add(&p->ptrace_entry, dead);
-		}
 	}
 }
 
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

