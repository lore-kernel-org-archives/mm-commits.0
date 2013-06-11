From: akpm@linux-foundation.org
Subject: +
 drivers-avoid-format-strings-in-names-passed-to-alloc_workqueue.patch added to -mm tree
Date: Tue, 11 Jun 2013 13:11:54 -0700
Message-ID: <51b7848a.dDSBm2HrX0+DYgOP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42124 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756775Ab3FKULz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jun 2013 16:11:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, keescook@chromium.org

Subject: + drivers-avoid-format-strings-in-names-passed-to-alloc_workqueue.patch added to -mm tree
To: keescook@chromium.org
From: akpm@linux-foundation.org
Date: Tue, 11 Jun 2013 13:11:54 -0700


The patch titled
     Subject: drivers: avoid format strings in names passed to alloc_workqueue()
has been added to the -mm tree.  Its filename is
     drivers-avoid-format-strings-in-names-passed-to-alloc_workqueue.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: drivers: avoid format strings in names passed to alloc_workqueue()

For the workqueue creation interfaces that do not expect format strings,
make sure they cannot accidently be parsed that way.  Additionally, clean
up calls made with a single parameter that would be handled as a format
string.  Many callers are passing potentially dynamic string content, so
use "%s" in those cases to avoid any potential accidents.

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 crypto/pcrypt.c                         |    4 ++--
 drivers/media/pci/cx18/cx18-driver.c    |    2 +-
 drivers/message/i2o/driver.c            |    4 ++--
 drivers/net/wireless/rt2x00/rt2x00dev.c |    2 +-
 drivers/net/wireless/rtlwifi/base.c     |    2 +-
 drivers/pci/hotplug/pciehp_hpc.c        |    4 +---
 drivers/pci/hotplug/shpchp_core.c       |    3 +--
 drivers/scsi/be2iscsi/be_main.c         |    2 +-
 drivers/scsi/qla4xxx/ql4_os.c           |    4 ++--
 drivers/scsi/scsi_transport_fc.c        |    6 +++---
 include/linux/workqueue.h               |    7 ++++---
 net/bluetooth/hci_core.c                |    9 ++++-----
 net/mac80211/main.c                     |    2 +-
 13 files changed, 24 insertions(+), 27 deletions(-)

