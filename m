From: akpm@linux-foundation.org
Subject: + otus-zdusbc-additional-usb-idnetifier.patch added to -mm tree
Date: Tue, 14 Apr 2009 16:58:33 -0700
Message-ID: <200904142358.n3ENwXBD006943@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39957 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756168AbZDOAAN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 20:00:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dnax88@gmail.com, greg@kroah.com


The patch titled
     otus/zdusb.c: additional USB idnetifier
has been added to the -mm tree.  Its filename is
     otus-zdusbc-additional-usb-idnetifier.patch

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
Subject: otus/zdusb.c: additional USB idnetifier
From: Daniele Napolitano <dnax88@gmail.com>

Provide support for WN111v2 USB 802.11n adapter.

Signed-off-by: Daniele Napolitano <dnax88@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/otus/zdusb.c |    3 ++-
 drivers/staging/otus/zdusb.h |    4 ++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/staging/otus/zdusb.c~otus-zdusbc-additional-usb-idnetifier drivers/staging/otus/zdusb.c
--- a/drivers/staging/otus/zdusb.c~otus-zdusbc-additional-usb-idnetifier
+++ a/drivers/staging/otus/zdusb.c
@@ -48,7 +48,8 @@ static const char driver_name[] = "Otus"
 static struct usb_device_id zd1221_ids [] = {
 	{ USB_DEVICE(VENDOR_ATHR, PRODUCT_AR9170) },
         { USB_DEVICE(VENDOR_DLINK, PRODUCT_DWA160A) },
-	{ USB_DEVICE(0x0846, 0x9010) },
+	{ USB_DEVICE(VENDOR_NETGEAR, PRODUCT_WNDA3100) },
+	{ USB_DEVICE(VENDOR_NETGEAR, PRODUCT_WN111v2) },
 	{ }					/* Terminating entry */
 };
 
diff -puN drivers/staging/otus/zdusb.h~otus-zdusbc-additional-usb-idnetifier drivers/staging/otus/zdusb.h
--- a/drivers/staging/otus/zdusb.h~otus-zdusbc-additional-usb-idnetifier
+++ a/drivers/staging/otus/zdusb.h
@@ -40,4 +40,8 @@
 #define VENDOR_DLINK            0x07D1  //Dlink
 #define PRODUCT_DWA160A         0x3C10
 
+#define	VENDOR_NETGEAR		0x0846	/* NetGear */
+#define	PRODUCT_WNDA3100	0x9010
+#define	PRODUCT_WN111v2		0x9001
+
 #endif
_

Patches currently in -mm which might be from dnax88@gmail.com are

linux-next.patch
otus-zdusbc-additional-usb-idnetifier.patch

