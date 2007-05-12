From: akpm@linux-foundation.org
Subject: - acpi-dock-cleanup-the-uid-patch.patch removed from -mm tree
Date: Fri, 11 May 2007 22:15:46 -0700
Message-ID: <200705120515.l4C5FkL7001776@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57772 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756380AbXELFPx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:15:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kristen.c.accardi@intel.com, ilya@total-knowledge.com, mm-commits@vger.kernel.org


The patch titled
     ACPI: dock: cleanup the uid patch
has been removed from the -mm tree.  Its filename was
     acpi-dock-cleanup-the-uid-patch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ACPI: dock: cleanup the uid patch
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Make uid sysfs file error path free memory, and cleanup sysfs file when
removing driver.  Also fix CodingStyle violations.

Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Illya A. Volynets-Evenbakh <ilya@total-knowledge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/dock.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN drivers/acpi/dock.c~acpi-dock-cleanup-the-uid-patch drivers/acpi/dock.c
--- a/drivers/acpi/dock.c~acpi-dock-cleanup-the-uid-patch
+++ a/drivers/acpi/dock.c
@@ -675,16 +675,15 @@ static ssize_t show_dock_uid(struct devi
 			     struct device_attribute *attr, char *buf)
 {
 	unsigned long lbuf;
-	acpi_status status = acpi_evaluate_integer(dock_station->handle, "_UID", NULL, &lbuf);
-	if(ACPI_FAILURE(status)) {
+	acpi_status status = acpi_evaluate_integer(dock_station->handle,
+					"_UID", NULL, &lbuf);
+	if (ACPI_FAILURE(status))
 	    return 0;
-	}
+
 	return snprintf(buf, PAGE_SIZE, "%lx\n", lbuf);
 }
 DEVICE_ATTR(uid, S_IRUGO, show_dock_uid, NULL);
 
-
-
 /**
  * dock_add - add a new dock station
  * @handle: the dock station handle
@@ -736,6 +735,8 @@ static int dock_add(acpi_handle handle)
 	ret = device_create_file(&dock_device.dev, &dev_attr_uid);
 	if (ret) {
 		printk("Error %d adding sysfs file\n", ret);
+		device_remove_file(&dock_device.dev, &dev_attr_docked);
+		device_remove_file(&dock_device.dev, &dev_attr_undock);
 		platform_device_unregister(&dock_device);
 		kfree(dock_station);
 		return ret;
@@ -775,6 +776,7 @@ dock_add_err:
 dock_add_err_unregister:
 	device_remove_file(&dock_device.dev, &dev_attr_docked);
 	device_remove_file(&dock_device.dev, &dev_attr_undock);
+	device_remove_file(&dock_device.dev, &dev_attr_uid);
 	platform_device_unregister(&dock_device);
 	kfree(dock_station);
 	return ret;
@@ -806,6 +808,7 @@ static int dock_remove(void)
 	/* cleanup sysfs */
 	device_remove_file(&dock_device.dev, &dev_attr_docked);
 	device_remove_file(&dock_device.dev, &dev_attr_undock);
+	device_remove_file(&dock_device.dev, &dev_attr_uid);
 	platform_device_unregister(&dock_device);
 
 	/* free dock station memory */
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
