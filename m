From: akpm@linux-foundation.org
Subject: + kernel-exit-compute-current-directly.patch added to -mm tree
Date: Thu, 05 Jan 2017 16:19:22 -0800
Message-ID: <586ee28a.ibvucEwIQWMVU5UK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58644 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754727AbdAFASK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2017 19:18:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, mark.rutland@arm.com, mingo@elte.hu, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/exit: compute current directly
has been added to the -mm tree.  Its filename is
     kernel-exit-compute-current-directly.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-exit-compute-current-directly.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-exit-compute-current-directly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: kernel/exit: compute current directly

Patch series "current vs ptr to current dereferencing".

First three patches get rid of 'tsk = current' based assignments to
simply use current/get_current macro directly now that we have some
actual numbers -- in which the conversion does improve some performance
numbers, specially the locking bits. This is only around what directly
is touched by patch 4, making it very obvious that we are indeed calling
upon the current task. There are other users left with this pattern that
could be cleaned up later.


This patch (of 4):

This patch effectively replaces the tsk pointer dereference (which is
obviously == current), to directly use get_current() macro.  In this case,
do_exit() always passes current to exit_mm(), hence we can simply get rid
of the arg.  This is also a performance win on some archs such as x86-64
and ppc64 -- arm64 is no longer an issue:

    https://lkml.org/lkml/2016/12/30/230

Link: http://lkml.kernel.org/r/1483479794-14013-2-git-send-email-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN kernel/exit.c~kernel-exit-compute-current-directly kernel/exit.c
--- a/kernel/exit.c~kernel-exit-compute-current-directly
+++ a/kernel/exit.c
@@ -468,12 +468,12 @@ assign_new_owner:
  * Turn us into a lazy TLB process if we
  * aren't already..
  */
-static void exit_mm(struct task_struct *tsk)
+static void exit_mm(void)
 {
-	struct mm_struct *mm = tsk->mm;
+	struct mm_struct *mm = current->mm;
 	struct core_state *core_state;
 
-	mm_release(tsk, mm);
+	mm_release(current, mm);
 	if (!mm)
 		return;
 	sync_mm_rss(mm);
@@ -491,7 +491,7 @@ static void exit_mm(struct task_struct *
 
 		up_read(&mm->mmap_sem);
 
-		self.task = tsk;
+		self.task = current;
 		self.next = xchg(&core_state->dumper.next, &self);
 		/*
 		 * Implies mb(), the result of xchg() must be visible
@@ -501,22 +501,22 @@ static void exit_mm(struct task_struct *
 			complete(&core_state->startup);
 
 		for (;;) {
-			set_task_state(tsk, TASK_UNINTERRUPTIBLE);
+			set_task_state(current, TASK_UNINTERRUPTIBLE);
 			if (!self.task) /* see coredump_finish() */
 				break;
 			freezable_schedule();
 		}
-		__set_task_state(tsk, TASK_RUNNING);
+		__set_task_state(current, TASK_RUNNING);
 		down_read(&mm->mmap_sem);
 	}
 	atomic_inc(&mm->mm_count);
-	BUG_ON(mm != tsk->active_mm);
+	BUG_ON(mm != current->active_mm);
 	/* more a memory barrier than a real lock */
-	task_lock(tsk);
-	tsk->mm = NULL;
+	task_lock(current);
+	current->mm = NULL;
 	up_read(&mm->mmap_sem);
 	enter_lazy_tlb(mm, current);
-	task_unlock(tsk);
+	task_unlock(current);
 	mm_update_next_owner(mm);
 	mmput(mm);
 	if (test_thread_flag(TIF_MEMDIE))
@@ -823,7 +823,7 @@ void __noreturn do_exit(long code)
 	tsk->exit_code = code;
 	taskstats_exit(tsk, group_dead);
 
-	exit_mm(tsk);
+	exit_mm();
 
 	if (group_dead)
 		acct_process();
_

Patches currently in -mm which might be from dave@stgolabs.net are

kernel-exit-compute-current-directly.patch
drivers-tty-compute-current-directly.patch
kernel-locking-compute-current-directly.patch
sched-remove-set_task_state.patch

