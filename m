From: akpm@linux-foundation.org
Subject: - pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:25:31 -0700
Message-ID: <200807242325.m6ONPVbX010888@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44623 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755196AbYGXXZw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:25:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rui.zhang@intel.com, harbour@sfinx.od.ua, oleg@tv-sign.ru, pavel@ucw.cz, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     pm: introduce new interfaces schedule_work_on() and queue_work_on()
has been removed from the -mm tree.  Its filename was
     pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pm: introduce new interfaces schedule_work_on() and queue_work_on()
From: Zhang Rui <rui.zhang@intel.com>

This interface allows adding a job on a specific cpu.

Although a work struct on a cpu will be scheduled to other cpu if the cpu
dies, there is a recursion if a work task tries to offline the cpu it's
running on.  we need to schedule the task to a specific cpu in this case. 
http://bugzilla.kernel.org/show_bug.cgi?id=10897

[oleg@tv-sign.ru: cleanups]
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Tested-by: Rus <harbour@sfinx.od.ua>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/workqueue.h |    3 ++
 kernel/workqueue.c        |   39 +++++++++++++++++++++++++++++++++++-
 2 files changed, 41 insertions(+), 1 deletion(-)

diff -puN include/linux/workqueue.h~pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on include/linux/workqueue.h
--- a/include/linux/workqueue.h~pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on
+++ a/include/linux/workqueue.h
@@ -179,6 +179,8 @@ __create_workqueue_key(const char *name,
 extern void destroy_workqueue(struct workqueue_struct *wq);
 
 extern int queue_work(struct workqueue_struct *wq, struct work_struct *work);
+extern int queue_work_on(int cpu, struct workqueue_struct *wq,
+			struct work_struct *work);
 extern int queue_delayed_work(struct workqueue_struct *wq,
 			struct delayed_work *work, unsigned long delay);
 extern int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
@@ -188,6 +190,7 @@ extern void flush_workqueue(struct workq
 extern void flush_scheduled_work(void);
 
 extern int schedule_work(struct work_struct *work);
+extern int schedule_work_on(int cpu, struct work_struct *work);
 extern int schedule_delayed_work(struct delayed_work *work, unsigned long delay);
 extern int schedule_delayed_work_on(int cpu, struct delayed_work *work,
 					unsigned long delay);
diff -puN kernel/workqueue.c~pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on kernel/workqueue.c
--- a/kernel/workqueue.c~pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on
+++ a/kernel/workqueue.c
@@ -140,7 +140,6 @@ static void insert_work(struct cpu_workq
 	wake_up(&cwq->more_work);
 }
 
-/* Preempt must be disabled. */
 static void __queue_work(struct cpu_workqueue_struct *cwq,
 			 struct work_struct *work)
 {
@@ -175,6 +174,31 @@ int queue_work(struct workqueue_struct *
 }
 EXPORT_SYMBOL_GPL(queue_work);
 
+/**
+ * queue_work_on - queue work on specific cpu
+ * @cpu: CPU number to execute work on
+ * @wq: workqueue to use
+ * @work: work to queue
+ *
+ * Returns 0 if @work was already on a queue, non-zero otherwise.
+ *
+ * We queue the work to a specific CPU, the caller must ensure it
+ * can't go away.
+ */
+int
+queue_work_on(int cpu, struct workqueue_struct *wq, struct work_struct *work)
+{
+	int ret = 0;
+
+	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
+		BUG_ON(!list_empty(&work->entry));
+		__queue_work(wq_per_cpu(wq, cpu), work);
+		ret = 1;
+	}
+	return ret;
+}
+EXPORT_SYMBOL_GPL(queue_work_on);
+
 static void delayed_work_timer_fn(unsigned long __data)
 {
 	struct delayed_work *dwork = (struct delayed_work *)__data;
@@ -553,6 +577,19 @@ int schedule_work(struct work_struct *wo
 }
 EXPORT_SYMBOL(schedule_work);
 
+/*
+ * schedule_work_on - put work task on a specific cpu
+ * @cpu: cpu to put the work task on
+ * @work: job to be done
+ *
+ * This puts a job on a specific cpu
+ */
+int schedule_work_on(int cpu, struct work_struct *work)
+{
+	return queue_work_on(cpu, keventd_wq, work);
+}
+EXPORT_SYMBOL(schedule_work_on);
+
 /**
  * schedule_delayed_work - put work task in global workqueue after delay
  * @dwork: job to be done
_

Patches currently in -mm which might be from rui.zhang@intel.com are

origin.patch
linux-next.patch
dcdbas-use-memory_read_from_buffer.patch
dcdbas-use-memory_read_from_buffer-fix.patch
dell_rbu-use-memory_read_from_buffer.patch
dell_rbu-use-memory_read_from_buffer-fix.patch

