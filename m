From: akpm@linux-foundation.org
Subject: [merged] ptrace-cleanup-check-set-of-pt_ptraced-during-attach.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:46:37 -0700
Message-ID: <200906182246.n5IMkb8s005598@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43363 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759140AbZFRWsJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:48:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, chrisw@sous-sol.org, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ptrace: cleanup check/set of PT_PTRACED during attach
has been removed from the -mm tree.  Its filename was
     ptrace-cleanup-check-set-of-pt_ptraced-during-attach.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace: cleanup check/set of PT_PTRACED during attach
From: Oleg Nesterov <oleg@redhat.com>

ptrace_attach() and ptrace_traceme() are the last functions which look as
if the untraced task can have task->ptrace != 0, this must not be
possible.  Change the code to just check ->ptrace != 0 and s/|=/=/ to set
PT_PTRACED.

Also, a couple of trivial whitespace cleanups in ptrace_attach().

And move ptrace_traceme() up near ptrace_attach() to keep them close to
each other.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |  101 +++++++++++++++++++++++-----------------------
 1 file changed, 51 insertions(+), 50 deletions(-)

diff -puN kernel/ptrace.c~ptrace-cleanup-check-set-of-pt_ptraced-during-attach kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace-cleanup-check-set-of-pt_ptraced-during-attach
+++ a/kernel/ptrace.c
@@ -177,12 +177,13 @@ int ptrace_attach(struct task_struct *ta
 	if (same_thread_group(task, current))
 		goto out;
 
-	/* Protect the target's credential calculations against our
+	/*
+	 * Protect exec's credential calculations against our interference;
 	 * interference; SUID, SGID and LSM creds get determined differently
 	 * under ptrace.
 	 */
 	retval = mutex_lock_interruptible(&task->cred_guard_mutex);
-	if (retval  < 0)
+	if (retval < 0)
 		goto out;
 repeat:
 	/*
@@ -210,10 +211,10 @@ repeat:
 	retval = -EPERM;
 	if (unlikely(task->exit_state))
 		goto bad;
-	if (task->ptrace & PT_PTRACED)
+	if (task->ptrace)
 		goto bad;
 
-	task->ptrace |= PT_PTRACED;
+	task->ptrace = PT_PTRACED;
 	if (capable(CAP_SYS_PTRACE))
 		task->ptrace |= PT_PTRACE_CAP;
 
@@ -229,6 +230,52 @@ out:
 	return retval;
 }
 
+/**
+ * ptrace_traceme  --  helper for PTRACE_TRACEME
+ *
+ * Performs checks and sets PT_PTRACED.
+ * Should be used by all ptrace implementations for PTRACE_TRACEME.
+ */
+int ptrace_traceme(void)
+{
+	int ret = -EPERM;
+
+	/*
+	 * Are we already being traced?
+	 */
+repeat:
+	task_lock(current);
+	if (!current->ptrace) {
+		/*
+		 * See ptrace_attach() comments about the locking here.
+		 */
+		unsigned long flags;
+		if (!write_trylock_irqsave(&tasklist_lock, flags)) {
+			task_unlock(current);
+			do {
+				cpu_relax();
+			} while (!write_can_lock(&tasklist_lock));
+			goto repeat;
+		}
+
+		ret = security_ptrace_traceme(current->parent);
+
+		/*
+		 * Check PF_EXITING to ensure ->real_parent has not passed
+		 * exit_ptrace(). Otherwise we don't report the error but
+		 * pretend ->real_parent untraces us right after return.
+		 */
+		if (!ret && !(current->real_parent->flags & PF_EXITING)) {
+			current->ptrace = PT_PTRACED;
+			__ptrace_link(current, current->real_parent);
+		}
+
+		write_unlock_irqrestore(&tasklist_lock, flags);
+	}
+	task_unlock(current);
+	return ret;
+}
+
 /*
  * Called with irqs disabled, returns true if childs should reap themselves.
  */
@@ -568,52 +615,6 @@ int ptrace_request(struct task_struct *c
 }
 
 /**
- * ptrace_traceme  --  helper for PTRACE_TRACEME
- *
- * Performs checks and sets PT_PTRACED.
- * Should be used by all ptrace implementations for PTRACE_TRACEME.
- */
-int ptrace_traceme(void)
-{
-	int ret = -EPERM;
-
-	/*
-	 * Are we already being traced?
-	 */
-repeat:
-	task_lock(current);
-	if (!(current->ptrace & PT_PTRACED)) {
-		/*
-		 * See ptrace_attach() comments about the locking here.
-		 */
-		unsigned long flags;
-		if (!write_trylock_irqsave(&tasklist_lock, flags)) {
-			task_unlock(current);
-			do {
-				cpu_relax();
-			} while (!write_can_lock(&tasklist_lock));
-			goto repeat;
-		}
-
-		ret = security_ptrace_traceme(current->parent);
-
-		/*
-		 * Check PF_EXITING to ensure ->real_parent has not passed
-		 * exit_ptrace(). Otherwise we don't report the error but
-		 * pretend ->real_parent untraces us right after return.
-		 */
-		if (!ret && !(current->real_parent->flags & PF_EXITING)) {
-			current->ptrace |= PT_PTRACED;
-			__ptrace_link(current, current->real_parent);
-		}
-
-		write_unlock_irqrestore(&tasklist_lock, flags);
-	}
-	task_unlock(current);
-	return ret;
-}
