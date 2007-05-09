From: akpm@linux-foundation.org
Subject: - workqueue-kill-noautorel-works.patch removed from -mm tree
Date: Wed, 09 May 2007 14:52:07 -0700
Message-ID: <200705092152.l49Lq7lB002967@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47475 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758957AbXEIVwu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:52:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     workqueue: kill NOAUTOREL works
has been removed from the -mm tree.  Its filename was
     workqueue-kill-noautorel-works.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: workqueue: kill NOAUTOREL works
From: Oleg Nesterov <oleg@tv-sign.ru>

We don't have any users, and it is not so trivial to use NOAUTOREL works
correctly.  It is better to simplify API.

Delete NOAUTOREL support and rename work_release to work_clear_pending to
avoid a confusion.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/workqueue.h |   64 +++++-------------------------------
 kernel/workqueue.c        |    5 +-
 2 files changed, 11 insertions(+), 58 deletions(-)

diff -puN include/linux/workqueue.h~workqueue-kill-noautorel-works include/linux/workqueue.h
--- a/include/linux/workqueue.h~workqueue-kill-noautorel-works
+++ a/include/linux/workqueue.h
@@ -24,15 +24,13 @@ typedef void (*work_func_t)(struct work_
 struct work_struct {
 	atomic_long_t data;
 #define WORK_STRUCT_PENDING 0		/* T if work item pending execution */
-#define WORK_STRUCT_NOAUTOREL 1		/* F if work item automatically released on exec */
 #define WORK_STRUCT_FLAG_MASK (3UL)
 #define WORK_STRUCT_WQ_DATA_MASK (~WORK_STRUCT_FLAG_MASK)
 	struct list_head entry;
 	work_func_t func;
 };
 
-#define WORK_DATA_INIT(autorelease) \
-	ATOMIC_LONG_INIT((autorelease) << WORK_STRUCT_NOAUTOREL)
+#define WORK_DATA_INIT()	ATOMIC_LONG_INIT(0)
 
 struct delayed_work {
 	struct work_struct work;
@@ -44,14 +42,8 @@ struct execute_work {
 };
 
 #define __WORK_INITIALIZER(n, f) {				\
-	.data = WORK_DATA_INIT(0),				\
-        .entry	= { &(n).entry, &(n).entry },			\
-	.func = (f),						\
-	}
-
-#define __WORK_INITIALIZER_NAR(n, f) {				\
-	.data = WORK_DATA_INIT(1),				\
-        .entry	= { &(n).entry, &(n).entry },			\
+	.data = WORK_DATA_INIT(),				\
+	.entry	= { &(n).entry, &(n).entry },			\
 	.func = (f),						\
 	}
 
@@ -60,23 +52,12 @@ struct execute_work {
 	.timer = TIMER_INITIALIZER(NULL, 0, 0),			\
 	}
 
-#define __DELAYED_WORK_INITIALIZER_NAR(n, f) {			\
-	.work = __WORK_INITIALIZER_NAR((n).work, (f)),		\
-	.timer = TIMER_INITIALIZER(NULL, 0, 0),			\
-	}
-
 #define DECLARE_WORK(n, f)					\
 	struct work_struct n = __WORK_INITIALIZER(n, f)
 
-#define DECLARE_WORK_NAR(n, f)					\
-	struct work_struct n = __WORK_INITIALIZER_NAR(n, f)
-
 #define DECLARE_DELAYED_WORK(n, f)				\
 	struct delayed_work n = __DELAYED_WORK_INITIALIZER(n, f)
 
-#define DECLARE_DELAYED_WORK_NAR(n, f)			\
-	struct dwork_struct n = __DELAYED_WORK_INITIALIZER_NAR(n, f)
-
 /*
  * initialize a work item's function pointer
  */
