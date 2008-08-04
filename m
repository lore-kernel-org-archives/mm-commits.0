From: akpm@linux-foundation.org
Subject: - bluetooth-add-quirks-for-a-few-hci_usb-devices.patch removed from -mm tree
Date: Mon, 04 Aug 2008 13:07:18 -0700
Message-ID: <200808042007.m74K7IAZ027770@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58361 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762723AbYHDUHh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 16:07:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben.collins@canonical.com, Mario_Limonciello@Dell.com, hidave.darkstar@gmail.com, marcel@holtmann.org, michael.frey@canonical.com, tim.gardner@canonical.com, mm-commits@vger.kernel.org


The patch titled
     bluetooth: add quirks for a few hci_usb devices
has been removed from the -mm tree.  Its filename was
     bluetooth-add-quirks-for-a-few-hci_usb-devices.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bluetooth: add quirks for a few hci_usb devices
From: Ben Collins <ben.collins@canonical.com>

Preface: The "Broadcom" device is on unreleased hardware, so I can't
disclose the actual model.

When the Dell 370 and 410 BT adapters are put into BT radio mode, they
need to be prepared like many other Broadcom adapters.

Also, add quirk Broadcom 2046 devices with HCI_RESET.  Reference for this
bug: https://launchpad.net/bugs/249448

Signed-off-by: Michael Frey <michael.frey@canonical.com>
Signed-off-by: Mario Limonciello <Mario_Limonciello@Dell.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Ben Collins <ben.collins@canonical.com>
Acked-by: Marcel Holtmann <marcel@holtmann.org>
Cc: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/bluetooth/hci_usb.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/bluetooth/hci_usb.c~bluetooth-add-quirks-for-a-few-hci_usb-devices drivers/bluetooth/hci_usb.c
--- a/drivers/bluetooth/hci_usb.c~bluetooth-add-quirks-for-a-few-hci_usb-devices
+++ a/drivers/bluetooth/hci_usb.c
@@ -134,6 +134,13 @@ static struct usb_device_id blacklist_id
 
 	/* Dell laptop with Broadcom chip */
 	{ USB_DEVICE(0x413c, 0x8126), .driver_info = HCI_RESET | HCI_WRONG_SCO_MTU },
+	/* Dell Wireless 370 */
+	{ USB_DEVICE(0x413c, 0x8156), .driver_info = HCI_RESET | HCI_WRONG_SCO_MTU },
+	/* Dell Wireless 410 */
+	{ USB_DEVICE(0x413c, 0x8152), .driver_info = HCI_RESET | HCI_WRONG_SCO_MTU },
+
+	/* Broadcom 2046 */
+	{ USB_DEVICE(0x0a5c, 0x2151), .driver_info = HCI_RESET },
 
 	/* Microsoft Wireless Transceiver for Bluetooth 2.0 */
 	{ USB_DEVICE(0x045e, 0x009c), .driver_info = HCI_RESET },
_

Patches currently in -mm which might be from ben.collins@canonical.com are

origin.patch
pegasus-add-blacklist-support-to-fix-belkin-bluetooth-dongle.patch

