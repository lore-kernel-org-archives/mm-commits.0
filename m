From: akpm@linux-foundation.org
Subject: + pps-add-async-pps-event-handler.patch added to -mm tree
Date: Wed, 04 Aug 2010 16:38:29 -0700
Message-ID: <201008042338.o74NcTgg017008@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52007 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756811Ab0HEADi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Aug 2010 20:03:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lasaine@lvk.cs.msu.su, giometti@enneenne.com, johnstul@us.ibm.com, joonwpark81@gmail.com, tj@kernel.org, yoush@cs.msu.su


The patch titled
     pps: add async PPS event handler
has been added to the -mm tree.  Its filename is
     pps-add-async-pps-event-handler.patch

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
Subject: pps: add async PPS event handler
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>

This handler should be called from an IRQ handler.  It uses per-device
workqueue internally.

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: "Nikita V. Youshchenko" <yoush@cs.msu.su>
Cc: Rodolfo Giometti <giometti@enneenne.com>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Joonwoo Park <joonwpark81@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/clients/pps-ktimer.c |    2 
 drivers/pps/clients/pps-ldisc.c  |    2 
 drivers/pps/kapi.c               |   95 +++++++++++++++++++++++++++--
 drivers/pps/pps.c                |   14 +++-
 include/linux/pps_kernel.h       |   16 ++++
 5 files changed, 119 insertions(+), 10 deletions(-)

diff -puN drivers/pps/clients/pps-ktimer.c~pps-add-async-pps-event-handler drivers/pps/clients/pps-ktimer.c
--- a/drivers/pps/clients/pps-ktimer.c~pps-add-async-pps-event-handler
+++ a/drivers/pps/clients/pps-ktimer.c
@@ -47,7 +47,7 @@ static void pps_ktimer_event(unsigned lo
 
 	dev_info(pps->dev, "PPS event at %lu\n", jiffies);
 
-	pps_event(pps, &ts, PPS_CAPTUREASSERT, NULL);
+	pps_event_irq(pps, &ts, PPS_CAPTUREASSERT, NULL);
 
 	mod_timer(&ktimer, jiffies + HZ);
 }