diff -puN crypto/pcrypt.c~drivers-avoid-format-strings-in-names-passed-to-alloc_workqueue crypto/pcrypt.c
--- a/crypto/pcrypt.c~drivers-avoid-format-strings-in-names-passed-to-alloc_workqueue
+++ a/crypto/pcrypt.c
@@ -455,8 +455,8 @@ static int pcrypt_init_padata(struct pad
 
 	get_online_cpus();
 
-	pcrypt->wq = alloc_workqueue(name,
-				     WQ_MEM_RECLAIM | WQ_CPU_INTENSIVE, 1);
+	pcrypt->wq = alloc_workqueue("%s", WQ_MEM_RECLAIM | WQ_CPU_INTENSIVE,
+				     1, name);
 	if (!pcrypt->wq)
 		goto err;
 
diff -puN drivers/media/pci/cx18/cx18-driver.c~drivers-avoid-format-strings-in-names-passed-to-alloc_workqueue drivers/media/pci/cx18/cx18-driver.c
--- a/drivers/media/pci/cx18/cx18-driver.c~drivers-avoid-format-strings-in-names-passed-to-alloc_workqueue
+++ a/drivers/media/pci/cx18/cx18-driver.c
@@ -695,7 +695,7 @@ static int cx18_create_in_workq(struct c
 {
 	snprintf(cx->in_workq_name, sizeof(cx->in_workq_name), "%s-in",
 		 cx->v4l2_dev.name);
-	cx->in_work_queue = alloc_ordered_workqueue(cx->in_workq_name, 0);
+	cx->in_work_queue = alloc_ordered_workqueue("%s", 0, cx->in_workq_name);
 	if (cx->in_work_queue == NULL) {
 		CX18_ERR("Unable to create incoming mailbox handler thread\n");
 		return -ENOMEM;
diff -puN drivers/message/i2o/driver.c~drivers-avoid-format-strings-in-names-passed-to-alloc_workqueue drivers/message/i2o/driver.c
--- a/drivers/message/i2o/driver.c~drivers-avoid-format-strings-in-names-passed-to-alloc_workqueue
+++ a/drivers/message/i2o/driver.c
@@ -84,8 +84,8 @@ int i2o_driver_register(struct i2o_drive
 	osm_debug("Register driver %s\n", drv->name);
 
 	if (drv->event) {
-		drv->event_queue = alloc_workqueue(drv->name,
-						   WQ_MEM_RECLAIM, 1);
+		drv->event_queue = alloc_workqueue("%s", WQ_MEM_RECLAIM, 1,
+						   drv->name);
 		if (!drv->event_queue) {
 			osm_err("Could not initialize event queue for driver "
 				"%s\n", drv->name);
diff -puN drivers/net/wireless/rt2x00/rt2x00dev.c~drivers-avoid-format-strings-in-names-passed-to-alloc_workqueue drivers/net/wireless/rt2x00/rt2x00dev.c
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c~drivers-avoid-format-strings-in-names-passed-to-alloc_workqueue
+++ a/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1304,7 +1304,7 @@ int rt2x00lib_probe_dev(struct rt2x00_de
 	 * Initialize work.
 	 */
 	rt2x00dev->workqueue =
-	    alloc_ordered_workqueue(wiphy_name(rt2x00dev->hw->wiphy), 0);
+	    alloc_ordered_workqueue("%s", 0, wiphy_name(rt2x00dev->hw->wiphy));
 	if (!rt2x00dev->workqueue) {
 		retval = -ENOMEM;
 		goto exit;
diff -puN drivers/net/wireless/rtlwifi/base.c~drivers-avoid-format-strings-in-names-passed-to-alloc_workqueue drivers/net/wireless/rtlwifi/base.c
--- a/drivers/net/wireless/rtlwifi/base.c~drivers-avoid-format-strings-in-names-passed-to-alloc_workqueue
+++ a/drivers/net/wireless/rtlwifi/base.c
@@ -380,7 +380,7 @@ static void _rtl_init_deferred_work(stru
 
 	/* <2> work queue */
 	rtlpriv->works.hw = hw;
-	rtlpriv->works.rtl_wq = alloc_workqueue(rtlpriv->cfg->name, 0, 0);
+	rtlpriv->works.rtl_wq = alloc_workqueue("%s", 0, 0, rtlpriv->cfg->name);
 	INIT_DELAYED_WORK(&rtlpriv->works.watchdog_wq,
 			  (void *)rtl_watchdog_wq_callback);
 	INIT_DELAYED_WORK(&rtlpriv->works.ips_nic_off_wq,
diff -puN drivers/pci/hotplug/pciehp_hpc.c~drivers-avoid-format-strings-in-names-passed-to-alloc_workqueue drivers/pci/hotplug/pciehp_hpc.c
--- a/drivers/pci/hotplug/pciehp_hpc.c~drivers-avoid-format-strings-in-names-passed-to-alloc_workqueue
+++ a/drivers/pci/hotplug/pciehp_hpc.c
@@ -773,14 +773,12 @@ static void pcie_shutdown_notification(s
 static int pcie_init_slot(struct controller *ctrl)
 {
 	struct slot *slot;
-	char name[32];
 
 	slot = kzalloc(sizeof(*slot), GFP_KERNEL);
 	if (!slot)
 		return -ENOMEM;
 
-	snprintf(name, sizeof(name), "pciehp-%u", PSN(ctrl));
-	slot->wq = alloc_workqueue(name, 0, 0);
+	slot->wq = alloc_workqueue("pciehp-%u", 0, 0, PSN(ctrl));
 	if (!slot->wq)
 		goto abort;
 
diff -puN drivers/pci/hotplug/shpchp_core.c~drivers-avoid-format-strings-in-names-passed-to-alloc_workqueue drivers/pci/hotplug/shpchp_core.c
--- a/drivers/pci/hotplug/shpchp_core.c~drivers-avoid-format-strings-in-names-passed-to-alloc_workqueue
+++ a/drivers/pci/hotplug/shpchp_core.c
@@ -128,8 +128,7 @@ static int init_slots(struct controller
 		slot->hpc_ops = ctrl->hpc_ops;
 		slot->number = ctrl->first_slot + (ctrl->slot_num_inc * i);
 
-		snprintf(name, sizeof(name), "shpchp-%d", slot->number);
-		slot->wq = alloc_workqueue(name, 0, 0);
+		slot->wq = alloc_workqueue("shpchp-%d", 0, 0, slot->number);
 		if (!slot->wq) {
 			retval = -ENOMEM;
 			goto error_info;
diff -puN drivers/scsi/be2iscsi/be_main.c~drivers-avoid-format-strings-in-names-passed-to-alloc_workqueue drivers/scsi/be2iscsi/be_main.c
--- a/drivers/scsi/be2iscsi/be_main.c~drivers-avoid-format-strings-in-names-passed-to-alloc_workqueue
+++ a/drivers/scsi/be2iscsi/be_main.c
@@ -4996,7 +4996,7 @@ static int beiscsi_dev_probe(struct pci_
 
 	snprintf(phba->wq_name, sizeof(phba->wq_name), "beiscsi_%02x_wq",
 		 phba->shost->host_no);
-	phba->wq = alloc_workqueue(phba->wq_name, WQ_MEM_RECLAIM, 1);
+	phba->wq = alloc_workqueue("%s", WQ_MEM_RECLAIM, 1, phba->wq_name);
 	if (!phba->wq) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
 			    "BM_%d : beiscsi_dev_probe-"
diff -puN drivers/scsi/qla4xxx/ql4_os.c~drivers-avoid-format-strings-in-names-passed-to-alloc_workqueue drivers/scsi/qla4xxx/ql4_os.c
--- a/drivers/scsi/qla4xxx/ql4_os.c~drivers-avoid-format-strings-in-names-passed-to-alloc_workqueue
+++ a/drivers/scsi/qla4xxx/ql4_os.c
@@ -7060,8 +7060,8 @@ skip_retry_init:
 	}
 	INIT_WORK(&ha->dpc_work, qla4xxx_do_dpc);
 
-	sprintf(buf, "qla4xxx_%lu_task", ha->host_no);
-	ha->task_wq = alloc_workqueue(buf, WQ_MEM_RECLAIM, 1);
+	ha->task_wq = alloc_workqueue("qla4xxx_%lu_task", WQ_MEM_RECLAIM, 1,
+				      ha->host_no);
 	if (!ha->task_wq) {
 		ql4_printk(KERN_WARNING, ha, "Unable to start task thread!\n");
 		ret = -ENODEV;
diff -puN drivers/scsi/scsi_transport_fc.c~drivers-avoid-format-strings-in-names-passed-to-alloc_workqueue drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c~drivers-avoid-format-strings-in-names-passed-to-alloc_workqueue
+++ a/drivers/scsi/scsi_transport_fc.c
@@ -435,7 +435,7 @@ static int fc_host_setup(struct transpor
 
 	snprintf(fc_host->work_q_name, sizeof(fc_host->work_q_name),
 		 "fc_wq_%d", shost->host_no);
-	fc_host->work_q = alloc_workqueue(fc_host->work_q_name, 0, 0);
+	fc_host->work_q = alloc_workqueue("%s", 0, 0, fc_host->work_q_name);
 	if (!fc_host->work_q)
 		return -ENOMEM;
 
@@ -443,8 +443,8 @@ static int fc_host_setup(struct transpor
 	snprintf(fc_host->devloss_work_q_name,
 		 sizeof(fc_host->devloss_work_q_name),
 		 "fc_dl_%d", shost->host_no);
-	fc_host->devloss_work_q =
-			alloc_workqueue(fc_host->devloss_work_q_name, 0, 0);
+	fc_host->devloss_work_q = alloc_workqueue("%s", 0, 0,
+					fc_host->devloss_work_q_name);
 	if (!fc_host->devloss_work_q) {
 		destroy_workqueue(fc_host->work_q);
 		fc_host->work_q = NULL;
diff -puN include/linux/workqueue.h~drivers-avoid-format-strings-in-names-passed-to-alloc_workqueue include/linux/workqueue.h
--- a/include/linux/workqueue.h~drivers-avoid-format-strings-in-names-passed-to-alloc_workqueue
+++ a/include/linux/workqueue.h
@@ -445,11 +445,12 @@ __alloc_workqueue_key(const char *fmt, u
 	alloc_workqueue(fmt, WQ_UNBOUND | __WQ_ORDERED | (flags), 1, ##args)
 
 #define create_workqueue(name)						\
-	alloc_workqueue((name), WQ_MEM_RECLAIM, 1)
+	alloc_workqueue("%s", WQ_MEM_RECLAIM, 1, (name))
 #define create_freezable_workqueue(name)				\
-	alloc_workqueue((name), WQ_FREEZABLE | WQ_UNBOUND | WQ_MEM_RECLAIM, 1)
+	alloc_workqueue("%s", WQ_FREEZABLE | WQ_UNBOUND | WQ_MEM_RECLAIM, \
+			1, (name))
 #define create_singlethread_workqueue(name)				\
-	alloc_workqueue((name), WQ_UNBOUND | WQ_MEM_RECLAIM, 1)
+	alloc_workqueue("%s", WQ_UNBOUND | WQ_MEM_RECLAIM, 1, (name))
 
 extern void destroy_workqueue(struct workqueue_struct *wq);
 
diff -puN net/bluetooth/hci_core.c~drivers-avoid-format-strings-in-names-passed-to-alloc_workqueue net/bluetooth/hci_core.c
--- a/net/bluetooth/hci_core.c~drivers-avoid-format-strings-in-names-passed-to-alloc_workqueue
+++ a/net/bluetooth/hci_core.c
@@ -2156,16 +2156,15 @@ int hci_register_dev(struct hci_dev *hde
 	list_add(&hdev->list, &hci_dev_list);
 	write_unlock(&hci_dev_list_lock);
 
-	hdev->workqueue = alloc_workqueue(hdev->name, WQ_HIGHPRI | WQ_UNBOUND |
-					  WQ_MEM_RECLAIM, 1);
+	hdev->workqueue = alloc_workqueue("%s", WQ_HIGHPRI | WQ_UNBOUND |
+					  WQ_MEM_RECLAIM, 1, hdev->name);
 	if (!hdev->workqueue) {
 		error = -ENOMEM;
 		goto err;
 	}
 
-	hdev->req_workqueue = alloc_workqueue(hdev->name,
-					      WQ_HIGHPRI | WQ_UNBOUND |
-					      WQ_MEM_RECLAIM, 1);
+	hdev->req_workqueue = alloc_workqueue("%s", WQ_HIGHPRI | WQ_UNBOUND |
+					      WQ_MEM_RECLAIM, 1, hdev->name);
 	if (!hdev->req_workqueue) {
 		destroy_workqueue(hdev->workqueue);
 		error = -ENOMEM;
diff -puN net/mac80211/main.c~drivers-avoid-format-strings-in-names-passed-to-alloc_workqueue net/mac80211/main.c
--- a/net/mac80211/main.c~drivers-avoid-format-strings-in-names-passed-to-alloc_workqueue
+++ a/net/mac80211/main.c
@@ -921,7 +921,7 @@ int ieee80211_register_hw(struct ieee802
 		hw->queues = IEEE80211_MAX_QUEUES;
 
 	local->workqueue =
-		alloc_ordered_workqueue(wiphy_name(local->hw.wiphy), 0);
+		alloc_ordered_workqueue("%s", 0, wiphy_name(local->hw.wiphy));
 	if (!local->workqueue) {
 		result = -ENOMEM;
 		goto fail_workqueue;
_

Patches currently in -mm which might be from keescook@chromium.org are

linux-next.patch
kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg.patch
kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg-fix.patch
drivers-mtd-chips-gen_probec-refactor-call-to-request_module.patch
clean-up-scary-strncpydst-src-strlensrc-uses.patch
clean-up-scary-strncpydst-src-strlensrc-uses-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
documentation-accounting-getdelaysc-avoid-strncpy-in-accounting-tool.patch
documentation-accounting-getdelaysc-avoid-strncpy-in-accounting-tool-fix.patch
block-do-not-pass-disk-names-as-format-strings.patch
crypto-sanitize-argument-for-format-string.patch
drivers-avoid-format-string-in-dev_set_name.patch
drivers-avoid-format-strings-in-names-passed-to-alloc_workqueue.patch
drivers-avoid-parsing-names-as-kthread_run-format-strings.patch
isdn-clean-up-debug-format-string-usage.patch

