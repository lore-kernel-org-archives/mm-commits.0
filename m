From: akpm@linux-foundation.org
Subject: [merged] ptrace-do-not-use-task-ptrace-directly-in-core-kernel.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:46:32 -0700
Message-ID: <200906182246.n5IMkWrd005591@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44395 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758440AbZFRW6I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:58:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ptrace: do not use task->ptrace directly in core kernel
has been removed from the -mm tree.  Its filename was
     ptrace-do-not-use-task-ptrace-directly-in-core-kernel.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace: do not use task->ptrace directly in core kernel
From: Oleg Nesterov <oleg@redhat.com>

No functional changes.

- Nobody except ptrace.c & co should use ptrace flags directly, we have
  task_ptrace() for that.

- No need to specially check PT_PTRACED, we must not have other PT_ bits
  set without PT_PTRACED. And no need to know this flag exists.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c   |    6 +++---
 kernel/signal.c |   10 +++++-----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff -puN kernel/exit.c~ptrace-do-not-use-task-ptrace-directly-in-core-kernel kernel/exit.c
--- a/kernel/exit.c~ptrace-do-not-use-task-ptrace-directly-in-core-kernel
+++ a/kernel/exit.c
@@ -757,7 +757,7 @@ static void reparent_thread(struct task_
 	p->exit_signal = SIGCHLD;
 
 	/* If it has exited notify the new parent about this child's death. */
-	if (!p->ptrace &&
+	if (!task_ptrace(p) &&
 	    p->exit_state == EXIT_ZOMBIE && thread_group_empty(p)) {
 		do_notify_parent(p, p->exit_signal);
 		if (task_detached(p)) {
@@ -782,7 +782,7 @@ static void forget_original_parent(struc
 	list_for_each_entry_safe(p, n, &father->children, sibling) {
 		p->real_parent = reaper;
 		if (p->parent == father) {
-			BUG_ON(p->ptrace);
+			BUG_ON(task_ptrace(p));
 			p->parent = p->real_parent;
 		}
 		reparent_thread(father, p, &dead_children);
@@ -1482,7 +1482,7 @@ static int wait_consider_task(struct tas
 		return 0;
 	}
 
-	if (likely(!ptrace) && unlikely(p->ptrace)) {
+	if (likely(!ptrace) && unlikely(task_ptrace(p))) {
 		/*
 		 * This child is hidden by ptrace.
 		 * We aren't allowed to see it now, but eventually we will.
diff -puN kernel/signal.c~ptrace-do-not-use-task-ptrace-directly-in-core-kernel kernel/signal.c
--- a/kernel/signal.c~ptrace-do-not-use-task-ptrace-directly-in-core-kernel
+++ a/kernel/signal.c
@@ -1410,7 +1410,7 @@ int do_notify_parent(struct task_struct 
  	/* do_notify_parent_cldstop should have been called instead.  */
  	BUG_ON(task_is_stopped_or_traced(tsk));
 
-	BUG_ON(!tsk->ptrace &&
+	BUG_ON(!task_ptrace(tsk) &&
 	       (tsk->group_leader != tsk || !thread_group_empty(tsk)));
 
 	info.si_signo = sig;
@@ -1449,7 +1449,7 @@ int do_notify_parent(struct task_struct 
 
 	psig = tsk->parent->sighand;
 	spin_lock_irqsave(&psig->siglock, flags);
-	if (!tsk->ptrace && sig == SIGCHLD &&
+	if (!task_ptrace(tsk) && sig == SIGCHLD &&
 	    (psig->action[SIGCHLD-1].sa.sa_handler == SIG_IGN ||
 	     (psig->action[SIGCHLD-1].sa.sa_flags & SA_NOCLDWAIT))) {
 		/*
@@ -1486,7 +1486,7 @@ static void do_notify_parent_cldstop(str
 	struct task_struct *parent;
 	struct sighand_struct *sighand;
 
-	if (tsk->ptrace & PT_PTRACED)
+	if (task_ptrace(tsk))
 		parent = tsk->parent;
 	else {
 		tsk = tsk->group_leader;
@@ -1535,7 +1535,7 @@ static void do_notify_parent_cldstop(str
 
 static inline int may_ptrace_stop(void)
 {
-	if (!likely(current->ptrace & PT_PTRACED))
+	if (!likely(task_ptrace(current)))
 		return 0;
 	/*
 	 * Are we in the middle of do_coredump?
@@ -1753,7 +1753,7 @@ static int do_signal_stop(int signr)
 static int ptrace_signal(int signr, siginfo_t *info,
 			 struct pt_regs *regs, void *cookie)
 {
-	if (!(current->ptrace & PT_PTRACED))
+	if (!task_ptrace(current))
 		return signr;
 
 	ptrace_signal_deliver(regs, cookie);
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
ptrace-wait_task_zombie-do-not-account-traced-sub-threads.patch
linux-next.patch
rework-fix-is_single_threaded.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
signals-tracehook_notify_jctl-change.patch
utrace-core.patch

