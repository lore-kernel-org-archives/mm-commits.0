From: akpm@linux-foundation.org
Subject: + coredump-zap_threads-comments-use-while_each_thread.patch added to -mm tree
Date: Tue, 03 Jun 2008 12:50:54 -0700
Message-ID: <200806031950.m53JoscL016642@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41464 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753903AbYFCTvr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2008 15:51:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com


The patch titled
     coredump: zap_threads: comments && use while_each_thread()
has been added to the -mm tree.  Its filename is
     coredump-zap_threads-comments-use-while_each_thread.patch

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
Subject: coredump: zap_threads: comments && use while_each_thread()
From: Oleg Nesterov <oleg@tv-sign.ru>

No changes in fs/exec.o

The for_each_process() loop in zap_threads() is very subtle, it is not
clear why we don't race with fork/exit/exec.  Add the fat comment.

Also, change the code to use while_each_thread().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   39 ++++++++++++++++++++++++++++++++-------
 1 file changed, 32 insertions(+), 7 deletions(-)

diff -puN fs/exec.c~coredump-zap_threads-comments-use-while_each_thread fs/exec.c
--- a/fs/exec.c~coredump-zap_threads-comments-use-while_each_thread
+++ a/fs/exec.c
@@ -1515,7 +1515,7 @@ static void zap_process(struct task_stru
 			sigaddset(&t->pending.signal, SIGKILL);
 			signal_wake_up(t, 1);
 		}
-	} while ((t = next_thread(t)) != start);
+	} while_each_thread(start, t);
 }
 
 static inline int zap_threads(struct task_struct *tsk, struct mm_struct *mm,
@@ -1537,7 +1537,36 @@ static inline int zap_threads(struct tas
 
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
@@ -1547,17 +1576,13 @@ static inline int zap_threads(struct tas
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

vt-fix-vc_resize-locking.patch
uml-activate_mm-remove-the-dead-pf_borrowed_mm-check.patch
posix-timers-timer_delete-remove-the-bogus-it_process-=-null-check.patch
posix-timers-release_posix_timer-kill-the-bogus-put_task_struct-it_process.patch
signals-collect_signal-remove-the-unneeded-sigismember-check.patch
signals-collect_signal-simplify-the-still_pending-logic.patch
signals-change-collect_signal-to-return-void.patch
__exit_signal-dont-take-rcu-lock.patch
signals-dequeue_signal-dont-check-signal_group_exit-when-setting-signal_stop_dequeued.patch
signals-do_signal_stop-kill-the-signal_unkillable-check.patch
coredump-zap_threads-comments-use-while_each_thread.patch
distinct-tgid-tid-i-o-statistics.patch

