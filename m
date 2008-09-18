From: akpm@linux-foundation.org
Subject: - usb-serial-ti_usb_3410_5052-obviously-broken-by-firmware-changes.patch removed from -mm tree
Date: Thu, 18 Sep 2008 13:56:52 -0700
Message-ID: <200809182056.m8IKuq3C019225@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44331 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755022AbYIRU5G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Sep 2008 16:57:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cmadams@hiwaay.net, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     usb serial: ti_usb_3410_5052 obviously broken by firmware changes
has been removed from the -mm tree.  Its filename was
     usb-serial-ti_usb_3410_5052-obviously-broken-by-firmware-changes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

