From: akpm@linux-foundation.org
Subject: [merged] thermal-add-support-for-thermal-sensor-present-on-spear13xx-machines.patch removed from -mm tree
Date: Fri, 23 Mar 2012 11:22:47 -0700
Message-ID: <20120323182247.51BCAA02EB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:33750 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759160Ab2CWSWu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Mar 2012 14:22:50 -0400
Received: by lbbgj3 with SMTP id gj3so183555lbb.1
        for <mm-commits@vger.kernel.org>; Fri, 23 Mar 2012 11:22:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vincenzo.frascino@st.com, lenb@kernel.org, viresh.kumar@st.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thermal: add support for thermal sensor present on SPEAr13xx machines
has been removed from the -mm tree.  Its filename was
     thermal-add-support-for-thermal-sensor-present-on-spear13xx-machines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Vincenzo Frascino <vincenzo.frascino@st.com>
Subject: thermal: add support for thermal sensor present on SPEAr13xx machines

ST's SPEAr13xx machines are based on CortexA9 ARM processors.  These
machines contain a thermal sensor for junction temperature monitoring.

This patch adds support for this thermal sensor in existing thermal
framework.

[akpm@linux-foundation.org: little code cleanup]
[akpm@linux-foundation.org: print the pointer correctly]
[viresh.kumar@st.com: thermal/spear_thermal: add compilation dependency on PLAT_SPEAR]
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@st.com>
Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/thermal/Kconfig                     |    8 
 drivers/thermal/Makefile                    |    1 
 drivers/thermal/spear_thermal.c             |  206 ++++++++++++++++++
 include/linux/platform_data/spear_thermal.h |   26 ++
 4 files changed, 241 insertions(+)

diff -puN drivers/thermal/Kconfig~thermal-add-support-for-thermal-sensor-present-on-spear13xx-machines drivers/thermal/Kconfig
--- a/drivers/thermal/Kconfig~thermal-add-support-for-thermal-sensor-present-on-spear13xx-machines
+++ a/drivers/thermal/Kconfig
@@ -18,3 +18,11 @@ config THERMAL_HWMON
 	depends on THERMAL
 	depends on HWMON=y || HWMON=THERMAL
 	default y
+
+config SPEAR_THERMAL
+	bool "SPEAr thermal sensor driver"
+	depends on THERMAL
+	depends on PLAT_SPEAR
+	help
+	  Enable this to plug the SPEAr thermal sensor driver into the Linux
+	  thermal framework
diff -puN drivers/thermal/Makefile~thermal-add-support-for-thermal-sensor-present-on-spear13xx-machines drivers/thermal/Makefile
--- a/drivers/thermal/Makefile~thermal-add-support-for-thermal-sensor-present-on-spear13xx-machines
+++ a/drivers/thermal/Makefile
@@ -3,3 +3,4 @@
 #
 
 obj-$(CONFIG_THERMAL)		+= thermal_sys.o
