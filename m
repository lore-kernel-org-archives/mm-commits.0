From: akpm@osdl.org
Subject: + serial-support-for-new-board.patch added to -mm tree
Date: Thu, 11 Jan 2007 13:04:38 -0800
Message-ID: <200701112104.l0BL4cht002996@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34752 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487AbXAKVFK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Jan 2007 16:05:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias.fuchs@esd-electronics.com, rmk@arm.linux.org.uk


The patch titled
     serial: support for new board
has been added to the -mm tree.  Its filename is
     serial-support-for-new-board.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: serial: support for new board
From: Matthias Fuchs <matthias.fuchs@esd-electronics.com>

Add support for the CPCI-ASIO4 quad port CompactPCI UART board from
electronic system design gmbh.

Signed-off-by: Matthias Fuchs <matthias.fuchs@esd-electronics.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/serial/8250_pci.c |   11 +++++++++++
 include/linux/pci_ids.h   |    3 +++
 2 files changed, 14 insertions(+)

diff -puN drivers/serial/8250_pci.c~serial-support-for-new-board drivers/serial/8250_pci.c
--- a/drivers/serial/8250_pci.c~serial-support-for-new-board
+++ a/drivers/serial/8250_pci.c
@@ -936,6 +936,7 @@ enum pci_board_num_t {
 
 	pbn_b2_1_115200,
 	pbn_b2_2_115200,
+	pbn_b2_4_115200,
 	pbn_b2_8_115200,
 
 	pbn_b2_1_460800,
@@ -1249,6 +1250,12 @@ static struct pciserial_board pci_boards
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
@@ -1990,6 +1997,10 @@ static struct pci_device_id serial_pci_t
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
@@ -955,6 +955,7 @@
 #define PCI_DEVICE_ID_PLX_R753		0x1152
 #define PCI_DEVICE_ID_PLX_OLITEC	0x1187
 #define PCI_DEVICE_ID_PLX_PCI200SYN	0x3196
+#define PCI_DEVICE_ID_PLX_9030		0x9030
 #define PCI_DEVICE_ID_PLX_9050		0x9050
 #define PCI_DEVICE_ID_PLX_9080		0x9080
 #define PCI_DEVICE_ID_PLX_GTEK_SERIAL2	0xa001
@@ -1688,6 +1689,8 @@
 #define PCI_VENDOR_ID_ELECTRONICDESIGNGMBH 0x12f8
 #define PCI_DEVICE_ID_LML_33R10		0x8a02
 
+#define PCI_VENDOR_ID_ESDGMBH		0x12fe
+#define PCI_DEVICE_ID_ESDGMBH_CPCIASIO4 0x0111
 
 #define PCI_VENDOR_ID_SIIG		0x131f
 #define PCI_SUBVENDOR_ID_SIIG		0x131f
_

Patches currently in -mm which might be from matthias.fuchs@esd-electronics.com are

serial-support-for-new-board.patch
