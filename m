From: akpm@linux-foundation.org
Subject: - workqueue-debug-flushing-deadlocks-with-lockdep.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:51:02 -0700
Message-ID: <200710192251.l9JMp2TQ024149@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49835 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966975AbXJSXGO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:06:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johannes@sipsolutions.net, a.p.zijlstra@chello.nl, mingo@elte.hu, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     workqueue: debug flushing deadlocks with lockdep
has been removed from the -mm tree.  Its filename was
     workqueue-debug-flushing-deadlocks-with-lockdep.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: workqueue: debug flushing deadlocks with lockdep
From: Johannes Berg <johannes@sipsolutions.net>

In the following scenario:

code path 1:
  my_function() -> lock(L1); ...; flush_workqueue(); ...

code path 2:
  run_workqueue() -> my_work() -> ...; lock(L1); ...

you can get a deadlock when my_work() is queued or running
but my_function() has acquired L1 already.

This patch adds a pseudo-lock to each workqueue to make lockdep
warn about this scenario.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Acked-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/lockdep.h   |    8 +++++
 include/linux/workqueue.h |   49 +++++++++++++++++++++++++++++++++---
 kernel/lockdep.c          |    2 -
 kernel/workqueue.c        |   36 ++++++++++++++++++++++++--
 4 files changed, 88 insertions(+), 7 deletions(-)

diff -puN include/linux/lockdep.h~workqueue-debug-flushing-deadlocks-with-lockdep include/linux/lockdep.h
--- a/include/linux/lockdep.h~workqueue-debug-flushing-deadlocks-with-lockdep
+++ a/include/linux/lockdep.h
@@ -276,6 +276,14 @@ extern void lockdep_init_map(struct lock
 				 (lock)->dep_map.key, sub)
 
 /*
+ * To initialize a lockdep_map statically use this macro.
+ * Note that _name must not be NULL.
+ */
+#define STATIC_LOCKDEP_MAP_INIT(_name, _key) \
+	{ .name = (_name), .key = (void *)(_key), }
+
+
+/*
  * Acquire a lock.
  *
  * Values for "read":
diff -puN include/linux/workqueue.h~workqueue-debug-flushing-deadlocks-with-lockdep include/linux/workqueue.h
--- a/include/linux/workqueue.h~workqueue-debug-flushing-deadlocks-with-lockdep
+++ a/include/linux/workqueue.h
@@ -8,6 +8,7 @@
 #include <linux/timer.h>
 #include <linux/linkage.h>
 #include <linux/bitops.h>
+#include <linux/lockdep.h>
 #include <asm/atomic.h>
 
 struct workqueue_struct;
@@ -28,6 +29,9 @@ struct work_struct {
 #define WORK_STRUCT_WQ_DATA_MASK (~WORK_STRUCT_FLAG_MASK)
 	struct list_head entry;
 	work_func_t func;
+#ifdef CONFIG_LOCKDEP
+	struct lockdep_map lockdep_map;
+#endif
 };
 
 #define WORK_DATA_INIT()	ATOMIC_LONG_INIT(0)
@@ -41,10 +45,23 @@ struct execute_work {
 	struct work_struct work;
 };
 
+#ifdef CONFIG_LOCKDEP
+/*
+ * NB: because we have to copy the lockdep_map, setting _key
+ * here is required, otherwise it could get initialised to the
+ * copy of the lockdep_map!
+ */
+#define __WORK_INIT_LOCKDEP_MAP(n, k) \
+	.lockdep_map = STATIC_LOCKDEP_MAP_INIT(n, k),
+#else
+#define __WORK_INIT_LOCKDEP_MAP(n, k)
+#endif
+
 #define __WORK_INITIALIZER(n, f) {				\
 	.data = WORK_DATA_INIT(),				\
 	.entry	= { &(n).entry, &(n).entry },			\
 	.func = (f),						\
+	__WORK_INIT_LOCKDEP_MAP(#n, &(n))			\
 	}
 
 #define __DELAYED_WORK_INITIALIZER(n, f) {			\
