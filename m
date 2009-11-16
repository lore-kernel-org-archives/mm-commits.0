From: akpm@linux-foundation.org
Subject: [folded] hpsa-allow-device-rescan-to-be-triggered-via-sysfs.patch removed from -mm tree
Date: Mon, 16 Nov 2009 13:28:27 -0800
Message-ID: <200911162128.nAGLSR5L001015@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41158 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754116AbZKPV2d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Nov 2009 16:28:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: scameron@beardog.cce.hp.com, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, mikem@beardog.cce.hp.com, mm-commits@vger.kernel.org


The patch titled
     hpsa:  Allow device rescan to be triggered via sysfs.
has been removed from the -mm tree.  Its filename was
     hpsa-allow-device-rescan-to-be-triggered-via-sysfs.patch

This patch was dropped because it was folded into scsi-add-hpsa-driver-for-hp-smart-array-controllers.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hpsa:  Allow device rescan to be triggered via sysfs.
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>

Allow device rescan to be triggered via sysfs.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Mike Miller <mikem@beardog.cce.hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hpsa.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff -puN drivers/scsi/hpsa.c~hpsa-allow-device-rescan-to-be-triggered-via-sysfs drivers/scsi/hpsa.c
--- a/drivers/scsi/hpsa.c~hpsa-allow-device-rescan-to-be-triggered-via-sysfs
+++ a/drivers/scsi/hpsa.c
@@ -147,10 +147,13 @@ static ssize_t lunid_show(struct device 
 static ssize_t unique_id_show(struct device *dev,
 	struct device_attribute *attr, char *buf);
 static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno);
+static ssize_t host_store_rescan(struct device *dev,
+	 struct device_attribute *attr, const char *buf, size_t count);
 
 DEVICE_ATTR(raid_level, S_IRUGO, raid_level_show, NULL);
 DEVICE_ATTR(lunid, S_IRUGO, lunid_show, NULL);
 DEVICE_ATTR(unique_id, S_IRUGO, unique_id_show, NULL);
+DEVICE_ATTR(rescan, S_IWUSR, NULL, host_store_rescan);
 
 struct device_attribute *hpsa_sdev_attrs[] = {
 	&dev_attr_raid_level,
@@ -159,6 +162,11 @@ struct device_attribute *hpsa_sdev_attrs
 	NULL,
 };
 
+static struct device_attribute *hpsa_shost_attrs[] = {
+	&dev_attr_rescan,
+	NULL,
+};
+
 static struct scsi_host_template hpsa_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= "hpsa",
@@ -177,6 +185,7 @@ static struct scsi_host_template hpsa_dr
 	.compat_ioctl		= hpsa_compat_ioctl,
 #endif
 	.sdev_attrs = hpsa_sdev_attrs,
+	.shost_attrs = hpsa_shost_attrs,
 };
 
 static inline struct ctlr_info *sdev_to_hba(struct scsi_device *sdev)
@@ -308,6 +317,21 @@ static int scan_thread(__attribute__((un
 	return 0;
 }
 
+static ssize_t host_store_rescan(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf, size_t count)
+{
+	struct ctlr_info *h;
+	struct Scsi_Host *shost = class_to_shost(dev);
+	unsigned long *priv = shost_priv(shost);
+	h = (struct ctlr_info *) *priv;
+	if (add_to_scan_list(h)) {
+		wake_up_process(hpsa_scan_thread);
+		wait_for_completion_interruptible(&h->scan_wait);
+	}
+	return count;
+}
+
 /* Enqueuing and dequeuing functions for cmdlists. */
 static inline void addQ(struct hlist_head *list, struct CommandList *c)
 {
_

Patches currently in -mm which might be from scameron@beardog.cce.hp.com are

linux-next.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers.patch
hpsa-allow-device-rescan-to-be-triggered-via-sysfs.patch
hpsa-make-hpsa_sdev_attrs-static.patch
hpsa-decode-unit-attention-condition-and-retry-commands.patch
hpsa-retry-driver-initiated-commands-on-unit-attention.patch
hpsa-flush-cache-with-interrupts-still-enabled.patch
hpsa-remove-sendcmd-in-no-case-are-we-required-to-poll-for-completions.patch
hpsa-make-fill_cmd-return-void.patch
hpsa-fix-typo-that-causes-scsi-status-to-be-lost.patch
hpsa-make-device-attrs-static.patch

