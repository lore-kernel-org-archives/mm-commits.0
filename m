From: akpm@linux-foundation.org
Subject: - acpi-compal-laptop-use-rfkill-switch-subsystem.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:33:56 -0800
Message-ID: <200811102033.mAAKXuBQ024747@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48051 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753418AbYKJUeg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 15:34:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cezary.jackiewicz@gmail.com, andi@firstfloor.org, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     acpi: compal-laptop: use rfkill switch subsystem
has been removed from the -mm tree.  Its filename was
     acpi-compal-laptop-use-rfkill-switch-subsystem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: compal-laptop: use rfkill switch subsystem
From: Cezary Jackiewicz <cezary.jackiewicz@gmail.com>

Removing unnecessary attributes, use rfkill switch subsystem.

It depends on the rfkill changes in net-next-2.6.

[randy.dunlap@oracle.com: compal-laptop: depends on RKFILL]
Signed-off-by: Cezary Jackiewicz <cezary.jackiewicz@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/Kconfig         |    2 
 drivers/misc/compal-laptop.c |  278 ++++++++++++++-------------------
 2 files changed, 128 insertions(+), 152 deletions(-)

diff -puN drivers/misc/Kconfig~acpi-compal-laptop-use-rfkill-switch-subsystem drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~acpi-compal-laptop-use-rfkill-switch-subsystem
+++ a/drivers/misc/Kconfig
@@ -232,6 +232,7 @@ config MSI_LAPTOP
         depends on X86
         depends on ACPI_EC
         depends on BACKLIGHT_CLASS_DEVICE
+	depends on RFKILL
         ---help---
 	  This is a driver for laptops built by MSI (MICRO-STAR
 	  INTERNATIONAL):
@@ -262,6 +263,7 @@ config COMPAL_LAPTOP
 	depends on X86
 	depends on ACPI_EC
 	depends on BACKLIGHT_CLASS_DEVICE
+	depends on RFKILL
 	---help---
 	  This is a driver for laptops built by Compal:
 
diff -puN drivers/misc/compal-laptop.c~acpi-compal-laptop-use-rfkill-switch-subsystem drivers/misc/compal-laptop.c
--- a/drivers/misc/compal-laptop.c~acpi-compal-laptop-use-rfkill-switch-subsystem
+++ a/drivers/misc/compal-laptop.c
@@ -24,19 +24,10 @@
  */
 
 /*
- * comapl-laptop.c - Compal laptop support.
+ * compal-laptop.c - Compal laptop support.
  *
- * This driver exports a few files in /sys/devices/platform/compal-laptop/:
- *
- *   wlan - wlan subsystem state: contains 0 or 1 (rw)
- *
- *   bluetooth - Bluetooth subsystem state: contains 0 or 1 (rw)
- *
- *   raw - raw value taken from embedded controller register (ro)
- *
- * In addition to these platform device attributes the driver
- * registers itself in the Linux backlight control subsystem and is
- * available to userspace under /sys/class/backlight/compal-laptop/.
+ * This driver registers itself in the Linux backlight control subsystem
+ * and rfkill switch subsystem.
  *
  * This driver might work on other laptops produced by Compal. If you
  * want to try it you can pass force=1 as argument to the module which
@@ -52,8 +43,12 @@
 #include <linux/backlight.h>
 #include <linux/platform_device.h>
 #include <linux/autoconf.h>
+#include <linux/rfkill.h>
 
-#define COMPAL_DRIVER_VERSION "0.2.6"
+#define COMPAL_DRIVER_VERSION "0.3.0"
+#define COMPAL_DRIVER_NAME "compal-laptop"
+#define COMPAL_ERR KERN_ERR COMPAL_DRIVER_NAME ": "
+#define COMPAL_INFO KERN_INFO COMPAL_DRIVER_NAME ": "
 
 #define COMPAL_LCD_LEVEL_MAX 8
 
@@ -64,6 +59,10 @@
 #define WLAN_MASK	0x01
 #define BT_MASK 	0x02
 
+/* rfkill switches */
+static struct rfkill *bluetooth_rfkill;
+static struct rfkill *wlan_rfkill;
+
 static int force;
 module_param(force, bool, 0);
 MODULE_PARM_DESC(force, "Force driver load, ignore DMI data");
@@ -89,67 +88,6 @@ static int get_lcd_level(void)
 	return (int) result;
 }
 
