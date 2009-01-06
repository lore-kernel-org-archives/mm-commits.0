From: akpm@linux-foundation.org
Subject: - mm-make-get_user_pages-interruptible-mmotm-ignore-sigkill-in-get_user_pages-during-munlock.patch removed from -mm tree
Date: Tue, 06 Jan 2009 12:18:08 -0800
Message-ID: <200901062018.n06KI9lZ014957@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58164 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751874AbZAFUSq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2009 15:18:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Lee.Schermerhorn@hp.com, hugh@veritas.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, menage@google.com, nickpiggin@yahoo.com.au, oleg@tv-sign.ru, penberg@cs.helsinki.fi


The patch titled
     ignore sigkill in get_user_pages during munlock
has been removed from the -mm tree.  Its filename was
     mm-make-get_user_pages-interruptible-mmotm-ignore-sigkill-in-get_user_pages-during-munlock.patch

This patch was dropped because it was folded into mm-make-get_user_pages-interruptible.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ignore sigkill in get_user_pages during munlock
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

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

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Paul Menage <menage@google.com>
Cc: Ying Han <yinghan@google.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Rohit Seth <rohitseth@google.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    1 +
 mm/memory.c   |   11 ++++++++---
 mm/mlock.c    |    9 +++++----
 3 files changed, 14 insertions(+), 7 deletions(-)

diff -puN mm/internal.h~mm-make-get_user_pages-interruptible-mmotm-ignore-sigkill-in-get_user_pages-during-munlock mm/internal.h
--- a/mm/internal.h~mm-make-get_user_pages-interruptible-mmotm-ignore-sigkill-in-get_user_pages-during-munlock
+++ a/mm/internal.h
@@ -276,6 +276,7 @@ static inline void mminit_validate_memmo
 #define GUP_FLAGS_WRITE                  0x1
 #define GUP_FLAGS_FORCE                  0x2
 #define GUP_FLAGS_IGNORE_VMA_PERMISSIONS 0x4
+#define GUP_FLAGS_IGNORE_SIGKILL         0x8
 
 int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 		     unsigned long start, int len, int flags,
diff -puN mm/memory.c~mm-make-get_user_pages-interruptible-mmotm-ignore-sigkill-in-get_user_pages-during-munlock mm/memory.c
--- a/mm/memory.c~mm-make-get_user_pages-interruptible-mmotm-ignore-sigkill-in-get_user_pages-during-munlock
+++ a/mm/memory.c
@@ -1197,6 +1197,7 @@ int __get_user_pages(struct task_struct 
 	int write = !!(flags & GUP_FLAGS_WRITE);
 	int force = !!(flags & GUP_FLAGS_FORCE);
 	int ignore = !!(flags & GUP_FLAGS_IGNORE_VMA_PERMISSIONS);
+	int ignore_sigkill = !!(flags & GUP_FLAGS_IGNORE_SIGKILL);
 
 	if (len <= 0)
 		return 0;
@@ -1275,10 +1276,14 @@ int __get_user_pages(struct task_struct 
 			struct page *page;
 
 			/*
-			 * If we have a pending SIGKILL, don't keep
-			 * allocating memory.
+			 * If we have a pending SIGKILL, don't keep faulting
+			 * pages and potentially allocating memory, unless
+			 * current is handling munlock--e.g., on exit. In
+			 * that case, we are not allocating memory.  Rather,
+			 * we're only unlocking already resident/mapped pages.
 			 */
-			if (unlikely(fatal_signal_pending(current)))
+			if (unlikely(!ignore_sigkill &&
+					fatal_signal_pending(current)))
 				return i ? i : -ERESTARTSYS;
 
 			if (write)
diff -puN mm/mlock.c~mm-make-get_user_pages-interruptible-mmotm-ignore-sigkill-in-get_user_pages-during-munlock mm/mlock.c
--- a/mm/mlock.c~mm-make-get_user_pages-interruptible-mmotm-ignore-sigkill-in-get_user_pages-during-munlock
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

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

cleanup-get-rid-of-ifdef-config_migration.patch
mm-add_active_or_unevictable-into-rmap.patch
vmscan-shrink_active_list-reduce-lru_lock-hold-time.patch
mm-make-get_user_pages-interruptible.patch
mm-make-get_user_pages-interruptible-mmotm-ignore-sigkill-in-get_user_pages-during-munlock.patch

