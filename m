From: akpm@linux-foundation.org
Subject: [merged] lockdep-mutex-provide-mutex_lock_nest_lock.patch removed from -mm tree
Date: Wed, 25 May 2011 13:28:44 -0700
Message-ID: <201105252027.p4PKR7aM014551@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52038 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754374Ab1EYU2T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:28:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, benh@kernel.crashing.org, davem@davemloft.net, hughd@google.com, jdike@addtoit.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lethal@linu


The patch titled
     lockdep, mutex: provide mutex_lock_nest_lock
has been removed from the -mm tree.  Its filename was
     lockdep-mutex-provide-mutex_lock_nest_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lockdep, mutex: provide mutex_lock_nest_lock
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

In order to convert i_mmap_lock to a mutex we need a mutex equivalent to
spin_lock_nest_lock(), thus provide the mutex_lock_nest_lock() annotation.

As with spin_lock_nest_lock(), mutex_lock_nest_lock() allows annotation of
the locking pattern where an outer lock serializes the acquisition order
of nested locks.  That is, if every time you lock multiple locks A, say A1
and A2 you first acquire N, the order of acquiring A1 and A2 is
irrelevant.  

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Miller <davem@davemloft.net>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Tony Luck <tony.luck@intel.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/lockdep.h |    3 +++
 include/linux/mutex.h   |    9 +++++++++
 kernel/mutex.c          |   25 +++++++++++++++++--------
 3 files changed, 29 insertions(+), 8 deletions(-)

diff -puN include/linux/lockdep.h~lockdep-mutex-provide-mutex_lock_nest_lock include/linux/lockdep.h
--- a/include/linux/lockdep.h~lockdep-mutex-provide-mutex_lock_nest_lock
+++ a/include/linux/lockdep.h
@@ -487,12 +487,15 @@ static inline void print_irqtrace_events
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # ifdef CONFIG_PROVE_LOCKING
 #  define mutex_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
+#  define mutex_acquire_nest(l, s, t, n, i)	lock_acquire(l, s, t, 0, 2, n, i)
 # else
 #  define mutex_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
+#  define mutex_acquire_nest(l, s, t, n, i)	lock_acquire(l, s, t, 0, 1, n, i)
 # endif
 # define mutex_release(l, n, i)			lock_release(l, n, i)
 #else
 # define mutex_acquire(l, s, t, i)		do { } while (0)
+# define mutex_acquire_nest(l, s, t, n, i)	do { } while (0)
 # define mutex_release(l, n, i)			do { } while (0)
 #endif
 
