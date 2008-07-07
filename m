From: akpm@linux-foundation.org
Subject: - olpc-sdhci-add-quirk-for-the-marvell-cafes-interrupt-timeout.patch removed from -mm tree
Date: Sun, 06 Jul 2008 20:05:49 -0700
Message-ID: <200807070305.m6735nV1004848@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46690 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753483AbYGGDGD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 6 Jul 2008 23:06:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, dilinger@debian.org, drzeus-list@drzeus.cx, mm-commits@vger.kernel.org


The patch titled
     olpc: sdhci: add quirk for the Marvell CaFe's interrupt timeout
has been removed from the -mm tree.  Its filename was
     olpc-sdhci-add-quirk-for-the-marvell-cafes-interrupt-timeout.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: olpc: sdhci: add quirk for the Marvell CaFe's interrupt timeout
From: Andres Salomon <dilinger@queued.net>

The CaFe chip has a hardware bug that ends up with us getting a timeout
value that's too small, causing the following sorts of problems:

[   60.525138] mmcblk0: error -110 transferring data
[   60.531477] end_request: I/O error, dev mmcblk0, sector 1484353
[   60.533371] Buffer I/O error on device mmcblk0p2, logical block 181632
[   60.533371] lost page write due to I/O error on mmcblk0p2

Presumably this is an off-by-one error in the hardware.  Incrementing
the timeout count value that we stuff into the TIMEOUT_CONTROL register
gets us a value that works.  This bug was originally discovered by
Pierre Ossman, I believe.

[thanks to Robert Millan for proving that this was still a problem]

Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -puN drivers/mmc/host/sdhci.c~olpc-sdhci-add-quirk-for-the-marvell-cafes-interrupt-timeout drivers/mmc/host/sdhci.c
--- a/drivers/mmc/host/sdhci.c~olpc-sdhci-add-quirk-for-the-marvell-cafes-interrupt-timeout
+++ a/drivers/mmc/host/sdhci.c
@@ -57,6 +57,8 @@ static unsigned int debug_quirks = 0;
 #define SDHCI_QUIRK_RESET_AFTER_REQUEST			(1<<8)
 /* Controller needs voltage and power writes to happen separately */
 #define SDHCI_QUIRK_NO_SIMULT_VDD_AND_POWER		(1<<9)
+/* Controller has an off-by-one issue with timeout value */
+#define SDHCI_QUIRK_INCR_TIMEOUT_CONTROL		(1<<10)
 
 static const struct pci_device_id pci_ids[] __devinitdata = {
 	{
@@ -134,7 +136,8 @@ static const struct pci_device_id pci_id
 		.device         = PCI_DEVICE_ID_MARVELL_CAFE_SD,
 		.subvendor      = PCI_ANY_ID,
 		.subdevice      = PCI_ANY_ID,
-		.driver_data    = SDHCI_QUIRK_NO_SIMULT_VDD_AND_POWER,
+		.driver_data    = SDHCI_QUIRK_NO_SIMULT_VDD_AND_POWER |
+				  SDHCI_QUIRK_INCR_TIMEOUT_CONTROL,
 	},
 
 	{
@@ -479,6 +482,13 @@ static void sdhci_prepare_data(struct sd
 			break;
 	}
 
+	/*
+	 * Compensate for an off-by-one error in the CaFe hardware; otherwise,
+	 * a too-small count gives us interrupt timeouts.
+	 */
+	if ((host->chip->quirks & SDHCI_QUIRK_INCR_TIMEOUT_CONTROL))
+		count++;
+
 	if (count >= 0xF) {
 		printk(KERN_WARNING "%s: Too large timeout requested!\n",
 			mmc_hostname(host->mmc));
_

Patches currently in -mm which might be from dilinger@queued.net are

linux-next.patch
lxfb-drop-dead-declarations-from-header.patch

