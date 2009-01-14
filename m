From: akpm@linux-foundation.org
Subject: [to-be-updated] mutex-implement-adaptive-spinning.patch removed from -mm tree
Date: Wed, 14 Jan 2009 09:35:57 -0800
Message-ID: <200901141735.n0EHZvDe010580@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52865 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764944AbZANRgl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Jan 2009 12:36:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peterz@infradead.org, a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org


The patch titled
     mutex: implement adaptive spinning
has been removed from the -mm tree.  Its filename was
     mutex-implement-adaptive-spinning.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mutex: implement adaptive spinning
From: Peter Zijlstra <peterz@infradead.org>

Change mutex contention behaviour such that it will sometimes busy wait
on acquisition - moving its behaviour closer to that of spinlocks.

This concept got ported to mainline from the -rt tree, where it was
originally implemented for rtmutexes by Steven Rostedt, based on work
by Gregory Haskins.

Testing with Ingo's test-mutex application
(http://lkml.org/lkml/2006/1/8/50) gave a 304% boost for VFS
scalability on my testbox:

 # ./test-mutex-shm V 16 10 | grep "^avg ops"
 avg ops/sec:               298932

 # ./test-mutex-shm V 16 10 | grep "^avg ops"
 avg ops/sec:               98287

The key criteria for the busy wait is that the lock owner has to be
running on a (different) cpu.  The idea is that as long as the owner is
running, there is a fair chance it'll release the lock soon, and thus
we'll be better off spinning instead of blocking/scheduling.

Since regular mutexes (as opposed to rtmutexes) do not atomically track
the owner, we add the owner in a non-atomic fashion and deal with the
races in the slowpath.

Furthermore, to ease the testing of the performance impact of this new
code, there is means to disable this behaviour runtime (without having
to reboot the system), when scheduler debugging is enabled
(CONFIG_SCHED_DEBUG=y), by issuing the following command:

 # echo NO_OWNER_SPIN > /debug/sched_features

This command re-enables spinning again (this is also the default):

 # echo OWNER_SPIN > /debug/sched_features

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mutex.h   |    5 -
 include/linux/sched.h   |    2 
 kernel/mutex-debug.c    |    9 --
 kernel/mutex-debug.h    |   18 ++---
 kernel/mutex.c          |  128 ++++++++++++++++++++++++++++++++------
 kernel/mutex.h          |   22 +++++-
 kernel/sched.c          |   71 ++++++++++++++++++++-
 kernel/sched_features.h |    1 
 8 files changed, 216 insertions(+), 40 deletions(-)

diff -puN include/linux/mutex.h~mutex-implement-adaptive-spinning include/linux/mutex.h
--- a/include/linux/mutex.h~mutex-implement-adaptive-spinning
+++ a/include/linux/mutex.h
@@ -50,8 +50,10 @@ struct mutex {
 	atomic_t		count;
 	spinlock_t		wait_lock;
 	struct list_head	wait_list;
-#ifdef CONFIG_DEBUG_MUTEXES
+#if defined(CONFIG_DEBUG_MUTEXES) || defined(CONFIG_SMP)
 	struct thread_info	*owner;
+#endif
+#ifdef CONFIG_DEBUG_MUTEXES
 	const char 		*name;
 	void			*magic;
 #endif
@@ -68,7 +70,6 @@ struct mutex_waiter {
 	struct list_head	list;
 	struct task_struct	*task;
 #ifdef CONFIG_DEBUG_MUTEXES
-	struct mutex		*lock;
 	void			*magic;
 #endif
 };
diff -puN include/linux/sched.h~mutex-implement-adaptive-spinning include/linux/sched.h
--- a/include/linux/sched.h~mutex-implement-adaptive-spinning
+++ a/include/linux/sched.h
@@ -328,7 +328,9 @@ extern signed long schedule_timeout(sign
 extern signed long schedule_timeout_interruptible(signed long timeout);
 extern signed long schedule_timeout_killable(signed long timeout);
 extern signed long schedule_timeout_uninterruptible(signed long timeout);
+asmlinkage void __schedule(void);
 asmlinkage void schedule(void);
+extern int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner);
 
 struct nsproxy;
 struct user_namespace;
diff -puN kernel/mutex-debug.c~mutex-implement-adaptive-spinning kernel/mutex-debug.c
--- a/kernel/mutex-debug.c~mutex-implement-adaptive-spinning
+++ a/kernel/mutex-debug.c
@@ -26,11 +26,6 @@
 /*
  * Must be called with lock->wait_lock held.
  */
-void debug_mutex_set_owner(struct mutex *lock, struct thread_info *new_owner)
-{
-	lock->owner = new_owner;
-}
-
 void debug_mutex_lock_common(struct mutex *lock, struct mutex_waiter *waiter)
 {
 	memset(waiter, MUTEX_DEBUG_INIT, sizeof(*waiter));
@@ -59,7 +54,6 @@ void debug_mutex_add_waiter(struct mutex
 
 	/* Mark the current thread as blocked on the lock: */
 	ti->task->blocked_on = waiter;
-	waiter->lock = lock;
 }
 
 void mutex_remove_waiter(struct mutex *lock, struct mutex_waiter *waiter,
@@ -82,7 +76,7 @@ void debug_mutex_unlock(struct mutex *lo
 	DEBUG_LOCKS_WARN_ON(lock->magic != lock);
 	DEBUG_LOCKS_WARN_ON(lock->owner != current_thread_info());
 	DEBUG_LOCKS_WARN_ON(!lock->wait_list.prev && !lock->wait_list.next);
-	DEBUG_LOCKS_WARN_ON(lock->owner != current_thread_info());
+	mutex_clear_owner(lock);
 }
 
 void debug_mutex_init(struct mutex *lock, const char *name,
@@ -95,7 +89,6 @@ void debug_mutex_init(struct mutex *lock
 	debug_check_no_locks_freed((void *)lock, sizeof(*lock));
 	lockdep_init_map(&lock->dep_map, name, key, 0);
 #endif
-	lock->owner = NULL;
 	lock->magic = lock;
 }
 
diff -puN kernel/mutex-debug.h~mutex-implement-adaptive-spinning kernel/mutex-debug.h
--- a/kernel/mutex-debug.h~mutex-implement-adaptive-spinning
+++ a/kernel/mutex-debug.h
@@ -13,14 +13,6 @@
 /*
  * This must be called with lock->wait_lock held.
  */
-extern void
-debug_mutex_set_owner(struct mutex *lock, struct thread_info *new_owner);
-
-static inline void debug_mutex_clear_owner(struct mutex *lock)
-{
-	lock->owner = NULL;
-}
-
 extern void debug_mutex_lock_common(struct mutex *lock,
 				    struct mutex_waiter *waiter);
 extern void debug_mutex_wake_waiter(struct mutex *lock,
@@ -35,6 +27,16 @@ extern void debug_mutex_unlock(struct mu
 extern void debug_mutex_init(struct mutex *lock, const char *name,
 			     struct lock_class_key *key);
 
+static inline void mutex_set_owner(struct mutex *lock)
+{
+	lock->owner = current_thread_info();
+}
+
+static inline void mutex_clear_owner(struct mutex *lock)
+{
+	lock->owner = NULL;
+}
+
 #define spin_lock_mutex(lock, flags)			\
 	do {						\
 		struct mutex *l = container_of(lock, struct mutex, wait_lock); \
diff -puN kernel/mutex.c~mutex-implement-adaptive-spinning kernel/mutex.c
--- a/kernel/mutex.c~mutex-implement-adaptive-spinning
+++ a/kernel/mutex.c
@@ -10,6 +10,11 @@
  * Many thanks to Arjan van de Ven, Thomas Gleixner, Steven Rostedt and
  * David Howells for suggestions and improvements.
  *
+ *  - Adaptive spinning for mutexes by Peter Zijlstra. (Ported to mainline
+ *    from the -rt tree, where it was originally implemented for rtmutexes
+ *    by Steven Rostedt, based on work by Gregory Haskins, Peter Morreale
+ *    and Sven Dietrich.
+ *
  * Also see Documentation/mutex-design.txt.
  */
 #include <linux/mutex.h>
@@ -46,6 +51,7 @@ __mutex_init(struct mutex *lock, const c
 	atomic_set(&lock->count, 1);
 	spin_lock_init(&lock->wait_lock);
 	INIT_LIST_HEAD(&lock->wait_list);
+	mutex_clear_owner(lock);
 
 	debug_mutex_init(lock, name, key);
 }
@@ -91,6 +97,7 @@ void inline __sched mutex_lock(struct mu
 	 * 'unlocked' into 'locked' state.
 	 */
 	__mutex_fastpath_lock(&lock->count, __mutex_lock_slowpath);
+	mutex_set_owner(lock);
 }
 
 EXPORT_SYMBOL(mutex_lock);
@@ -115,6 +122,14 @@ void __sched mutex_unlock(struct mutex *
 	 * The unlocking fastpath is the 0->1 transition from 'locked'
 	 * into 'unlocked' state:
 	 */
+#ifndef CONFIG_DEBUG_MUTEXES
+	/*
+	 * When debugging is enabled we must not clear the owner before time,
+	 * the slow path will always be taken, and that clears the owner field
+	 * after verifying that it was indeed current.
+	 */
+	mutex_clear_owner(lock);
+#endif
 	__mutex_fastpath_unlock(&lock->count, __mutex_unlock_slowpath);
 }
 
@@ -129,21 +144,82 @@ __mutex_lock_common(struct mutex *lock, 
 {
 	struct task_struct *task = current;
 	struct mutex_waiter waiter;
-	unsigned int old_val;
 	unsigned long flags;
 
+	preempt_disable();
+	mutex_acquire(&lock->dep_map, subclass, 0, ip);
+#if defined(CONFIG_SMP) && !defined(CONFIG_DEBUG_MUTEXES)
+	/*
+	 * Optimistic spinning.
+	 *
+	 * We try to spin for acquisition when we find that there are no
+	 * pending waiters and the lock owner is currently running on a
+	 * (different) CPU.
+	 *
+	 * The rationale is that if the lock owner is running, it is likely to
+	 * release the lock soon.
+	 *
+	 * Since this needs the lock owner, and this mutex implementation
+	 * doesn't track the owner atomically in the lock field, we need to
+	 * track it non-atomically.
+	 *
+	 * We can't do this for DEBUG_MUTEXES because that relies on wait_lock
+	 * to serialize everything.
+	 */
+
+	for (;;) {
+		struct thread_info *owner;
+
+		/*
+		 * If there are pending waiters, join them.
+		 */
+		if (!list_empty(&lock->wait_list))
+			break;
+
+		/*
+		 * If there's an owner, wait for it to either
+		 * release the lock or go to sleep.
+		 */
+		owner = ACCESS_ONCE(lock->owner);
+		if (owner && !mutex_spin_on_owner(lock, owner))
+			break;
+
+		/*
+		 * When there's no owner, we might have preempted between the
+		 * owner acquiring the lock and setting the owner field. If
+		 * we're an RT task that will live-lock because we won't let
+		 * the owner complete.
+		 */
+		if (!owner && (need_resched() || rt_task(task)))
+			break;
+
+		if (atomic_cmpxchg(&lock->count, 1, 0) == 1) {
+			lock_acquired(&lock->dep_map, ip);
+			mutex_set_owner(lock);
+			preempt_enable();
+			return 0;
+		}
+
+		/*
+		 * The cpu_relax() call is a compiler barrier which forces
+		 * everything in this loop to be re-loaded. We don't need
+		 * memory barriers as we'll eventually observe the right
+		 * values at the cost of a few extra spins.
+		 */
+		cpu_relax();
+	}
+#endif
+
 	spin_lock_mutex(&lock->wait_lock, flags);
 
 	debug_mutex_lock_common(lock, &waiter);
-	mutex_acquire(&lock->dep_map, subclass, 0, ip);
 	debug_mutex_add_waiter(lock, &waiter, task_thread_info(task));
 
 	/* add waiting tasks to the end of the waitqueue (FIFO): */
 	list_add_tail(&waiter.list, &lock->wait_list);
 	waiter.task = task;
 
-	old_val = atomic_xchg(&lock->count, -1);
-	if (old_val == 1)
+	if (atomic_xchg(&lock->count, -1) == 1)
 		goto done;
 
 	lock_contended(&lock->dep_map, ip);
@@ -158,8 +234,7 @@ __mutex_lock_common(struct mutex *lock, 
 		 * that when we release the lock, we properly wake up the
 		 * other waiters:
 		 */
-		old_val = atomic_xchg(&lock->count, -1);
-		if (old_val == 1)
+		if (atomic_xchg(&lock->count, -1) == 1)
 			break;
 
 		/*
@@ -173,21 +248,22 @@ __mutex_lock_common(struct mutex *lock, 
 			spin_unlock_mutex(&lock->wait_lock, flags);
 
 			debug_mutex_free_waiter(&waiter);
+			preempt_enable();
 			return -EINTR;
 		}
 		__set_task_state(task, state);
 
 		/* didnt get the lock, go to sleep: */
 		spin_unlock_mutex(&lock->wait_lock, flags);
-		schedule();
+		__schedule();
 		spin_lock_mutex(&lock->wait_lock, flags);
 	}
 
 done:
 	lock_acquired(&lock->dep_map, ip);
 	/* got the lock - rejoice! */
-	mutex_remove_waiter(lock, &waiter, task_thread_info(task));
-	debug_mutex_set_owner(lock, task_thread_info(task));
+	mutex_remove_waiter(lock, &waiter, current_thread_info());
+	mutex_set_owner(lock);
 
 	/* set it to 0 if there are no waiters left: */
 	if (likely(list_empty(&lock->wait_list)))
@@ -196,6 +272,7 @@ done:
 	spin_unlock_mutex(&lock->wait_lock, flags);
 
 	debug_mutex_free_waiter(&waiter);
+	preempt_enable();
 
 	return 0;
 }
@@ -222,7 +299,8 @@ int __sched
 mutex_lock_interruptible_nested(struct mutex *lock, unsigned int subclass)
 {
 	might_sleep();
-	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE, subclass, _RET_IP_);
+	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE,
+				   subclass, _RET_IP_);
 }
 
 EXPORT_SYMBOL_GPL(mutex_lock_interruptible_nested);
@@ -260,8 +338,6 @@ __mutex_unlock_common_slowpath(atomic_t 
 		wake_up_process(waiter->task);
 	}
 
-	debug_mutex_clear_owner(lock);
-
 	spin_unlock_mutex(&lock->wait_lock, flags);
 }
 
@@ -298,18 +374,30 @@ __mutex_lock_interruptible_slowpath(atom
  */
 int __sched mutex_lock_interruptible(struct mutex *lock)
 {
+	int ret;
+
 	might_sleep();
-	return __mutex_fastpath_lock_retval
+	ret =  __mutex_fastpath_lock_retval
 			(&lock->count, __mutex_lock_interruptible_slowpath);
+	if (!ret)
+		mutex_set_owner(lock);
+
+	return ret;
 }
 
 EXPORT_SYMBOL(mutex_lock_interruptible);
 
 int __sched mutex_lock_killable(struct mutex *lock)
 {
+	int ret;
+
 	might_sleep();
-	return __mutex_fastpath_lock_retval
+	ret = __mutex_fastpath_lock_retval
 			(&lock->count, __mutex_lock_killable_slowpath);
+	if (!ret)
+		mutex_set_owner(lock);
+
+	return ret;
 }
 EXPORT_SYMBOL(mutex_lock_killable);
 
@@ -352,9 +440,10 @@ static inline int __mutex_trylock_slowpa
 
 	prev = atomic_xchg(&lock->count, -1);
 	if (likely(prev == 1)) {
-		debug_mutex_set_owner(lock, current_thread_info());
+		mutex_set_owner(lock);
 		mutex_acquire(&lock->dep_map, 0, 1, _RET_IP_);
 	}
+
 	/* Set it back to 0 if there are no waiters: */
 	if (likely(list_empty(&lock->wait_list)))
 		atomic_set(&lock->count, 0);
@@ -380,8 +469,13 @@ static inline int __mutex_trylock_slowpa
  */
 int __sched mutex_trylock(struct mutex *lock)
 {
-	return __mutex_fastpath_trylock(&lock->count,
-					__mutex_trylock_slowpath);
+	int ret;
+
+	ret = __mutex_fastpath_trylock(&lock->count, __mutex_trylock_slowpath);
+	if (ret)
+		mutex_set_owner(lock);
+
+	return ret;
 }
 
 EXPORT_SYMBOL(mutex_trylock);
diff -puN kernel/mutex.h~mutex-implement-adaptive-spinning kernel/mutex.h
--- a/kernel/mutex.h~mutex-implement-adaptive-spinning
+++ a/kernel/mutex.h
@@ -16,8 +16,26 @@
 #define mutex_remove_waiter(lock, waiter, ti) \
 		__list_del((waiter)->list.prev, (waiter)->list.next)
 
-#define debug_mutex_set_owner(lock, new_owner)		do { } while (0)
-#define debug_mutex_clear_owner(lock)			do { } while (0)
+#ifdef CONFIG_SMP
+static inline void mutex_set_owner(struct mutex *lock)
+{
+	lock->owner = current_thread_info();
+}
+
+static inline void mutex_clear_owner(struct mutex *lock)
+{
+	lock->owner = NULL;
+}
+#else
+static inline void mutex_set_owner(struct mutex *lock)
+{
+}
+
+static inline void mutex_clear_owner(struct mutex *lock)
+{
+}
+#endif
+
 #define debug_mutex_wake_waiter(lock, waiter)		do { } while (0)
 #define debug_mutex_free_waiter(waiter)			do { } while (0)
 #define debug_mutex_add_waiter(lock, waiter, ti)	do { } while (0)
diff -puN kernel/sched.c~mutex-implement-adaptive-spinning kernel/sched.c
--- a/kernel/sched.c~mutex-implement-adaptive-spinning
+++ a/kernel/sched.c
@@ -4538,15 +4538,13 @@ pick_next_task(struct rq *rq, struct tas
 /*
  * schedule() is the main scheduler function.
  */
-asmlinkage void __sched schedule(void)
+asmlinkage void __sched __schedule(void)
 {
 	struct task_struct *prev, *next;
 	unsigned long *switch_count;
 	struct rq *rq;
 	int cpu;
 
-need_resched:
-	preempt_disable();
 	cpu = smp_processor_id();
 	rq = cpu_rq(cpu);
 	rcu_qsctr_inc(cpu);
@@ -4603,13 +4601,80 @@ need_resched_nonpreemptible:
 
 	if (unlikely(reacquire_kernel_lock(current) < 0))
 		goto need_resched_nonpreemptible;
+}
 
+asmlinkage void __sched schedule(void)
+{
+need_resched:
+	preempt_disable();
+	__schedule();
 	preempt_enable_no_resched();
 	if (unlikely(test_thread_flag(TIF_NEED_RESCHED)))
 		goto need_resched;
 }
 EXPORT_SYMBOL(schedule);
 
+#ifdef CONFIG_SMP
+/*
+ * Look out! "owner" is an entirely speculative pointer
+ * access and not reliable.
+ */
+int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner)
+{
+	unsigned int cpu;
+	struct rq *rq;
+
+	if (!sched_feat(OWNER_SPIN))
+		return 0;
+
+#ifdef CONFIG_DEBUG_PAGEALLOC
+	/*
+	 * Need to access the cpu field knowing that
+	 * DEBUG_PAGEALLOC could have unmapped it if
+	 * the mutex owner just released it and exited.
+	 */
+	if (probe_kernel_address(&owner->cpu, cpu))
+		goto out;
+#else
+	cpu = owner->cpu;
+#endif
+
+	/*
+	 * Even if the access succeeded (likely case),
+	 * the cpu field may no longer be valid.
+	 */
+	if (cpu >= nr_cpumask_bits)
+		goto out;
+
+	/*
+	 * We need to validate that we can do a
+	 * get_cpu() and that we have the percpu area.
+	 */
+	if (!cpu_online(cpu))
+		goto out;
+
+	rq = cpu_rq(cpu);
+
+	for (;;) {
+		/*
+		 * Owner changed, break to re-assess state.
+		 */
+		if (lock->owner != owner)
+			break;
+
+		/*
+		 * Is that owner really running on that cpu?
+		 */
+		if (task_thread_info(rq->curr) != owner || need_resched())
+			return 0;
+
+		cpu_relax();
+	}
+out:
+	return 1;
+}
+#endif
+
 #ifdef CONFIG_PREEMPT
 /*
  * this is the entry point to schedule() from in-kernel preemption
diff -puN kernel/sched_features.h~mutex-implement-adaptive-spinning kernel/sched_features.h
--- a/kernel/sched_features.h~mutex-implement-adaptive-spinning
+++ a/kernel/sched_features.h
@@ -13,3 +13,4 @@ SCHED_FEAT(LB_WAKEUP_UPDATE, 1)
 SCHED_FEAT(ASYM_EFF_LOAD, 1)
 SCHED_FEAT(WAKEUP_OVERLAP, 0)
 SCHED_FEAT(LAST_BUDDY, 1)
+SCHED_FEAT(OWNER_SPIN, 1)
_

Patches currently in -mm which might be from peterz@infradead.org are

mutex-implement-adaptive-spinning.patch

