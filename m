From: akpm@linux-foundation.org
Subject: + add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch added to -mm tree
Date: Thu, 19 Jul 2007 18:19:28 -0700
Message-ID: <200707200119.l6K1JSpn000363@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48594 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758430AbXGTBTx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 21:19:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: schmidt@digadd.de, alan@lxorguk.ukuu.org.uk, bjorn.helgaas@hp.com, rmk+lkml@arm.linux.org.uk, yinghai.lu@sun.com


The patch titled
     Add blacklisting capability to serial_pci to avoid misdetection of serial ports
has been added to the -mm tree.  Its filename is
     add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add blacklisting capability to serial_pci to avoid misdetection of serial ports
From: Christian Schmidt <schmidt@digadd.de>

The serial_pci driver tries to guess serial ports on unknown devices based
on the PCI class (modem or serial).  On certain softmodems (AC'97 modems)
this can lead to the recognition of non-existing serial ports.

This patch adds a blacklist of PCI IDs that are to be ignored by the driver.

Signed-off-by: Christian Schmidt <schmidt@digadd.de>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Yinghai Lu <yinghai.lu@sun.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_pci.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+)

diff -puN drivers/serial/8250_pci.c~add-blacklisting-capability-to-serial_pci-to-avoid-misdetection drivers/serial/8250_pci.c
--- a/drivers/serial/8250_pci.c~add-blacklisting-capability-to-serial_pci-to-avoid-misdetection
+++ a/drivers/serial/8250_pci.c
@@ -1665,6 +1665,11 @@ static struct pciserial_board pci_boards
 	},
 };
 
+static const struct pci_device_id softmodem_blacklist[] = {
+     { PCI_VDEVICE ( AL, 0x5457 ), }, /* ALi Corporation M5457 AC'97 Modem */
+     { }
+};
+
 /*
  * Given a complete unknown PCI device, try to use some heuristics to
  * guess what the configuration might be, based on the pitiful PCI
@@ -1673,6 +1678,7 @@ static struct pciserial_board pci_boards
 static int __devinit
 serial_pci_guess_board(struct pci_dev *dev, struct pciserial_board *board)
 {
+        const struct pci_device_id * blacklist;
 	int num_iomem, num_port, first_port = -1, i;
 	
 	/*
@@ -1687,6 +1693,16 @@ serial_pci_guess_board(struct pci_dev *d
 	    (dev->class & 0xff) > 6)
 		return -ENODEV;
 
+	/*
+	 * Do not access blacklisted devices that are known not to
+	 * feature serial ports.
+	 */
+	for (blacklist = softmodem_blacklist; blacklist->vendor; blacklist++) {
+	        if ((dev->vendor == blacklist->vendor) &&
+	            (dev->device == blacklist->device))
+		        return -ENODEV;
+	}
+
 	num_iomem = num_port = 0;
 	for (i = 0; i < PCI_NUM_BAR_RESOURCES; i++) {
 		if (pci_resource_flags(dev, i) & IORESOURCE_IO) {
_

Patches currently in -mm which might be from schmidt@digadd.de are

add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix.patch
