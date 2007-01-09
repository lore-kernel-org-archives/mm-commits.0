From: akpm@osdl.org
Subject: + acpi-bay-remove-acpi-driver-struct.patch added to -mm tree
Date: Mon, 08 Jan 2007 16:21:23 -0800
Message-ID: <200701090021.l090LNft023798@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57021 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728AbXAIAV0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 8 Jan 2007 19:21:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kristen.c.accardi@intel.com


The patch titled
     ACPI: bay: remove ACPI driver struct
has been added to the -mm tree.  Its filename is
     acpi-bay-remove-acpi-driver-struct.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ACPI: bay: remove ACPI driver struct
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>

The bay driver is a platform driver, and doesn't need to also be an acpi
driver.  Remove the acpi driver related structures and callbacks, they didn't
do anything anyway.  Switch to uevent for user space event notification.

Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/acpi/bay.c |   99 +------------------------------------------
 1 files changed, 4 insertions(+), 95 deletions(-)

diff -puN drivers/acpi/bay.c~acpi-bay-remove-acpi-driver-struct drivers/acpi/bay.c
--- a/drivers/acpi/bay.c~acpi-bay-remove-acpi-driver-struct
+++ a/drivers/acpi/bay.c
@@ -47,18 +47,6 @@ MODULE_LICENSE("GPL");
 	acpi_get_name(h, ACPI_FULL_PATHNAME, &buffer);\
 	printk(KERN_DEBUG PREFIX "%s: %s\n", prefix, s); }
 static void bay_notify(acpi_handle handle, u32 event, void *data);
-static int acpi_bay_add(struct acpi_device *device);
-static int acpi_bay_remove(struct acpi_device *device, int type);
-
-static struct acpi_driver acpi_bay_driver = {
-	.name = ACPI_BAY_DRIVER_NAME,
-	.class = ACPI_BAY_CLASS,
-	.ids = ACPI_BAY_HID,
-	.ops = {
-		.add = acpi_bay_add,
-		.remove = acpi_bay_remove,
-		},
-};
 
 struct bay {
 	acpi_handle handle;
@@ -234,14 +222,6 @@ int eject_removable_drive(struct device 
 }
 EXPORT_SYMBOL_GPL(eject_removable_drive);
 
-static int acpi_bay_add(struct acpi_device *device)
-{
-	bay_dprintk(device->handle, "adding bay device");
-	strcpy(acpi_device_name(device), "Dockable Bay");
-	strcpy(acpi_device_class(device), "bay");
-	return 0;
-}
-
 static int acpi_bay_add_fs(struct bay *bay)
 {
 	int ret;
@@ -339,52 +319,6 @@ bay_add_err:
 	return -ENODEV;
 }
 
-static int acpi_bay_remove(struct acpi_device *device, int type)
-{
-	/*** FIXME: do something here */
-	return 0;
-}
-
-/**
- * bay_create_acpi_device - add new devices to acpi
- * @handle - handle of the device to add
- *
- *  This function will create a new acpi_device for the given
- *  handle if one does not exist already.  This should cause
- *  acpi to scan for drivers for the given devices, and call
- *  matching driver's add routine.
- *
- *  Returns a pointer to the acpi_device corresponding to the handle.
- */
-static struct acpi_device * bay_create_acpi_device(acpi_handle handle)
-{
-	struct acpi_device *device = NULL;
-	struct acpi_device *parent_device;
-	acpi_handle parent;
-	int ret;
-
-	bay_dprintk(handle, "Trying to get device");
-	if (acpi_bus_get_device(handle, &device)) {
-		/*
-		 * no device created for this object,
-		 * so we should create one.
-		 */
-		bay_dprintk(handle, "No device for handle");
-		acpi_get_parent(handle, &parent);
-		if (acpi_bus_get_device(parent, &parent_device))
-			parent_device = NULL;
-
-		ret = acpi_bus_add(&device, parent_device, handle,
-			ACPI_BUS_TYPE_DEVICE);
-		if (ret) {
-			pr_debug("error adding bus, %x\n",
-				-ret);
-			return NULL;
-		}
-	}
-	return device;
-}
-
 /**
  * bay_notify - act upon an acpi bay notification
  * @handle: the bay handle
@@ -394,38 +328,19 @@ static struct acpi_device * bay_create_a
  */
 static void bay_notify(acpi_handle handle, u32 event, void *data)
 {
-	struct acpi_device *dev;
+	struct bay *bay_dev = (struct bay *)data;
+	struct device *dev = &bay_dev->pdev->dev;
 
 	bay_dprintk(handle, "Bay event");
 
 	switch(event) {
 	case ACPI_NOTIFY_BUS_CHECK:
-		printk("Bus Check\n");
 	case ACPI_NOTIFY_DEVICE_CHECK:
-		printk("Device Check\n");
-		dev = bay_create_acpi_device(handle);
-		if (dev)
-			acpi_bus_generate_event(dev, event, 0);
-		else
-			printk("No device for generating event\n");
-		/* wouldn't it be a good idea to just rescan SATA
-		 * right here?
-		 */
-		break;
 	case ACPI_NOTIFY_EJECT_REQUEST:
-		printk("Eject request\n");
-		dev = bay_create_acpi_device(handle);
-		if (dev)
-			acpi_bus_generate_event(dev, event, 0);
-		else
-			printk("No device for generating eventn");
-
-		/* wouldn't it be a good idea to just call the
-		 * eject_device here if we were a SATA device?
-		 */
+		kobject_uevent(&dev->kobj, KOBJ_CHANGE);
 		break;
 	default:
-		printk("unknown event %d\n", event);
+		printk(KERN_ERR PREFIX "Bay: unknown event %d\n", event);
 	}
 }
 
@@ -457,10 +372,6 @@ static int __init bay_init(void)
 	acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
 		ACPI_UINT32_MAX, find_bay, &bays, NULL);
 
-	if (bays)
-		if ((acpi_bus_register_driver(&acpi_bay_driver) < 0))
-			printk(KERN_ERR "Unable to register bay driver\n");
-
 	if (!bays)
 		return -ENODEV;
 
@@ -481,8 +392,6 @@ static void __exit bay_exit(void)
 		kfree(bay->name);
 		kfree(bay);
 	}
-
-	acpi_bus_unregister_driver(&acpi_bay_driver);
 }
 
 postcore_initcall(bay_init);
_

Patches currently in -mm which might be from kristen.c.accardi@intel.com are

git-acpi.patch
acpi-bay-remove-acpi-driver-struct.patch
acpi-make-bay-depend-on-dock.patch
git-libata-all.patch
