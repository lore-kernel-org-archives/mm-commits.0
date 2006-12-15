From: akpm@osdl.org
Subject: + usblp-add-serial-number-to-device-id.patch added to -mm tree
Date: Thu, 14 Dec 2006 16:51:32 -0800
Message-ID: <200612150051.kBF0pWaG001975@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:46964 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932304AbWLOAvh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 19:51:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eibach@gdsys.de, greg@kroah.com


The patch titled
     usblp: Add serial number to device ID
has been added to the -mm tree.  Its filename is
     usblp-add-serial-number-to-device-id.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: usblp: Add serial number to device ID
From: Dirk Eibach <eibach@gdsys.de>

I noticed that some USB-printers, e.g.  Canon PIXMA iP3000 don't add their
serial number to the IEEE-1284 device ID string as expected by userspace
apps like cups.  Because of this, connecting multiple printers of the same
type to a system does not work properly.

This patch adds the usb serial number to the device ID if it is left
out by the printer.

Signed-off-by: Dirk Eibach <eibach@gdsys.de>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/usb/class/usblp.c |   12 ++++++++++++
 1 files changed, 12 insertions(+)

diff -puN drivers/usb/class/usblp.c~usblp-add-serial-number-to-device-id drivers/usb/class/usblp.c
--- a/drivers/usb/class/usblp.c~usblp-add-serial-number-to-device-id
+++ a/drivers/usb/class/usblp.c
@@ -1162,6 +1162,18 @@ static int usblp_cache_device_id_string(
 		length = USBLP_DEVICE_ID_SIZE - 1;
 	usblp->device_id_string[length] = '\0';
 
+	/* Insert serial number into the device ID string if the printer
+	 * is braindead enough to leave it out. */
+	if ( (usblp->dev->serial)
+		&& (length + strlen(usblp->dev->serial) + 6 < USBLP_DEVICE_ID_SIZE)
+		&& !strstr(usblp->device_id_string+2, "SERN:")
+		&& !strstr(usblp->device_id_string+2, "SER:") )
+	{
+		sprintf(usblp->device_id_string+length, "SERN:%s;", usblp->dev->serial);
+		length += 6 + strlen(usblp->dev->serial);
+		*((__be16 *)usblp->device_id_string) = cpu_to_be16(length);
+	}
+
 	dbg("usblp%d Device ID string [len=%d]=\"%s\"",
 		usblp->minor, length, &usblp->device_id_string[2]);
 
_

Patches currently in -mm which might be from eibach@gdsys.de are

usblp-add-serial-number-to-device-id.patch

