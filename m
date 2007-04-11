From: akpm@linux-foundation.org
Subject: - sony-laptop-prepare-the-platform-driver-for-multiple-users.patch removed from -mm tree
Date: Wed, 11 Apr 2007 16:20:39 -0700
Message-ID: <200704112320.l3BNKdh6017499@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35928 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161423AbXDKXWC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 19:22:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: malattia@linux.it, lenb@kernel.org, stelian@popies.net, mm-commits@vger.kernel.org


The patch titled
     sony-laptop: prepare the platform driver for multiple users
has been removed from the -mm tree.  Its filename was
     sony-laptop-prepare-the-platform-driver-for-multiple-users.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sony-laptop: prepare the platform driver for multiple users
From: Mattia Dongili <malattia@linux.it>

Both the SNC and SPIC device drivers will create attributes and thus there's
the need to have an internal usage count to avoid re-registering or
de-registering at the wrong time.

Signed-off-by: Mattia Dongili <malattia@linux.it>
Cc: Len Brown <lenb@kernel.org>
Cc: Stelian Pop <stelian@popies.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sony-laptop.c |  212 ++++++++++++++++++-----------------
 1 file changed, 112 insertions(+), 100 deletions(-)

diff -puN drivers/misc/sony-laptop.c~prepare-the-platform-driver-for-multiple-users drivers/misc/sony-laptop.c
--- a/drivers/misc/sony-laptop.c~prepare-the-platform-driver-for-multiple-users
+++ a/drivers/misc/sony-laptop.c
@@ -54,6 +54,64 @@ module_param(debug, int, 0);
 MODULE_PARM_DESC(debug, "set this to 1 (and RTFM) if you want to help "
 		 "the development of this driver");
 
