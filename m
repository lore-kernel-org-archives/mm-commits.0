From: akpm@linux-foundation.org
Subject: + lockdep-mutex-provide-mutex_lock_nest_lock.patch added to -mm tree
Date: Tue, 19 Apr 2011 13:10:32 -0700
Message-ID: <201104192010.p3JKAXol020506@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48792 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751931Ab1DSULX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Apr 2011 16:11:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, benh@kernel.crashing.org, davem@davemloft.net, hughd@google.com, jdike@addtoit.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lethal@linux-sh.org, mel@csn.ul.ie, namhyung@gmail.com, npiggin@kernel.dk, richard@nod.at, rmk@arm.linux.org.uk, schwidefsky@de.ibm.com, tony.luck@intel.com


The patch titled
     lockdep, mutex: provide mutex_lock_nest_lock
has been added to the -mm tree.  Its filename is
     lockdep-mutex-provide-mutex_lock_nest_lock.patch

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
Subject: lockdep, mutex: provide mutex_lock_nest_lock
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Provide the mutex_lock_nest_lock() annotation.

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
@@ -276,16 +276,25 @@ void __sched
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
 
@@ -294,7 +303,7 @@ mutex_lock_interruptible_nested(struct m
 {
 	might_sleep();
 	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE,
-				   subclass, _RET_IP_);
+				   subclass, NULL, _RET_IP_);
 }
 
 EXPORT_SYMBOL_GPL(mutex_lock_interruptible_nested);
@@ -400,7 +409,7 @@ __mutex_lock_slowpath(atomic_t *lock_cou
 {
 	struct mutex *lock = container_of(lock_count, struct mutex, count);
 
-	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, 0, _RET_IP_);
+	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, 0, NULL, _RET_IP_);
 }
 
 static noinline int __sched
@@ -408,7 +417,7 @@ __mutex_lock_killable_slowpath(atomic_t 
 {
 	struct mutex *lock = container_of(lock_count, struct mutex, count);
 
-	return __mutex_lock_common(lock, TASK_KILLABLE, 0, _RET_IP_);
+	return __mutex_lock_common(lock, TASK_KILLABLE, 0, NULL, _RET_IP_);
 }
 
 static noinline int __sched
@@ -416,7 +425,7 @@ __mutex_lock_interruptible_slowpath(atom
 {
 	struct mutex *lock = container_of(lock_count, struct mutex, count);
 
-	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE, 0, _RET_IP_);
+	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE, 0, NULL, _RET_IP_);
 }
 #endif
 
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

linux-next.patch
net-convert-%p-usage-to-%pk.patch
mm-mmu_gather-rework.patch
mm-mmu_gather-rework-fix.patch
powerpc-mmu_gather-rework.patch
sparc-mmu_gather-rework.patch
s390-mmu_gather-rework.patch
arm-mmu_gather-rework.patch
sh-mmu_gather-rework.patch
ia64-mmu_gather-rework.patch
um-mmu_gather-rework.patch
mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage.patch
mm-powerpc-move-the-rcu-page-table-freeing-into-generic-code.patch
mm-extended-batches-for-generic-mmu_gather.patch
lockdep-mutex-provide-mutex_lock_nest_lock.patch
mm-remove-i_mmap_lock-lockbreak.patch
mm-convert-i_mmap_lock-to-a-mutex.patch
mm-revert-page_lock_anon_vma-lock-annotation.patch
mm-improve-page_lock_anon_vma-comment.patch
mm-use-refcounts-for-page_lock_anon_vma.patch
mm-convert-anon_vma-lock-to-a-mutex.patch
mm-optimize-page_lock_anon_vma-fast-path.patch

