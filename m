From: akpm@linux-foundation.org
Subject: [merged]
 usb-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch removed from -mm tree
Date: Mon, 16 Feb 2015 12:16:43 -0800
Message-ID: <54e2502b.gZiuwYZfoQWUhaSV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50993 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbbBPURT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:17:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, gregkh@linuxfoundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: usb: use %*pb[l] to print bitmaps including cpumasks and nodemasks
has been removed from the -mm tree.  Its filename was
     usb-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: usb: use %*pb[l] to print bitmaps including cpumasks and nodemasks

printk and friends can now formap bitmaps using '%*pb[l]'.  cpumask
and nodemask also provide cpumask_pr_args() and nodemask_pr_args()
respectively which can be used to generate the two printf arguments
necessary to format the specified cpu/nodemask.

* drivers/uwb/drp.c::uwb_drp_handle_alien_drp() was formatting mas.bm
  into a buffer but never used it.  Removed.

This patch is dependent on the following two patches.

 lib/vsprintf: implement bitmap printing through '%*pb[l]'
 cpumask, nodemask: implement cpumask/nodemask_pr_args()

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/host/whci/debug.c      |    7 ++-----
 drivers/usb/wusbcore/reservation.c |    5 ++---
 drivers/usb/wusbcore/wa-rpipe.c    |    5 ++---
 drivers/usb/wusbcore/wusbhc.c      |    7 ++-----
 drivers/uwb/drp.c                  |    2 --
 drivers/uwb/uwb-debug.c            |   14 ++++----------
 6 files changed, 12 insertions(+), 28 deletions(-)

