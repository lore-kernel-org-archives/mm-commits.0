From: akpm@linux-foundation.org
Subject: - acpi-dock-unsuppress-uevents.patch removed from -mm tree
Date: Fri, 11 May 2007 22:15:56 -0700
Message-ID: <200705120515.l4C5FuTB001788@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43561 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756491AbXELFP6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:15:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kristen.c.accardi@intel.com, mm-commits@vger.kernel.org


The patch titled
     ACPI: dock: unsuppress uevents
has been removed from the -mm tree.  Its filename was
     acpi-dock-unsuppress-uevents.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
git-acpi.patch
libata-check-for-an-support.patch
genhd-expose-an-to-user-space.patch
scsi-expose-an-to-user-space.patch
libata-expose-an-to-user-space.patch
genhd-send-async-notification-on-media-change.patch
scsi-save-disk-in-scsi_device.patch
libata-send-event-when-an-received.patch
cpci_hotplug-convert-to-use-the-kthread-api.patch
