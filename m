From: akpm@linux-foundation.org
Subject: + olpc-sdhci-add-quirk-for-the-marvell-cafes-vdd-powerup-issue.patch added to -mm tree
Date: Mon, 23 Jun 2008 17:07:29 -0700
Message-ID: <200806240007.m5O07TlI023318@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40496 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750942AbYFXAHq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jun 2008 20:07:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@queued.net, dilinger@debian.org, drzeus-list@drzeus.cx


The patch titled
     olpc: sdhci: add quirk for the Marvell CaFe's vdd/powerup issue
has been added to the -mm tree.  Its filename is
     olpc-sdhci-add-quirk-for-the-marvell-cafes-vdd-powerup-issue.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: olpc: sdhci: add quirk for the Marvell CaFe's vdd/powerup issue
From: Andres Salomon <dilinger@queued.net>

This has been sitting around unloved for way too long..

The Marvell CaFe chip's SD implementation chokes during card insertion
if one attempts to set the voltage and power up in the same
SDHCI_POWER_CONTROL register write.  This adds a quirk that does
that particular dance in two steps.

It also adds an entry to pci_ids.h for the CaFe chip's SD device.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci.c |   18 ++++++++++++++++++
 include/linux/pci_ids.h  |    1 +
 2 files changed, 19 insertions(+)

diff -puN drivers/mmc/host/sdhci.c~olpc-sdhci-add-quirk-for-the-marvell-cafes-vdd-powerup-issue drivers/mmc/host/sdhci.c
--- a/drivers/mmc/host/sdhci.c~olpc-sdhci-add-quirk-for-the-marvell-cafes-vdd-powerup-issue
+++ a/drivers/mmc/host/sdhci.c
@@ -55,6 +55,8 @@ static unsigned int debug_quirks = 0;
 #define SDHCI_QUIRK_32BIT_DMA_SIZE			(1<<7)
 /* Controller needs to be reset after each request to stay stable */
 #define SDHCI_QUIRK_RESET_AFTER_REQUEST			(1<<8)
+/* Controller needs voltage and power writes to happen separately */
+#define SDHCI_QUIRK_NO_SIMULT_VDD_AND_POWER		(1<<9)
 
 static const struct pci_device_id pci_ids[] __devinitdata = {
 	{
@@ -128,6 +130,14 @@ static const struct pci_device_id pci_id
 	},
 
 	{
+		.vendor         = PCI_VENDOR_ID_MARVELL,
+		.device         = PCI_DEVICE_ID_MARVELL_CAFE_SD,
+		.subvendor      = PCI_ANY_ID,
+		.subdevice      = PCI_ANY_ID,
+		.driver_data    = SDHCI_QUIRK_NO_SIMULT_VDD_AND_POWER,
+	},
+
+	{
 		.vendor         = PCI_VENDOR_ID_JMICRON,
 		.device         = PCI_DEVICE_ID_JMICRON_JMB38X_SD,
 		.subvendor      = PCI_ANY_ID,
@@ -774,6 +784,14 @@ static void sdhci_set_power(struct sdhci
 		BUG();
 	}
 
+	/*
+	 * At least the CaFe chip gets confused if we set the voltage
+	 * and set turn on power at the same time, so set the voltage first.
+	 */
+	if ((host->chip->quirks & SDHCI_QUIRK_NO_SIMULT_VDD_AND_POWER))
+		writeb(pwr & ~SDHCI_POWER_ON,
+				host->ioaddr + SDHCI_POWER_CONTROL);
+
 	writeb(pwr, host->ioaddr + SDHCI_POWER_CONTROL);
 
 out:
diff -puN include/linux/pci_ids.h~olpc-sdhci-add-quirk-for-the-marvell-cafes-vdd-powerup-issue include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~olpc-sdhci-add-quirk-for-the-marvell-cafes-vdd-powerup-issue
+++ a/include/linux/pci_ids.h
@@ -1520,6 +1520,7 @@
 #define PCI_DEVICE_ID_MARVELL_GT64260	0x6430
 #define PCI_DEVICE_ID_MARVELL_MV64360	0x6460
 #define PCI_DEVICE_ID_MARVELL_MV64460	0x6480
+#define PCI_DEVICE_ID_MARVELL_CAFE_SD	0x4101
 
 #define PCI_VENDOR_ID_V3		0x11b0
 #define PCI_DEVICE_ID_V3_V960		0x0001
_

Patches currently in -mm which might be from dilinger@queued.net are

olpc-sdhci-add-quirk-for-the-marvell-cafes-vdd-powerup-issue.patch
olpc-sdhci-add-quirk-for-the-marvell-cafes-interrupt-timeout.patch

