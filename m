From: akpm@linux-foundation.org
Subject: + lockdep-lock-protection-locks.patch added to -mm tree
Date: Mon, 04 Aug 2008 14:35:18 -0700
Message-ID: <200808042135.m74LZIR9032213@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58846 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765425AbYHDVfy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 17:35:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl


The patch titled
     lockdep: lock protection locks
has been added to the -mm tree.  Its filename is
     lockdep-lock-protection-locks.patch

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
Subject: lockdep: lock protection locks
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

On Fri, 2008-08-01 at 16:26 -0700, Linus Torvalds wrote:

> On Fri, 1 Aug 2008, David Miller wrote:
> >
> > Taking more than a few locks of the same class at once is bad
> > news and it's better to find an alternative method.
>
> It's not always wrong.
>
> If you can guarantee that anybody that takes more than one lock of a
> particular class will always take a single top-level lock _first_, then
> that's all good. You can obviously screw up and take the same lock _twice_
> (which will deadlock), but at least you cannot get into ABBA situations.
>
> So maybe the right thing to do is to just teach lockdep about "lock
> protection locks". That would have solved the multi-queue issues for
> networking too - all the actual network drivers would still have taken
> just their single queue lock, but the one case that needs to take all of
> them would have taken a separate top-level lock first.
>
> Never mind that the multi-queue locks were always taken in the same order:
> it's never wrong to just have some top-level serialization, and anybody
> who needs to take <n> locks might as well do <n+1>, because they sure as
> hell aren't going to be on _any_ fastpaths.
>
> So the simplest solution really sounds like just teaching lockdep about
> that one special case. It's not "nesting" exactly, although it's obviously
> related to it.

Do as Linus suggested. The lock protection lock is called nest_lock.

Note that we still have the MAX_LOCK_DEPTH (48) limit to consider, so anything
that spills that it still up shit creek.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/lockdep.h    |   34 ++++++++++++++++++----------------
 include/linux/rcuclassic.h |    2 +-
 kernel/lockdep.c           |   26 +++++++++++++++++++++-----
 3 files changed, 40 insertions(+), 22 deletions(-)

diff -puN include/linux/lockdep.h~lockdep-lock-protection-locks include/linux/lockdep.h
--- a/include/linux/lockdep.h~lockdep-lock-protection-locks
+++ a/include/linux/lockdep.h
@@ -211,6 +211,7 @@ struct held_lock {
 	u64				prev_chain_key;
 	unsigned long			acquire_ip;
 	struct lockdep_map		*instance;
+	struct lockdep_map		*nest_lock;
 #ifdef CONFIG_LOCK_STAT
 	u64 				waittime_stamp;
 	u64				holdtime_stamp;
@@ -297,7 +298,8 @@ extern void lockdep_init_map(struct lock
  *   2: full validation
  */
 extern void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
-			 int trylock, int read, int check, unsigned long ip);
+			 int trylock, int read, int check,
+			 struct lockdep_map *nest_lock, unsigned long ip);
 
 extern void lock_release(struct lockdep_map *lock, int nested,
 			 unsigned long ip);
@@ -319,7 +321,7 @@ static inline void lockdep_on(void)
 {
 }
 
-# define lock_acquire(l, s, t, r, c, i)		do { } while (0)
+# define lock_acquire(l, s, t, r, c, n, i)	do { } while (0)
 # define lock_release(l, n, i)			do { } while (0)
 # define lock_set_subclass(l, s, i)		do { } while (0)
 # define lockdep_init()				do { } while (0)
@@ -407,9 +409,9 @@ static inline void print_irqtrace_events
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # ifdef CONFIG_PROVE_LOCKING
-#  define spin_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, i)
+#  define spin_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
 # else
-#  define spin_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, i)
+#  define spin_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
 # endif
 # define spin_release(l, n, i)			lock_release(l, n, i)
 #else
@@ -419,11 +421,11 @@ static inline void print_irqtrace_events
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # ifdef CONFIG_PROVE_LOCKING
-#  define rwlock_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, i)
-#  define rwlock_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 2, 2, i)
+#  define rwlock_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
+#  define rwlock_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 2, 2, NULL, i)
 # else
-#  define rwlock_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, i)
-#  define rwlock_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 2, 1, i)
+#  define rwlock_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
+#  define rwlock_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 2, 1, NULL, i)
 # endif
 # define rwlock_release(l, n, i)		lock_release(l, n, i)
 #else
@@ -434,9 +436,9 @@ static inline void print_irqtrace_events
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # ifdef CONFIG_PROVE_LOCKING
-#  define mutex_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, i)
+#  define mutex_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
 # else
-#  define mutex_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, i)
+#  define mutex_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
 # endif
 # define mutex_release(l, n, i)			lock_release(l, n, i)
 #else
@@ -446,11 +448,11 @@ static inline void print_irqtrace_events
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # ifdef CONFIG_PROVE_LOCKING
-#  define rwsem_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, i)
-#  define rwsem_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 1, 2, i)
+#  define rwsem_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
+#  define rwsem_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 1, 2, NULL, i)
 # else
