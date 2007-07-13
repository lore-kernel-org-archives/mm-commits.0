From: akpm@linux-foundation.org
Subject: + drivers-edac-fix-edac_device-semaphore-to-mutex.patch added to -mm tree
Date: Fri, 13 Jul 2007 11:30:36 -0700
Message-ID: <200707131830.l6DIUaII011023@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52945 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756492AbXGMSbN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 14:31:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dougthompson@xmission.com, greg@kroah.com


The patch titled
     drivers edac: fix edac_device semaphore to mutex
has been added to the -mm tree.  Its filename is
     drivers-edac-fix-edac_device-semaphore-to-mutex.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers edac: fix edac_device semaphore to mutex
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
 1 files changed, 11 insertions(+), 11 deletions(-)

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

drivers-edac-add-edac_mc_find-api.patch
drivers-edac-add-rddr2-memory-types.patch
drivers-edac-split-out-functions-to-unique-files.patch
drivers-edac-add-edac_device-class.patch
drivers-edac-mc-sysfs-add-missing-mem-types.patch
drivers-edac-change-from-semaphore-to-mutex-operation.patch
drivers-edac-coreh-fix-scrubdefs.patch
drivers-edac-new-i82443bxgz-mc-driver.patch
drivers-edac-new-i82443bxgz-mc-driver-broken.patch
drivers-edac-add-new-nmi-rescan.patch
drivers-edac-mod-use-edac_coreh.patch
drivers-edac-add-dev_name-getter-function.patch
drivers-edac-new-inte-30x0-mc-driver.patch
drivers-edac-mod-mc-to-use-workq-instead-of-kthread.patch
drivers-edac-updated-pci-monitoring.patch
drivers-edac-mod-assert_error-check.patch
drivers-edac-core-lindent-cleanup.patch
drivers-edac-edac_device-sysfs-cleanup.patch
drivers-edac-cleanup-workq-ifdefs.patch
drivers-edac-lindent-amd76x.patch
drivers-edac-lindent-i5000.patch
drivers-edac-lindent-e7xxx.patch
drivers-edac-lindent-i3000.patch
drivers-edac-lindent-i82860.patch
drivers-edac-lindent-i82875p.patch
drivers-edac-lindent-e752x.patch
drivers-edac-lindent-i82443bxgx.patch
drivers-edac-lindent-r82600.patch
drivers-edac-drivers-to-use-new-pci-operation.patch
drivers-edac-add-device-sysfs-attributes.patch
drivers-edac-device-output-clenaup.patch
drivers-edac-add-info-kconfig.patch
drivers-edac-update-maintainers-files-for-edac.patch
drivers-edac-cleanup-spaces-gotos-after-lindent-messup.patch
driver-edac-add-mips-and-ppc-visibility.patch
driver-edac-mod-race-fix-i82875p.patch
driver-edac-fix-ignored-return-i82875p.patch
include-linux-pci_id-h-add-amd-northbridge-defines.patch
driver-edac-i5000-define-typo.patch
driver-edac-remove-null-from-statics.patch
driver-edac-i5000-code-tidying.patch
driver-edac-edac_device-code-tidying.patch
driver-edac-mod-edac_align_ptr-function.patch
driver-edac-mod-edac_opt_state_to_string-function.patch
driver-edac-remove-file-edac_mc-h.patch
drivers-edac-fix-edac_device-semaphore-to-mutex.patch
drivers-edac-fix-e752x-reversed-csrows.patch
drivers-edac-new-pasemi-driver.patch
drivers-edac-fix-leaf-sysfs-attribute.patch
drivers-edac-fix-edac_mc-init-apis.patch
drivers-edac-fix-edac_device-init-apis.patch
drivers-edac-fix-edac_mc-sysfs-completion-code.patch
drivers-edac-fix-edac_device-sysfs-completion-code.patch
