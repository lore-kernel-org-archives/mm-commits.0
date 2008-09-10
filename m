From: akpm@linux-foundation.org
Subject: + usb-serial-ti_usb_3410_5052-obviously-broken-by-firmware-changes.patch added to -mm tree
Date: Wed, 10 Sep 2008 14:11:38 -0700
Message-ID: <200809102111.m8ALBco5026392@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751631AbYIJVMP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Sep 2008 17:12:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cmadams@hiwaay.net, greg@kroah.com


The patch titled
     usb serial: ti_usb_3410_5052 obviously broken by firmware changes
has been added to the -mm tree.  Its filename is
     usb-serial-ti_usb_3410_5052-obviously-broken-by-firmware-changes.patch

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
Subject: usb serial: ti_usb_3410_5052 obviously broken by firmware changes
From: Chris Adams <cmadams@hiwaay.net>

While making some other changes to ti_usb_3410_5052, I noticed that the
changes made to move the firmware loading to a separate function are
broken (in ti_download_firmware(), status is set to -ENOMEM and never
changed).  This means the driver will never initialize the device
properly.  It looks like status was supposed to get the result of
ti_do_download().

Signed-off-by: Chris Adams <cmadams@hiwaay.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/ti_usb_3410_5052.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/serial/ti_usb_3410_5052.c~usb-serial-ti_usb_3410_5052-obviously-broken-by-firmware-changes drivers/usb/serial/ti_usb_3410_5052.c
--- a/drivers/usb/serial/ti_usb_3410_5052.c~usb-serial-ti_usb_3410_5052-obviously-broken-by-firmware-changes
+++ a/drivers/usb/serial/ti_usb_3410_5052.c
@@ -1747,7 +1747,7 @@ static int ti_download_firmware(struct t
 	if (buffer) {
 		memcpy(buffer, fw_p->data, fw_p->size);
 		memset(buffer + fw_p->size, 0xff, buffer_size - fw_p->size);
-		ti_do_download(dev, pipe, buffer, fw_p->size);
+		status = ti_do_download(dev, pipe, buffer, fw_p->size);
 		kfree(buffer);
 	}
 	release_firmware(fw_p);
_

Patches currently in -mm which might be from cmadams@hiwaay.net are

usb-serial-ti_usb_3410_5052-obviously-broken-by-firmware-changes.patch

