From: akpm@linux-foundation.org
Subject: + acpi-remove-sysfs_create_link-from-video-driver.patch added to -mm tree
Date: Mon, 28 Mar 2011 14:05:13 -0700
Message-ID: <201103282105.p2SL5EBL029083@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53800 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751276Ab1C1VFm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Mar 2011 17:05:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mjg@redhat.com, alessandro.suardi@gmail.com, jeff.chua.linux@gmail.com, lenb@kernel.org, rjw@sisk.pl, rui.zhang@intel.com


The patch titled
     acpi: remove sysfs_create_link() from video driver
has been added to the -mm tree.  Its filename is
     acpi-remove-sysfs_create_link-from-video-driver.patch

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
Subject: acpi: remove sysfs_create_link() from video driver
From: Matthew Garrett <mjg@redhat.com>

The acpi video driver attempts to explicitly create a sysfs link between
the acpi device and the associated PCI device.  However, we're now also
doing this from the backlight core, which means that we get a backtrace
caused by a duplicate file.  Remove the code and leave it up to the
backlight core.

Reported-by: Jeff Chua <jeff.chua.linux@gmail.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Len Brown <lenb@kernel.org>
Tested-by: Alessandro Suardi <alessandro.suardi@gmail.com>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/video.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN drivers/acpi/video.c~acpi-remove-sysfs_create_link-from-video-driver drivers/acpi/video.c
--- a/drivers/acpi/video.c~acpi-remove-sysfs_create_link-from-video-driver
+++ a/drivers/acpi/video.c
@@ -824,11 +824,6 @@ static void acpi_video_device_find_cap(s
 		device->backlight->props.brightness =
 				acpi_video_get_brightness(device->backlight);
 
-		result = sysfs_create_link(&device->backlight->dev.kobj,
-					   &device->dev->dev.kobj, "device");
-		if (result)
-			printk(KERN_ERR PREFIX "Create sysfs link\n");
