From: akpm@linux-foundation.org
Subject: + hpsa-fix-use-of-unallocated-memory-for-msa2xxx-enclosure-device-data.patch added to -mm tree
Date: Tue, 13 Oct 2009 13:54:15 -0700
Message-ID: <200910132054.n9DKsFEc006590@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60888 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934175AbZJMUzE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Oct 2009 16:55:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: scameron@beardog.cce.hp.com, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, mikem@beardog.cce.hp.com


The patch titled
     hpsa: fix use of unallocated memory for MSA2xxx enclosure device data
has been added to the -mm tree.  Its filename is
     hpsa-fix-use-of-unallocated-memory-for-msa2xxx-enclosure-device-data.patch

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

scsi-add-hpsa-driver-for-hp-smart-array-controllers.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix-hpsa_allow_any-test-for-vendor-id.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix.patch
hpsa-fix-use-of-unallocated-memory-for-msa2xxx-enclosure-device-data.patch
cciss-fix-multiple-calls-to-pci_release_regions.patch
cciss-add-cciss_allow_hpsa-module-parameter.patch

