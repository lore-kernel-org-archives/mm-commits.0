From: akpm@linux-foundation.org
Subject: - drivers-edac-mod-mc-to-use-workq-instead-of-kthread.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:05:51 -0700
Message-ID: <200707192005.l6JK5pmS020078@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60664 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756391AbXGSUPw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: djiang@mvista.com, dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     drivers/edac: mod MC to use workq instead of kthread
has been removed from the -mm tree.  Its filename was
     drivers-edac-mod-mc-to-use-workq-instead-of-kthread.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/edac: mod MC to use workq instead of kthread
From: Dave Jiang <djiang@mvista.com>

Move the memory controller object to work queue based implementation from the
kernel thread based.

Signed-off-by: Dave Jiang <djiang@mvista.com>
Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_core.h     |   14 +++
 drivers/edac/edac_device.c   |   36 +++++----
 drivers/edac/edac_mc.c       |  119 +++++++++++++++++++++++++++++++++
 drivers/edac/edac_mc_sysfs.c |   14 ++-
 drivers/edac/edac_module.c   |   86 +++--------------------
 drivers/edac/edac_module.h   |    5 -
 6 files changed, 177 insertions(+), 97 deletions(-)

diff -puN drivers/edac/edac_core.h~drivers-edac-mod-mc-to-use-workq-instead-of-kthread drivers/edac/edac_core.h
--- a/drivers/edac/edac_core.h~drivers-edac-mod-mc-to-use-workq-instead-of-kthread
+++ a/drivers/edac/edac_core.h
@@ -382,6 +382,15 @@ struct mem_ctl_info {
 	/* edac sysfs device control */
 	struct kobject edac_mci_kobj;
 	struct completion kobj_complete;
+
+	/* work struct for this MC */
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
+	struct delayed_work work;
+#else
+	struct work_struct work;
+#endif
+	/* the internal state of this controller instance */
+	int op_state;
 };
 
 /*
@@ -573,6 +582,9 @@ struct edac_device_ctl_info {
 };
 
 /* To get from the instance's wq to the beginning of the ctl structure */
+#define to_edac_mem_ctl_work(w) \
+		container_of(w, struct mem_ctl_info, work)
+
 #define to_edac_device_ctl_work(w) \
 		container_of(w,struct edac_device_ctl_info,work)
 
@@ -584,6 +596,8 @@ static inline void edac_device_calc_dela
 	edac_dev->delay = edac_dev->poll_msec * HZ / 1000;
 }
 
