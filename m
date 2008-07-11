From: akpm@linux-foundation.org
Subject: + pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:40:59 -0700
Message-ID: <200807111846.m6BIkeTj031024@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36982 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755653AbYGKSrE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:47:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rui.zhang@intel.com, harbour@sfinx.od.ua, oleg@tv-sign.ru, pavel@ucw.cz, rjw@sisk.pl


The patch titled
     pm: introduce new interfaces schedule_work_on() and queue_work_on()
has been added to the -mm tree.  Its filename is
     pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pm: introduce new interfaces schedule_work_on() and queue_work_on()
From: Zhang Rui <rui.zhang@intel.com>

This interface allows adding a job on a specific cpu.

Although a work struct on a cpu will be scheduled to other cpu if the cpu
dies, there is a recursion if a work task tries to offline the cpu it's
running on.  we need to schedule the task to a specific cpu in this case. 
http://bugzilla.kernel.org/show_bug.cgi?id=10897

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Tested-by: Rus <harbour@sfinx.od.ua>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/workqueue.h |    3 ++
 kernel/workqueue.c        |   39 ++++++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+)

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
@@ -175,6 +175,32 @@ int queue_work(struct workqueue_struct *
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
+ * We queue the work to a specific CPU
+ */
+int
+queue_work_on(int cpu, struct workqueue_struct *wq, struct work_struct *work)
+{
+	int ret = 0;
+
+	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
+		BUG_ON(!list_empty(&work->entry));
+		preempt_disable();
+		__queue_work(wq_per_cpu(wq, cpu), work);
+		preempt_enable();
+		ret = 1;
+	}
+	return ret;
+}
+EXPORT_SYMBOL_GPL(queue_work_on);
+
 static void delayed_work_timer_fn(unsigned long __data)
 {
 	struct delayed_work *dwork = (struct delayed_work *)__data;
@@ -553,6 +579,19 @@ int schedule_work(struct work_struct *wo
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

linux-next.patch
pm-ahci-speed-up-resume.patch
pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on.patch
pm-schedule-sysrq-poweroff-on-boot-cpu.patch
dcdbas-use-memory_read_from_buffer.patch
dell_rbu-use-memory_read_from_buffer.patch

