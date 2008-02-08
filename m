From: akpm@linux-foundation.org
Subject: - kill-pt_attached.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:13:21 -0800
Message-ID: <200802082013.m18KD2Bu010257@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52411 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757531AbYBHVB1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 16:01:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, hch@lst.de, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     kill PT_ATTACHED
has been removed from the -mm tree.  Its filename was
     kill-pt_attached.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kill PT_ATTACHED
From: Oleg Nesterov <oleg@tv-sign.ru>

Since the patch

	"Fix ptrace_attach()/ptrace_traceme()/de_thread() race"
	commit f5b40e363ad6041a96e3da32281d8faa191597b9

we set PT_ATTACHED and change child->parent "atomically" wrt task_list lock.

This means we can remove the checks like "PT_ATTACHED && ->parent != ptracer"
which were needed to catch the "ptrace attach is in progress" case.  We can
also remove the flag itself since nobody else uses it.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ptrace.h |    1 -
 kernel/exit.c          |   13 +------------
 kernel/ptrace.c        |    6 ++----
 kernel/signal.c        |    5 -----
 4 files changed, 3 insertions(+), 22 deletions(-)

diff -puN include/linux/ptrace.h~kill-pt_attached include/linux/ptrace.h
--- a/include/linux/ptrace.h~kill-pt_attached
+++ a/include/linux/ptrace.h
@@ -67,7 +67,6 @@
 #define PT_TRACE_EXEC	0x00000080
 #define PT_TRACE_VFORK_DONE	0x00000100
 #define PT_TRACE_EXIT	0x00000200
-#define PT_ATTACHED	0x00000400	/* parent != real_parent */
 
 #define PT_TRACE_MASK	0x000003f4
 
diff -puN kernel/exit.c~kill-pt_attached kernel/exit.c
--- a/kernel/exit.c~kill-pt_attached
+++ a/kernel/exit.c
@@ -1514,18 +1514,7 @@ static int wait_task_continued(struct ta
 
 static inline int my_ptrace_child(struct task_struct *p)
 {
-	if (!(p->ptrace & PT_PTRACED))
-		return 0;
-	if (!(p->ptrace & PT_ATTACHED))
-		return 1;
-	/*
-	 * This child was PTRACE_ATTACH'd.  We should be seeing it only if
-	 * we are the attacher.  If we are the real parent, this is a race
-	 * inside ptrace_attach.  It is waiting for the tasklist_lock,
-	 * which we have to switch the parent links, but has already set
-	 * the flags in p->ptrace.
-	 */
-	return (p->parent != p->real_parent);
+	return p->ptrace & PT_PTRACED;
 }
 
 static long do_wait(pid_t pid, int options, struct siginfo __user *infop,
diff -puN kernel/ptrace.c~kill-pt_attached kernel/ptrace.c
--- a/kernel/ptrace.c~kill-pt_attached
+++ a/kernel/ptrace.c
@@ -100,8 +100,7 @@ int ptrace_check_attach(struct task_stru
 	 */
 	read_lock(&tasklist_lock);
 	if ((child->ptrace & PT_PTRACED) && child->parent == current &&
-	    (!(child->ptrace & PT_ATTACHED) || child->real_parent != current)
-	    && child->signal != NULL) {
+	     child->signal != NULL) {
 		ret = 0;
 		spin_lock_irq(&child->sighand->siglock);
 		if (task_is_stopped(child))
@@ -200,8 +199,7 @@ repeat:
 		goto bad;
 
 	/* Go */
-	task->ptrace |= PT_PTRACED | ((task->real_parent != current)
-				      ? PT_ATTACHED : 0);
+	task->ptrace |= PT_PTRACED;
 	if (capable(CAP_SYS_PTRACE))
 		task->ptrace |= PT_PTRACE_CAP;
 
diff -puN kernel/signal.c~kill-pt_attached kernel/signal.c
--- a/kernel/signal.c~kill-pt_attached
+++ a/kernel/signal.c
@@ -1556,11 +1556,6 @@ static inline int may_ptrace_stop(void)
 {
 	if (!likely(current->ptrace & PT_PTRACED))
 		return 0;
-
-	if (unlikely(current->parent == current->real_parent &&
-		    (current->ptrace & PT_ATTACHED)))
-		return 0;
-
 	/*
 	 * Are we in the middle of do_coredump?
 	 * If so and our tracer is also part of the coredump stopping
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
revert-proc-fix-the-threaded-proc-self.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
