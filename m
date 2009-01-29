From: akpm@linux-foundation.org
Subject: + ptrace-fix-possible-zombie-leak-on-ptrace_detach.patch added to -mm tree
Date: Thu, 29 Jan 2009 00:43:55 -0800
Message-ID: <200901290843.n0T8htOk002990@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51507 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753018AbZA2Ioj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Jan 2009 03:44:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, dvlasenk@redhat.com, jmarchan@redhat.com, roland@redhat.com


The patch titled
     ptrace: fix possible zombie leak on PTRACE_DETACH
has been added to the -mm tree.  Its filename is
     ptrace-fix-possible-zombie-leak-on-ptrace_detach.patch

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
Subject: ptrace: fix possible zombie leak on PTRACE_DETACH
From: Oleg Nesterov <oleg@redhat.com>

When ptrace_detach() takes tasklist, the tracee can be SIGKILL'ed.  If it
has already passed exit_notify() we can leak a zombie, because a) ptracing
disables the auto-reaping logic, and b) ->real_parent was not notified
about the child's death.

ptrace_detach() should follow the ptrace_exit's logic, change the code
accordingly.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ptrace.h |    1 +
 kernel/ptrace.c        |    9 +++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff -puN include/linux/ptrace.h~ptrace-fix-possible-zombie-leak-on-ptrace_detach include/linux/ptrace.h
--- a/include/linux/ptrace.h~ptrace-fix-possible-zombie-leak-on-ptrace_detach
+++ a/include/linux/ptrace.h
@@ -94,6 +94,7 @@ extern void ptrace_notify(int exit_code)
 extern void __ptrace_link(struct task_struct *child,
 			  struct task_struct *new_parent);
 extern void __ptrace_unlink(struct task_struct *child);
+extern int __ptrace_detach(struct task_struct *tracer, struct task_struct *p);
 extern void ptrace_fork(struct task_struct *task, unsigned long clone_flags);
 #define PTRACE_MODE_READ   1
 #define PTRACE_MODE_ATTACH 2
diff -puN kernel/ptrace.c~ptrace-fix-possible-zombie-leak-on-ptrace_detach kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace-fix-possible-zombie-leak-on-ptrace_detach
+++ a/kernel/ptrace.c
@@ -237,6 +237,8 @@ out:
 
 int ptrace_detach(struct task_struct *child, unsigned int data)
 {
+	int dead = 0;
+
 	if (!valid_signal(data))
 		return -EIO;
 
@@ -244,18 +246,21 @@ int ptrace_detach(struct task_struct *ch
 	ptrace_disable(child);
 	clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
 
-	/* protect against de_thread()->release_task() */
 	write_lock_irq(&tasklist_lock);
+	/* protect against de_thread()->release_task() */
 	if (child->ptrace) {
 		child->exit_code = data;
 
-		__ptrace_unlink(child);
+		dead = __ptrace_detach(current, child);
 
 		if (!child->exit_state)
 			wake_up_process(child);
 	}
 	write_unlock_irq(&tasklist_lock);
 
+	if (unlikely(dead))
+		release_task(child);
+
 	return 0;
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