+#define edac_calc_delay(dev) dev->delay = dev->poll_msec * HZ / 1000;
+
 /*
  * The alloc() and free() functions for the 'edac_device' control info
  * structure. A MC driver will allocate one of these for each edac_device
diff -puN drivers/edac/edac_device.c~drivers-edac-mod-mc-to-use-workq-instead-of-kthread drivers/edac/edac_device.c
--- a/drivers/edac/edac_device.c~drivers-edac-mod-mc-to-use-workq-instead-of-kthread
+++ a/drivers/edac/edac_device.c
@@ -332,17 +332,17 @@ EXPORT_SYMBOL(edac_device_find);
 
 
 /*
- * edac_workq_function
+ * edac_device_workq_function
  *	performs the operation scheduled by a workq request
  */
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
-static void edac_workq_function(struct work_struct *work_req)
+static void edac_device_workq_function(struct work_struct *work_req)
 {
 	struct delayed_work *d_work = (struct delayed_work*) work_req;
 	struct edac_device_ctl_info *edac_dev =
 		to_edac_device_ctl_work(d_work);
 #else
-static void edac_workq_function(void *ptr)
+static void edac_device_workq_function(void *ptr)
 {
 	struct edac_device_ctl_info *edac_dev =
 		(struct edac_device_ctl_info *) ptr;
@@ -364,30 +364,31 @@ static void edac_workq_function(void *pt
 }
 
 /*
- * edac_workq_setup
+ * edac_device_workq_setup
  *	initialize a workq item for this edac_device instance
  *	passing in the new delay period in msec
  */
-void edac_workq_setup(struct edac_device_ctl_info *edac_dev, unsigned msec)
+void edac_device_workq_setup(struct edac_device_ctl_info *edac_dev,
+		unsigned msec)
 {
 	debugf0("%s()\n", __func__);
 
 	edac_dev->poll_msec = msec;
-	edac_device_calc_delay(edac_dev);	/* Calc delay jiffies */
+	edac_calc_delay(edac_dev);	/* Calc delay jiffies */
 
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
-	INIT_DELAYED_WORK(&edac_dev->work,edac_workq_function);
+	INIT_DELAYED_WORK(&edac_dev->work, edac_device_workq_function);
 #else
-	INIT_WORK(&edac_dev->work,edac_workq_function,edac_dev);
+	INIT_WORK(&edac_dev->work, edac_device_workq_function, edac_dev);
 #endif
-	queue_delayed_work(edac_workqueue,&edac_dev->work, edac_dev->delay);
+	queue_delayed_work(edac_workqueue, &edac_dev->work, edac_dev->delay);
 }
 
 /*
- * edac_workq_teardown
+ * edac_device_workq_teardown
  *	stop the workq processing on this edac_dev
  */
-void edac_workq_teardown(struct edac_device_ctl_info *edac_dev)
+void edac_device_workq_teardown(struct edac_device_ctl_info *edac_dev)
 {
 	int status;
 
@@ -409,10 +410,10 @@ void edac_device_reset_delay_period(
 	lock_device_list();
 
 	/* cancel the current workq request */
-	edac_workq_teardown(edac_dev);
+	edac_device_workq_teardown(edac_dev);
 
 	/* restart the workq request, with new delay value */
-	edac_workq_setup(edac_dev, value);
+	edac_device_workq_setup(edac_dev, value);
 
 	unlock_device_list();
 }
@@ -479,8 +480,11 @@ int edac_device_add_device(struct edac_d
 		/* This instance is NOW RUNNING */
 		edac_dev->op_state = OP_RUNNING_POLL;
 
-		/* enable workq processing on this instance, default = 1000 msec */
-		edac_workq_setup(edac_dev, 1000);
+		/*
+		 * enable workq processing on this instance,
+		 * default = 1000 msec
+		 */
+		edac_device_workq_setup(edac_dev, 1000);
 	} else {
 		edac_dev->op_state = OP_RUNNING_INTERRUPT;
 	}
@@ -538,7 +542,7 @@ struct edac_device_ctl_info * edac_devic
 	edac_dev->op_state = OP_OFFLINE;
 
 	/* clear workq processing on this instance */
-	edac_workq_teardown(edac_dev);
+	edac_device_workq_teardown(edac_dev);
 
 	/* Tear down the sysfs entries for this instance */
 	edac_device_remove_sysfs(edac_dev);
diff -puN drivers/edac/edac_mc.c~drivers-edac-mod-mc-to-use-workq-instead-of-kthread drivers/edac/edac_mc.c
--- a/drivers/edac/edac_mc.c~drivers-edac-mod-mc-to-use-workq-instead-of-kthread
+++ a/drivers/edac/edac_mc.c
@@ -184,6 +184,8 @@ struct mem_ctl_info *edac_mc_alloc(unsig
 		}
 	}
 
+	mci->op_state = OP_ALLOC;
+
 	return mci;
 }
 EXPORT_SYMBOL_GPL(edac_mc_alloc);
@@ -215,6 +217,107 @@ static struct mem_ctl_info *find_mci_by_
 	return NULL;
 }
 
