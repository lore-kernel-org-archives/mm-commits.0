From: akpm@linux-foundation.org
Subject: + ptrace-kill-__ptrace_detach-fix-exit_state-check.patch added to -mm tree
Date: Thu, 29 Jan 2009 00:43:49 -0800
Message-ID: <200901290843.n0T8hn74002853@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40340 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752522AbZA2Iof (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Jan 2009 03:44:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, dvlasenk@redhat.com, jmarchan@redhat.com, roland@redhat.com


The patch titled
     ptrace: kill __ptrace_detach(), fix ->exit_state check
has been added to the -mm tree.  Its filename is
     ptrace-kill-__ptrace_detach-fix-exit_state-check.patch

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
Subject: ptrace: kill __ptrace_detach(), fix ->exit_state check
From: Oleg Nesterov <oleg@redhat.com>

Move the code from __ptrace_detach() to its single caller and kill this
helper.

Also, fix the ->exit_state check, we shouldn't wake up EXIT_DEAD tasks. 
Actually, I think task_is_stopped_or_traced() makes more sense, but this
needs another patch.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |   22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff -puN kernel/ptrace.c~ptrace-kill-__ptrace_detach-fix-exit_state-check kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace-kill-__ptrace_detach-fix-exit_state-check
+++ a/kernel/ptrace.c
@@ -235,16 +235,6 @@ out:
 	return retval;
 }
 
-static inline void __ptrace_detach(struct task_struct *child, unsigned int data)
-{
-	child->exit_code = data;
-	/* .. re-parent .. */
-	__ptrace_unlink(child);
-	/* .. and wake it up. */
-	if (child->exit_state != EXIT_ZOMBIE)
-		wake_up_process(child);
-}
-
 int ptrace_detach(struct task_struct *child, unsigned int data)
 {
 	if (!valid_signal(data))
@@ -254,10 +244,16 @@ int ptrace_detach(struct task_struct *ch
 	ptrace_disable(child);
 	clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
 
-	write_lock_irq(&tasklist_lock);
 	/* protect against de_thread()->release_task() */
-	if (child->ptrace)
-		__ptrace_detach(child, data);
+	write_lock_irq(&tasklist_lock);
+	if (child->ptrace) {
+		child->exit_code = data;
+
+		__ptrace_unlink(child);
+
+		if (!child->exit_state)
+			wake_up_process(child);
+	}
 	write_unlock_irq(&tasklist_lock);
 
 	return 0;
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

