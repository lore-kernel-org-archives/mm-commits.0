From: akpm@linux-foundation.org
Subject: [merged] hid-core-ignore-philips-ieee802154-rf-dongle.patch removed from -mm tree
Date: Mon, 10 Aug 2009 12:28:20 -0700
Message-ID: <200908101928.n7AJSKsq027523@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35884 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752498AbZHJT2k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Aug 2009 15:28:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glaweh@debian.org, jikos@jikos.cz, mm-commits@vger.kernel.org


The patch titled
     hid-core: ignore Philips IEEE802.15.4 RF Dongle
has been removed from the -mm tree.  Its filename was
     hid-core-ignore-philips-ieee802154-rf-dongle.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

