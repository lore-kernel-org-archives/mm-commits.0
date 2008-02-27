From: akpm@linux-foundation.org
Subject: - kill-double_spin_lock.patch removed from -mm tree
Date: Wed, 27 Feb 2008 14:17:28 -0800
Message-ID: <200802272217.m1RMHSuf000815@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:48454 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759288AbYB0WSt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 17:18:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, a.p.zijlstra@chello.nl, arjan@linux.intel.com, heiko.carstens@de.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     kill double_spin_lock()
has been removed from the -mm tree.  Its filename was
     kill-double_spin_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-hrt.patch
kthread-add-a-missing-memory-barrier-to-kthread_stop.patch
kthread-call-wake_up_process-without-the-lock-being-held.patch
documentation-atomic_add_unless-doesnt-imply-mb-on-failure-fix.patch
mmap_region-cleanup-the-final-vma_merge-related-code.patch
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
consolidate-checking-for-ignored-legacy-signals-simplify.patch
signals-do_signal_stop-use-signal_group_exit.patch
signals-do_group_exit-use-signal_group_exit-more-consistently.patch
lock_task_sighand-add-rcu-lock-unlock.patch
k_getrusage-dont-take-rcu_read_lock.patch
do_task_stat-dont-take-rcu_read_lock.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
cleanup_workqueue_thread-remove-the-unneeded-cpu-parameter.patch
simplify-cpu_hotplug_begin-put_online_cpus.patch
redo-locking-of-tty-pgrp.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
procfs-task-exe-symlink-fix-2.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch
