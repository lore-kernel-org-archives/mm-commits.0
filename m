From: akpm@linux-foundation.org
Subject: + acpi-dont-free-non-existent-backlight-in-acpi-video-module.patch added to -mm tree
Date: Mon, 13 Jul 2009 16:41:53 -0700
Message-ID: <200907132341.n6DNfrG9016381@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39115 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754517AbZGMXm6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Jul 2009 19:42:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: keithp@keithp.com, lenb@kernel.org, rui.zhang@intel.com


The patch titled
     acpi: don't free non-existent backlight in acpi video module
has been added to the -mm tree.  Its filename is
     acpi-dont-free-non-existent-backlight-in-acpi-video-module.patch

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
Subject: acpi: don't free non-existent backlight in acpi video module
From: Keith Packard <keithp@keithp.com>

acpi_video_put_one_device was attempting to remove sysfs entries and
unregister a backlight device without first checking that said backlight
device structure had been created.

Signed-off-by: Keith Packard <keithp@keithp.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/video.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/acpi/video.c~acpi-dont-free-non-existent-backlight-in-acpi-video-module drivers/acpi/video.c
--- a/drivers/acpi/video.c~acpi-dont-free-non-existent-backlight-in-acpi-video-module
+++ a/drivers/acpi/video.c
@@ -2004,8 +2004,11 @@ static int acpi_video_bus_put_one_device
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
acpi-dont-free-non-existent-backlight-in-acpi-video-module.patch

