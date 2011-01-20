From: akpm@linux-foundation.org
Subject: [to-be-updated] acpi-tie-acpi-backlight-devices-to-pci-devices-if-possible.patch removed from -mm tree
Date: Thu, 20 Jan 2011 15:14:40 -0800
Message-ID: <201101202314.p0KNEeXn008364@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35722 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754104Ab1ATXPl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Jan 2011 18:15:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mjg@redhat.com, airlied@linux.ie, alexdeucher@gmail.com, bskeggs@redhat.com, chris@chris-wilson.co.uk, jbarnes@virtuousgeek.org, lenb@kernel.org, rpurdie@rpsys.net, rui.zhang@intel.co


The patch titled
     acpi: tie ACPI backlight devices to PCI devices if possible
has been removed from the -mm tree.  Its filename was
     acpi-tie-acpi-backlight-devices-to-pci-devices-if-possible.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: tie ACPI backlight devices to PCI devices if possible
From: Matthew Garrett <mjg@redhat.com>

Dual-GPU machines may provide more than one ACPI backlight interface.  Tie
the backlight device to the GPU in order to allow userspace to identify
the correct interface.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: David Airlie <airlied@linux.ie>
Cc: Alex Deucher <alexdeucher@gmail.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/video.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff -puN drivers/acpi/video.c~acpi-tie-acpi-backlight-devices-to-pci-devices-if-possible drivers/acpi/video.c
--- a/drivers/acpi/video.c~acpi-tie-acpi-backlight-devices-to-pci-devices-if-possible
+++ a/drivers/acpi/video.c
@@ -782,6 +782,9 @@ static void acpi_video_device_find_cap(s
 
 	if (acpi_video_backlight_support()) {
 		struct backlight_properties props;
+		struct pci_dev *pdev;
+		acpi_handle acpi_parent;
+		struct device *parent = NULL;
 		int result;
 		static int count = 0;
 		char *name;
@@ -794,10 +797,20 @@ static void acpi_video_device_find_cap(s
 			return;
 		count++;
 
+		acpi_get_parent(device->dev->handle, &acpi_parent);
+
+		pdev = acpi_get_pci_dev(acpi_parent);
+		if (pdev) {
+			parent = &pdev->dev;
+			pci_dev_put(pdev);
+		}
+
 		memset(&props, 0, sizeof(struct backlight_properties));
 		props.type = BACKLIGHT_FIRMWARE;
 		props.max_brightness = device->brightness->count - 3;
-		device->backlight = backlight_device_register(name, NULL, device,
+		device->backlight = backlight_device_register(name,
+							      parent,
+							      device,
 							      &acpi_backlight_ops,
 							      &props);
 		kfree(name);
_

Patches currently in -mm which might be from mjg@redhat.com are

acerhdf-add-support-for-aspire-1410-bios-v13314.patch
mbp_nvidia_bl-remove-dmi-dependency.patch
mbp_nvidia_bl-check-that-the-backlight-control-functions.patch
mbp_nvidia_bl-rename-to-apple_bl.patch

