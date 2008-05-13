From: akpm@linux-foundation.org
Subject: + net-usb-add-support-for-apple-usb-ethernet-adapter.patch added to -mm tree
Date: Tue, 13 May 2008 15:14:44 -0700
Message-ID: <200805132214.m4DMEiwO002463@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38677 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755034AbYEMWOz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 18:14:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aurelien.nephtali@sitadelle.com, aurelien@sitadelle.com, david-b@pacbell.net, greg@kroah.com


The patch titled
     net/usb: add support for Apple USB Ethernet Adapter
has been added to the -mm tree.  Its filename is
     net-usb-add-support-for-apple-usb-ethernet-adapter.patch

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
Subject: net/usb: add support for Apple USB Ethernet Adapter
From: Aurelien Nephtali <aurelien.nephtali@sitadelle.com>

Add support for Apple USB Ethernet Adapter.

http://store.apple.com/1-800-MY-APPLE/WebObjects/AppleStore.woa/wa/RSLID?nplm=MB442Z/A

Signed-off-by: Aurelien Nephtali <aurelien@sitadelle.com>
Cc: Greg KH <greg@kroah.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/usb/asix.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/net/usb/asix.c~net-usb-add-support-for-apple-usb-ethernet-adapter drivers/net/usb/asix.c
--- a/drivers/net/usb/asix.c~net-usb-add-support-for-apple-usb-ethernet-adapter
+++ a/drivers/net/usb/asix.c
@@ -1440,6 +1440,10 @@ static const struct usb_device_id	produc
 	// Belkin F5D5055
 	USB_DEVICE(0x050d, 0x5055),
 	.driver_info = (unsigned long) &ax88178_info,
+}, {
+	// Apple USB Ethernet Adapter
+	USB_DEVICE(0x05ac, 0x1402),
+	.driver_info = (unsigned long) &ax88772_info,
 },
 	{ },		// END
 };
_

Patches currently in -mm which might be from aurelien.nephtali@sitadelle.com are

net-usb-add-support-for-apple-usb-ethernet-adapter.patch

