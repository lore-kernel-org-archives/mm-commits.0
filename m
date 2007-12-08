From: akpm@linux-foundation.org
Subject: - driver-core-add-driver_create_group.patch removed from -mm tree
Date: Fri, 07 Dec 2007 17:30:19 -0800
Message-ID: <200712080130.lB81UJi2013532@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51603 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754272AbXLHBjq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Dec 2007 20:39:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: greg@kroah.com, arthur.jones@qlogic.com, gregkh@suse.de, rdreier@cisco.com, mm-commits@vger.kernel.org


The patch titled
     Driver core: add driver_create_group
has been removed from the -mm tree.  Its filename was
     driver-core-add-driver_create_group.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Driver core: add driver_create_group
From: Greg KH <greg@kroah.com>

Add function for drivers to be able to create and remove sysfs attribute
groups without having to fall back to the "raw" sysfs calls.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Arthur Jones <arthur.jones@qlogic.com>
Cc: Roland Dreier <rdreier@cisco.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/driver.c                     |   37 ++++++++++++++++++++
 drivers/infiniband/hw/ipath/ipath_sysfs.c |   15 +-------
 include/linux/device.h                    |    5 ++
 3 files changed, 44 insertions(+), 13 deletions(-)

diff -puN drivers/base/driver.c~driver-core-add-driver_create_group drivers/base/driver.c
--- a/drivers/base/driver.c~driver-core-add-driver_create_group
+++ a/drivers/base/driver.c
@@ -123,6 +123,43 @@ void driver_remove_file(struct device_dr
 	}
 }
 
+/**
+ * driver_create_group - create group of sysfs files for a driver.
+ * @drv: driver.
+ * @group: pointer to a group of attributes to add
+ *
+ * Adds a group of sysfs attributes to the specified driver.
+ */
+int driver_create_group(struct device_driver *drv,
+			struct attribute_group *group)
+{
+	int error;
+	if (get_driver(drv)) {
+		error = sysfs_create_group(&drv->p->kobj, group);
+		put_driver(drv);
+	} else
+		error = -EINVAL;
+	return error;
+}
+EXPORT_SYMBOL_GPL(driver_create_group);
+
+/**
+ * driver_remove_file - remove group of sysfs files for a driver.
+ * @drv: driver.
+ * @group: pointer to a group of attributes to add.
+ *
+ * Removes a group of sysfs attributes that was previously created with a
+ * call to driver_create_group().
+ */
+void driver_remove_group(struct device_driver *drv,
+			 struct attribute_group *group)
+{
+	if (get_driver(drv)) {
+		sysfs_remove_group(&drv->p->kobj, group);
+		put_driver(drv);
+	}
+}
+EXPORT_SYMBOL_GPL(driver_remove_group);
 
 /**
  *	get_driver - increment driver reference count.
diff -puN drivers/infiniband/hw/ipath/ipath_sysfs.c~driver-core-add-driver_create_group drivers/infiniband/hw/ipath/ipath_sysfs.c
--- a/drivers/infiniband/hw/ipath/ipath_sysfs.c~driver-core-add-driver_create_group
+++ a/drivers/infiniband/hw/ipath/ipath_sysfs.c
@@ -757,20 +757,19 @@ int ipath_driver_create_group(struct dev
 {
 	int ret;
 
-	ret = sysfs_create_group(&drv->kobj, &driver_attr_group);
+	ret = driver_create_group(drv, &driver_attr_group);
 
 	return ret;
 }
 
 void ipath_driver_remove_group(struct device_driver *drv)
 {
-	sysfs_remove_group(&drv->kobj, &driver_attr_group);
+	driver_remove_group(drv, &driver_attr_group);
 }
 
 int ipath_device_create_group(struct device *dev, struct ipath_devdata *dd)
 {
 	int ret;
-	char unit[5];
 
 	ret = sysfs_create_group(&dev->kobj, &dev_attr_group);
 	if (ret)
@@ -780,11 +779,6 @@ int ipath_device_create_group(struct dev
 	if (ret)
 		goto bail_attrs;
 
-	snprintf(unit, sizeof(unit), "%02d", dd->ipath_unit);
-	ret = sysfs_create_link(&dev->driver->kobj, &dev->kobj, unit);
-	if (ret == 0)
-		goto bail;
-
 	sysfs_remove_group(&dev->kobj, &dev_counter_attr_group);
 bail_attrs:
 	sysfs_remove_group(&dev->kobj, &dev_attr_group);
@@ -794,11 +788,6 @@ bail:
 
 void ipath_device_remove_group(struct device *dev, struct ipath_devdata *dd)
 {
-	char unit[5];
-
-	snprintf(unit, sizeof(unit), "%02d", dd->ipath_unit);
-	sysfs_remove_link(&dev->driver->kobj, unit);
-
 	sysfs_remove_group(&dev->kobj, &dev_counter_attr_group);
 	sysfs_remove_group(&dev->kobj, &dev_attr_group);
 
diff -puN include/linux/device.h~driver-core-add-driver_create_group include/linux/device.h
--- a/include/linux/device.h~driver-core-add-driver_create_group
+++ a/include/linux/device.h
@@ -152,6 +152,11 @@ struct driver_attribute driver_attr_##_n
 extern int __must_check driver_create_file(struct device_driver *,
 					struct driver_attribute *);
 extern void driver_remove_file(struct device_driver *, struct driver_attribute *);
+extern int __must_check driver_create_group(struct device_driver *,
+					    struct attribute_group *);
+extern void driver_remove_group(struct device_driver *,
+				struct attribute_group *);
+
 
 extern int __must_check driver_for_each_device(struct device_driver * drv,
 		struct device *start, void *data,
_

Patches currently in -mm which might be from greg@kroah.com are

gregkh-driver-kset-convert-to-kobj_sysfs_ops-vs-git-acpi.patch
unbork-gregkh-driver-kset-convert-sys-devices-to-use-kset_create-vioc.patch
quirk-enable-msi-mapping-on-ht1000.patch
belkin_sa-clean-up-for-new-style-termios-and-speed.patch
keyspan_pda-clean-up-speed-handling.patch
mct232-speed-new-termios-and-compliance-cleanups.patch
mct232-speed-new-termios-and-compliance-cleanups-fix.patch
ohci-hcdcohci_irq-locking-fix.patch
usb-testing-driver-dont-free-a-locked-mutex.patch
usb-mon-nopage.patch
git-x86.patch
add-accessors-for-segment_boundary_mask-in.patch
pci-add-dma-segment-boundary-support.patch
swiotlb-respect-the-segment-boundary-limits.patch
call-dma_set_seg_boundary-in-__scsi_alloc_queue.patch
dca-convert-struct-class_device-to-struct-device.patch
dont-touch-fs_struct-in-usermodehelper.patch
usb-net2280-cant-have-a-function-called-show_registers.patch
make-sure-nobodys-leaking-resources.patch
workaround-for-a-pci-restoring-bug.patch
