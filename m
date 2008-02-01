From: akpm@linux-foundation.org
Subject: - use-macros-instead-of-task_-flags.patch removed from -mm tree
Date: Fri, 01 Feb 2008 14:30:08 -0800
Message-ID: <200802012230.m11MU8Uh001882@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36335 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755497AbYBAWnT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Feb 2008 17:43:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthew@wil.cx, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Use macros instead of TASK_ flags
has been removed from the -mm tree.  Its filename was
     use-macros-instead-of-task_-flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Use macros instead of TASK_ flags
From: Matthew Wilcox <matthew@wil.cx>

Abstracting away direct uses of TASK_ flags allows us to change the
definitions of the task flags more easily.

Also restructure do_wait() a little

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c        |    7 ---
 fs/proc/base.c         |    2 
 include/linux/sched.h  |   15 ++++++
 include/linux/wait.h   |   11 ++--
 kernel/exit.c          |   88 +++++++++++++++++----------------------
 kernel/power/process.c |    6 +-
 kernel/ptrace.c        |    8 +--
 kernel/sched.c         |   13 ++---
 kernel/signal.c        |    6 +-
 kernel/wait.c          |    2 
 10 files changed, 78 insertions(+), 80 deletions(-)

diff -puN fs/proc/array.c~use-macros-instead-of-task_-flags fs/proc/array.c
--- a/fs/proc/array.c~use-macros-instead-of-task_-flags
+++ a/fs/proc/array.c
@@ -141,12 +141,7 @@ static const char *task_state_array[] = 
 
 static inline const char *get_task_state(struct task_struct *tsk)
 {
-	unsigned int state = (tsk->state & (TASK_RUNNING |
-					    TASK_INTERRUPTIBLE |
-					    TASK_UNINTERRUPTIBLE |
-					    TASK_STOPPED |
-					    TASK_TRACED)) |
-					   tsk->exit_state;
+	unsigned int state = (tsk->state & TASK_REPORT) | tsk->exit_state;
 	const char **p = &task_state_array[0];
 
 	while (state) {
diff -puN fs/proc/base.c~use-macros-instead-of-task_-flags fs/proc/base.c
--- a/fs/proc/base.c~use-macros-instead-of-task_-flags
+++ a/fs/proc/base.c
@@ -195,7 +195,7 @@ static int proc_root_link(struct inode *
 	(task == current || \
 	(task->parent == current && \
 	(task->ptrace & PT_PTRACED) && \
-	 (task->state == TASK_STOPPED || task->state == TASK_TRACED) && \
+	 (is_task_stopped_or_traced(task)) && \
 	 security_ptrace(current,task) == 0))
 
 struct mm_struct *mm_for_maps(struct task_struct *task)
diff -puN include/linux/sched.h~use-macros-instead-of-task_-flags include/linux/sched.h
--- a/include/linux/sched.h~use-macros-instead-of-task_-flags
+++ a/include/linux/sched.h
@@ -179,6 +179,21 @@ print_cfs_rq(struct seq_file *m, int cpu
 /* in tsk->state again */
 #define TASK_DEAD		64
 
+/* Convenience macros for the sake of wake_up */
+#define TASK_NORMAL		(TASK_INTERRUPTIBLE | TASK_UNINTERRUPTIBLE)
+#define TASK_ALL		(TASK_NORMAL | TASK_STOPPED | TASK_TRACED)
+
+/* get_task_state() */
+#define TASK_REPORT		(TASK_RUNNING | TASK_INTERRUPTIBLE | \
+				 TASK_UNINTERRUPTIBLE | TASK_STOPPED | \
+				 TASK_TRACED)
+
+#define is_task_traced(task)	((task->state & TASK_TRACED) != 0)
+#define is_task_stopped(task)	((task->state & TASK_STOPPED) != 0)
+#define is_task_stopped_or_traced(task)	\
+			((task->state & (TASK_STOPPED | TASK_TRACED)) != 0)
+#define is_task_loadavg(task)	((task->state & TASK_UNINTERRUPTIBLE) != 0)
+
 #define __set_task_state(tsk, state_value)		\
 	do { (tsk)->state = (state_value); } while (0)
 #define set_task_state(tsk, state_value)		\
diff -puN include/linux/wait.h~use-macros-instead-of-task_-flags include/linux/wait.h
--- a/include/linux/wait.h~use-macros-instead-of-task_-flags
+++ a/include/linux/wait.h
@@ -152,14 +152,15 @@ int FASTCALL(out_of_line_wait_on_bit(voi
 int FASTCALL(out_of_line_wait_on_bit_lock(void *, int, int (*)(void *), unsigned));
 wait_queue_head_t *FASTCALL(bit_waitqueue(void *, int));
 
-#define wake_up(x)			__wake_up(x, TASK_UNINTERRUPTIBLE | TASK_INTERRUPTIBLE, 1, NULL)
-#define wake_up_nr(x, nr)		__wake_up(x, TASK_UNINTERRUPTIBLE | TASK_INTERRUPTIBLE, nr, NULL)
-#define wake_up_all(x)			__wake_up(x, TASK_UNINTERRUPTIBLE | TASK_INTERRUPTIBLE, 0, NULL)
+#define wake_up(x)			__wake_up(x, TASK_NORMAL, 1, NULL)
+#define wake_up_nr(x, nr)		__wake_up(x, TASK_NORMAL, nr, NULL)
+#define wake_up_all(x)			__wake_up(x, TASK_NORMAL, 0, NULL)
+#define wake_up_locked(x)		__wake_up_locked((x), TASK_NORMAL)
+
 #define wake_up_interruptible(x)	__wake_up(x, TASK_INTERRUPTIBLE, 1, NULL)
 #define wake_up_interruptible_nr(x, nr)	__wake_up(x, TASK_INTERRUPTIBLE, nr, NULL)
 #define wake_up_interruptible_all(x)	__wake_up(x, TASK_INTERRUPTIBLE, 0, NULL)
-#define	wake_up_locked(x)		__wake_up_locked((x), TASK_UNINTERRUPTIBLE | TASK_INTERRUPTIBLE)
-#define wake_up_interruptible_sync(x)   __wake_up_sync((x),TASK_INTERRUPTIBLE, 1)
+#define wake_up_interruptible_sync(x)	__wake_up_sync((x), TASK_INTERRUPTIBLE, 1)
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 /*
diff -puN kernel/exit.c~use-macros-instead-of-task_-flags kernel/exit.c
--- a/kernel/exit.c~use-macros-instead-of-task_-flags
+++ a/kernel/exit.c
@@ -249,7 +249,7 @@ static int has_stopped_jobs(struct pid *
 	struct task_struct *p;
 
 	do_each_pid_task(pgrp, PIDTYPE_PGID, p) {
-		if (p->state != TASK_STOPPED)
+		if (!is_task_stopped(p))
 			continue;
 		retval = 1;
 		break;
@@ -614,7 +614,7 @@ reparent_thread(struct task_struct *p, s
 		p->parent = p->real_parent;
 		add_parent(p);
 
-		if (p->state == TASK_TRACED) {
+		if (is_task_traced(p)) {
 			/*
 			 * If it was at a trace stop, turn it into
 			 * a normal stop since it's no longer being
@@ -1564,60 +1564,51 @@ repeat:
 			}
 			allowed = 1;
 
-			switch (p->state) {
-			case TASK_TRACED:
-				/*
-				 * When we hit the race with PTRACE_ATTACH,
-				 * we will not report this child.  But the
-				 * race means it has not yet been moved to
-				 * our ptrace_children list, so we need to
-				 * set the flag here to avoid a spurious ECHILD
-				 * when the race happens with the only child.
-				 */
-				flag = 1;
-				if (!my_ptrace_child(p))
-					continue;
-				/*FALLTHROUGH*/
-			case TASK_STOPPED:
+			if (is_task_stopped_or_traced(p)) {
 				/*
 				 * It's stopped now, so it might later
 				 * continue, exit, or stop again.
+				 *
+				 * When we hit the race with PTRACE_ATTACH, we
+				 * will not report this child.  But the race
+				 * means it has not yet been moved to our
+				 * ptrace_children list, so we need to set the
+				 * flag here to avoid a spurious ECHILD when
+				 * the race happens with the only child.
 				 */
 				flag = 1;
-				if (!(options & WUNTRACED) &&
-				    !my_ptrace_child(p))
-					continue;
+
+				if (!my_ptrace_child(p)) {
+					if (is_task_traced(p))
+						continue;
+					if (!(options & WUNTRACED))
+						continue;
+				}
+
 				retval = wait_task_stopped(p, ret == 2,
-							   (options & WNOWAIT),
-							   infop,
-							   stat_addr, ru);
+						(options & WNOWAIT), infop,
+						stat_addr, ru);
 				if (retval == -EAGAIN)
 					goto repeat;
 				if (retval != 0) /* He released the lock.  */
 					goto end;
-				break;
-			default:
-			// case EXIT_DEAD:
-				if (p->exit_state == EXIT_DEAD)
+			} else if (p->exit_state == EXIT_DEAD) {
+				continue;
+			} else if (p->exit_state == EXIT_ZOMBIE) {
+				/*
+				 * Eligible but we cannot release it yet:
+				 */
+				if (ret == 2)
+					goto check_continued;
+				if (!likely(options & WEXITED))
 					continue;
-			// case EXIT_ZOMBIE:
-				if (p->exit_state == EXIT_ZOMBIE) {
-					/*
-					 * Eligible but we cannot release
-					 * it yet:
-					 */
-					if (ret == 2)
-						goto check_continued;
-					if (!likely(options & WEXITED))
-						continue;
-					retval = wait_task_zombie(
-						p, (options & WNOWAIT),
-						infop, stat_addr, ru);
-					/* He released the lock.  */
-					if (retval != 0)
-						goto end;
-					break;
-				}
+				retval = wait_task_zombie(p,
+						(options & WNOWAIT), infop,
+						stat_addr, ru);
+				/* He released the lock.  */
+				if (retval != 0)
+					goto end;
+			} else {
 check_continued:
 				/*
 				 * It's running now, so it might later
@@ -1626,12 +1617,11 @@ check_continued:
 				flag = 1;
 				if (!unlikely(options & WCONTINUED))
 					continue;
-				retval = wait_task_continued(
-					p, (options & WNOWAIT),
-					infop, stat_addr, ru);
+				retval = wait_task_continued(p,
+						(options & WNOWAIT), infop,
+						stat_addr, ru);
 				if (retval != 0) /* He released the lock.  */
 					goto end;
-				break;
 			}
 		}
 		if (!flag) {
diff -puN kernel/power/process.c~use-macros-instead-of-task_-flags kernel/power/process.c
--- a/kernel/power/process.c~use-macros-instead-of-task_-flags
+++ a/kernel/power/process.c
@@ -86,9 +86,9 @@ static void fake_signal_wake_up(struct t
 
 static void send_fake_signal(struct task_struct *p)
 {
-	if (p->state == TASK_STOPPED)
+	if (is_task_stopped(p))
 		force_sig_specific(SIGSTOP, p);
-	fake_signal_wake_up(p, p->state == TASK_STOPPED);
+	fake_signal_wake_up(p, is_task_stopped(p));
 }
 
 static int has_mm(struct task_struct *p)
@@ -182,7 +182,7 @@ static int try_to_freeze_tasks(int freez
 			if (frozen(p) || !freezeable(p))
 				continue;
 
-			if (p->state == TASK_TRACED && frozen(p->parent)) {
+			if (is_task_traced(p) && frozen(p->parent)) {
 				cancel_freezing(p);
 				continue;
 			}
diff -puN kernel/ptrace.c~use-macros-instead-of-task_-flags kernel/ptrace.c
--- a/kernel/ptrace.c~use-macros-instead-of-task_-flags
+++ a/kernel/ptrace.c
@@ -51,7 +51,7 @@ void __ptrace_link(struct task_struct *c
 void ptrace_untrace(struct task_struct *child)
 {
 	spin_lock(&child->sighand->siglock);
-	if (child->state == TASK_TRACED) {
+	if (is_task_traced(child)) {
 		if (child->signal->flags & SIGNAL_STOP_STOPPED) {
 			child->state = TASK_STOPPED;
 		} else {
@@ -79,7 +79,7 @@ void __ptrace_unlink(struct task_struct 
 		add_parent(child);
 	}
 
-	if (child->state == TASK_TRACED)
+	if (is_task_traced(child))
 		ptrace_untrace(child);
 }
 
@@ -103,9 +103,9 @@ int ptrace_check_attach(struct task_stru
 	    && child->signal != NULL) {
 		ret = 0;
 		spin_lock_irq(&child->sighand->siglock);
-		if (child->state == TASK_STOPPED) {
+		if (is_task_stopped(child)) {
 			child->state = TASK_TRACED;
-		} else if (child->state != TASK_TRACED && !kill) {
+		} else if (!is_task_traced(child) && !kill) {
 			ret = -ESRCH;
 		}
 		spin_unlock_irq(&child->sighand->siglock);
diff -puN kernel/sched.c~use-macros-instead-of-task_-flags kernel/sched.c
--- a/kernel/sched.c~use-macros-instead-of-task_-flags
+++ a/kernel/sched.c
@@ -1383,7 +1383,7 @@ static int effective_prio(struct task_st
  */
 static void activate_task(struct rq *rq, struct task_struct *p, int wakeup)
 {
-	if (p->state == TASK_UNINTERRUPTIBLE)
+	if (is_task_loadavg(p))
 		rq->nr_uninterruptible--;
 
 	enqueue_task(rq, p, wakeup);
@@ -1395,7 +1395,7 @@ static void activate_task(struct rq *rq,
  */
 static void deactivate_task(struct rq *rq, struct task_struct *p, int sleep)
 {
-	if (p->state == TASK_UNINTERRUPTIBLE)
+	if (is_task_loadavg(p))
 		rq->nr_uninterruptible++;
 
 	dequeue_task(rq, p, sleep);
@@ -1928,8 +1928,7 @@ out:
 
 int fastcall wake_up_process(struct task_struct *p)
 {
-	return try_to_wake_up(p, TASK_STOPPED | TASK_TRACED |
-				 TASK_INTERRUPTIBLE | TASK_UNINTERRUPTIBLE, 0);
+	return try_to_wake_up(p, TASK_ALL, 0);
 }
 EXPORT_SYMBOL(wake_up_process);
 
@@ -4158,8 +4157,7 @@ void complete(struct completion *x)
 
 	spin_lock_irqsave(&x->wait.lock, flags);
 	x->done++;
-	__wake_up_common(&x->wait, TASK_UNINTERRUPTIBLE | TASK_INTERRUPTIBLE,
-			 1, 0, NULL);
+	__wake_up_common(&x->wait, TASK_NORMAL, 1, 0, NULL);
 	spin_unlock_irqrestore(&x->wait.lock, flags);
 }
 EXPORT_SYMBOL(complete);
@@ -4170,8 +4168,7 @@ void complete_all(struct completion *x)
 
 	spin_lock_irqsave(&x->wait.lock, flags);
 	x->done += UINT_MAX/2;
-	__wake_up_common(&x->wait, TASK_UNINTERRUPTIBLE | TASK_INTERRUPTIBLE,
-			 0, 0, NULL);
+	__wake_up_common(&x->wait, TASK_NORMAL, 0, 0, NULL);
 	spin_unlock_irqrestore(&x->wait.lock, flags);
 }
 EXPORT_SYMBOL(complete_all);
diff -puN kernel/signal.c~use-macros-instead-of-task_-flags kernel/signal.c
--- a/kernel/signal.c~use-macros-instead-of-task_-flags
+++ a/kernel/signal.c
@@ -838,7 +838,7 @@ static inline int wants_signal(int sig, 
 		return 0;
 	if (sig == SIGKILL)
 		return 1;
-	if (p->state & (TASK_STOPPED | TASK_TRACED))
+	if (is_task_stopped_or_traced(p))
 		return 0;
 	return task_curr(p) || !signal_pending(p);
 }
@@ -1419,7 +1419,7 @@ void do_notify_parent(struct task_struct
 	BUG_ON(sig == -1);
 
  	/* do_notify_parent_cldstop should have been called instead.  */
- 	BUG_ON(tsk->state & (TASK_STOPPED|TASK_TRACED));
+ 	BUG_ON(is_task_stopped_or_traced(tsk));
 
 	BUG_ON(!tsk->ptrace &&
 	       (tsk->group_leader != tsk || !thread_group_empty(tsk)));
@@ -1707,7 +1707,7 @@ static int do_signal_stop(int signr)
 			 * so this check has no races.
 			 */
 			if (!t->exit_state &&
-			    !(t->state & (TASK_STOPPED|TASK_TRACED))) {
+			    !is_task_stopped_or_traced(t)) {
 				stop_count++;
 				signal_wake_up(t, 0);
 			}
diff -puN kernel/wait.c~use-macros-instead-of-task_-flags kernel/wait.c
--- a/kernel/wait.c~use-macros-instead-of-task_-flags
+++ a/kernel/wait.c
@@ -215,7 +215,7 @@ void fastcall __wake_up_bit(wait_queue_h
 {
 	struct wait_bit_key key = __WAIT_BIT_KEY_INITIALIZER(word, bit);
 	if (waitqueue_active(wq))
-		__wake_up(wq, TASK_INTERRUPTIBLE|TASK_UNINTERRUPTIBLE, 1, &key);
+		__wake_up(wq, TASK_NORMAL, 1, &key);
 }
 EXPORT_SYMBOL(__wake_up_bit);
 
_

Patches currently in -mm which might be from matthew@wil.cx are

origin.patch
pcmcia-convert-some-internal-only-ioaddr_t-to-unsigned-int.patch
pcmcia-replace-kio_addr_t-with-unsigned-int-everywhere.patch
hash-add-explicit-u32-and-u64-versions-of-hash.patch
make-sure-nobodys-leaking-resources.patch
