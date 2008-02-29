From: akpm@linux-foundation.org
Subject: + driver-core-fix-cleanup-when-failing-device_add.patch added to -mm tree
Date: Thu, 28 Feb 2008 21:32:52 -0800
Message-ID: <200802290532.m1T5Wqfc007523@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:45184 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751672AbYB2Fd3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Feb 2008 00:33:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cornelia.huck@de.ibm.com, greg@kroah.com, kay.sievers@vrfy.org


The patch titled
     Driver core: Fix cleanup when failing device_add().
has been added to the -mm tree.  Its filename is
     driver-core-fix-cleanup-when-failing-device_add.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -622,7 +622,8 @@ static struct kobject *get_device_parent
 static void cleanup_glue_dir(struct device *dev, struct kobject *glue_dir)
 {
 	/* see if we live in a "glue" directory */
-	if (!dev->class || glue_dir->kset != &dev->class->class_dirs)
+	if (!glue_dir || !dev->class ||
+	    glue_dir->kset != &dev->class->class_dirs)
 		return;
 
 	kobject_put(glue_dir);
@@ -781,7 +782,7 @@ int device_add(struct device *dev)
 	dev = get_device(dev);
 	if (!dev || !strlen(dev->bus_id)) {
 		error = -EINVAL;
-		goto Error;
+		goto Done;
 	}
 
 	pr_debug("device: '%s': %s\n", dev->bus_id, __FUNCTION__);
_

Patches currently in -mm which might be from cornelia.huck@de.ibm.com are

driver-core-fix-cleanup-when-failing-device_add.patch

