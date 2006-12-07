From: akpm@osdl.org
Subject: - make-the-dock-station-driver-a-platform-device-driver.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:18:25 -0800
Message-ID: <200612072318.kB7NIPEK031024@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53982 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163910AbWLGXS1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:18:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kristen.c.accardi@intel.com, mm-commits@vger.kernel.org


The patch titled
     Make the dock station driver a platform device driver
has been removed from the -mm tree.  Its filename was
     make-the-dock-station-driver-a-platform-device-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Make the dock station driver a platform device driver
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Make the dock station driver a platform device driver so that we can create
sysfs entries under /sys/device/platform.

Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/acpi/dock.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff -puN drivers/acpi/dock.c~make-the-dock-station-driver-a-platform-device-driver drivers/acpi/dock.c
--- a/drivers/acpi/dock.c~make-the-dock-station-driver-a-platform-device-driver
+++ a/drivers/acpi/dock.c
@@ -27,6 +27,7 @@
 #include <linux/init.h>
 #include <linux/types.h>
 #include <linux/notifier.h>
+#include <linux/platform_device.h>
 #include <linux/jiffies.h>
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
@@ -39,6 +40,8 @@ MODULE_DESCRIPTION(ACPI_DOCK_DRIVER_NAME
 MODULE_LICENSE("GPL");
 
 static struct atomic_notifier_head dock_notifier_list;
+static struct platform_device dock_device;
+static char dock_device_name[] = "dock";
 
 struct dock_station {
 	acpi_handle handle;
@@ -629,6 +632,15 @@ static int dock_add(acpi_handle handle)
 	mutex_init(&dock_station->hp_lock);
 	ATOMIC_INIT_NOTIFIER_HEAD(&dock_notifier_list);
 
+	/* initialize platform device stuff */
+	dock_device.name = dock_device_name;
+	ret = platform_device_register(&dock_device);
+	if (ret) {
+		printk(KERN_ERR PREFIX "Error registering dock device\n", ret);
+		kfree(dock_station);
+		return ret;
+	}
+
 	/* Find dependent devices */
 	acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
 			    ACPI_UINT32_MAX, find_dock_devices, dock_station,
@@ -638,7 +650,8 @@ static int dock_add(acpi_handle handle)
 	dd = alloc_dock_dependent_device(handle);
 	if (!dd) {
 		kfree(dock_station);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto dock_add_err_unregister;
 	}
 	add_dock_dependent_device(dock_station, dd);
 
@@ -658,8 +671,10 @@ static int dock_add(acpi_handle handle)
 	return 0;
 
 dock_add_err:
-	kfree(dock_station);
 	kfree(dd);
+dock_add_err_unregister:
+	platform_device_unregister(&dock_device);
+	kfree(dock_station);
 	return ret;
 }
 
@@ -686,6 +701,9 @@ static int dock_remove(void)
 	if (ACPI_FAILURE(status))
 		printk(KERN_ERR "Error removing notify handler\n");
 
+	/* cleanup sysfs */
+	platform_device_unregister(&dock_device);
+
 	/* free dock station memory */
 	kfree(dock_station);
 	return 0;
_

Patches currently in -mm which might be from kristen.c.accardi@intel.com are

origin.patch
git-acpi.patch
git-libata-all.patch

