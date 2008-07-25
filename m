From: akpm@linux-foundation.org
Subject: - coredump-zap_threads-comments-use-while_each_thread.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:59:31 -0700
Message-ID: <200807252259.m6PMxV1S003397@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42920 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751486AbYGYXA1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:00:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     coredump: zap_threads: comments && use while_each_thread()
has been removed from the -mm tree.  Its filename was
     coredump-zap_threads-comments-use-while_each_thread.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: coredump: zap_threads: comments && use while_each_thread()
From: Oleg Nesterov <oleg@tv-sign.ru>

No changes in fs/exec.o

The for_each_process() loop in zap_threads() is very subtle, it is not
clear why we don't race with fork/exit/exec.  Add the fat comment.

Also, change the code to use while_each_thread().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   39 ++++++++++++++++++++++++++++++++-------
 1 file changed, 32 insertions(+), 7 deletions(-)

diff -puN fs/exec.c~coredump-zap_threads-comments-use-while_each_thread fs/exec.c
--- a/fs/exec.c~coredump-zap_threads-comments-use-while_each_thread
+++ a/fs/exec.c
@@ -1517,7 +1517,7 @@ static void zap_process(struct task_stru
 			sigaddset(&t->pending.signal, SIGKILL);
 			signal_wake_up(t, 1);
 		}
-	} while ((t = next_thread(t)) != start);
+	} while_each_thread(start, t);
 }
 
 static inline int zap_threads(struct task_struct *tsk, struct mm_struct *mm,
@@ -1539,7 +1539,36 @@ static inline int zap_threads(struct tas
 
 	if (atomic_read(&mm->mm_users) == mm->core_waiters + 1)
 		goto done;
-
+	/*
+	 * We should find and kill all tasks which use this mm, and we should
+	 * count them correctly into mm->core_waiters. We don't take tasklist
+	 * lock, but this is safe wrt:
+	 *
+	 * fork:
+	 *	None of sub-threads can fork after zap_process(leader). All
+	 *	processes which were created before this point should be
+	 *	visible to zap_threads() because copy_process() adds the new
+	 *	process to the tail of init_task.tasks list, and lock/unlock
+	 *	of ->siglock provides a memory barrier.
+	 *
+	 * do_exit:
+	 *	The caller holds mm->mmap_sem. This means that the task which
+	 *	uses this mm can't pass exit_mm(), so it can't exit or clear
+	 *	its ->mm.
+	 *
+	 * de_thread:
+	 *	It does list_replace_rcu(&leader->tasks, &current->tasks),
+	 *	we must see either old or new leader, this does not matter.
+	 *	However, it can change p->sighand, so lock_task_sighand(p)
+	 *	must be used. Since p->mm != NULL and we hold ->mmap_sem
+	 *	it can't fail.
+	 *
+	 *	Note also that "g" can be the old leader with ->mm == NULL
+	 *	and already unhashed and thus removed from ->thread_group.
+	 *	This is OK, __unhash_process()->list_del_rcu() does not
+	 *	clear the ->next pointer, we will find the new leader via
+	 *	next_thread().
+	 */
 	rcu_read_lock();
 	for_each_process(g) {
 		if (g == tsk->group_leader)
@@ -1549,17 +1578,13 @@ static inline int zap_threads(struct tas
 		do {
 			if (p->mm) {
 				if (p->mm == mm) {
-					/*
-					 * p->sighand can't disappear, but
-					 * may be changed by de_thread()
-					 */
 					lock_task_sighand(p, &flags);
 					zap_process(p);
 					unlock_task_sighand(p, &flags);
 				}
 				break;
 			}
-		} while ((p = next_thread(p)) != g);
+		} while_each_thread(g, p);
 	}
 	rcu_read_unlock();
 done:
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
linux-next.patch
migrate_timers-add-comment-use-spinlock_irq.patch
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

