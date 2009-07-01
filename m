From: akpm@linux-foundation.org
Subject: [merged] parport-serial-add-support-for-netmos-9901-multi-io-card.patch removed from -mm tree
Date: Wed, 01 Jul 2009 10:26:50 -0700
Message-ID: <200907011726.n61HQoqR001516@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39076 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753341AbZGAR1D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jul 2009 13:27:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mb@bu3sch.de, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     parport/serial: add support for NetMos 9901 Multi-IO card
has been removed from the -mm tree.  Its filename was
     parport-serial-add-support-for-netmos-9901-multi-io-card.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: parport/serial: add support for NetMos 9901 Multi-IO card
From: Michael Buesch <mb@bu3sch.de>

Add support for the PCI-Express NetMos 9901 Multi-IO card.

0001:06:00.0 Serial controller [0700]: NetMos Technology Device [9710:9901] (prog-if 02 [16550])
        Subsystem: Device [a000:1000]
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 65
        Region 0: I/O ports at 0030 [size=8]
        Region 1: Memory at 80105000 (32-bit, non-prefetchable) [size=4K]
        Region 4: Memory at 80104000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: <access denied>
        Kernel driver in use: serial
        Kernel modules: 8250_pci

0001:06:00.1 Serial controller [0700]: NetMos Technology Device [9710:9901] (prog-if 02 [16550])
        Subsystem: Device [a000:1000]
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin B routed to IRQ 65
        Region 0: I/O ports at 0020 [size=8]
        Region 1: Memory at 80103000 (32-bit, non-prefetchable) [size=4K]
        Region 4: Memory at 80102000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: <access denied>
        Kernel driver in use: serial
        Kernel modules: 8250_pci

0001:06:00.2 Parallel controller [0701]: NetMos Technology Device [9710:9901] (prog-if 03 [IEEE1284])
        Subsystem: Device [a000:2000]
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin C routed to IRQ 65
        Region 0: I/O ports at 0010 [size=8]
        Region 1: I/O ports at <unassigned>
        Region 2: Memory at 80101000 (32-bit, non-prefetchable) [size=4K]
        Region 4: Memory at 80100000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: <access denied>
        Kernel driver in use: parport_pc
        Kernel modules: parport_pc

[   16.760181] PCI parallel port detected: 416c:0100, I/O at 0x812010(0x0), IRQ 65
[   16.760225] parport0: PC-style at 0x812010, irq 65 [PCSPP,TRISTATE,EPP]
[   16.851842] serial 0001:06:00.0: enabling device (0004 -> 0007)
[   16.883776] 0001:06:00.0: ttyS0 at I/O 0x812030 (irq = 65) is a ST16650V2
[   16.893832] serial 0001:06:00.1: enabling device (0004 -> 0007)
[   16.926537] 0001:06:00.1: ttyS1 at I/O 0x812020 (irq = 65) is a ST16650V2

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parport/parport_pc.c |    5 ++++-
 drivers/serial/8250_pci.c    |    6 ++++++
 include/linux/pci_ids.h      |    1 +
 3 files changed, 11 insertions(+), 1 deletion(-)

diff -puN drivers/parport/parport_pc.c~parport-serial-add-support-for-netmos-9901-multi-io-card drivers/parport/parport_pc.c
--- a/drivers/parport/parport_pc.c~parport-serial-add-support-for-netmos-9901-multi-io-card
+++ a/drivers/parport/parport_pc.c
@@ -2907,6 +2907,7 @@ enum parport_pc_pci_cards {
 	netmos_9755,
 	netmos_9805,
 	netmos_9815,
+	netmos_9901,
 	quatech_sppxp100,
 };
 
@@ -2987,7 +2988,7 @@ static struct parport_pc_pci {
 	/* netmos_9755 */               { 2, { { 0, 1 }, { 2, 3 },} },
 	/* netmos_9805 */               { 1, { { 0, -1 }, } },
 	/* netmos_9815 */               { 2, { { 0, -1 }, { 2, -1 }, } },
-
+	/* netmos_9901 */               { 1, { { 0, -1 }, } },
 	/* quatech_sppxp100 */		{ 1, { { 0, 1 }, } },
 };
 
@@ -3089,6 +3090,8 @@ static const struct pci_device_id parpor
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, netmos_9805 },
 	{ PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9815,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, netmos_9815 },
+	{ PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9901,
+	  0xA000, 0x2000, 0, 0, netmos_9901 },
 	/* Quatech SPPXP-100 Parallel port PCI ExpressCard */
 	{ PCI_VENDOR_ID_QUATECH, PCI_DEVICE_ID_QUATECH_SPPXP_100,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, quatech_sppxp100 },
diff -puN drivers/serial/8250_pci.c~parport-serial-add-support-for-netmos-9901-multi-io-card drivers/serial/8250_pci.c
--- a/drivers/serial/8250_pci.c~parport-serial-add-support-for-netmos-9901-multi-io-card
+++ a/drivers/serial/8250_pci.c
@@ -759,6 +759,8 @@ static int pci_netmos_init(struct pci_de
 	/* subdevice 0x00PS means <P> parallel, <S> serial */
 	unsigned int num_serial = dev->subsystem_device & 0xf;
 
+	if (dev->device == PCI_DEVICE_ID_NETMOS_9901)
+		return 0;
 	if (dev->subsystem_vendor == PCI_VENDOR_ID_IBM &&
 			dev->subsystem_device == 0x0299)
 		return 0;
@@ -3557,6 +3559,10 @@ static struct pci_device_id serial_pci_t
 		PCI_VENDOR_ID_IBM, 0x0299,
 		0, 0, pbn_b0_bt_2_115200 },
 
+	{	PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9901,
+		0xA000, 0x1000,
+		0, 0, pbn_b0_1_115200 },
+
 	/*
 	 * These entries match devices with class COMMUNICATION_SERIAL,
 	 * COMMUNICATION_MODEM or COMMUNICATION_MULTISERIAL
diff -puN include/linux/pci_ids.h~parport-serial-add-support-for-netmos-9901-multi-io-card include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~parport-serial-add-support-for-netmos-9901-multi-io-card
+++ a/include/linux/pci_ids.h
@@ -2645,6 +2645,7 @@
 #define PCI_DEVICE_ID_NETMOS_9835	0x9835
 #define PCI_DEVICE_ID_NETMOS_9845	0x9845
 #define PCI_DEVICE_ID_NETMOS_9855	0x9855
+#define PCI_DEVICE_ID_NETMOS_9901	0x9901
 
 #define PCI_VENDOR_ID_3COM_2		0xa727
 
_

Patches currently in -mm which might be from mb@bu3sch.de are

origin.patch

