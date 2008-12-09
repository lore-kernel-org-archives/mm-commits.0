From: akpm@linux-foundation.org
Subject: + 8250_pci-add-support-for-netmos-9835.patch added to -mm tree
Date: Mon, 08 Dec 2008 16:29:35 -0800
Message-ID: <200812090029.mB90TZhK013791@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33459 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753718AbYLIA3q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Dec 2008 19:29:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk


The patch titled
     8250_pci: add support for netmos 9835
has been added to the -mm tree.  Its filename is
     8250_pci-add-support-for-netmos-9835.patch

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
Subject: 8250_pci: add support for netmos 9835
From: Jiri Slaby <jirislaby@gmail.com>

Most of netmos 9835 hardware is handled by parport-serial.  IBM introduces
a device which doesn't have any parallel ports and have screwed subdevice
PCI id (not corresponding to port numbers).

Handle this device (9710:9835 1014:0299) properly.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_pci.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN drivers/serial/8250_pci.c~8250_pci-add-support-for-netmos-9835 drivers/serial/8250_pci.c
--- a/drivers/serial/8250_pci.c~8250_pci-add-support-for-netmos-9835
+++ a/drivers/serial/8250_pci.c
@@ -600,6 +600,10 @@ static int pci_netmos_init(struct pci_de
 	/* subdevice 0x00PS means <P> parallel, <S> serial */
 	unsigned int num_serial = dev->subsystem_device & 0xf;
 
+	if (dev->subsystem_vendor == PCI_VENDOR_ID_IBM &&
+			dev->subsystem_device == 0x0299)
+		return 0;
+
 	if (num_serial == 0)
 		return -ENODEV;
 	return num_serial;
@@ -3091,6 +3095,10 @@ static struct pci_device_id serial_pci_t
 		0,
 		pbn_b0_8_115200 },
 
+	{	PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9835,
+		PCI_VENDOR_ID_IBM, 0x0299,
+		0, 0, pbn_b0_bt_2_115200 },
+
 	/*
 	 * These entries match devices with class COMMUNICATION_SERIAL,
 	 * COMMUNICATION_MODEM or COMMUNICATION_MULTISERIAL
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
linux-next.patch
hid-dont-allow-dealextreme-usb-radio-be-handled-by-usb-hid-driver.patch
ata-piix-fix-pointer-deref-on-suspend.patch
drivers-char-cycladesc-cy_pci_probe-fix-error-path.patch
pci-quirks-dont-mark-one-netmos-as-class-other.patch
8250_pci-add-support-for-netmos-9835.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

