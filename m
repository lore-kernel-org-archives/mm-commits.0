From: akpm@linux-foundation.org
Subject: + ptrace-do-not-use-task-ptrace-directly-in-core-kernel.patch added to -mm tree
Date: Wed, 29 Apr 2009 14:50:15 -0700
Message-ID: <200904292150.n3TLoF4d013908@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40083 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753840AbZD2Vv7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Apr 2009 17:51:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, roland@redhat.com


The patch titled
     ptrace: do not use task->ptrace directly in core kernel
has been added to the -mm tree.  Its filename is
     ptrace-do-not-use-task-ptrace-directly-in-core-kernel.patch

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
 kernel/fork.c   |    2 +-
 kernel/signal.c |   10 +++++-----
 3 files changed, 9 insertions(+), 9 deletions(-)

diff -puN kernel/exit.c~ptrace-do-not-use-task-ptrace-directly-in-core-kernel kernel/exit.c
--- a/kernel/exit.c~ptrace-do-not-use-task-ptrace-directly-in-core-kernel
+++ a/kernel/exit.c
@@ -753,7 +753,7 @@ static void reparent_thread(struct task_
 	p->exit_signal = SIGCHLD;
 
 	/* If it has exited notify the new parent about this child's death. */
-	if (!p->ptrace &&
+	if (!task_ptrace(p) &&
 	    p->exit_state == EXIT_ZOMBIE && thread_group_empty(p)) {
 		do_notify_parent(p, p->exit_signal);
 		if (task_detached(p)) {
@@ -778,7 +778,7 @@ static void forget_original_parent(struc
 	list_for_each_entry_safe(p, n, &father->children, sibling) {
 		p->real_parent = reaper;
 		if (p->parent == father) {
-			BUG_ON(p->ptrace);
+			BUG_ON(task_ptrace(p));
 			p->parent = p->real_parent;
 		}
 		reparent_thread(father, p, &dead_children);
@@ -1484,7 +1484,7 @@ static int wait_consider_task(struct tas
 			*notask_error = ret;
 	}
 
-	if (likely(!ptrace) && unlikely(p->ptrace)) {
+	if (likely(!ptrace) && unlikely(task_ptrace(p))) {
 		/*
 		 * This child is hidden by ptrace.
 		 * We aren't allowed to see it now, but eventually we will.
diff -puN kernel/fork.c~ptrace-do-not-use-task-ptrace-directly-in-core-kernel kernel/fork.c
--- a/kernel/fork.c~ptrace-do-not-use-task-ptrace-directly-in-core-kernel
+++ a/kernel/fork.c
@@ -1089,7 +1089,7 @@ static struct task_struct *copy_process(
 #ifdef CONFIG_DEBUG_MUTEXES
 	p->blocked_on = NULL; /* not blocked yet */
 #endif
-	if (unlikely(current->ptrace))
+	if (unlikely(task_ptrace(current)))
 		ptrace_fork(p, clone_flags);
 
 	/* Perform scheduler related setup. Assign this task to a CPU. */
diff -puN kernel/signal.c~ptrace-do-not-use-task-ptrace-directly-in-core-kernel kernel/signal.c
--- a/kernel/signal.c~ptrace-do-not-use-task-ptrace-directly-in-core-kernel
+++ a/kernel/signal.c
@@ -1400,7 +1400,7 @@ int do_notify_parent(struct task_struct 
  	/* do_notify_parent_cldstop should have been called instead.  */
  	BUG_ON(task_is_stopped_or_traced(tsk));
 
-	BUG_ON(!tsk->ptrace &&
+	BUG_ON(!task_ptrace(tsk) &&
 	       (tsk->group_leader != tsk || !thread_group_empty(tsk)));
 
 	info.si_signo = sig;
@@ -1439,7 +1439,7 @@ int do_notify_parent(struct task_struct 
 
 	psig = tsk->parent->sighand;
 	spin_lock_irqsave(&psig->siglock, flags);
-	if (!tsk->ptrace && sig == SIGCHLD &&
+	if (!task_ptrace(tsk) && sig == SIGCHLD &&
 	    (psig->action[SIGCHLD-1].sa.sa_handler == SIG_IGN ||
 	     (psig->action[SIGCHLD-1].sa.sa_flags & SA_NOCLDWAIT))) {
 		/*
@@ -1476,7 +1476,7 @@ static void do_notify_parent_cldstop(str
 	struct task_struct *parent;
 	struct sighand_struct *sighand;
 
-	if (tsk->ptrace & PT_PTRACED)
+	if (task_ptrace(tsk))
 		parent = tsk->parent;
 	else {
 		tsk = tsk->group_leader;
@@ -1525,7 +1525,7 @@ static void do_notify_parent_cldstop(str
 
 static inline int may_ptrace_stop(void)
 {
-	if (!likely(current->ptrace & PT_PTRACED))
+	if (!likely(task_ptrace(current)))
 		return 0;
 	/*
 	 * Are we in the middle of do_coredump?
@@ -1743,7 +1743,7 @@ static int do_signal_stop(int signr)
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
maintainers-add-ptrace-entry.patch
linux-next.patch
ptrace-s-parent-real_parent-in-binfmt_elf_fdpicc.patch
slow_work_thread-should-do-the-exclusive-wait.patch
rework-fix-is_single_threaded.patch
getrusage-fill-ru_maxrss-value.patch
ptrace-remove-pt_dtrace-from-arch-h8300.patch
ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa.patch
ptrace-remove-pt_dtrace-from-m68k-m68knommu.patch
ptrace-remove-pt_dtrace-from-arch-m32r.patch
ptrace-mm_need_new_owner-use-real_parent-to-search-in-the-siblings.patch
ptrace-tracehook_unsafe_exec-remove-the-stale-comment.patch
ptrace-tracehook_unsafe_exec-remove-the-stale-comment-fix.patch
ptrace-do-not-use-task-ptrace-directly-in-core-kernel.patch
copy_process-remove-the-unneeded-clear_tsk_thread_flagtif_sigpending.patch
elf_core_dump-use-rcu_read_lock-to-access-real_parent.patch
kthreads-simplify-the-startup-synchronization.patch
kthreads-rework-kthread_stop.patch
kthreads-simplify-migration_thread-exit-path.patch
signals-split-do_tkill.patch
signals-implement-sys_rt_tgsigqueueinfo.patch
x86-hookup-sys_rt_tgsigqueueinfo.patch
signals-tracehook_notify_jctl-change.patch

