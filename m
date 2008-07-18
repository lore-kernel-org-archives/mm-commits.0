From: akpm@linux-foundation.org
Subject: - ptrace-ptrace-children-revamp.patch removed from -mm tree
Date: Fri, 18 Jul 2008 16:24:37 -0700
Message-ID: <200807182324.m6INObDZ004218@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51335 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760573AbYGRXZ0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jul 2008 19:25:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     ptrace: ptrace children revamp
has been removed from the -mm tree.  Its filename was
     ptrace-ptrace-children-revamp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace: ptrace children revamp
From: Roland McGrath <roland@redhat.com>

ptrace no longer fiddles with the children/sibling links, and the old
ptrace_children list is gone.  Now ptrace, whether of one's own children
or another's via PTRACE_ATTACH, just uses the new ptraced list instead.

There should be no user-visible difference that matters.  The only change
is the order in which do_wait() sees multiple stopped children and stopped
ptrace attachees.  Since wait_task_stopped() was changed earlier so it no
longer reorders the children list, we already know this won't cause any
new problems.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/init_task.h |    4 
 include/linux/sched.h     |   26 +---
 kernel/exit.c             |  226 ++++++++++++++++++------------------
 kernel/fork.c             |    6 
 kernel/ptrace.c           |   37 +++--
 5 files changed, 160 insertions(+), 139 deletions(-)

diff -puN include/linux/init_task.h~ptrace-ptrace-children-revamp include/linux/init_task.h
--- a/include/linux/init_task.h~ptrace-ptrace-children-revamp
+++ a/include/linux/init_task.h
@@ -140,8 +140,8 @@ extern struct group_info init_groups;
 		.nr_cpus_allowed = NR_CPUS,				\
 	},								\
 	.tasks		= LIST_HEAD_INIT(tsk.tasks),			\
-	.ptrace_children= LIST_HEAD_INIT(tsk.ptrace_children),		\
-	.ptrace_list	= LIST_HEAD_INIT(tsk.ptrace_list),		\
+	.ptraced	= LIST_HEAD_INIT(tsk.ptraced),			\
+	.ptrace_entry	= LIST_HEAD_INIT(tsk.ptrace_entry),		\
 	.real_parent	= &tsk,						\
 	.parent		= &tsk,						\
 	.children	= LIST_HEAD_INIT(tsk.children),			\
