From: akpm@linux-foundation.org
Subject: [folded] hpsa-fix-use-of-unallocated-memory-for-msa2xxx-enclosure-device-data.patch removed from -mm tree
Date: Mon, 16 Nov 2009 13:28:09 -0800
Message-ID: <200911162128.nAGLS9fv032684@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59018 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753854AbZKPV2P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Nov 2009 16:28:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: scameron@beardog.cce.hp.com, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, mikem@beardog.cce.hp.com, mm-commits@vger.kernel.org


The patch titled
     hpsa: fix use of unallocated memory for MSA2xxx enclosure device data
has been removed from the -mm tree.  Its filename was
     hpsa-fix-use-of-unallocated-memory-for-msa2xxx-enclosure-device-data.patch

This patch was dropped because it was folded into scsi-add-hpsa-driver-for-hp-smart-array-controllers.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hpsa: fix use of unallocated memory for MSA2xxx enclosure device data
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>

Fix use of unallocated memory for MSA2xxx enclosure device data.  If you
happened to have fewer physical devices reported by CCISS_REPORT_LUNS than
the total number of MSA2012 enclosures (unlikely), the data for some
enclosure(s) would get stored into, or cause other device data to be
stored into unallocated territory.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Mike Miller <mikem@beardog.cce.hp.com>
Cc: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/scsi/hpsa.c~hpsa-fix-use-of-unallocated-memory-for-msa2xxx-enclosure-device-data drivers/scsi/hpsa.c
--- a/drivers/scsi/hpsa.c~hpsa-fix-use-of-unallocated-memory-for-msa2xxx-enclosure-device-data
+++ a/drivers/scsi/hpsa.c
@@ -1314,7 +1314,8 @@ static void figure_bus_target_lun(struct
 static int add_msa2xxx_enclosure_device(struct ctlr_info *h,
 	struct hpsa_scsi_dev_t *tmpdevice,
 	struct hpsa_scsi_dev_t *this_device, __u8 *lunaddrbytes,
-	int bus, int target, int lun, unsigned long lunzerobits[])
+	int bus, int target, int lun, unsigned long lunzerobits[],
+	int *nmsa2xxx_enclosures)
 {
 	unsigned char scsi3addr[8];
 
@@ -1333,10 +1334,19 @@ static int add_msa2xxx_enclosure_device(
 	if (is_hba_lunid(scsi3addr))
 		return 0; /* Don't add the RAID controller here. */
 
+#define MAX_MSA2XXX_ENCLOSURES 32
+	if (*nmsa2xxx_enclosures >= MAX_MSA2XXX_ENCLOSURES) {
+		dev_warn(&h->pdev->dev, "Maximum number of MSA2XXX "
+			"enclosures exceeded.  Check your hardware "
+			"configuration.");
+		return 0;
+	}
+
 	memset(scsi3addr, 0, 8);
 	scsi3addr[3] = target;
 	if (hpsa_update_device_info(h, scsi3addr, this_device))
 		return 0;
+	(*nmsa2xxx_enclosures)++;
 	hpsa_set_bus_target_lun(this_device, bus, target, 0);
 	set_bit(target, lunzerobits);
 	return 1;
@@ -1416,7 +1426,7 @@ static void hpsa_update_scsi_devices(str
 	struct hpsa_scsi_dev_t **currentsd, *this_device, *tmpdevice;
 	int ncurrent = 0;
 	int reportlunsize = sizeof(*physdev_list) + HPSA_MAX_PHYS_LUN * 8;
-	int i;
+	int i, nmsa2xxx_enclosures, ndevs_to_allocate;
 	int bus, target, lun;
 	DECLARE_BITMAP(lunzerobits, HPSA_MAX_TARGETS_PER_CTLR);
 
@@ -1438,8 +1448,14 @@ static void hpsa_update_scsi_devices(str
 			logdev_list, &nlogicals))
 		goto out;
 
+	/* We might see up to 32 MSA2xxx enclosures, actually 8 of them
+	 * but each of them 4 times through different paths.  The plus 1
+	 * is for the RAID controller.
+	 */
+	ndevs_to_allocate = nphysicals + nlogicals + MAX_MSA2XXX_ENCLOSURES + 1;
+
 	/* Allocate the per device structures */
-	for (i = 0; i < nphysicals + nlogicals + 1; i++) {
+	for (i = 0; i < ndevs_to_allocate; i++) {
 		currentsd[i] = kzalloc(sizeof(*currentsd[i]), GFP_KERNEL);
 		if (!currentsd[i]) {
 			dev_warn(&h->pdev->dev, "out of memory at %s:%d\n",
@@ -1450,6 +1466,7 @@ static void hpsa_update_scsi_devices(str
 	}
 
 	/* adjust our table of devices */
+	nmsa2xxx_enclosures = 0;
 	for (i = 0; i < nphysicals + nlogicals + 1; i++) {
 		__u8 *lunaddrbytes;
 
@@ -1482,7 +1499,8 @@ static void hpsa_update_scsi_devices(str
 		 * there is no lun 0.
 		 */
 		if (add_msa2xxx_enclosure_device(h, tmpdevice, this_device,
-			lunaddrbytes, bus, target, lun, lunzerobits)) {
+				lunaddrbytes, bus, target, lun, lunzerobits,
+				&nmsa2xxx_enclosures)) {
 			ncurrent++;
 			this_device = currentsd[ncurrent];
 		}
_

Patches currently in -mm which might be from scameron@beardog.cce.hp.com are

linux-next.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers.patch
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
hpsa-make-device-attrs-static.patch

