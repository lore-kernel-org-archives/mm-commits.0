From: akpm@linux-foundation.org
Subject: + hci_usb-another-device-with-buggy-sco-support.patch added to -mm tree
Date: Tue, 12 Feb 2008 15:57:38 -0800
Message-ID: <200802122357.m1CNvc39029785@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34588 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752591AbYBLX5r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Feb 2008 18:57:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dsd@gentoo.org, greg@kroah.com, marcel@holtmann.org


The patch titled
     hci_usb: another device with buggy SCO support
has been added to the -mm tree.  Its filename is
     hci_usb-another-device-with-buggy-sco-support.patch

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

origin.patch
pci-disable-decoding-during-sizing-of-bars.patch
hci_usb-another-device-with-buggy-sco-support.patch
