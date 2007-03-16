From: akpm@linux-foundation.org
Subject: + driver-core-handle-sysfs_op-failure-while-device_add.patch added to -mm tree
Date: Thu, 15 Mar 2007 17:55:58 -0800
Message-ID: <200703160155.l2G1twpI032419@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48872 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072AbXCPB4i (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 21:56:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmonakhov@sw.ru, dmonakhov@openvz.org, greg@kroah.com


The patch titled
     driver core: handle sysfs_op failure while device_add
has been added to the -mm tree.  Its filename is
     driver-core-handle-sysfs_op-failure-while-device_add.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: driver core: handle sysfs_op failure while device_add
From: Dmitriy Monakhov <dmonakhov@sw.ru>

- rearrange error path sequence, in order to make it more correct.  In fact
  if initial sequance was doA(); doB(); doC(); we should undo it with folowing
  sequance undoC(); undoB(); undoA();

- handle sysfs_ops failure

This patch kills "ignoring return value of 'sysfs_create_link'" warning
message.

Signed-off-by: Monakhov Dmitriy <dmonakhov@openvz.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/core.c |   47 +++++++++++++++++++++++++++---------------
 1 file changed, 31 insertions(+), 16 deletions(-)

diff -puN drivers/base/core.c~driver-core-handle-sysfs_op-failure-while-device_add drivers/base/core.c
--- a/drivers/base/core.c~driver-core-handle-sysfs_op-failure-while-device_add
+++ a/drivers/base/core.c
@@ -636,22 +636,34 @@ int device_add(struct device *dev)
 	}
 
 	if (dev->class) {
-		sysfs_create_link(&dev->kobj, &dev->class->subsys.kset.kobj,
-				  "subsystem");
+		error = sysfs_create_link(&dev->kobj,
+				&dev->class->subsys.kset.kobj, "subsystem");
+		if (error)
+			goto ueventattrError;
 		/* If this is not a "fake" compatible device, then create the
 		 * symlink from the class to the device. */
-		if (dev->kobj.parent != &dev->class->subsys.kset.kobj)
-			sysfs_create_link(&dev->class->subsys.kset.kobj,
-					  &dev->kobj, dev->bus_id);
+		if (dev->kobj.parent != &dev->class->subsys.kset.kobj) {
+			error = sysfs_create_link(
+					&dev->class->subsys.kset.kobj,
+					&dev->kobj, dev->bus_id);
+			if (error)
+				goto busLinkErr;
+		}
 		if (parent) {
-			sysfs_create_link(&dev->kobj, &dev->parent->kobj,
-							"device");
+			error = sysfs_create_link(&dev->kobj,
+					&dev->parent->kobj, "device");
+			if (error)
+				goto deviceLinkErr;
 #ifdef CONFIG_SYSFS_DEPRECATED
 			class_name = make_class_name(dev->class->name,
 							&dev->kobj);
-			if (class_name)
-				sysfs_create_link(&dev->parent->kobj,
-						  &dev->kobj, class_name);
+			if (class_name) {
+				error = sysfs_create_link(
+						&dev->parent->kobj,
+						&dev->kobj, class_name);
+				if (error)
+					goto classLinkErr;
+			}
 #endif
 		}
 	}
@@ -703,12 +715,6 @@ int device_add(struct device *dev)
 	}
 
 	if (dev->class) {
-		sysfs_remove_link(&dev->kobj, "subsystem");
-		/* If this is not a "fake" compatible device, remove the
-		 * symlink from the class to the device. */
-		if (dev->kobj.parent != &dev->class->subsys.kset.kobj)
-			sysfs_remove_link(&dev->class->subsys.kset.kobj,
-					  dev->bus_id);
 		if (parent) {
 #ifdef CONFIG_SYSFS_DEPRECATED
 			char *class_name = make_class_name(dev->class->name,
@@ -718,8 +724,17 @@ int device_add(struct device *dev)
 						  class_name);
 			kfree(class_name);
 #endif
+classLinkErr:
 			sysfs_remove_link(&dev->kobj, "device");
 		}
+deviceLinkErr:
+		/* If this is not a "fake" compatible device, remove the
+		 * symlink from the class to the device. */
+		if (dev->kobj.parent != &dev->class->subsys.kset.kobj)
+			sysfs_remove_link(&dev->class->subsys.kset.kobj,
+					  dev->bus_id);
+busLinkErr:
+		sysfs_remove_link(&dev->kobj, "subsystem");
 	}
  ueventattrError:
 	device_remove_file(dev, &dev->uevent_attr);
_

Patches currently in -mm which might be from dmonakhov@sw.ru are

origin.patch
driver-core-handles-kobject_uevent-failure-while-device_add.patch
driver-core-handle-sysfs_op-failure-while-device_add.patch
git-libata-all.patch
freevxfs-possible-null-pointer-dereference-fix.patch
reiserfs-possible-null-pointer-dereference-during-resize.patch
ext3-dirindex-error-pointer-issues.patch
floppy-handle-device_create_file-failure-while-init.patch
splice-partial-write-handling-fix.patch