@@ -76,12 +93,24 @@ struct execute_work {
  * assignment of the work data initializer allows the compiler
  * to generate better code.
  */
+#ifdef CONFIG_LOCKDEP
 #define INIT_WORK(_work, _func)						\
 	do {								\
+		static struct lock_class_key __key;			\
+									\
 		(_work)->data = (atomic_long_t) WORK_DATA_INIT();	\
+		lockdep_init_map(&(_work)->lockdep_map, #_work, &__key, 0);\
 		INIT_LIST_HEAD(&(_work)->entry);			\
 		PREPARE_WORK((_work), (_func));				\
 	} while (0)
+#else
+#define INIT_WORK(_work, _func)						\
+	do {								\
+		(_work)->data = (atomic_long_t) WORK_DATA_INIT();	\
+		INIT_LIST_HEAD(&(_work)->entry);			\
+		PREPARE_WORK((_work), (_func));				\
+	} while (0)
+#endif
 
 #define INIT_DELAYED_WORK(_work, _func)				\
 	do {							\
@@ -118,9 +147,23 @@ struct execute_work {
 	clear_bit(WORK_STRUCT_PENDING, work_data_bits(work))
 
 
-extern struct workqueue_struct *__create_workqueue(const char *name,
-						    int singlethread,
-						    int freezeable);
+extern struct workqueue_struct *
+__create_workqueue_key(const char *name, int singlethread,
+		       int freezeable, struct lock_class_key *key);
+
+#ifdef CONFIG_LOCKDEP
+#define __create_workqueue(name, singlethread, freezeable)	\
+({								\
+	static struct lock_class_key __key;			\
+								\
+	__create_workqueue_key((name), (singlethread),		\
+			       (freezeable), &__key);		\
+})
+#else
+#define __create_workqueue(name, singlethread, freezeable)	\
+	__create_workqueue_key((name), (singlethread), (freezeable), NULL)
+#endif
+
 #define create_workqueue(name) __create_workqueue((name), 0, 0)
 #define create_freezeable_workqueue(name) __create_workqueue((name), 1, 1)
 #define create_singlethread_workqueue(name) __create_workqueue((name), 1, 0)
diff -puN kernel/lockdep.c~workqueue-debug-flushing-deadlocks-with-lockdep kernel/lockdep.c
--- a/kernel/lockdep.c~workqueue-debug-flushing-deadlocks-with-lockdep
+++ a/kernel/lockdep.c
@@ -1521,7 +1521,7 @@ cache_hit:
 }
 
 static int validate_chain(struct task_struct *curr, struct lockdep_map *lock,
-	       	struct held_lock *hlock, int chain_head, u64 chain_key)
+		struct held_lock *hlock, int chain_head, u64 chain_key)
 {
 	/*
 	 * Trylock needs to maintain the stack of held locks, but it
diff -puN kernel/workqueue.c~workqueue-debug-flushing-deadlocks-with-lockdep kernel/workqueue.c
--- a/kernel/workqueue.c~workqueue-debug-flushing-deadlocks-with-lockdep
+++ a/kernel/workqueue.c
@@ -32,6 +32,7 @@
 #include <linux/freezer.h>
 #include <linux/kallsyms.h>
 #include <linux/debug_locks.h>
+#include <linux/lockdep.h>
 
 /*
  * The per-CPU workqueue (if single thread, we always use the first
@@ -61,6 +62,9 @@ struct workqueue_struct {
 	const char *name;
 	int singlethread;
 	int freezeable;		/* Freeze threads during suspend */
+#ifdef CONFIG_LOCKDEP
+	struct lockdep_map lockdep_map;
+#endif
 };
 
 /* All the per-cpu workqueues on the system, for hotplug cpu to add/remove
@@ -250,6 +254,17 @@ static void run_workqueue(struct cpu_wor
 		struct work_struct *work = list_entry(cwq->worklist.next,
 						struct work_struct, entry);
 		work_func_t f = work->func;
+#ifdef CONFIG_LOCKDEP
+		/*
+		 * It is permissible to free the struct work_struct
+		 * from inside the function that is called from it,
+		 * this we need to take into account for lockdep too.
+		 * To avoid bogus "held lock freed" warnings as well
+		 * as problems when looking into work->lockdep_map,
+		 * make a copy and use that here.
+		 */
+		struct lockdep_map lockdep_map = work->lockdep_map;
+#endif
 
 		cwq->current_work = work;
 		list_del_init(cwq->worklist.next);
@@ -257,7 +272,11 @@ static void run_workqueue(struct cpu_wor
 
 		BUG_ON(get_wq_data(work) != cwq);
 		work_clear_pending(work);
+		lock_acquire(&cwq->wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
+		lock_acquire(&lockdep_map, 0, 0, 0, 2, _THIS_IP_);
 		f(work);
+		lock_release(&lockdep_map, 1, _THIS_IP_);
+		lock_release(&cwq->wq->lockdep_map, 1, _THIS_IP_);
 
 		if (unlikely(in_atomic() || lockdep_depth(current) > 0)) {
 			printk(KERN_ERR "BUG: workqueue leaked lock or atomic: "
@@ -376,6 +395,8 @@ void fastcall flush_workqueue(struct wor
 	int cpu;
 
 	might_sleep();
+	lock_acquire(&wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
+	lock_release(&wq->lockdep_map, 1, _THIS_IP_);
 	for_each_cpu_mask(cpu, *cpu_map)
 		flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));
 }
@@ -446,6 +467,9 @@ static void wait_on_work(struct work_str
 
 	might_sleep();
 
+	lock_acquire(&work->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
+	lock_release(&work->lockdep_map, 1, _THIS_IP_);
+
 	cwq = get_wq_data(work);
 	if (!cwq)
 		return;
@@ -695,8 +719,10 @@ static void start_workqueue_thread(struc
 	}
 }
 
-struct workqueue_struct *__create_workqueue(const char *name,
-					    int singlethread, int freezeable)
+struct workqueue_struct *__create_workqueue_key(const char *name,
+						int singlethread,
+						int freezeable,
+						struct lock_class_key *key)
 {
 	struct workqueue_struct *wq;
 	struct cpu_workqueue_struct *cwq;
@@ -713,6 +739,7 @@ struct workqueue_struct *__create_workqu
 	}
 
 	wq->name = name;
+	lockdep_init_map(&wq->lockdep_map, name, key, 0);
 	wq->singlethread = singlethread;
 	wq->freezeable = freezeable;
 	INIT_LIST_HEAD(&wq->list);
@@ -741,7 +768,7 @@ struct workqueue_struct *__create_workqu
 	}
 	return wq;
 }
-EXPORT_SYMBOL_GPL(__create_workqueue);
+EXPORT_SYMBOL_GPL(__create_workqueue_key);
 
 static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
 {
@@ -752,6 +779,9 @@ static void cleanup_workqueue_thread(str
 	if (cwq->thread == NULL)
 		return;
 
+	lock_acquire(&cwq->wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
+	lock_release(&cwq->wq->lockdep_map, 1, _THIS_IP_);
+
 	flush_cpu_workqueue(cwq);
 	/*
 	 * If the caller is CPU_DEAD and cwq->worklist was not empty,
_

Patches currently in -mm which might be from johannes@sipsolutions.net are

origin.patch
git-wireless.patch
