From: akpm@linux-foundation.org
Subject: + serial-add-addi-data-gmbh-pci-express-communication-cards-in-8250_pcic-and-pci_idsh.patch added to -mm tree
Date: Tue, 13 Oct 2009 19:01:56 -0700
Message-ID: <200910140201.n9E21u8A003402@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54410 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752643AbZJNCCp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Oct 2009 22:02:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Krauth.Julien@addi-data.com, alan@lxorguk.ukuu.org.uk


The patch titled
     serial: add ADDI-DATA GmbH PCI-Express communication cards in 8250_pci.c and pci_ids.h
has been added to the -mm tree.  Its filename is
     serial-add-addi-data-gmbh-pci-express-communication-cards-in-8250_pcic-and-pci_idsh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial: add ADDI-DATA GmbH PCI-Express communication cards in 8250_pci.c and pci_ids.h
From: "Krauth.Julien" <Krauth.Julien@addi-data.com>

Add support for ADDI-DATA GmbH PCI-Express communication cards:

APCIe-7300
APCIe-7420
APCIe-7500
APCIe-7800

Warning: 8250_pci.c depends on pci_ids.h. 8250_pci.c

Signed-off-by: Krauth Julien <Krauth.Julien@addi-data.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_pci.c |   67 ++++++++++++++++++++++++++++++++++++
 include/linux/pci_ids.h   |    4 ++
 2 files changed, 71 insertions(+)

diff -puN drivers/serial/8250_pci.c~serial-add-addi-data-gmbh-pci-express-communication-cards-in-8250_pcic-and-pci_idsh drivers/serial/8250_pci.c
--- a/drivers/serial/8250_pci.c~serial-add-addi-data-gmbh-pci-express-communication-cards-in-8250_pcic-and-pci_idsh
+++ a/drivers/serial/8250_pci.c
@@ -1566,6 +1566,10 @@ enum pci_board_num_t {
 	pbn_ni8430_4,
 	pbn_ni8430_8,
 	pbn_ni8430_16,
+	pbn_ADDIDATA_PCIe_1_3906250,
+	pbn_ADDIDATA_PCIe_2_3906250,
+	pbn_ADDIDATA_PCIe_4_3906250,
+	pbn_ADDIDATA_PCIe_8_3906250,
 };
 
 /*
@@ -2185,6 +2189,37 @@ static struct pciserial_board pci_boards
 		.uart_offset	= 0x10,
 		.first_offset	= 0x800,
 	},
+	/*
+	 * ADDI-DATA GmbH PCI-Express communication cards <info@addi-data.com>
+	 */
+	[pbn_ADDIDATA_PCIe_1_3906250] = {
+		.flags		= FL_BASE0,
+		.num_ports	= 1,
+		.base_baud	= 3906250,
+		.uart_offset	= 0x200,
+		.first_offset	= 0x1000,
+	},
+	[pbn_ADDIDATA_PCIe_2_3906250] = {
+		.flags		= FL_BASE0,
+		.num_ports	= 2,
+		.base_baud	= 3906250,
+		.uart_offset	= 0x200,
+		.first_offset	= 0x1000,
+	},
+	[pbn_ADDIDATA_PCIe_4_3906250] = {
+		.flags		= FL_BASE0,
+		.num_ports	= 4,
+		.base_baud	= 3906250,
+		.uart_offset	= 0x200,
+		.first_offset	= 0x1000,
+	},
+	[pbn_ADDIDATA_PCIe_8_3906250] = {
+		.flags		= FL_BASE0,
+		.num_ports	= 8,
+		.base_baud	= 3906250,
+		.uart_offset	= 0x200,
+		.first_offset	= 0x1000,
+	},
 };
 
 static const struct pci_device_id softmodem_blacklist[] = {
@@ -3556,6 +3591,38 @@ static struct pci_device_id serial_pci_t
 		0,
 		pbn_b0_8_115200 },
 
+	{	PCI_VENDOR_ID_ADDIDATA,
+		PCI_DEVICE_ID_ADDIDATA_APCIe7500,
+		PCI_ANY_ID,
+		PCI_ANY_ID,
+		0,
+		0,
+		pbn_ADDIDATA_PCIe_4_3906250 },
+
+	{	PCI_VENDOR_ID_ADDIDATA,
+		PCI_DEVICE_ID_ADDIDATA_APCIe7420,
+		PCI_ANY_ID,
+		PCI_ANY_ID,
+		0,
+		0,
+		pbn_ADDIDATA_PCIe_2_3906250 },
+
+	{	PCI_VENDOR_ID_ADDIDATA,
+		PCI_DEVICE_ID_ADDIDATA_APCIe7300,
+		PCI_ANY_ID,
+		PCI_ANY_ID,
+		0,
+		0,
+		pbn_ADDIDATA_PCIe_1_3906250 },
+
+	{	PCI_VENDOR_ID_ADDIDATA,
+		PCI_DEVICE_ID_ADDIDATA_APCIe7800,
+		PCI_ANY_ID,
+		PCI_ANY_ID,
+		0,
+		0,
+		pbn_ADDIDATA_PCIe_8_3906250 },
+
 	{	PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9835,
 		PCI_VENDOR_ID_IBM, 0x0299,
 		0, 0, pbn_b0_bt_2_115200 },
diff -puN include/linux/pci_ids.h~serial-add-addi-data-gmbh-pci-express-communication-cards-in-8250_pcic-and-pci_idsh include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~serial-add-addi-data-gmbh-pci-express-communication-cards-in-8250_pcic-and-pci_idsh
+++ a/include/linux/pci_ids.h
@@ -2162,6 +2162,10 @@
 #define PCI_DEVICE_ID_ADDIDATA_APCI7420_3      0x700D
 #define PCI_DEVICE_ID_ADDIDATA_APCI7300_3      0x700E
 #define PCI_DEVICE_ID_ADDIDATA_APCI7800_3      0x700F
+#define PCI_DEVICE_ID_ADDIDATA_APCIe7300       0x7010
+#define PCI_DEVICE_ID_ADDIDATA_APCIe7420       0x7011
+#define PCI_DEVICE_ID_ADDIDATA_APCIe7500       0x7012
+#define PCI_DEVICE_ID_ADDIDATA_APCIe7800       0x7013
 
 #define PCI_VENDOR_ID_PDC		0x15e9
 
_

Patches currently in -mm which might be from Krauth.Julien@addi-data.com are

serial-add-addi-data-gmbh-pci-express-communication-cards-in-8250_pcic-and-pci_idsh.patch

