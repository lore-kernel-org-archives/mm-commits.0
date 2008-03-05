From: akpm@linux-foundation.org
Subject: - driver-core-fix-cleanup-when-failing-device_add.patch removed from -mm tree
Date: Tue, 04 Mar 2008 23:47:03 -0800
Message-ID: <200803050747.m257l3AK021825@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49901 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763058AbYCEHrt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 02:47:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cornelia.huck@de.ibm.com, greg@kroah.com, kay.sievers@vrfy.org, mm-commits@vger.kernel.org


The patch titled
     Driver core: Fix cleanup when failing device_add().
has been removed from the -mm tree.  Its filename was
     driver-core-fix-cleanup-when-failing-device_add.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Driver core: Fix cleanup when failing device_add().
From: Cornelia Huck <cornelia.huck@de.ibm.com>

- Don't call cleanup_device_parent() if we didn't call setup_parent().

- dev->kobj.parent may be NULL when cleanup_device_parent() is called, so we
  need to handle glue_dir == NULL in cleanup_glue_dir().

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/core.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/base/core.c~driver-core-fix-cleanup-when-failing-device_add drivers/base/core.c
--- a/drivers/base/core.c~driver-core-fix-cleanup-when-failing-device_add
+++ a/drivers/base/core.c
@@ -627,7 +627,8 @@ static struct kobject *get_device_parent
 static void cleanup_glue_dir(struct device *dev, struct kobject *glue_dir)
 {
 	/* see if we live in a "glue" directory */
-	if (!dev->class || glue_dir->kset != &dev->class->class_dirs)
+	if (!glue_dir || !dev->class ||
+	    glue_dir->kset != &dev->class->class_dirs)
 		return;
 
 	kobject_put(glue_dir);
@@ -779,7 +780,7 @@ int device_add(struct device *dev)
 	dev = get_device(dev);
 	if (!dev || !strlen(dev->bus_id)) {
 		error = -EINVAL;
-		goto Error;
+		goto Done;
 	}
 
 	pr_debug("device: '%s': %s\n", dev->bus_id, __FUNCTION__);
_

Patches currently in -mm which might be from cornelia.huck@de.ibm.com are


