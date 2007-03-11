From: akpm@linux-foundation.org
Subject: + kref-refcounting-breakage-in-mainline.patch added to -mm tree
Date: Sat, 10 Mar 2007 23:41:34 -0800
Message-ID: <200703110741.l2B7fYod007168@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38926 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255AbXCKHlj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Mar 2007 03:41:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: efault@gmx.de, greg@kroah.com


The patch titled
     kref refcounting breakage in mainline
has been added to the -mm tree.  Its filename is
     kref-refcounting-breakage-in-mainline.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kref refcounting breakage in mainline
From: Mike Galbraith <efault@gmx.de>

My reference count woes stem from module_remove_driver() not removing the
link created in module_add_driver().  With the below, my box boots fine. 
Since I obviously know spit about driver layer glue, I'll just call this
one a diagnostic, and head for the hills :)

Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |   32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff -puN kernel/module.c~kref-refcounting-breakage-in-mainline kernel/module.c
--- a/kernel/module.c~kref-refcounting-breakage-in-mainline
+++ a/kernel/module.c
@@ -2411,20 +2411,28 @@ void module_remove_driver(struct device_
 		return;
 
 	sysfs_remove_link(&drv->kobj, "module");
-	if (drv->owner && drv->owner->mkobj.drivers_dir) {
-		driver_name = make_driver_name(drv);
-		if (driver_name) {
-			sysfs_remove_link(drv->owner->mkobj.drivers_dir,
+	driver_name = make_driver_name(drv);
+	if (!driver_name)
+		return;
+	if (drv->owner && drv->owner->mkobj.drivers_dir)
+		sysfs_remove_link(drv->owner->mkobj.drivers_dir,
 					  driver_name);
-			kfree(driver_name);
-		}
+	else if (drv->mod_name) {
+		struct module_kobject *mk;
+		struct kobject *mkobj;
+
+		/* Lookup built-in module entry in /sys/modules */
+		mkobj = kset_find_obj(&module_subsys.kset, drv->mod_name);
+		if (!mkobj)
+			goto out_free;
+		mk = container_of(mkobj, struct module_kobject, kobj);
+		module_create_drivers_dir(mk);
+		sysfs_remove_link(mk->drivers_dir, driver_name);
+		/* Release reference taken via lookup */
+		kobject_put(mkobj);
 	}
-	/*
-	 * Undo the additional reference we added in module_add_driver()
-	 * via kset_find_obj()
-	 */
-	if (drv->mod_name)
-		kobject_put(&drv->kobj);
+out_free:
+	kfree(driver_name);
 }
 EXPORT_SYMBOL(module_remove_driver);
 #endif
_

Patches currently in -mm which might be from efault@gmx.de are

kref-refcounting-breakage-in-mainline.patch
readahead-call-scheme.patch
