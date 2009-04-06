From: akpm@linux-foundation.org
Subject: [merged] ptrace-fix-possible-zombie-leak-on-ptrace_detach.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:35:40 -0700
Message-ID: <200904061935.n36JZe9U012137@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47157 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757943AbZDFTjq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:39:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, dvlasenk@redhat.com, jmarchan@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ptrace: fix possible zombie leak on PTRACE_DETACH
has been removed from the -mm tree.  Its filename was
     ptrace-fix-possible-zombie-leak-on-ptrace_detach.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Tested-by: Denys Vlasenko <dvlasenk@redhat.com>
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

origin.patch
linux-next.patch
getrusage-fill-ru_maxrss-value.patch
signals-split-do_tkill.patch
signals-implement-sys_rt_tgsigqueueinfo.patch
x86-hookup-sys_rt_tgsigqueueinfo.patch
signals-tracehook_notify_jctl-change.patch

