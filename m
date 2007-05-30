From: akpm@linux-foundation.org
Subject: + driver-core-check-return-code-of-sysfs_create_link-fix.patch added to -mm tree
Date: Tue, 29 May 2007 21:47:23 -0700
Message-ID: <200705300447.l4U4lM5E019434@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:42730 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751270AbXE3Er3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 May 2007 00:47:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cornelia.huck@de.ibm.com, greg@kroah.com


The patch titled
     driver-core-check-return-code-of-sysfs_create_link fix
has been added to the -mm tree.  Its filename is
     driver-core-check-return-code-of-sysfs_create_link-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: driver-core-check-return-code-of-sysfs_create_link fix
From: Cornelia Huck <cornelia.huck@de.ibm.com>

Fix check when to create certain symlinks (the device link and some
compatible links).

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/core.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff -puN drivers/base/core.c~driver-core-check-return-code-of-sysfs_create_link-fix drivers/base/core.c
--- a/drivers/base/core.c~driver-core-check-return-code-of-sysfs_create_link-fix
+++ a/drivers/base/core.c
@@ -657,12 +657,12 @@ static int device_add_class_symlinks(str
 	 * If this is not a "fake" compatible device, then create the
 	 * symlink from the class to the device.
 	 */
-	if (dev->kobj.parent == &dev->class->subsys.kobj)
-		return 0;
-	error = sysfs_create_link(&dev->class->subsys.kobj, &dev->kobj,
-				  dev->bus_id);
-	if (error)
-		goto out_subsys;
+	if (dev->kobj.parent != &dev->class->subsys.kobj) {
+		error = sysfs_create_link(&dev->class->subsys.kobj, &dev->kobj,
+					  dev->bus_id);
+		if (error)
+			goto out_subsys;
+	}
 	if (dev->parent) {
 		error = sysfs_create_link(&dev->kobj, &dev->parent->kobj,
 					  "device");
@@ -689,7 +689,8 @@ out_device:
 		sysfs_remove_link(&dev->kobj, "device");
 #endif
 out_busid:
-	sysfs_remove_link(&dev->class->subsys.kobj, dev->bus_id);
+	if (dev->kobj.parent != &dev->class->subsys.kobj)
+		sysfs_remove_link(&dev->class->subsys.kobj, dev->bus_id);
 out_subsys:
 	sysfs_remove_link(&dev->kobj, "subsystem");
 out:
@@ -712,7 +713,8 @@ static void device_remove_class_symlinks
 #endif
 		sysfs_remove_link(&dev->kobj, "device");
 	}
-	sysfs_remove_link(&dev->class->subsys.kobj, dev->bus_id);
+	if (dev->kobj.parent != &dev->class->subsys.kobj)
+		sysfs_remove_link(&dev->class->subsys.kobj, dev->bus_id);
 	sysfs_remove_link(&dev->kobj, "subsystem");
 }
 
_

Patches currently in -mm which might be from cornelia.huck@de.ibm.com are

driver-core-check-return-code-of-sysfs_create_link.patch
driver-core-check-return-code-of-sysfs_create_link-fix.patch
driver-core-coding-style-cleanup.patch
partitions-check-the-return-value-of-kobject_add-etc.patch
