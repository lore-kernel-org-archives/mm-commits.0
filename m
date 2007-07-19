From: akpm@linux-foundation.org
Subject: - drivers-edac-fix-edac_device-semaphore-to-mutex.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:07:07 -0700
Message-ID: <200707192007.l6JK77Xb020233@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59741 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760907AbXGSUP2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dougthompson@xmission.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     drivers/edac: fix edac_device semaphore to mutex
has been removed from the -mm tree.  Its filename was
     drivers-edac-fix-edac_device-semaphore-to-mutex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/edac: fix edac_device semaphore to mutex
From: Doug Thompson <dougthompson@xmission.com>

A previous patch changed the edac_mc src file from semaphore usage to mutex
This patch changes the edac_device src file as well, from semaphore use to
mutex operation.

Use a mutex primitive for mutex operations, as it does not require a
semaphore

Cc: Alan Cox alan@lxorguk.ukuu.org.uk
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_device.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN drivers/edac/edac_device.c~drivers-edac-fix-edac_device-semaphore-to-mutex drivers/edac/edac_device.c
--- a/drivers/edac/edac_device.c~drivers-edac-fix-edac_device-semaphore-to-mutex
+++ a/drivers/edac/edac_device.c
@@ -33,7 +33,7 @@
 #include "edac_module.h"
 
 /* lock to memory controller's control array 'edac_device_list' */
-static DECLARE_MUTEX(device_ctls_mutex);
+static DEFINE_MUTEX(device_ctls_mutex);
 static struct list_head edac_device_list = LIST_HEAD_INIT(edac_device_list);
 
 #ifdef CONFIG_EDAC_DEBUG
@@ -340,7 +340,7 @@ static void edac_device_workq_function(s
 	struct edac_device_ctl_info *edac_dev = to_edac_device_ctl_work(d_work);
 
 	//debugf0("%s() here and running\n", __func__);
-	down(&device_ctls_mutex);
+	mutex_lock(&device_ctls_mutex);
 
 	/* Only poll controllers that are running polled and have a check */
 	if ((edac_dev->op_state == OP_RUNNING_POLL) &&
@@ -348,7 +348,7 @@ static void edac_device_workq_function(s
 			edac_dev->edac_check(edac_dev);
 	}
 
-	up(&device_ctls_mutex);
+	mutex_unlock(&device_ctls_mutex);
 
 	/* Reschedule */
 	queue_delayed_work(edac_workqueue, &edac_dev->work, edac_dev->delay);
@@ -393,7 +393,7 @@ void edac_device_workq_teardown(struct e
 void edac_device_reset_delay_period(struct edac_device_ctl_info *edac_dev,
 					unsigned long value)
 {
-	down(&device_ctls_mutex);
+	mutex_lock(&device_ctls_mutex);
 
 	/* cancel the current workq request */
 	edac_device_workq_teardown(edac_dev);
@@ -401,7 +401,7 @@ void edac_device_reset_delay_period(stru
 	/* restart the workq request, with new delay value */
 	edac_device_workq_setup(edac_dev, value);
 
-	up(&device_ctls_mutex);
+	mutex_unlock(&device_ctls_mutex);
 }
 
 /**
@@ -425,7 +425,7 @@ int edac_device_add_device(struct edac_d
 	if (edac_debug_level >= 3)
 		edac_device_dump_device(edac_dev);
 #endif
-	down(&device_ctls_mutex);
+	mutex_lock(&device_ctls_mutex);
 
 	if (add_edac_dev_to_global_list(edac_dev))
 		goto fail0;
@@ -463,7 +463,7 @@ int edac_device_add_device(struct edac_d
 				dev_name(edac_dev),
 				edac_op_state_to_string(edac_dev->op_state));
 
-	up(&device_ctls_mutex);
+	mutex_unlock(&device_ctls_mutex);
 	return 0;
 
 fail1:
@@ -471,7 +471,7 @@ fail1:
 	del_edac_device_from_global_list(edac_dev);
 
 fail0:
-	up(&device_ctls_mutex);
+	mutex_unlock(&device_ctls_mutex);
 	return 1;
 }
 EXPORT_SYMBOL_GPL(edac_device_add_device);
@@ -495,12 +495,12 @@ struct edac_device_ctl_info *edac_device
 
 	debugf0("MC: %s()\n", __func__);
 
-	down(&device_ctls_mutex);
+	mutex_lock(&device_ctls_mutex);
 
 	/* Find the structure on the list, if not there, then leave */
 	edac_dev = find_edac_device_by_dev(dev);
 	if (edac_dev == NULL) {
-		up(&device_ctls_mutex);
+		mutex_unlock(&device_ctls_mutex);
 		return NULL;
 	}
 
@@ -516,7 +516,7 @@ struct edac_device_ctl_info *edac_device
 	/* deregister from global list */
 	del_edac_device_from_global_list(edac_dev);
 
-	up(&device_ctls_mutex);
+	mutex_unlock(&device_ctls_mutex);
 
 	edac_printk(KERN_INFO, EDAC_MC,
 		"Removed device %d for %s %s: DEV %s\n",
_

Patches currently in -mm which might be from dougthompson@xmission.com are

origin.patch