-#  define rwsem_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, i)
-#  define rwsem_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 1, 1, i)
+#  define rwsem_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
+#  define rwsem_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 1, 1, NULL, i)
 # endif
 # define rwsem_release(l, n, i)			lock_release(l, n, i)
 #else
@@ -461,9 +463,9 @@ static inline void print_irqtrace_events
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # ifdef CONFIG_PROVE_LOCKING
-#  define map_acquire(l)		lock_acquire(l, 0, 0, 0, 2, _THIS_IP_)
+#  define map_acquire(l)		lock_acquire(l, 0, 0, 0, 2, NULL, _THIS_IP_)
 # else
-#  define map_acquire(l)		lock_acquire(l, 0, 0, 0, 1, _THIS_IP_)
+#  define map_acquire(l)		lock_acquire(l, 0, 0, 0, 1, NULL, _THIS_IP_)
 # endif
 # define map_release(l)			lock_release(l, 1, _THIS_IP_)
 #else
diff -puN include/linux/rcuclassic.h~lockdep-lock-protection-locks include/linux/rcuclassic.h
--- a/include/linux/rcuclassic.h~lockdep-lock-protection-locks
+++ a/include/linux/rcuclassic.h
@@ -125,7 +125,7 @@ extern int rcu_needs_cpu(int cpu);
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 extern struct lockdep_map rcu_lock_map;
 # define rcu_read_acquire()	\
-			lock_acquire(&rcu_lock_map, 0, 0, 2, 1, _THIS_IP_)
+			lock_acquire(&rcu_lock_map, 0, 0, 2, 1, NULL, _THIS_IP_)
 # define rcu_read_release()	lock_release(&rcu_lock_map, 1, _THIS_IP_)
 #else
 # define rcu_read_acquire()	do { } while (0)
diff -puN kernel/lockdep.c~lockdep-lock-protection-locks kernel/lockdep.c
--- a/kernel/lockdep.c~lockdep-lock-protection-locks
+++ a/kernel/lockdep.c
@@ -1372,18 +1372,32 @@ check_deadlock(struct task_struct *curr,
 	       struct lockdep_map *next_instance, int read)
 {
 	struct held_lock *prev;
+	struct held_lock *nest = NULL;
 	int i;
 
 	for (i = 0; i < curr->lockdep_depth; i++) {
 		prev = curr->held_locks + i;
+
+		if (prev->instance == next->nest_lock)
+			nest = prev;
+
 		if (hlock_class(prev) != hlock_class(next))
 			continue;
+
 		/*
 		 * Allow read-after-read recursion of the same
 		 * lock class (i.e. read_lock(lock)+read_lock(lock)):
 		 */
 		if ((read == 2) && prev->read)
 			return 2;
+
+		/*
+		 * We're holding the nest_lock, which serializes this lock's
+		 * nesting behaviour.
+		 */
+		if (nest)
+			return 2;
+
 		return print_deadlock_bug(curr, prev, next);
 	}
 	return 1;
@@ -2505,7 +2519,7 @@ EXPORT_SYMBOL_GPL(lockdep_init_map);
  */
 static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 			  int trylock, int read, int check, int hardirqs_off,
-			  unsigned long ip)
+			  struct lockdep_map *nest_lock, unsigned long ip)
 {
 	struct task_struct *curr = current;
 	struct lock_class *class = NULL;
@@ -2564,6 +2578,7 @@ static int __lock_acquire(struct lockdep
 	hlock->class_idx = class - lock_classes + 1;
 	hlock->acquire_ip = ip;
 	hlock->instance = lock;
+	hlock->nest_lock = nest_lock;
 	hlock->trylock = trylock;
 	hlock->read = read;
 	hlock->check = check;
@@ -2715,7 +2730,7 @@ found_it:
 		if (!__lock_acquire(hlock->instance,
 			hlock_class(hlock)->subclass, hlock->trylock,
 				hlock->read, hlock->check, hlock->hardirqs_off,
-				hlock->acquire_ip))
+				hlock->nest_lock, hlock->acquire_ip))
 			return 0;
 	}
 
@@ -2776,7 +2791,7 @@ found_it:
 		if (!__lock_acquire(hlock->instance,
 			hlock_class(hlock)->subclass, hlock->trylock,
 				hlock->read, hlock->check, hlock->hardirqs_off,
-				hlock->acquire_ip))
+				hlock->nest_lock, hlock->acquire_ip))
 			return 0;
 	}
 
@@ -2913,7 +2928,8 @@ EXPORT_SYMBOL_GPL(lock_set_subclass);
  * and also avoid lockdep recursion:
  */
 void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
-			  int trylock, int read, int check, unsigned long ip)
+			  int trylock, int read, int check,
+			  struct lockdep_map *nest_lock, unsigned long ip)
 {
 	unsigned long flags;
 
@@ -2928,7 +2944,7 @@ void lock_acquire(struct lockdep_map *lo
 
 	current->lockdep_recursion = 1;
 	__lock_acquire(lock, subclass, trylock, read, check,
-		       irqs_disabled_flags(flags), ip);
+		       irqs_disabled_flags(flags), nest_lock, ip);
 	current->lockdep_recursion = 0;
 	raw_local_irq_restore(flags);
 }
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

