From: akpm@linux-foundation.org
Subject: + lockdep-spin_lock_nest_lock-fix.patch added to -mm tree
Date: Thu, 07 Aug 2008 14:40:13 -0700
Message-ID: <200808072140.m77LeD8m006969@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52949 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751739AbYHGVlF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2008 17:41:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl


The patch titled
     lockdep-spin_lock_nest_lock fix
has been added to the -mm tree.  Its filename is
     lockdep-spin_lock_nest_lock-fix.patch

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

linux-next.patch
sched-type-fix.patch
lockdep-fix-combinatorial-explosion-in-lock-subgraph-traversal.patch
lockdep-fix-combinatorial-explosion-in-lock-subgraph-traversal-fix.patch
lockdep-lock_set_subclass-reset-a-held-locks-subclass.patch
lockdep-re-annotate-scheduler-runqueues.patch
lockdep-shrink-held_lock-structure.patch
lockdep-shrink-held_lock-structure-fix.patch
lockdep-shrink-held_lock-structure-fix-2.patch
lockdep-map_acquire.patch
lockdep-lock-protection-locks.patch
lockdep-spin_lock_nest_lock.patch
lockdep-spin_lock_nest_lock-fix.patch

