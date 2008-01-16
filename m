From: akpm@linux-foundation.org
Subject: + restore-jdelvare-i2c-i2c-add-i2c_new_dummy-utility.patch added to -mm tree
Date: Wed, 16 Jan 2008 01:37:53 -0800
Message-ID: <200801160946.m0G9kEd6030760@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45535 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751269AbYAPJqf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jan 2008 04:46:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, byron.bbradley@gmail.com, david-b@pacbell.net


The patch titled
     restore jdelvare-i2c-i2c-add-i2c_new_dummy-utility
has been added to the -mm tree.  Its filename is
     restore-jdelvare-i2c-i2c-add-i2c_new_dummy-utility.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: restore jdelvare-i2c-i2c-add-i2c_new_dummy-utility


Cc: Jean Delvare <khali@linux-fr.org>
Cc: "Byron Bradley" <byron.bbradley@gmail.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/i2c-core.c |   59 ++++++++++++++++++++++++++++++++++++++-
 include/linux/i2c.h    |    6 +++
 2 files changed, 64 insertions(+), 1 deletion(-)

diff -puN drivers/i2c/i2c-core.c~restore-jdelvare-i2c-i2c-add-i2c_new_dummy-utility drivers/i2c/i2c-core.c
--- a/drivers/i2c/i2c-core.c~restore-jdelvare-i2c-i2c-add-i2c_new_dummy-utility
+++ a/drivers/i2c/i2c-core.c
@@ -277,6 +277,50 @@ void i2c_unregister_device(struct i2c_cl
 EXPORT_SYMBOL_GPL(i2c_unregister_device);
 
 
+static int dummy_nop(struct i2c_client *client)
+{
+	return 0;
+}
+
+static struct i2c_driver dummy_driver = {
+	.driver.name	= "dummy",
+	.probe		= dummy_nop,
+	.remove		= dummy_nop,
+};
+
+/**
+ * i2c_new_dummy - return a new i2c device bound to a dummy driver
+ * @adapter: the adapter managing the device
+ * @address: seven bit address to be used
+ * @type: optional label used for i2c_client.name
+ * Context: can sleep
+ *
+ * This returns an I2C client bound to the "dummy" driver, intended for use
+ * with devices that consume multiple addresses.  Examples of such chips
+ * include various EEPROMS (like 24c04 and 24c08 models).
+ *
+ * These dummy devices have two main uses.  First, most I2C and SMBus calls
+ * except i2c_transfer() need a client handle; the dummy will be that handle.
+ * And second, this prevents the specified address from being bound to a
+ * different driver.
+ *
+ * This returns the new i2c client, which should be saved for later use with
+ * i2c_unregister_device(); or NULL to indicate an error.
+ */
+struct i2c_client *
+i2c_new_dummy(struct i2c_adapter *adapter, u16 address, const char *type)
+{
+	struct i2c_board_info info = {
+		.driver_name	= "dummy",
+		.addr		= address,
+	};
+
+	if (type)
+		strlcpy(info.type, type, sizeof info.type);
+	return i2c_new_device(adapter, &info);
+}
+EXPORT_SYMBOL_GPL(i2c_new_dummy);
+
 /* ------------------------------------------------------------------------- */
 
 /* I2C bus adapters -- one roots each I2C or SMBUS segment */
@@ -832,11 +876,24 @@ static int __init i2c_init(void)
 	retval = bus_register(&i2c_bus_type);
 	if (retval)
 		return retval;
-	return class_register(&i2c_adapter_class);
+	retval = class_register(&i2c_adapter_class);
+	if (retval)
+		goto bus_err;
+	retval = i2c_add_driver(&dummy_driver);
+	if (retval)
+		goto class_err;
+	return 0;
+
+class_err:
+	class_unregister(&i2c_adapter_class);
+bus_err:
+	bus_unregister(&i2c_bus_type);
+	return retval;
 }
 
 static void __exit i2c_exit(void)
 {
+	i2c_del_driver(&dummy_driver);
 	class_unregister(&i2c_adapter_class);
 	bus_unregister(&i2c_bus_type);
 }
diff -puN include/linux/i2c.h~restore-jdelvare-i2c-i2c-add-i2c_new_dummy-utility include/linux/i2c.h
--- a/include/linux/i2c.h~restore-jdelvare-i2c-i2c-add-i2c_new_dummy-utility
+++ a/include/linux/i2c.h
@@ -257,6 +257,12 @@ i2c_new_probed_device(struct i2c_adapter
 		      struct i2c_board_info *info,
 		      unsigned short const *addr_list);
 
+/* For devices that use several addresses, use i2c_new_dummy() to make
+ * client handles for the extra addresses.
+ */
+extern struct i2c_client *
+i2c_new_dummy(struct i2c_adapter *adap, u16 address, const char *type);
+
 extern void i2c_unregister_device(struct i2c_client *);
 
 /* Mainboard arch_initcall() code should register all its I2C devices.
_

Patches currently in -mm which might be from khali@linux-fr.org are

origin.patch
small-acpica-extension-to-be-able-to-store-the-name-of.patch
export-acpi_check_resource_conflict.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
git-arm.patch
git-dvb.patch
fix-jdelvare-i2c-i2c-constify-client-address-data.patch
oz99x-i2c-button-and-led-support-driver.patch
oz99x-i2c-button-and-led-support-driver-update.patch
i2c-isp1301_omap-new-style-i2c-driver-updates-part-1.patch
i2c-isp1301_omap-new-style-i2c-driver-updates-part-2.patch
git-hwmon.patch
hwmon-new-chip-driver-for-ti-ads7828-a-d.patch
hwmon-new-chip-driver-for-ti-ads7828-a-d-checkpatch-fixes.patch
hwmon-new-chip-driver-for-ti-ads7828-a-d-update.patch
rtc-pcf8583-dont-abuse-i2c_m_nostart.patch
restore-jdelvare-i2c-i2c-add-i2c_new_dummy-utility.patch
rtc-add-support-for-the-s-35390a-rtc-chip.patch
rtc-add-support-for-the-s-35390a-rtc-chip-update.patch
rtc-add-support-for-the-s-35390a-rtc-chip-update2.patch
gpiolib-add-drivers-gpio-directory.patch
gpiolib-add-gpio-provider-infrastructure.patch
gpiolib-update-documentation-gpiotxt.patch
gpiolib-pxa-platform-support.patch
gpiolib-pcf857x-i2c-gpio-expander-support.patch
gpiolib-mcp23s08-spi-gpio-expander-support.patch
gpiolib-pca9539-i2c-gpio-expander-support.patch
gpiolib-deprecate-obsolete-pca9539-driver.patch
gpiolib-avr32-at32ap-platform-support.patch
