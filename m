From: akpm@linux-foundation.org
Subject: - drivers-edac-fix-workq-reset-deadlock.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:07:28 -0700
Message-ID: <200707192007.l6JK7Scg020266@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57196 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761914AbXGSUQu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:16:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dougthompson@xmission.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     drivers/edac: fix workq reset deadlock
has been removed from the -mm tree.  Its filename was
     drivers-edac-fix-workq-reset-deadlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/edac: fix workq reset deadlock
From: Doug Thompson <dougthompson@xmission.com>

Fix mutex locking deadlock on the device controller linked list.  Was calling
a lock then a function that could call the same lock.  Moved the cancel workq
function to outside the lock

Added some short circuit logic in the workq code

Added comments of description

Code tidying

Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_device.c |   56 ++++++++++++++++++++++-----
 drivers/edac/edac_mc.c     |   72 +++++++++++++++++++++++++----------
 2 files changed, 100 insertions(+), 28 deletions(-)

diff -puN drivers/edac/edac_device.c~drivers-edac-fix-workq-reset-deadlock drivers/edac/edac_device.c
--- a/drivers/edac/edac_device.c~drivers-edac-fix-workq-reset-deadlock
+++ a/drivers/edac/edac_device.c
@@ -32,7 +32,9 @@
 #include "edac_core.h"
 #include "edac_module.h"
 
-/* lock to memory controller's control array 'edac_device_list' */
+/* lock for the list: 'edac_device_list', manipulation of this list
+ * is protected by the 'device_ctls_mutex' lock
+ */
 static DEFINE_MUTEX(device_ctls_mutex);
 static struct list_head edac_device_list = LIST_HEAD_INIT(edac_device_list);
 
@@ -386,6 +388,14 @@ EXPORT_SYMBOL_GPL(edac_device_find);
 /*
  * edac_device_workq_function
  *	performs the operation scheduled by a workq request
+ *
+ *	this workq is embedded within an edac_device_ctl_info
+ *	structure, that needs to be polled for possible error events.
+ *
+ *	This operation is to acquire the list mutex lock
+ *	(thus preventing insertation or deletion)
+ *	and then call the device's poll function IFF this device is
+ *	running polled and there is a poll function defined.
  */
 static void edac_device_workq_function(struct work_struct *work_req)
 {
@@ -403,8 +413,17 @@ static void edac_device_workq_function(s
 
 	mutex_unlock(&device_ctls_mutex);
 
-	/* Reschedule */
-	queue_delayed_work(edac_workqueue, &edac_dev->work, edac_dev->delay);
+	/* Reschedule the workq for the next time period to start again
+	 * if the number of msec is for 1 sec, then adjust to the next
+	 * whole one second to save timers fireing all over the period
+	 * between integral seconds
+	 */
+	if (edac_dev->poll_msec == 1000)
+		queue_delayed_work(edac_workqueue, &edac_dev->work,
+				round_jiffies(edac_dev->delay));
+	else
+		queue_delayed_work(edac_workqueue, &edac_dev->work,
+				edac_dev->delay);
 }
 
 /*
@@ -417,11 +436,26 @@ void edac_device_workq_setup(struct edac
 {
 	debugf0("%s()\n", __func__);
 
+	/* take the arg 'msec' and set it into the control structure
+	 * to used in the time period calculation
+	 * then calc the number of jiffies that represents
+	 */
 	edac_dev->poll_msec = msec;
-	edac_dev->delay = msecs_to_jiffies(msec);	/* Calc delay jiffies */
+	edac_dev->delay = msecs_to_jiffies(msec);
 
 	INIT_DELAYED_WORK(&edac_dev->work, edac_device_workq_function);
-	queue_delayed_work(edac_workqueue, &edac_dev->work, edac_dev->delay);
+
+	/* optimize here for the 1 second case, which will be normal value, to
+	 * fire ON the 1 second time event. This helps reduce all sorts of
+	 * timers firing on sub-second basis, while they are happy
+	 * to fire together on the 1 second exactly
+	 */
+	if (edac_dev->poll_msec == 1000)
+		queue_delayed_work(edac_workqueue, &edac_dev->work,
+				round_jiffies(edac_dev->delay));
+	else
+		queue_delayed_work(edac_workqueue, &edac_dev->work,
+				edac_dev->delay);
 }
 
 /*
@@ -441,16 +475,20 @@ void edac_device_workq_teardown(struct e
 
 /*
  * edac_device_reset_delay_period
+ *
+ *	need to stop any outstanding workq queued up at this time
+ *	because we will be resetting the sleep time.
+ *	Then restart the workq on the new delay
  */
