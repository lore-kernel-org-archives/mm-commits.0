From: akpm@linux-foundation.org
Subject: + usbtouchscreen-fix-egalax-hid-ignoring.patch added to -mm tree
Date: Wed, 11 Feb 2009 14:33:28 -0800
Message-ID: <200902112233.n1BMXSYY026814@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39049 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755007AbZBKWeP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Feb 2009 17:34:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: daniel.ritz-ml@swissonline.ch, daniel.ritz@gmx.ch, dtor@mail.ru, max.weninger@gmail.com


The patch titled
     usbtouchscreen: fix eGalax HID ignoring
has been added to the -mm tree.  Its filename is
     usbtouchscreen-fix-egalax-hid-ignoring.patch

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
Subject: usbtouchscreen: fix eGalax HID ignoring
From: Daniel Ritz <daniel.ritz-ml@swissonline.ch>

Fix the eGalax/EETI HID device ignoring by adding a match for the protocol
too.  This is what the marco USB_DEVICE_HID_CLASS() was supposed to do
anyways.

Devices confirmed to be real HID have the class set to HID and the
protocol set to 'mouse'.  Some have HID class but protocol set to 'none'. 
Those are not HID and should be driven by usbtouchscreen.

Signed-off-by: Daniel Ritz <daniel.ritz@gmx.ch>
Reported-and-tested-by: Max Weninger <max.weninger@gmail.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/usbtouchscreen.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/input/touchscreen/usbtouchscreen.c~usbtouchscreen-fix-egalax-hid-ignoring drivers/input/touchscreen/usbtouchscreen.c
--- a/drivers/input/touchscreen/usbtouchscreen.c~usbtouchscreen-fix-egalax-hid-ignoring
+++ a/drivers/input/touchscreen/usbtouchscreen.c
@@ -122,6 +122,7 @@ enum {
 
 #define USB_DEVICE_HID_CLASS(vend, prod) \
 	.match_flags = USB_DEVICE_ID_MATCH_INT_CLASS \
+		| USB_DEVICE_ID_MATCH_INT_PROTOCOL \
 		| USB_DEVICE_ID_MATCH_DEVICE, \
 	.idVendor = (vend), \
 	.idProduct = (prod), \
_

Patches currently in -mm which might be from daniel.ritz-ml@swissonline.ch are

usbtouchscreen-fix-egalax-hid-ignoring.patch

