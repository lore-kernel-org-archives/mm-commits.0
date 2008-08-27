From: akpm@linux-foundation.org
Subject: + pid_ns-bug-11391-change-child_reaper-when-init-group_leader-exits.patch added to -mm tree
Date: Wed, 27 Aug 2008 14:26:59 -0700
Message-ID: <200808272126.m7RLQx8R023349@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50541 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752286AbYH0V2D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Aug 2008 17:28:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, robert.rex@exasol.com, serue@us.ibm.com, sukadev@linux.vnet.ibm.com, xemul@openvz.org


The patch titled
     pid_ns: (BUG 11391) change ->child_reaper when init->group_leader exits
has been added to the -mm tree.  Its filename is
     pid_ns-bug-11391-change-child_reaper-when-init-group_leader-exits.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pid_ns: (BUG 11391) change ->child_reaper when init->group_leader exits
From: Oleg Nesterov <oleg@tv-sign.ru>

We don't change pid_ns->child_reaper when the main thread of the
subnamespace init exits.  As Robert Rex <robert.rex@exasol.com> pointed
out this is wrong.

Yes, the re-parenting itself works correctly, but if the reparented task
exits it needs ->parent->nsproxy->pid_ns in do_notify_parent(), and if the
main thread is zombie its ->nsproxy was already cleared by
exit_task_namespaces().

Introduce the new function, find_new_reaper(), which finds the new
->parent for the re-parenting and changes ->child_reaper if needed.  Kill
the now unneeded exit_child_reaper().

Also move the changing of ->child_reaper from zap_pid_ns_processes() to
find_new_reaper(), this consolidates the games with ->child_reaper and
makes it stable under tasklist_lock.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=11391

Reported-by: Robert Rex <robert.rex@exasol.com>
Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Acked-by: Pavel Emelyanov <xemul@openvz.org>
Acked-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c          |   78 +++++++++++++++++----------------------
 kernel/pid_namespace.c |    6 ---
 2 files changed, 34 insertions(+), 50 deletions(-)

