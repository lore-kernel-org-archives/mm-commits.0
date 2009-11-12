From: akpm@linux-foundation.org
Subject: + hpsa-decode-unit-attention-condition-and-retry-commands.patch added to -mm tree
Date: Thu, 12 Nov 2009 14:53:46 -0800
Message-ID: <200911122253.nACMrkER006596@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44940 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754382AbZKLWyb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Nov 2009 17:54:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: scameron@beardog.cce.hp.com, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, mikem@beardog.cce.hp.com


The patch titled
     hpsa: decode unit attention condition and retry commands.
has been added to the -mm tree.  Its filename is
     hpsa-decode-unit-attention-condition-and-retry-commands.patch

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
Subject: hpsa: decode unit attention condition and retry commands.
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>

hpsa: decode unit attention condition and mark commands with DID_SOFT_ERROR
to make the mid-layer retry them.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Signed-off-by: Mike Miller <mikem@beardog.cce.hp.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Mike Miller <mikem@beardog.cce.hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hpsa.c     |   69 +++++++++++++++++++++++++++++++++++++-
 drivers/scsi/hpsa_cmd.h |   23 ++++++++++++
 2 files changed, 91 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/hpsa.c~hpsa-decode-unit-attention-condition-and-retry-commands drivers/scsi/hpsa.c
--- a/drivers/scsi/hpsa.c~hpsa-decode-unit-attention-condition-and-retry-commands
+++ a/drivers/scsi/hpsa.c
@@ -149,6 +149,10 @@ static ssize_t unique_id_show(struct dev
 static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno);
 static ssize_t host_store_rescan(struct device *dev,
 	 struct device_attribute *attr, const char *buf, size_t count);
+static int check_for_unit_attention(struct ctlr_info *h,
+	struct CommandList *c);
+static void check_ioctl_unit_attention(struct ctlr_info *h,
+	struct CommandList *c);
 
 DEVICE_ATTR(raid_level, S_IRUGO, raid_level_show, NULL);
 DEVICE_ATTR(lunid, S_IRUGO, lunid_show, NULL);
