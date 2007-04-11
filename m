From: akpm@linux-foundation.org
Subject: - sony-laptop-remove-acpi-references-from-variable-and-function-names.patch removed from -mm tree
Date: Wed, 11 Apr 2007 16:20:35 -0700
Message-ID: <200704112320.l3BNKZCU017496@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35921 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161418AbXDKXV7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 19:21:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: malattia@linux.it, lenb@kernel.org, stelian@popies.net, mm-commits@vger.kernel.org


The patch titled
     sony-laptop: remove ACPI references from variable and function names
has been removed from the -mm tree.  Its filename was
     sony-laptop-remove-acpi-references-from-variable-and-function-names.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sony-laptop: remove ACPI references from variable and function names
From: Mattia Dongili <malattia@linux.it>

Signed-off-by: Mattia Dongili <malattia@linux.it>
Cc: Len Brown <lenb@kernel.org>
Cc: Stelian Pop <stelian@popies.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sony-laptop.c |  186 +++++++++++++++++------------------
 1 file changed, 93 insertions(+), 93 deletions(-)

diff -puN drivers/misc/sony-laptop.c~remove-acpi-references-from-variable-and-function-names drivers/misc/sony-laptop.c
--- a/drivers/misc/sony-laptop.c~remove-acpi-references-from-variable-and-function-names
+++ a/drivers/misc/sony-laptop.c
@@ -35,9 +35,9 @@
 #include <acpi/acpi_bus.h>
 #include <asm/uaccess.h>
 
-#define ACPI_SNC_CLASS		"sony"
-#define ACPI_SNC_HID		"SNY5001"
-#define ACPI_SNC_DRIVER_NAME	"ACPI Sony Notebook Control Driver v0.4"
+#define SONY_NC_CLASS		"sony"
+#define SONY_NC_HID		"SNY5001"
+#define SONY_NC_DRIVER_NAME	"ACPI Sony Notebook Control Driver v0.4"
 
 /* the device uses 1-based values, while the backlight subsystem uses
    0-based values */
@@ -46,7 +46,7 @@
 #define LOG_PFX			KERN_WARNING "sony-laptop: "
 
 MODULE_AUTHOR("Stelian Pop, Mattia Dongili");
-MODULE_DESCRIPTION(ACPI_SNC_DRIVER_NAME);
+MODULE_DESCRIPTION(SONY_NC_DRIVER_NAME);
 MODULE_LICENSE("GPL");
 
 static int debug;
@@ -54,9 +54,9 @@ module_param(debug, int, 0);
 MODULE_PARM_DESC(debug, "set this to 1 (and RTFM) if you want to help "
 		 "the development of this driver");
 
