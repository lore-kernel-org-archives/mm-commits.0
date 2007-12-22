From: akpm@linux-foundation.org
Subject: + serial-add-addi-data-gmbh-communication-cardsin8250_pcic-and-pci_idsh.patch added to -mm tree
Date: Sat, 22 Dec 2007 00:35:24 -0800
Message-ID: <200712220835.lBM8ZO3T024840@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55256 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751059AbXLVIgA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 22 Dec 2007 03:36:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Krauth.Julien@addi-data.com, krauth.julien@addi-data.com, rmk@arm.linux.org.uk


The patch titled
     serial: add ADDI-DATA GmbH Communication cardsin8250_pci.c and pci_ids.h
has been added to the -mm tree.  Its filename is
     serial-add-addi-data-gmbh-communication-cardsin8250_pcic-and-pci_idsh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial: add ADDI-DATA GmbH Communication cardsin8250_pci.c and pci_ids.h
From: "Krauth.Julien" <Krauth.Julien@addi-data.com>

Add ADDI-DATA GmbH communication cards to 8250_pci driver.  Supported cards
are:

APCI-7300, APCI-7420, APCI-7500, APCI-7800 APCI-7300-2, APCI-7420-2,
APCI-7500-2 APCI-7300-3, APCI-7420-3, APCI-7500-3, APCI-7800-3

Signed-off-by: Krauth J. <krauth.julien@addi-data.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_pci.c |  133 ++++++++++++++++++++++++++++++++++++
 include/linux/pci_ids.h   |   17 ++++
 2 files changed, 150 insertions(+)

diff -puN drivers/serial/8250_pci.c~serial-add-addi-data-gmbh-communication-cardsin8250_pcic-and-pci_idsh drivers/serial/8250_pci.c
--- a/drivers/serial/8250_pci.c~serial-add-addi-data-gmbh-communication-cardsin8250_pcic-and-pci_idsh
+++ a/drivers/serial/8250_pci.c
@@ -106,6 +106,32 @@ setup_port(struct serial_private *priv, 
 }
 
 /*
+ * ADDI-DATA GmbH communication cards <info@addi-data.com>
+ */
+static int
+addidata_apci7800_setup(struct serial_private *priv, struct pciserial_board *board,
+               struct uart_port *port, int idx)
+{
+	unsigned int bar = 0, offset = board->first_offset;
+	bar = FL_GET_BASE(board->flags);
+
+	if (idx < 2 ) {
+		offset += idx * board->uart_offset;
+	} else if ((idx >= 2) && (idx < 4)) {
+		bar += 1;
+		offset += ((idx - 2) * board->uart_offset);
+	} else if ((idx >= 4) && (idx < 6 )) {
+		bar += 2;
+		offset += ((idx - 4) * board->uart_offset);
+	} else if (idx >= 6) {
+		bar += 3;
+		offset += ((idx - 6) * board->uart_offset);
+	}
+
+	return setup_port(priv, port, bar, offset, board->reg_shift);
+}
+
+/*
  * AFAVLAB uses a different mixture of BARs and offsets
  * Not that ugly ;) -- HW
  */
