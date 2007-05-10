From: akpm@linux-foundation.org
Subject: + acpi-dock-fix-opps-after-dock-driver-fails-to-initialize.patch added to -mm tree
Date: Wed, 09 May 2007 21:15:57 -0700
Message-ID: <200705100415.l4A4Fvpa011776@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38476 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754649AbXEJEQG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 00:16:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cebbert@redhat.com, kristen.c.accardi@intel.com


The patch titled
     ACPI: dock: fix opps after dock driver fails to initialize
has been added to the -mm tree.  Its filename is
     acpi-dock-fix-opps-after-dock-driver-fails-to-initialize.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
acpi-dock-fix-opps-after-dock-driver-fails-to-initialize.patch
acpi-fix-oops-after-dock-driver-fails-to-initialize.patch