diff -puN include/linux/mutex.h~lockdep-mutex-provide-mutex_lock_nest_lock include/linux/mutex.h
--- a/include/linux/mutex.h~lockdep-mutex-provide-mutex_lock_nest_lock
+++ a/include/linux/mutex.h
@@ -132,6 +132,7 @@ static inline int mutex_is_locked(struct
  */
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 extern void mutex_lock_nested(struct mutex *lock, unsigned int subclass);
+extern void _mutex_lock_nest_lock(struct mutex *lock, struct lockdep_map *nest_lock);
 extern int __must_check mutex_lock_interruptible_nested(struct mutex *lock,
 					unsigned int subclass);
 extern int __must_check mutex_lock_killable_nested(struct mutex *lock,
@@ -140,6 +141,13 @@ extern int __must_check mutex_lock_killa
 #define mutex_lock(lock) mutex_lock_nested(lock, 0)
 #define mutex_lock_interruptible(lock) mutex_lock_interruptible_nested(lock, 0)
 #define mutex_lock_killable(lock) mutex_lock_killable_nested(lock, 0)
+
+#define mutex_lock_nest_lock(lock, nest_lock)				\
+do {									\
+	typecheck(struct lockdep_map *, &(nest_lock)->dep_map);		\
+	_mutex_lock_nest_lock(lock, &(nest_lock)->dep_map);		\
+} while (0)
+
 #else
 extern void mutex_lock(struct mutex *lock);
 extern int __must_check mutex_lock_interruptible(struct mutex *lock);
@@ -148,6 +156,7 @@ extern int __must_check mutex_lock_killa
 # define mutex_lock_nested(lock, subclass) mutex_lock(lock)
 # define mutex_lock_interruptible_nested(lock, subclass) mutex_lock_interruptible(lock)
 # define mutex_lock_killable_nested(lock, subclass) mutex_lock_killable(lock)
+# define mutex_lock_nest_lock(lock, nest_lock) mutex_lock(lock)
 #endif
 
 /*
diff -puN kernel/mutex.c~lockdep-mutex-provide-mutex_lock_nest_lock kernel/mutex.c
--- a/kernel/mutex.c~lockdep-mutex-provide-mutex_lock_nest_lock
+++ a/kernel/mutex.c
@@ -131,14 +131,14 @@ EXPORT_SYMBOL(mutex_unlock);
  */
 static inline int __sched
 __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
-	       	unsigned long ip)
+		    struct lockdep_map *nest_lock, unsigned long ip)
 {
 	struct task_struct *task = current;
 	struct mutex_waiter waiter;
 	unsigned long flags;
 
 	preempt_disable();
-	mutex_acquire(&lock->dep_map, subclass, 0, ip);
+	mutex_acquire_nest(&lock->dep_map, subclass, 0, nest_lock, ip);
 
 #ifdef CONFIG_MUTEX_SPIN_ON_OWNER
 	/*
@@ -269,16 +269,25 @@ void __sched
 mutex_lock_nested(struct mutex *lock, unsigned int subclass)
 {
 	might_sleep();
-	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, subclass, _RET_IP_);
+	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, subclass, NULL, _RET_IP_);
 }
 
 EXPORT_SYMBOL_GPL(mutex_lock_nested);
 
+void __sched
+_mutex_lock_nest_lock(struct mutex *lock, struct lockdep_map *nest)
+{
+	might_sleep();
+	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, 0, nest, _RET_IP_);
+}
+
+EXPORT_SYMBOL_GPL(_mutex_lock_nest_lock);
+
 int __sched
 mutex_lock_killable_nested(struct mutex *lock, unsigned int subclass)
 {
 	might_sleep();
-	return __mutex_lock_common(lock, TASK_KILLABLE, subclass, _RET_IP_);
+	return __mutex_lock_common(lock, TASK_KILLABLE, subclass, NULL, _RET_IP_);
 }
 EXPORT_SYMBOL_GPL(mutex_lock_killable_nested);
 
@@ -287,7 +296,7 @@ mutex_lock_interruptible_nested(struct m
 {
 	might_sleep();
 	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE,
-				   subclass, _RET_IP_);
+				   subclass, NULL, _RET_IP_);
 }
 
 EXPORT_SYMBOL_GPL(mutex_lock_interruptible_nested);
@@ -393,7 +402,7 @@ __mutex_lock_slowpath(atomic_t *lock_cou
 {
 	struct mutex *lock = container_of(lock_count, struct mutex, count);
 
-	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, 0, _RET_IP_);
+	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, 0, NULL, _RET_IP_);
 }
 
 static noinline int __sched
@@ -401,7 +410,7 @@ __mutex_lock_killable_slowpath(atomic_t 
 {
 	struct mutex *lock = container_of(lock_count, struct mutex, count);
 
-	return __mutex_lock_common(lock, TASK_KILLABLE, 0, _RET_IP_);
+	return __mutex_lock_common(lock, TASK_KILLABLE, 0, NULL, _RET_IP_);
 }
 
 static noinline int __sched
@@ -409,7 +418,7 @@ __mutex_lock_interruptible_slowpath(atom
 {
 	struct mutex *lock = container_of(lock_count, struct mutex, count);
 
-	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE, 0, _RET_IP_);
+	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE, 0, NULL, _RET_IP_);
 }
 #endif
 
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
linux-next.patch
cpumask-convert-cpumask_of_cpu-to-cpumask_of.patch