-static ssize_t sony_acpi_show(struct device *, struct device_attribute *,
+static ssize_t sony_nc_sysfs_show(struct device *, struct device_attribute *,
 			      char *);
-static ssize_t sony_acpi_store(struct device *, struct device_attribute *,
+static ssize_t sony_nc_sysfs_store(struct device *, struct device_attribute *,
 			       const char *, size_t);
 static int boolean_validate(const int, const int);
 static int brightness_default_validate(const int, const int);
@@ -64,7 +64,7 @@ static int brightness_default_validate(c
 #define SNC_VALIDATE_IN		0
 #define SNC_VALIDATE_OUT	1
 
-struct sony_acpi_value {
+struct sony_nc_value {
 	char *name;		/* name of the entry */
 	char **acpiget;		/* names of the ACPI get function */
 	char **acpiset;		/* names of the ACPI set function */
@@ -75,65 +75,65 @@ struct sony_acpi_value {
 	struct device_attribute devattr;	/* sysfs atribute */
 };
 
-#define HANDLE_NAMES(_name, _values...) \
+#define SNC_HANDLE_NAMES(_name, _values...) \
 	static char *snc_##_name[] = { _values, NULL }
 
-#define SONY_ACPI_VALUE(_name, _getters, _setters, _validate, _debug) \
+#define SNC_HANDLE(_name, _getters, _setters, _validate, _debug) \
 	{ \
 		.name		= __stringify(_name), \
 		.acpiget	= _getters, \
 		.acpiset	= _setters, \
 		.validate	= _validate, \
 		.debug		= _debug, \
-		.devattr	= __ATTR(_name, 0, sony_acpi_show, sony_acpi_store), \
+		.devattr	= __ATTR(_name, 0, sony_nc_sysfs_show, sony_nc_sysfs_store), \
 	}
 
-#define SONY_ACPI_VALUE_NULL	{ .name = NULL }
+#define SNC_HANDLE_NULL	{ .name = NULL }
 
-HANDLE_NAMES(fnkey_get, "GHKE");
+SNC_HANDLE_NAMES(fnkey_get, "GHKE");
 
-HANDLE_NAMES(brightness_def_get, "GPBR");
-HANDLE_NAMES(brightness_def_set, "SPBR");
+SNC_HANDLE_NAMES(brightness_def_get, "GPBR");
+SNC_HANDLE_NAMES(brightness_def_set, "SPBR");
 
-HANDLE_NAMES(cdpower_get, "GCDP");
-HANDLE_NAMES(cdpower_set, "SCDP", "CDPW");
+SNC_HANDLE_NAMES(cdpower_get, "GCDP");
+SNC_HANDLE_NAMES(cdpower_set, "SCDP", "CDPW");
 
-HANDLE_NAMES(audiopower_get, "GAZP");
-HANDLE_NAMES(audiopower_set, "AZPW");
+SNC_HANDLE_NAMES(audiopower_get, "GAZP");
+SNC_HANDLE_NAMES(audiopower_set, "AZPW");
 
-HANDLE_NAMES(lanpower_get, "GLNP");
-HANDLE_NAMES(lanpower_set, "LNPW");
+SNC_HANDLE_NAMES(lanpower_get, "GLNP");
+SNC_HANDLE_NAMES(lanpower_set, "LNPW");
 
-HANDLE_NAMES(PID_get, "GPID");
+SNC_HANDLE_NAMES(PID_get, "GPID");
 
-HANDLE_NAMES(CTR_get, "GCTR");
-HANDLE_NAMES(CTR_set, "SCTR");
+SNC_HANDLE_NAMES(CTR_get, "GCTR");
+SNC_HANDLE_NAMES(CTR_set, "SCTR");
 
-HANDLE_NAMES(PCR_get, "GPCR");
-HANDLE_NAMES(PCR_set, "SPCR");
+SNC_HANDLE_NAMES(PCR_get, "GPCR");
+SNC_HANDLE_NAMES(PCR_set, "SPCR");
 
-HANDLE_NAMES(CMI_get, "GCMI");
-HANDLE_NAMES(CMI_set, "SCMI");
+SNC_HANDLE_NAMES(CMI_get, "GCMI");
+SNC_HANDLE_NAMES(CMI_set, "SCMI");
 
-static struct sony_acpi_value sony_acpi_values[] = {
-	SONY_ACPI_VALUE(brightness_default, snc_brightness_def_get,
+static struct sony_nc_value sony_nc_values[] = {
+	SNC_HANDLE(brightness_default, snc_brightness_def_get,
 			snc_brightness_def_set, brightness_default_validate, 0),
-	SONY_ACPI_VALUE(fnkey, snc_fnkey_get, NULL, NULL, 0),
-	SONY_ACPI_VALUE(cdpower, snc_cdpower_get, snc_cdpower_set, boolean_validate, 0),
-	SONY_ACPI_VALUE(audiopower, snc_audiopower_get, snc_audiopower_set,
+	SNC_HANDLE(fnkey, snc_fnkey_get, NULL, NULL, 0),
+	SNC_HANDLE(cdpower, snc_cdpower_get, snc_cdpower_set, boolean_validate, 0),
+	SNC_HANDLE(audiopower, snc_audiopower_get, snc_audiopower_set,
 			boolean_validate, 0),
-	SONY_ACPI_VALUE(lanpower, snc_lanpower_get, snc_lanpower_set,
+	SNC_HANDLE(lanpower, snc_lanpower_get, snc_lanpower_set,
 			boolean_validate, 1),
 	/* unknown methods */
-	SONY_ACPI_VALUE(PID, snc_PID_get, NULL, NULL, 1),
-	SONY_ACPI_VALUE(CTR, snc_CTR_get, snc_CTR_set, NULL, 1),
-	SONY_ACPI_VALUE(PCR, snc_PCR_get, snc_PCR_set, NULL, 1),
-	SONY_ACPI_VALUE(CMI, snc_CMI_get, snc_CMI_set, NULL, 1),
-	SONY_ACPI_VALUE_NULL
+	SNC_HANDLE(PID, snc_PID_get, NULL, NULL, 1),
+	SNC_HANDLE(CTR, snc_CTR_get, snc_CTR_set, NULL, 1),
+	SNC_HANDLE(PCR, snc_PCR_get, snc_PCR_set, NULL, 1),
+	SNC_HANDLE(CMI, snc_CMI_get, snc_CMI_set, NULL, 1),
+	SNC_HANDLE_NULL
 };
 
-static acpi_handle sony_acpi_handle;
-static struct acpi_device *sony_acpi_acpi_device = NULL;
+static acpi_handle sony_nc_acpi_handle;
+static struct acpi_device *sony_nc_acpi_device = NULL;
 
 /*
  * acpi_evaluate_object wrappers
@@ -194,7 +194,7 @@ static int acpi_callsetfunc(acpi_handle 
 }
 
 /*
- * sony_acpi_values input/output validate functions
+ * sony_nc_values input/output validate functions
  */
 
 /* brightness_default_validate:
@@ -229,19 +229,19 @@ static int boolean_validate(const int di
 }
 
 /*
- * Sysfs show/store common to all sony_acpi_values
+ * Sysfs show/store common to all sony_nc_values
  */
-static ssize_t sony_acpi_show(struct device *dev, struct device_attribute *attr,
+static ssize_t sony_nc_sysfs_show(struct device *dev, struct device_attribute *attr,
 			      char *buffer)
 {
 	int value;
-	struct sony_acpi_value *item =
-	    container_of(attr, struct sony_acpi_value, devattr);
+	struct sony_nc_value *item =
+	    container_of(attr, struct sony_nc_value, devattr);
 
 	if (!*item->acpiget)
 		return -EIO;
 
-	if (acpi_callgetfunc(sony_acpi_handle, *item->acpiget, &value) < 0)
+	if (acpi_callgetfunc(sony_nc_acpi_handle, *item->acpiget, &value) < 0)
 		return -EIO;
 
 	if (item->validate)
@@ -250,13 +250,13 @@ static ssize_t sony_acpi_show(struct dev
 	return snprintf(buffer, PAGE_SIZE, "%d\n", value);
 }
 
-static ssize_t sony_acpi_store(struct device *dev,
+static ssize_t sony_nc_sysfs_store(struct device *dev,
 			       struct device_attribute *attr,
 			       const char *buffer, size_t count)
 {
 	int value;
-	struct sony_acpi_value *item =
-	    container_of(attr, struct sony_acpi_value, devattr);
+	struct sony_nc_value *item =
+	    container_of(attr, struct sony_nc_value, devattr);
 
 	if (!item->acpiset)
 		return -EIO;
@@ -272,7 +272,7 @@ static ssize_t sony_acpi_store(struct de
 	if (value < 0)
 		return value;
 
-	if (acpi_callsetfunc(sony_acpi_handle, *item->acpiset, value, NULL) < 0)
+	if (acpi_callsetfunc(sony_nc_acpi_handle, *item->acpiset, value, NULL) < 0)
 		return -EIO;
 	item->value = value;
 	item->valid = 1;
@@ -290,10 +290,10 @@ static struct platform_driver sncpf_driv
 };
 static struct platform_device *sncpf_device;
 
-static int sony_snc_pf_add(void)
+static int sony_nc_pf_add(void)
 {
 	acpi_handle handle;
-	struct sony_acpi_value *item;
+	struct sony_nc_value *item;
 	int ret = 0;
 
 	ret = platform_driver_register(&sncpf_driver);
@@ -310,14 +310,14 @@ static int sony_snc_pf_add(void)
 	if (ret)
 		goto out_platform_alloced;
 
-	for (item = sony_acpi_values; item->name; ++item) {
+	for (item = sony_nc_values; item->name; ++item) {
 
 		if (!debug && item->debug)
 			continue;
 
 		/* find the available acpiget as described in the DSDT */
 		for (; item->acpiget && *item->acpiget; ++item->acpiget) {
-			if (ACPI_SUCCESS(acpi_get_handle(sony_acpi_handle,
+			if (ACPI_SUCCESS(acpi_get_handle(sony_nc_acpi_handle,
 							 *item->acpiget,
 							 &handle))) {
 				if (debug)
@@ -330,7 +330,7 @@ static int sony_snc_pf_add(void)
 
 		/* find the available acpiset as described in the DSDT */
 		for (; item->acpiset && *item->acpiset; ++item->acpiset) {
-			if (ACPI_SUCCESS(acpi_get_handle(sony_acpi_handle,
+			if (ACPI_SUCCESS(acpi_get_handle(sony_nc_acpi_handle,
 							 *item->acpiset,
 							 &handle))) {
 				if (debug)
@@ -353,7 +353,7 @@ static int sony_snc_pf_add(void)
 	return 0;
 
       out_sysfs:
-	for (item = sony_acpi_values; item->name; ++item) {
+	for (item = sony_nc_values; item->name; ++item) {
 		device_remove_file(&sncpf_device->dev, &item->devattr);
 	}
 	platform_device_del(sncpf_device);
@@ -365,11 +365,11 @@ static int sony_snc_pf_add(void)
 	return ret;
 }
 
-static void sony_snc_pf_remove(void)
+static void sony_nc_pf_remove(void)
 {
-	struct sony_acpi_value *item;
+	struct sony_nc_value *item;
 
-	for (item = sony_acpi_values; item->name; ++item) {
+	for (item = sony_nc_values; item->name; ++item) {
 		device_remove_file(&sncpf_device->dev, &item->devattr);
 	}
 
@@ -383,7 +383,7 @@ static void sony_snc_pf_remove(void)
  */
 static int sony_backlight_update_status(struct backlight_device *bd)
 {
-	return acpi_callsetfunc(sony_acpi_handle, "SBRT",
+	return acpi_callsetfunc(sony_nc_acpi_handle, "SBRT",
 				bd->props.brightness + 1, NULL);
 }
 
@@ -391,7 +391,7 @@ static int sony_backlight_get_brightness
 {
 	int value;
 
-	if (acpi_callgetfunc(sony_acpi_handle, "GBRT", &value))
+	if (acpi_callgetfunc(sony_nc_acpi_handle, "GBRT", &value))
 		return 0;
 	/* brightness levels are 1-based, while backlight ones are 0-based */
 	return value - 1;
@@ -410,7 +410,7 @@ static void sony_acpi_notify(acpi_handle
 {
 	if (debug)
 		printk(LOG_PFX "sony_acpi_notify, event: %d\n", event);
-	acpi_bus_generate_event(sony_acpi_acpi_device, 1, event);
+	acpi_bus_generate_event(sony_nc_acpi_device, 1, event);
 }
 
 static acpi_status sony_walk_callback(acpi_handle handle, u32 level,
@@ -431,16 +431,16 @@ static acpi_status sony_walk_callback(ac
 /*
  * ACPI device
  */
-static int sony_acpi_resume(struct acpi_device *device)
+static int sony_nc_resume(struct acpi_device *device)
 {
-	struct sony_acpi_value *item;
+	struct sony_nc_value *item;
 
-	for (item = sony_acpi_values; item->name; item++) {
+	for (item = sony_nc_values; item->name; item++) {
 		int ret;
 
 		if (!item->valid)
 			continue;
-		ret = acpi_callsetfunc(sony_acpi_handle, *item->acpiset,
+		ret = acpi_callsetfunc(sony_nc_acpi_handle, *item->acpiset,
 				       item->value, NULL);
 		if (ret < 0) {
 			printk("%s: %d\n", __FUNCTION__, ret);
@@ -450,18 +450,18 @@ static int sony_acpi_resume(struct acpi_
 	return 0;
 }
 
-static int sony_acpi_add(struct acpi_device *device)
+static int sony_nc_add(struct acpi_device *device)
 {
 	acpi_status status;
 	int result = 0;
 	acpi_handle handle;
 
-	sony_acpi_acpi_device = device;
+	sony_nc_acpi_device = device;
 
-	sony_acpi_handle = device->handle;
+	sony_nc_acpi_handle = device->handle;
 
 	if (debug) {
-		status = acpi_walk_namespace(ACPI_TYPE_METHOD, sony_acpi_handle,
+		status = acpi_walk_namespace(ACPI_TYPE_METHOD, sony_nc_acpi_handle,
 					     1, sony_walk_callback, NULL, NULL);
 		if (ACPI_FAILURE(status)) {
 			printk(LOG_PFX "unable to walk acpi resources\n");
@@ -470,7 +470,7 @@ static int sony_acpi_add(struct acpi_dev
 		}
 	}
 
-	status = acpi_install_notify_handler(sony_acpi_handle,
+	status = acpi_install_notify_handler(sony_nc_acpi_handle,
 					     ACPI_DEVICE_NOTIFY,
 					     sony_acpi_notify, NULL);
 	if (ACPI_FAILURE(status)) {
@@ -479,7 +479,7 @@ static int sony_acpi_add(struct acpi_dev
 		goto outwalk;
 	}
 
-	if (ACPI_SUCCESS(acpi_get_handle(sony_acpi_handle, "GBRT", &handle))) {
+	if (ACPI_SUCCESS(acpi_get_handle(sony_nc_acpi_handle, "GBRT", &handle))) {
 		sony_backlight_device = backlight_device_register("sony", NULL,
 								  NULL,
 								  &sony_backlight_ops);
@@ -497,10 +497,10 @@ static int sony_acpi_add(struct acpi_dev
 
 	}
 
-	if (sony_snc_pf_add())
+	if (sony_nc_pf_add())
 		goto outbacklight;
 
-	printk(KERN_INFO ACPI_SNC_DRIVER_NAME " successfully installed\n");
+	printk(KERN_INFO SONY_NC_DRIVER_NAME " successfully installed\n");
 
 	return 0;
 
@@ -508,7 +508,7 @@ static int sony_acpi_add(struct acpi_dev
 	if (sony_backlight_device)
 		backlight_device_unregister(sony_backlight_device);
 
-	status = acpi_remove_notify_handler(sony_acpi_handle,
+	status = acpi_remove_notify_handler(sony_nc_acpi_handle,
 					    ACPI_DEVICE_NOTIFY,
 					    sony_acpi_notify);
 	if (ACPI_FAILURE(status))
@@ -517,48 +517,48 @@ static int sony_acpi_add(struct acpi_dev
 	return result;
 }
 
-static int sony_acpi_remove(struct acpi_device *device, int type)
+static int sony_nc_remove(struct acpi_device *device, int type)
 {
 	acpi_status status;
 
 	if (sony_backlight_device)
 		backlight_device_unregister(sony_backlight_device);
 
-	sony_acpi_acpi_device = NULL;
+	sony_nc_acpi_device = NULL;
 
-	status = acpi_remove_notify_handler(sony_acpi_handle,
+	status = acpi_remove_notify_handler(sony_nc_acpi_handle,
 					    ACPI_DEVICE_NOTIFY,
 					    sony_acpi_notify);
 	if (ACPI_FAILURE(status))
 		printk(LOG_PFX "unable to remove notify handler\n");
 
-	sony_snc_pf_remove();
+	sony_nc_pf_remove();
 
-	printk(KERN_INFO ACPI_SNC_DRIVER_NAME " successfully removed\n");
+	printk(KERN_INFO SONY_NC_DRIVER_NAME " successfully removed\n");
 
 	return 0;
 }
 
-static struct acpi_driver sony_acpi_driver = {
-	.name = ACPI_SNC_DRIVER_NAME,
-	.class = ACPI_SNC_CLASS,
-	.ids = ACPI_SNC_HID,
+static struct acpi_driver sony_nc_driver = {
+	.name = SONY_NC_DRIVER_NAME,
+	.class = SONY_NC_CLASS,
+	.ids = SONY_NC_HID,
 	.ops = {
-		.add = sony_acpi_add,
-		.remove = sony_acpi_remove,
-		.resume = sony_acpi_resume,
+		.add = sony_nc_add,
+		.remove = sony_nc_remove,
+		.resume = sony_nc_resume,
 		},
 };
 
-static int __init sony_acpi_init(void)
+static int __init sony_laptop_init(void)
 {
-	return acpi_bus_register_driver(&sony_acpi_driver);
+	return acpi_bus_register_driver(&sony_nc_driver);
 }
 
-static void __exit sony_acpi_exit(void)
+static void __exit sony_laptop_exit(void)
 {
-	acpi_bus_unregister_driver(&sony_acpi_driver);
+	acpi_bus_unregister_driver(&sony_nc_driver);
 }
 
-module_init(sony_acpi_init);
-module_exit(sony_acpi_exit);
+module_init(sony_laptop_init);
+module_exit(sony_laptop_exit);
_

Patches currently in -mm which might be from malattia@linux.it are

git-cpufreq.patch
