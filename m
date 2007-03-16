From: akpm@linux-foundation.org
Subject: + driver-core-handles-kobject_uevent-failure-while-device_add.patch added to -mm tree
Date: Thu, 15 Mar 2007 17:55:55 -0800
Message-ID: <200703160155.l2G1ttvl032416@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48871 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbXCPB4e (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 21:56:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmonakhov@sw.ru, dmonakhov@openvz.org, greg@kroah.com


The patch titled
     driver core: handles kobject_uevent failure while device_add
has been added to the -mm tree.  Its filename is
     driver-core-handles-kobject_uevent-failure-while-device_add.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -662,8 +662,11 @@ int device_add(struct device *dev)
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
@@ -683,6 +686,9 @@ int device_add(struct device *dev)
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

origin.patch
driver-core-handles-kobject_uevent-failure-while-device_add.patch
driver-core-handle-sysfs_op-failure-while-device_add.patch
git-libata-all.patch
freevxfs-possible-null-pointer-dereference-fix.patch
reiserfs-possible-null-pointer-dereference-during-resize.patch
ext3-dirindex-error-pointer-issues.patch
floppy-handle-device_create_file-failure-while-init.patch
splice-partial-write-handling-fix.patch
