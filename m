From: akpm@linux-foundation.org
Subject: - input-uvc-the-button-on-the-camera-is-key_camera.patch removed from -mm tree
Date: Mon, 12 Jan 2009 11:58:25 -0800
Message-ID: <200901121958.n0CJwPeP027630@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50395 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755669AbZALT7B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jan 2009 14:59:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hadess@hadess.net, mm-commits@vger.kernel.org


The patch titled
     input: uvc: the button on the camera is KEY_CAMERA
has been removed from the -mm tree.  Its filename was
     input-uvc-the-button-on-the-camera-is-key_camera.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input: uvc: the button on the camera is KEY_CAMERA
From: Bastien Nocera <hadess@hadess.net>

Not BTN_0.  Also call input_sync() on the device once the button has been
pressed.



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/uvc/uvc_status.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/media/video/uvc/uvc_status.c~input-uvc-the-button-on-the-camera-is-key_camera drivers/media/video/uvc/uvc_status.c
--- a/drivers/media/video/uvc/uvc_status.c~input-uvc-the-button-on-the-camera-is-key_camera
+++ a/drivers/media/video/uvc/uvc_status.c
@@ -47,7 +47,7 @@ static int uvc_input_init(struct uvc_dev
 	input->dev.parent = &dev->intf->dev;
 
 	set_bit(EV_KEY, input->evbit);
-	set_bit(BTN_0, input->keybit);
+	set_bit(KEY_CAMERA, input->keybit);
 
 	if ((ret = input_register_device(input)) < 0)
 		goto error;
@@ -70,8 +70,10 @@ static void uvc_input_cleanup(struct uvc
 static void uvc_input_report_key(struct uvc_device *dev, unsigned int code,
 	int value)
 {
-	if (dev->input)
+	if (dev->input) {
 		input_report_key(dev->input, code, value);
+		input_sync(dev->input);
+	}
 }
 
 #else
@@ -96,7 +98,7 @@ static void uvc_event_streaming(struct u
 			return;
 		uvc_trace(UVC_TRACE_STATUS, "Button (intf %u) %s len %d\n",
 			data[1], data[3] ? "pressed" : "released", len);
-		uvc_input_report_key(dev, BTN_0, data[3]);
+		uvc_input_report_key(dev, KEY_CAMERA, data[3]);
 	} else {
 		uvc_trace(UVC_TRACE_STATUS, "Stream %u error event %02x %02x "
 			"len %d.\n", data[1], data[2], data[3], len);
_

Patches currently in -mm which might be from hadess@hadess.net are

linux-next.patch

