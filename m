From: akpm@linux-foundation.org
Subject: - driver-core-dont-fail-attaching-the-device-if-it.patch removed from -mm tree
Date: Fri, 09 Feb 2007 21:24:24 -0800
Message-ID: <200702100524.l1A5OOjh004584@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36702 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689AbXBJFYt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 Feb 2007 00:24:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cornelia.huck@de.ibm.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     driver core: don't fail attaching the device if it cannot be bound
has been removed from the -mm tree.  Its filename was
     driver-core-dont-fail-attaching-the-device-if-it.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: driver core: don't fail attaching the device if it cannot be bound
From: Cornelia Huck <cornelia.huck@de.ibm.com>

Don't fail bus_attach_device() if the device cannot be bound.

If dev->driver has been specified, reset it to NULL if device_bind_driver()
failed and add the device as an unbound device.  As a result,
bus_attach_device() now cannot fail, and we can remove some checking from
device_add().

Also remove an unneeded check in bus_rescan_devices_helper().

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/base.h |    2 +-
 drivers/base/bus.c  |   13 +++++--------
 drivers/base/core.c |    5 +----
 drivers/base/dd.c   |    6 +++++-
 4 files changed, 12 insertions(+), 14 deletions(-)

diff -puN drivers/base/base.h~driver-core-dont-fail-attaching-the-device-if-it drivers/base/base.h
--- a/drivers/base/base.h~driver-core-dont-fail-attaching-the-device-if-it
+++ a/drivers/base/base.h
@@ -16,7 +16,7 @@ extern int cpu_dev_init(void);
 extern int attribute_container_init(void);
 
 extern int bus_add_device(struct device * dev);
-extern int bus_attach_device(struct device * dev);
+extern void bus_attach_device(struct device * dev);
 extern void bus_remove_device(struct device * dev);
 extern struct bus_type *get_bus(struct bus_type * bus);
 extern void put_bus(struct bus_type * bus);
diff -puN drivers/base/bus.c~driver-core-dont-fail-attaching-the-device-if-it drivers/base/bus.c
--- a/drivers/base/bus.c~driver-core-dont-fail-attaching-the-device-if-it
+++ a/drivers/base/bus.c
@@ -420,21 +420,20 @@ out_put:
  *	- Add device to bus's list of devices.
  *	- Try to attach to driver.
  */
-int bus_attach_device(struct device * dev)
+void bus_attach_device(struct device * dev)
 {
 	struct bus_type *bus = dev->bus;
-	int ret = 0;
+	int ret;
 
 	if (bus) {
 		dev->is_registered = 1;
 		ret = device_attach(dev);
-		if (ret >= 0) {
+		WARN_ON(ret < 0);
+		if (ret >= 0)
 			klist_add_tail(&dev->knode_bus, &bus->klist_devices);
-			ret = 0;
-		} else
+		else
 			dev->is_registered = 0;
 	}
-	return ret;
 }
 
 /**
@@ -607,8 +606,6 @@ static int __must_check bus_rescan_devic
 		ret = device_attach(dev);
 		if (dev->parent)
 			up(&dev->parent->sem);
-		if (ret > 0)
-			ret = 0;
 	}
 	return ret < 0 ? ret : 0;
 }
diff -puN drivers/base/core.c~driver-core-dont-fail-attaching-the-device-if-it drivers/base/core.c
--- a/drivers/base/core.c~driver-core-dont-fail-attaching-the-device-if-it
+++ a/drivers/base/core.c
@@ -591,8 +591,7 @@ int device_add(struct device *dev)
 		goto BusError;
 	if (!dev->uevent_suppress)
 		kobject_uevent(&dev->kobj, KOBJ_ADD);
-	if ((error = bus_attach_device(dev)))
-		goto AttachError;
+	bus_attach_device(dev);
 	if (parent)
 		klist_add_tail(&dev->knode_parent, &parent->klist_children);
 
@@ -611,8 +610,6 @@ int device_add(struct device *dev)
  	kfree(class_name);
 	put_device(dev);
 	return error;
- AttachError:
-	bus_remove_device(dev);
  BusError:
 	device_pm_remove(dev);
  PMError:
diff -puN drivers/base/dd.c~driver-core-dont-fail-attaching-the-device-if-it drivers/base/dd.c
--- a/drivers/base/dd.c~driver-core-dont-fail-attaching-the-device-if-it
+++ a/drivers/base/dd.c
@@ -230,7 +230,7 @@ static int device_probe_drivers(void *da
  *
  *	Returns 1 if the device was bound to a driver;
  *	0 if no matching device was found or multithreaded probing is done;
- *	error code otherwise.
+ *	-ENODEV if the device is not registered.
  *
  *	When called for a USB interface, @dev->parent->sem must be held.
  */
@@ -244,6 +244,10 @@ int device_attach(struct device * dev)
 		ret = device_bind_driver(dev);
 		if (ret == 0)
 			ret = 1;
+		else {
+			dev->driver = NULL;
+			ret = 0;
+		}
 	} else {
 		if (dev->bus->multithread_probe)
 			probe_task = kthread_run(device_probe_drivers, dev,
_

Patches currently in -mm which might be from cornelia.huck@de.ibm.com are

origin.patch
git-s390.patch