diff -puN kernel/exit.c~pid_ns-bug-11391-change-child_reaper-when-init-group_leader-exits kernel/exit.c
--- a/kernel/exit.c~pid_ns-bug-11391-change-child_reaper-when-init-group_leader-exits
+++ a/kernel/exit.c
@@ -831,26 +831,50 @@ static void reparent_thread(struct task_
  * the child reaper process (ie "init") in our pid
  * space.
  */
+static struct task_struct *find_new_reaper(struct task_struct *father)
+{
+	struct pid_namespace *pid_ns = task_active_pid_ns(father);
+	struct task_struct *thread;
+
+	thread = father;
+	while_each_thread(father, thread) {
+		if (thread->flags & PF_EXITING)
+			continue;
+		if (unlikely(pid_ns->child_reaper == father))
+			pid_ns->child_reaper = thread;
+		return thread;
+	}
+
+	if (unlikely(pid_ns->child_reaper == father)) {
+		write_unlock_irq(&tasklist_lock);
+		if (unlikely(pid_ns == &init_pid_ns))
+			panic("Attempted to kill init!");
+
+		zap_pid_ns_processes(pid_ns);
+		write_lock_irq(&tasklist_lock);
+		/*
+		 * We can not clear ->child_reaper or leave it alone.
+		 * There may by stealth EXIT_DEAD tasks on ->children,
+		 * forget_original_parent() must move them somewhere.
+		 */
+		pid_ns->child_reaper = init_pid_ns.child_reaper;
+	}
+
+	return pid_ns->child_reaper;
+}
+
 static void forget_original_parent(struct task_struct *father)
 {
-	struct task_struct *p, *n, *reaper = father;
+	struct task_struct *p, *n, *reaper;
 	LIST_HEAD(ptrace_dead);
 
 	write_lock_irq(&tasklist_lock);
-
+	reaper = find_new_reaper(father);
 	/*
 	 * First clean up ptrace if we were using it.
 	 */
 	ptrace_exit(father, &ptrace_dead);
 
-	do {
-		reaper = next_thread(reaper);
-		if (reaper == father) {
-			reaper = task_child_reaper(father);
-			break;
-		}
-	} while (reaper->flags & PF_EXITING);
-
 	list_for_each_entry_safe(p, n, &father->children, sibling) {
 		p->real_parent = reaper;
 		if (p->parent == father) {
@@ -959,39 +983,6 @@ static void check_stack_usage(void)
 static inline void check_stack_usage(void) {}
 #endif
 
-static inline void exit_child_reaper(struct task_struct *tsk)
-{
-	if (likely(tsk->group_leader != task_child_reaper(tsk)))
-		return;
-
-	if (tsk->nsproxy->pid_ns == &init_pid_ns)
-		panic("Attempted to kill init!");
-
-	/*
-	 * @tsk is the last thread in the 'cgroup-init' and is exiting.
-	 * Terminate all remaining processes in the namespace and reap them
-	 * before exiting @tsk.
-	 *
-	 * Note that @tsk (last thread of cgroup-init) may not necessarily
-	 * be the child-reaper (i.e main thread of cgroup-init) of the
-	 * namespace i.e the child_reaper may have already exited.
-	 *
-	 * Even after a child_reaper exits, we let it inherit orphaned children,
-	 * because, pid_ns->child_reaper remains valid as long as there is
-	 * at least one living sub-thread in the cgroup init.
-
-	 * This living sub-thread of the cgroup-init will be notified when
-	 * a child inherited by the 'child-reaper' exits (do_notify_parent()
-	 * uses __group_send_sig_info()). Further, when reaping child processes,
-	 * do_wait() iterates over children of all living sub threads.
-
-	 * i.e even though 'child_reaper' thread is listed as the parent of the
-	 * orphaned children, any living sub-thread in the cgroup-init can
-	 * perform the role of the child_reaper.
-	 */
-	zap_pid_ns_processes(tsk->nsproxy->pid_ns);
-}
-
 NORET_TYPE void do_exit(long code)
 {
 	struct task_struct *tsk = current;
@@ -1051,7 +1042,6 @@ NORET_TYPE void do_exit(long code)
 	}
 	group_dead = atomic_dec_and_test(&tsk->signal->live);
 	if (group_dead) {
-		exit_child_reaper(tsk);
 		hrtimer_cancel(&tsk->signal->real_timer);
 		exit_itimers(tsk->signal);
 	}
diff -puN kernel/pid_namespace.c~pid_ns-bug-11391-change-child_reaper-when-init-group_leader-exits kernel/pid_namespace.c
--- a/kernel/pid_namespace.c~pid_ns-bug-11391-change-child_reaper-when-init-group_leader-exits
+++ a/kernel/pid_namespace.c
@@ -179,12 +179,6 @@ void zap_pid_ns_processes(struct pid_nam
 		rc = sys_wait4(-1, NULL, __WALL, NULL);
 	} while (rc != -ECHILD);
 
-	/*
-	 * We can not clear ->child_reaper or leave it alone.
-	 * There may by stealth EXIT_DEAD tasks on ->children,
-	 * forget_original_parent() must move them somewhere.
-	 */
-	pid_ns->child_reaper = init_pid_ns.child_reaper;
 	acct_exit_ns(pid_ns);
 	return;
 }
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

exit-signals-use-of-uninitialized-field-notify_count.patch
pid_ns-zap_pid_ns_processes-fix-the-child_reaper-changing.patch
pid_ns-bug-11391-change-child_reaper-when-init-group_leader-exits.patch
linux-next.patch
posix-timers-dont-switch-to-group_leader-if-it_process-dies.patch
posix-timers-always-do-get_task_structtimer-it_process.patch
posix-timers-sys_timer_create-remove-the-buggy-pf_exiting-check.patch
posix-timers-sys_timer_create-simplify-and-s-tasklist-rcu.patch
posix-timers-move-the-initialization-of-timer-sigq-from-send-to-create-path.patch
posix-timers-sys_timer_create-cleanup-the-error-handling.patch
posix-timers-kill-it_sigev_signo-and-it_sigev_value.patch
posix-timers-lock_timer-kill-the-bogus-it_id-check.patch
posix-timers-lock_timer-make-it-readable.patch
posix-timers-use-struct-pid-instead-of-struct-task_struct.patch
posix-timers-check-it_signal-instead-of-it_pid-to-validate-the-timer.patch
posix-timers-simplify-de_thread-exit_itimers-path.patch
make-ptrace_untrace-static.patch
coredump-format_corename-dont-append-%pid-if-multi-threaded.patch
kthread_bind-use-wait_task_inactivetask_uninterruptible.patch

