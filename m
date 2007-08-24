From: akpm@linux-foundation.org
Subject: - add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:55:37 -0700
Message-ID: <200708242055.l7OKtbaN013972@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47197 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756819AbXHXU41 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 16:56:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: schmidt@digadd.de, alan@lxorguk.ukuu.org.uk, bjorn.helgaas@hp.com, rmk+lkml@arm.linux.org.uk, yinghai.lu@sun.com, mm-commits@vger.kernel.org


The patch titled
     Add blacklisting capability to serial_pci to avoid misdetection of serial ports
has been removed from the -mm tree.  Its filename was
     add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add blacklisting capability to serial_pci to avoid misdetection of serial ports
From: Christian Schmidt <schmidt@digadd.de>

The serial_pci driver tries to guess serial ports on unknown devices based
on the PCI class (modem or serial).  On certain softmodems (AC'97 modems)
this can lead to the recognition of non-existing serial ports.

This patch adds a blacklist of PCI IDs that are to be ignored by the driver.

[akpm@linux-foundation.org: cleanups]
Signed-off-by: Christian Schmidt <schmidt@digadd.de>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Yinghai Lu <yinghai.lu@sun.com>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_pci.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+)

diff -puN drivers/serial/8250_pci.c~add-blacklisting-capability-to-serial_pci-to-avoid-misdetection drivers/serial/8250_pci.c
--- a/drivers/serial/8250_pci.c~add-blacklisting-capability-to-serial_pci-to-avoid-misdetection
+++ a/drivers/serial/8250_pci.c
@@ -1652,6 +1652,10 @@ static struct pciserial_board pci_boards
 	},
 };
 
+static const struct pci_device_id softmodem_blacklist[] = {
+	{ PCI_VDEVICE ( AL, 0x5457 ), }, /* ALi Corporation M5457 AC'97 Modem */
+};
+
 /*
  * Given a complete unknown PCI device, try to use some heuristics to
  * guess what the configuration might be, based on the pitiful PCI
@@ -1660,6 +1664,7 @@ static struct pciserial_board pci_boards
 static int __devinit
 serial_pci_guess_board(struct pci_dev *dev, struct pciserial_board *board)
 {
+	const struct pci_device_id *blacklist;
 	int num_iomem, num_port, first_port = -1, i;
 	
 	/*
@@ -1674,6 +1679,18 @@ serial_pci_guess_board(struct pci_dev *d
 	    (dev->class & 0xff) > 6)
 		return -ENODEV;
 
+	/*
+	 * Do not access blacklisted devices that are known not to
+	 * feature serial ports.
+	 */
+	for (blacklist = softmodem_blacklist;
+	     blacklist < softmodem_blacklist + ARRAY_SIZE(softmodem_blacklist);
+	     blacklist++) {
+		if (dev->vendor == blacklist->vendor &&
+		    dev->device == blacklist->device)
+			return -ENODEV;
+	}
+
 	num_iomem = num_port = 0;
 	for (i = 0; i < PCI_NUM_BAR_RESOURCES; i++) {
 		if (pci_resource_flags(dev, i) & IORESOURCE_IO) {
_

Patches currently in -mm which might be from schmidt@digadd.de are

origin.patch