diff -puN include/linux/sched.h~ptrace-ptrace-children-revamp include/linux/sched.h
--- a/include/linux/sched.h~ptrace-ptrace-children-revamp
+++ a/include/linux/sched.h
@@ -1063,12 +1063,6 @@ struct task_struct {
 #endif
 
 	struct list_head tasks;
-	/*
-	 * ptrace_list/ptrace_children forms the list of my children
-	 * that were stolen by a ptracer.
-	 */
-	struct list_head ptrace_children;
-	struct list_head ptrace_list;
 
 	struct mm_struct *mm, *active_mm;
 
@@ -1089,18 +1083,25 @@ struct task_struct {
 	/* 
 	 * pointers to (original) parent process, youngest child, younger sibling,
 	 * older sibling, respectively.  (p->father can be replaced with 
-	 * p->parent->pid)
+	 * p->real_parent->pid)
 	 */
-	struct task_struct *real_parent; /* real parent process (when being debugged) */
-	struct task_struct *parent;	/* parent process */
+	struct task_struct *real_parent; /* real parent process */
+	struct task_struct *parent; /* recipient of SIGCHLD, wait4() reports */
 	/*
-	 * children/sibling forms the list of my children plus the
-	 * tasks I'm ptracing.
+	 * children/sibling forms the list of my natural children
 	 */
 	struct list_head children;	/* list of my children */
 	struct list_head sibling;	/* linkage in my parent's children list */
 	struct task_struct *group_leader;	/* threadgroup leader */
 
+	/*
+	 * ptraced is the list of tasks this task is using ptrace on.
+	 * This includes both natural children and PTRACE_ATTACH targets.
+	 * p->ptrace_entry is p's link on the p->parent->ptraced list.
+	 */
+	struct list_head ptraced;
+	struct list_head ptrace_entry;
+
 	/* PID/PID hash table linkage. */
 	struct pid_link pids[PIDTYPE_MAX];
 	struct list_head thread_group;
@@ -1876,9 +1877,6 @@ extern void wait_task_inactive(struct ta
 #define wait_task_inactive(p)	do { } while (0)
 #endif
 
-#define remove_parent(p)	list_del_init(&(p)->sibling)
-#define add_parent(p)		list_add_tail(&(p)->sibling,&(p)->parent->children)
-
 #define next_task(p)	list_entry(rcu_dereference((p)->tasks.next), struct task_struct, tasks)
 
 #define for_each_process(p) \
diff -puN kernel/exit.c~ptrace-ptrace-children-revamp kernel/exit.c
--- a/kernel/exit.c~ptrace-ptrace-children-revamp
+++ a/kernel/exit.c
@@ -71,7 +71,7 @@ static void __unhash_process(struct task
 		__get_cpu_var(process_counts)--;
 	}
 	list_del_rcu(&p->thread_group);
-	remove_parent(p);
+	list_del_init(&p->sibling);
 }
 
 /*
@@ -150,6 +150,18 @@ static void delayed_put_task_struct(stru
 	put_task_struct(container_of(rhp, struct task_struct, rcu));
 }
 
+/*
+ * Do final ptrace-related cleanup of a zombie being reaped.
+ *
+ * Called with write_lock(&tasklist_lock) held.
+ */
+static void ptrace_release_task(struct task_struct *p)
+{
+	BUG_ON(!list_empty(&p->ptraced));
+	ptrace_unlink(p);
+	BUG_ON(!list_empty(&p->ptrace_entry));
+}
+
 void release_task(struct task_struct * p)
 {
 	struct task_struct *leader;
@@ -158,8 +170,7 @@ repeat:
 	atomic_dec(&p->user->processes);
 	proc_flush_task(p);
 	write_lock_irq(&tasklist_lock);
-	ptrace_unlink(p);
-	BUG_ON(!list_empty(&p->ptrace_list) || !list_empty(&p->ptrace_children));
+	ptrace_release_task(p);
 	__exit_signal(p);
 
 	/*
@@ -313,9 +324,8 @@ static void reparent_to_kthreadd(void)
 
 	ptrace_unlink(current);
 	/* Reparent to init */
-	remove_parent(current);
 	current->real_parent = current->parent = kthreadd_task;
-	add_parent(current);
+	list_move_tail(&current->sibling, &current->real_parent->children);
 
 	/* Set the exit signal to SIGCHLD so we signal init on exit */
 	current->exit_signal = SIGCHLD;
@@ -687,37 +697,71 @@ static void exit_mm(struct task_struct *
 	mmput(mm);
 }
 
-static void
-reparent_thread(struct task_struct *p, struct task_struct *father, int traced)
+/*
+ * Detach all tasks we were using ptrace on.
+ * Any that need to be release_task'd are put on the @dead list.
+ *
+ * Called with write_lock(&tasklist_lock) held.
+ */
+static void ptrace_exit(struct task_struct *parent, struct list_head *dead)
 {
-	if (p->pdeath_signal)
-		/* We already hold the tasklist_lock here.  */
-		group_send_sig_info(p->pdeath_signal, SEND_SIG_NOINFO, p);
+	struct task_struct *p, *n;
 
-	/* Move the child from its dying parent to the new one.  */
-	if (unlikely(traced)) {
-		/* Preserve ptrace links if someone else is tracing this child.  */
-		list_del_init(&p->ptrace_list);
-		if (ptrace_reparented(p))
-			list_add(&p->ptrace_list, &p->real_parent->ptrace_children);
-	} else {
-		/* If this child is being traced, then we're the one tracing it
-		 * anyway, so let go of it.
+	list_for_each_entry_safe(p, n, &parent->ptraced, ptrace_entry) {
+		__ptrace_unlink(p);
+
+		if (p->exit_state != EXIT_ZOMBIE)
+			continue;
+
+		/*
+		 * If it's a zombie, our attachedness prevented normal
+		 * parent notification or self-reaping.  Do notification
+		 * now if it would have happened earlier.  If it should
+		 * reap itself, add it to the @dead list.  We can't call
+		 * release_task() here because we already hold tasklist_lock.
+		 *
+		 * If it's our own child, there is no notification to do.
 		 */
-		p->ptrace = 0;
-		remove_parent(p);
-		p->parent = p->real_parent;
-		add_parent(p);
+		if (!task_detached(p) && thread_group_empty(p)) {
+			if (!same_thread_group(p->real_parent, parent))
+				do_notify_parent(p, p->exit_signal);
+		}
 
-		if (task_is_traced(p)) {
+		if (task_detached(p)) {
 			/*
-			 * If it was at a trace stop, turn it into
-			 * a normal stop since it's no longer being
-			 * traced.
+			 * Mark it as in the process of being reaped.
 			 */
-			ptrace_untrace(p);
+			p->exit_state = EXIT_DEAD;
+			list_add(&p->ptrace_entry, dead);
 		}
 	}
+}
+
+/*
+ * Finish up exit-time ptrace cleanup.
+ *
+ * Called without locks.
+ */
+static void ptrace_exit_finish(struct task_struct *parent,
+			       struct list_head *dead)
+{
+	struct task_struct *p, *n;
+
+	BUG_ON(!list_empty(&parent->ptraced));
+
+	list_for_each_entry_safe(p, n, dead, ptrace_entry) {
+		list_del_init(&p->ptrace_entry);
+		release_task(p);
+	}
+}
+
+static void reparent_thread(struct task_struct *p, struct task_struct *father)
+{
+	if (p->pdeath_signal)
+		/* We already hold the tasklist_lock here.  */
+		group_send_sig_info(p->pdeath_signal, SEND_SIG_NOINFO, p);
+
+	list_move_tail(&p->sibling, &p->real_parent->children);
 
 	/* If this is a threaded reparent there is no need to
 	 * notify anyone anything has happened.
@@ -732,7 +776,8 @@ reparent_thread(struct task_struct *p, s
 	/* If we'd notified the old parent about this child's death,
 	 * also notify the new parent.
 	 */
-	if (!traced && p->exit_state == EXIT_ZOMBIE &&
+	if (!ptrace_reparented(p) &&
+	    p->exit_state == EXIT_ZOMBIE &&
 	    !task_detached(p) && thread_group_empty(p))
 		do_notify_parent(p, p->exit_signal);
 
@@ -749,12 +794,15 @@ reparent_thread(struct task_struct *p, s
 static void forget_original_parent(struct task_struct *father)
 {
 	struct task_struct *p, *n, *reaper = father;
-	struct list_head ptrace_dead;
-
-	INIT_LIST_HEAD(&ptrace_dead);
+	LIST_HEAD(ptrace_dead);
 
 	write_lock_irq(&tasklist_lock);
 
+	/*
+	 * First clean up ptrace if we were using it.
+	 */
+	ptrace_exit(father, &ptrace_dead);
+
 	do {
 		reaper = next_thread(reaper);
 		if (reaper == father) {
@@ -763,58 +811,19 @@ static void forget_original_parent(struc
 		}
 	} while (reaper->flags & PF_EXITING);
 
-	/*
-	 * There are only two places where our children can be:
-	 *
-	 * - in our child list
-	 * - in our ptraced child list
-	 *
-	 * Search them and reparent children.
-	 */
 	list_for_each_entry_safe(p, n, &father->children, sibling) {
-		int ptrace;
-
-		ptrace = p->ptrace;
-
-		/* if father isn't the real parent, then ptrace must be enabled */
-		BUG_ON(father != p->real_parent && !ptrace);
-
-		if (father == p->real_parent) {
-			/* reparent with a reaper, real father it's us */
-			p->real_parent = reaper;
-			reparent_thread(p, father, 0);
-		} else {
-			/* reparent ptraced task to its real parent */
-			__ptrace_unlink (p);
-			if (p->exit_state == EXIT_ZOMBIE && !task_detached(p) &&
-			    thread_group_empty(p))
-				do_notify_parent(p, p->exit_signal);
-		}
-
-		/*
-		 * if the ptraced child is a detached zombie we must collect
-		 * it before we exit, or it will remain zombie forever since
-		 * we prevented it from self-reap itself while it was being
-		 * traced by us, to be able to see it in wait4.
-		 */
-		if (unlikely(ptrace && p->exit_state == EXIT_ZOMBIE && task_detached(p)))
-			list_add(&p->ptrace_list, &ptrace_dead);
-	}
-
-	list_for_each_entry_safe(p, n, &father->ptrace_children, ptrace_list) {
 		p->real_parent = reaper;
-		reparent_thread(p, father, 1);
+		if (p->parent == father) {
+			BUG_ON(p->ptrace);
+			p->parent = p->real_parent;
+		}
+		reparent_thread(p, father);
 	}
 
 	write_unlock_irq(&tasklist_lock);
 	BUG_ON(!list_empty(&father->children));
-	BUG_ON(!list_empty(&father->ptrace_children));
-
-	list_for_each_entry_safe(p, n, &ptrace_dead, ptrace_list) {
-		list_del_init(&p->ptrace_list);
-		release_task(p);
-	}
 
+	ptrace_exit_finish(father, &ptrace_dead);
 }
 
 /*
@@ -1172,13 +1181,6 @@ static int eligible_child(enum pid_type 
 			return 0;
 	}
 
-	/*
-	 * Do not consider detached threads that are
-	 * not ptraced:
-	 */
-	if (task_detached(p) && !p->ptrace)
-		return 0;
-
 	/* Wait for all children (clone and not) if __WALL is set;
 	 * otherwise, wait for clone children *only* if __WCLONE is
 	 * set; otherwise, wait for non-clone children *only*.  (Note:
@@ -1391,7 +1393,7 @@ static int wait_task_zombie(struct task_
  * the lock and this task is uninteresting.  If we return nonzero, we have
  * released the lock and the system call should return.
  */
-static int wait_task_stopped(struct task_struct *p,
+static int wait_task_stopped(int ptrace, struct task_struct *p,
 			     int options, struct siginfo __user *infop,
 			     int __user *stat_addr, struct rusage __user *ru)
 {
@@ -1399,7 +1401,7 @@ static int wait_task_stopped(struct task
 	uid_t uid = 0; /* unneeded, required by compiler */
 	pid_t pid;
 
-	if (!(p->ptrace & PT_PTRACED) && !(options & WUNTRACED))
+	if (!(options & WUNTRACED))
 		return 0;
 
 	exit_code = 0;
@@ -1408,7 +1410,7 @@ static int wait_task_stopped(struct task
 	if (unlikely(!task_is_stopped_or_traced(p)))
 		goto unlock_sig;
 
-	if (!(p->ptrace & PT_PTRACED) && p->signal->group_stop_count > 0)
+	if (!ptrace && p->signal->group_stop_count > 0)
 		/*
 		 * A group stop is in progress and this is the group leader.
 		 * We won't report until all threads have stopped.
@@ -1437,7 +1439,7 @@ unlock_sig:
 	 */
 	get_task_struct(p);
 	pid = task_pid_vnr(p);
-	why = (p->ptrace & PT_PTRACED) ? CLD_TRAPPED : CLD_STOPPED;
+	why = ptrace ? CLD_TRAPPED : CLD_STOPPED;
 	read_unlock(&tasklist_lock);
 
 	if (unlikely(options & WNOWAIT))
@@ -1528,7 +1530,7 @@ static int wait_task_continued(struct ta
  * Returns zero if the search for a child should continue;
  * then *@notask_error is 0 if @p is an eligible child, or still -ECHILD.
  */
-static int wait_consider_task(struct task_struct *parent,
+static int wait_consider_task(struct task_struct *parent, int ptrace,
 			      struct task_struct *p, int *notask_error,
 			      enum pid_type type, struct pid *pid, int options,
 			      struct siginfo __user *infop,
@@ -1538,6 +1540,15 @@ static int wait_consider_task(struct tas
 	if (ret <= 0)
 		return ret;
 
+	if (likely(!ptrace) && unlikely(p->ptrace)) {
+		/*
+		 * This child is hidden by ptrace.
+		 * We aren't allowed to see it now, but eventually we will.
+		 */
+		*notask_error = 0;
+		return 0;
+	}
+
 	if (p->exit_state == EXIT_DEAD)
 		return 0;
 
@@ -1554,7 +1565,8 @@ static int wait_consider_task(struct tas
 	*notask_error = 0;
 
 	if (task_is_stopped_or_traced(p))
-		return wait_task_stopped(p, options, infop, stat_addr, ru);
+		return wait_task_stopped(ptrace, p, options,
+					 infop, stat_addr, ru);
 
 	return wait_task_continued(p, options, infop, stat_addr, ru);
 }
@@ -1575,11 +1587,16 @@ static int do_wait_thread(struct task_st
 	struct task_struct *p;
 
 	list_for_each_entry(p, &tsk->children, sibling) {
-		int ret = wait_consider_task(tsk, p, notask_error,
-					     type, pid, options,
-					     infop, stat_addr, ru);
-		if (ret)
-			return ret;
+		/*
+		 * Do not consider detached threads.
+		 */
+		if (!task_detached(p)) {
+			int ret = wait_consider_task(tsk, 0, p, notask_error,
+						     type, pid, options,
+						     infop, stat_addr, ru);
+			if (ret)
+				return ret;
+		}
 	}
 
 	return 0;
@@ -1593,21 +1610,16 @@ static int ptrace_do_wait(struct task_st
 	struct task_struct *p;
 
 	/*
-	 * If we never saw an eligile child, check for children stolen by
-	 * ptrace.  We don't leave -ECHILD in *@notask_error if there are any,
-	 * because we will eventually be allowed to wait for them again.
+	 * Traditionally we see ptrace'd stopped tasks regardless of options.
 	 */
-	if (!*notask_error)
-		return 0;
+	options |= WUNTRACED;
 
-	list_for_each_entry(p, &tsk->ptrace_children, ptrace_list) {
-		int ret = eligible_child(type, pid, options, p);
-		if (unlikely(ret < 0))
+	list_for_each_entry(p, &tsk->ptraced, ptrace_entry) {
+		int ret = wait_consider_task(tsk, 1, p, notask_error,
+					     type, pid, options,
+					     infop, stat_addr, ru);
+		if (ret)
 			return ret;
-		if (ret) {
-			*notask_error = 0;
-			return 0;
-		}
 	}
 
 	return 0;
diff -puN kernel/fork.c~ptrace-ptrace-children-revamp kernel/fork.c
--- a/kernel/fork.c~ptrace-ptrace-children-revamp
+++ a/kernel/fork.c
@@ -1177,8 +1177,8 @@ static struct task_struct *copy_process(
 	 */
 	p->group_leader = p;
 	INIT_LIST_HEAD(&p->thread_group);
-	INIT_LIST_HEAD(&p->ptrace_children);
-	INIT_LIST_HEAD(&p->ptrace_list);
+	INIT_LIST_HEAD(&p->ptrace_entry);
+	INIT_LIST_HEAD(&p->ptraced);
 
 	/* Now that the task is set up, run cgroup callbacks if
 	 * necessary. We need to run them before the task is visible
@@ -1250,7 +1250,7 @@ static struct task_struct *copy_process(
 	}
 
 	if (likely(p->pid)) {
-		add_parent(p);
+		list_add_tail(&p->sibling, &p->real_parent->children);
 		if (unlikely(p->ptrace & PT_PTRACED))
 			__ptrace_link(p, current->parent);
 
diff -puN kernel/ptrace.c~ptrace-ptrace-children-revamp kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace-ptrace-children-revamp
+++ a/kernel/ptrace.c
@@ -33,13 +33,9 @@
  */
 void __ptrace_link(struct task_struct *child, struct task_struct *new_parent)
 {
-	BUG_ON(!list_empty(&child->ptrace_list));
-	if (child->parent == new_parent)
-		return;
-	list_add(&child->ptrace_list, &child->parent->ptrace_children);
-	remove_parent(child);
+	BUG_ON(!list_empty(&child->ptrace_entry));
+	list_add(&child->ptrace_entry, &new_parent->ptraced);
 	child->parent = new_parent;
-	add_parent(child);
 }
  
 /*
@@ -73,12 +69,8 @@ void __ptrace_unlink(struct task_struct 
 	BUG_ON(!child->ptrace);
 
 	child->ptrace = 0;
-	if (ptrace_reparented(child)) {
-		list_del_init(&child->ptrace_list);
-		remove_parent(child);
-		child->parent = child->real_parent;
-		add_parent(child);
-	}
+	child->parent = child->real_parent;
+	list_del_init(&child->ptrace_entry);
 
 	if (task_is_traced(child))
 		ptrace_untrace(child);
@@ -492,15 +484,34 @@ int ptrace_traceme(void)
 	/*
 	 * Are we already being traced?
 	 */
+repeat:
 	task_lock(current);
 	if (!(current->ptrace & PT_PTRACED)) {
+		/*
+		 * See ptrace_attach() comments about the locking here.
+		 */
+		unsigned long flags;
+		if (!write_trylock_irqsave(&tasklist_lock, flags)) {
+			task_unlock(current);
+			do {
+				cpu_relax();
+			} while (!write_can_lock(&tasklist_lock));
+			goto repeat;
+		}
+
 		ret = security_ptrace(current->parent, current,
 				      PTRACE_MODE_ATTACH);
+
 		/*
 		 * Set the ptrace bit in the process ptrace flags.
+		 * Then link us on our parent's ptraced list.
 		 */
-		if (!ret)
+		if (!ret) {
 			current->ptrace |= PT_PTRACED;
+			__ptrace_link(current, current->real_parent);
+		}
+
+		write_unlock_irqrestore(&tasklist_lock, flags);
 	}
 	task_unlock(current);
 	return ret;
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
markers-fix-duplicate-modpost-entry.patch
linux-next.patch
execve-filename-document-and-export-via-auxiliary-vector.patch
flag-parameters-paccept-fix.patch
flag-parameters-paccept-fix-flag-parameters-arch-specific-sock_nonblock.patch
posix-timers-timer_delete-remove-the-bogus-it_process-=-null-check.patch
posix-timers-release_posix_timer-kill-the-bogus-put_task_struct-it_process.patch
signals-collect_signal-remove-the-unneeded-sigismember-check.patch
signals-collect_signal-simplify-the-still_pending-logic.patch
__exit_signal-dont-take-rcu-lock.patch
signals-dequeue_signal-dont-check-signal_group_exit-when-setting-signal_stop_dequeued.patch
signals-do_signal_stop-kill-the-signal_unkillable-check.patch
coredump-zap_threads-comments-use-while_each_thread.patch
signals-make-siginfo_t-si_utime-si_sstime-report-times-in-user_hz-not-hz.patch
kernel-signalc-change-vars-pid-and-tgid-types-to-pid_t.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
ptrace-give-more-respect-to-sigkill.patch
ptrace-simplify-ptrace_stop-sigkill_pending-path.patch
introduce-pf_kthread-flag.patch
kill-pf_borrowed_mm-in-favour-of-pf_kthread.patch
coredump-zap_threads-must-skip-kernel-threads.patch
coredump-elf_core_dump-skip-kernel-threads.patch
coredump-turn-mm-core_startup_done-into-the-pointer-to-struct-core_state.patch
coredump-move-mm-core_waiters-into-struct-core_state.patch
coredump-simplify-core_state-nr_threads-calculation.patch
coredump-turn-core_state-nr_threads-into-atomic_t.patch
coredump-make-mm-core_state-visible-to-core_dump.patch
coredump-construct-the-list-of-coredumping-threads-at-startup-time.patch
coredump-elf_core_dump-use-core_state-dumper-list.patch
coredump-elf_fdpic_core_dump-use-core_state-dumper-list.patch
coredump-kill-mm-core_done.patch
coredump-binfmt_elf_fdpic-dont-use-sub-threads-mm.patch
coredump-exit_mm-clear-mm-first-then-play-with-core_state.patch
coredump-exit_mm-clear-mm-first-then-play-with-core_state-checkpatch-fixes.patch
tracehook-add-linux-tracehookh.patch
tracehook-exec.patch
tracehook-unexport-ptrace_notify.patch
tracehook-exit.patch
tracehook-clone.patch
tracehook-vfork-done.patch
tracehook-release_task.patch
tracehook-tracehook_tracer_task.patch
tracehook-tracehook_expect_breakpoints.patch
tracehook-tracehook_signal_handler.patch
tracehook-tracehook_consider_ignored_signal.patch
tracehook-tracehook_consider_fatal_signal.patch
tracehook-syscall.patch
tracehook-get_signal_to_deliver.patch
tracehook-job-control.patch
tracehook-death.patch
tracehook-force-signal_pending.patch
tracehook-tif_notify_resume.patch
tracehook-asm-syscallh.patch
tracehook-config_have_arch_tracehook.patch
tracehook-wait_task_inactive.patch
task_current_syscall.patch
proc-pid-syscall.patch

