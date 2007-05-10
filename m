From: akpm@linux-foundation.org
Subject: + acpi-dock-cleanup-the-uid-patch.patch added to -mm tree
Date: Wed, 09 May 2007 21:15:55 -0700
Message-ID: <200705100415.l4A4Ftaj011773@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54654 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754584AbXEJEQF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 00:16:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kristen.c.accardi@intel.com, ilya@total-knowledge.com


The patch titled
     ACPI: dock: cleanup the uid patch
has been added to the -mm tree.  Its filename is
     acpi-dock-cleanup-the-uid-patch.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
acpi-dock-cleanup-the-uid-patch.patch
acpi-dock-fix-opps-after-dock-driver-fails-to-initialize.patch
acpi-dock-use-dynamically-allocated-platform-device.patch
acpi-dock-add-immediate_undock-option.patch
acpi-dock-unsuppress-uevents.patch
acpi-dock-send-envp-with-uevent.patch
acpi-bay-unsuppress-uevents.patch
acpi-fix-oops-after-dock-driver-fails-to-initialize.patch
cpci_hotplug-convert-to-use-the-kthread-api.patch
