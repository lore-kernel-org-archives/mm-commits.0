From: akpm@linux-foundation.org
Subject: [merged] parport-parport_serial-dont-bind-netmos-ibm-0299.patch removed from -mm tree
Date: Thu, 12 Feb 2009 12:25:57 -0800
Message-ID: <200902122025.n1CKPv5U015410@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57541 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759293AbZBLUfL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Feb 2009 15:35:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     parport: parport_serial, don't bind netmos ibm 0299
has been removed from the -mm tree.  Its filename was
     parport-parport_serial-dont-bind-netmos-ibm-0299.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: parport: parport_serial, don't bind netmos ibm 0299
From: Jiri Slaby <jirislaby@gmail.com>

Since netmos 9835 with subids 0x1014(IBM):0x0299 is now bound with
serial/8250_pci, because it has no parallel ports and subdevice id isn't
in the expected form, return -ENODEV from probe function.

This is performed in netmos preinit_hook.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parport/parport_serial.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/parport/parport_serial.c~parport-parport_serial-dont-bind-netmos-ibm-0299 drivers/parport/parport_serial.c
--- a/drivers/parport/parport_serial.c~parport-parport_serial-dont-bind-netmos-ibm-0299
+++ a/drivers/parport/parport_serial.c
@@ -64,6 +64,11 @@ struct parport_pc_pci {
 
 static int __devinit netmos_parallel_init(struct pci_dev *dev, struct parport_pc_pci *card, int autoirq, int autodma)
 {
+	/* the rule described below doesn't hold for this device */
+	if (dev->device == PCI_DEVICE_ID_NETMOS_9835 &&
+			dev->subsystem_vendor == PCI_VENDOR_ID_IBM &&
+			dev->subsystem_device == 0x0299)
+		return -ENODEV;
 	/*
 	 * Netmos uses the subdevice ID to indicate the number of parallel
 	 * and serial ports.  The form is 0x00PS, where <P> is the number of
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
linux-next.patch
pci-quirks-dont-mark-one-netmos-as-class-other.patch
tty-pty-lookup-retval-fixup.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

