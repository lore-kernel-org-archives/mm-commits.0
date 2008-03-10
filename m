From: akpm@linux-foundation.org
Subject: - bluetooth-add-another-broadcom-device.patch removed from -mm tree
Date: Mon, 10 Mar 2008 11:05:33 -0700
Message-ID: <200803101805.m2AI5XPX030109@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49922 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751283AbYCJSGO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 14:06:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kkeil@suse.de, hidave.darkstar@gmail.com, marcel@holtmann.org, mm-commits@vger.kernel.org


The patch titled
     bluetooth: add another Broadcom device
has been removed from the -mm tree.  Its filename was
     bluetooth-add-another-broadcom-device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bluetooth: add another Broadcom device
From: Karsten Keil <kkeil@suse.de>

Add another Broadcom BCM2045 based device to the blacklist, with these
settings the micro dongle works on my system.

Signed-off-by: Karsten Keil <kkeil@suse.de>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/bluetooth/hci_usb.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/bluetooth/hci_usb.c~bluetooth-add-another-broadcom-device drivers/bluetooth/hci_usb.c
--- a/drivers/bluetooth/hci_usb.c~bluetooth-add-another-broadcom-device
+++ a/drivers/bluetooth/hci_usb.c
@@ -116,6 +116,7 @@ static struct usb_device_id blacklist_id
 	{ USB_DEVICE(0x0a5c, 0x2009), .driver_info = HCI_BCM92035 },
 
 	/* Broadcom BCM2045 */
+	{ USB_DEVICE(0x0a5c, 0x2039), .driver_info = HCI_RESET | HCI_WRONG_SCO_MTU },
 	{ USB_DEVICE(0x0a5c, 0x2101), .driver_info = HCI_RESET | HCI_WRONG_SCO_MTU },
 
 	/* IBM/Lenovo ThinkPad with Broadcom chip */
_

Patches currently in -mm which might be from kkeil@suse.de are

capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
isdn-replace-remaining-__function__-occurrences.patch
isdn_tty-prepare-for-bkl-push-down.patch

