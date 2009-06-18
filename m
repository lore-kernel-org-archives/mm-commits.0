From: akpm@linux-foundation.org
Subject: [merged] ptrace-do-not-use-task_lock-for-attach.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:46:39 -0700
Message-ID: <200906182246.n5IMkdDh005721@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48399 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759049AbZFRWsJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:48:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, chrisw@sous-sol.org, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ptrace: do not use task_lock() for attach
has been removed from the -mm tree.  Its filename was
     ptrace-do-not-use-task_lock-for-attach.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace: do not use task_lock() for attach
From: Oleg Nesterov <oleg@redhat.com>

Remove the "Nasty, nasty" lock dance in ptrace_attach()/ptrace_traceme() -
from now task_lock() has nothing to do with ptrace at all.

With the recent changes nobody uses task_lock() to serialize with ptrace,
but in fact it was never needed and it was never used consistently.

However ptrace_attach() calls __ptrace_may_access() and needs task_lock()
to pin task->mm for get_dumpable().  But we can call __ptrace_may_access()
before we take tasklist_lock, ->cred_exec_mutex protects us against
do_execve() path which can change creds and MMF_DUMP* flags.

(ugly, but we can't use ptrace_may_access() because it hides the error
code, so we have to take task_lock() and use __ptrace_may_access()).

NOTE: this change assumes that LSM hooks, security_ptrace_may_access() and
security_ptrace_traceme(), can be called without task_lock() held.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |   59 ++++++++++------------------------------------
 1 file changed, 13 insertions(+), 46 deletions(-)

diff -puN kernel/ptrace.c~ptrace-do-not-use-task_lock-for-attach kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace-do-not-use-task_lock-for-attach
+++ a/kernel/ptrace.c
@@ -167,7 +167,6 @@ bool ptrace_may_access(struct task_struc
 int ptrace_attach(struct task_struct *task)
 {
 	int retval;
-	unsigned long flags;
 
 	audit_ptrace(task);
 
@@ -185,34 +184,19 @@ int ptrace_attach(struct task_struct *ta
 	retval = mutex_lock_interruptible(&task->cred_guard_mutex);
 	if (retval < 0)
 		goto out;
-repeat:
-	/*
-	 * Nasty, nasty.
-	 *
-	 * We want to hold both the task-lock and the
-	 * tasklist_lock for writing at the same time.
-	 * But that's against the rules (tasklist_lock
-	 * is taken for reading by interrupts on other
-	 * cpu's that may have task_lock).
-	 */
-	task_lock(task);
-	if (!write_trylock_irqsave(&tasklist_lock, flags)) {
-		task_unlock(task);
-		do {
-			cpu_relax();
-		} while (!write_can_lock(&tasklist_lock));
-		goto repeat;
-	}
 
+	task_lock(task);
 	retval = __ptrace_may_access(task, PTRACE_MODE_ATTACH);
+	task_unlock(task);
 	if (retval)
-		goto bad;
+		goto unlock_creds;
 
+	write_lock_irq(&tasklist_lock);
 	retval = -EPERM;
 	if (unlikely(task->exit_state))
-		goto bad;
+		goto unlock_tasklist;
 	if (task->ptrace)
-		goto bad;
+		goto unlock_tasklist;
 
 	task->ptrace = PT_PTRACED;
 	if (capable(CAP_SYS_PTRACE))
@@ -222,9 +206,9 @@ repeat:
 	send_sig_info(SIGSTOP, SEND_SIG_FORCED, task);
 
 	retval = 0;
-bad:
-	write_unlock_irqrestore(&tasklist_lock, flags);
-	task_unlock(task);
+unlock_tasklist:
+	write_unlock_irq(&tasklist_lock);
+unlock_creds:
 	mutex_unlock(&task->cred_guard_mutex);
 out:
 	return retval;
@@ -240,26 +224,10 @@ int ptrace_traceme(void)
 {
 	int ret = -EPERM;
 
-	/*
-	 * Are we already being traced?
-	 */
-repeat:
-	task_lock(current);
+	write_lock_irq(&tasklist_lock);
+	/* Are we already being traced? */
 	if (!current->ptrace) {
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
 		ret = security_ptrace_traceme(current->parent);
-
 		/*
 		 * Check PF_EXITING to ensure ->real_parent has not passed
 		 * exit_ptrace(). Otherwise we don't report the error but
@@ -269,10 +237,9 @@ repeat:
 			current->ptrace = PT_PTRACED;
 			__ptrace_link(current, current->real_parent);
 		}
