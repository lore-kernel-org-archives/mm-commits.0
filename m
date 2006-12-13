From: akpm@osdl.org
Subject: + add-support-for-korenix-16c950-based-pci-cards.patch added to -mm tree
Date: Wed, 13 Dec 2006 15:56:02 -0800
Message-ID: <200612132356.kBDNu24K025146@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58920 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670AbWLMX4Z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 18:56:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rmk+lkml@arm.linux.org.uk, rmk+kernel@arm.linux.org.uk


The patch titled
     Add support for Korenix 16C950-based PCI cards
has been added to the -mm tree.  Its filename is
     add-support-for-korenix-16c950-based-pci-cards.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add support for Korenix 16C950-based PCI cards
From: Russell King <rmk+lkml@arm.linux.org.uk>

Add initial support to 8250-pci for the Korenix Jetcard PCI serial cards. 
The JC12xx cards are standard RS232-based serial cards utilising the Oxford
16C950 device.

The JC14xx are RS422/RS485-based cards, but in order for these to be
supported natively, we will need additional tweaks to the 8250 layers so we
can specify some values for the 950's registers.  Hence, these two entries
are commented out.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/serial/8250_pci.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+)

diff -puN drivers/serial/8250_pci.c~add-support-for-korenix-16c950-based-pci-cards drivers/serial/8250_pci.c
--- a/drivers/serial/8250_pci.c~add-support-for-korenix-16c950-based-pci-cards
+++ a/drivers/serial/8250_pci.c
@@ -2243,6 +2243,30 @@ static struct pci_device_id serial_pci_t
 		pbn_b0_bt_1_460800 },
 
 	/*
+	 * Korenix Jetcard F0/F1 cards (JC1204, JC1208, JC1404, JC1408).
+	 * Cards are identified by their subsystem vendor IDs, which
+	 * (in hex) match the model number.
+	 *
+	 * Note that JC140x are RS422/485 cards which require ox950
+	 * ACR = 0x10, and as such are not currently fully supported.
+	 */
+	{	PCI_VENDOR_ID_KORENIX, PCI_DEVICE_ID_KORENIX_JETCARDF0,
+		0x1204, 0x0004, 0, 0,
+		pbn_b0_4_921600 },
+	{	PCI_VENDOR_ID_KORENIX, PCI_DEVICE_ID_KORENIX_JETCARDF0,
+		0x1208, 0x0004, 0, 0,
+		pbn_b0_4_921600 },
+/*	{	PCI_VENDOR_ID_KORENIX, PCI_DEVICE_ID_KORENIX_JETCARDF0,
+		0x1402, 0x0002, 0, 0,
+		pbn_b0_2_921600 }, */
+/*	{	PCI_VENDOR_ID_KORENIX, PCI_DEVICE_ID_KORENIX_JETCARDF0,
+		0x1404, 0x0004, 0, 0,
+		pbn_b0_4_921600 }, */
+	{	PCI_VENDOR_ID_KORENIX, PCI_DEVICE_ID_KORENIX_JETCARDF1,
+		0x1208, 0x0004, 0, 0,
+		pbn_b0_4_921600 },
+
+	/*
 	 * Dell Remote Access Card 4 - Tim_T_Murphy@Dell.com
 	 */
 	{	PCI_VENDOR_ID_DELL, PCI_DEVICE_ID_DELL_RAC4,
_

Patches currently in -mm which might be from rmk+lkml@arm.linux.org.uk are

add-support-for-korenix-16c950-based-pci-cards.patch

