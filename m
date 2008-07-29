From: akpm@linux-foundation.org
Subject: + pegasus-add-blacklist-support-to-fix-belkin-bluetooth-dongle.patch added to -mm tree
Date: Mon, 28 Jul 2008 19:50:37 -0700
Message-ID: <200807290250.m6T2obpR010450@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50502 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752481AbYG2Cvu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jul 2008 22:51:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben.collins@canonical.com, david-b@pacbell.net, gregkh@suse.de, jeff@garzik.org, stefan.bader@canonical.com


The patch titled
     pegasus: add blacklist support to fix Belkin bluetooth dongle.
has been added to the -mm tree.  Its filename is
     pegasus-add-blacklist-support-to-fix-belkin-bluetooth-dongle.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pegasus: add blacklist support to fix Belkin bluetooth dongle.
From: Ben Collins <ben.collins@canonical.com>

Reference: https://launchpad.net/bugs/140511

The Belkin bluetooth dongle unfortunately shares the vendor and device id
with the network adapter which causes lockups whenever the bluetooth
dongle is inserted.

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Ben Collins <ben.collins@canonical.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/usb/pegasus.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff -puN drivers/net/usb/pegasus.c~pegasus-add-blacklist-support-to-fix-belkin-bluetooth-dongle drivers/net/usb/pegasus.c
--- a/drivers/net/usb/pegasus.c~pegasus-add-blacklist-support-to-fix-belkin-bluetooth-dongle
+++ a/drivers/net/usb/pegasus.c
@@ -1285,6 +1285,21 @@ static void check_carrier(struct work_st
 	}
 }
 
+static int pegasus_blacklisted(struct usb_device *udev)
+{
+	struct usb_device_descriptor *udd = &udev->descriptor;
+
+	/* Special quirk to keep the driver from handling the Belkin Bluetooth
+	 * dongle which happens to have the same ID.
+	 */
+	if ((udd->idVendor == VENDOR_BELKIN && udd->idProduct == 0x0121) &&
+	    (udd->bDeviceClass == USB_CLASS_WIRELESS_CONTROLLER) &&
+	    (udd->bDeviceProtocol == 1))
+		return 1;
+
+	return 0;
+}
+
 static int pegasus_probe(struct usb_interface *intf,
 			 const struct usb_device_id *id)
 {
@@ -1296,6 +1311,12 @@ static int pegasus_probe(struct usb_inte
 	DECLARE_MAC_BUF(mac);
 
 	usb_get_dev(dev);
+
+	if (pegasus_blacklisted(dev)) {
+		res = -ENODEV;
+		goto out;
+	}
+
 	net = alloc_etherdev(sizeof(struct pegasus));
 	if (!net) {
 		dev_err(&intf->dev, "can't allocate %s\n", "device");
_

Patches currently in -mm which might be from ben.collins@canonical.com are

origin.patch
bluetooth-add-quirks-for-a-few-hci_usb-devices.patch
nsc-ircc-default-to-dongle-type-9-on-ibm-hardware.patch
pegasus-add-blacklist-support-to-fix-belkin-bluetooth-dongle.patch

