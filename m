From: akpm@linux-foundation.org
Subject: - acpi-dock-use-dynamically-allocated-platform-device.patch removed from -mm tree
Date: Fri, 11 May 2007 22:15:52 -0700
Message-ID: <200705120515.l4C5FqFt001782@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44865 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756435AbXELFPy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:15:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kristen.c.accardi@intel.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     ACPI: dock: use dynamically allocated platform device
has been removed from the -mm tree.  Its filename was
     acpi-dock-use-dynamically-allocated-platform-device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ACPI: dock: use dynamically allocated platform device
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Get rid of no release function warnings by switching to dynamically allocating
the platform_device and using the platform device release routine in the base
driver.

Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/dock.c |   47 ++++++++++++++++++++----------------------
 1 file changed, 23 insertions(+), 24 deletions(-)

diff -puN drivers/acpi/dock.c~acpi-dock-use-dynamically-allocated-platform-device drivers/acpi/dock.c
--- a/drivers/acpi/dock.c~acpi-dock-use-dynamically-allocated-platform-device
+++ a/drivers/acpi/dock.c
@@ -41,7 +41,7 @@ MODULE_DESCRIPTION(ACPI_DOCK_DRIVER_DESC
 MODULE_LICENSE("GPL");
 
 static struct atomic_notifier_head dock_notifier_list;
-static struct platform_device dock_device;
+static struct platform_device *dock_device;
 static char dock_device_name[] = "dock";
 
 struct dock_station {
@@ -327,7 +327,7 @@ static void hotplug_dock_devices(struct 
 
 static void dock_event(struct dock_station *ds, u32 event, int num)
 {
-	struct device *dev = &dock_device.dev;
+	struct device *dev = &dock_device->dev;
 	/*
 	 * Indicate that the status of the dock station has
 	 * changed.
@@ -710,37 +710,36 @@ static int dock_add(acpi_handle handle)
 	ATOMIC_INIT_NOTIFIER_HEAD(&dock_notifier_list);
 
 	/* initialize platform device stuff */
-	dock_device.name = dock_device_name;
-	ret = platform_device_register(&dock_device);
-	if (ret) {
-		printk(KERN_ERR PREFIX "Error %d registering dock device\n", ret);
+	dock_device =
+		platform_device_register_simple(dock_device_name, 0, NULL, 0);
+	if (IS_ERR(dock_device)) {
 		kfree(dock_station);
 		dock_station = NULL;
-		return ret;
+		return PTR_ERR(dock_device);
 	}
-	ret = device_create_file(&dock_device.dev, &dev_attr_docked);
+	ret = device_create_file(&dock_device->dev, &dev_attr_docked);
 	if (ret) {
 		printk("Error %d adding sysfs file\n", ret);
-		platform_device_unregister(&dock_device);
+		platform_device_unregister(dock_device);
 		kfree(dock_station);
 		dock_station = NULL;
 		return ret;
 	}
-	ret = device_create_file(&dock_device.dev, &dev_attr_undock);
+	ret = device_create_file(&dock_device->dev, &dev_attr_undock);
 	if (ret) {
 		printk("Error %d adding sysfs file\n", ret);
-		device_remove_file(&dock_device.dev, &dev_attr_docked);
-		platform_device_unregister(&dock_device);
+		device_remove_file(&dock_device->dev, &dev_attr_docked);
+		platform_device_unregister(dock_device);
 		kfree(dock_station);
 		dock_station = NULL;
 		return ret;
 	}
-	ret = device_create_file(&dock_device.dev, &dev_attr_uid);
+	ret = device_create_file(&dock_device->dev, &dev_attr_uid);
 	if (ret) {
 		printk("Error %d adding sysfs file\n", ret);
-		device_remove_file(&dock_device.dev, &dev_attr_docked);
-		device_remove_file(&dock_device.dev, &dev_attr_undock);
-		platform_device_unregister(&dock_device);
+		device_remove_file(&dock_device->dev, &dev_attr_docked);
+		device_remove_file(&dock_device->dev, &dev_attr_undock);
+		platform_device_unregister(dock_device);
 		kfree(dock_station);
 		dock_station = NULL;
 		return ret;
@@ -779,10 +778,10 @@ static int dock_add(acpi_handle handle)
 dock_add_err:
 	kfree(dd);
 dock_add_err_unregister:
-	device_remove_file(&dock_device.dev, &dev_attr_docked);
-	device_remove_file(&dock_device.dev, &dev_attr_undock);
-	device_remove_file(&dock_device.dev, &dev_attr_uid);
-	platform_device_unregister(&dock_device);
+	device_remove_file(&dock_device->dev, &dev_attr_docked);
+	device_remove_file(&dock_device->dev, &dev_attr_undock);
+	device_remove_file(&dock_device->dev, &dev_attr_uid);
+	platform_device_unregister(dock_device);
 	kfree(dock_station);
 	dock_station = NULL;
 	return ret;
@@ -812,10 +811,10 @@ static int dock_remove(void)
 		printk(KERN_ERR "Error removing notify handler\n");
 
 	/* cleanup sysfs */
-	device_remove_file(&dock_device.dev, &dev_attr_docked);
-	device_remove_file(&dock_device.dev, &dev_attr_undock);
-	device_remove_file(&dock_device.dev, &dev_attr_uid);
-	platform_device_unregister(&dock_device);
+	device_remove_file(&dock_device->dev, &dev_attr_docked);
+	device_remove_file(&dock_device->dev, &dev_attr_undock);
+	device_remove_file(&dock_device->dev, &dev_attr_uid);
+	platform_device_unregister(dock_device);
 
 	/* free dock station memory */
 	kfree(dock_station);
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
