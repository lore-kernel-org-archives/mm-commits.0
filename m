From: akpm@linux-foundation.org
Subject: + kernel-modulec-make_driver_name-can-use-kasrpintf.patch added to -mm tree
Date: Tue, 27 Nov 2007 13:11:11 -0800
Message-ID: <200711272111.lARLBBXC030585@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58436 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757597AbXK0VLW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 16:11:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.kozlowski@tuxland.pl, rusty@rustcorp.com.au


The patch titled
     kernel/module.c: make_driver_name() can use kasrpintf()
has been added to the -mm tree.  Its filename is
     kernel-modulec-make_driver_name-can-use-kasrpintf.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kernel/module.c: make_driver_name() can use kasrpintf()
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

make_driver_name() wants kasprintf().

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff -puN kernel/module.c~kernel-modulec-make_driver_name-can-use-kasrpintf kernel/module.c
--- a/kernel/module.c~kernel-modulec-make_driver_name-can-use-kasrpintf
+++ a/kernel/module.c
@@ -2508,15 +2508,7 @@ void print_modules(void)
 #ifdef CONFIG_SYSFS
 static char *make_driver_name(struct device_driver *drv)
 {
-	char *driver_name;
-
-	driver_name = kmalloc(strlen(drv->name) + strlen(drv->bus->name) + 2,
-			      GFP_KERNEL);
-	if (!driver_name)
-		return NULL;
-
-	sprintf(driver_name, "%s:%s", drv->bus->name, drv->name);
-	return driver_name;
+	return kasprintf(GFP_KERNEL, "%s:%s", drv->bus->name, drv->name);
 }
 
 static void module_create_drivers_dir(struct module_kobject *mk)
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

git-mmc.patch
config_highpte-vs-sub-page-page-tables-fix-2.patch
kernel-modulec-make_driver_name-can-use-kasrpintf.patch
reiser4.patch
