From: akpm@linux-foundation.org
Subject: - hci_usb-another-device-with-buggy-sco-support.patch removed from -mm tree
Date: Wed, 05 Mar 2008 01:01:14 -0800
Message-ID: <200803050901.m2591EAr024440@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56496 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752086AbYCEJB5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 04:01:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dsd@gentoo.org, greg@kroah.com, marcel@holtmann.org, mm-commits@vger.kernel.org


The patch titled
     hci_usb: another device with buggy SCO support
has been removed from the -mm tree.  Its filename was
     hci_usb-another-device-with-buggy-sco-support.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hci_usb: another device with buggy SCO support
From: Daniel Drake <dsd@gentoo.org>

As reported at:
https://bugs.gentoo.org/show_bug.cgi?id=203196
https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.22/+bug/152689

This unbranded bluetooth USB dongle causes the following message to
repeatedly appear in the kernel logs:
    hci_scodata_packet: hci0 SCO packet for unknown connection handle 92

This patch solves the issue. I'm not sure of its correctness, it is based
on work by Ossi Berg and Tim Gardner on the Ubuntu bug tracker.

Signed-off-by: Daniel Drake <dsd@gentoo.org>
Cc: Greg KH <greg@kroah.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/bluetooth/hci_usb.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/bluetooth/hci_usb.c~hci_usb-another-device-with-buggy-sco-support drivers/bluetooth/hci_usb.c
--- a/drivers/bluetooth/hci_usb.c~hci_usb-another-device-with-buggy-sco-support
+++ a/drivers/bluetooth/hci_usb.c
@@ -162,6 +162,9 @@ static struct usb_device_id blacklist_id
 	/* Frontline ComProbe Bluetooth Sniffer */
 	{ USB_DEVICE(0x16d3, 0x0002), .driver_info = HCI_SNIFFER },
 
+	/* Generic/no-name device with buggy SCO support */
+	{ USB_DEVICE(0x0e5e, 0x6622), .driver_info = HCI_BROKEN_ISOC },
+
 	{ }	/* Terminating entry */
 };
 
_

Patches currently in -mm which might be from dsd@gentoo.org are

hci_usb-another-device-with-buggy-sco-support.patch

