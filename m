From: akpm@linux-foundation.org
Subject: + usb-video-add-a-device-link-to-usbvideo-devices-else-hal-will-ignore-them.patch added to -mm tree
Date: Fri, 07 Mar 2008 00:22:57 -0800
Message-ID: <200803070822.m278MvuR012879@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35390 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752789AbYCGIXS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Mar 2008 03:23:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pterjan@mandriva.com, mchehab@infradead.org


The patch titled
     usb video: add a device link to usbvideo devices, else hal will ignore them
has been added to the -mm tree.  Its filename is
     usb-video-add-a-device-link-to-usbvideo-devices-else-hal-will-ignore-them.patch

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
Subject: usb video: add a device link to usbvideo devices, else hal will ignore them
From: Pascal Terjan <pterjan@mandriva.com>

Signed-off-by: Pascal Terjan <pterjan@mandriva.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/usbvideo/usbvideo.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/media/video/usbvideo/usbvideo.c~usb-video-add-a-device-link-to-usbvideo-devices-else-hal-will-ignore-them drivers/media/video/usbvideo/usbvideo.c
--- a/drivers/media/video/usbvideo/usbvideo.c~usb-video-add-a-device-link-to-usbvideo-devices-else-hal-will-ignore-them
+++ a/drivers/media/video/usbvideo/usbvideo.c
@@ -1034,6 +1034,11 @@ int usbvideo_RegisterVideoDevice(struct 
 		info("%s: iface=%d. endpoint=$%02x paletteBits=$%08lx",
 		     __FUNCTION__, uvd->iface, uvd->video_endp, uvd->paletteBits);
 	}
+	if (uvd->dev == NULL) {
+		err("%s: uvd->dev == NULL", __FUNCTION__);
+		return -EINVAL;
+	}
+	uvd->vdev.dev=&(uvd->dev->dev);
 	if (video_register_device(&uvd->vdev, VFL_TYPE_GRABBER, video_nr) == -1) {
 		err("%s: video_register_device failed", __FUNCTION__);
 		return -EPIPE;
@@ -1041,10 +1046,6 @@ int usbvideo_RegisterVideoDevice(struct 
 	if (uvd->debug > 1) {
 		info("%s: video_register_device() successful", __FUNCTION__);
 	}
-	if (uvd->dev == NULL) {
-		err("%s: uvd->dev == NULL", __FUNCTION__);
-		return -EINVAL;
-	}
 
 	info("%s on /dev/video%d: canvas=%s videosize=%s",
 	     (uvd->handle != NULL) ? uvd->handle->drvName : "???",
_

Patches currently in -mm which might be from pterjan@mandriva.com are

git-alsa.patch
usb-video-add-a-device-link-to-usbvideo-devices-else-hal-will-ignore-them.patch