+obj-$(CONFIG_SPEAR_THERMAL)		+= spear_thermal.o
\ No newline at end of file
diff -puN /dev/null drivers/thermal/spear_thermal.c
--- /dev/null
+++ a/drivers/thermal/spear_thermal.c
@@ -0,0 +1,206 @@
+/*
+ * SPEAr thermal driver.
+ *
+ * Copyright (C) 2011-2012 ST Microelectronics
+ * Author: Vincenzo Frascino <vincenzo.frascino@st.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/clk.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/platform_data/spear_thermal.h>
+#include <linux/thermal.h>
+
+#define MD_FACTOR	1000
+
+/* SPEAr Thermal Sensor Dev Structure */
+struct spear_thermal_dev {
+	/* pointer to base address of the thermal sensor */
+	void __iomem *thermal_base;
+	/* clk structure */
+	struct clk *clk;
+	/* pointer to thermal flags */
+	unsigned int flags;
+};
+
+static inline int thermal_get_temp(struct thermal_zone_device *thermal,
+				unsigned long *temp)
+{
+	struct spear_thermal_dev *stdev = thermal->devdata;
+
+	/*
+	 * Data are ready to be read after 628 usec from POWERDOWN signal
+	 * (PDN) = 1
+	 */
+	*temp = (readl(stdev->thermal_base) & 0x7F) * MD_FACTOR;
+	return 0;
+}
+
+static struct thermal_zone_device_ops ops = {
+	.get_temp = thermal_get_temp,
+};
+
+#ifdef CONFIG_PM
+static int spear_thermal_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct thermal_zone_device *spear_thermal = platform_get_drvdata(pdev);
+	struct spear_thermal_dev *stdev = spear_thermal->devdata;
+	unsigned int actual_mask = 0;
+
+	/* Disable SPEAr Thermal Sensor */
+	actual_mask = readl(stdev->thermal_base);
+	writel(actual_mask & ~stdev->flags, stdev->thermal_base);
+
+	clk_disable(stdev->clk);
+	dev_info(dev, "Suspended.\n");
+
+	return 0;
+}
+
+static int spear_thermal_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct thermal_zone_device *spear_thermal = platform_get_drvdata(pdev);
+	struct spear_thermal_dev *stdev = spear_thermal->devdata;
+	unsigned int actual_mask = 0;
+	int ret = 0;
+
+	ret = clk_enable(stdev->clk);
+	if (ret) {
+		dev_err(&pdev->dev, "Can't enable clock\n");
+		return ret;
+	}
+
+	/* Enable SPEAr Thermal Sensor */
+	actual_mask = readl(stdev->thermal_base);
+	writel(actual_mask | stdev->flags, stdev->thermal_base);
+
+	dev_info(dev, "Resumed.\n");
+
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(spear_thermal_pm_ops, spear_thermal_suspend,
+		spear_thermal_resume);
+
+static int spear_thermal_probe(struct platform_device *pdev)
+{
+	struct thermal_zone_device *spear_thermal = NULL;
+	struct spear_thermal_dev *stdev;
+	struct spear_thermal_pdata *pdata;
+	int ret = 0;
+	struct resource *stres = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+
+	if (!stres) {
+		dev_err(&pdev->dev, "memory resource missing\n");
+		return -ENODEV;
+	}
+
+	pdata = dev_get_platdata(&pdev->dev);
+	if (!pdata) {
+		dev_err(&pdev->dev, "platform data is NULL\n");
+		return -EINVAL;
+	}
+
+	stdev = devm_kzalloc(&pdev->dev, sizeof(*stdev), GFP_KERNEL);
+	if (!stdev) {
+		dev_err(&pdev->dev, "kzalloc fail\n");
+		return -ENOMEM;
+	}
+
+	/* Enable thermal sensor */
+	stdev->thermal_base = devm_ioremap(&pdev->dev, stres->start,
+			resource_size(stres));
+	if (!stdev->thermal_base) {
+		dev_err(&pdev->dev, "ioremap failed\n");
+		return -ENOMEM;
+	}
+
+	stdev->clk = clk_get(&pdev->dev, NULL);
+	if (IS_ERR(stdev->clk)) {
+		dev_err(&pdev->dev, "Can't get clock\n");
+		return PTR_ERR(stdev->clk);
+	}
+
+	ret = clk_enable(stdev->clk);
+	if (ret) {
+		dev_err(&pdev->dev, "Can't enable clock\n");
+		goto put_clk;
+	}
+
+	stdev->flags = pdata->thermal_flags;
+	writel(stdev->flags, stdev->thermal_base);
+
+	spear_thermal = thermal_zone_device_register("spear_thermal", 0,
+				stdev, &ops, 0, 0, 0, 0);
+	if (!spear_thermal) {
+		dev_err(&pdev->dev, "thermal zone device is NULL\n");
+		ret = -EINVAL;
+		goto disable_clk;
+	}
+
+	platform_set_drvdata(pdev, spear_thermal);
+
+	dev_info(&spear_thermal->device, "Thermal Sensor Loaded at: 0x%p.\n",
+			stdev->thermal_base);
+
+	return 0;
+
+disable_clk:
+	clk_disable(stdev->clk);
+put_clk:
+	clk_put(stdev->clk);
+
+	return ret;
+}
+
+static int spear_thermal_exit(struct platform_device *pdev)
+{
+	unsigned int actual_mask = 0;
+	struct thermal_zone_device *spear_thermal = platform_get_drvdata(pdev);
+	struct spear_thermal_dev *stdev = spear_thermal->devdata;
+
+	thermal_zone_device_unregister(spear_thermal);
+	platform_set_drvdata(pdev, NULL);
+
+	/* Disable SPEAr Thermal Sensor */
+	actual_mask = readl(stdev->thermal_base);
+	writel(actual_mask & ~stdev->flags, stdev->thermal_base);
+
+	clk_disable(stdev->clk);
+	clk_put(stdev->clk);
+
+	return 0;
+}
+
+static struct platform_driver spear_thermal_driver = {
+	.probe = spear_thermal_probe,
+	.remove = spear_thermal_exit,
+	.driver = {
+		.name = "spear_thermal",
+		.owner = THIS_MODULE,
+		.pm = &spear_thermal_pm_ops,
+	},
+};
+
+module_platform_driver(spear_thermal_driver);
+
+MODULE_AUTHOR("Vincenzo Frascino <vincenzo.frascino@st.com>");
+MODULE_DESCRIPTION("SPEAr thermal driver");
+MODULE_LICENSE("GPL");
diff -puN /dev/null include/linux/platform_data/spear_thermal.h
--- /dev/null
+++ a/include/linux/platform_data/spear_thermal.h
@@ -0,0 +1,26 @@
+/*
+ * SPEAr thermal driver platform data.
+ *
+ * Copyright (C) 2011-2012 ST Microelectronics
+ * Author: Vincenzo Frascino <vincenzo.frascino@st.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+#ifndef SPEAR_THERMAL_H
+#define SPEAR_THERMAL_H
+
+/* SPEAr Thermal Sensor Platform Data */
+struct spear_thermal_pdata {
+	/* flags used to enable thermal sensor */
+	unsigned int thermal_flags;
+};
+
+#endif /* SPEAR_THERMAL_H */
_

Patches currently in -mm which might be from vincenzo.frascino@st.com are

linux-next.patch

