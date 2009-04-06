From: akpm@linux-foundation.org
Subject: [merged] forget_original_parent-split-out-the-un-ptrace-part.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:35:48 -0700
Message-ID: <200904061935.n36JZm4k012204@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60361 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751908AbZDFUYa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 16:24:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, ebiederm@xmission.com, markus.t.metzger@intel.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     forget_original_parent: split out the un-ptrace part
has been removed from the -mm tree.  Its filename was
     forget_original_parent-split-out-the-un-ptrace-part.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: forget_original_parent: split out the un-ptrace part
From: Oleg Nesterov <oleg@redhat.com>

By discussion with Roland.

- Rename ptrace_exit() to exit_ptrace(), and change it to do all the
  necessary work with ->ptraced list by its own.

- Move this code from exit.c to ptrace.c

- Update the comment in ptrace_detach() to explain the rechecking of
  the child->ptrace.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ptrace.h |    2 
 include/linux/sched.h  |    5 ++
 kernel/exit.c          |   95 ++-------------------------------------
 kernel/ptrace.c        |   78 +++++++++++++++++++++++++++++++-
 4 files changed, 88 insertions(+), 92 deletions(-)

diff -puN include/linux/ptrace.h~forget_original_parent-split-out-the-un-ptrace-part include/linux/ptrace.h
--- a/include/linux/ptrace.h~forget_original_parent-split-out-the-un-ptrace-part
+++ a/include/linux/ptrace.h
@@ -94,7 +94,7 @@ extern void ptrace_notify(int exit_code)
 extern void __ptrace_link(struct task_struct *child,
 			  struct task_struct *new_parent);
 extern void __ptrace_unlink(struct task_struct *child);
-extern int __ptrace_detach(struct task_struct *tracer, struct task_struct *p);
+extern void exit_ptrace(struct task_struct *tracer);
 extern void ptrace_fork(struct task_struct *task, unsigned long clone_flags);
 #define PTRACE_MODE_READ   1
 #define PTRACE_MODE_ATTACH 2
