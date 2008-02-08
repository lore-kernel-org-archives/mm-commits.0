From: akpm@linux-foundation.org
Subject: - acpi-backlight-reset-brightness-on-resume.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:10:32 -0800
Message-ID: <200802080810.m188AD7I014924@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60219 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760669AbYBHIT3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:19:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mjg59@srcf.ucam.org, lenb@kernel.org, rui.zhang@intel.com, mm-commits@vger.kernel.org


The patch titled
     acpi backlight: reset brightness on resume
has been removed from the -mm tree.  Its filename was
     acpi-backlight-reset-brightness-on-resume.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi backlight: reset brightness on resume
From: Matthew Garrett <mjg59@srcf.ucam.org>

Some machines seem to need the backlight brightness to be reset on resume. 
Add support for doing so to the video module.

[akpm@linux-foundation.org: coding-style fixes]
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
@@ -78,6 +78,7 @@ module_param(brightness_switch_enabled, 
 
 static int acpi_video_bus_add(struct acpi_device *device);
 static int acpi_video_bus_remove(struct acpi_device *device, int type);
+static int acpi_video_resume(struct acpi_device *device);
 
 static const struct acpi_device_id video_device_ids[] = {
 	{ACPI_VIDEO_HID, 0},
@@ -92,6 +93,7 @@ static struct acpi_driver acpi_video_bus
 	.ops = {
 		.add = acpi_video_bus_add,
 		.remove = acpi_video_bus_remove,
+		.resume = acpi_video_resume,
 		},
 };
 
@@ -1948,6 +1950,25 @@ static void acpi_video_device_notify(acp
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
+	for (i = 0; i < video->attached_count; i++) {
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

origin.patch
