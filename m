From: akpm@osdl.org
Subject: - support-for-freezeable-workqueues.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:59:59 -0800
Message-ID: <200612072259.kB7MxxCt029570@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51162 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163679AbWLGXAK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:00:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, dgc@sgi.com, nigel@suspend2.net, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     Support for freezeable workqueues
has been removed from the -mm tree.  Its filename was
     support-for-freezeable-workqueues.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Support for freezeable workqueues
From: "Rafael J. Wysocki" <rjw@sisk.pl>

Make it possible to create a workqueue the worker thread of which will be
frozen during suspend, along with other kernel threads.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Nigel Cunningham <nigel@suspend2.net>
Cc: David Chinner <dgc@sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/workqueue.h |    8 +++++---
 kernel/workqueue.c        |   20 ++++++++++++++------
 2 files changed, 19 insertions(+), 9 deletions(-)

diff -puN include/linux/workqueue.h~support-for-freezeable-workqueues include/linux/workqueue.h
--- a/include/linux/workqueue.h~support-for-freezeable-workqueues
+++ a/include/linux/workqueue.h
@@ -147,9 +147,11 @@ struct execute_work {
 
 
 extern struct workqueue_struct *__create_workqueue(const char *name,
-						    int singlethread);
-#define create_workqueue(name) __create_workqueue((name), 0)
-#define create_singlethread_workqueue(name) __create_workqueue((name), 1)
+						    int singlethread,
+						    int freezeable);
+#define create_workqueue(name) __create_workqueue((name), 0, 0)
+#define create_freezeable_workqueue(name) __create_workqueue((name), 0, 1)
+#define create_singlethread_workqueue(name) __create_workqueue((name), 1, 0)
 
 extern void destroy_workqueue(struct workqueue_struct *wq);
 
diff -puN kernel/workqueue.c~support-for-freezeable-workqueues kernel/workqueue.c
--- a/kernel/workqueue.c~support-for-freezeable-workqueues
+++ a/kernel/workqueue.c
@@ -29,6 +29,7 @@
 #include <linux/kthread.h>
 #include <linux/hardirq.h>
 #include <linux/mempolicy.h>
+#include <linux/freezer.h>
 
 /*
  * The per-CPU workqueue (if single thread, we always use the first
@@ -55,6 +56,8 @@ struct cpu_workqueue_struct {
 	struct task_struct *thread;
 
 	int run_depth;		/* Detect run_workqueue() recursion depth */
+
+	int freezeable;		/* Freeze the thread during suspend */
 } ____cacheline_aligned;
 
 /*
@@ -265,7 +268,8 @@ static int worker_thread(void *__cwq)
 	struct k_sigaction sa;
 	sigset_t blocked;
 
-	current->flags |= PF_NOFREEZE;
+	if (!cwq->freezeable)
+		current->flags |= PF_NOFREEZE;
 
 	set_user_nice(current, -5);
 
@@ -288,6 +292,9 @@ static int worker_thread(void *__cwq)
 
 	set_current_state(TASK_INTERRUPTIBLE);
 	while (!kthread_should_stop()) {
+		if (cwq->freezeable)
+			try_to_freeze();
+
 		add_wait_queue(&cwq->more_work, &wait);
 		if (list_empty(&cwq->worklist))
 			schedule();
@@ -364,7 +371,7 @@ void fastcall flush_workqueue(struct wor
 EXPORT_SYMBOL_GPL(flush_workqueue);
 
 static struct task_struct *create_workqueue_thread(struct workqueue_struct *wq,
-						   int cpu)
+						   int cpu, int freezeable)
 {
 	struct cpu_workqueue_struct *cwq = per_cpu_ptr(wq->cpu_wq, cpu);
 	struct task_struct *p;
@@ -374,6 +381,7 @@ static struct task_struct *create_workqu
 	cwq->thread = NULL;
 	cwq->insert_sequence = 0;
 	cwq->remove_sequence = 0;
+	cwq->freezeable = freezeable;
 	INIT_LIST_HEAD(&cwq->worklist);
 	init_waitqueue_head(&cwq->more_work);
 	init_waitqueue_head(&cwq->work_done);
@@ -389,7 +397,7 @@ static struct task_struct *create_workqu
 }
 
 struct workqueue_struct *__create_workqueue(const char *name,
-					    int singlethread)
+					    int singlethread, int freezeable)
 {
 	int cpu, destroy = 0;
 	struct workqueue_struct *wq;
@@ -409,7 +417,7 @@ struct workqueue_struct *__create_workqu
 	mutex_lock(&workqueue_mutex);
 	if (singlethread) {
 		INIT_LIST_HEAD(&wq->list);
-		p = create_workqueue_thread(wq, singlethread_cpu);
+		p = create_workqueue_thread(wq, singlethread_cpu, freezeable);
 		if (!p)
 			destroy = 1;
 		else
@@ -417,7 +425,7 @@ struct workqueue_struct *__create_workqu
 	} else {
 		list_add(&wq->list, &workqueues);
 		for_each_online_cpu(cpu) {
-			p = create_workqueue_thread(wq, cpu);
+			p = create_workqueue_thread(wq, cpu, freezeable);
 			if (p) {
 				kthread_bind(p, cpu);
 				wake_up_process(p);
@@ -667,7 +675,7 @@ static int __devinit workqueue_cpu_callb
 		mutex_lock(&workqueue_mutex);
 		/* Create a new workqueue thread for it. */
 		list_for_each_entry(wq, &workqueues, list) {
-			if (!create_workqueue_thread(wq, hotcpu)) {
+			if (!create_workqueue_thread(wq, hotcpu, 0)) {
 				printk("workqueue for %i failed\n", hotcpu);
 				return NOTIFY_BAD;
 			}
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
git-acpi.patch
md-change-lifetime-rules-for-md-devices.patch

