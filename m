From: akpm@linux-foundation.org
Subject: + lockdep-spin_lock_nest_lock.patch added to -mm tree
Date: Mon, 04 Aug 2008 14:35:20 -0700
Message-ID: <200808042135.m74LZKIw032219@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41322 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765666AbYHDVkw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 17:40:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl


The patch titled
     lockdep: spin_lock_nest_lock()
has been added to the -mm tree.  Its filename is
     lockdep-spin_lock_nest_lock.patch

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
Subject: lockdep: spin_lock_nest_lock()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Expose the new lock protection lock.

This can be used to annotate places where we take multiple locks of the
same class and avoid deadlocks by always taking another (top-level) lock
first.

NOTE: we're still bound to the MAX_LOCK_DEPTH (48) limit.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/lockdep.h  |    2 ++
 include/linux/spinlock.h |    6 ++++++
 kernel/spinlock.c        |   11 +++++++++++
 3 files changed, 19 insertions(+)

diff -puN include/linux/lockdep.h~lockdep-spin_lock_nest_lock include/linux/lockdep.h
--- a/include/linux/lockdep.h~lockdep-spin_lock_nest_lock
+++ a/include/linux/lockdep.h
@@ -410,8 +410,10 @@ static inline void print_irqtrace_events
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # ifdef CONFIG_PROVE_LOCKING
 #  define spin_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
+#  define spin_acquire_nest(l, s, t, n, i)	lock_acquire(l, s, t, 0, 2, n, i)
 # else
 #  define spin_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
+#  define spin_acquire_nest(l, s, t, n, i)	lock_acquire(l, s, t, 0, 1, NULL, i)
 # endif
 # define spin_release(l, n, i)			lock_release(l, n, i)
 #else
diff -puN include/linux/spinlock.h~lockdep-spin_lock_nest_lock include/linux/spinlock.h
--- a/include/linux/spinlock.h~lockdep-spin_lock_nest_lock
+++ a/include/linux/spinlock.h
@@ -183,8 +183,14 @@ do {								\
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # define spin_lock_nested(lock, subclass) _spin_lock_nested(lock, subclass)
+# define spin_lock_nest_lock(lock, nest_lock)				\
+	 do {								\
+		 typecheck(struct lockdep_map *, &nest_lock->dep_map);	\
+		 _spin_lock_nest_lock(lock, &nest_lock->dep_map);	\
+	 } while (0)
 #else
 # define spin_lock_nested(lock, subclass) _spin_lock(lock)
+# define spin_lock_nest_lock(lock, nest_lock) _spin_lock(lock)
 #endif
 
 #define write_lock(lock)		_write_lock(lock)
diff -puN kernel/spinlock.c~lockdep-spin_lock_nest_lock kernel/spinlock.c
--- a/kernel/spinlock.c~lockdep-spin_lock_nest_lock
+++ a/kernel/spinlock.c
@@ -292,6 +292,7 @@ void __lockfunc _spin_lock_nested(spinlo
 }
 
 EXPORT_SYMBOL(_spin_lock_nested);
+
 unsigned long __lockfunc _spin_lock_irqsave_nested(spinlock_t *lock, int subclass)
 {
 	unsigned long flags;
@@ -314,6 +315,16 @@ unsigned long __lockfunc _spin_lock_irqs
 
 EXPORT_SYMBOL(_spin_lock_irqsave_nested);
 
+void __lockfunc _spin_lock_nest_lock(spinlock_t *lock,
+				     struct lockdep_map *nest_lock)
+{
+	preempt_disable();
+	spin_acquire_nest(&lock->dep_map, 0, 0, nest_lock, _RET_IP_);
+	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
+}
+
+EXPORT_SYMBOL(_spin_lock_nest_lock)
+
 #endif
 
 void __lockfunc _spin_unlock(spinlock_t *lock)
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

linux-next.patch
sched-type-fix.patch
lockdep-fix-combinatorial-explosion-in-lock-subgraph-traversal.patch
lockdep-lock_set_subclass-reset-a-held-locks-subclass.patch
lockdep-re-annotate-scheduler-runqueues.patch
lockdep-shrink-held_lock-structure.patch
lockdep-map_acquire.patch
lockdep-lock-protection-locks.patch
lockdep-spin_lock_nest_lock.patch

