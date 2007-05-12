From: akpm@linux-foundation.org
Subject: - acpi-dock-fix-opps-after-dock-driver-fails-to-initialize.patch removed from -mm tree
Date: Fri, 11 May 2007 22:15:50 -0700
Message-ID: <200705120515.l4C5Foos001779@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51366 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756435AbXELFP7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:15:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cebbert@redhat.com, kristen.c.accardi@intel.com, mm-commits@vger.kernel.org


The patch titled
     ACPI: dock: fix opps after dock driver fails to initialize
has been removed from the -mm tree.  Its filename was
     acpi-dock-fix-opps-after-dock-driver-fails-to-initialize.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ACPI: dock: fix opps after dock driver fails to initialize
From: Chuck Ebbert <cebbert@redhat.com>

The driver tests the dock_station pointer for nonnull to check whether it has
initialized properly.  But in some cases dock_station will be non-null after
being freed when driver init fails.  Fix by zeroing the pointer after freeing.

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/dock.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/acpi/dock.c~acpi-dock-fix-opps-after-dock-driver-fails-to-initialize drivers/acpi/dock.c
--- a/drivers/acpi/dock.c~acpi-dock-fix-opps-after-dock-driver-fails-to-initialize
+++ a/drivers/acpi/dock.c
@@ -715,6 +715,7 @@ static int dock_add(acpi_handle handle)
 	if (ret) {
 		printk(KERN_ERR PREFIX "Error %d registering dock device\n", ret);
 		kfree(dock_station);
+		dock_station = NULL;
 		return ret;
 	}
 	ret = device_create_file(&dock_device.dev, &dev_attr_docked);
@@ -722,6 +723,7 @@ static int dock_add(acpi_handle handle)
 		printk("Error %d adding sysfs file\n", ret);
 		platform_device_unregister(&dock_device);
 		kfree(dock_station);
+		dock_station = NULL;
 		return ret;
 	}
 	ret = device_create_file(&dock_device.dev, &dev_attr_undock);
@@ -730,6 +732,7 @@ static int dock_add(acpi_handle handle)
 		device_remove_file(&dock_device.dev, &dev_attr_docked);
 		platform_device_unregister(&dock_device);
 		kfree(dock_station);
+		dock_station = NULL;
 		return ret;
 	}
 	ret = device_create_file(&dock_device.dev, &dev_attr_uid);
@@ -739,6 +742,7 @@ static int dock_add(acpi_handle handle)
 		device_remove_file(&dock_device.dev, &dev_attr_undock);
 		platform_device_unregister(&dock_device);
 		kfree(dock_station);
+		dock_station = NULL;
 		return ret;
 	}
 
@@ -751,6 +755,7 @@ static int dock_add(acpi_handle handle)
 	dd = alloc_dock_dependent_device(handle);
 	if (!dd) {
 		kfree(dock_station);
+		dock_station = NULL;
 		ret = -ENOMEM;
 		goto dock_add_err_unregister;
 	}
@@ -779,6 +784,7 @@ dock_add_err_unregister:
 	device_remove_file(&dock_device.dev, &dev_attr_uid);
 	platform_device_unregister(&dock_device);
 	kfree(dock_station);
+	dock_station = NULL;
 	return ret;
 }
 
@@ -813,6 +819,7 @@ static int dock_remove(void)
 
 	/* free dock station memory */
 	kfree(dock_station);
+	dock_station = NULL;
 	return 0;
 }
 
_

Patches currently in -mm which might be from cebbert@redhat.com are

origin.patch
git-acpi.patch
i386-pci-fixup-for-siemens-nixdorf-ag-fsc-multiprocessor-interrupt-controllers.patch