@@ -95,16 +76,9 @@ struct execute_work {
  * assignment of the work data initializer allows the compiler
  * to generate better code.
  */
-#define INIT_WORK(_work, _func)					\
-	do {							\
-		(_work)->data = (atomic_long_t) WORK_DATA_INIT(0);	\
-		INIT_LIST_HEAD(&(_work)->entry);		\
-		PREPARE_WORK((_work), (_func));			\
-	} while (0)
-
-#define INIT_WORK_NAR(_work, _func)					\
+#define INIT_WORK(_work, _func)						\
 	do {								\
-		(_work)->data = (atomic_long_t) WORK_DATA_INIT(1);	\
+		(_work)->data = (atomic_long_t) WORK_DATA_INIT();	\
 		INIT_LIST_HEAD(&(_work)->entry);			\
 		PREPARE_WORK((_work), (_func));				\
 	} while (0)
@@ -115,12 +89,6 @@ struct execute_work {
 		init_timer(&(_work)->timer);			\
 	} while (0)
 
-#define INIT_DELAYED_WORK_NAR(_work, _func)			\
-	do {							\
-		INIT_WORK_NAR(&(_work)->work, (_func));		\
-		init_timer(&(_work)->timer);			\
-	} while (0)
-
 #define INIT_DELAYED_WORK_DEFERRABLE(_work, _func)			\
 	do {							\
 		INIT_WORK(&(_work)->work, (_func));		\
@@ -143,24 +111,10 @@ struct execute_work {
 	work_pending(&(w)->work)
 
 /**
- * work_release - Release a work item under execution
- * @work: The work item to release
- *
- * This is used to release a work item that has been initialised with automatic
- * release mode disabled (WORK_STRUCT_NOAUTOREL is set).  This gives the work
- * function the opportunity to grab auxiliary data from the container of the
- * work_struct before clearing the pending bit as the work_struct may be
- * subject to deallocation the moment the pending bit is cleared.
- *
- * In such a case, this should be called in the work function after it has
- * fetched any data it may require from the containter of the work_struct.
- * After this function has been called, the work_struct may be scheduled for
- * further execution or it may be deallocated unless other precautions are
- * taken.
- *
- * This should also be used to release a delayed work item.
+ * work_clear_pending - for internal use only, mark a work item as not pending
+ * @work: The work item in question
  */
-#define work_release(work) \
+#define work_clear_pending(work) \
 	clear_bit(WORK_STRUCT_PENDING, work_data_bits(work))
 
 
@@ -205,7 +159,7 @@ static inline int cancel_delayed_work(st
 
 	ret = del_timer(&work->timer);
 	if (ret)
-		work_release(&work->work);
+		work_clear_pending(&work->work);
 	return ret;
 }
 
diff -puN kernel/workqueue.c~workqueue-kill-noautorel-works kernel/workqueue.c
--- a/kernel/workqueue.c~workqueue-kill-noautorel-works
+++ a/kernel/workqueue.c
@@ -246,8 +246,7 @@ static void run_workqueue(struct cpu_wor
 		spin_unlock_irq(&cwq->lock);
 
 		BUG_ON(get_wq_data(work) != cwq);
-		if (!test_bit(WORK_STRUCT_NOAUTOREL, work_data_bits(work)))
-			work_release(work);
+		work_clear_pending(work);
 		f(work);
 
 		if (unlikely(in_atomic() || lockdep_depth(current) > 0)) {
@@ -453,7 +452,7 @@ void flush_work(struct workqueue_struct 
 	 */
 	spin_lock_irq(&cwq->lock);
 	list_del_init(&work->entry);
-	work_release(work);
+	work_clear_pending(work);
 	spin_unlock_irq(&cwq->lock);
 
 	for_each_cpu_mask(cpu, *cpu_map)
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patch
freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
nlmclnt_recovery-dont-use-clone_sighand.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
fix-pf_nofreeze-and-freezeable-race-2.patch
freezer-document-task_lock-in-thaw_process.patch
move-frozen_process-to-kernel-power-processc.patch
separate-freezer-from-pm-code-rev-2.patch
introduce-freezer-flags-rev-2.patch
libata-core-convert-to-use-cancel_rearming_delayed_work.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
getrusage-fill-ru_inblock-and-ru_oublock-fields-if-possible.patch
dont-init-pgrp-and-__session-in-init_signals.patch