diff -puN drivers/usb/host/whci/debug.c~usb-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks drivers/usb/host/whci/debug.c
--- a/drivers/usb/host/whci/debug.c~usb-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks
+++ a/drivers/usb/host/whci/debug.c
@@ -86,17 +86,14 @@ static void qset_print(struct seq_file *
 static int di_print(struct seq_file *s, void *p)
 {
 	struct whc *whc = s->private;
-	char buf[72];
 	int d;
 
 	for (d = 0; d < whc->n_devices; d++) {
 		struct di_buf_entry *di = &whc->di_buf[d];
 
-		bitmap_scnprintf(buf, sizeof(buf),
-				 (unsigned long *)di->availability_info, UWB_NUM_MAS);
-
 		seq_printf(s, "DI[%d]\n", d);
-		seq_printf(s, "  availability: %s\n", buf);
+		seq_printf(s, "  availability: %*pb\n",
+			   UWB_NUM_MAS, (unsigned long *)di->availability_info);
 		seq_printf(s, "  %c%c key idx: %d dev addr: %d\n",
 			   (di->addr_sec_info & WHC_DI_SECURE) ? 'S' : ' ',
 			   (di->addr_sec_info & WHC_DI_DISABLE) ? 'D' : ' ',
diff -puN drivers/usb/wusbcore/reservation.c~usb-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks drivers/usb/wusbcore/reservation.c
--- a/drivers/usb/wusbcore/reservation.c~usb-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks
+++ a/drivers/usb/wusbcore/reservation.c
@@ -49,14 +49,13 @@ static void wusbhc_rsv_complete_cb(struc
 	struct wusbhc *wusbhc = rsv->pal_priv;
 	struct device *dev = wusbhc->dev;
 	struct uwb_mas_bm mas;
-	char buf[72];
 
 	dev_dbg(dev, "%s: state = %d\n", __func__, rsv->state);
 	switch (rsv->state) {
 	case UWB_RSV_STATE_O_ESTABLISHED:
 		uwb_rsv_get_usable_mas(rsv, &mas);
-		bitmap_scnprintf(buf, sizeof(buf), mas.bm, UWB_NUM_MAS);
-		dev_dbg(dev, "established reservation: %s\n", buf);
+		dev_dbg(dev, "established reservation: %*pb\n",
+			UWB_NUM_MAS, mas.bm);
 		wusbhc_bwa_set(wusbhc, rsv->stream, &mas);
 		break;
 	case UWB_RSV_STATE_NONE:
diff -puN drivers/usb/wusbcore/wa-rpipe.c~usb-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks drivers/usb/wusbcore/wa-rpipe.c
--- a/drivers/usb/wusbcore/wa-rpipe.c~usb-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks
+++ a/drivers/usb/wusbcore/wa-rpipe.c
@@ -496,10 +496,9 @@ void wa_rpipes_destroy(struct wahc *wa)
 	struct device *dev = &wa->usb_iface->dev;
 
 	if (!bitmap_empty(wa->rpipe_bm, wa->rpipes)) {
-		char buf[256];
 		WARN_ON(1);
-		bitmap_scnprintf(buf, sizeof(buf), wa->rpipe_bm, wa->rpipes);
-		dev_err(dev, "BUG: pipes not released on exit: %s\n", buf);
+		dev_err(dev, "BUG: pipes not released on exit: %*pb\n",
+			wa->rpipes, wa->rpipe_bm);
 	}
 	kfree(wa->rpipe_bm);
 }
diff -puN drivers/usb/wusbcore/wusbhc.c~usb-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks drivers/usb/wusbcore/wusbhc.c
--- a/drivers/usb/wusbcore/wusbhc.c~usb-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks
+++ a/drivers/usb/wusbcore/wusbhc.c
@@ -496,11 +496,8 @@ static void __exit wusbcore_exit(void)
 {
 	clear_bit(0, wusb_cluster_id_table);
 	if (!bitmap_empty(wusb_cluster_id_table, CLUSTER_IDS)) {
-		char buf[256];
-		bitmap_scnprintf(buf, sizeof(buf), wusb_cluster_id_table,
-				 CLUSTER_IDS);
-		printk(KERN_ERR "BUG: WUSB Cluster IDs not released "
-		       "on exit: %s\n", buf);
+		printk(KERN_ERR "BUG: WUSB Cluster IDs not released on exit: %*pb\n",
+		       CLUSTER_IDS, wusb_cluster_id_table);
 		WARN_ON(1);
 	}
 	usb_unregister_notify(&wusb_usb_notifier);
diff -puN drivers/uwb/drp.c~usb-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks drivers/uwb/drp.c
--- a/drivers/uwb/drp.c~usb-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks
+++ a/drivers/uwb/drp.c
@@ -619,11 +619,9 @@ static void uwb_drp_handle_alien_drp(str
 	struct device *dev = &rc->uwb_dev.dev;
 	struct uwb_mas_bm mas;
 	struct uwb_cnflt_alien *cnflt;
-	char buf[72];
 	unsigned long delay_us = UWB_MAS_LENGTH_US * UWB_MAS_PER_ZONE;
 
 	uwb_drp_ie_to_bm(&mas, drp_ie);
-	bitmap_scnprintf(buf, sizeof(buf), mas.bm, UWB_NUM_MAS);
 
 	list_for_each_entry(cnflt, &rc->cnflt_alien_list, rc_node) {
 		if (bitmap_equal(cnflt->mas.bm, mas.bm, UWB_NUM_MAS)) {
diff -puN drivers/uwb/uwb-debug.c~usb-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks drivers/uwb/uwb-debug.c
--- a/drivers/uwb/uwb-debug.c~usb-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks
+++ a/drivers/uwb/uwb-debug.c
@@ -217,7 +217,6 @@ static int reservations_print(struct seq
 		struct uwb_dev_addr devaddr;
 		char owner[UWB_ADDR_STRSIZE], target[UWB_ADDR_STRSIZE];
 		bool is_owner;
-		char buf[72];
 
 		uwb_dev_addr_print(owner, sizeof(owner), &rsv->owner->dev_addr);
 		if (rsv->target.type == UWB_RSV_TARGET_DEV) {
@@ -234,8 +233,7 @@ static int reservations_print(struct seq
 			   owner, target, uwb_rsv_state_str(rsv->state));
 		seq_printf(s, "  stream: %d  type: %s\n",
 			   rsv->stream, uwb_rsv_type_str(rsv->type));
-		bitmap_scnprintf(buf, sizeof(buf), rsv->mas.bm, UWB_NUM_MAS);
-		seq_printf(s, "  %s\n", buf);
+		seq_printf(s, "  %*pb\n", UWB_NUM_MAS, rsv->mas.bm);
 	}
 
 	mutex_unlock(&rc->rsvs_mutex);
@@ -259,14 +257,10 @@ static const struct file_operations rese
 static int drp_avail_print(struct seq_file *s, void *p)
 {
 	struct uwb_rc *rc = s->private;
-	char buf[72];
 
-	bitmap_scnprintf(buf, sizeof(buf), rc->drp_avail.global, UWB_NUM_MAS);
-	seq_printf(s, "global:  %s\n", buf);
-	bitmap_scnprintf(buf, sizeof(buf), rc->drp_avail.local, UWB_NUM_MAS);
-	seq_printf(s, "local:   %s\n", buf);
-	bitmap_scnprintf(buf, sizeof(buf), rc->drp_avail.pending, UWB_NUM_MAS);
-	seq_printf(s, "pending: %s\n", buf);
+	seq_printf(s, "global:  %*pb\n", UWB_NUM_MAS, rc->drp_avail.global);
+	seq_printf(s, "local:   %*pb\n", UWB_NUM_MAS, rc->drp_avail.local);
+	seq_printf(s, "pending: %*pb\n", UWB_NUM_MAS, rc->drp_avail.pending);
 
 	return 0;
 }
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch

