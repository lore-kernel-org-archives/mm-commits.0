From: akpm@linux-foundation.org
Subject: - serial-add-pci-ids-for-pa-semi-pwrficient-onchip-uarts.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:56:53 -0700
Message-ID: <200708242056.l7OKurSB014106@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60784 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763835AbXHXVI2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:08:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olof@lixom.net, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     serial: add pci ids for PA Semi PWRficient onchip uarts
has been removed from the -mm tree.  Its filename was
     serial-add-pci-ids-for-pa-semi-pwrficient-onchip-uarts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-powerpc.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
