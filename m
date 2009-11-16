From: akpm@linux-foundation.org
Subject: [folded] scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix-hpsa_allow_any-test-for-vendor-id.patch removed from -mm tree
Date: Mon, 16 Nov 2009 13:28:02 -0800
Message-ID: <200911162128.nAGLS2Tf032372@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35362 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753215AbZKPV2J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Nov 2009 16:28:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: scameron@beardog.cce.hp.com, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, mikem@beardog.cce.hp.com, mm-commits@vger.kernel.org


The patch titled
     hpsa: fix hpsa_allow_any test for vendor ID
has been removed from the -mm tree.  Its filename was
     scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix-hpsa_allow_any-test-for-vendor-id.patch

This patch was dropped because it was folded into scsi-add-hpsa-driver-for-hp-smart-array-controllers.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hpsa: fix hpsa_allow_any test for vendor ID
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>

Fix hpsa_allow_any test for vendor ID.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: Mike Miller <mikem@beardog.cce.hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/scsi/hpsa.c~scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix-hpsa_allow_any-test-for-vendor-id drivers/scsi/hpsa.c
--- a/drivers/scsi/hpsa.c~scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix-hpsa_allow_any-test-for-vendor-id
+++ a/drivers/scsi/hpsa.c
@@ -3080,7 +3080,7 @@ static int hpsa_pci_init(struct ctlr_inf
 
 	if (prod_index == ARRAY_SIZE(products)) {
 		prod_index--;
-		if (subsystem_vendor_id == !PCI_VENDOR_ID_HP ||
+		if (subsystem_vendor_id != PCI_VENDOR_ID_HP ||
 				!hpsa_allow_any) {
 			dev_warn(&pdev->dev, "unrecognized board ID:"
 				" 0x%08lx, ignoring.\n",
_

Patches currently in -mm which might be from scameron@beardog.cce.hp.com are

linux-next.patch
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
hpsa-make-device-attrs-static.patch

