From: akpm@linux-foundation.org
Subject: + kill-double_spin_lock.patch added to -mm tree
Date: Fri, 15 Feb 2008 12:56:54 -0800
Message-ID: <200802152056.m1FKusdK023430@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37315 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763968AbYBOU5c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 15:57:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, a.p.zijlstra@chello.nl, arjan@linux.intel.com, heiko.carstens@de.ibm.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     kill double_spin_lock()
has been added to the -mm tree.  Its filename is
     kill-double_spin_lock.patch

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
Subject: kill double_spin_lock()
From: Oleg Nesterov <oleg@tv-sign.ru>

double_spin_lock() has no callers, and it can't be used without additional
lockdep annotations, remove it.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/spinlock.h |   37 -------------------------------------
 1 file changed, 37 deletions(-)

diff -puN include/linux/spinlock.h~kill-double_spin_lock include/linux/spinlock.h
--- a/include/linux/spinlock.h~kill-double_spin_lock
+++ a/include/linux/spinlock.h
@@ -296,43 +296,6 @@ do {						\
 })
 
 /*
- * Locks two spinlocks l1 and l2.
- * l1_first indicates if spinlock l1 should be taken first.
- */
-static inline void double_spin_lock(spinlock_t *l1, spinlock_t *l2,
-				    bool l1_first)
-	__acquires(l1)
-	__acquires(l2)
-{
-	if (l1_first) {
-		spin_lock(l1);
-		spin_lock(l2);
-	} else {
-		spin_lock(l2);
-		spin_lock(l1);
-	}
-}
-
-/*
- * Unlocks two spinlocks l1 and l2.
- * l1_taken_first indicates if spinlock l1 was taken first and therefore
- * should be released after spinlock l2.
- */
-static inline void double_spin_unlock(spinlock_t *l1, spinlock_t *l2,
-				      bool l1_taken_first)
-	__releases(l1)
-	__releases(l2)
-{
-	if (l1_taken_first) {
-		spin_unlock(l2);
-		spin_unlock(l1);
-	} else {
-		spin_unlock(l1);
-		spin_unlock(l2);
-	}
-}
-
-/*
  * Pull the atomic_t declaration:
  * (asm-mips/atomic.h needs above definitions)
  */
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

mmap_region-cleanup-the-final-vma_merge-related-code.patch
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
consolidate-checking-for-ignored-legacy-signals-simplify.patch
signals-do_signal_stop-use-signal_group_exit.patch
timers-simplify-lockdep-stuff.patch
hrtimers-simplify-lockdep-stuff.patch
kill-double_spin_lock.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
