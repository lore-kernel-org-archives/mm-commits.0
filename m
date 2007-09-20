From: akpm@linux-foundation.org
Subject: - driver-core-fix-deprectated-sysfs-structure-for-nested-class-devices.patch removed from -mm tree
Date: Thu, 20 Sep 2007 14:16:04 -0700
Message-ID: <200709202116.l8KLG4LR002977@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51130 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752213AbXITV3N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 17:29:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dtor@insightbb.com, anssi.hannula@gmail.com, dtor@mail.ru, greg@kroah.com, kay.sievers@vrfy.org, mm-commits@vger.kernel.org


The patch titled
     Driver core: fix deprectated sysfs structure for nested class devices
has been removed from the -mm tree.  Its filename was
     driver-core-fix-deprectated-sysfs-structure-for-nested-class-devices.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Driver core: fix deprectated sysfs structure for nested class devices
From: Dmitry Torokhov <dtor@insightbb.com>

Nested class devices used to have 'device' symlink point to a real
(physical) device instead of a parent class device.  When converting
subsystems to struct device we need to keep doing what class devices did if
CONFIG_SYSFS_DEPRECATED is Y, otherwise parts of udev break.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Acked-by: Greg KH <greg@kroah.com>
Tested-by: Anssi Hannula <anssi.hannula@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/core.c |   29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff -puN drivers/base/core.c~driver-core-fix-deprectated-sysfs-structure-for-nested-class-devices drivers/base/core.c
--- a/drivers/base/core.c~driver-core-fix-deprectated-sysfs-structure-for-nested-class-devices
+++ a/drivers/base/core.c
@@ -679,14 +679,26 @@ static int device_add_class_symlinks(str
 			goto out_subsys;
 	}
 	if (dev->parent) {
-		error = sysfs_create_link(&dev->kobj, &dev->parent->kobj,
-					  "device");
-		if (error)
-			goto out_busid;
 #ifdef CONFIG_SYSFS_DEPRECATED
 		{
-			char * class_name = make_class_name(dev->class->name,
-								&dev->kobj);
+			struct device *parent = dev->parent;
+			char *class_name;
+
+			/*
+			 * In old sysfs stacked class devices had 'device'
+			 * link pointing to real device instead of parent
+			 */
+			while (parent->class && !parent->bus && parent->parent)
+				parent = parent->parent;
+
+			error = sysfs_create_link(&dev->kobj,
+						  &parent->kobj,
+						  "device");
+			if (error)
+				goto out_busid;
+
+			class_name = make_class_name(dev->class->name,
+							&dev->kobj);
 			if (class_name)
 				error = sysfs_create_link(&dev->parent->kobj,
 							&dev->kobj, class_name);
@@ -694,6 +706,11 @@ static int device_add_class_symlinks(str
 			if (error)
 				goto out_device;
 		}
+#else
+		error = sysfs_create_link(&dev->kobj, &dev->parent->kobj,
+					  "device");
+		if (error)
+			goto out_busid;
 #endif
 	}
 	return 0;
_

Patches currently in -mm which might be from dtor@insightbb.com are

git-input.patch
hdaps-switch-to-using-input-polldev.patch
