From: akpm@linux-foundation.org
Subject: + serial-add-support-for-the-lava-quattro-pci-quad-port-16550a-card.patch added to -mm tree
Date: Tue, 10 Nov 2009 16:18:52 -0800
Message-ID: <200911110018.nAB0Iqi2025680@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51681 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752911AbZKKAS4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Nov 2009 19:18:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: buytenh@wantstofly.org, alan@lxorguk.ukuu.org.uk


The patch titled
     serial: add support for the Lava Quattro PCI quad-port 16550A card
has been added to the -mm tree.  Its filename is
     serial-add-support-for-the-lava-quattro-pci-quad-port-16550a-card.patch

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
Subject: serial: add support for the Lava Quattro PCI quad-port 16550A card
From: Lennert Buytenhek <buytenh@wantstofly.org>

This seems to be a different model (with a different PCI ID) than the
"Quatro" card that is also in the list.

Signed-off-by: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/serial/8250_pci.c~serial-add-support-for-the-lava-quattro-pci-quad-port-16550a-card drivers/serial/8250_pci.c
--- a/drivers/serial/8250_pci.c~serial-add-support-for-the-lava-quattro-pci-quad-port-16550a-card
+++ a/drivers/serial/8250_pci.c
@@ -3139,6 +3139,12 @@ static struct pci_device_id serial_pci_t
 	{	PCI_VENDOR_ID_LAVA, PCI_DEVICE_ID_LAVA_QUATRO_B,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_b0_bt_2_115200 },
+	{	PCI_VENDOR_ID_LAVA, PCI_DEVICE_ID_LAVA_QUATTRO_A,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		pbn_b0_bt_2_115200 },
+	{	PCI_VENDOR_ID_LAVA, PCI_DEVICE_ID_LAVA_QUATTRO_B,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		pbn_b0_bt_2_115200 },
 	{	PCI_VENDOR_ID_LAVA, PCI_DEVICE_ID_LAVA_OCTO_A,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_b0_bt_4_460800 },
diff -puN include/linux/pci_ids.h~serial-add-support-for-the-lava-quattro-pci-quad-port-16550a-card include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~serial-add-support-for-the-lava-quattro-pci-quad-port-16550a-card
+++ a/include/linux/pci_ids.h
@@ -1956,6 +1956,8 @@
 #define PCI_DEVICE_ID_LAVA_DSERIAL	0x0100 /* 2x 16550 */
 #define PCI_DEVICE_ID_LAVA_QUATRO_A	0x0101 /* 2x 16550, half of 4 port */
 #define PCI_DEVICE_ID_LAVA_QUATRO_B	0x0102 /* 2x 16550, half of 4 port */
+#define PCI_DEVICE_ID_LAVA_QUATTRO_A	0x0120 /* 2x 16550A, half of 4 port */
+#define PCI_DEVICE_ID_LAVA_QUATTRO_B	0x0121 /* 2x 16550A, half of 4 port */
 #define PCI_DEVICE_ID_LAVA_OCTO_A	0x0180 /* 4x 16550A, half of 8 port */
 #define PCI_DEVICE_ID_LAVA_OCTO_B	0x0181 /* 4x 16550A, half of 8 port */
 #define PCI_DEVICE_ID_LAVA_PORT_PLUS	0x0200 /* 2x 16650 */
_

Patches currently in -mm which might be from buytenh@wantstofly.org are

serial-fix-printk-format-specifiers-for-struct-uart_port-iobase.patch
serial-add-support-for-the-lava-quattro-pci-quad-port-16550a-card.patch
linux-next.patch