-static int set_wlan_state(int state)
-{
-	u8 result, value;
-
-	ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
-
-	if ((result & KILLSWITCH_MASK) == 0)
-		return -EINVAL;
-	else {
-		if (state)
-			value = (u8) (result | WLAN_MASK);
-		else
-			value = (u8) (result & ~WLAN_MASK);
-		ec_write(COMPAL_EC_COMMAND_WIRELESS, value);
-	}
-
-	return 0;
-}
-
-static int set_bluetooth_state(int state)
-{
-	u8 result, value;
-
-	ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
-
-	if ((result & KILLSWITCH_MASK) == 0)
-		return -EINVAL;
-	else {
-		if (state)
-			value = (u8) (result | BT_MASK);
-		else
-			value = (u8) (result & ~BT_MASK);
-		ec_write(COMPAL_EC_COMMAND_WIRELESS, value);
-	}
-
-	return 0;
-}
-
-static int get_wireless_state(int *wlan, int *bluetooth)
-{
-	u8 result;
-
-	ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
-
-	if (wlan) {
-		if ((result & KILLSWITCH_MASK) == 0)
-			*wlan = 0;
-		else
-			*wlan = result & WLAN_MASK;
-	}
-
-	if (bluetooth) {
-		if ((result & KILLSWITCH_MASK) == 0)
-			*bluetooth = 0;
-		else
-			*bluetooth = (result & BT_MASK) >> 1;
-	}
-
-	return 0;
-}
-
 /* Backlight device stuff */
 
 static int bl_get_brightness(struct backlight_device *b)
@@ -172,99 +110,121 @@ static struct backlight_device *compalbl
 
 /* Platform device */
 
-static ssize_t show_wlan(struct device *dev,
-	struct device_attribute *attr, char *buf)
-{
-	int ret, enabled;
+static struct platform_driver compal_driver = {
+	.driver = {
+		.name = COMPAL_DRIVER_NAME,
+		.owner = THIS_MODULE,
+	}
+};
 
-	ret = get_wireless_state(&enabled, NULL);
-	if (ret < 0)
-		return ret;
+static struct platform_device *compal_device;
 
-	return sprintf(buf, "%i\n", enabled);
-}
+/* rfkill stuff */
 
-static ssize_t show_raw(struct device *dev,
-	struct device_attribute *attr, char *buf)
+static int wlan_rfk_set(void *data, enum rfkill_state state)
 {
-	u8 result;
+	u8 result, value;
 
 	ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
 
-	return sprintf(buf, "%i\n", result);
+	if ((result & KILLSWITCH_MASK) == 0)
+		return 0;
+	else {
+		if (state == RFKILL_STATE_ON)
+			value = (u8) (result | WLAN_MASK);
+		else
+			value = (u8) (result & ~WLAN_MASK);
+		ec_write(COMPAL_EC_COMMAND_WIRELESS, value);
+	}
+
+	return 0;
 }
 
-static ssize_t show_bluetooth(struct device *dev,
-	struct device_attribute *attr, char *buf)
+static int wlan_rfk_get(void *data, enum rfkill_state *state)
 {
-	int ret, enabled;
+	u8 result;
 
-	ret = get_wireless_state(NULL, &enabled);
-	if (ret < 0)
-		return ret;
+	ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
 
-	return sprintf(buf, "%i\n", enabled);
+	if ((result & KILLSWITCH_MASK) == 0)
+		*state = RFKILL_STATE_OFF;
+	else
+		*state = result & WLAN_MASK;
+
+	return 0;
 }
 
-static ssize_t store_wlan_state(struct device *dev,
-	struct device_attribute *attr, const char *buf, size_t count)
+static int bluetooth_rfk_set(void *data, enum rfkill_state state)
 {
-	int state, ret;
+	u8 result, value;
 
-	if (sscanf(buf, "%i", &state) != 1 || (state < 0 || state > 1))
-		return -EINVAL;
+	ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
 
-	ret = set_wlan_state(state);
-	if (ret < 0)
-		return ret;
+	if ((result & KILLSWITCH_MASK) == 0)
+		return 0;
+	else {
+		if (state == RFKILL_STATE_ON)
+			value = (u8) (result | BT_MASK);
+		else
+			value = (u8) (result & ~BT_MASK);
+		ec_write(COMPAL_EC_COMMAND_WIRELESS, value);
+	}
 
-	return count;
+	return 0;
 }
 
-static ssize_t store_bluetooth_state(struct device *dev,
-	struct device_attribute *attr, const char *buf, size_t count)
+static int bluetooth_rfk_get(void *data, enum rfkill_state *state)
 {
-	int state, ret;
+	u8 result;
 
-	if (sscanf(buf, "%i", &state) != 1 || (state < 0 || state > 1))
-		return -EINVAL;
+	ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
 
-	ret = set_bluetooth_state(state);
-	if (ret < 0)
-		return ret;
-
-	return count;
-}
-
-static DEVICE_ATTR(bluetooth, 0644, show_bluetooth, store_bluetooth_state);
-static DEVICE_ATTR(wlan, 0644, show_wlan, store_wlan_state);
-static DEVICE_ATTR(raw, 0444, show_raw, NULL);
-
-static struct attribute *compal_attributes[] = {
-	&dev_attr_bluetooth.attr,
-	&dev_attr_wlan.attr,
-	&dev_attr_raw.attr,
-	NULL
-};
+	if ((result & KILLSWITCH_MASK) == 0)
+		*state = RFKILL_STATE_OFF;
+	else
+		*state = (result & BT_MASK) >> 1;
 
