From: akpm@linux-foundation.org
Subject: [merged] usbtouchscreen-fix-egalax-hid-ignoring.patch removed from -mm tree
Date: Mon, 02 Mar 2009 11:23:39 -0800
Message-ID: <200903021923.n22JNdCK014442@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58040 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753611AbZCBTY3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2009 14:24:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.ritz-ml@swissonline.ch, daniel.ritz@gmx.ch, dtor@mail.ru, max.weninger@gmail.com, mm-commits@vger.kernel.org


The patch titled
     usbtouchscreen: fix eGalax HID ignoring
has been removed from the -mm tree.  Its filename was
     usbtouchscreen-fix-egalax-hid-ignoring.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usbtouchscreen: fix eGalax HID ignoring
From: Daniel Ritz <daniel.ritz-ml@swissonline.ch>

Commit ec42d4481e36cbdb5b2801f957e678211a9e5ae2 ("Input: usbtouchscreen -
ignore eGalax screens supporting HID protocol") broke usbtouchscreen for
some eGalax/EETI devices that claim to be HID, but are not.

Devices confirmed to be real HID have the class set to HID and the
protocol set to 'mouse'.  Some have HID class but protocol set to 'none'. 
Those are not HID and should be driven by usbtouchscreen.

Fix the device ignoring macro by adding match for the protocol too.
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

linux-next.patch

