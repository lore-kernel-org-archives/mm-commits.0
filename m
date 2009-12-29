From: akpm@linux-foundation.org
Subject: [merged] 8250_pci-add-support-for-mcs9865-syba-6x-serial-port-card.patch removed from -mm tree
Date: Tue, 29 Dec 2009 13:32:54 -0800
Message-ID: <200912292132.nBTLWsrv008664@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47315 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752804AbZL2VdH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Dec 2009 16:33:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iws@ovro.caltech.edu, alan@lxorguk.ukuu.org.uk, augulis.darius@gmail.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     8250_pci: add support for MCS9865 / SYBA 6x Serial Port Card
has been removed from the -mm tree.  Its filename was
     8250_pci-add-support-for-mcs9865-syba-6x-serial-port-card.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: 8250_pci: add support for MCS9865 / SYBA 6x Serial Port Card
From: "Ira W. Snyder" <iws@ovro.caltech.edu>

This patch is heavily based on an earlier patch found on the linux-serial
mailing list [1], written by Darius Augulis.

The previous incarnation of this patch only supported a 2x serial port
card.  I have added support for my SYBA 6x serial port card, and tested on
x86.

[1]: http://marc.info/?l=linux-serial&m=124975806304760

Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
Cc: Darius Augulis <augulis.darius@gmail.com>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parport/parport_pc.c |    6 ++++++
 drivers/serial/8250_pci.c    |   22 +++++++++++++++++++++-
 include/linux/pci_ids.h      |    1 +
 3 files changed, 28 insertions(+), 1 deletion(-)

diff -puN drivers/parport/parport_pc.c~8250_pci-add-support-for-mcs9865-syba-6x-serial-port-card drivers/parport/parport_pc.c
--- a/drivers/parport/parport_pc.c~8250_pci-add-support-for-mcs9865-syba-6x-serial-port-card
+++ a/drivers/parport/parport_pc.c
@@ -2908,6 +2908,7 @@ enum parport_pc_pci_cards {
 	netmos_9805,
 	netmos_9815,
 	netmos_9901,
+	netmos_9865,
 	quatech_sppxp100,
 };
 
@@ -2989,6 +2990,7 @@ static struct parport_pc_pci {
 	/* netmos_9805 */               { 1, { { 0, -1 }, } },
 	/* netmos_9815 */               { 2, { { 0, -1 }, { 2, -1 }, } },
 	/* netmos_9901 */               { 1, { { 0, -1 }, } },
+	/* netmos_9865 */               { 1, { { 0, -1 }, } },
 	/* quatech_sppxp100 */		{ 1, { { 0, 1 }, } },
 };
 
@@ -3092,6 +3094,10 @@ static const struct pci_device_id parpor
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, netmos_9815 },
 	{ PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9901,
 	  0xA000, 0x2000, 0, 0, netmos_9901 },
+	{ PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9865,
+	  0xA000, 0x1000, 0, 0, netmos_9865 },
+	{ PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9865,
+	  0xA000, 0x2000, 0, 0, netmos_9865 },
 	/* Quatech SPPXP-100 Parallel port PCI ExpressCard */
 	{ PCI_VENDOR_ID_QUATECH, PCI_DEVICE_ID_QUATECH_SPPXP_100,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, quatech_sppxp100 },
diff -puN drivers/serial/8250_pci.c~8250_pci-add-support-for-mcs9865-syba-6x-serial-port-card drivers/serial/8250_pci.c
--- a/drivers/serial/8250_pci.c~8250_pci-add-support-for-mcs9865-syba-6x-serial-port-card
+++ a/drivers/serial/8250_pci.c
@@ -760,7 +760,8 @@ static int pci_netmos_init(struct pci_de
 	/* subdevice 0x00PS means <P> parallel, <S> serial */
 	unsigned int num_serial = dev->subsystem_device & 0xf;
 
-	if (dev->device == PCI_DEVICE_ID_NETMOS_9901)
+	if ((dev->device == PCI_DEVICE_ID_NETMOS_9901) ||
+		(dev->device == PCI_DEVICE_ID_NETMOS_9865))
 		return 0;
 	if (dev->subsystem_vendor == PCI_VENDOR_ID_IBM &&
 			dev->subsystem_device == 0x0299)
@@ -1479,6 +1480,7 @@ enum pci_board_num_t {
 
 	pbn_b0_bt_1_115200,
 	pbn_b0_bt_2_115200,
+	pbn_b0_bt_4_115200,
 	pbn_b0_bt_8_115200,
 
 	pbn_b0_bt_1_460800,
@@ -1703,6 +1705,12 @@ static struct pciserial_board pci_boards
 		.base_baud	= 115200,
 		.uart_offset	= 8,
 	},
+	[pbn_b0_bt_4_115200] = {
+		.flags		= FL_BASE0|FL_BASE_BARS,
+		.num_ports	= 4,
+		.base_baud	= 115200,
+		.uart_offset	= 8,
+	},
 	[pbn_b0_bt_8_115200] = {
 		.flags		= FL_BASE0|FL_BASE_BARS,
 		.num_ports	= 8,
@@ -3649,6 +3657,18 @@ static struct pci_device_id serial_pci_t
 		0, 0, pbn_b0_1_115200 },
 
 	/*
+	 * Best Connectivity PCI Multi I/O cards
+	 */
+
+	{	PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9865,
+		0xA000, 0x1000,
+		0, 0, pbn_b0_1_115200 },
+
+	{	PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9865,
+		0xA000, 0x3004,
+		0, 0, pbn_b0_bt_4_115200 },
+
+	/*
 	 * These entries match devices with class COMMUNICATION_SERIAL,
 	 * COMMUNICATION_MODEM or COMMUNICATION_MULTISERIAL
 	 */
diff -puN include/linux/pci_ids.h~8250_pci-add-support-for-mcs9865-syba-6x-serial-port-card include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~8250_pci-add-support-for-mcs9865-syba-6x-serial-port-card
+++ a/include/linux/pci_ids.h
@@ -2713,6 +2713,7 @@
 #define PCI_DEVICE_ID_NETMOS_9835	0x9835
 #define PCI_DEVICE_ID_NETMOS_9845	0x9845
 #define PCI_DEVICE_ID_NETMOS_9855	0x9855
+#define PCI_DEVICE_ID_NETMOS_9865	0x9865
 #define PCI_DEVICE_ID_NETMOS_9901	0x9901
 
 #define PCI_VENDOR_ID_3COM_2		0xa727
_

Patches currently in -mm which might be from iws@ovro.caltech.edu are

linux-next.patch

