From: akpm@linux-foundation.org
Subject: + hid-add-quirk_hiddev-for-belkin-flip-kvm.patch added to -mm tree
Date: Sun, 08 Apr 2007 02:22:50 -0700
Message-ID: <200704080922.l389MoV7019956@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45365 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbXDHJXF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 8 Apr 2007 05:23:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dengel@sourceharvest.com, dtor@mail.ru, greg@kroah.com, jikos@jikos.cz


The patch titled
     hid: add QUIRK_HIDDEV for Belkin Flip KVM
has been added to the -mm tree.  Its filename is
     hid-add-quirk_hiddev-for-belkin-flip-kvm.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: hid: add QUIRK_HIDDEV for Belkin Flip KVM
From: Daniel P. Engel <dengel@sourceharvest.com>

Add HID_QUIRK_HIDDEV for the Belkin Flip USB KVM to the hid-core blacklist
table.  The Belkin Flip USB KVM provides for software control of switching
via a HID class interface.  It overloads three HID LED usages, two of which
aren't mapped in the ev_dev input subsection, and which it doesn't make
sense to map.  In order to force the creation of a hiddev device for
controlling the Flip, this quirk flag is needed.

Signed-off-by: Daniel P. Engel <dengel@sourceharvest.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Greg KH <greg@kroah.com>
Cc: Jiri Kosina <jikos@jikos.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hid/usbhid/hid-core.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/hid/usbhid/hid-core.c~hid-add-quirk_hiddev-for-belkin-flip-kvm drivers/hid/usbhid/hid-core.c
--- a/drivers/hid/usbhid/hid-core.c~hid-add-quirk_hiddev-for-belkin-flip-kvm
+++ a/drivers/hid/usbhid/hid-core.c
@@ -304,6 +304,9 @@ static const struct hid_blacklist {
 
 	{ USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_RECEIVER, HID_QUIRK_BAD_RELATIVE_KEYS },
 
+	{ USB_VENDOR_ID_BELKIN, USB_DEVICE_ID_FLIP_KVM, HID_QUIRK_HIDDEV },
+
+
 	{ USB_VENDOR_ID_AASHIMA, USB_DEVICE_ID_AASHIMA_GAMEPAD, HID_QUIRK_BADPAD },
 	{ USB_VENDOR_ID_AASHIMA, USB_DEVICE_ID_AASHIMA_PREDATOR, HID_QUIRK_BADPAD },
 	{ USB_VENDOR_ID_ALPS, USB_DEVICE_ID_IBM_GAMEPAD, HID_QUIRK_BADPAD },
@@ -763,6 +766,9 @@ static void hid_irq_out(struct urb *urb)
 	wake_up(&hid->wait);
 }
 
+#define USB_VENDOR_ID_BELKIN		0x050d
+#define USB_DEVICE_ID_FLIP_KVM		0x3201
+
 /*
  * Control pipe completion handler.
  */
_

Patches currently in -mm which might be from dengel@sourceharvest.com are

git-hid.patch
hid-add-two-led-codes-to-hid-input-mapping.patch
hid-add-quirk_hiddev-for-belkin-flip-kvm.patch
