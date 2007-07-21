From: akpm@linux-foundation.org
Subject: + workqueue-debug-flushing-deadlocks-with-lockdep.patch added to -mm tree
Date: Fri, 20 Jul 2007 17:04:51 -0700
Message-ID: <200707210004.l6L04pdt023362@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44077 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751102AbXGUAFq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 20:05:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johannes@sipsolutions.net, a.p.zijlstra@chello.nl, mingo@elte.hu, oleg@tv-sign.ru


The patch titled
     workqueue: debug flushing deadlocks with lockdep
has been added to the -mm tree.  Its filename is
     workqueue-debug-flushing-deadlocks-with-lockdep.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Acked-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/workqueue.h |   20 +++++++++++++++++---
 kernel/workqueue.c        |   20 +++++++++++++++++---
 2 files changed, 34 insertions(+), 6 deletions(-)

diff -puN include/linux/workqueue.h~workqueue-debug-flushing-deadlocks-with-lockdep include/linux/workqueue.h
--- a/include/linux/workqueue.h~workqueue-debug-flushing-deadlocks-with-lockdep
+++ a/include/linux/workqueue.h
@@ -118,9 +118,23 @@ struct execute_work {
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
@@ -257,7 +261,9 @@ static void run_workqueue(struct cpu_wor
 
 		BUG_ON(get_wq_data(work) != cwq);
 		work_clear_pending(work);
+		lock_acquire(&cwq->wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
 		f(work);
+		lock_release(&cwq->wq->lockdep_map, 1, _THIS_IP_);
 
 		if (unlikely(in_atomic() || lockdep_depth(current) > 0)) {
 			printk(KERN_ERR "BUG: workqueue leaked lock or atomic: "
@@ -376,6 +382,8 @@ void fastcall flush_workqueue(struct wor
 	int cpu;
 
 	might_sleep();
+	lock_acquire(&wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
+	lock_release(&wq->lockdep_map, 1, _THIS_IP_);
 	for_each_cpu_mask(cpu, *cpu_map)
 		flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));
 }
@@ -695,8 +703,10 @@ static void start_workqueue_thread(struc
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
@@ -713,6 +723,7 @@ struct workqueue_struct *__create_workqu
 	}
 
 	wq->name = name;
+	lockdep_init_map(&wq->lockdep_map, name, key, 0);
 	wq->singlethread = singlethread;
 	wq->freezeable = freezeable;
 	INIT_LIST_HEAD(&wq->list);
@@ -741,7 +752,7 @@ struct workqueue_struct *__create_workqu
 	}
 	return wq;
 }
-EXPORT_SYMBOL_GPL(__create_workqueue);
+EXPORT_SYMBOL_GPL(__create_workqueue_key);
 
 static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
 {
@@ -752,6 +763,9 @@ static void cleanup_workqueue_thread(str
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
workqueue-debug-flushing-deadlocks-with-lockdep.patch
workqueue-debug-work-related-deadlocks-with-lockdep.patch