+/*********** Platform Device ***********/
+
+static atomic_t sony_pf_users = ATOMIC_INIT(0);
+static struct platform_driver sony_pf_driver = {
+	.driver = {
+		   .name = "sony-laptop",
+		   .owner = THIS_MODULE,
+		   }
+};
+static struct platform_device *sony_pf_device;
+
+static int sony_pf_add(void)
+{
+	int ret = 0;
+
+	/* don't run again if already initialized */
+	if (atomic_add_return(1, &sony_pf_users) > 1)
+		return 0;
+
+	ret = platform_driver_register(&sony_pf_driver);
+	if (ret)
+		goto out;
+
+	sony_pf_device = platform_device_alloc("sony-laptop", -1);
+	if (!sony_pf_device) {
+		ret = -ENOMEM;
+		goto out_platform_registered;
+	}
+
+	ret = platform_device_add(sony_pf_device);
+	if (ret)
+		goto out_platform_alloced;
+
+	return 0;
+
+      out_platform_alloced:
+	platform_device_put(sony_pf_device);
+	sony_pf_device = NULL;
+      out_platform_registered:
+	platform_driver_unregister(&sony_pf_driver);
+      out:
+	atomic_dec(&sony_pf_users);
+	return ret;
+}
+
+static void sony_pf_remove(void)
+{
+	/* deregister only after the last user has gone */
+	if (!atomic_dec_and_test(&sony_pf_users))
+		return;
+
+	platform_device_del(sony_pf_device);
+	platform_device_put(sony_pf_device);
+	platform_driver_unregister(&sony_pf_driver);
+}
+
+/*********** SNC (SNY5001) Device ***********/
+
 static ssize_t sony_nc_sysfs_show(struct device *, struct device_attribute *,
 			      char *);
 static ssize_t sony_nc_sysfs_store(struct device *, struct device_attribute *,
@@ -279,104 +337,6 @@ static ssize_t sony_nc_sysfs_store(struc
 	return count;
 }
 
-/*
- * Platform device
- */
-static struct platform_driver sncpf_driver = {
-	.driver = {
-		   .name = "sony-laptop",
-		   .owner = THIS_MODULE,
-		   }
-};
-static struct platform_device *sncpf_device;
-
-static int sony_nc_pf_add(void)
-{
-	acpi_handle handle;
-	struct sony_nc_value *item;
-	int ret = 0;
-
-	ret = platform_driver_register(&sncpf_driver);
-	if (ret)
-		goto out;
-
-	sncpf_device = platform_device_alloc("sony-laptop", -1);
-	if (!sncpf_device) {
-		ret = -ENOMEM;
-		goto out_platform_registered;
-	}
-
-	ret = platform_device_add(sncpf_device);
-	if (ret)
-		goto out_platform_alloced;
-
-	for (item = sony_nc_values; item->name; ++item) {
-
-		if (!debug && item->debug)
-			continue;
-
-		/* find the available acpiget as described in the DSDT */
-		for (; item->acpiget && *item->acpiget; ++item->acpiget) {
-			if (ACPI_SUCCESS(acpi_get_handle(sony_nc_acpi_handle,
-							 *item->acpiget,
-							 &handle))) {
-				if (debug)
-					printk(LOG_PFX "Found %s getter: %s\n",
-					       item->name, *item->acpiget);
-				item->devattr.attr.mode |= S_IRUGO;
-				break;
-			}
-		}
-
-		/* find the available acpiset as described in the DSDT */
-		for (; item->acpiset && *item->acpiset; ++item->acpiset) {
-			if (ACPI_SUCCESS(acpi_get_handle(sony_nc_acpi_handle,
-							 *item->acpiset,
-							 &handle))) {
-				if (debug)
-					printk(LOG_PFX "Found %s setter: %s\n",
-					       item->name, *item->acpiset);
-				item->devattr.attr.mode |= S_IWUSR;
-				break;
-			}
-		}
-
-		if (item->devattr.attr.mode != 0) {
-			ret =
-			    device_create_file(&sncpf_device->dev,
-					       &item->devattr);
-			if (ret)
-				goto out_sysfs;
-		}
-	}
-
-	return 0;
-
-      out_sysfs:
-	for (item = sony_nc_values; item->name; ++item) {
-		device_remove_file(&sncpf_device->dev, &item->devattr);
-	}
-	platform_device_del(sncpf_device);
-      out_platform_alloced:
-	platform_device_put(sncpf_device);
-      out_platform_registered:
-	platform_driver_unregister(&sncpf_driver);
-      out:
-	return ret;
-}
-
-static void sony_nc_pf_remove(void)
-{
-	struct sony_nc_value *item;
-
-	for (item = sony_nc_values; item->name; ++item) {
-		device_remove_file(&sncpf_device->dev, &item->devattr);
-	}
-
-	platform_device_del(sncpf_device);
-	platform_device_put(sncpf_device);
-	platform_driver_unregister(&sncpf_driver);
-}
 
 /*
  * Backlight device
@@ -455,6 +415,7 @@ static int sony_nc_add(struct acpi_devic
 	acpi_status status;
 	int result = 0;
 	acpi_handle handle;
+	struct sony_nc_value *item;
 
 	sony_nc_acpi_device = device;
 
@@ -497,13 +458,59 @@ static int sony_nc_add(struct acpi_devic
 
 	}
 
-	if (sony_nc_pf_add())
+	if (sony_pf_add())
 		goto outbacklight;
 
+	/* create sony_pf sysfs attributes related to the SNC device */
+	for (item = sony_nc_values; item->name; ++item) {
+
+		if (!debug && item->debug)
+			continue;
+
+		/* find the available acpiget as described in the DSDT */
+		for (; item->acpiget && *item->acpiget; ++item->acpiget) {
+			if (ACPI_SUCCESS(acpi_get_handle(sony_nc_acpi_handle,
+							 *item->acpiget,
+							 &handle))) {
+				if (debug)
+					printk(LOG_PFX "Found %s getter: %s\n",
+					       item->name, *item->acpiget);
+				item->devattr.attr.mode |= S_IRUGO;
+				break;
+			}
+		}
+
+		/* find the available acpiset as described in the DSDT */
+		for (; item->acpiset && *item->acpiset; ++item->acpiset) {
+			if (ACPI_SUCCESS(acpi_get_handle(sony_nc_acpi_handle,
+							 *item->acpiset,
+							 &handle))) {
+				if (debug)
+					printk(LOG_PFX "Found %s setter: %s\n",
+					       item->name, *item->acpiset);
+				item->devattr.attr.mode |= S_IWUSR;
+				break;
+			}
+		}
+
+		if (item->devattr.attr.mode != 0) {
+			result =
+			    device_create_file(&sony_pf_device->dev,
+					       &item->devattr);
+			if (result)
+				goto out_sysfs;
+		}
+	}
+
 	printk(KERN_INFO SONY_NC_DRIVER_NAME " successfully installed\n");
 
 	return 0;
 
+      out_sysfs:
+	for (item = sony_nc_values; item->name; ++item) {
+		device_remove_file(&sony_pf_device->dev, &item->devattr);
+	}
+	sony_pf_remove();
       outbacklight:
 	if (sony_backlight_device)
 		backlight_device_unregister(sony_backlight_device);
@@ -520,6 +527,7 @@ static int sony_nc_add(struct acpi_devic
 static int sony_nc_remove(struct acpi_device *device, int type)
 {
 	acpi_status status;
+	struct sony_nc_value *item;
 
 	if (sony_backlight_device)
 		backlight_device_unregister(sony_backlight_device);
@@ -532,7 +540,11 @@ static int sony_nc_remove(struct acpi_de
 	if (ACPI_FAILURE(status))
 		printk(LOG_PFX "unable to remove notify handler\n");
 
-	sony_nc_pf_remove();
+	for (item = sony_nc_values; item->name; ++item) {
+		device_remove_file(&sony_pf_device->dev, &item->devattr);
+	}
+
+	sony_pf_remove();
 
 	printk(KERN_INFO SONY_NC_DRIVER_NAME " successfully removed\n");
 
_

Patches currently in -mm which might be from malattia@linux.it are

git-cpufreq.patch
