From: akpm@linux-foundation.org
Subject: + bluetooth-blacklist-another-broadcom-bcm2035-device.patch added to -mm tree
Date: Fri, 02 Nov 2007 13:59:04 -0700
Message-ID: <200711022059.lA2Kx4IG010688@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48652 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751550AbXKBU7W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Nov 2007 16:59:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andy@smile.org.ua, marcel@holtmann.org


The patch titled
     bluetooth: blacklist another Broadcom BCM2035 device
has been added to the -mm tree.  Its filename is
     bluetooth-blacklist-another-broadcom-bcm2035-device.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: bluetooth: blacklist another Broadcom BCM2035 device
From: Andy Shevchenko <andy@smile.org.ua>

This device is recognized as bluetooth, but still not works.

Signed-off-by: Andy Shevchenko <andy@smile.org.ua>
Cc: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/bluetooth/hci_usb.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/bluetooth/hci_usb.c~bluetooth-blacklist-another-broadcom-bcm2035-device drivers/bluetooth/hci_usb.c
--- a/drivers/bluetooth/hci_usb.c~bluetooth-blacklist-another-broadcom-bcm2035-device
+++ a/drivers/bluetooth/hci_usb.c
@@ -111,6 +111,7 @@ static struct usb_device_id blacklist_id
 	{ USB_DEVICE(0x0a5c, 0x2033), .driver_info = HCI_IGNORE },
 
 	/* Broadcom BCM2035 */
+	{ USB_DEVICE(0x0a5c, 0x2035), .driver_info = HCI_RESET | HCI_WRONG_SCO_MTU },
 	{ USB_DEVICE(0x0a5c, 0x200a), .driver_info = HCI_RESET | HCI_WRONG_SCO_MTU },
 	{ USB_DEVICE(0x0a5c, 0x2009), .driver_info = HCI_BCM92035 },
 
_

Patches currently in -mm which might be from andy@smile.org.ua are

bluetooth-blacklist-another-broadcom-bcm2035-device.patch
