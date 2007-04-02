From: akpm@linux-foundation.org
Subject: - driver-core-fix-built-in-drivers-sysfs-links.patch removed from -mm tree
Date: Mon, 02 Apr 2007 16:03:59 -0700
Message-ID: <200704022303.l32N3xEC011949@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51988 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966071AbXDBXEF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 2 Apr 2007 19:04:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kay.sievers@vrfy.org, greg@kroah.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     driver core: fix built-in drivers sysfs links
has been removed from the -mm tree.  Its filename was
     driver-core-fix-built-in-drivers-sysfs-links.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: driver core: fix built-in drivers sysfs links
From: Kay Sievers <kay.sievers@vrfy.org>

built-in drivers had broken sysfs links that caused bootup hangs for
certain driver unregistry sequences.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/device.h |    1 +
 kernel/module.c        |   18 ++++++++++++++----
 2 files changed, 15 insertions(+), 4 deletions(-)

diff -puN include/linux/device.h~driver-core-fix-built-in-drivers-sysfs-links include/linux/device.h
--- a/include/linux/device.h~driver-core-fix-built-in-drivers-sysfs-links
+++ a/include/linux/device.h
@@ -128,6 +128,7 @@ struct device_driver {
 
 	struct module		* owner;
 	const char 		* mod_name;	/* used for built-in modules */
+	struct module_kobject	* mkobj;
 
 	int	(*probe)	(struct device * dev);
 	int	(*remove)	(struct device * dev);
diff -puN kernel/module.c~driver-core-fix-built-in-drivers-sysfs-links kernel/module.c
--- a/kernel/module.c~driver-core-fix-built-in-drivers-sysfs-links
+++ a/kernel/module.c
@@ -2384,8 +2384,13 @@ void module_add_driver(struct module *mo
 
 		/* Lookup built-in module entry in /sys/modules */
 		mkobj = kset_find_obj(&module_subsys.kset, drv->mod_name);
-		if (mkobj)
+		if (mkobj) {
 			mk = container_of(mkobj, struct module_kobject, kobj);
+			/* remember our module structure */
+			drv->mkobj = mk;
+			/* kset_find_obj took a reference */
+			kobject_put(mkobj);
+		}
 	}
 
 	if (!mk)
@@ -2405,17 +2410,22 @@ EXPORT_SYMBOL(module_add_driver);
 
 void module_remove_driver(struct device_driver *drv)
 {
+	struct module_kobject *mk = NULL;
 	char *driver_name;
 
 	if (!drv)
 		return;
 
 	sysfs_remove_link(&drv->kobj, "module");
-	if (drv->owner && drv->owner->mkobj.drivers_dir) {
+
+	if (drv->owner)
+		mk = &drv->owner->mkobj;
+	else if (drv->mkobj)
+		mk = drv->mkobj;
+	if (mk && mk->drivers_dir) {
 		driver_name = make_driver_name(drv);
 		if (driver_name) {
-			sysfs_remove_link(drv->owner->mkobj.drivers_dir,
-					  driver_name);
+			sysfs_remove_link(mk->drivers_dir, driver_name);
 			kfree(driver_name);
 		}
 	}
_

Patches currently in -mm which might be from kay.sievers@vrfy.org are

origin.patch
driver-core-suppress-uevents-via-filter.patch
driver-core-switch-firmware_class-to.patch
s390-cio-delay-uevents-for-subchannels.patch
uevent-use-add_uevent_var-instead-of-open-coding-it.patch
