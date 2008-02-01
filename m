From: akpm@linux-foundation.org
Subject: + acpi-backlight-reset-brightness-on-resume.patch added to -mm tree
Date: Thu, 31 Jan 2008 16:22:59 -0800
Message-ID: <200802010022.m110MxLA018833@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45047 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754137AbYBAAXV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 Jan 2008 19:23:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mjg59@srcf.ucam.org, lenb@kernel.org, rui.zhang@intel.com


The patch titled
     acpi backlight: reset brightness on resume
has been added to the -mm tree.  Its filename is
     acpi-backlight-reset-brightness-on-resume.patch

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
Subject: acpi backlight: reset brightness on resume
From: Matthew Garrett <mjg59@srcf.ucam.org>

Some machines seem to need the backlight brightness to be reset on resume. 
Add support for doing so to the video module.

Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/video.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff -puN drivers/acpi/video.c~acpi-backlight-reset-brightness-on-resume drivers/acpi/video.c
--- a/drivers/acpi/video.c~acpi-backlight-reset-brightness-on-resume
+++ a/drivers/acpi/video.c
@@ -74,6 +74,7 @@ MODULE_LICENSE("GPL");
 
 static int acpi_video_bus_add(struct acpi_device *device);
 static int acpi_video_bus_remove(struct acpi_device *device, int type);
+static int acpi_video_resume(struct acpi_device *device);
 
 static const struct acpi_device_id video_device_ids[] = {
 	{ACPI_VIDEO_HID, 0},
@@ -88,6 +89,7 @@ static struct acpi_driver acpi_video_bus
 	.ops = {
 		.add = acpi_video_bus_add,
 		.remove = acpi_video_bus_remove,
+		.resume = acpi_video_resume,
 		},
 };
 
@@ -1931,6 +1933,25 @@ static void acpi_video_device_notify(acp
 }
 
 static int instance;
+static int acpi_video_resume(struct acpi_device *device)
+{
+	struct acpi_video_bus *video;
+	struct acpi_video_device *video_device;
+	int i;
+
+	if (!device || !acpi_driver_data(device))
+		return -EINVAL;
+
+	video = acpi_driver_data(device);
+
+	for (i=0; i<video->attached_count; i++) {
+		video_device = video->attached_array[i].bind_info;
+		if (video_device && video_device->backlight)
+			acpi_video_set_brightness(video_device->backlight);
+	}
+	return AE_OK;
+}
+
 static int acpi_video_bus_add(struct acpi_device *device)
 {
 	acpi_status status;
_

Patches currently in -mm which might be from mjg59@srcf.ucam.org are

acpi-ignore-acpi-video-devices-that-arent-present-in-hardware.patch
acpi-ignore-acpi-video-devices-that-arent-present-in-hardware-checkpatch-fixes.patch
acpi-backlight-reset-brightness-on-resume.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
