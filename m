From: akpm@linux-foundation.org
Subject: + struct-class-sem-to-mutex-converting.patch added to -mm tree
Date: Mon, 12 May 2008 14:54:52 -0700
Message-ID: <200805122154.m4CLsqNs011148@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36022 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753154AbYELVy4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 May 2008 17:54:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidave.darkstar@gmail.com, greg@kroah.com, kay.sievers@vrfy.org


The patch titled
     driver core: struct class sem to mutex conversion
has been added to the -mm tree.  Its filename is
     struct-class-sem-to-mutex-converting.patch

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
Subject: driver core: struct class sem to mutex conversion
From: Dave Young <hidave.darkstar@gmail.com>

The class_device is already removed, so do the class->sem to mutex conversion.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/class.c   |   22 +++++++++++-----------
 drivers/base/core.c    |    9 ++++-----
 include/linux/device.h |    3 ++-
 3 files changed, 17 insertions(+), 17 deletions(-)

diff -puN drivers/base/class.c~struct-class-sem-to-mutex-converting drivers/base/class.c
--- a/drivers/base/class.c~struct-class-sem-to-mutex-converting
+++ a/drivers/base/class.c
@@ -144,7 +144,7 @@ int class_register(struct class *cls)
 	INIT_LIST_HEAD(&cls->devices);
 	INIT_LIST_HEAD(&cls->interfaces);
 	kset_init(&cls->class_dirs);
-	init_MUTEX(&cls->sem);
+	mutex_init(&cls->mutex);
 	error = kobject_set_name(&cls->subsys.kobj, "%s", cls->name);
 	if (error)
 		return error;
@@ -266,7 +266,7 @@ char *make_class_name(const char *name, 
  * We check the return of @fn each time. If it returns anything
  * other than 0, we break out and return that value.
  *
- * Note, we hold class->sem in this function, so it can not be
+ * Note, we hold class->mutex in this function, so it can not be
  * re-acquired in @fn, otherwise it will self-deadlocking. For
  * example, calls to add or remove class members would be verboten.
  */
@@ -278,7 +278,7 @@ int class_for_each_device(struct class *
 
 	if (!class)
 		return -EINVAL;
-	down(&class->sem);
+	mutex_lock(&class->mutex);
 	list_for_each_entry(dev, &class->devices, node) {
 		dev = get_device(dev);
 		if (dev) {
@@ -289,7 +289,7 @@ int class_for_each_device(struct class *
 		if (error)
 			break;
 	}
-	up(&class->sem);
+	mutex_unlock(&class->mutex);
 
 	return error;
 }
@@ -311,7 +311,7 @@ EXPORT_SYMBOL_GPL(class_for_each_device)
  *
  * Note, you will need to drop the reference with put_device() after use.
  *
- * We hold class->sem in this function, so it can not be
+ * We hold class->mutex in this function, so it can not be
  * re-acquired in @match, otherwise it will self-deadlocking. For
  * example, calls to add or remove class members would be verboten.
  */
@@ -324,7 +324,7 @@ struct device *class_find_device(struct 
 	if (!class)
 		return NULL;
 
-	down(&class->sem);
+	mutex_lock(&class->mutex);
 	list_for_each_entry(dev, &class->devices, node) {
 		dev = get_device(dev);
 		if (dev) {
@@ -336,7 +336,7 @@ struct device *class_find_device(struct 
 		} else
 			break;
 	}
-	up(&class->sem);
+	mutex_unlock(&class->mutex);
 
 	return found ? dev : NULL;
 }
@@ -354,13 +354,13 @@ int class_interface_register(struct clas
 	if (!parent)
 		return -EINVAL;
 
-	down(&parent->sem);
+	mutex_lock(&parent->mutex);
 	list_add_tail(&class_intf->node, &parent->interfaces);
 	if (class_intf->add_dev) {
 		list_for_each_entry(dev, &parent->devices, node)
 			class_intf->add_dev(dev, class_intf);
 	}
-	up(&parent->sem);
+	mutex_unlock(&parent->mutex);
 
 	return 0;
 }
@@ -373,13 +373,13 @@ void class_interface_unregister(struct c
 	if (!parent)
 		return;
 
-	down(&parent->sem);
+	mutex_lock(&parent->mutex);
 	list_del_init(&class_intf->node);
 	if (class_intf->remove_dev) {
 		list_for_each_entry(dev, &parent->devices, node)
 			class_intf->remove_dev(dev, class_intf);
 	}
-	up(&parent->sem);
+	mutex_unlock(&parent->mutex);
 
 	class_put(parent);
 }
diff -puN drivers/base/core.c~struct-class-sem-to-mutex-converting drivers/base/core.c
--- a/drivers/base/core.c~struct-class-sem-to-mutex-converting
+++ a/drivers/base/core.c
@@ -20,7 +20,6 @@
 #include <linux/notifier.h>
 #include <linux/genhd.h>
 #include <linux/kallsyms.h>
-#include <linux/semaphore.h>
 
 #include "base.h"
 #include "power/power.h"
@@ -942,7 +941,7 @@ int device_add(struct device *dev)
 		klist_add_tail(&dev->knode_parent, &parent->klist_children);
 
 	if (dev->class) {
-		down(&dev->class->sem);
+		mutex_lock(&dev->class->mutex);
 		/* tie the class to the device */
 		list_add_tail(&dev->node, &dev->class->devices);
 
@@ -950,7 +949,7 @@ int device_add(struct device *dev)
 		list_for_each_entry(class_intf, &dev->class->interfaces, node)
 			if (class_intf->add_dev)
 				class_intf->add_dev(dev, class_intf);
-		up(&dev->class->sem);
+		mutex_unlock(&dev->class->mutex);
 	}
  Done:
 	put_device(dev);
@@ -1052,14 +1051,14 @@ void device_del(struct device *dev)
 	if (dev->class) {
 		device_remove_class_symlinks(dev);
 
-		down(&dev->class->sem);
+		mutex_lock(&dev->class->mutex);
 		/* notify any interfaces that the device is now gone */
 		list_for_each_entry(class_intf, &dev->class->interfaces, node)
 			if (class_intf->remove_dev)
 				class_intf->remove_dev(dev, class_intf);
 		/* remove the device from the class list */
 		list_del_init(&dev->node);
-		up(&dev->class->sem);
+		mutex_unlock(&dev->class->mutex);
 	}
 	device_remove_file(dev, &uevent_attr);
 	device_remove_attrs(dev);
diff -puN include/linux/device.h~struct-class-sem-to-mutex-converting include/linux/device.h
--- a/include/linux/device.h~struct-class-sem-to-mutex-converting
+++ a/include/linux/device.h
@@ -20,6 +20,7 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/pm.h>
+#include <linux/mutex.h>
 #include <linux/semaphore.h>
 #include <asm/atomic.h>
 #include <asm/device.h>
@@ -186,7 +187,7 @@ struct class {
 	struct list_head	devices;
 	struct list_head	interfaces;
 	struct kset		class_dirs;
-	struct semaphore	sem; /* locks children, devices, interfaces */
+	struct mutex		mutex; /* locks devices, interfaces */
 	struct class_attribute		*class_attrs;
 	struct device_attribute		*dev_attrs;
 	struct kobject			*dev_kobj;
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

struct-class-sem-to-mutex-converting.patch
struct-class-remove-children-list.patch
i2c-use-class_for_each_device.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
printk-ratelimiting-rewrite.patch
printk-ratelimiting-rewrite-fix.patch

