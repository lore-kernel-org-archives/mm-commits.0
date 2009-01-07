From: akpm@linux-foundation.org
Subject: - mm-make-get_user_pages-interruptible.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:14:21 -0800
Message-ID: <200901072214.n07MELtY014305@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53380 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761116AbZAGWOt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:14:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghan@google.com, hugh@veritas.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, menage@google.com, nickpiggin@yahoo.com.au, oleg@tv-sign.ru, penberg@cs.helsinki.fi, rie


The patch titled
     mm: make get_user_pages() interruptible
has been removed from the -mm tree.  Its filename was
     mm-make-get_user_pages-interruptible.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: make get_user_pages() interruptible
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


Lee:

An unfortunate side effect of "make-get_user_pages-interruptible" is that
it prevents a SIGKILL'd task from munlock-ing pages that it had mlocked,
resulting in freeing of mlocked pages.  Freeing of mlocked pages, in
itself, is not so bad.  We just count them now--altho' I had hoped to
remove this stat and add PG_MLOCKED to the free pages flags check.

However, consider pages in shared libraries mapped by more than one task
that a task mlocked--e.g., via mlockall().  If the task that mlocked the
pages exits via SIGKILL, these pages would be left mlocked and
unevictable.

Proposed fix:

Add another GUP flag to ignore sigkill when calling get_user_pages from
munlock()--similar to Kosaki Motohiro's 'IGNORE_VMA_PERMISSIONS flag for
the same purpose.  We are not actually allocating memory in this case,
which "make-get_user_pages-interruptible" intends to avoid.  We're just
munlocking pages that are already resident and mapped, and we're reusing
get_user_pages() to access those pages.

??  Maybe we should combine 'IGNORE_VMA_PERMISSIONS and '_IGNORE_SIGKILL
into a single flag: GUP_FLAGS_MUNLOCK ???

[Lee.Schermerhorn@hp.com: ignore sigkill in get_user_pages during munlock]
Signed-off-by: Paul Menage <menage@google.com>
Signed-off-by: Ying Han <yinghan@google.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Rohit Seth <rohitseth@google.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    1 +
 mm/memory.c   |   14 +++++++++-----
 mm/mlock.c    |    9 +++++----
 3 files changed, 15 insertions(+), 9 deletions(-)

diff -puN mm/internal.h~mm-make-get_user_pages-interruptible mm/internal.h
--- a/mm/internal.h~mm-make-get_user_pages-interruptible
+++ a/mm/internal.h
@@ -276,6 +276,7 @@ static inline void mminit_validate_memmo
 #define GUP_FLAGS_WRITE                  0x1
 #define GUP_FLAGS_FORCE                  0x2
 #define GUP_FLAGS_IGNORE_VMA_PERMISSIONS 0x4
+#define GUP_FLAGS_IGNORE_SIGKILL         0x8
 
 int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 		     unsigned long start, int len, int flags,
diff -puN mm/memory.c~mm-make-get_user_pages-interruptible mm/memory.c
--- a/mm/memory.c~mm-make-get_user_pages-interruptible
+++ a/mm/memory.c
@@ -1210,6 +1210,7 @@ int __get_user_pages(struct task_struct 
 	int write = !!(flags & GUP_FLAGS_WRITE);
 	int force = !!(flags & GUP_FLAGS_FORCE);
 	int ignore = !!(flags & GUP_FLAGS_IGNORE_VMA_PERMISSIONS);
+	int ignore_sigkill = !!(flags & GUP_FLAGS_IGNORE_SIGKILL);
 
 	if (len <= 0)
 		return 0;
@@ -1288,12 +1289,15 @@ int __get_user_pages(struct task_struct 
 			struct page *page;
 
 			/*
-			 * If tsk is ooming, cut off its access to large memory
-			 * allocations. It has a pending SIGKILL, but it can't
-			 * be processed until returning to user space.
+			 * If we have a pending SIGKILL, don't keep faulting
+			 * pages and potentially allocating memory, unless
+			 * current is handling munlock--e.g., on exit. In
+			 * that case, we are not allocating memory.  Rather,
+			 * we're only unlocking already resident/mapped pages.
 			 */
-			if (unlikely(test_tsk_thread_flag(tsk, TIF_MEMDIE)))
-				return i ? i : -ENOMEM;
+			if (unlikely(!ignore_sigkill &&
+					fatal_signal_pending(current)))
+				return i ? i : -ERESTARTSYS;
 
 			if (write)
 				foll_flags |= FOLL_WRITE;
diff -puN mm/mlock.c~mm-make-get_user_pages-interruptible mm/mlock.c
--- a/mm/mlock.c~mm-make-get_user_pages-interruptible
+++ a/mm/mlock.c
@@ -173,12 +173,13 @@ static long __mlock_vma_pages_range(stru
 		  (atomic_read(&mm->mm_users) != 0));
 
 	/*
-	 * mlock:   don't page populate if page has PROT_NONE permission.
-	 * munlock: the pages always do munlock althrough
-	 *          its has PROT_NONE permission.
+	 * mlock:   don't page populate if vma has PROT_NONE permission.
+	 * munlock: always do munlock although the vma has PROT_NONE
+	 *          permission, or SIGKILL is pending.
 	 */
 	if (!mlock)
-		gup_flags |= GUP_FLAGS_IGNORE_VMA_PERMISSIONS;
+		gup_flags |= GUP_FLAGS_IGNORE_VMA_PERMISSIONS |
+			     GUP_FLAGS_IGNORE_SIGKILL;
 
 	if (vma->vm_flags & VM_WRITE)
 		gup_flags |= GUP_FLAGS_WRITE;
_

Patches currently in -mm which might be from yinghan@google.com are

origin.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch

