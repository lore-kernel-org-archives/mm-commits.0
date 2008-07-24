From: akpm@linux-foundation.org
Subject: - serial-add-support-for-a-no-name-4-ports-multiserial-card.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:28:10 -0700
Message-ID: <200807242328.m6ONSAjS011235@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33486 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756252AbYGXX3Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:29:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catab@embedromix.ro, alan@redhat.com, rmk+kernel@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     serial: add support for a no-name 4 ports multiserial card
has been removed from the -mm tree.  Its filename was
     serial-add-support-for-a-no-name-4-ports-multiserial-card.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial: add support for a no-name 4 ports multiserial card
From: "Catalin(ux) M BOIE" <catab@embedromix.ro>

It is a no-name PCI card.  I found no reference to a producer so I used
"UNKNOWN_0x1584" as the name.

Full lspci:
01:07.0 0780: 10b5:9050 (rev 01)
        Subsystem: 10b5:1584
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- \
                ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- \
                DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin A routed to IRQ 10
        Region 1: I/O ports at ec00 [size=128]
        Region 2: I/O ports at e480 [size=32]
        Region 3: I/O ports at e400 [size=8]
        Capabilities: [40] Power Management version 1
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA \
                        PME(D0+,D1-,D2-,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [48] #06 [0080]
        Capabilities: [4c] Vital Product Data

After:
0000:01:07.0: ttyS4 at I/O 0xe480 (irq = 10) is a 16550A
0000:01:07.0: ttyS5 at I/O 0xe488 (irq = 10) is a 16550A
0000:01:07.0: ttyS6 at I/O 0xe490 (irq = 10) is a 16550A
0000:01:07.0: ttyS7 at I/O 0xe498 (irq = 10) is a 16550A

Signed-off-by: Catalin(ux) M BOIE <catab@embedromix.ro>
Acked-by: Alan Cox <alan@redhat.com>
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_pci.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff -puN drivers/serial/8250_pci.c~serial-add-support-for-a-no-name-4-ports-multiserial-card drivers/serial/8250_pci.c
--- a/drivers/serial/8250_pci.c~serial-add-support-for-a-no-name-4-ports-multiserial-card
+++ a/drivers/serial/8250_pci.c
@@ -767,6 +767,9 @@ pci_default_setup(struct serial_private 
 #define PCI_SUBDEVICE_ID_POCTAL232	0x0308
 #define PCI_SUBDEVICE_ID_POCTAL422	0x0408
 
+/* Unknown vendors/cards - this should not be in linux/pci_ids.h */
+#define PCI_SUBDEVICE_ID_UNKNOWN_0x1584	0x1584
+
 /*
  * Master list of serial port init/setup/exit quirks.
  * This does not describe the general nature of the port.
@@ -882,6 +885,15 @@ static struct pci_serial_quirk pci_seria
 	},
 	{
 		.vendor		= PCI_VENDOR_ID_PLX,
+		.device		= PCI_DEVICE_ID_PLX_9050,
+		.subvendor	= PCI_VENDOR_ID_PLX,
+		.subdevice	= PCI_SUBDEVICE_ID_UNKNOWN_0x1584,
+		.init		= pci_plx9050_init,
+		.setup		= pci_default_setup,
+		.exit		= __devexit_p(pci_plx9050_exit),
+	},
+	{
+		.vendor		= PCI_VENDOR_ID_PLX,
 		.device		= PCI_DEVICE_ID_PLX_ROMULUS,
 		.subvendor	= PCI_VENDOR_ID_PLX,
 		.subdevice	= PCI_DEVICE_ID_PLX_ROMULUS,
@@ -2197,6 +2209,11 @@ static struct pci_device_id serial_pci_t
 	{	PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_1077,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_b2_4_921600 },
+	/* Unknown card - subdevice 0x1584 */
+	{	PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9050,
+		PCI_VENDOR_ID_PLX,
+		PCI_SUBDEVICE_ID_UNKNOWN_0x1584, 0, 0,
+		pbn_b0_4_115200 },
 	{	PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9050,
 		PCI_SUBVENDOR_ID_KEYSPAN,
 		PCI_SUBDEVICE_ID_KEYSPAN_SX2, 0, 0,
_

Patches currently in -mm which might be from catab@embedromix.ro are

origin.patch

