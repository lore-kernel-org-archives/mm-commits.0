From: akpm@linux-foundation.org
Subject: + hwmon-add-wm835x-pmic-hardware-monitoring-driver.patch added to -mm tree
Date: Mon, 27 Jul 2009 14:04:08 -0700
Message-ID: <200907272104.n6RL49Ut031054@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37592 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754789AbZG0VFA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Jul 2009 17:05:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, khali@linux-fr.org


The patch titled
     hwmon: add WM835x PMIC hardware monitoring driver
has been added to the -mm tree.  Its filename is
     hwmon-add-wm835x-pmic-hardware-monitoring-driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hwmon: add WM835x PMIC hardware monitoring driver
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

This driver provides reporting of the status supply voltage rails
of the WM835x series of PMICs via the hwmon API.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/hwmon/wm8350      |   26 +++++
 drivers/hwmon/Kconfig           |   10 +
 drivers/hwmon/Makefile          |    1 
 drivers/hwmon/wm8350-hwmon.c    |  151 ++++++++++++++++++++++++++++++
 drivers/mfd/wm8350-core.c       |    3 
 include/linux/mfd/wm8350/core.h |    6 +
 6 files changed, 197 insertions(+)

diff -puN /dev/null Documentation/hwmon/wm8350
--- /dev/null
+++ a/Documentation/hwmon/wm8350
@@ -0,0 +1,26 @@
+Kernel driver wm8350-hwmon
+==========================
+
+Supported chips:
+  * Wolfson Microelectronics WM835x PMICs
+    Prefix: 'wm8350'
+    Datasheet:
+	http://www.wolfsonmicro.com/products/WM8350
+	http://www.wolfsonmicro.com/products/WM8351
+	http://www.wolfsonmicro.com/products/WM8352
+
+Authors: Mark Brown <broonie@opensource.wolfsonmicro.com>
+
+Description
+-----------
+
+The WM835x series of PMICs include an AUXADC which can be used to
+monitor a range of system operating parameters, including the voltages
+of the major supplies within the system.  Currently the driver provides
+simple access to these major supplies.
+
+Voltage Monitoring
+------------------
+
+Voltages are sampled by a 12 bit ADC.  For the internal supplies the ADC
+is referenced to the system VRTC.
diff -puN drivers/hwmon/Kconfig~hwmon-add-wm835x-pmic-hardware-monitoring-driver drivers/hwmon/Kconfig
--- a/drivers/hwmon/Kconfig~hwmon-add-wm835x-pmic-hardware-monitoring-driver
+++ a/drivers/hwmon/Kconfig
@@ -930,6 +930,16 @@ config SENSORS_W83627EHF
 	  This driver can also be built as a module.  If so, the module
 	  will be called w83627ehf.
 
+config SENSORS_WM8350
+	tristate "Wolfson Microelectronics WM835x"
+	depends on MFD_WM8350
+	help
+	  If you say yes here you get support for the hardware
+	  monitoring features of the WM835x series of PMICs.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called wm8350-hwmon.
+
 config SENSORS_ULTRA45
 	tristate "Sun Ultra45 PIC16F747"
 	depends on SPARC64
diff -puN drivers/hwmon/Makefile~hwmon-add-wm835x-pmic-hardware-monitoring-driver drivers/hwmon/Makefile
--- a/drivers/hwmon/Makefile~hwmon-add-wm835x-pmic-hardware-monitoring-driver
+++ a/drivers/hwmon/Makefile
@@ -90,6 +90,7 @@ obj-$(CONFIG_SENSORS_VT8231)	+= vt8231.o
 obj-$(CONFIG_SENSORS_W83627EHF)	+= w83627ehf.o
 obj-$(CONFIG_SENSORS_W83L785TS)	+= w83l785ts.o
 obj-$(CONFIG_SENSORS_W83L786NG)	+= w83l786ng.o
