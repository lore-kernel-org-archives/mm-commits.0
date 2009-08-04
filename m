From: akpm@linux-foundation.org
Subject: + hid-core-ignore-philips-ieee802154-rf-dongle.patch added to -mm tree
Date: Tue, 04 Aug 2009 00:12:10 -0700
Message-ID: <200908040712.n747CA14019354@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33058 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932493AbZHDHMa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Aug 2009 03:12:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: glaweh@debian.org, jikos@jikos.cz


The patch titled
     hid-core: ignore Philips IEEE802.15.4 RF Dongle
has been added to the -mm tree.  Its filename is
     hid-core-ignore-philips-ieee802154-rf-dongle.patch

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
Subject: hid-core: ignore Philips IEEE802.15.4 RF Dongle
From: Henning Glawe <glaweh@debian.org>

This usb device claims to be of HID class, but is in fact a 802.15.4
lowpan transceiver, therefore the generic HID driver cannot operate this
device.  A separate driver for this device will be written for this using
the new 802.15.4 stack.

Signed-off-by: Henning Glawe <glaweh@debian.org>
Cc: Jiri Kosina <jikos@jikos.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hid/hid-core.c |    1 +
 drivers/hid/hid-ids.h  |    3 +++
 2 files changed, 4 insertions(+)

diff -puN drivers/hid/hid-core.c~hid-core-ignore-philips-ieee802154-rf-dongle drivers/hid/hid-core.c
--- a/drivers/hid/hid-core.c~hid-core-ignore-philips-ieee802154-rf-dongle
+++ a/drivers/hid/hid-core.c
@@ -1644,6 +1644,7 @@ static const struct hid_device_id hid_ig
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PANJIT, 0x0002) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PANJIT, 0x0003) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PANJIT, 0x0004) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_PHILIPS, USB_DEVICE_ID_PHILIPS_IEEE802154_DONGLE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_POWERCOM, USB_DEVICE_ID_POWERCOM_UPS) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SOUNDGRAPH, USB_DEVICE_ID_SOUNDGRAPH_IMON_LCD) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SOUNDGRAPH, USB_DEVICE_ID_SOUNDGRAPH_IMON_LCD2) },
diff -puN drivers/hid/hid-ids.h~hid-core-ignore-philips-ieee802154-rf-dongle drivers/hid/hid-ids.h
--- a/drivers/hid/hid-ids.h~hid-core-ignore-philips-ieee802154-rf-dongle
+++ a/drivers/hid/hid-ids.h
@@ -360,6 +360,9 @@
 #define USB_VENDOR_ID_PETALYNX		0x18b1
 #define USB_DEVICE_ID_PETALYNX_MAXTER_REMOTE	0x0037
 
+#define USB_VENDOR_ID_PHILIPS       0x0471
+#define USB_DEVICE_ID_PHILIPS_IEEE802154_DONGLE 0x0617
+
 #define USB_VENDOR_ID_PLAYDOTCOM	0x0b43
 #define USB_DEVICE_ID_PLAYDOTCOM_EMS_USBII	0x0003
 
_

Patches currently in -mm which might be from glaweh@debian.org are

hid-core-ignore-philips-ieee802154-rf-dongle.patch

