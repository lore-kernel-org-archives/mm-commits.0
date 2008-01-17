From: akpm@linux-foundation.org
Subject: - recent-lenovo-thinkpads-define-a-dummy-grahpics-device-find-it-and-ignore-it.patch removed from -mm tree
Date: Wed, 16 Jan 2008 20:33:18 -0800
Message-ID: <200801170432.m0H4Ww2C009078@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50843 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752653AbYAQEdW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jan 2008 23:33:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: trenn@suse.de, lenb@kernel.org, mjg59@srcf.ucam.org, mm-commits@vger.kernel.org


The patch titled
     Recent Lenovo ThinkPads define a dummy grahpics device, find it and ignore it
has been removed from the -mm tree.  Its filename was
     recent-lenovo-thinkpads-define-a-dummy-grahpics-device-find-it-and-ignore-it.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Recent Lenovo ThinkPads define a dummy grahpics device, find it and ignore it
From: Thomas Renninger <trenn@suse.de>

I posted this one already and Matthew had some concerns about it:
http://www.mail-archive.com/linux-acpi@vger.kernel.org/msg09510.html

IMO, this one should still be added to -mm, because:
  - The patch itself is correct, it is the function that is called
    that must make sure to return the corresponding pci device

  - There currently is a bug: Lenovos will register a device for which
    no physical device exists.

  - That means on these machines HW is addressed/poked
    which does not exist -> danger.

  - There is no other way to fix up acpi_get_physical_device, than to
    just do this change (at least I don't see it). People have to
    complain that their device is not found (the message they see in
    dmesg is obvious).
    Then we can make acpi_get_physical_device more robust, which will
    come out as a benefit for other functionality too sooner or later to
    be able to rely on getting struct pci in the video (and possibly
    other) driver(s).

Recent Lenovo ThinkPads define a dummy grahpics device, find it and ignore it

Signed-off-by: Thomas Renninger <trenn@suse.de>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/video.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN drivers/acpi/video.c~recent-lenovo-thinkpads-define-a-dummy-grahpics-device-find-it-and-ignore-it drivers/acpi/video.c
--- a/drivers/acpi/video.c~recent-lenovo-thinkpads-define-a-dummy-grahpics-device-find-it-and-ignore-it
+++ a/drivers/acpi/video.c
@@ -35,6 +35,7 @@
 #include <linux/input.h>
 #include <linux/backlight.h>
 #include <linux/video_output.h>
+#include <linux/acpi.h>
 #include <asm/uaccess.h>
 
 #include <acpi/acpi_bus.h>
@@ -1390,6 +1391,21 @@ acpi_video_bus_get_one_device(struct acp
 	u32 max_brightness;
 	int status;
 	int error;
+	struct device *dev;
+
+
+	/*
+	 *	Check whether we have really  a graphics device physically
+	 *      in the slot and registered at the system.
+	 */
+	dev = acpi_get_physical_device(device->handle);
+	if (!dev) {
+		printk (KERN_DEBUG PREFIX "Video device %s.%s not physically"
+			" connected, ignoring\n", acpi_device_bid(device),
+			device->parent ? acpi_device_bid(device->parent) : "");
+		return -ENODEV;
+	}
+	put_device(dev);
 
 	status = acpi_evaluate_integer(device->handle, "_ADR", NULL,
 					&device_id);
_

Patches currently in -mm which might be from trenn@suse.de are

git-acpi.patch
small-acpica-extension-to-be-able-to-store-the-name-of.patch
export-acpi_check_resource_conflict.patch
git-alsa.patch
check-for-acpi-resource-conflicts-in-i2c-bus-drivers.patch
check-for-acpi-resource-conflicts-in-hwmon-drivers.patch
git-x86.patch
declare-pnp-option-parsing-functions-as-__init.patch
declare-pnp-option-parsing-functions-as-__init-checkpatch-fixes.patch