-
 void edac_device_reset_delay_period(struct edac_device_ctl_info *edac_dev,
 					unsigned long value)
 {
-	mutex_lock(&device_ctls_mutex);
-
-	/* cancel the current workq request */
+	/* cancel the current workq request, without the mutex lock */
 	edac_device_workq_teardown(edac_dev);
 
+	/* acquire the mutex before doing the workq setup */
+	mutex_lock(&device_ctls_mutex);
+
 	/* restart the workq request, with new delay value */
 	edac_device_workq_setup(edac_dev, value);
 
diff -puN drivers/edac/edac_mc.c~drivers-edac-fix-workq-reset-deadlock drivers/edac/edac_mc.c
--- a/drivers/edac/edac_mc.c~drivers-edac-fix-workq-reset-deadlock
+++ a/drivers/edac/edac_mc.c
@@ -258,6 +258,12 @@ static void edac_mc_workq_function(struc
 
 	mutex_lock(&mem_ctls_mutex);
 
+	/* if this control struct has movd to offline state, we are done */
+	if (mci->op_state == OP_OFFLINE) {
+		mutex_unlock(&mem_ctls_mutex);
+		return;
+	}
+
 	/* Only poll controllers that are running polled and have a check */
 	if (edac_mc_assert_error_check_and_clear() && (mci->edac_check != NULL))
 		mci->edac_check(mci);
@@ -279,11 +285,19 @@ static void edac_mc_workq_function(struc
  * edac_mc_workq_setup
  *	initialize a workq item for this mci
  *	passing in the new delay period in msec
+ *
+ *	locking model:
+ *
+ *		called with the mem_ctls_mutex held
  */
-void edac_mc_workq_setup(struct mem_ctl_info *mci, unsigned msec)
+static void edac_mc_workq_setup(struct mem_ctl_info *mci, unsigned msec)
 {
 	debugf0("%s()\n", __func__);
 
+	/* if this instance is not in the POLL state, then simply return */
+	if (mci->op_state != OP_RUNNING_POLL)
+		return;
+
 	INIT_DELAYED_WORK(&mci->work, edac_mc_workq_function);
 	queue_delayed_work(edac_workqueue, &mci->work, msecs_to_jiffies(msec));
 }
@@ -291,29 +305,39 @@ void edac_mc_workq_setup(struct mem_ctl_
 /*
  * edac_mc_workq_teardown
  *	stop the workq processing on this mci
+ *
+ *	locking model:
+ *
+ *		called WITHOUT lock held
  */
-void edac_mc_workq_teardown(struct mem_ctl_info *mci)
+static void edac_mc_workq_teardown(struct mem_ctl_info *mci)
 {
 	int status;
 
-	status = cancel_delayed_work(&mci->work);
-	if (status == 0) {
-		/* workq instance might be running, wait for it */
-		flush_workqueue(edac_workqueue);
+	/* if not running POLL, leave now */
+	if (mci->op_state == OP_RUNNING_POLL) {
+		status = cancel_delayed_work(&mci->work);
+		if (status == 0) {
+			debugf0("%s() not canceled, flush the queue\n",
+				__func__);
+
+			/* workq instance might be running, wait for it */
+			flush_workqueue(edac_workqueue);
+		}
 	}
 }
 
 /*
  * edac_reset_delay_period
  */
-
-void edac_reset_delay_period(struct mem_ctl_info *mci, unsigned long value)
+static void edac_reset_delay_period(struct mem_ctl_info *mci, unsigned long value)
 {
-	mutex_lock(&mem_ctls_mutex);
-
 	/* cancel the current workq request */
 	edac_mc_workq_teardown(mci);
 
+	/* lock the list of devices for the new setup */
+	mutex_lock(&mem_ctls_mutex);
+
 	/* restart the workq request, with new delay value */
 	edac_mc_workq_setup(mci, value);
 
@@ -323,6 +347,10 @@ void edac_reset_delay_period(struct mem_
 /* Return 0 on success, 1 on failure.
  * Before calling this function, caller must
  * assign a unique value to mci->mc_idx.
+ *
+ *	locking model:
+ *
+ *		called with the mem_ctls_mutex lock held
  */
 static int add_mc_to_global_list(struct mem_ctl_info *mci)
 {
@@ -331,7 +359,8 @@ static int add_mc_to_global_list(struct 
 
 	insert_before = &mc_devices;
 
-	if (unlikely((p = find_mci_by_dev(mci->dev)) != NULL))
+	p = find_mci_by_dev(mci->dev);
+	if (unlikely(p != NULL))
 		goto fail0;
 
 	list_for_each(item, &mc_devices) {
@@ -467,8 +496,8 @@ int edac_mc_add_mc(struct mem_ctl_info *
 	}
 
 	/* Report action taken */
-	edac_mc_printk(mci, KERN_INFO, "Giving out device to %s %s: DEV %s\n",
-		mci->mod_name, mci->ctl_name, dev_name(mci));
+	edac_mc_printk(mci, KERN_INFO, "Giving out device to '%s' '%s':"
+		" DEV %s\n", mci->mod_name, mci->ctl_name, dev_name(mci));
 
 	mutex_unlock(&mem_ctls_mutex);
 	return 0;
@@ -493,10 +522,13 @@ struct mem_ctl_info *edac_mc_del_mc(stru
 {
 	struct mem_ctl_info *mci;
 
-	debugf0("MC: %s()\n", __func__);
+	debugf0("%s()\n", __func__);
+
 	mutex_lock(&mem_ctls_mutex);
 
-	if ((mci = find_mci_by_dev(dev)) == NULL) {
+	/* find the requested mci struct in the global list */
+	mci = find_mci_by_dev(dev);
+	if (mci == NULL) {
 		mutex_unlock(&mem_ctls_mutex);
 		return NULL;
 	}
@@ -504,15 +536,17 @@ struct mem_ctl_info *edac_mc_del_mc(stru
 	/* marking MCI offline */
 	mci->op_state = OP_OFFLINE;
 
-	/* flush workq processes */
-	edac_mc_workq_teardown(mci);
-
-	edac_remove_sysfs_mci_device(mci);
 	del_mc_from_global_list(mci);
 	mutex_unlock(&mem_ctls_mutex);
+
+	/* flush workq processes and remove sysfs */
+	edac_mc_workq_teardown(mci);
+	edac_remove_sysfs_mci_device(mci);
+
 	edac_printk(KERN_INFO, EDAC_MC,
 		"Removed device %d for %s %s: DEV %s\n", mci->mc_idx,
 		mci->mod_name, mci->ctl_name, dev_name(mci));
+
 	return mci;
 }
 EXPORT_SYMBOL_GPL(edac_mc_del_mc);
_

Patches currently in -mm which might be from dougthompson@xmission.com are

origin.patch
