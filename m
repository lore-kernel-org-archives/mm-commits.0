From: akpm@linux-foundation.org
Subject: + usb-hid-hidbp-drivers-add-imon-lcds-to-hid-blacklist.patch added to -mm tree
Date: Mon, 12 May 2008 16:01:38 -0700
Message-ID: <200805122301.m4CN1cSA013606@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32793 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754989AbYELXCO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 May 2008 19:02:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dylan.semler@gmail.com, greg@kroah.com, jkosina@suse.cz


The patch titled
     USB HID/HIDBP DRIVERS: Add iMON LCDs to HID blacklist
has been added to the -mm tree.  Its filename is
     usb-hid-hidbp-drivers-add-imon-lcds-to-hid-blacklist.patch

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
Subject: USB HID/HIDBP DRIVERS: Add iMON LCDs to HID blacklist
From: Dylan R Semler <dylan.semler@gmail.com>

The new iMON LCDs from SoundGraph need to be blacklisted from HID in order
to be used by lirc.

This patch adds vendor and device IDs for iMON LCDs and adds them to the
blacklist.

Signed-off-by: Dylan R Semler dylan.semler@gmail.com
Cc: Greg KH <greg@kroah.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hid/usbhid/hid-quirks.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/hid/usbhid/hid-quirks.c~usb-hid-hidbp-drivers-add-imon-lcds-to-hid-blacklist drivers/hid/usbhid/hid-quirks.c
--- a/drivers/hid/usbhid/hid-quirks.c~usb-hid-hidbp-drivers-add-imon-lcds-to-hid-blacklist
+++ a/drivers/hid/usbhid/hid-quirks.c
@@ -371,6 +371,9 @@
 #define USB_VENDOR_ID_SONY			0x054c
 #define USB_DEVICE_ID_SONY_PS3_CONTROLLER	0x0268
 
+#define USB_VENDOR_ID_SOUNDGRAPH		0x15c2
+#define USB_DEVICE_ID_SOUNDGRAPH_IMON_LCD	0x0038
+
 #define USB_VENDOR_ID_SUN		0x0430
 #define USB_DEVICE_ID_RARITAN_KVM_DONGLE	0xcdab
 
_

Patches currently in -mm which might be from dylan.semler@gmail.com are

usb-hid-hidbp-drivers-add-imon-lcds-to-hid-blacklist.patch

