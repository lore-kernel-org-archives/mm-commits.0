From: akpm@linux-foundation.org
Subject: - bluetooth-add-sco-work-around-for-the-broadcom.patch removed from -mm tree
Date: Sun, 06 May 2007 23:50:00 -0700
Message-ID: <200705070650.l476o0NW020512@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52744 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754069AbXEGGua (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 02:50:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: x@jeffhansen.com, marcel@holtmann.org, mm-commits@vger.kernel.org


The patch titled
     bluetooth: add SCO work-around for the Broadcom 2045
has been removed from the -mm tree.  Its filename was
     bluetooth-add-sco-work-around-for-the-broadcom.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: bluetooth: add SCO work-around for the Broadcom 2045
From: Jeff Hansen <x@jeffhansen.com>

Enable the necessary SCO work-around for the Broadcom 2045 chip, which comes
in the most recent IOGear dongles.

Cc: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/bluetooth/hci_usb.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/bluetooth/hci_usb.c~bluetooth-add-sco-work-around-for-the-broadcom drivers/bluetooth/hci_usb.c
--- a/drivers/bluetooth/hci_usb.c~bluetooth-add-sco-work-around-for-the-broadcom
+++ a/drivers/bluetooth/hci_usb.c
@@ -114,6 +114,9 @@ static struct usb_device_id blacklist_id
 	{ USB_DEVICE(0x0a5c, 0x200a), .driver_info = HCI_RESET | HCI_WRONG_SCO_MTU },
 	{ USB_DEVICE(0x0a5c, 0x2009), .driver_info = HCI_BCM92035 },
 
+	/* Broadcom BCM2045 */
+	{ USB_DEVICE(0x0a5c, 0x2101), .driver_info = HCI_WRONG_SCO_MTU },
+
 	/* IBM/Lenovo ThinkPad with Broadcom chip */
 	{ USB_DEVICE(0x0a5c, 0x201e), .driver_info = HCI_WRONG_SCO_MTU },
 	{ USB_DEVICE(0x0a5c, 0x2110), .driver_info = HCI_WRONG_SCO_MTU },
_

Patches currently in -mm which might be from x@jeffhansen.com are