+/*
+ * handler for EDAC to check if NMI type handler has asserted interrupt
+ */
+static int edac_mc_assert_error_check_and_clear(void)
+{
+	int vreg;
+
+	if(edac_op_state == EDAC_OPSTATE_POLL)
+		return 1;
+
+	vreg = atomic_read(&edac_err_assert);
+	if(vreg) {
+		atomic_set(&edac_err_assert, 0);
+		return 1;
+	}
+
+	return 0;
+}
+
+/*
+ * edac_mc_workq_function
+ *	performs the operation scheduled by a workq request
+ */
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
+static void edac_mc_workq_function(struct work_struct *work_req)
+{
+	struct delayed_work *d_work = (struct delayed_work*) work_req;
+	struct mem_ctl_info *mci = to_edac_mem_ctl_work(d_work);
+#else
+static void edac_mc_workq_function(void *ptr)
+{
+	struct mem_ctl_info *mci = (struct mem_ctl_info *) ptr;
+#endif
+
+	mutex_lock(&mem_ctls_mutex);
+
+	/* Only poll controllers that are running polled and have a check */
+	if (edac_mc_assert_error_check_and_clear() && (mci->edac_check != NULL))
+		mci->edac_check(mci);
+
+	/*
+	 * FIXME: temp place holder for PCI checks,
+	 * goes away when we break out PCI
+	 */
+	edac_pci_do_parity_check();
+
+	mutex_unlock(&mem_ctls_mutex);
+
+	/* Reschedule */
+	queue_delayed_work(edac_workqueue, &mci->work, edac_mc_get_poll_msec());
+}
+
+/*
+ * edac_mc_workq_setup
+ *	initialize a workq item for this mci
+ *	passing in the new delay period in msec
+ */
+void edac_mc_workq_setup(struct mem_ctl_info *mci, unsigned msec)
+{
+	debugf0("%s()\n", __func__);
+
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
+	INIT_DELAYED_WORK(&mci->work, edac_mc_workq_function);
+#else
+	INIT_WORK(&mci->work, edac_mc_workq_function, mci);
+#endif
+	queue_delayed_work(edac_workqueue, &mci->work, msecs_to_jiffies(msec));
+}
+
+/*
+ * edac_mc_workq_teardown
+ *	stop the workq processing on this mci
+ */
+void edac_mc_workq_teardown(struct mem_ctl_info *mci)
+{
+	int status;
+
+	status = cancel_delayed_work(&mci->work);
+	if (status == 0) {
+		/* workq instance might be running, wait for it */
+		flush_workqueue(edac_workqueue);
+	}
+}
+
+/*
+ * edac_reset_delay_period
+ */
+
+void edac_reset_delay_period(struct mem_ctl_info *mci, unsigned long value)
+{
+	mutex_lock(&mem_ctls_mutex);
+
+	/* cancel the current workq request */
+	edac_mc_workq_teardown(mci);
+
+	/* restart the workq request, with new delay value */
+	edac_mc_workq_setup(mci, value);
+
+	mutex_unlock(&mem_ctls_mutex);
+}
+
 /* Return 0 on success, 1 on failure.
  * Before calling this function, caller must
  * assign a unique value to mci->mc_idx.
@@ -351,6 +454,16 @@ int edac_mc_add_mc(struct mem_ctl_info *
 		goto fail1;
 	}
 
+	/* If there IS a check routine, then we are running POLLED */
+	if (mci->edac_check != NULL) {
+		/* This instance is NOW RUNNING */
+		mci->op_state = OP_RUNNING_POLL;
+
+		edac_mc_workq_setup(mci, edac_mc_get_poll_msec());
+	} else {
+		mci->op_state = OP_RUNNING_INTERRUPT;
+	}
+
 	/* Report action taken */
 	edac_mc_printk(mci, KERN_INFO, "Giving out device to %s %s: DEV %s\n",
 		mci->mod_name, mci->ctl_name, dev_name(mci));
@@ -386,6 +499,12 @@ struct mem_ctl_info * edac_mc_del_mc(str
 		return NULL;
 	}
 
+	/* marking MCI offline */
+	mci->op_state = OP_OFFLINE;
+
+	/* flush workq processes */
+	edac_mc_workq_teardown(mci);
+
 	edac_remove_sysfs_mci_device(mci);
 	del_mc_from_global_list(mci);
 	mutex_unlock(&mem_ctls_mutex);
diff -puN drivers/edac/edac_mc_sysfs.c~drivers-edac-mod-mc-to-use-workq-instead-of-kthread drivers/edac/edac_mc_sysfs.c
--- a/drivers/edac/edac_mc_sysfs.c~drivers-edac-mod-mc-to-use-workq-instead-of-kthread
+++ a/drivers/edac/edac_mc_sysfs.c
@@ -22,22 +22,28 @@ static int panic_on_ue;
 static int poll_msec = 1000;
 
 /* Getter functions for above */
-int edac_get_log_ue()
+int edac_get_log_ue(void)
 {
 	return log_ue;
 }
 
-int edac_get_log_ce()
+int edac_get_log_ce(void)
 {
 	return log_ce;
 }
 
-int edac_get_panic_on_ue()
+int edac_get_panic_on_ue(void)
 {
 	return panic_on_ue;
 }
 
-int edac_get_poll_msec()
+/* this is temporary */
+int edac_mc_get_poll_msec(void)
+{
+	return edac_get_poll_msec();
+}
+
+int edac_get_poll_msec(void)
 {
 	return poll_msec;
 }
diff -puN drivers/edac/edac_module.c~drivers-edac-mod-mc-to-use-workq-instead-of-kthread drivers/edac/edac_module.c
--- a/drivers/edac/edac_module.c~drivers-edac-mod-mc-to-use-workq-instead-of-kthread
+++ a/drivers/edac/edac_module.c
@@ -1,6 +1,14 @@
-
-#include <linux/freezer.h>
-#include <linux/kthread.h>
+/*
+ * edac_module.c
+ *
+ * (C) 2007 www.douglaskthompson.com
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ *
+ * Author: Doug Thompson <norsk5@xmission.com>
+ *
+ */
 #include <linux/edac.h>
 
 #include "edac_core.h"
@@ -17,10 +25,6 @@ EXPORT_SYMBOL_GPL(edac_debug_level);
 /* scope is to module level only */
 struct workqueue_struct *edac_workqueue;
 
-/* private to this file */
-static struct task_struct *edac_thread;
-
-
 /*
  * sysfs object: /sys/devices/system/edac
  *	need to export to other files in this modules
@@ -84,63 +88,6 @@ static void edac_unregister_sysfs_edac_n
 	edac_class_valid = 0;
 }
 
-
-/*
- * Check MC status every edac_get_poll_msec().
- * Check PCI status every edac_get_poll_msec() as well.
- *
- * This where the work gets done for edac.
- *
- * SMP safe, doesn't use NMI, and auto-rate-limits.
- */
-static void do_edac_check(void)
-{
-	debugf3("%s()\n", __func__);
-
-	/* perform the poll activities */
-	edac_check_mc_devices();
-	edac_pci_do_parity_check();
-}
-
-/*
- * handler for EDAC to check if NMI type handler has asserted interrupt
- */
-static int edac_assert_error_check_and_clear(void)
-{
-	int vreg;
-
-	if(edac_op_state == EDAC_OPSTATE_POLL)
-		return 1;
-
-	vreg = atomic_read(&edac_err_assert);
-	if(vreg) {
-		atomic_set(&edac_err_assert, 0);
-		return 1;
-	}
-
-	return 0;
-}
-
-/*
- * Action thread for EDAC to perform the POLL operations
- */
-static int edac_kernel_thread(void *arg)
-{
-	int msec;
-
-	while (!kthread_should_stop()) {
-		if(edac_assert_error_check_and_clear())
-			do_edac_check();
-
-		/* goto sleep for the interval */
-		msec = (HZ * edac_get_poll_msec()) / 1000;
-		schedule_timeout_interruptible(msec);
-		try_to_freeze();
-	}
-
-	return 0;
-}
-
 /*
  * edac_workqueue_setup
  *	initialize the edac work queue for polling operations
@@ -221,19 +168,9 @@ static int __init edac_init(void)
 		goto error_pci;
 	}
 
-	/* create our kernel thread */
-	edac_thread = kthread_run(edac_kernel_thread, NULL, "kedac");
-
-	if (IS_ERR(edac_thread)) {
-		err = PTR_ERR(edac_thread);
-		goto error_work;
-	}
-
 	return 0;
 
 	/* Error teardown stack */
-error_work:
-	edac_workqueue_teardown();
 error_pci:
 	edac_sysfs_pci_teardown();
 error_mem:
@@ -251,7 +188,6 @@ error:
 static void __exit edac_exit(void)
 {
 	debugf0("%s()\n", __func__);
-	kthread_stop(edac_thread);
 
 	/* tear down the various subsystems*/
 	edac_workqueue_teardown();
diff -puN drivers/edac/edac_module.h~drivers-edac-mod-mc-to-use-workq-instead-of-kthread drivers/edac/edac_module.h
--- a/drivers/edac/edac_module.h~drivers-edac-mod-mc-to-use-workq-instead-of-kthread
+++ a/drivers/edac/edac_module.h
@@ -28,6 +28,7 @@ extern int edac_get_log_ue(void);
 extern int edac_get_log_ce(void);
 extern int edac_get_panic_on_ue(void);
 extern int edac_get_poll_msec(void);
+extern int edac_mc_get_poll_msec(void);
 
 extern int edac_device_create_sysfs(struct edac_device_ctl_info *edac_dev);
 extern void edac_device_remove_sysfs(struct edac_device_ctl_info *edac_dev);
@@ -35,9 +36,9 @@ extern struct sysdev_class *edac_get_eda
 
 /* edac core workqueue: single CPU mode */
 extern struct workqueue_struct *edac_workqueue;
-extern void edac_workq_setup(struct edac_device_ctl_info *edac_dev,
+extern void edac_device_workq_setup(struct edac_device_ctl_info *edac_dev,
 				unsigned msec);
-extern void edac_workq_teardown(struct edac_device_ctl_info *edac_dev);
+extern void edac_device_workq_teardown(struct edac_device_ctl_info *edac_dev);
 extern void edac_device_reset_delay_period(
 			struct edac_device_ctl_info *edac_dev,
 			unsigned long value);
_

Patches currently in -mm which might be from djiang@mvista.com are

origin.patch