diff -puN include/linux/sched.h~forget_original_parent-split-out-the-un-ptrace-part include/linux/sched.h
--- a/include/linux/sched.h~forget_original_parent-split-out-the-un-ptrace-part
+++ a/include/linux/sched.h
@@ -2061,6 +2061,11 @@ static inline int thread_group_empty(str
 #define delay_group_leader(p) \
 		(thread_group_leader(p) && !thread_group_empty(p))
 
+static inline int task_detached(struct task_struct *p)
+{
+	return p->exit_signal == -1;
+}
+
 /*
  * Protects ->fs, ->files, ->mm, ->group_info, ->comm, keyring
  * subscriptions and synchronises with wait4().  Also used in procfs.  Also
diff -puN kernel/exit.c~forget_original_parent-split-out-the-un-ptrace-part kernel/exit.c
--- a/kernel/exit.c~forget_original_parent-split-out-the-un-ptrace-part
+++ a/kernel/exit.c
@@ -61,11 +61,6 @@ DEFINE_TRACE(sched_process_wait);
 
 static void exit_mm(struct task_struct * tsk);
 
-static inline int task_detached(struct task_struct *p)
-{
-	return p->exit_signal == -1;
-}
-
 static void __unhash_process(struct task_struct *p)
 {
 	nr_threads--;
@@ -731,85 +726,6 @@ static void exit_mm(struct task_struct *
 	mmput(mm);
 }
 
-/*
- * Called with irqs disabled, returns true if childs should reap themselves.
- */
-static int ignoring_children(struct sighand_struct *sigh)
-{
-	int ret;
-	spin_lock(&sigh->siglock);
-	ret = (sigh->action[SIGCHLD-1].sa.sa_handler == SIG_IGN) ||
-	      (sigh->action[SIGCHLD-1].sa.sa_flags & SA_NOCLDWAIT);
-	spin_unlock(&sigh->siglock);
-	return ret;
-}
-
-/* Returns nonzero if the tracee should be released. */
-int __ptrace_detach(struct task_struct *tracer, struct task_struct *p)
-{
-	__ptrace_unlink(p);
-
-	if (p->exit_state != EXIT_ZOMBIE)
-		return 0;
-	/*
-	 * If it's a zombie, our attachedness prevented normal
-	 * parent notification or self-reaping.  Do notification
-	 * now if it would have happened earlier.  If it should
-	 * reap itself we return true.
-	 *
-	 * If it's our own child, there is no notification to do.
-	 * But if our normal children self-reap, then this child
-	 * was prevented by ptrace and we must reap it now.
-	 */
-	if (!task_detached(p) && thread_group_empty(p)) {
-		if (!same_thread_group(p->real_parent, tracer))
-			do_notify_parent(p, p->exit_signal);
-		else if (ignoring_children(tracer->sighand))
-			p->exit_signal = -1;
-	}
-
-	if (!task_detached(p))
-		return 0;
-
-	/* Mark it as in the process of being reaped. */
-	p->exit_state = EXIT_DEAD;
-	return 1;
-}
-
-/*
- * Detach all tasks we were using ptrace on.
- * Any that need to be release_task'd are put on the @dead list.
- *
- * Called with write_lock(&tasklist_lock) held.
- */
-static void ptrace_exit(struct task_struct *parent, struct list_head *dead)
-{
-	struct task_struct *p, *n;
-
-	list_for_each_entry_safe(p, n, &parent->ptraced, ptrace_entry) {
-		if (__ptrace_detach(parent, p))
-			list_add(&p->ptrace_entry, dead);
-	}
-}
-
-/*
- * Finish up exit-time ptrace cleanup.
- *
- * Called without locks.
- */
-static void ptrace_exit_finish(struct task_struct *parent,
-			       struct list_head *dead)
-{
-	struct task_struct *p, *n;
-
-	BUG_ON(!list_empty(&parent->ptraced));
-
-	list_for_each_entry_safe(p, n, dead, ptrace_entry) {
-		list_del_init(&p->ptrace_entry);
-		release_task(p);
-	}
-}
-
 /* Returns nonzero if the child should be released. */
 static int reparent_thread(struct task_struct *p, struct task_struct *father)
 {
@@ -894,12 +810,10 @@ static void forget_original_parent(struc
 	struct task_struct *p, *n, *reaper;
 	LIST_HEAD(ptrace_dead);
 
+	exit_ptrace(father);
+
 	write_lock_irq(&tasklist_lock);
 	reaper = find_new_reaper(father);
-	/*
-	 * First clean up ptrace if we were using it.
-	 */
-	ptrace_exit(father, &ptrace_dead);
 
 	list_for_each_entry_safe(p, n, &father->children, sibling) {
 		p->real_parent = reaper;
@@ -914,7 +828,10 @@ static void forget_original_parent(struc
 	write_unlock_irq(&tasklist_lock);
 	BUG_ON(!list_empty(&father->children));
 
-	ptrace_exit_finish(father, &ptrace_dead);
+	list_for_each_entry_safe(p, n, &ptrace_dead, ptrace_entry) {
+		list_del_init(&p->ptrace_entry);
+		release_task(p);
+	}
 }
 
 /*
diff -puN kernel/ptrace.c~forget_original_parent-split-out-the-un-ptrace-part kernel/ptrace.c
--- a/kernel/ptrace.c~forget_original_parent-split-out-the-un-ptrace-part
+++ a/kernel/ptrace.c
@@ -235,9 +235,57 @@ out:
 	return retval;
 }
 
+/*
+ * Called with irqs disabled, returns true if childs should reap themselves.
+ */
+static int ignoring_children(struct sighand_struct *sigh)
+{
+	int ret;
+	spin_lock(&sigh->siglock);
+	ret = (sigh->action[SIGCHLD-1].sa.sa_handler == SIG_IGN) ||
+	      (sigh->action[SIGCHLD-1].sa.sa_flags & SA_NOCLDWAIT);
+	spin_unlock(&sigh->siglock);
+	return ret;
+}
+
+/*
+ * Called with tasklist_lock held for writing.
+ * Unlink a traced task, and clean it up if it was a traced zombie.
+ * Return true if it needs to be reaped with release_task().
+ * (We can't call release_task() here because we already hold tasklist_lock.)
+ *
+ * If it's a zombie, our attachedness prevented normal parent notification
+ * or self-reaping.  Do notification now if it would have happened earlier.
+ * If it should reap itself, return true.
+ *
+ * If it's our own child, there is no notification to do.
+ * But if our normal children self-reap, then this child
+ * was prevented by ptrace and we must reap it now.
+ */
+static bool __ptrace_detach(struct task_struct *tracer, struct task_struct *p)
+{
+	__ptrace_unlink(p);
+
+	if (p->exit_state == EXIT_ZOMBIE) {
+		if (!task_detached(p) && thread_group_empty(p)) {
+			if (!same_thread_group(p->real_parent, tracer))
+				do_notify_parent(p, p->exit_signal);
+			else if (ignoring_children(tracer->sighand))
+				p->exit_signal = -1;
+		}
+		if (task_detached(p)) {
+			/* Mark it as in the process of being reaped. */
+			p->exit_state = EXIT_DEAD;
+			return true;
+		}
+	}
+
+	return false;
+}
+
 int ptrace_detach(struct task_struct *child, unsigned int data)
 {
-	int dead = 0;
+	bool dead = false;
 
 	if (!valid_signal(data))
 		return -EIO;
@@ -247,7 +295,10 @@ int ptrace_detach(struct task_struct *ch
 	clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
 
 	write_lock_irq(&tasklist_lock);
-	/* protect against de_thread()->release_task() */
+	/*
+	 * This child can be already killed. Make sure de_thread() or
+	 * our sub-thread doing do_wait() didn't do release_task() yet.
+	 */
 	if (child->ptrace) {
 		child->exit_code = data;
 
@@ -264,6 +315,29 @@ int ptrace_detach(struct task_struct *ch
 	return 0;
 }
 
+/*
+ * Detach all tasks we were using ptrace on.
+ */
+void exit_ptrace(struct task_struct *tracer)
+{
+	struct task_struct *p, *n;
+	LIST_HEAD(ptrace_dead);
+
+	write_lock_irq(&tasklist_lock);
+	list_for_each_entry_safe(p, n, &tracer->ptraced, ptrace_entry) {
+		if (__ptrace_detach(tracer, p))
+			list_add(&p->ptrace_entry, &ptrace_dead);
+	}
+	write_unlock_irq(&tasklist_lock);
+
+	BUG_ON(!list_empty(&tracer->ptraced));
+
+	list_for_each_entry_safe(p, n, &ptrace_dead, ptrace_entry) {
+		list_del_init(&p->ptrace_entry);
+		release_task(p);
+	}
+}
+
 int ptrace_readdata(struct task_struct *tsk, unsigned long src, char __user *dst, int len)
 {
 	int copied = 0;
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
getrusage-fill-ru_maxrss-value.patch
signals-split-do_tkill.patch
signals-implement-sys_rt_tgsigqueueinfo.patch
x86-hookup-sys_rt_tgsigqueueinfo.patch
signals-tracehook_notify_jctl-change.patch

