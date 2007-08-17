From: akpm@linux-foundation.org
Subject: + serial-add-pci-ids-for-pa-semi-pwrficient-onchip-uarts.patch added to -mm tree
Date: Fri, 17 Aug 2007 13:50:49 -0700
Message-ID: <200708172050.l7HKonsm028863@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55118 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757358AbXHQUvf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Aug 2007 16:51:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: olof@lixom.net, rmk@arm.linux.org.uk


The patch titled
     serial: add pci ids for PA Semi PWRficient onchip uarts
has been added to the -mm tree.  Its filename is
     serial-add-pci-ids-for-pa-semi-pwrficient-onchip-uarts.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: serial: add pci ids for PA Semi PWRficient onchip uarts
From: Olof Johansson <olof@lixom.net>

Add PCI IDs for the onchip UARTs on PA Semi PWRficient.

Signed-off-by: Olof Johansson <olof@lixom.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_pci.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+)

diff -puN drivers/serial/8250_pci.c~serial-add-pci-ids-for-pa-semi-pwrficient-onchip-uarts drivers/serial/8250_pci.c
--- a/drivers/serial/8250_pci.c~serial-add-pci-ids-for-pa-semi-pwrficient-onchip-uarts
+++ a/drivers/serial/8250_pci.c
@@ -1128,6 +1128,7 @@ enum pci_board_num_t {
 	pbn_exar_XR17C152,
 	pbn_exar_XR17C154,
 	pbn_exar_XR17C158,
+	pbn_pasemi_1682M,
 };
 
 /*
@@ -1650,6 +1651,14 @@ static struct pciserial_board pci_boards
 		.base_baud	= 921600,
 		.uart_offset	= 0x200,
 	},
+	/*
+	 * PA Semi PWRficient PA6T-1682M on-chip UART
+	 */
+	[pbn_pasemi_1682M] = {
+		.flags		= FL_BASE0,
+		.num_ports	= 1,
+		.base_baud	= 8333333,
+	},
 };
 
 static const struct pci_device_id softmodem_blacklist[] = {
@@ -2558,6 +2567,13 @@ static struct pci_device_id serial_pci_t
 		PCI_SUBVENDOR_ID_PERLE, PCI_SUBDEVICE_ID_PCI_RAS8,
 		0, 0, pbn_b2_8_921600 },
 	/*
+	 * PA Semi PA6T-1682M on-chip UART
+	 */
+	{	PCI_VENDOR_ID_PASEMI, 0xa004,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		pbn_pasemi_1682M },
+
+	/*
 	 * These entries match devices with class COMMUNICATION_SERIAL,
 	 * COMMUNICATION_MODEM or COMMUNICATION_MULTISERIAL
 	 */
_

Patches currently in -mm which might be from olof@lixom.net are

serial-add-pci-ids-for-pa-semi-pwrficient-onchip-uarts.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
