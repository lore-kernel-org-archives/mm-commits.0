From: akpm@linux-foundation.org
Subject: + device_schedule_callback-needs-a-module-reference.patch added to -mm tree
Date: Mon, 09 Apr 2007 13:06:07 -0700
Message-ID: <200704092006.l39K67Ng022203@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58072 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965388AbXDIUGg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 9 Apr 2007 16:06:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stern@rowland.harvard.edu, greg@kroah.com, neilb@suse.de, satyam.sharma@gmail.com


The patch titled
     device_schedule_callback() needs a module reference
has been added to the -mm tree.  Its filename is
     device_schedule_callback-needs-a-module-reference.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: device_schedule_callback() needs a module reference
From: Alan Stern <stern@rowland.harvard.edu>

This patch (as896b) fixes an oversight in the design of
device_schedule_callback().  It is necessary to acquire a reference to the
module owning the callback routine, to prevent the module from being
unloaded before the callback can run.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/core.c    |   16 ++++++++++------
 fs/sysfs/file.c        |   14 +++++++++++---
 include/linux/device.h |   10 ++++++++--
 include/linux/sysfs.h  |    4 ++--
 4 files changed, 31 insertions(+), 13 deletions(-)

diff -puN drivers/base/core.c~device_schedule_callback-needs-a-module-reference drivers/base/core.c
--- a/drivers/base/core.c~device_schedule_callback-needs-a-module-reference
+++ a/drivers/base/core.c
@@ -430,9 +430,10 @@ void device_remove_bin_file(struct devic
 EXPORT_SYMBOL_GPL(device_remove_bin_file);
 
 /**
- * device_schedule_callback - helper to schedule a callback for a device
+ * device_schedule_callback_owner - helper to schedule a callback for a device
  * @dev: device.
  * @func: callback function to invoke later.
+ * @owner: module owning the callback routine
  *
  * Attribute methods must not unregister themselves or their parent device
  * (which would amount to the same thing).  Attempts to do so will deadlock,
@@ -443,20 +444,23 @@ EXPORT_SYMBOL_GPL(device_remove_bin_file
  * argument in the workqueue's process context.  @dev will be pinned until
  * @func returns.
  *
+ * This routine is usually called via the inline device_schedule_callback(),
+ * which automatically sets @owner to THIS_MODULE.
+ *
  * Returns 0 if the request was submitted, -ENOMEM if storage could not
- * be allocated.
+ * be allocated, -ENODEV if a reference to @owner isn't available.
  *
  * NOTE: This routine won't work if CONFIG_SYSFS isn't set!  It uses an
  * underlying sysfs routine (since it is intended for use by attribute
  * methods), and if sysfs isn't available you'll get nothing but -ENOSYS.
  */
-int device_schedule_callback(struct device *dev,
-		void (*func)(struct device *))
+int device_schedule_callback_owner(struct device *dev,
+		void (*func)(struct device *), struct module *owner)
 {
 	return sysfs_schedule_callback(&dev->kobj,
-			(void (*)(void *)) func, dev);
+			(void (*)(void *)) func, dev, owner);
 }
-EXPORT_SYMBOL_GPL(device_schedule_callback);
+EXPORT_SYMBOL_GPL(device_schedule_callback_owner);
 
 static void klist_children_get(struct klist_node *n)
 {
diff -puN fs/sysfs/file.c~device_schedule_callback-needs-a-module-reference fs/sysfs/file.c
--- a/fs/sysfs/file.c~device_schedule_callback-needs-a-module-reference
+++ a/fs/sysfs/file.c
@@ -647,6 +647,7 @@ struct sysfs_schedule_callback_struct {
 	struct kobject 		*kobj;
 	void			(*func)(void *);
 	void			*data;
+	struct module		*owner;
 	struct work_struct	work;
 };
 
@@ -657,6 +658,7 @@ static void sysfs_schedule_callback_work
 
 	(ss->func)(ss->data);
 	kobject_put(ss->kobj);
+	module_put(ss->owner);
 	kfree(ss);
 }
 
@@ -665,6 +667,7 @@ static void sysfs_schedule_callback_work
  * @kobj: object we're acting for.
  * @func: callback function to invoke later.
  * @data: argument to pass to @func.
+ * @owner: module owning the callback code
  *
  * sysfs attribute methods must not unregister themselves or their parent
  * kobject (which would amount to the same thing).  Attempts to do so will
@@ -677,20 +680,25 @@ static void sysfs_schedule_callback_work
  * until @func returns.
  *
  * Returns 0 if the request was submitted, -ENOMEM if storage could not
- * be allocated.
+ * be allocated, -ENODEV if a reference to @owner isn't available.
  */
 int sysfs_schedule_callback(struct kobject *kobj, void (*func)(void *),
-		void *data)
+		void *data, struct module *owner)
 {
 	struct sysfs_schedule_callback_struct *ss;
 
+	if (!try_module_get(owner))
+		return -ENODEV;
 	ss = kmalloc(sizeof(*ss), GFP_KERNEL);
-	if (!ss)
+	if (!ss) {
+		module_put(owner);
 		return -ENOMEM;
+	}
 	kobject_get(kobj);
 	ss->kobj = kobj;
 	ss->func = func;
 	ss->data = data;
+	ss->owner = owner;
 	INIT_WORK(&ss->work, sysfs_schedule_callback_work);
 	schedule_work(&ss->work);
 	return 0;
diff -puN include/linux/device.h~device_schedule_callback-needs-a-module-reference include/linux/device.h
--- a/include/linux/device.h~device_schedule_callback-needs-a-module-reference
+++ a/include/linux/device.h
@@ -366,8 +366,14 @@ extern int __must_check device_create_bi
 					       struct bin_attribute *attr);
 extern void device_remove_bin_file(struct device *dev,
 				   struct bin_attribute *attr);
-extern int device_schedule_callback(struct device *dev,
-		void (*func)(struct device *));
+extern int device_schedule_callback_owner(struct device *dev,
+		void (*func)(struct device *), struct module *owner);
+
+static inline int device_schedule_callback(struct device *dev,
+		void (*func)(struct device *))
+{
+	return device_schedule_callback_owner(dev, func, THIS_MODULE);
+}
 
 /* device resource management */
 typedef void (*dr_release_t)(struct device *dev, void *res);
diff -puN include/linux/sysfs.h~device_schedule_callback-needs-a-module-reference include/linux/sysfs.h
--- a/include/linux/sysfs.h~device_schedule_callback-needs-a-module-reference
+++ a/include/linux/sysfs.h
@@ -80,7 +80,7 @@ struct sysfs_ops {
 #ifdef CONFIG_SYSFS
 
 extern int sysfs_schedule_callback(struct kobject *kobj,
-		void (*func)(void *), void *data);
+		void (*func)(void *), void *data, struct module *owner);
 
 extern int __must_check
 sysfs_create_dir(struct kobject *, struct dentry *);
@@ -138,7 +138,7 @@ extern int __must_check sysfs_init(void)
 #else /* CONFIG_SYSFS */
 
 static inline int sysfs_schedule_callback(struct kobject *kobj,
-		void (*func)(void *), void *data)
+		void (*func)(void *), void *data, struct module *owner)
 {
 	return -ENOSYS;
 }
_

Patches currently in -mm which might be from stern@rowland.harvard.edu are

device_schedule_callback-needs-a-module-reference.patch
git-hid.patch
