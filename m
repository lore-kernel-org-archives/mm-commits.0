From: akpm@linux-foundation.org
Subject: - drivers-edac-fix-reset-edac_mc-pollmsec.patch removed from -mm tree
Date: Sat, 28 Jul 2007 23:12:16 -0700
Message-ID: <200707290612.l6T6CGgA011112@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45330 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758128AbXG2GXo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:23:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dougthompson@xmission.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     drivers/edac: fix reset edac_mc pollmsec
has been removed from the -mm tree.  Its filename was
     drivers-edac-fix-reset-edac_mc-pollmsec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/edac: fix reset edac_mc pollmsec
From: Doug Thompson <dougthompson@xmission.com>

This fixes a deadlock that could occur on a 'setup' and 'teardown' sequence of
the workq for a edac_mc control structure instance.  A similiar fix was
previously implemented for the edac_device code.

In addition, the edac_mc device code there was missing code to allow the workq
period valu to be altered via sysfs control.

This patch adds that fix on the code, and allows for the changing of the
period value as well.

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_mc.c       |   64 +++++++++++++++++++++------------
 drivers/edac/edac_mc_sysfs.c |   19 +++++++++
 drivers/edac/edac_module.h   |    2 +
 3 files changed, 62 insertions(+), 23 deletions(-)

diff -puN drivers/edac/edac_mc.c~drivers-edac-fix-reset-edac_mc-pollmsec drivers/edac/edac_mc.c
--- a/drivers/edac/edac_mc.c~drivers-edac-fix-reset-edac_mc-pollmsec
+++ a/drivers/edac/edac_mc.c
@@ -214,6 +214,13 @@ void edac_mc_free(struct mem_ctl_info *m
 }
 EXPORT_SYMBOL_GPL(edac_mc_free);
 
+
+/*
+ * find_mci_by_dev
+ *
+ *	scan list of controllers looking for the one that manages
+ *	the 'dev' device
+ */
 static struct mem_ctl_info *find_mci_by_dev(struct device *dev)
 {
 	struct mem_ctl_info *mci;
@@ -268,12 +275,6 @@ static void edac_mc_workq_function(struc
 	if (edac_mc_assert_error_check_and_clear() && (mci->edac_check != NULL))
 		mci->edac_check(mci);
 
-	/*
-	 * FIXME: temp place holder for PCI checks,
-	 * goes away when we break out PCI
-	 */
-	edac_pci_do_parity_check();
-
 	mutex_unlock(&mem_ctls_mutex);
 
 	/* Reschedule */
@@ -314,36 +315,55 @@ static void edac_mc_workq_teardown(struc
 {
 	int status;
 
-	/* if not running POLL, leave now */
-	if (mci->op_state == OP_RUNNING_POLL) {
-		status = cancel_delayed_work(&mci->work);
-		if (status == 0) {
-			debugf0("%s() not canceled, flush the queue\n",
-				__func__);
+	status = cancel_delayed_work(&mci->work);
+	if (status == 0) {
+		debugf0("%s() not canceled, flush the queue\n",
+			__func__);
 
-			/* workq instance might be running, wait for it */
-			flush_workqueue(edac_workqueue);
-		}
+		/* workq instance might be running, wait for it */
+		flush_workqueue(edac_workqueue);
 	}
 }
 
 /*
- * edac_reset_delay_period
+ * edac_mc_reset_delay_period(unsigned long value)
+ *
+ *	user space has updated our poll period value, need to
+ *	reset our workq delays
  */
-static void edac_reset_delay_period(struct mem_ctl_info *mci, unsigned long value)
+void edac_mc_reset_delay_period(int value)
 {
-	/* cancel the current workq request */
-	edac_mc_workq_teardown(mci);
+	struct mem_ctl_info *mci;
+	struct list_head *item;
+
+	mutex_lock(&mem_ctls_mutex);
+
+	/* scan the list and turn off all workq timers, doing so under lock
+	 */
+	list_for_each(item, &mc_devices) {
+		mci = list_entry(item, struct mem_ctl_info, link);
+
+		if (mci->op_state == OP_RUNNING_POLL)
+			cancel_delayed_work(&mci->work);
+	}
+
+	mutex_unlock(&mem_ctls_mutex);
 
-	/* lock the list of devices for the new setup */
+
+	/* re-walk the list, and reset the poll delay */
 	mutex_lock(&mem_ctls_mutex);
 
-	/* restart the workq request, with new delay value */
-	edac_mc_workq_setup(mci, value);
+	list_for_each(item, &mc_devices) {
+		mci = list_entry(item, struct mem_ctl_info, link);
+
+		edac_mc_workq_setup(mci, (unsigned long) value);
+	}
 
 	mutex_unlock(&mem_ctls_mutex);
 }
 
+
+
 /* Return 0 on success, 1 on failure.
  * Before calling this function, caller must
  * assign a unique value to mci->mc_idx.
diff -puN drivers/edac/edac_mc_sysfs.c~drivers-edac-fix-reset-edac_mc-pollmsec drivers/edac/edac_mc_sysfs.c
--- a/drivers/edac/edac_mc_sysfs.c~drivers-edac-fix-reset-edac_mc-pollmsec
+++ a/drivers/edac/edac_mc_sysfs.c
@@ -122,6 +122,23 @@ static ssize_t memctrl_int_store(void *p
 	return count;
 }
 
+/*
+ * mc poll_msec time value
+ */
+static ssize_t poll_msec_int_store(void *ptr, const char *buffer, size_t count)
+{
+	int *value = (int *)ptr;
+
+	if (isdigit(*buffer)) {
+		*value = simple_strtoul(buffer, NULL, 0);
+
+		/* notify edac_mc engine to reset the poll period */
+		edac_mc_reset_delay_period(*value);
+	}
+
+	return count;
+}
+
 
 /* EDAC sysfs CSROW data structures and methods
  */
@@ -704,7 +721,7 @@ MEMCTRL_ATTR(edac_mc_log_ce,
 	S_IRUGO | S_IWUSR, memctrl_int_show, memctrl_int_store);
 
 MEMCTRL_ATTR(edac_mc_poll_msec,
-	S_IRUGO | S_IWUSR, memctrl_int_show, memctrl_int_store);
+	S_IRUGO | S_IWUSR, memctrl_int_show, poll_msec_int_store);
 
 /* Base Attributes of the memory ECC object */
 static struct memctrl_dev_attribute *memctrl_attr[] = {
diff -puN drivers/edac/edac_module.h~drivers-edac-fix-reset-edac_mc-pollmsec drivers/edac/edac_module.h
--- a/drivers/edac/edac_module.h~drivers-edac-fix-reset-edac_mc-pollmsec
+++ a/drivers/edac/edac_module.h
@@ -52,6 +52,8 @@ extern void edac_device_workq_setup(stru
 extern void edac_device_workq_teardown(struct edac_device_ctl_info *edac_dev);
 extern void edac_device_reset_delay_period(struct edac_device_ctl_info
 					   *edac_dev, unsigned long value);
+extern void edac_mc_reset_delay_period(int value);
+
 extern void *edac_align_ptr(void *ptr, unsigned size);
 
 /*
_

Patches currently in -mm which might be from dougthompson@xmission.com are

origin.patch
