From: akpm@linux-foundation.org
Subject: + make-get_user_pages-interruptible.patch added to -mm tree
Date: Tue, 25 Nov 2008 15:44:11 -0800
Message-ID: <200811252344.mAPNiBUO020429@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46096 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753048AbYKYXov (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Nov 2008 18:44:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yinghan@google.com, hugh@veritas.com, matthew@wil.cx, menage@google.com, nickpiggin@yahoo.com.au, penberg@cs.helsinki.fi, rientjes@google.com


The patch titled
     mm: make get_user_pages interruptible
has been added to the -mm tree.  Its filename is
     make-get_user_pages-interruptible.patch

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
Subject: mm: make get_user_pages interruptible
From: Ying Han <yinghan@google.com>

The initial implementation of checking TIF_MEMDIE covers the cases of OOM
killing.  If the process has been OOM killed, the TIF_MEMDIE is set and it
return immediately.  This patch includes:

1.  add the case that the SIGKILL is sent by user processes.  The
   process can try to get_user_pages() unlimited memory even if a user
   process has sent a SIGKILL to it(maybe a monitor find the process
   exceed its memory limit and try to kill it).  In the old
   implementation, the SIGKILL won't be handled until the get_user_pages()
   returns.

2.  change the return value to be ERESTARTSYS.  It makes no sense to
   return ENOMEM if the get_user_pages returned by getting a SIGKILL
   signal.  Considering the general convention for a system call
   interrupted by a signal is ERESTARTNOSYS, so the current return value
   is consistant to that.

Signed-off-by: Paul Menage <menage@google.com>
Signed-off-by:Ying Han <yinghan@google.com>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    1 +
 kernel/signal.c       |    2 +-
 mm/memory.c           |   10 +++++-----
 3 files changed, 7 insertions(+), 6 deletions(-)

diff -puN include/linux/sched.h~make-get_user_pages-interruptible include/linux/sched.h
--- a/include/linux/sched.h~make-get_user_pages-interruptible
+++ a/include/linux/sched.h
@@ -1750,6 +1750,7 @@ extern void wake_up_new_task(struct task
 extern void sched_fork(struct task_struct *p, int clone_flags);
 extern void sched_dead(struct task_struct *p);
 
+extern int sigkill_pending(struct task_struct *tsk);
 extern void proc_caches_init(void);
 extern void flush_signals(struct task_struct *);
 extern void ignore_signals(struct task_struct *);
diff -puN kernel/signal.c~make-get_user_pages-interruptible kernel/signal.c
--- a/kernel/signal.c~make-get_user_pages-interruptible
+++ a/kernel/signal.c
@@ -1516,7 +1516,7 @@ static inline int may_ptrace_stop(void)
  * Return nonzero if there is a SIGKILL that should be waking us up.
  * Called with the siglock held.
  */
-static int sigkill_pending(struct task_struct *tsk)
+int sigkill_pending(struct task_struct *tsk)
 {
 	return	sigismember(&tsk->pending.signal, SIGKILL) ||
 		sigismember(&tsk->signal->shared_pending.signal, SIGKILL);
diff -puN mm/memory.c~make-get_user_pages-interruptible mm/memory.c
--- a/mm/memory.c~make-get_user_pages-interruptible
+++ a/mm/memory.c
@@ -1219,12 +1219,12 @@ int __get_user_pages(struct task_struct 
 			struct page *page;
 
 			/*
-			 * If tsk is ooming, cut off its access to large memory
-			 * allocations. It has a pending SIGKILL, but it can't
-			 * be processed until returning to user space.
+			 * If we have a pending SIGKILL, don't keep
+			 * allocating memory.
 			 */
-			if (unlikely(test_tsk_thread_flag(tsk, TIF_MEMDIE)))
-				return i ? i : -ENOMEM;
+			if (unlikely(sigkill_pending(current) ||
+					sigkill_pending(tsk)))
+				return i ? i : -ERESTARTSYS;
 
 			if (write)
 				foll_flags |= FOLL_WRITE;
_

Patches currently in -mm which might be from yinghan@google.com are

make-get_user_pages-interruptible.patch

