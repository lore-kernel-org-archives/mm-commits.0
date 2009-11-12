From: akpm@linux-foundation.org
Subject: + hpsa-use-shost_priv-instead-of-accessing-host-hostdata-directly.patch added to -mm tree
Date: Thu, 12 Nov 2009 14:53:34 -0800
Message-ID: <200911122253.nACMrYMR006082@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754693AbZKLWyM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Nov 2009 17:54:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: scameron@beardog.cce.hp.com, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, mikem@beardog.cce.hp.com


The patch titled
     hpsa: Use shost_priv instead of accessing host->hostdata[0] directly.
has been added to the -mm tree.  Its filename is
     hpsa-use-shost_priv-instead-of-accessing-host-hostdata-directly.patch

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
Subject: hpsa: Use shost_priv instead of accessing host->hostdata[0] directly.
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>

Use shost_priv instead of accessing host->hostdata[0] directly.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Mike Miller <mikem@beardog.cce.hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hpsa.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff -puN drivers/scsi/hpsa.c~hpsa-use-shost_priv-instead-of-accessing-host-hostdata-directly drivers/scsi/hpsa.c
--- a/drivers/scsi/hpsa.c~hpsa-use-shost_priv-instead-of-accessing-host-hostdata-directly
+++ a/drivers/scsi/hpsa.c
@@ -177,6 +177,12 @@ static struct scsi_host_template hpsa_dr
 	.sdev_attrs = hpsa_sdev_attrs,
 };
 
+static inline struct ctlr_info *sdev_to_hba(struct scsi_device *sdev)
+{
+	unsigned long *priv = shost_priv(sdev->host);
+	return (struct ctlr_info *) *priv;
+}
+
 /* Enqueuing and dequeuing functions for cmdlists. */
 static inline void addQ(struct hlist_head *list, struct CommandList *c)
 {
@@ -227,7 +233,7 @@ static ssize_t raid_level_show(struct de
 	unsigned long flags;
 
 	sdev = to_scsi_device(dev);
-	h = (struct ctlr_info *) sdev->host->hostdata[0];
+	h = sdev_to_hba(sdev);
 	spin_lock_irqsave(&h->lock, flags);
 	hdev = sdev->hostdata;
 	if (!hdev) {
@@ -260,7 +266,7 @@ static ssize_t lunid_show(struct device 
 	unsigned char lunid[8];
 
 	sdev = to_scsi_device(dev);
-	h = (struct ctlr_info *) sdev->host->hostdata[0];
+	h = sdev_to_hba(sdev);
 	spin_lock_irqsave(&h->lock, flags);
 	hdev = sdev->hostdata;
 	if (!hdev) {
@@ -284,7 +290,7 @@ static ssize_t unique_id_show(struct dev
 	unsigned char sn[16];
 
 	sdev = to_scsi_device(dev);
-	h = (struct ctlr_info *) sdev->host->hostdata[0];
+	h = sdev_to_hba(sdev);
 	spin_lock_irqsave(&h->lock, flags);
 	hdev = sdev->hostdata;
 	if (!hdev) {
@@ -677,7 +683,7 @@ static int hpsa_slave_alloc(struct scsi_
 	unsigned long flags;
 	struct ctlr_info *h;
 
-	h = (struct ctlr_info *) sdev->host->hostdata[0];
+	h = sdev_to_hba(sdev);
 	spin_lock_irqsave(&h->devlock, flags);
 	sd = lookup_hpsa_scsi_dev(h, sdev_channel(sdev),
 		sdev_id(sdev), sdev->lun);
@@ -1615,7 +1621,7 @@ static int hpsa_scsi_queue_command(struc
 	unsigned long flags;
 
 	/* Get the ptr to our adapter structure out of cmd->host. */
-	h = (struct ctlr_info *) cmd->device->host->hostdata[0];
+	h = sdev_to_hba(cmd->device);
 	dev = cmd->device->hostdata;
 	if (!dev) {
 		cmd->result = DID_NO_CONNECT << 16;
@@ -1795,7 +1801,7 @@ static int hpsa_eh_device_reset_handler(
 	struct hpsa_scsi_dev_t *dev;
 
 	/* find the controller to which the command to be aborted was sent */
-	h = (struct ctlr_info *) scsicmd->device->host->hostdata[0];
+	h = sdev_to_hba(scsicmd->device);
 	if (h == NULL) /* paranoia */
 		return FAILED;
 	dev_warn(&h->pdev->dev, "resetting drive\n");
@@ -2325,7 +2331,7 @@ static int hpsa_ioctl(struct scsi_device
 	struct ctlr_info *h;
 	void __user *argp = (void __user *)arg;
 
-	h = (struct ctlr_info *) dev->host->hostdata[0];
+	h = sdev_to_hba(dev);
 
 	switch (cmd) {
 	case CCISS_DEREGDISK:
_

Patches currently in -mm which might be from scameron@beardog.cce.hp.com are

scsi-add-hpsa-driver-for-hp-smart-array-controllers.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix-hpsa_allow_any-test-for-vendor-id.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix.patch
hpsa-fix-use-of-unallocated-memory-for-msa2xxx-enclosure-device-data.patch
hpsa-allocate-the-correct-amount-of-extra-space-for-the-scsi-host.patch
hpsa-use-shost_priv-instead-of-accessing-host-hostdata-directly.patch
hpsa-factor-out-command-submission-sequence.patch
hpsa-factor-out-some-pci_unmap-code.patch
add-thread-to-allow-controllers-to-register-for-rescan-for-new-devices.patch
hpsa-allow-device-rescan-to-be-triggered-via-sysfs.patch
hpsa-make-hpsa_sdev_attrs-static.patch
hpsa-decode-unit-attention-condition-and-retry-commands.patch
hpsa-retry-driver-initiated-commands-on-unit-attention.patch
hpsa-flush-cache-with-interrupts-still-enabled.patch
hpsa-remove-sendcmd-in-no-case-are-we-required-to-poll-for-completions.patch
hpsa-make-fill_cmd-return-void.patch
hpsa-fix-typo-that-causes-scsi-status-to-be-lost.patch

