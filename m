From: akpm@linux-foundation.org
Subject: - driver-core-check-return-code-of-sysfs_create_link-fix.patch removed from -mm tree
Date: Mon, 09 Jul 2007 11:38:00 -0700
Message-ID: <200707091838.l69Ic04U000700@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34789 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754396AbXGISiL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 14:38:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cornelia.huck@de.ibm.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     driver-core-check-return-code-of-sysfs_create_link fix
has been removed from the -mm tree.  Its filename was
     driver-core-check-return-code-of-sysfs_create_link-fix.patch

This patch was dropped because it was folded into driver-core-check-return-code-of-sysfs_create_link.patch

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
 	/* only bus-device parents get a "device"-link */
 	if (dev->parent && dev->parent->bus) {
 		error = sysfs_create_link(&dev->kobj, &dev->parent->kobj,
@@ -690,7 +690,8 @@ out_device:
 		sysfs_remove_link(&dev->kobj, "device");
 #endif
 out_busid:
-	sysfs_remove_link(&dev->class->subsys.kobj, dev->bus_id);
+	if (dev->kobj.parent != &dev->class->subsys.kobj)
+		sysfs_remove_link(&dev->class->subsys.kobj, dev->bus_id);
 out_subsys:
 	sysfs_remove_link(&dev->kobj, "subsystem");
 out:
@@ -713,7 +714,8 @@ static void device_remove_class_symlinks
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
scsi-dont-build-scsi_dma_mapunmap-for-has_dma.patch
scsi-dont-build-scsi_dma_mapunmap-for-has_dma-fix.patch
dma-mapping-prevent-dma-dependent-code-from-linking-on.patch
