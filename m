From: akpm@linux-foundation.org
Subject: + kill-pf_borrowed_mm-in-favour-of-pf_kthread.patch added to -mm tree
Date: Wed, 04 Jun 2008 00:57:53 -0700
Message-ID: <200806040757.m547vrcn011130@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37927 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752329AbYFDH7j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2008 03:59:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com


The patch titled
     kill PF_BORROWED_MM in favour of PF_KTHREAD
has been added to the -mm tree.  Its filename is
     kill-pf_borrowed_mm-in-favour-of-pf_kthread.patch

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
Subject: kill PF_BORROWED_MM in favour of PF_KTHREAD
From: Oleg Nesterov <oleg@tv-sign.ru>

Kill PF_BORROWED_MM.  Change use_mm/unuse_mm to not play with ->flags, and
do s/PF_BORROWED_MM/PF_KTHREAD/ for a couple of other users.

No functional changes yet.  But this allows us to do further
fixes/cleanups.

oom_kill/ptrace/etc often check "p->mm != NULL" to filter out the
kthreads, this is wrong because of use_mm().  The problem with
PF_BORROWED_MM is that we need task_lock() to avoid races.  With this
patch we can check PF_KTHREAD directly, or use a simple lockless helper:

	/* The result must not be dereferenced !!! */
	struct mm_struct *__get_task_mm(struct task_struct *tsk)
	{
		if (tsk->flags & PF_KTHREAD)
			return NULL;
		return tsk->mm;
	}

Note also ecard_task().  It runs with ->mm != NULL, but it's the kernel
thread without PF_BORROWED_MM.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c               |    2 --
 include/linux/sched.h  |    3 +--
 kernel/fork.c          |    4 ++--
 kernel/power/process.c |    2 +-
 4 files changed, 4 insertions(+), 7 deletions(-)

diff -puN fs/aio.c~kill-pf_borrowed_mm-in-favour-of-pf_kthread fs/aio.c
--- a/fs/aio.c~kill-pf_borrowed_mm-in-favour-of-pf_kthread
+++ a/fs/aio.c
@@ -586,7 +586,6 @@ static void use_mm(struct mm_struct *mm)
 	struct task_struct *tsk = current;
 
 	task_lock(tsk);
-	tsk->flags |= PF_BORROWED_MM;
 	active_mm = tsk->active_mm;
 	atomic_inc(&mm->mm_count);
 	tsk->mm = mm;
@@ -614,7 +613,6 @@ static void unuse_mm(struct mm_struct *m
 	struct task_struct *tsk = current;
 
 	task_lock(tsk);
-	tsk->flags &= ~PF_BORROWED_MM;
 	tsk->mm = NULL;
 	/* active_mm is still 'mm' */
 	enter_lazy_tlb(mm, tsk);
diff -puN include/linux/sched.h~kill-pf_borrowed_mm-in-favour-of-pf_kthread include/linux/sched.h
--- a/include/linux/sched.h~kill-pf_borrowed_mm-in-favour-of-pf_kthread
+++ a/include/linux/sched.h
@@ -1500,7 +1500,7 @@ static inline void put_task_struct(struc
 #define PF_KSWAPD	0x00040000	/* I am kswapd */
 #define PF_SWAPOFF	0x00080000	/* I am in swapoff */
 #define PF_LESS_THROTTLE 0x00100000	/* Throttle me less: I clean memory */
-#define PF_BORROWED_MM	0x00200000	/* I am a kthread doing use_mm */
+#define PF_KTHREAD	0x00200000	/* I am a kernel thread */
 #define PF_RANDOMIZE	0x00400000	/* randomize virtual address space */
 #define PF_SWAPWRITE	0x00800000	/* Allowed to write to swap */
 #define PF_SPREAD_PAGE	0x01000000	/* Spread page cache over cpuset */
@@ -1508,7 +1508,6 @@ static inline void put_task_struct(struc
 #define PF_MEMPOLICY	0x10000000	/* Non-default NUMA mempolicy */
 #define PF_MUTEX_TESTER	0x20000000	/* Thread belongs to the rt mutex tester */
 #define PF_FREEZER_SKIP	0x40000000	/* Freezer should not count it as freezeable */
-#define PF_KTHREAD	0x80000000	/* I am a kernel thread */
 
 /*
  * Only the _current_ task can read/write to tsk->flags, but other
diff -puN kernel/fork.c~kill-pf_borrowed_mm-in-favour-of-pf_kthread kernel/fork.c
--- a/kernel/fork.c~kill-pf_borrowed_mm-in-favour-of-pf_kthread
+++ a/kernel/fork.c
@@ -452,7 +452,7 @@ EXPORT_SYMBOL_GPL(mmput);
 /**
  * get_task_mm - acquire a reference to the task's mm
  *
- * Returns %NULL if the task has no mm.  Checks PF_BORROWED_MM (meaning
+ * Returns %NULL if the task has no mm.  Checks PF_KTHREAD (meaning
  * this kernel workthread has transiently adopted a user mm with use_mm,
  * to do its AIO) is not set and if so returns a reference to it, after
  * bumping up the use count.  User must release the mm via mmput()
@@ -465,7 +465,7 @@ struct mm_struct *get_task_mm(struct tas
 	task_lock(task);
 	mm = task->mm;
 	if (mm) {
-		if (task->flags & PF_BORROWED_MM)
+		if (task->flags & PF_KTHREAD)
 			mm = NULL;
 		else
 			atomic_inc(&mm->mm_users);
diff -puN kernel/power/process.c~kill-pf_borrowed_mm-in-favour-of-pf_kthread kernel/power/process.c
--- a/kernel/power/process.c~kill-pf_borrowed_mm-in-favour-of-pf_kthread
+++ a/kernel/power/process.c
@@ -86,7 +86,7 @@ static void fake_signal_wake_up(struct t
 
 static int has_mm(struct task_struct *p)
 {
-	return (p->mm && !(p->flags & PF_BORROWED_MM));
+	return (p->mm && !(p->flags & PF_KTHREAD));
 }
 
 /**
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

vt-fix-vc_resize-locking.patch
introduce-pf_kthread-flag.patch
kill-pf_borrowed_mm-in-favour-of-pf_kthread.patch
coredump-zap_threads-must-skip-kernel-threads.patch
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

