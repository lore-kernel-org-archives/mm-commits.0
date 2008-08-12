From: akpm@linux-foundation.org
Subject: - lockdep-spin_lock_nest_lock-fix.patch removed from -mm tree
Date: Tue, 12 Aug 2008 13:26:40 -0700
Message-ID: <200808122026.m7CKQeDG011489@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38870 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751696AbYHLU0n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Aug 2008 16:26:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org


The patch titled
     lockdep-spin_lock_nest_lock fix
has been removed from the -mm tree.  Its filename was
     lockdep-spin_lock_nest_lock-fix.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lockdep-spin_lock_nest_lock fix
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/spinlock.h         |    4 ++--
 include/linux/spinlock_api_smp.h |    2 ++
 kernel/spinlock.c                |    2 +-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff -puN include/linux/spinlock.h~lockdep-spin_lock_nest_lock-fix include/linux/spinlock.h
--- a/include/linux/spinlock.h~lockdep-spin_lock_nest_lock-fix
+++ a/include/linux/spinlock.h
@@ -185,8 +185,8 @@ do {								\
 # define spin_lock_nested(lock, subclass) _spin_lock_nested(lock, subclass)
 # define spin_lock_nest_lock(lock, nest_lock)				\
 	 do {								\
-		 typecheck(struct lockdep_map *, &nest_lock->dep_map);	\
-		 _spin_lock_nest_lock(lock, &nest_lock->dep_map);	\
+		 typecheck(struct lockdep_map *, &(nest_lock)->dep_map);\
+		 _spin_lock_nest_lock(lock, &(nest_lock)->dep_map);	\
 	 } while (0)
 #else
 # define spin_lock_nested(lock, subclass) _spin_lock(lock)
diff -puN include/linux/spinlock_api_smp.h~lockdep-spin_lock_nest_lock-fix include/linux/spinlock_api_smp.h
--- a/include/linux/spinlock_api_smp.h~lockdep-spin_lock_nest_lock-fix
+++ a/include/linux/spinlock_api_smp.h
@@ -22,6 +22,8 @@ int in_lock_functions(unsigned long addr
 void __lockfunc _spin_lock(spinlock_t *lock)		__acquires(lock);
 void __lockfunc _spin_lock_nested(spinlock_t *lock, int subclass)
 							__acquires(lock);
+void __lockfunc _spin_lock_nest_lock(spinlock_t *lock, struct lockdep_map *map)
+							__acquires(lock);
 void __lockfunc _read_lock(rwlock_t *lock)		__acquires(lock);
 void __lockfunc _write_lock(rwlock_t *lock)		__acquires(lock);
 void __lockfunc _spin_lock_bh(spinlock_t *lock)		__acquires(lock);
diff -puN kernel/spinlock.c~lockdep-spin_lock_nest_lock-fix kernel/spinlock.c
--- a/kernel/spinlock.c~lockdep-spin_lock_nest_lock-fix
+++ a/kernel/spinlock.c
@@ -323,7 +323,7 @@ void __lockfunc _spin_lock_nest_lock(spi
 	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
 }
 
-EXPORT_SYMBOL(_spin_lock_nest_lock)
+EXPORT_SYMBOL(_spin_lock_nest_lock);
 
 #endif
 
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
linux-next.patch
lockdep-spin_lock_nest_lock-fix.patch
lockdep-spin_lock_nest_lock-fix-checkpatch-fixes.patch
lockdep-annotate-mm_take_all_locks.patch
lockdep-handle-chains-involving-classes-defined-in-modules.patch
mm-fix-mm_take_all_locks-locking-order.patch
irq-warn-about-irqf_disabledirqf_shared.patch

