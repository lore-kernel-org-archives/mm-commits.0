From: akpm@linux-foundation.org
Subject: - serial-support-for-new-board.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:54:02 -0800
Message-ID: <200702112254.l1BMs2B1016164@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60472 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932857AbXBKWyX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:54:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias.fuchs@esd-electronics.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     serial: support for new board
has been removed from the -mm tree.  Its filename was
     serial-support-for-new-board.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: serial: support for new board
From: Matthias Fuchs <matthias.fuchs@esd-electronics.com>

Add support for the CPCI-ASIO4 quad port CompactPCI UART board from
electronic system design gmbh.

Signed-off-by: Matthias Fuchs <matthias.fuchs@esd-electronics.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_pci.c |   11 +++++++++++
 include/linux/pci_ids.h   |    2 ++
 2 files changed, 13 insertions(+)

diff -puN drivers/serial/8250_pci.c~serial-support-for-new-board drivers/serial/8250_pci.c
--- a/drivers/serial/8250_pci.c~serial-support-for-new-board
+++ a/drivers/serial/8250_pci.c
@@ -943,6 +943,7 @@ enum pci_board_num_t {
 
 	pbn_b2_1_115200,
 	pbn_b2_2_115200,
+	pbn_b2_4_115200,
 	pbn_b2_8_115200,
 
 	pbn_b2_1_460800,
@@ -1256,6 +1257,12 @@ static struct pciserial_board pci_boards
 		.base_baud	= 115200,
 		.uart_offset	= 8,
 	},
+	[pbn_b2_4_115200] = {
+		.flags          = FL_BASE2,
+		.num_ports      = 4,
+		.base_baud      = 115200,
+		.uart_offset    = 8,
+	},
 	[pbn_b2_8_115200] = {
 		.flags		= FL_BASE2,
 		.num_ports	= 8,
@@ -1997,6 +2004,10 @@ static struct pci_device_id serial_pci_t
 	{	PCI_VENDOR_ID_PANACOM, PCI_DEVICE_ID_PANACOM_DUALMODEM,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_panacom2 },
+	{	PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9030,
+		PCI_VENDOR_ID_ESDGMBH,
+		PCI_DEVICE_ID_ESDGMBH_CPCIASIO4, 0, 0,
+		pbn_b2_4_115200 },
 	{	PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9050,
 		PCI_SUBVENDOR_ID_CHASE_PCIFAST,
 		PCI_SUBDEVICE_ID_CHASE_PCIFAST4, 0, 0, 
diff -puN include/linux/pci_ids.h~serial-support-for-new-board include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~serial-support-for-new-board
+++ a/include/linux/pci_ids.h
@@ -1697,6 +1697,8 @@
 #define PCI_VENDOR_ID_ELECTRONICDESIGNGMBH 0x12f8
 #define PCI_DEVICE_ID_LML_33R10		0x8a02
 
+#define PCI_VENDOR_ID_ESDGMBH		0x12fe
+#define PCI_DEVICE_ID_ESDGMBH_CPCIASIO4 0x0111
 
 #define PCI_VENDOR_ID_SIIG		0x131f
 #define PCI_SUBVENDOR_ID_SIIG		0x131f
_

Patches currently in -mm which might be from matthias.fuchs@esd-electronics.com are

origin.patch