diff -puN drivers/pps/clients/pps-ldisc.c~pps-add-async-pps-event-handler drivers/pps/clients/pps-ldisc.c
--- a/drivers/pps/clients/pps-ldisc.c~pps-add-async-pps-event-handler
+++ a/drivers/pps/clients/pps-ldisc.c
@@ -40,7 +40,7 @@ static void pps_tty_dcd_change(struct tt
 		ts = &__ts;
 
 	/* Now do the PPS event report */
-	pps_event(pps, ts, status ? PPS_CAPTUREASSERT : PPS_CAPTURECLEAR,
+	pps_event_irq(pps, ts, status ? PPS_CAPTUREASSERT : PPS_CAPTURECLEAR,
 			NULL);
 
 	dev_dbg(pps->dev, "PPS %s at %lu\n", status ? "assert" : "clear",
diff -puN drivers/pps/kapi.c~pps-add-async-pps-event-handler drivers/pps/kapi.c
--- a/drivers/pps/kapi.c~pps-add-async-pps-event-handler
+++ a/drivers/pps/kapi.c
@@ -31,9 +31,19 @@
 #include <linux/slab.h>
 
 /*
+ * Global variables
+ */
+
+/* PPS event workqueue */
+struct workqueue_struct *pps_event_workqueue;
+
+/*
  * Local functions
  */
 
+static void assert_work_func(struct work_struct *work);
+static void clear_work_func(struct work_struct *work);
+
 static void pps_add_offset(struct pps_ktime *ts, struct pps_ktime *offset)
 {
 	ts->nsec += offset->nsec;
@@ -107,6 +117,9 @@ struct pps_device *pps_register_source(s
 	init_waitqueue_head(&pps->queue);
 	spin_lock_init(&pps->lock);
 
+	INIT_WORK(&pps->assert_work, assert_work_func);
+	INIT_WORK(&pps->clear_work, clear_work_func);
+
 	/* Create the char device */
 	err = pps_register_cdev(pps);
 	if (err < 0) {
@@ -148,11 +161,12 @@ EXPORT_SYMBOL(pps_unregister_source);
  * @event: the event type
  * @data: userdef pointer
  *
- * This function is used by each PPS client in order to register a new
- * PPS event into the system (it's usually called inside an IRQ handler).
+ * This function is used by PPS clients in order to register a new
+ * PPS event into the system. It should not be called from an IRQ
+ * handler. Use pps_event_irq instead.
  *
- * If an echo function is associated with the PPS device it will be called
- * as:
+ * If an echo function is associated with the PPS device it will be
+ * called as:
  *	pps->info.echo(pps, event, data);
  */
 void pps_event(struct pps_device *pps, struct pps_event_time *ts, int event,
@@ -222,3 +236,76 @@ void pps_event(struct pps_device *pps, s
 	spin_unlock_irqrestore(&pps->lock, flags);
 }
 EXPORT_SYMBOL(pps_event);
+
+/* Async event handlers */
+
+static void assert_work_func(struct work_struct *work)
+{
+	struct pps_device *pps = container_of(work,
+			struct pps_device, assert_work);
+
+	pps_event(pps, &pps->assert_work_ts, PPS_CAPTUREASSERT,
+			pps->assert_work_data);
+}
+
+static void clear_work_func(struct work_struct *work)
+{
+	struct pps_device *pps = container_of(work,
+			struct pps_device, clear_work);
+
+	pps_event(pps, &pps->clear_work_ts, PPS_CAPTURECLEAR,
+			pps->clear_work_data);
+}
+
+/* pps_event_irq - register a PPS event for deffered handling using
+ * workqueue
+ *
+ * @pps: the PPS device
+ * @ts: the event timestamp
+ * @event: the event type
+ * @data: userdef pointer
+ *
+ * This function is used by PPS clients in order to register a new
+ * PPS event into the system. It should be called from an IRQ handler
+ * only.
+ *
+ * If an echo function is associated with the PPS device it will be
+ * called as:
+ *	pps->info.echo(pps, event, data);
+ */
+void pps_event_irq(struct pps_device *pps, struct pps_event_time *ts,
+		int event, void *data)
+{
+	/* check event type */
+	BUG_ON((event & (PPS_CAPTUREASSERT | PPS_CAPTURECLEAR)) == 0);
+
+	if (event & PPS_CAPTUREASSERT) {
+		if (work_pending(&pps->assert_work)) {
+			dev_err(pps->dev, "deferred assert edge work haven't"
+					" been handled within a second\n");
+			/* FIXME: do something more intelligent
+			 * then just exit */
+		} else {
+			/* now we can copy data safely */
+			pps->assert_work_ts = *ts;
+			pps->assert_work_data = data;
+
+			queue_work(pps_event_workqueue, &pps->assert_work);
+		}
+	}
+	if (event & PPS_CAPTURECLEAR) {
+		if (work_pending(&pps->clear_work)) {
+			dev_err(pps->dev, "deferred clear edge work haven't"
+					" been handled within a second\n");
+			/* FIXME: do something more intelligent
+			 * then just exit */
+		} else {
+			/* now we can copy data safely */
+			pps->clear_work_ts = *ts;
+			pps->clear_work_data = data;
+
+			queue_work(pps_event_workqueue, &pps->clear_work);
+		}
+	}
+}
+EXPORT_SYMBOL(pps_event_irq);
diff -puN drivers/pps/pps.c~pps-add-async-pps-event-handler drivers/pps/pps.c
--- a/drivers/pps/pps.c~pps-add-async-pps-event-handler
+++ a/drivers/pps/pps.c
@@ -319,18 +319,26 @@ void pps_unregister_cdev(struct pps_devi
 
 static void __exit pps_exit(void)
 {
-	class_destroy(pps_class);
 	unregister_chrdev_region(pps_devt, PPS_MAX_SOURCES);
+	class_destroy(pps_class);
+	destroy_workqueue(pps_event_workqueue);
 }
 
 static int __init pps_init(void)
 {
 	int err;
 
+	pps_event_workqueue = create_rt_workqueue("pps");
+	if (!pps_event_workqueue) {
+		pr_err("pps: failed to create workqueue\n");
+		return -ENOMEM;
+	}
+
 	pps_class = class_create(THIS_MODULE, "pps");
 	if (!pps_class) {
 		pr_err("pps: failed to allocate class\n");
-		return -ENOMEM;
+		err = -ENOMEM;
+		goto destroy_workqueue;
 	}
 	pps_class->dev_attrs = pps_attrs;
 
@@ -348,6 +356,8 @@ static int __init pps_init(void)
 
 remove_class:
 	class_destroy(pps_class);
+destroy_workqueue:
+	destroy_workqueue(pps_event_workqueue);
 
 	return err;
 }
diff -puN include/linux/pps_kernel.h~pps-add-async-pps-event-handler include/linux/pps_kernel.h
--- a/include/linux/pps_kernel.h~pps-add-async-pps-event-handler
+++ a/include/linux/pps_kernel.h
@@ -26,6 +26,7 @@
 #include <linux/cdev.h>
 #include <linux/device.h>
 #include <linux/time.h>
+#include <linux/workqueue.h>
 
 /*
  * Global defines
@@ -70,6 +71,13 @@ struct pps_device {
 	struct device *dev;
 	struct fasync_struct *async_queue;	/* fasync method */
 	spinlock_t lock;
+
+	struct work_struct assert_work;
+	struct work_struct clear_work;
+	struct pps_event_time assert_work_ts;
+	struct pps_event_time clear_work_ts;
+	void *assert_work_data;
+	void *clear_work_data;
 };
 
 /*
@@ -78,6 +86,8 @@ struct pps_device {
 
 extern struct device_attribute pps_attrs[];
 
+extern struct workqueue_struct *pps_event_workqueue;
+
 /*
  * Exported functions
  */
@@ -87,8 +97,10 @@ extern struct pps_device *pps_register_s
 extern void pps_unregister_source(struct pps_device *pps);
 extern int pps_register_cdev(struct pps_device *pps);
 extern void pps_unregister_cdev(struct pps_device *pps);
-extern void pps_event(struct pps_device *pps, struct pps_event_time *ts, int event,
-		void *data);
+extern void pps_event(struct pps_device *pps,
+		struct pps_event_time *ts, int event, void *data);
+extern void pps_event_irq(struct pps_device *pps,
+		struct pps_event_time *ts, int event, void *data);
 
 static inline void timespec_to_pps_ktime(struct pps_ktime *kt,
 		struct timespec ts)
_

Patches currently in -mm which might be from lasaine@lvk.cs.msu.su are

pps-trivial-fixes.patch
pps-declare-variables-where-they-are-used-in-switch.patch
pps-fix-race-in-pps_fetch-handler.patch
pps-unify-timestamp-gathering.patch
pps-access-pps-device-by-direct-pointer.patch
pps-convert-printk-pr_-to-dev_.patch
pps-move-idr-stuff-to-ppsc.patch
pps-add-async-pps-event-handler.patch
pps-dont-disable-interrupts-when-using-spin-locks.patch
pps-use-bug_on-for-kernel-api-safety-checks.patch
pps-simplify-conditions-a-bit.patch
ntp-add-hardpps-implementation.patch
pps-capture-monotonic_raw-timestamps-as-well.patch
pps-add-kernel-consumer-support.patch
pps-add-parallel-port-pps-client.patch
pps-add-parallel-port-pps-signal-generator.patch

