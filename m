From: akpm@linux-foundation.org
Subject: - perle-multimodem-card-pci-ras-detection.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:54:00 -0800
Message-ID: <200702112254.l1BMs0Qr016161@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60464 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932858AbXBKWyT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:54:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: thomas.hoehn@avocent.com, alan@lxorguk.ukuu.org.uk, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Perle multimodem card (PCI-RAS) detection
has been removed from the -mm tree.  Its filename was
     perle-multimodem-card-pci-ras-detection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Perle multimodem card (PCI-RAS) detection
From: Thomas Hoehn <thomas.hoehn@avocent.com>

Get the Perle quad-modem PCI card (PCI-RAS4) detected by serial driver.  It
may also get the PCI-RAS8 running, but can't guarantee as I didn't had one for
testing.

Signed-off-by: Thomas Hoehn <thomas.hoehn@avocent.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250.c     |    8 ++++++--
 drivers/serial/8250_pci.c |   16 ++++++++++++++++
 include/linux/pci_ids.h   |    5 +++++
 3 files changed, 27 insertions(+), 2 deletions(-)

diff -puN drivers/serial/8250.c~perle-multimodem-card-pci-ras-detection drivers/serial/8250.c
--- a/drivers/serial/8250.c~perle-multimodem-card-pci-ras-detection
+++ a/drivers/serial/8250.c
@@ -920,12 +920,16 @@ static void autoconfig(struct uart_8250_
 #ifdef __i386__
 		outb(0xff, 0x080);
 #endif
-		scratch2 = serial_inp(up, UART_IER);
+		/*
+		 * Mask out IER[7:4] bits for test as some UARTs (e.g. TL
+		 * 16C754B) allow only to modify them if an EFR bit is set.
+		 */
+		scratch2 = serial_inp(up, UART_IER) & 0x0f;
 		serial_outp(up, UART_IER, 0x0F);
 #ifdef __i386__
 		outb(0, 0x080);
 #endif
-		scratch3 = serial_inp(up, UART_IER);
+		scratch3 = serial_inp(up, UART_IER) & 0x0f;
 		serial_outp(up, UART_IER, scratch);
 		if (scratch2 != 0 || scratch3 != 0x0F) {
 			/*
diff -puN drivers/serial/8250_pci.c~perle-multimodem-card-pci-ras-detection drivers/serial/8250_pci.c
--- a/drivers/serial/8250_pci.c~perle-multimodem-card-pci-ras-detection
+++ a/drivers/serial/8250_pci.c
@@ -679,6 +679,13 @@ static struct pci_serial_quirk pci_seria
 	 */
 	{
 		.vendor		= PCI_VENDOR_ID_PLX,
+		.device		= PCI_DEVICE_ID_PLX_9030,
+		.subvendor	= PCI_SUBVENDOR_ID_PERLE,
+		.subdevice	= PCI_ANY_ID,
+		.setup		= pci_default_setup,
+	},
+	{
+		.vendor		= PCI_VENDOR_ID_PLX,
 		.device		= PCI_DEVICE_ID_PLX_9050,
 		.subvendor	= PCI_SUBVENDOR_ID_EXSYS,
 		.subdevice	= PCI_SUBDEVICE_ID_EXSYS_4055,
@@ -2379,6 +2386,15 @@ static struct pci_device_id serial_pci_t
 		pbn_b2_2_115200 },
 
 	/*
+	 * Perle PCI-RAS cards
+	 */
+	{       PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9030,
+		PCI_SUBVENDOR_ID_PERLE, PCI_SUBDEVICE_ID_PCI_RAS4,
+		0, 0, pbn_b2_4_921600 },
+	{       PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9030,
+		PCI_SUBVENDOR_ID_PERLE, PCI_SUBDEVICE_ID_PCI_RAS8,
+		0, 0, pbn_b2_8_921600 },
+	/*
 	 * These entries match devices with class COMMUNICATION_SERIAL,
 	 * COMMUNICATION_MODEM or COMMUNICATION_MULTISERIAL
 	 */
diff -puN include/linux/pci_ids.h~perle-multimodem-card-pci-ras-detection include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~perle-multimodem-card-pci-ras-detection
+++ a/include/linux/pci_ids.h
@@ -959,6 +959,7 @@
 #define PCI_DEVICE_ID_PLX_R753		0x1152
 #define PCI_DEVICE_ID_PLX_OLITEC	0x1187
 #define PCI_DEVICE_ID_PLX_PCI200SYN	0x3196
+#define PCI_DEVICE_ID_PLX_9030          0x9030
 #define PCI_DEVICE_ID_PLX_9050		0x9050
 #define PCI_DEVICE_ID_PLX_9080		0x9080
 #define PCI_DEVICE_ID_PLX_GTEK_SERIAL2	0xa001
@@ -1994,6 +1995,10 @@
 
 #define PCI_VENDOR_ID_CHELSIO		0x1425
 
+#define PCI_SUBVENDOR_ID_PERLE          0x155f
+#define PCI_SUBDEVICE_ID_PCI_RAS4       0xf001
+#define PCI_SUBDEVICE_ID_PCI_RAS8       0xf010
+
 
 #define PCI_VENDOR_ID_SYBA		0x1592
 #define PCI_DEVICE_ID_SYBA_2P_EPP	0x0782
_

Patches currently in -mm which might be from thomas.hoehn@avocent.com are

origin.patch