@@ -317,6 +321,57 @@ static int scan_thread(__attribute__((un
 	return 0;
 }
 
+static int check_for_unit_attention(struct ctlr_info *h,
+	struct CommandList *c)
+{
+	if (c->err_info->SenseInfo[2] != UNIT_ATTENTION)
+		return 0;
+
+	switch (c->err_info->SenseInfo[12]) {
+	case STATE_CHANGED:
+		dev_warn(&h->pdev->dev, "hpsa%d: a state change "
+			"detected, command retried\n", h->ctlr);
+		break;
+	case LUN_FAILED:
+		dev_warn(&h->pdev->dev, "hpsa%d: LUN failure "
+			"detected, action required\n", h->ctlr);
+		break;
+	case REPORT_LUNS_CHANGED:
+		dev_warn(&h->pdev->dev, "hpsa%d: report LUN data "
+			"changed\n", h->ctlr);
+	/*
+	 * Here, we could call add_to_scan_list and wake up the scan thread,
+	 * except that it's quite likely that we will get more than one
+	 * REPORT_LUNS_CHANGED condition in quick succession, which means
+	 * that those which occur after the first one will likely happen
+	 * *during* the scan_thread's rescan.  And the rescan code is not
+	 * robust enough to restart in the middle, undoing what it has already
+	 * done, and it's not clear that it's even possible to do this, since
+	 * part of what it does is notify the SCSI mid layer, which starts
+	 * doing it's own i/o to read partition tables and so on, and the
+	 * driver doesn't have visibility to know what might need undoing.
+	 * In any event, if possible, it is horribly complicated to get right
+	 * so we just don't do it for now.
+	 *
+	 * Note: this REPORT_LUNS_CHANGED condition only occurs on the MSA2012.
+	 */
+		break;
+	case POWER_OR_RESET:
+		dev_warn(&h->pdev->dev, "hpsa%d: a power on "
+			"or device reset detected\n", h->ctlr);
+		break;
+	case UNIT_ATTENTION_CLEARED:
+		dev_warn(&h->pdev->dev, "hpsa%d: unit attention "
+		    "cleared by another initiator\n", h->ctlr);
+		break;
+	default:
+		dev_warn(&h->pdev->dev, "hpsa%d: unknown "
+			"unit attention detected\n", h->ctlr);
+		break;
+	}
+	return 1;
+}
+
 static ssize_t host_store_rescan(struct device *dev,
 				 struct device_attribute *attr,
 				 const char *buf, size_t count)
@@ -903,7 +958,10 @@ static void complete_scsi_command(struct
 		}
 
 		if (ei->ScsiStatus == SAM_STAT_CHECK_CONDITION) {
-
+			if (check_for_unit_attention(h, cp)) {
+				cmd->result = DID_SOFT_ERROR << 16;
+				break;
+			}
 			if (sense_key == ILLEGAL_REQUEST) {
 				/* If ASC/ASCQ indicate Logical Unit
 				 * Not Supported condition,
@@ -2295,6 +2353,7 @@ static int hpsa_passthru_ioctl(struct ct
 	}
 	hpsa_scsi_do_simple_cmd_core(h, c);
 	hpsa_pci_unmap(h->pdev, c, 1, PCI_DMA_BIDIRECTIONAL);
+	check_ioctl_unit_attention(h, c);
 
 	/* Copy the error information out */
 	memcpy(&iocommand.error_info, c->err_info,
@@ -2423,6 +2482,7 @@ static int hpsa_big_passthru_ioctl(struc
 	}
 	hpsa_scsi_do_simple_cmd_core(h, c);
 	hpsa_pci_unmap(h->pdev, c, sg_used, PCI_DMA_BIDIRECTIONAL);
+	check_ioctl_unit_attention(h, c);
 	/* Copy the error information out */
 	memcpy(&ioc->error_info, c->err_info, sizeof(ioc->error_info));
 	if (copy_to_user(argp, ioc, sizeof(*ioc))) {
@@ -2455,6 +2515,13 @@ cleanup1:
 	return status;
 }
 
+static void check_ioctl_unit_attention(struct ctlr_info *h,
+	struct CommandList *c)
+{
+	if (c->err_info->CommandStatus == CMD_TARGET_STATUS &&
+			c->err_info->ScsiStatus != SAM_STAT_CHECK_CONDITION)
+		(void) check_for_unit_attention(h, c);
+}
 /*
  * ioctl
  */
diff -puN drivers/scsi/hpsa_cmd.h~hpsa-decode-unit-attention-condition-and-retry-commands drivers/scsi/hpsa_cmd.h
--- a/drivers/scsi/hpsa_cmd.h~hpsa-decode-unit-attention-condition-and-retry-commands
+++ a/drivers/scsi/hpsa_cmd.h
@@ -41,6 +41,29 @@
 #define CMD_TIMEOUT             0x000B
 #define CMD_UNABORTABLE		0x000C
 
+/* Unit Attentions ASC's as defined for the MSA2012sa */
+#define POWER_OR_RESET			0x29
+#define STATE_CHANGED			0x2a
+#define UNIT_ATTENTION_CLEARED		0x2f
+#define LUN_FAILED			0x3e
+#define REPORT_LUNS_CHANGED		0x3f
+
+/* Unit Attentions ASCQ's as defined for the MSA2012sa */
+
+	/* These ASCQ's defined for ASC = POWER_OR_RESET */
+#define POWER_ON_RESET			0x00
+#define POWER_ON_REBOOT			0x01
+#define SCSI_BUS_RESET			0x02
+#define MSA_TARGET_RESET		0x03
+#define CONTROLLER_FAILOVER		0x04
+#define TRANSCEIVER_SE			0x05
+#define TRANSCEIVER_LVD			0x06
+
+	/* These ASCQ's defined for ASC = STATE_CHANGED */
+#define RESERVATION_PREEMPTED		0x03
+#define ASYM_ACCESS_CHANGED		0x06
+#define LUN_CAPACITY_CHANGED		0x09
+
 /* transfer direction */
 #define XFER_NONE               0x00
 #define XFER_WRITE              0x01
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