+obj-$(CONFIG_SENSORS_WM8350)	+= wm8350-hwmon.o
 
 ifeq ($(CONFIG_HWMON_DEBUG_CHIP),y)
 EXTRA_CFLAGS += -DDEBUG
diff -puN /dev/null drivers/hwmon/wm8350-hwmon.c
--- /dev/null
+++ a/drivers/hwmon/wm8350-hwmon.c
@@ -0,0 +1,151 @@
+/*
+ * drivers/hwmon/wm8350-hwmon.c - Wolfson Microelectronics WM8350 PMIC
+ *                                  hardware monitoring features.
+ *
+ * Copyright (C) 2009 Wolfson Microelectronics plc
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License v2 as published by the
+ * Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/hwmon.h>
+#include <linux/hwmon-sysfs.h>
+
+#include <linux/mfd/wm8350/core.h>
+#include <linux/mfd/wm8350/comparator.h>
+
+static ssize_t show_name(struct device *dev,
+			 struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "wm8350\n");
+}
+
+static const char *input_names[] = {
+	[WM8350_AUXADC_USB]  = "USB",
+	[WM8350_AUXADC_LINE] = "Line",
+	[WM8350_AUXADC_BATT] = "Battery",
+};
+
+
+static ssize_t show_voltage(struct device *dev,
+			    struct device_attribute *attr, char *buf)
+{
+	struct wm8350 *wm8350 = dev_get_drvdata(dev);
+	int channel = to_sensor_dev_attr(attr)->index;
+	int val;
+
+	val = wm8350_read_auxadc(wm8350, channel, 0, 0) * WM8350_AUX_COEFF;
+	val = DIV_ROUND_CLOSEST(val, 1000);
+
+	return sprintf(buf, "%d\n", val);
+}
+
+static ssize_t show_label(struct device *dev,
+			  struct device_attribute *attr, char *buf)
+{
+	int channel = to_sensor_dev_attr(attr)->index;
+
+	return sprintf(buf, "%s\n", input_names[channel]);
+}
+
+#define WM8350_NAMED_VOLTAGE(id, name) \
+	static SENSOR_DEVICE_ATTR(in##id##_input, S_IRUGO, show_voltage,\
+				  NULL, name);		\
+	static SENSOR_DEVICE_ATTR(in##id##_label, S_IRUGO, show_label,	\
+				  NULL, name)
+
+static DEVICE_ATTR(name, S_IRUGO, show_name, NULL);
+
+WM8350_NAMED_VOLTAGE(0, WM8350_AUXADC_USB);
+WM8350_NAMED_VOLTAGE(1, WM8350_AUXADC_BATT);
+WM8350_NAMED_VOLTAGE(2, WM8350_AUXADC_LINE);
+
+static struct attribute *wm8350_attributes[] = {
+	&dev_attr_name.attr,
+
+	&sensor_dev_attr_in0_input.dev_attr.attr,
+	&sensor_dev_attr_in0_label.dev_attr.attr,
+	&sensor_dev_attr_in1_input.dev_attr.attr,
+	&sensor_dev_attr_in1_label.dev_attr.attr,
+	&sensor_dev_attr_in2_input.dev_attr.attr,
+	&sensor_dev_attr_in2_label.dev_attr.attr,
+
+	NULL,
+};
+
+static const struct attribute_group wm8350_attr_group = {
+	.attrs	= wm8350_attributes,
+};
+
+static int __devinit wm8350_hwmon_probe(struct platform_device *pdev)
+{
+	struct wm8350 *wm8350 = platform_get_drvdata(pdev);
+	int ret;
+
+	ret = sysfs_create_group(&pdev->dev.kobj, &wm8350_attr_group);
+	if (ret)
+		goto err;
+
+	wm8350->hwmon.classdev = hwmon_device_register(&pdev->dev);
+	if (IS_ERR(wm8350->hwmon.classdev)) {
+		ret = PTR_ERR(wm8350->hwmon.classdev);
+		goto err_group;
+	}
+
+	return 0;
+
+err_group:
+	sysfs_remove_group(&pdev->dev.kobj, &wm8350_attr_group);
+err:
+	return ret;
+}
+
+static int __devexit wm8350_hwmon_remove(struct platform_device *pdev)
+{
+	struct wm8350 *wm8350 = platform_get_drvdata(pdev);
+
+	hwmon_device_unregister(wm8350->hwmon.classdev);
+	sysfs_remove_group(&pdev->dev.kobj, &wm8350_attr_group);
+
+	return 0;
+}
+
+static struct platform_driver wm8350_hwmon_driver = {
+	.probe = wm8350_hwmon_probe,
+	.remove = __devexit_p(wm8350_hwmon_remove),
+	.driver = {
+		.name = "wm8350-hwmon",
+		.owner = THIS_MODULE,
+	},
+};
+
+static int __init wm8350_hwmon_init(void)
+{
+	return platform_driver_register(&wm8350_hwmon_driver);
+}
+module_init(wm8350_hwmon_init);
+
+static void __exit wm8350_hwmon_exit(void)
+{
+	platform_driver_unregister(&wm8350_hwmon_driver);
+}
+module_exit(wm8350_hwmon_exit);
+
+MODULE_AUTHOR("Mark Brown <broonie@opensource.wolfsonmicro.com>");
+MODULE_DESCRIPTION("WM8350 Hardware Monitoring");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:wm8350-hwmon");
diff -puN drivers/mfd/wm8350-core.c~hwmon-add-wm835x-pmic-hardware-monitoring-driver drivers/mfd/wm8350-core.c
--- a/drivers/mfd/wm8350-core.c~hwmon-add-wm835x-pmic-hardware-monitoring-driver
+++ a/drivers/mfd/wm8350-core.c
@@ -1472,6 +1472,8 @@ int wm8350_device_init(struct wm8350 *wm
 				   &(wm8350->codec.pdev));
 	wm8350_client_dev_register(wm8350, "wm8350-gpio",
 				   &(wm8350->gpio.pdev));
+	wm8350_client_dev_register(wm8350, "wm8350-hwmon",
+				   &(wm8350->hwmon.pdev));
 	wm8350_client_dev_register(wm8350, "wm8350-power",
 				   &(wm8350->power.pdev));
 	wm8350_client_dev_register(wm8350, "wm8350-rtc", &(wm8350->rtc.pdev));
@@ -1498,6 +1500,7 @@ void wm8350_device_exit(struct wm8350 *w
 	platform_device_unregister(wm8350->wdt.pdev);
 	platform_device_unregister(wm8350->rtc.pdev);
 	platform_device_unregister(wm8350->power.pdev);
+	platform_device_unregister(wm8350->hwmon.pdev);
 	platform_device_unregister(wm8350->gpio.pdev);
 	platform_device_unregister(wm8350->codec.pdev);
 
diff -puN include/linux/mfd/wm8350/core.h~hwmon-add-wm835x-pmic-hardware-monitoring-driver include/linux/mfd/wm8350/core.h
--- a/include/linux/mfd/wm8350/core.h~hwmon-add-wm835x-pmic-hardware-monitoring-driver
+++ a/include/linux/mfd/wm8350/core.h
@@ -605,6 +605,11 @@ struct wm8350_irq {
 	void *data;
 };
 
+struct wm8350_hwmon {
+	struct platform_device *pdev;
+	struct device *classdev;
+};
+
 struct wm8350 {
 	struct device *dev;
 
@@ -629,6 +634,7 @@ struct wm8350 {
 	/* Client devices */
 	struct wm8350_codec codec;
 	struct wm8350_gpio gpio;
+	struct wm8350_hwmon hwmon;
 	struct wm8350_pmic pmic;
 	struct wm8350_power power;
 	struct wm8350_rtc rtc;
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

origin.patch
linux-next.patch
hwmon-add-wm835x-pmic-hardware-monitoring-driver.patch

