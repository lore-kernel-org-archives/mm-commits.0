From: akpm@linux-foundation.org
Subject: - ptrace-introduce-ptrace_reparented-helper.patch removed from -mm tree
Date: Thu, 01 May 2008 02:27:35 -0700
Message-ID: <200805010927.m419RZqW030430@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35620 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757353AbYEAJ2V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:28:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ptrace: introduce ptrace_reparented() helper
has been removed from the -mm tree.  Its filename was
     ptrace-introduce-ptrace_reparented-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace: introduce ptrace_reparented() helper
From: Oleg Nesterov <oleg@tv-sign.ru>

Add another trivial helper for the sake of grep.  It also auto-documents the
fact that ->parent != real_parent implies ->ptrace.

No functional changes.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ptrace.h |    4 ++++
 kernel/exit.c          |    9 ++++-----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff -puN include/linux/ptrace.h~ptrace-introduce-ptrace_reparented-helper include/linux/ptrace.h
--- a/include/linux/ptrace.h~ptrace-introduce-ptrace_reparented-helper
+++ a/include/linux/ptrace.h
@@ -98,6 +98,10 @@ extern void ptrace_untrace(struct task_s
 extern int ptrace_may_attach(struct task_struct *task);
 extern int __ptrace_may_attach(struct task_struct *task);
 
+static inline int ptrace_reparented(struct task_struct *child)
+{
+	return child->real_parent != child->parent;
+}
 static inline void ptrace_link(struct task_struct *child,
 			       struct task_struct *new_parent)
 {
diff -puN kernel/exit.c~ptrace-introduce-ptrace_reparented-helper kernel/exit.c
--- a/kernel/exit.c~ptrace-introduce-ptrace_reparented-helper
+++ a/kernel/exit.c
@@ -698,7 +698,7 @@ reparent_thread(struct task_struct *p, s
 	if (unlikely(traced)) {
 		/* Preserve ptrace links if someone else is tracing this child.  */
 		list_del_init(&p->ptrace_list);
-		if (p->parent != p->real_parent)
+		if (ptrace_reparented(p))
 			list_add(&p->ptrace_list, &p->real_parent->ptrace_children);
 	} else {
 		/* If this child is being traced, then we're the one tracing it
@@ -865,8 +865,8 @@ static void exit_notify(struct task_stru
 	 * only has special meaning to our real parent.
 	 */
 	if (!task_detached(tsk) && thread_group_empty(tsk)) {
-		int signal = (tsk->parent == tsk->real_parent)
-				? tsk->exit_signal : SIGCHLD;
+		int signal = ptrace_reparented(tsk) ?
+				SIGCHLD : tsk->exit_signal;
 		do_notify_parent(tsk, signal);
 	} else if (tsk->ptrace) {
 		do_notify_parent(tsk, SIGCHLD);
@@ -1269,8 +1269,7 @@ static int wait_task_zombie(struct task_
 		return 0;
 	}
 
-	/* traced means p->ptrace, but not vice versa */
-	traced = (p->real_parent != p->parent);
+	traced = ptrace_reparented(p);
 
 	if (likely(!traced)) {
 		struct signal_struct *psig;
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed.patch
workqueue-remove-redundant-function-invocation.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

