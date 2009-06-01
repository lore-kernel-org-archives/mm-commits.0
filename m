From: akpm@linux-foundation.org
Subject: + v4l-generate-key_camera-instead-of-btn_0-key-events-on-input-devices.patch added to -mm tree
Date: Mon, 01 Jun 2009 14:49:25 -0700
Message-ID: <200906012149.n51LnQRp006165@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35143 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752391AbZFAVuI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Jun 2009 17:50:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mzxreary@0pointer.de, mchehab@infradead.org


The patch titled
     v4l: generate KEY_CAMERA instead of BTN_0 key events on input devices
has been added to the -mm tree.  Its filename is
     v4l-generate-key_camera-instead-of-btn_0-key-events-on-input-devices.patch

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
Subject: v4l: generate KEY_CAMERA instead of BTN_0 key events on input devices
From: Lennart Poettering <mzxreary@0pointer.de>

A bunch of V4L drivers generate BTN_0 instead of KEY_CAMERA key presses.

X11 is able to handle KEY_CAMERA automatically these days while BTN_0 is
not treated at all.  Thus it would be of big benefit if the camera drivers
would consistently generate KEY_CAMERA.  Some drivers (uvc) already do,
this patch updates the remaining drivers to do the same.

I only possess a limited set of webcams, so this isn't tested with all
cameras.  The patch is rather trivial and compile tested, so I'd say it's
still good enough to get merged.

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/pwc/pwc-if.c                  |    4 ++--
 drivers/media/video/usbvideo/konicawc.c           |    4 ++--
 drivers/media/video/usbvideo/quickcam_messenger.c |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/media/video/pwc/pwc-if.c~v4l-generate-key_camera-instead-of-btn_0-key-events-on-input-devices drivers/media/video/pwc/pwc-if.c
--- a/drivers/media/video/pwc/pwc-if.c~v4l-generate-key_camera-instead-of-btn_0-key-events-on-input-devices
+++ a/drivers/media/video/pwc/pwc-if.c
@@ -601,7 +601,7 @@ static void pwc_snapshot_button(struct p
 
 #ifdef CONFIG_USB_PWC_INPUT_EVDEV
 	if (pdev->button_dev) {
-		input_report_key(pdev->button_dev, BTN_0, down);
+		input_report_key(pdev->button_dev, KEY_CAMERA, down);
 		input_sync(pdev->button_dev);
 	}
 #endif
@@ -1847,7 +1847,7 @@ static int usb_pwc_probe(struct usb_inte
 	usb_to_input_id(pdev->udev, &pdev->button_dev->id);
 	pdev->button_dev->dev.parent = &pdev->udev->dev;
 	pdev->button_dev->evbit[0] = BIT_MASK(EV_KEY);
-	pdev->button_dev->keybit[BIT_WORD(BTN_0)] = BIT_MASK(BTN_0);
+	pdev->button_dev->keybit[BIT_WORD(KEY_CAMERA)] = BIT_MASK(KEY_CAMERA);
 
 	rc = input_register_device(pdev->button_dev);
 	if (rc) {
diff -puN drivers/media/video/usbvideo/konicawc.c~v4l-generate-key_camera-instead-of-btn_0-key-events-on-input-devices drivers/media/video/usbvideo/konicawc.c
--- a/drivers/media/video/usbvideo/konicawc.c~v4l-generate-key_camera-instead-of-btn_0-key-events-on-input-devices
+++ a/drivers/media/video/usbvideo/konicawc.c
@@ -240,7 +240,7 @@ static void konicawc_register_input(stru
 	input_dev->dev.parent = &dev->dev;
 
 	input_dev->evbit[0] = BIT_MASK(EV_KEY);
-	input_dev->keybit[BIT_WORD(BTN_0)] = BIT_MASK(BTN_0);
+	input_dev->keybit[BIT_WORD(KEY_CAMERA)] = BIT_MASK(KEY_CAMERA);
 
 	error = input_register_device(cam->input);
 	if (error) {
@@ -263,7 +263,7 @@ static void konicawc_unregister_input(st
 static void konicawc_report_buttonstat(struct konicawc *cam)
 {
 	if (cam->input) {
-		input_report_key(cam->input, BTN_0, cam->buttonsts);
+		input_report_key(cam->input, KEY_CAMERA, cam->buttonsts);
 		input_sync(cam->input);
 	}
 }
diff -puN drivers/media/video/usbvideo/quickcam_messenger.c~v4l-generate-key_camera-instead-of-btn_0-key-events-on-input-devices drivers/media/video/usbvideo/quickcam_messenger.c
--- a/drivers/media/video/usbvideo/quickcam_messenger.c~v4l-generate-key_camera-instead-of-btn_0-key-events-on-input-devices
+++ a/drivers/media/video/usbvideo/quickcam_messenger.c
@@ -103,7 +103,7 @@ static void qcm_register_input(struct qc
 	input_dev->dev.parent = &dev->dev;
 
 	input_dev->evbit[0] = BIT_MASK(EV_KEY);
-	input_dev->keybit[BIT_WORD(BTN_0)] = BIT_MASK(BTN_0);
+	input_dev->keybit[BIT_WORD(KEY_CAMERA)] = BIT_MASK(KEY_CAMERA);
 
 	error = input_register_device(cam->input);
 	if (error) {
@@ -126,7 +126,7 @@ static void qcm_unregister_input(struct 
 static void qcm_report_buttonstat(struct qcm *cam)
 {
 	if (cam->input) {
-		input_report_key(cam->input, BTN_0, cam->button_sts);
+		input_report_key(cam->input, KEY_CAMERA, cam->button_sts);
 		input_sync(cam->input);
 	}
 }
_

Patches currently in -mm which might be from mzxreary@0pointer.de are

v4l-pwc-use-usb_interface-as-parent-not-usb_device.patch
v4l-generate-key_camera-instead-of-btn_0-key-events-on-input-devices.patch

