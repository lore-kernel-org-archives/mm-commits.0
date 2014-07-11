From: akpm@linux-foundation.org
Subject: + kernel-exit-fix-coding-style-warnings-and-errors.patch added to -mm tree
Date: Fri, 11 Jul 2014 14:59:42 -0700
Message-ID: <53c05e4e.QBLKetGNSST3sjtP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f73.google.com ([209.85.219.73]:57799 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbaGKV7n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Jul 2014 17:59:43 -0400
Received: by mail-oa0-f73.google.com with SMTP id g18so358739oah.4
        for <mm-commits@vger.kernel.org>; Fri, 11 Jul 2014 14:59:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ionut.m.alexa@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/exit.c: fix coding style warnings and errors
has been added to the -mm tree.  Its filename is
     kernel-exit-fix-coding-style-warnings-and-errors.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-exit-fix-coding-style-warnings-and-errors.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-exit-fix-coding-style-warnings-and-errors.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ionut Alexa <ionut.m.alexa@gmail.com>
Subject: kernel/exit.c: fix coding style warnings and errors

Fixed coding style warnings and errors.

Signed-off-by: Ionut Alexa <ionut.m.alexa@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   49 +++++++++++++++++++++++++-----------------------
 1 file changed, 26 insertions(+), 23 deletions(-)

diff -puN kernel/exit.c~kernel-exit-fix-coding-style-warnings-and-errors kernel/exit.c
--- a/kernel/exit.c~kernel-exit-fix-coding-style-warnings-and-errors
+++ a/kernel/exit.c
@@ -59,7 +59,7 @@
 #include <asm/pgtable.h>
 #include <asm/mmu_context.h>
 
-static void exit_mm(struct task_struct * tsk);
+static void exit_mm(struct task_struct *tsk);
 
 static void __unhash_process(struct task_struct *p, bool group_dead)
 {
@@ -151,7 +151,7 @@ static void __exit_signal(struct task_st
 	spin_unlock(&sighand->siglock);
 
 	__cleanup_sighand(sighand);
-	clear_tsk_thread_flag(tsk,TIF_SIGPENDING);
+	clear_tsk_thread_flag(tsk, TIF_SIGPENDING);
 	if (group_dead) {
 		flush_sigqueue(&sig->shared_pending);
 		tty_kref_put(tty);
@@ -168,7 +168,7 @@ static void delayed_put_task_struct(stru
 }
 
 
-void release_task(struct task_struct * p)
+void release_task(struct task_struct *p)
 {
 	struct task_struct *leader;
 	int zap_leader;
@@ -192,7 +192,8 @@ repeat:
 	 */
 	zap_leader = 0;
 	leader = p->group_leader;
-	if (leader != p && thread_group_empty(leader) && leader->exit_state == EXIT_ZOMBIE) {
+	if (leader != p && thread_group_empty(leader)
+			&& leader->exit_state == EXIT_ZOMBIE) {
 		/*
 		 * If we were the last child thread and the leader has
 		 * exited already, and the leader's parent ignores SIGCHLD,
@@ -241,7 +242,8 @@ struct pid *session_of_pgrp(struct pid *
  *
  * "I ask you, have you ever known what it is to be an orphan?"
  */
-static int will_become_orphaned_pgrp(struct pid *pgrp, struct task_struct *ignored_task)
+static int will_become_orphaned_pgrp(struct pid *pgrp,
+					struct task_struct *ignored_task)
 {
 	struct task_struct *p;
 
@@ -294,9 +296,9 @@ kill_orphaned_pgrp(struct task_struct *t
 	struct task_struct *ignored_task = tsk;
 
 	if (!parent)
-		 /* exit: our father is in a different pgrp than
-		  * we are and we were the only connection outside.
-		  */
+		/* exit: our father is in a different pgrp than
+		 * we are and we were the only connection outside.
+		 */
 		parent = tsk->real_parent;
 	else
 		/* reparent: our child is in a different pgrp than
@@ -405,7 +407,7 @@ assign_new_owner:
  * Turn us into a lazy TLB process if we
  * aren't already..
  */
-static void exit_mm(struct task_struct * tsk)
+static void exit_mm(struct task_struct *tsk)
 {
 	struct mm_struct *mm = tsk->mm;
 	struct core_state *core_state;
@@ -425,6 +427,7 @@ static void exit_mm(struct task_struct *
 	core_state = mm->core_state;
 	if (core_state) {
 		struct core_thread self;
+
 		up_read(&mm->mmap_sem);
 
 		self.task = tsk;
@@ -565,6 +568,7 @@ static void forget_original_parent(struc
 
 	list_for_each_entry_safe(p, n, &father->children, sibling) {
 		struct task_struct *t = p;
+
 		do {
 			t->real_parent = reaper;
 			if (t->parent == father) {
@@ -598,7 +602,7 @@ static void exit_notify(struct task_stru
 	/*
 	 * This does two things:
 	 *
-  	 * A.  Make init inherit all the child processes
+	 * A.  Make init inherit all the child processes
 	 * B.  Check to see if any process groups have become orphaned
 	 *	as a result of our exiting, and if they have any stopped
 	 *	jobs, send them a SIGHUP and then a SIGCONT.  (POSIX 3.2.2.2)
@@ -648,9 +652,8 @@ static void check_stack_usage(void)
 
 	spin_lock(&low_water_lock);
 	if (free < lowest_to_date) {
-		printk(KERN_WARNING "%s (%d) used greatest stack depth: "
-				"%lu bytes left\n",
-				current->comm, task_pid_nr(current), free);
+		pr_warn("%s (%d) used greatest stack depth: %lu bytes left\n",
+			current->comm, task_pid_nr(current), free);
 		lowest_to_date = free;
 	}
 	spin_unlock(&low_water_lock);
@@ -691,8 +694,7 @@ void do_exit(long code)
 	 * leave this task alone and wait for reboot.
 	 */
 	if (unlikely(tsk->flags & PF_EXITING)) {
-		printk(KERN_ALERT
-			"Fixing recursive fault but reboot is needed!\n");
+		pr_alert("Fixing recursive fault but reboot is needed!\n");
 		/*
 		 * We can do this unlocked here. The futex code uses
 		 * this flag just to verify whether the pi state
@@ -716,9 +718,9 @@ void do_exit(long code)
 	raw_spin_unlock_wait(&tsk->pi_lock);
 
 	if (unlikely(in_atomic()))
-		printk(KERN_INFO "note: %s[%d] exited with preempt_count %d\n",
-				current->comm, task_pid_nr(current),
-				preempt_count());
+		pr_info("note: %s[%d] exited with preempt_count %d\n",
+			current->comm, task_pid_nr(current),
+			preempt_count());
 
 	acct_update_integrals(tsk);
 	/* sync mm's RSS info before statistics gathering */
@@ -836,7 +838,6 @@ void do_exit(long code)
 	for (;;)
 		cpu_relax();	/* For when BUG is null */
 }
-
 EXPORT_SYMBOL_GPL(do_exit);
 
 void complete_and_exit(struct completion *comp, long code)
@@ -846,7 +847,6 @@ void complete_and_exit(struct completion
 
 	do_exit(code);
 }
-
 EXPORT_SYMBOL(complete_and_exit);
 
 SYSCALL_DEFINE1(exit, int, error_code)
@@ -869,6 +869,7 @@ do_group_exit(int exit_code)
 		exit_code = sig->group_exit_code;
 	else if (!thread_group_empty(current)) {
 		struct sighand_struct *const sighand = current->sighand;
+
 		spin_lock_irq(&sighand->siglock);
 		if (signal_group_exit(sig))
 			/* Another thread got here before we took the lock.  */
@@ -1033,9 +1034,9 @@ static int wait_task_zombie(struct wait_
 		 * as other threads in the parent group can be right
 		 * here reaping other children at the same time.
 		 *
-		 * We use thread_group_cputime_adjusted() to get times for the thread
-		 * group, which consolidates times for all threads in the
-		 * group including the group leader.
+		 * We use thread_group_cputime_adjusted() to get times for
+		 * the thread group, which consolidates times for all threads
+		 * in the group including the group leader.
 		 */
 		thread_group_cputime_adjusted(p, &tgutime, &tgstime);
 		spin_lock_irq(&p->real_parent->sighand->siglock);
@@ -1417,6 +1418,7 @@ static int do_wait_thread(struct wait_op
 
 	list_for_each_entry(p, &tsk->children, sibling) {
 		int ret = wait_consider_task(wo, 0, p);
+
 		if (ret)
 			return ret;
 	}
@@ -1430,6 +1432,7 @@ static int ptrace_do_wait(struct wait_op
 
 	list_for_each_entry(p, &tsk->ptraced, ptrace_entry) {
 		int ret = wait_consider_task(wo, 1, p);
+
 		if (ret)
 			return ret;
 	}
_

Patches currently in -mm which might be from ionut.m.alexa@gmail.com are

kernel-exit-fix-coding-style-warnings-and-errors.patch

