From: akpm@linux-foundation.org
Subject: + parport-parport_serial-dont-bind-netmos-ibm-0299.patch added to -mm tree
Date: Tue, 10 Feb 2009 12:42:52 -0800
Message-ID: <200902102042.n1AKgq8Z014305@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44558 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754830AbZBJUm4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Feb 2009 15:42:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     parport: parport_serial, don't bind netmos ibm 0299
has been added to the -mm tree.  Its filename is
     parport-parport_serial-dont-bind-netmos-ibm-0299.patch

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

linux-next.patch
pci-quirks-dont-mark-one-netmos-as-class-other.patch
tty-pty-lookup-retval-fixup.patch
parport-parport_serial-dont-bind-netmos-ibm-0299.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

