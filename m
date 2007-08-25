From: akpm@linux-foundation.org
Subject: - acpi-fix-oops-after-dock-driver-fails-to-initialize.patch removed from -mm tree
Date: Fri, 24 Aug 2007 20:21:40 -0700
Message-ID: <200708250321.l7P3Le6L027879@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43491 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751690AbXHYDWE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 23:22:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cebbert@redhat.com, kristen.c.accardi@intel.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     ACPI: fix oops after dock driver fails to initialize
has been removed from the -mm tree.  Its filename was
     acpi-fix-oops-after-dock-driver-fails-to-initialize.patch

This patch was dropped because it isn't in the present -mm lineup

------------------------------------------------------
Subject: ACPI: fix oops after dock driver fails to initialize
From: Chuck Ebbert <cebbert@redhat.com>

The driver tests the dock_station pointer for nonnull to check whether it has
initialized properly.  But in some cases dock_station will be non-null after
being freed when driver init fails.  Fix by zeroing the pointer after freeing.

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/dock.c |   26 ++++++++++++--------------
 1 files changed, 12 insertions(+), 14 deletions(-)

diff -puN drivers/acpi/dock.c~acpi-fix-oops-after-dock-driver-fails-to-initialize drivers/acpi/dock.c
--- a/drivers/acpi/dock.c~acpi-fix-oops-after-dock-driver-fails-to-initialize
+++ a/drivers/acpi/dock.c
@@ -714,31 +714,24 @@ static int dock_add(acpi_handle handle)
 	dock_device.name = dock_device_name;
 	ret = platform_device_register(&dock_device);
 	if (ret) {
-		printk(KERN_ERR PREFIX "Error %d registering dock device\n", ret);
-		kfree(dock_station);
-		return ret;
+		printk(KERN_ERR PREFIX "Error %d registering dock device\n",
+				ret);
+		goto err;
 	}
 	ret = device_create_file(&dock_device.dev, &dev_attr_docked);
 	if (ret) {
 		printk("Error %d adding sysfs file\n", ret);
-		platform_device_unregister(&dock_device);
-		kfree(dock_station);
-		return ret;
+		goto err_register;
 	}
 	ret = device_create_file(&dock_device.dev, &dev_attr_undock);
 	if (ret) {
 		printk("Error %d adding sysfs file\n", ret);
-		device_remove_file(&dock_device.dev, &dev_attr_docked);
-		platform_device_unregister(&dock_device);
-		kfree(dock_station);
-		return ret;
+		goto err_sysfs_1;
 	}
 	ret = device_create_file(&dock_device.dev, &dev_attr_uid);
 	if (ret) {
 		printk("Error %d adding sysfs file\n", ret);
-		platform_device_unregister(&dock_device);
-		kfree(dock_station);
-		return ret;
+		goto err_sysfs_2;
 	}
 
 	/* Find dependent devices */
@@ -749,7 +742,6 @@ static int dock_add(acpi_handle handle)
 	/* add the dock station as a device dependent on itself */
 	dd = alloc_dock_dependent_device(handle);
 	if (!dd) {
-		kfree(dock_station);
 		ret = -ENOMEM;
 		goto dock_add_err_unregister;
 	}
@@ -773,10 +765,15 @@ static int dock_add(acpi_handle handle)
 dock_add_err:
 	kfree(dd);
 dock_add_err_unregister:
+err_sysfs_2:
 	device_remove_file(&dock_device.dev, &dev_attr_docked);
+err_sysfs_1:
 	device_remove_file(&dock_device.dev, &dev_attr_undock);
+err_register:
 	platform_device_unregister(&dock_device);
+err:
 	kfree(dock_station);
+	dock_station = NULL;
 	return ret;
 }
 
@@ -810,6 +807,7 @@ static int dock_remove(void)
 
 	/* free dock station memory */
 	kfree(dock_station);
+	dock_station = NULL;
 	return 0;
 }
 
_

Patches currently in -mm which might be from cebbert@redhat.com are
