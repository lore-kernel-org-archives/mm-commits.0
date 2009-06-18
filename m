From: akpm@linux-foundation.org
Subject: [merged] ptrace-ptrace_attach-check-pf_kthread-exit_state-instead-of-mm.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:46:34 -0700
Message-ID: <200906182246.n5IMkYSO005595@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44047 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759064AbZFRWsJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:48:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, chrisw@sous-sol.org, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ptrace: ptrace_attach: check PF_KTHREAD + exit_state instead of ->mm
has been removed from the -mm tree.  Its filename was
     ptrace-ptrace_attach-check-pf_kthread-exit_state-instead-of-mm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace: ptrace_attach: check PF_KTHREAD + exit_state instead of ->mm
From: Oleg Nesterov <oleg@redhat.com>

- Add PF_KTHREAD check to prevent attaching to the kernel thread
  with a borrowed ->mm.

  With or without this change we can race with daemonize() which
  can set PF_KTHREAD or clear ->mm after ptrace_attach() does the
  check, but this doesn't matter because reparent_to_kthreadd()
  does ptrace_unlink().

- Kill "!task->mm" check. We don't really care about ->mm != NULL,
  and the task can call exit_mm() right after we drop task_lock().
  What we need is to make sure we can't attach after exit_notify(),
  check task->exit_state != 0 instead.

Also, move the "already traced" check down for cosmetic reasons.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff -puN kernel/ptrace.c~ptrace-ptrace_attach-check-pf_kthread-exit_state-instead-of-mm kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace-ptrace_attach-check-pf_kthread-exit_state-instead-of-mm
+++ a/kernel/ptrace.c
@@ -172,6 +172,8 @@ int ptrace_attach(struct task_struct *ta
 	audit_ptrace(task);
 
 	retval = -EPERM;
+	if (unlikely(task->flags & PF_KTHREAD))
+		goto out;
 	if (same_thread_group(task, current))
 		goto out;
 
@@ -182,8 +184,6 @@ int ptrace_attach(struct task_struct *ta
 	retval = mutex_lock_interruptible(&task->cred_guard_mutex);
 	if (retval  < 0)
 		goto out;
-
-	retval = -EPERM;
 repeat:
 	/*
 	 * Nasty, nasty.
@@ -203,23 +203,24 @@ repeat:
 		goto repeat;
 	}
 
-	if (!task->mm)
-		goto bad;
-	/* the same process cannot be attached many times */
-	if (task->ptrace & PT_PTRACED)
-		goto bad;
 	retval = __ptrace_may_access(task, PTRACE_MODE_ATTACH);
 	if (retval)
 		goto bad;
 
-	/* Go */
+	retval = -EPERM;
+	if (unlikely(task->exit_state))
+		goto bad;
+	if (task->ptrace & PT_PTRACED)
+		goto bad;
+
 	task->ptrace |= PT_PTRACED;
 	if (capable(CAP_SYS_PTRACE))
 		task->ptrace |= PT_PTRACE_CAP;
 
 	__ptrace_link(task, current);
