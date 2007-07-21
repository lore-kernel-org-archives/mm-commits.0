From: akpm@linux-foundation.org
Subject: + workqueue-debug-work-related-deadlocks-with-lockdep.patch added to -mm tree
Date: Fri, 20 Jul 2007 17:04:53 -0700
Message-ID: <200707210004.l6L04rjT023365@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59483 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750853AbXGUAFr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 20:05:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johannes@sipsolutions.net, a.p.zijlstra@chello.nl, mingo@elte.hu, oleg@tv-sign.ru


The patch titled
     ] workqueue: debug work related deadlocks with lockdep
has been added to the -mm tree.  Its filename is
     workqueue-debug-work-related-deadlocks-with-lockdep.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ] workqueue: debug work related deadlocks with lockdep
From: Johannes Berg <johannes@sipsolutions.net>

In the following scenario:

code path 1:
  my_function() -> lock(L1); ...; cancel_work_sync(my_work)
  [or cancel_rearming_delayed_work(my_work)]

code path 2:
  run_workqueue() -> my_work.f() -> ...; lock(L1); ...

you can get a deadlock if my_work.f() is running but my_function() has
acquired L1 already.  This patch adds a pseudo-lock to each struct work_struct
to make lockdep warn about this scenario.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Acked-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/lockdep.h   |    8 ++++++++
 include/linux/workqueue.h |   29 +++++++++++++++++++++++++++++
 kernel/workqueue.c        |   16 ++++++++++++++++
 3 files changed, 53 insertions(+)

diff -puN include/linux/lockdep.h~workqueue-debug-work-related-deadlocks-with-lockdep include/linux/lockdep.h
--- a/include/linux/lockdep.h~workqueue-debug-work-related-deadlocks-with-lockdep
+++ a/include/linux/lockdep.h
@@ -268,6 +268,14 @@ extern void lockdep_init_map(struct lock
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
diff -puN include/linux/workqueue.h~workqueue-debug-work-related-deadlocks-with-lockdep include/linux/workqueue.h
--- a/include/linux/workqueue.h~workqueue-debug-work-related-deadlocks-with-lockdep
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
diff -puN kernel/workqueue.c~workqueue-debug-work-related-deadlocks-with-lockdep kernel/workqueue.c
--- a/kernel/workqueue.c~workqueue-debug-work-related-deadlocks-with-lockdep
+++ a/kernel/workqueue.c
@@ -254,6 +254,17 @@ static void run_workqueue(struct cpu_wor
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
@@ -262,7 +273,9 @@ static void run_workqueue(struct cpu_wor
 		BUG_ON(get_wq_data(work) != cwq);
 		work_clear_pending(work);
 		lock_acquire(&cwq->wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
+		lock_acquire(&lockdep_map, 0, 0, 0, 2, _THIS_IP_);
 		f(work);
+		lock_release(&lockdep_map, 1, _THIS_IP_);
 		lock_release(&cwq->wq->lockdep_map, 1, _THIS_IP_);
 
 		if (unlikely(in_atomic() || lockdep_depth(current) > 0)) {
@@ -454,6 +467,9 @@ static void wait_on_work(struct work_str
 
 	might_sleep();
 
+	lock_acquire(&work->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
+	lock_release(&work->lockdep_map, 1, _THIS_IP_);
+
 	cwq = get_wq_data(work);
 	if (!cwq)
 		return;
_

Patches currently in -mm which might be from johannes@sipsolutions.net are

origin.patch
workqueue-debug-flushing-deadlocks-with-lockdep.patch
workqueue-debug-work-related-deadlocks-with-lockdep.patch
