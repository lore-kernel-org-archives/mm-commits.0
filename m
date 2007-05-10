From: akpm@linux-foundation.org
Subject: + acpi-dock-unsuppress-uevents.patch added to -mm tree
Date: Wed, 09 May 2007 21:16:03 -0700
Message-ID: <200705100416.l4A4G3AO011785@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56849 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754639AbXEJEQF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 00:16:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kristen.c.accardi@intel.com


The patch titled
     ACPI: dock: unsuppress uevents
has been added to the -mm tree.  Its filename is
     acpi-dock-unsuppress-uevents.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ACPI: dock: unsuppress uevents
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Platform devices may not send uevents by default - override the setting so
that we can send uevents on dock/undock.

Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/dock.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/acpi/dock.c~acpi-dock-unsuppress-uevents drivers/acpi/dock.c
--- a/drivers/acpi/dock.c~acpi-dock-unsuppress-uevents
+++ a/drivers/acpi/dock.c
@@ -751,6 +751,9 @@ static int dock_add(acpi_handle handle)
 		return PTR_ERR(dock_device);
 	}
 
+	/* we want the dock device to send uevents */
+	dock_device->dev.uevent_suppress = 0;
+
 	ret = device_create_file(&dock_device->dev, &dev_attr_docked);
 	if (ret) {
 		printk("Error %d adding sysfs file\n", ret);
_

Patches currently in -mm which might be from kristen.c.accardi@intel.com are

origin.patch
acpi-dock-cleanup-the-uid-patch.patch
acpi-dock-fix-opps-after-dock-driver-fails-to-initialize.patch
acpi-dock-use-dynamically-allocated-platform-device.patch
acpi-dock-add-immediate_undock-option.patch
acpi-dock-unsuppress-uevents.patch
acpi-dock-send-envp-with-uevent.patch
acpi-bay-unsuppress-uevents.patch
acpi-fix-oops-after-dock-driver-fails-to-initialize.patch
cpci_hotplug-convert-to-use-the-kthread-api.patch
