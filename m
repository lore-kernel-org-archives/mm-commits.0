From: akpm@linux-foundation.org
Subject: + make-cancel_xxx_work_sync-return-a-boolean.patch added to -mm tree
Date: Tue, 03 Jul 2007 14:07:40 -0700
Message-ID: <200707032107.l63L7eCw015644@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39535 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751005AbXGCVH4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jul 2007 17:07:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, jarkao2@o2.pl


The patch titled
     make cancel_xxx_work_sync() return a boolean
has been added to the -mm tree.  Its filename is
     make-cancel_xxx_work_sync-return-a-boolean.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: make cancel_xxx_work_sync() return a boolean
From: Oleg Nesterov <oleg@tv-sign.ru>

Change cancel_work_sync() and cancel_delayed_work_sync() to return a boolean
indicating whether the work was actually cancelled.  A zero return value means
that the work was not pending/queued.

Without that kind of change it is not possible to avoid flush_workqueue()
sometimes, see the next patch as an example.

Also, this patch unifies both functions and kills the (unlikely) busy-wait
loop.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Jarek Poplawski <jarkao2@o2.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/workqueue.h |    4 +--
 kernel/workqueue.c        |   41 +++++++++++++++++++++++-------------
 2 files changed, 29 insertions(+), 16 deletions(-)

diff -puN include/linux/workqueue.h~make-cancel_xxx_work_sync-return-a-boolean include/linux/workqueue.h
--- a/include/linux/workqueue.h~make-cancel_xxx_work_sync-return-a-boolean
+++ a/include/linux/workqueue.h
@@ -148,7 +148,7 @@ extern int keventd_up(void);
 extern void init_workqueues(void);
 int execute_in_process_context(work_func_t fn, struct execute_work *);
 
-extern void cancel_work_sync(struct work_struct *work);
+extern int cancel_work_sync(struct work_struct *work);
 
 /*
  * Kill off a pending schedule_delayed_work().  Note that the work callback
@@ -166,7 +166,7 @@ static inline int cancel_delayed_work(st
 	return ret;
 }
 
-extern void cancel_delayed_work_sync(struct delayed_work *work);
+extern int cancel_delayed_work_sync(struct delayed_work *work);
 
 /* Obsolete. use cancel_delayed_work_sync() */
 static inline
diff -puN kernel/workqueue.c~make-cancel_xxx_work_sync-return-a-boolean kernel/workqueue.c
--- a/kernel/workqueue.c~make-cancel_xxx_work_sync-return-a-boolean
+++ a/kernel/workqueue.c
@@ -382,16 +382,16 @@ void fastcall flush_workqueue(struct wor
 EXPORT_SYMBOL_GPL(flush_workqueue);
 
 /*
- * Upon a successful return, the caller "owns" WORK_STRUCT_PENDING bit,
+ * Upon a successful return (>= 0), the caller "owns" WORK_STRUCT_PENDING bit,
  * so this work can't be re-armed in any way.
  */
 static int try_to_grab_pending(struct work_struct *work)
 {
 	struct cpu_workqueue_struct *cwq;
-	int ret = 0;
+	int ret = -1;
 
 	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work)))
-		return 1;
+		return 0;
 
 	/*
 	 * The queueing is in progress, or it is already queued. Try to
@@ -457,10 +457,28 @@ static void wait_on_work(struct work_str
 		wait_on_cpu_work(per_cpu_ptr(wq->cpu_wq, cpu), work);
 }
 
+static int __cancel_work_timer(struct work_struct *work,
+				struct timer_list* timer)
+{
+	int ret;
+
+	do {
+		ret = (timer && likely(del_timer(timer)));
+		if (!ret)
+			ret = try_to_grab_pending(work);
+		wait_on_work(work);
+	} while (unlikely(ret < 0));
+
+	work_clear_pending(work);
+	return ret;
+}
+
 /**
  * cancel_work_sync - block until a work_struct's callback has terminated
  * @work: the work which is to be flushed
  *
+ * Returns true if @work was pending.
+ *
  * cancel_work_sync() will cancel the work if it is queued. If the work's
  * callback appears to be running, cancel_work_sync() will block until it
  * has completed.
@@ -476,12 +494,9 @@ static void wait_on_work(struct work_str
  * The caller must ensure that workqueue_struct on which this work was last
  * queued can't be destroyed before this function returns.
  */
-void cancel_work_sync(struct work_struct *work)
+int cancel_work_sync(struct work_struct *work)
 {
-	while (!try_to_grab_pending(work))
-		cpu_relax();
-	wait_on_work(work);
-	work_clear_pending(work);
+	return __cancel_work_timer(work, NULL);
 }
 EXPORT_SYMBOL_GPL(cancel_work_sync);
 
@@ -489,16 +504,14 @@ EXPORT_SYMBOL_GPL(cancel_work_sync);
  * cancel_delayed_work_sync - reliably kill off a delayed work.
  * @dwork: the delayed work struct
  *
+ * Returns true if @dwork was pending.
+ *
  * It is possible to use this function if @dwork rearms itself via queue_work()
  * or queue_delayed_work(). See also the comment for cancel_work_sync().
  */
-void cancel_delayed_work_sync(struct delayed_work *dwork)
+int cancel_delayed_work_sync(struct delayed_work *dwork)
 {
-	while (!del_timer(&dwork->timer) &&
-	       !try_to_grab_pending(&dwork->work))
-		cpu_relax();
-	wait_on_work(&dwork->work);
-	work_clear_pending(&dwork->work);
+	return __cancel_work_timer(&dwork->work, &dwork->timer);
 }
 EXPORT_SYMBOL(cancel_delayed_work_sync);
 
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

libata-core-convert-to-use-cancel_rearming_delayed_work.patch
freezer-make-kernel-threads-nonfreezable-by-default.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix-fix.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix-2.patch
freezer-run-show_state-when-freezing-times-out.patch
hibernation-prepare-to-enter-the-low-power-state.patch
freezer-avoid-freezing-kernel-threads-prematurely.patch
freezer-use-__set_current_state-in-refrigerator.patch
freezer-return-int-from-freeze_processes.patch
freezer-remove-redundant-check-in-try_to_freeze_tasks.patch
pm-prevent-frozen-user-mode-helpers-from-failing-the-freezing-of-tasks-rev-2.patch
add-generic-exit-time-stack-depth-checking-to-config_debug_stack_usage.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
use-write_trylock_irqsave-in-ptrace_attach.patch
fix-stop_machine_run-problem-with-naughty-real-time-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
percpu_counters-use-cpu-notifiers.patch
percpu_counters-use-for_each_online_cpu.patch
mm-fix-create_new_namespaces-return-value.patch
adb_probe_task-remove-unneeded-flush_signals-call.patch
kcdrwd-remove-unneeded-flush_signals-call.patch
nbdcsock_xmit-cleanup-signal-related-code.patch
rename-cancel_rearming_delayed_work-to-cancel_delayed_work_sync.patch
make-cancel_xxx_work_sync-return-a-boolean.patch
