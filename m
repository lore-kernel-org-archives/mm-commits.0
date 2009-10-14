From: akpm@linux-foundation.org
Subject: + 8250_pci-add-ibm-saturn-serial-card.patch added to -mm tree
Date: Tue, 13 Oct 2009 19:41:52 -0700
Message-ID: <200910140241.n9E2fqWi022032@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34386 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761505AbZJNCno (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Oct 2009 22:43:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: benh@kernel.crashing.org, alan@lxorguk.ukuu.org.uk, mreed10@us.ibm.com, stable@kernel.org


The patch titled
     8250_pci: add IBM Saturn serial card
has been added to the -mm tree.  Its filename is
     8250_pci-add-ibm-saturn-serial-card.patch

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
Subject: 8250_pci: add IBM Saturn serial card
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

The IBM Saturn serial card has only one port. Without that fixup,
the kernel thinks it has two, which confuses userland setup and
admin tools as well.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Michael Reed <mreed10@us.ibm.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_pci.c |   11 +++++++++++
 include/linux/pci_ids.h   |    2 ++
 2 files changed, 13 insertions(+)

diff -puN drivers/serial/8250_pci.c~8250_pci-add-ibm-saturn-serial-card drivers/serial/8250_pci.c
--- a/drivers/serial/8250_pci.c~8250_pci-add-ibm-saturn-serial-card
+++ a/drivers/serial/8250_pci.c
@@ -1561,6 +1561,7 @@ enum pci_board_num_t {
 	pbn_exar_XR17C152,
 	pbn_exar_XR17C154,
 	pbn_exar_XR17C158,
+	pbn_exar_ibm_saturn,
 	pbn_pasemi_1682M,
 	pbn_ni8430_2,
 	pbn_ni8430_4,
@@ -2150,6 +2151,13 @@ static struct pciserial_board pci_boards
 		.base_baud	= 921600,
 		.uart_offset	= 0x200,
 	},
+	[pbn_exar_ibm_saturn] = {
+		.flags		= FL_BASE0,
+		.num_ports	= 1,
+		.base_baud	= 921600,
+		.uart_offset	= 0x200,
+	},
+
 	/*
 	 * PA Semi PWRficient PA6T-1682M on-chip UART
 	 */
@@ -2684,6 +2692,9 @@ static struct pci_device_id serial_pci_t
 		PCI_SUBVENDOR_ID_CONNECT_TECH,
 		PCI_SUBDEVICE_ID_CONNECT_TECH_PCI_UART_8_485, 0, 0,
 		pbn_b0_8_1843200_200 },
+	{	PCI_VENDOR_ID_EXAR, PCI_DEVICE_ID_EXAR_XR17C152,
+		PCI_VENDOR_ID_IBM, PCI_SUBDEVICE_ID_IBM_SATURN_SERIAL_ONE_PORT,
+		0, 0, pbn_exar_ibm_saturn },
 
 	{	PCI_VENDOR_ID_SEALEVEL, PCI_DEVICE_ID_SEALEVEL_U530,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
diff -puN include/linux/pci_ids.h~8250_pci-add-ibm-saturn-serial-card include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~8250_pci-add-ibm-saturn-serial-card
+++ a/include/linux/pci_ids.h
@@ -484,6 +484,8 @@
 #define PCI_DEVICE_ID_IBM_ICOM_V2_ONE_PORT_RVX_ONE_PORT_MDM	0x0251
 #define PCI_DEVICE_ID_IBM_ICOM_V2_ONE_PORT_RVX_ONE_PORT_MDM_PCIE 0x0361
 #define PCI_DEVICE_ID_IBM_ICOM_FOUR_PORT_MODEL	0x252
+#define PCI_SUBVENDOR_ID_IBM		0x1014
+#define PCI_SUBDEVICE_ID_IBM_SATURN_SERIAL_ONE_PORT	0x03d4
 
 #define PCI_VENDOR_ID_UNISYS		0x1018
 #define PCI_DEVICE_ID_UNISYS_DMA_DIRECTOR 0x001C
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

linux-next.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
8250_pci-add-ibm-saturn-serial-card.patch
mm-add-notifier-in-pageblock-isolation-for-balloon-drivers.patch
powerpc-make-the-cmm-memory-hotplug-aware.patch
bitmap-introduce-bitmap_set-bitmap_clear-bitmap_find_next_zero_area.patch
iommu-helper-use-bitmap-library.patch

