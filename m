From: akpm@linux-foundation.org
Subject: - driver-core-handles-kobject_uevent-failure-while-device_add.patch removed from -mm tree
Date: Wed, 21 Mar 2007 23:39:29 -0800
Message-ID: <200703220739.l2M7dUBm015072@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43007 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753183AbXCVHkJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Mar 2007 03:40:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dmonakhov@sw.ru, dmonakhov@openvz.org, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     driver core: handles kobject_uevent failure while device_add
has been removed from the -mm tree.  Its filename was
     driver-core-handles-kobject_uevent-failure-while-device_add.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: driver core: handles kobject_uevent failure while device_add
From: Dmitriy Monakhov <dmonakhov@sw.ru>

Signed-off-by: Monakhov Dmitriy <dmonakhov@openvz.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/core.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN drivers/base/core.c~driver-core-handles-kobject_uevent-failure-while-device_add drivers/base/core.c
--- a/drivers/base/core.c~driver-core-handles-kobject_uevent-failure-while-device_add
+++ a/drivers/base/core.c
@@ -714,8 +714,11 @@ int device_add(struct device *dev)
 		goto PMError;
 	if ((error = bus_add_device(dev)))
 		goto BusError;
-	if (!dev->uevent_suppress)
-		kobject_uevent(&dev->kobj, KOBJ_ADD);
+	if (!dev->uevent_suppress) {
+		error = kobject_uevent(&dev->kobj, KOBJ_ADD);
+		if (error)
+			goto UeventError;
+	}
 	bus_attach_device(dev);
 	if (parent)
 		klist_add_tail(&dev->knode_parent, &parent->klist_children);
@@ -735,6 +738,9 @@ int device_add(struct device *dev)
 	kfree(class_name);
 	put_device(dev);
 	return error;
+
+ UeventError:
+ 	bus_remove_device(dev);
  BusError:
 	device_pm_remove(dev);
  PMError:
_

Patches currently in -mm which might be from dmonakhov@sw.ru are

driver-core-handles-kobject_uevent-failure-while-device_add.patch
driver-core-handle-sysfs_op-failure-while-device_add.patch
git-libata-all.patch
freevxfs-possible-null-pointer-dereference-fix.patch
reiserfs-possible-null-pointer-dereference-during-resize.patch
ext3-dirindex-error-pointer-issues.patch
ext3-dirindex-error-pointer-issues-fix.patch
floppy-handle-device_create_file-failure-while-init.patch
splice-partial-write-handling-fix.patch
