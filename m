From: akpm@linux-foundation.org
Subject: + drivers-edac-cleanup-workq-ifdefs.patch added to -mm tree
Date: Tue, 05 Jun 2007 18:51:13 -0700
Message-ID: <200706060151.l561pDO2007485@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45997 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934491AbXFFB41 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2007 21:56:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dougthompson@xmission.com


The patch titled
     drivers-edac: cleanup workq ifdefs
has been added to the -mm tree.  Its filename is
     drivers-edac-cleanup-workq-ifdefs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers-edac: cleanup workq ifdefs
From: Douglas Thompson <dougthompson@xmission.com>

The origin of this code comes from patches at sourceforge, that
allow EDAC to be updated to various kernels. With kernel version 2.6.20 a
new workq system was installed, thus the patches needed to be modified
based on the kernel version. For submitting to the latest kernel.org
those #ifdefs are removed

Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_core.h   |   13 +------------
 drivers/edac/edac_device.c |   11 -----------
 drivers/edac/edac_mc.c     |   10 ----------
 drivers/edac/edac_pci.c    |   10 ----------
 4 files changed, 1 insertion(+), 43 deletions(-)

diff -puN drivers/edac/edac_core.h~drivers-edac-cleanup-workq-ifdefs drivers/edac/edac_core.h
--- a/drivers/edac/edac_core.h~drivers-edac-cleanup-workq-ifdefs
+++ a/drivers/edac/edac_core.h
@@ -395,11 +395,8 @@ struct mem_ctl_info {
 	struct completion kobj_complete;
 
 	/* work struct for this MC */
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
 	struct delayed_work work;
-#else
-	struct work_struct work;
-#endif
+
 	/* the internal state of this controller instance */
 	int op_state;
 };
@@ -530,11 +527,7 @@ struct edac_device_ctl_info {
 	/* the internal state of this controller instance */
 	int op_state;
 	/* work struct for this instance */
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
 	struct delayed_work work;
-#else
-	struct work_struct work;
-#endif
 
 	/* pointer to edac polling checking routine:
 	 *      If NOT NULL: points to polling check routine
@@ -647,11 +640,7 @@ struct edac_pci_ctl_info {
 	/* the internal state of this controller instance */
 	int op_state;
 	/* work struct for this instance */
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
 	struct delayed_work work;
-#else
-	struct work_struct work;
-#endif
 
 	/* pointer to edac polling checking routine:
 	 *      If NOT NULL: points to polling check routine
diff -puN drivers/edac/edac_device.c~drivers-edac-cleanup-workq-ifdefs drivers/edac/edac_device.c
--- a/drivers/edac/edac_device.c~drivers-edac-cleanup-workq-ifdefs
+++ a/drivers/edac/edac_device.c
@@ -332,17 +332,10 @@ EXPORT_SYMBOL(edac_device_find);
  * edac_device_workq_function
  *	performs the operation scheduled by a workq request
  */
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
 static void edac_device_workq_function(struct work_struct *work_req)
 {
 	struct delayed_work *d_work = (struct delayed_work *)work_req;
 	struct edac_device_ctl_info *edac_dev = to_edac_device_ctl_work(d_work);
-#else
-static void edac_device_workq_function(void *ptr)
-{
-	struct edac_device_ctl_info *edac_dev =
-	    (struct edac_device_ctl_info *)ptr;
-#endif
 
 	//debugf0("%s() here and running\n", __func__);
 	lock_device_list();
@@ -372,11 +365,7 @@ void edac_device_workq_setup(struct edac
 	edac_dev->poll_msec = msec;
 	edac_calc_delay(edac_dev);	/* Calc delay jiffies */
 
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
 	INIT_DELAYED_WORK(&edac_dev->work, edac_device_workq_function);
-#else
-	INIT_WORK(&edac_dev->work, edac_device_workq_function, edac_dev);
-#endif
 	queue_delayed_work(edac_workqueue, &edac_dev->work, edac_dev->delay);
 }
 
diff -puN drivers/edac/edac_mc.c~drivers-edac-cleanup-workq-ifdefs drivers/edac/edac_mc.c
--- a/drivers/edac/edac_mc.c~drivers-edac-cleanup-workq-ifdefs
+++ a/drivers/edac/edac_mc.c
@@ -235,16 +235,10 @@ static int edac_mc_assert_error_check_an
  * edac_mc_workq_function
  *	performs the operation scheduled by a workq request
  */
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
 static void edac_mc_workq_function(struct work_struct *work_req)
 {
 	struct delayed_work *d_work = (struct delayed_work *)work_req;
 	struct mem_ctl_info *mci = to_edac_mem_ctl_work(d_work);
-#else
-static void edac_mc_workq_function(void *ptr)
-{
-	struct mem_ctl_info *mci = (struct mem_ctl_info *)ptr;
-#endif
 
 	mutex_lock(&mem_ctls_mutex);
 
@@ -274,11 +268,7 @@ void edac_mc_workq_setup(struct mem_ctl_
 {
 	debugf0("%s()\n", __func__);
 
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
 	INIT_DELAYED_WORK(&mci->work, edac_mc_workq_function);
-#else
-	INIT_WORK(&mci->work, edac_mc_workq_function, mci);
-#endif
 	queue_delayed_work(edac_workqueue, &mci->work, msecs_to_jiffies(msec));
 }
 
diff -puN drivers/edac/edac_pci.c~drivers-edac-cleanup-workq-ifdefs drivers/edac/edac_pci.c
--- a/drivers/edac/edac_pci.c~drivers-edac-cleanup-workq-ifdefs
+++ a/drivers/edac/edac_pci.c
@@ -214,16 +214,10 @@ EXPORT_SYMBOL_GPL(edac_pci_find);
  * edac_pci_workq_function()
  * 	performs the operation scheduled by a workq request
  */
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
 static void edac_pci_workq_function(struct work_struct *work_req)
 {
 	struct delayed_work *d_work = (struct delayed_work *)work_req;
 	struct edac_pci_ctl_info *pci = to_edac_pci_ctl_work(d_work);
-#else
-static void edac_pci_workq_function(void *ptr)
-{
-	struct edac_pci_ctl_info *pci = ptr;
-#endif
 
 	edac_lock_pci_list();
 
@@ -248,11 +242,7 @@ static void edac_pci_workq_setup(struct 
 {
 	debugf0("%s()\n", __func__);
 
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
 	INIT_DELAYED_WORK(&pci->work, edac_pci_workq_function);
-#else
-	INIT_WORK(&pci->work, edac_pci_workq_function, pci);
-#endif
 	queue_delayed_work(edac_workqueue, &pci->work,
 			   msecs_to_jiffies(edac_pci_get_poll_msec()));
 }
_

Patches currently in -mm which might be from dougthompson@xmission.com are

drivers-edac-remove-depends-on-x86.patch
drivers-edac-add-edac_mc_find-api.patch
drivers-edac-add-rddr2-memory-types.patch
drivers-edac-split-out-functions-to-unique-files.patch
drivers-edac-add-edac_device-class.patch
drivers-edac-mc-sysfs-add-missing-mem-types.patch
drivers-edac-change-from-semaphore-to-mutex-operation.patch
drivers-edac-coreh-fix-scrubdefs.patch
drivers-edac-new-i82443bxgz-mc-driver.patch
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
