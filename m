From: akpm@linux-foundation.org
Subject: + wireless-zd1211rw-add-device-id-fix-wifi-dongle-trust-nw-3100.patch added to -mm tree
Date: Fri, 19 Sep 2008 16:47:06 -0700
Message-ID: <200809192347.m8JNl629013418@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59820 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751984AbYISXsF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Sep 2008 19:48:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: born.into.silence@gmail.com, dsd@gentoo.org, johannes@sipsolutions.net, kune@deine-taler.de, linville@tuxdriver.com


The patch titled
     wireless: zd1211rw: add device ID fix wifi dongle "trust nw-3100"
has been added to the -mm tree.  Its filename is
     wireless-zd1211rw-add-device-id-fix-wifi-dongle-trust-nw-3100.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: wireless: zd1211rw: add device ID fix wifi dongle "trust nw-3100"
From: <born.into.silence@gmail.com>

akpm: taken from http://bugzilla.kernel.org/show_bug.cgi?id=11587

I bought the wifi dongle trust nw-3100 wich is in fact a zd1211rw.  Its
hardware id was missing in the sources, adding it made it work flawlessly.

Cc: Daniel Drake <dsd@gentoo.org>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Ulrich Kunitz <kune@deine-taler.de>
Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/zd1211rw/zd_usb.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/net/wireless/zd1211rw/zd_usb.c~wireless-zd1211rw-add-device-id-fix-wifi-dongle-trust-nw-3100 drivers/net/wireless/zd1211rw/zd_usb.c
--- a/drivers/net/wireless/zd1211rw/zd_usb.c~wireless-zd1211rw-add-device-id-fix-wifi-dongle-trust-nw-3100
+++ a/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -58,6 +58,7 @@ static struct usb_device_id usb_ids[] = 
 	{ USB_DEVICE(0x0586, 0x3407), .driver_info = DEVICE_ZD1211 },
 	{ USB_DEVICE(0x129b, 0x1666), .driver_info = DEVICE_ZD1211 },
 	{ USB_DEVICE(0x157e, 0x300a), .driver_info = DEVICE_ZD1211 },
+	{ USB_DEVICE(0x0105, 0x145f), .driver_info = DEVICE_ZD1211 },
 	/* ZD1211B */
 	{ USB_DEVICE(0x0ace, 0x1215), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x157e, 0x300d), .driver_info = DEVICE_ZD1211B },
_

Patches currently in -mm which might be from born.into.silence@gmail.com are

wireless-zd1211rw-add-device-id-fix-wifi-dongle-trust-nw-3100.patch

