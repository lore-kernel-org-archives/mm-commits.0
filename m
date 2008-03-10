From: akpm@linux-foundation.org
Subject: - usb-video-add-a-device-link-to-usbvideo-devices-else-hal-will-ignore-them.patch removed from -mm tree
Date: Mon, 10 Mar 2008 11:05:23 -0700
Message-ID: <200803101805.m2AI5N0K030088@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38405 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751283AbYCJSGD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 14:06:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pterjan@mandriva.com, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     usb video: add a device link to usbvideo devices, else hal will ignore them
has been removed from the -mm tree.  Its filename was
     usb-video-add-a-device-link-to-usbvideo-devices-else-hal-will-ignore-them.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
git-dvb.patch

