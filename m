From: akpm@linux-foundation.org
Subject: + acpi-ignore-acpi-video-devices-that-arent-present-in-hardware.patch added to -mm tree
Date: Wed, 16 Jan 2008 20:34:03 -0800
Message-ID: <200801170433.m0H4Xh85009090@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59868 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753075AbYAQEeH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jan 2008 23:34:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mjg59@srcf.ucam.org, lenb@kernel.org, shaohua.li@intel.com, trenn@suse.de


The patch titled
     acpi: ignore ACPI video devices that aren't present in hardware
has been added to the -mm tree.  Its filename is
     acpi-ignore-acpi-video-devices-that-arent-present-in-hardware.patch

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
Subject: acpi: ignore ACPI video devices that aren't present in hardware
From: Matthew Garrett <mjg59@srcf.ucam.org>

Vendors often ship machines with a choice of integrated or discrete
graphics, and use the same DSDT for both.  As a result, the ACPI video
module will locate devices that may not exist on this specific platform. 
Attempt to determine whether the device exists or not, and abort the device
creation if it doesn't.

Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Len Brown <lenb@kernel.org>
Cc: "Li, Shaohua" <shaohua.li@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/video.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff -puN drivers/acpi/video.c~acpi-ignore-acpi-video-devices-that-arent-present-in-hardware drivers/acpi/video.c
--- a/drivers/acpi/video.c~acpi-ignore-acpi-video-devices-that-arent-present-in-hardware
+++ a/drivers/acpi/video.c
@@ -1268,8 +1268,37 @@ acpi_video_bus_write_DOS(struct file *fi
 
 static int acpi_video_bus_add_fs(struct acpi_device *device)
 {
+	long device_id;
+	int status;
 	struct proc_dir_entry *entry = NULL;
 	struct acpi_video_bus *video;
+	struct device *dev;
+	
+	status =
+	    acpi_evaluate_integer(device->handle, "_ADR", NULL, &device_id);
+
+	if (!ACPI_SUCCESS(status))
+		return -ENODEV;
+
+	/* We need to attempt to determine whether the _ADR refers to a
+	   PCI device or not. There's no terribly good way to do this,
+	   so the best we can hope for is to assume that there'll never
+	   be a video device in the host bridge */
+	if (device_id >= 0x10000) {
+		/* It looks like a PCI device. Does it exist? */
+		dev = acpi_get_physical_device(device->handle);
+	} else {
+		/* It doesn't look like a PCI device. Does its parent
+		   exist? */
+		acpi_handle phandle;
+		if (acpi_get_parent(device->handle, &phandle))
+			return -ENODEV;
+		dev = acpi_get_physical_device(phandle);
+	}
+	if (!dev)
+		return -ENODEV;
+	put_device(dev);
+
 
 
 	video = acpi_driver_data(device);
_

Patches currently in -mm which might be from mjg59@srcf.ucam.org are

acpi-ignore-acpi-video-devices-that-arent-present-in-hardware.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