@@ -752,6 +778,16 @@ pci_default_setup(struct serial_private 
  */
 static struct pci_serial_quirk pci_serial_quirks[] = {
 	/*
+	* ADDI-DATA GmbH communication cards <info@addi-data.com>
+	*/
+	{
+		.vendor         = PCI_VENDOR_ID_ADDIDATA_OLD,
+		.device         = PCI_DEVICE_ID_ADDIDATA_APCI7800,
+		.subvendor      = PCI_ANY_ID,
+		.subdevice      = PCI_ANY_ID,
+		.setup          = addidata_apci7800_setup,
+	},
+	/*
 	 * AFAVLAB cards - these may be called via parport_serial
 	 *  It is not clear whether this applies to all products.
 	 */
@@ -1179,6 +1215,12 @@ static struct pciserial_board pci_boards
 		.base_baud	= 115200,
 		.uart_offset	= 8,
 	},
+	[pbn_b0_8_115200] = {
+		.flags		= FL_BASE0,
+		.num_ports	= 8,
+		.base_baud	= 115200,
+		.uart_offset	= 8,
+	},
 
 	[pbn_b0_1_921600] = {
 		.flags		= FL_BASE0,
@@ -2697,6 +2739,97 @@ static struct pci_device_id serial_pci_t
 		pbn_pasemi_1682M },
 
 	/*
+	* ADDI-DATA GmbH communication cards <info@addi-data.com>
+	*/
+	{	PCI_VENDOR_ID_ADDIDATA,
+		PCI_DEVICE_ID_ADDIDATA_APCI7500,
+		PCI_ANY_ID,
+		PCI_ANY_ID,
+		0,
+		0,
+		pbn_b0_4_115200 },
+
+	{	PCI_VENDOR_ID_ADDIDATA,
+		PCI_DEVICE_ID_ADDIDATA_APCI7420,
+		PCI_ANY_ID,
+		PCI_ANY_ID,
+		0,
+		0,
+		pbn_b0_2_115200 },
+
+	{	PCI_VENDOR_ID_ADDIDATA,
+		PCI_DEVICE_ID_ADDIDATA_APCI7300,
+		PCI_ANY_ID,
+		PCI_ANY_ID,
+		0,
+		0,
+		pbn_b0_1_115200 },
+
+	{	PCI_VENDOR_ID_ADDIDATA_OLD,
+		PCI_DEVICE_ID_ADDIDATA_APCI7800,
+		PCI_ANY_ID,
+		PCI_ANY_ID,
+		0,
+		0,
+		pbn_b1_8_115200 },
+
+	{	PCI_VENDOR_ID_ADDIDATA,
+		PCI_DEVICE_ID_ADDIDATA_APCI7500_2,
+		PCI_ANY_ID,
+		PCI_ANY_ID,
+		0,
+		0,
+		pbn_b0_4_115200 },
+
+	{	PCI_VENDOR_ID_ADDIDATA,
+		PCI_DEVICE_ID_ADDIDATA_APCI7420_2,
+		PCI_ANY_ID,
+		PCI_ANY_ID,
+		0,
+		0,
+		pbn_b0_2_115200 },
+
+	{	PCI_VENDOR_ID_ADDIDATA,
+		PCI_DEVICE_ID_ADDIDATA_APCI7300_2,
+		PCI_ANY_ID,
+		PCI_ANY_ID,
+		0,
+		0,
+		pbn_b0_1_115200 },
+
+	{	PCI_VENDOR_ID_ADDIDATA,
+		PCI_DEVICE_ID_ADDIDATA_APCI7500_3,
+		PCI_ANY_ID,
+		PCI_ANY_ID,
+		0,
+		0,
+		pbn_b0_4_115200 },
+
+	{	PCI_VENDOR_ID_ADDIDATA,
+		PCI_DEVICE_ID_ADDIDATA_APCI7420_3,
+		PCI_ANY_ID,
+		PCI_ANY_ID,
+		0,
+		0,
+		pbn_b0_2_115200 },
+
+	{	PCI_VENDOR_ID_ADDIDATA,
+		PCI_DEVICE_ID_ADDIDATA_APCI7300_3,
+		PCI_ANY_ID,
+		PCI_ANY_ID,
+		0,
+		0,
+		pbn_b0_1_115200 },
+
+	{	PCI_VENDOR_ID_ADDIDATA,
+		PCI_DEVICE_ID_ADDIDATA_APCI7800_3,
+		PCI_ANY_ID,
+		PCI_ANY_ID,
+		0,
+		0,
+		pbn_b0_8_115200 },
+
+	/*
 	 * These entries match devices with class COMMUNICATION_SERIAL,
 	 * COMMUNICATION_MODEM or COMMUNICATION_MULTISERIAL
 	 */
diff -puN include/linux/pci_ids.h~serial-add-addi-data-gmbh-communication-cardsin8250_pcic-and-pci_idsh include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~serial-add-addi-data-gmbh-communication-cardsin8250_pcic-and-pci_idsh
+++ a/include/linux/pci_ids.h
@@ -2043,6 +2043,23 @@
 #define PCI_VENDOR_ID_QUICKNET		0x15e2
 #define PCI_DEVICE_ID_QUICKNET_XJ	0x0500
 
+/*
+ * ADDI-DATA GmbH communication cards <info@addi-data.com>
+ */
+#define PCI_VENDOR_ID_ADDIDATA_OLD             0x10E8
+#define PCI_VENDOR_ID_ADDIDATA                 0x15B8
+#define PCI_DEVICE_ID_ADDIDATA_APCI7500        0x7000
+#define PCI_DEVICE_ID_ADDIDATA_APCI7420        0x7001
+#define PCI_DEVICE_ID_ADDIDATA_APCI7300        0x7002
+#define PCI_DEVICE_ID_ADDIDATA_APCI7800        0x818E
+#define PCI_DEVICE_ID_ADDIDATA_APCI7500_2      0x7009
+#define PCI_DEVICE_ID_ADDIDATA_APCI7420_2      0x700A
+#define PCI_DEVICE_ID_ADDIDATA_APCI7300_2      0x700B
+#define PCI_DEVICE_ID_ADDIDATA_APCI7500_3      0x700C
+#define PCI_DEVICE_ID_ADDIDATA_APCI7420_3      0x700D
+#define PCI_DEVICE_ID_ADDIDATA_APCI7300_3      0x700E
+#define PCI_DEVICE_ID_ADDIDATA_APCI7800_3      0x700F
+
 #define PCI_VENDOR_ID_PDC		0x15e9
 
 #define PCI_VENDOR_ID_FARSITE           0x1619
_

Patches currently in -mm which might be from Krauth.Julien@addi-data.com are

serial-add-addi-data-gmbh-communication-cardsin8250_pcic-and-pci_idsh.patch