-static struct attribute_group compal_attribute_group = {
-	.attrs = compal_attributes
-};
+	return 0;
+}
 
-static struct platform_driver compal_driver = {
-	.driver = {
-		.name = "compal-laptop",
-		.owner = THIS_MODULE,
+static int __init compal_rfkill(struct rfkill **rfk,
+				const enum rfkill_type rfktype,
+				const char *name,
+				int (*toggle_radio)(void *, enum rfkill_state),
+				int (*get_state)(void *, enum rfkill_state *))
+{
+	int res;
+
+	(*rfk) = rfkill_allocate(&compal_device->dev, rfktype);
+	if (!*rfk) {
+		printk(COMPAL_ERR
+				"failed to allocate memory for rfkill class\n");
+		return -ENOMEM;
 	}
-};
 
-static struct platform_device *compal_device;
+	(*rfk)->name = name;
+	(*rfk)->get_state = get_state;
+	(*rfk)->toggle_radio = toggle_radio;
+	(*rfk)->user_claim_unsupported = 1;
+
+	res = rfkill_register(*rfk);
+	if (res < 0) {
+		printk(COMPAL_ERR
+				"failed to register %s rfkill switch: %d\n",
+				name, res);
+		rfkill_free(*rfk);
+		*rfk = NULL;
+		return res;
+	}
+
+	return 0;
+}
 
 /* Initialization */
 
 static int dmi_check_cb(const struct dmi_system_id *id)
 {
-	printk(KERN_INFO "compal-laptop: Identified laptop model '%s'.\n",
+	printk(COMPAL_INFO "Identified laptop model '%s'.\n",
 		id->ident);
 
 	return 0;
@@ -326,12 +286,13 @@ static int __init compal_init(void)
 
 	/* Register backlight stuff */
 
-	compalbl_device = backlight_device_register("compal-laptop", NULL, NULL,
-						&compalbl_ops);
+	compalbl_device = backlight_device_register(COMPAL_DRIVER_NAME, NULL,
+						NULL, &compalbl_ops);
 	if (IS_ERR(compalbl_device))
 		return PTR_ERR(compalbl_device);
 
 	compalbl_device->props.max_brightness = COMPAL_LCD_LEVEL_MAX-1;
+	compalbl_device->props.brightness = get_lcd_level();
 
 	ret = platform_driver_register(&compal_driver);
 	if (ret)
@@ -339,7 +300,7 @@ static int __init compal_init(void)
 
 	/* Register platform stuff */
 
-	compal_device = platform_device_alloc("compal-laptop", -1);
+	compal_device = platform_device_alloc(COMPAL_DRIVER_NAME, -1);
 	if (!compal_device) {
 		ret = -ENOMEM;
 		goto fail_platform_driver;
@@ -347,23 +308,28 @@ static int __init compal_init(void)
 
 	ret = platform_device_add(compal_device);
 	if (ret)
-		goto fail_platform_device1;
+		goto fail_platform_device;
 
-	ret = sysfs_create_group(&compal_device->dev.kobj,
-		&compal_attribute_group);
-	if (ret)
-		goto fail_platform_device2;
-
-	printk(KERN_INFO "compal-laptop: driver "COMPAL_DRIVER_VERSION
-		" successfully loaded.\n");
+	/* Register rfkill stuff */
 
-	return 0;
+	compal_rfkill(&wlan_rfkill,
+					RFKILL_TYPE_WLAN,
+					"compal_laptop_wlan_sw",
+					wlan_rfk_set,
+					wlan_rfk_get);
+
+	compal_rfkill(&bluetooth_rfkill,
+					RFKILL_TYPE_BLUETOOTH,
+					"compal_laptop_bluetooth_sw",
+					bluetooth_rfk_set,
+					bluetooth_rfk_get);
 
-fail_platform_device2:
+	printk(COMPAL_INFO "driver "COMPAL_DRIVER_VERSION
+			" successfully loaded.\n");
 
-	platform_device_del(compal_device);
+	return 0;
 
-fail_platform_device1:
+fail_platform_device:
 
 	platform_device_put(compal_device);
 
@@ -380,13 +346,21 @@ fail_backlight:
 
 static void __exit compal_cleanup(void)
 {
+	if (bluetooth_rfkill) {
+		rfkill_unregister(bluetooth_rfkill);
+		bluetooth_rfkill = NULL;
+	}
+
+	if (wlan_rfkill) {
+		rfkill_unregister(wlan_rfkill);
+		wlan_rfkill = NULL;
+	}
 
-	sysfs_remove_group(&compal_device->dev.kobj, &compal_attribute_group);
 	platform_device_unregister(compal_device);
 	platform_driver_unregister(&compal_driver);
 	backlight_device_unregister(compalbl_device);
 
-	printk(KERN_INFO "compal-laptop: driver unloaded.\n");
+	printk(COMPAL_INFO "driver unloaded.\n");
 }
 
 module_init(compal_init);
_

Patches currently in -mm which might be from cezary.jackiewicz@gmail.com are

linux-next.patch

