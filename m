From: akpm@linux-foundation.org
Subject: + driver-core-clean-up-up-symlinks.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:35:10 -0800
Message-ID: <200702272035.l1RKZDAJ027568@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50710 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554AbXB0Ufs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 15:35:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jsimmons@infradead.org, cornelia.huck@de.ibm.com, greg@kroah.com


The patch titled
     driver core: clean up up symlinks
has been added to the -mm tree.  Its filename is
     driver-core-clean-up-up-symlinks.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: driver core: clean up up symlinks
From: James Simmons <jsimmons@infradead.org>

When a device fails to register the class symlinks where not cleaned up. 
This left a symlink in the /sys/class/"device"/ directory that pointed to
no where.  This caused the sysfs_follow_link Oops I reported earlier.  This
patch cleanups up the symlink.  Please apply.  Thank you.

Signed-off-by: James Simmons <jsimmons@infradead.org>
Cc: Greg KH <greg@kroah.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/core.c |   31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff -puN drivers/base/core.c~driver-core-clean-up-up-symlinks drivers/base/core.c
--- a/drivers/base/core.c~driver-core-clean-up-up-symlinks
+++ a/drivers/base/core.c
@@ -634,12 +634,41 @@ int device_add(struct device *dev)
 					     BUS_NOTIFY_DEL_DEVICE, dev);
 	device_remove_groups(dev);
  GroupError:
- 	device_remove_attrs(dev);
+	device_remove_attrs(dev);
  AttrsError:
 	if (dev->devt_attr) {
 		device_remove_file(dev, dev->devt_attr);
 		kfree(dev->devt_attr);
 	}
+
+	if (dev->class) {
+		sysfs_remove_link(&dev->kobj, "subsystem");
+		/* If this is not a "fake" compatible device, remove the
+		 * symlink from the class to the device. */
+		if (dev->kobj.parent != &dev->class->subsys.kset.kobj)
+			sysfs_remove_link(&dev->class->subsys.kset.kobj,
+					  dev->bus_id);
+#ifdef CONFIG_SYSFS_DEPRECATED
+		if (parent) {
+			char *class_name = make_class_name(dev->class->name,
+							   &dev->kobj);
+			if (class_name)
+				sysfs_remove_link(&dev->parent->kobj,
+						  class_name);
+			kfree(class_name);
+			sysfs_remove_link(&dev->kobj, "device");
+		}
+#endif
+
+		down(&dev->class->sem);
+		/* notify any interfaces that the device is now gone */
+		list_for_each_entry(class_intf, &dev->class->interfaces, node)
+			if (class_intf->remove_dev)
+				class_intf->remove_dev(dev, class_intf);
+		/* remove the device from the class list */
+		list_del_init(&dev->node);
+		up(&dev->class->sem);
+	}
  ueventattrError:
 	device_remove_file(dev, &dev->uevent_attr);
  attrError:
_

Patches currently in -mm which might be from jsimmons@infradead.org are

driver-core-clean-up-up-symlinks.patch
ps3fb-thread-updates.patch
ps3av-thread-updates.patch
ps3fb-kill-superfluous-zero-initializations.patch
ps3av-misc-updates.patch
aty128fb-fix-blanking.patch
change-rivafb_remove-to-__devexit.patch
atyfb-replace-busy-loop-with-mdelay.patch
fbdev-display-class.patch
