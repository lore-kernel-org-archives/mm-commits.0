From: akpm@linux-foundation.org
Subject: - acpi-add-backlight-support-to-the-sony_acpi.patch removed from -mm tree
Date: Thu, 08 Feb 2007 01:13:09 -0800
Message-ID: <200702080913.l189D9Y7010298@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34600 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423156AbXBHJNW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Feb 2007 04:13:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alessandro.guido@gmail.com, rpurdie@rpsys.net, stelian@popies.net, mm-commits@vger.kernel.org


The patch titled
     acpi: add backlight support to the sony_acpi driver
has been removed from the -mm tree.  Its filename was
     acpi-add-backlight-support-to-the-sony_acpi.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: acpi: add backlight support to the sony_acpi driver
From: Alessandro Guido <alessandro.guido@gmail.com>

Make the sony_acpi use the backlight subsystem to adjust brightness value
instead of using the /proc/sony/brightness file.  (Other settings will
still have a /proc/sony/...  entry)

Signed-off-by: Alessandro Guido <alessandro.guido@gmail.com>
Cc: Stelian Pop <stelian@popies.net>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/Kconfig     |    1 
 drivers/acpi/sony_acpi.c |   53 +++++++++++++++++++++++++++++++++----
 2 files changed, 49 insertions(+), 5 deletions(-)

diff -puN drivers/acpi/Kconfig~acpi-add-backlight-support-to-the-sony_acpi drivers/acpi/Kconfig
--- a/drivers/acpi/Kconfig~acpi-add-backlight-support-to-the-sony_acpi
+++ a/drivers/acpi/Kconfig
@@ -281,6 +281,7 @@ config ACPI_TOSHIBA
 config ACPI_SONY
 	tristate "Sony Laptop Extras"
 	depends on X86 && ACPI
+	select BACKLIGHT_CLASS_DEVICE
 	default m
 	  ---help---
 	  This mini-driver drives the ACPI SNC device present in the
diff -puN drivers/acpi/sony_acpi.c~acpi-add-backlight-support-to-the-sony_acpi drivers/acpi/sony_acpi.c
--- a/drivers/acpi/sony_acpi.c~acpi-add-backlight-support-to-the-sony_acpi
+++ a/drivers/acpi/sony_acpi.c
@@ -27,13 +27,19 @@
 #include <linux/moduleparam.h>
 #include <linux/init.h>
 #include <linux/types.h>
+#include <linux/backlight.h>
+#include <linux/err.h>
 #include <acpi/acpi_drivers.h>
 #include <acpi/acpi_bus.h>
 #include <asm/uaccess.h>
 
 #define ACPI_SNC_CLASS		"sony"
 #define ACPI_SNC_HID		"SNY5001"
-#define ACPI_SNC_DRIVER_NAME	"ACPI Sony Notebook Control Driver v0.2"
+#define ACPI_SNC_DRIVER_NAME	"ACPI Sony Notebook Control Driver v0.3"
+
+/* the device uses 1-based values, while the backlight subsystem uses
+   0-based values */
+#define SONY_MAX_BRIGHTNESS	8
 
 #define LOG_PFX			KERN_WARNING "sony_acpi: "
 
@@ -49,6 +55,16 @@ MODULE_PARM_DESC(debug, "set this to 1 (
 static acpi_handle sony_acpi_handle;
 static struct proc_dir_entry *sony_acpi_dir;
 
+static int sony_backlight_update_status(struct backlight_device *bd);
+static int sony_backlight_get_brightness(struct backlight_device *bd);
+static struct backlight_device *sony_backlight_device;
+static struct backlight_properties sony_backlight_properties = {
+	.owner		= THIS_MODULE,
+	.update_status	= sony_backlight_update_status,
+	.get_brightness	= sony_backlight_get_brightness,
+	.max_brightness	= SONY_MAX_BRIGHTNESS - 1,
+};
+
 static struct sony_acpi_value {
 	char			*name;	 /* name of the entry */
 	struct proc_dir_entry 	*proc;	 /* /proc entry */
@@ -65,7 +81,7 @@ static struct sony_acpi_value {
 		.acpiget	= "GBRT",
 		.acpiset	= "SBRT",
 		.min		= 1,
-		.max		= 8,
+		.max		= SONY_MAX_BRIGHTNESS,
 		.debug		= 0,
 	},
 	{
@@ -73,7 +89,7 @@ static struct sony_acpi_value {
 		.acpiget	= "GPBR",
 		.acpiset	= "SPBR",
 		.min		= 1,
-		.max		= 8,
+		.max		= SONY_MAX_BRIGHTNESS,
 		.debug		= 0,
 	},
 	{
@@ -276,6 +292,7 @@ static int sony_acpi_add(struct acpi_dev
 {
 	acpi_status status;
 	int result;
+	acpi_handle handle;
 	struct sony_acpi_value *item;
 
 	sony_acpi_handle = device->handle;
@@ -303,9 +320,15 @@ static int sony_acpi_add(struct acpi_dev
 		}
 	}
 
-	for (item = sony_acpi_values; item->name; ++item) {
-		acpi_handle handle;
+	if (ACPI_SUCCESS(acpi_get_handle(sony_acpi_handle, "GBRT", &handle))) {
+		sony_backlight_device = backlight_device_register("sony", NULL,
+					NULL, &sony_backlight_properties);
+	        if (IS_ERR(sony_backlight_device)) {
+        	        printk(LOG_PFX "unable to register backlight device\n");
+		}
+	}
 
+	for (item = sony_acpi_values; item->name; ++item) {
 		if (!debug && item->debug)
 			continue;
 
@@ -358,6 +381,9 @@ static int sony_acpi_remove(struct acpi_
 	acpi_status status;
 	struct sony_acpi_value *item;
 
+	if (sony_backlight_device)
+		backlight_device_unregister(sony_backlight_device);
+
 	if (debug) {
 		status = acpi_remove_notify_handler(sony_acpi_handle,
 						    ACPI_DEVICE_NOTIFY,
@@ -375,6 +401,23 @@ static int sony_acpi_remove(struct acpi_
 	return 0;
 }
 
+static int sony_backlight_update_status(struct backlight_device *bd)
+{
+	return acpi_callsetfunc(sony_acpi_handle, "SBRT",
+				bd->props->brightness + 1,
+				NULL);
+}
+
+static int sony_backlight_get_brightness(struct backlight_device *bd)
+{
+	int value;
+
+	if (acpi_callgetfunc(sony_acpi_handle, "GBRT", &value))
+		return 0;
+	/* brightness levels are 1-based, while backlight ones are 0-based */
+	return value - 1;
+}
+
 static struct acpi_driver sony_acpi_driver = {
 	.name	= ACPI_SNC_DRIVER_NAME,
 	.class	= ACPI_SNC_CLASS,
_

Patches currently in -mm which might be from alessandro.guido@gmail.com are

git-acpi.patch
acpi-add-backlight-support-to-the-sony_acpi.patch
