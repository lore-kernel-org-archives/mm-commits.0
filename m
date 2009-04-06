From: akpm@linux-foundation.org
Subject: [merged] ptrace-reintroduce-__ptrace_detach-as-a-callee-of-ptrace_exit.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:35:38 -0700
Message-ID: <200904061935.n36JZcR1012129@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45916 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758583AbZDFUXw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 16:23:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, dvlasenk@redhat.com, jmarchan@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ptrace: reintroduce __ptrace_detach() as a callee of ptrace_exit()
has been removed from the -mm tree.  Its filename was
     ptrace-reintroduce-__ptrace_detach-as-a-callee-of-ptrace_exit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 kernel/exit.c |   62 +++++++++++++++++++++++++-----------------------
 1 file changed, 33 insertions(+), 29 deletions(-)

diff -puN kernel/exit.c~ptrace-reintroduce-__ptrace_detach-as-a-callee-of-ptrace_exit kernel/exit.c
--- a/kernel/exit.c~ptrace-reintroduce-__ptrace_detach-as-a-callee-of-ptrace_exit
+++ a/kernel/exit.c
@@ -744,6 +744,38 @@ static int ignoring_children(struct sigh
 	return ret;
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
+	 * reap itself we return true.
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
@@ -755,36 +787,8 @@ static void ptrace_exit(struct task_stru
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
