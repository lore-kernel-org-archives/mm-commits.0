From: akpm@linux-foundation.org
Subject: [merged] acpi-dont-free-non-existent-backlight-in-acpi-video-module.patch removed from -mm tree
Date: Mon, 31 Aug 2009 14:18:51 -0700
Message-ID: <200908312118.n7VLIp1D018639@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42003 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750878AbZHaVUU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Aug 2009 17:20:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keithp@keithp.com, lenb@kernel.org, rui.zhang@intel.com, mm-commits@vger.kernel.org


The patch titled
     acpi: don't free non-existent backlight in acpi video module
has been removed from the -mm tree.  Its filename was
     acpi-dont-free-non-existent-backlight-in-acpi-video-module.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: don't free non-existent backlight in acpi video module
From: Keith Packard <keithp@keithp.com>

acpi_video_put_one_device was attempting to remove sysfs entries and
unregister a backlight device without first checking that said backlight
device structure had been created.

Signed-off-by: Keith Packard <keithp@keithp.com>
Acked-by: Zhang Rui <rui.zhang@intel.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/video.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/acpi/video.c~acpi-dont-free-non-existent-backlight-in-acpi-video-module drivers/acpi/video.c
--- a/drivers/acpi/video.c~acpi-dont-free-non-existent-backlight-in-acpi-video-module
+++ a/drivers/acpi/video.c
@@ -2006,8 +2006,11 @@ static int acpi_video_bus_put_one_device
 	status = acpi_remove_notify_handler(device->dev->handle,
 					    ACPI_DEVICE_NOTIFY,
 					    acpi_video_device_notify);
-	sysfs_remove_link(&device->backlight->dev.kobj, "device");
-	backlight_device_unregister(device->backlight);
+	if (device->backlight) {
+		sysfs_remove_link(&device->backlight->dev.kobj, "device");
+		backlight_device_unregister(device->backlight);
+		device->backlight = NULL;
+	}
 	if (device->cdev) {
 		sysfs_remove_link(&device->dev->dev.kobj,
 				  "thermal_cooling");
_

Patches currently in -mm which might be from keithp@keithp.com are

origin.patch

