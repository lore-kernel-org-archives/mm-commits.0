From: akpm@osdl.org
Subject: + mmc-add-a-quirk-to-allow-ene-pci-sd-card-readers-to-work-again.patch added to -mm tree
Date: Tue, 02 Jan 2007 14:25:30 -0800
Message-ID: <200701022225.l02MPUMK031891@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:38466 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964986AbXABWZw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 17:25:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linux@youmustbejoking.demon.co.uk, drzeus@drzeus.cx


The patch titled
     mmc: add a quirk to allow ENE PCI SD card readers to work again
has been added to the -mm tree.  Its filename is
     mmc-add-a-quirk-to-allow-ene-pci-sd-card-readers-to-work-again.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mmc: add a quirk to allow ENE PCI SD card readers to work again
From: Darren Salt <linux@youmustbejoking.demon.co.uk>

Support for these devices was broken for 2.6.18-rc1 and later by commit
146ad66eac836c0b976c98f428d73e1f6a75270d, which added voltage level
support.

This restores the previous behaviour for these devices by ensuring that
when the voltage is changed, only one write to set the voltage is
performed.

It may be that both writes are needed if the voltage is being changed
between two non-zero values or that it's safe to ensure that only one write
is done if the hardware only supports one voltage; I don't know whether
either is the case nor can I test since I have only the one SD reader
(1524:0550), and it supports just the one voltage.

Signed-off-by: Darren Salt <linux@youmustbejoking.demon.co.uk>
Cc: Pierre Ossman <drzeus@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/mmc/sdhci.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff -puN drivers/mmc/sdhci.c~mmc-add-a-quirk-to-allow-ene-pci-sd-card-readers-to-work-again drivers/mmc/sdhci.c
--- a/drivers/mmc/sdhci.c~mmc-add-a-quirk-to-allow-ene-pci-sd-card-readers-to-work-again
+++ a/drivers/mmc/sdhci.c
@@ -37,6 +37,7 @@ static unsigned int debug_quirks = 0;
 #define SDHCI_QUIRK_FORCE_DMA				(1<<1)
 /* Controller doesn't like some resets when there is no card inserted. */
 #define SDHCI_QUIRK_NO_CARD_NO_RESET			(1<<2)
+#define SDHCI_QUIRK_SINGLE_POWER_WRITE			(1<<3)
 
 static const struct pci_device_id pci_ids[] __devinitdata = {
 	{
@@ -65,6 +66,16 @@ static const struct pci_device_id pci_id
 		.driver_data	= SDHCI_QUIRK_FORCE_DMA,
 	},
 
+	{
+		.class		= PCI_CLASS_SYSTEM_SDHCI << 8,
+		.class_mask	= 0xFFFF00,
+		.vendor		= PCI_VENDOR_ID_ENE,
+		.device		= PCI_ANY_ID,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.driver_data	= SDHCI_QUIRK_SINGLE_POWER_WRITE,
+	},
+
 	{	/* Generic SD host controller */
 		PCI_DEVICE_CLASS((PCI_CLASS_SYSTEM_SDHCI << 8), 0xFFFF00)
 	},
@@ -669,16 +680,17 @@ out:
 
 static void sdhci_set_power(struct sdhci_host *host, unsigned short power)
 {
-	u8 pwr;
+	u8 pwr = 0;
 
 	if (host->power == power)
 		return;
 
-	writeb(0, host->ioaddr + SDHCI_POWER_CONTROL);
-
 	if (power == (unsigned short)-1)
 		goto out;
 
+	if ((host->chip->quirks & SDHCI_QUIRK_SINGLE_POWER_WRITE) == 0)
+		writeb(0, host->ioaddr + SDHCI_POWER_CONTROL);
+
 	pwr = SDHCI_POWER_ON;
 
 	switch (power) {
_

Patches currently in -mm which might be from linux@youmustbejoking.demon.co.uk are

mmc-add-a-quirk-to-allow-ene-pci-sd-card-readers-to-work-again.patch
