From: akpm@linux-foundation.org
Subject: + isight_firmware-avoid-crash-on-loading-invalid-firmware.patch added to -mm tree
Date: Fri, 06 Jun 2008 12:35:15 -0700
Message-ID: <200806061935.m56JZFDr015264@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42561 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755585AbYFFTgS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jun 2008 15:36:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mjg59@srcf.ucam.org, greg@kroah.com, justinmattock@gmail.com, mjg@redhat.com


The patch titled
     isight_firmware: Avoid crash on loading invalid firmware
has been added to the -mm tree.  Its filename is
     isight_firmware-avoid-crash-on-loading-invalid-firmware.patch

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
Subject: isight_firmware: Avoid crash on loading invalid firmware
From: Matthew Garrett <mjg59@srcf.ucam.org>

Different tools generate slightly different formats of the isight
firmware. Ensure that the firmware buffer is not overrun, while still
ensuring that the correct amount of data is written if trailing data is
present.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Report-by: Justin Mattock <justinmattock@gmail.com>
Tested-by: Justin Mattock <justinmattock@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/misc/isight_firmware.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff -puN drivers/usb/misc/isight_firmware.c~isight_firmware-avoid-crash-on-loading-invalid-firmware drivers/usb/misc/isight_firmware.c
--- a/drivers/usb/misc/isight_firmware.c~isight_firmware-avoid-crash-on-loading-invalid-firmware
+++ a/drivers/usb/misc/isight_firmware.c
@@ -39,9 +39,12 @@ static int isight_firmware_load(struct u
 	struct usb_device *dev = interface_to_usbdev(intf);
 	int llen, len, req, ret = 0;
 	const struct firmware *firmware;
-	unsigned char *buf;
+	unsigned char *buf = kmalloc(50, GFP_KERNEL);
 	unsigned char data[4];
-	char *ptr;
+	u8 *ptr;
+
+	if (!buf)
+		return -ENOMEM;
 
 	if (request_firmware(&firmware, "isight.fw", &dev->dev) != 0) {
 		printk(KERN_ERR "Unable to load isight firmware\n");
@@ -59,7 +62,7 @@ static int isight_firmware_load(struct u
 		goto out;
 	}
 
-	while (1) {
+	while (ptr+4 <= firmware->data+firmware->size) {
 		memcpy(data, ptr, 4);
 		len = (data[0] << 8 | data[1]);
 		req = (data[2] << 8 | data[3]);
@@ -71,10 +74,14 @@ static int isight_firmware_load(struct u
 			continue;
 
 		for (; len > 0; req += 50) {
-			llen = len > 50 ? 50 : len;
+			llen = min(len, 50);
 			len -= llen;
-
-			buf = kmalloc(llen, GFP_KERNEL);
+			if (ptr+llen > firmware->data+firmware->size) {
+				printk(KERN_ERR
+				       "Malformed isight firmware");
+				ret = -ENODEV;
+				goto out;
+			}
 			memcpy(buf, ptr, llen);
 
 			ptr += llen;
@@ -89,16 +96,18 @@ static int isight_firmware_load(struct u
 				goto out;
 			}
 
-			kfree(buf);
 		}
 	}
+
 	if (usb_control_msg
 	    (dev, usb_sndctrlpipe(dev, 0), 0xa0, 0x40, 0xe600, 0, "\0", 1,
 	     300) != 1) {
 		printk(KERN_ERR "isight firmware loading completion failed\n");
 		ret = -ENODEV;
 	}
+
 out:
+	kfree(buf);
 	release_firmware(firmware);
 	return ret;
 }
_

Patches currently in -mm which might be from mjg59@srcf.ucam.org are

acpi-video-balcklist-fujitsu-lifebook-s6410.patch
bay-exit-if-notify-handler-cannot-be-installed.patch
input-add-switch-for-dock-events.patch
acpi-send-switch-event-on-dock-events.patch
isight_firmware-avoid-crash-on-loading-invalid-firmware.patch
misc-add-hp-wmi-laptop-extras-driver.patch

