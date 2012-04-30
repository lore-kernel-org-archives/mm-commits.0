From: akpm@linux-foundation.org
Subject: + drivers-thermal-spear_thermalc-add-device-tree-probing-capability.patch added to -mm tree
Date: Mon, 30 Apr 2012 16:33:33 -0700
Message-ID: <20120430233333.D36F5A0270@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:49823 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757277Ab2D3Xdf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Apr 2012 19:33:35 -0400
Received: by yenq2 with SMTP id q2so402911yen.1
        for <mm-commits@vger.kernel.org>; Mon, 30 Apr 2012 16:33:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: viresh.linux@gmail.com, dan.carpenter@oracle.com, lenb@kernel.org, vincenzo.frascino@st.com, viresh.kumar@st.com


The patch titled
     Subject: drivers/thermal/spear_thermal.c: add Device Tree probing capability
has been added to the -mm tree.  Its filename is
     drivers-thermal-spear_thermalc-add-device-tree-probing-capability.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Viresh Kumar <viresh.linux@gmail.com>
Subject: drivers/thermal/spear_thermal.c: add Device Tree probing capability

SPEAr platforms now support DT and so must convert all drivers to support
DT.  This patch adds DT probing support for SPEAr thermal sensor driver
and updates its documentation too.

Also, as SPEAr is the only user of this driver and is only available with
DT, make this an only DT driver.  So, platform_data is completely removed
and passed via DT now.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Vincenzo Frascino <vincenzo.frascino@st.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/thermal/spear-thermal.txt |   14 +++++
 drivers/thermal/Kconfig                                     |    1 
 drivers/thermal/spear_thermal.c                             |   26 ++++++----
 include/linux/platform_data/spear_thermal.h                 |   26 ----------
 4 files changed, 31 insertions(+), 36 deletions(-)

diff -puN /dev/null Documentation/devicetree/bindings/thermal/spear-thermal.txt
--- /dev/null
+++ a/Documentation/devicetree/bindings/thermal/spear-thermal.txt
@@ -0,0 +1,14 @@
+* SPEAr Thermal
+
+Required properties:
+- compatible : "st,thermal-spear1340"
+- reg : Address range of the thermal registers
+- st,thermal-flags: flags used to enable thermal sensor
+
+Example:
+
+	thermal@fc000000 {
+		compatible = "st,thermal-spear1340";
+		reg = <0xfc000000 0x1000>;
+		st,thermal-flags = <0x7000>;
+	};
diff -puN drivers/thermal/Kconfig~drivers-thermal-spear_thermalc-add-device-tree-probing-capability drivers/thermal/Kconfig
--- a/drivers/thermal/Kconfig~drivers-thermal-spear_thermalc-add-device-tree-probing-capability
+++ a/drivers/thermal/Kconfig
@@ -23,6 +23,7 @@ config SPEAR_THERMAL
 	bool "SPEAr thermal sensor driver"
 	depends on THERMAL
 	depends on PLAT_SPEAR
+	depends on OF
 	help
 	  Enable this to plug the SPEAr thermal sensor driver into the Linux
 	  thermal framework
diff -puN drivers/thermal/spear_thermal.c~drivers-thermal-spear_thermalc-add-device-tree-probing-capability drivers/thermal/spear_thermal.c
--- a/drivers/thermal/spear_thermal.c~drivers-thermal-spear_thermalc-add-device-tree-probing-capability
+++ a/drivers/thermal/spear_thermal.c
@@ -20,9 +20,9 @@
 #include <linux/err.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
+#include <linux/of.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
-#include <linux/platform_data/spear_thermal.h>
 #include <linux/thermal.h>
 
 #define MD_FACTOR	1000
@@ -103,21 +103,20 @@ static int spear_thermal_probe(struct pl
 {
 	struct thermal_zone_device *spear_thermal = NULL;
 	struct spear_thermal_dev *stdev;
-	struct spear_thermal_pdata *pdata;
-	int ret = 0;
+	struct device_node *np = pdev->dev.of_node;
 	struct resource *stres = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	int ret = 0, val;
+
+	if (!np || !of_property_read_u32(np, "st,thermal-flags", &val)) {
+		dev_err(&pdev->dev, "Failed: DT Pdata not passed\n");
+		return -EINVAL;
+	}
 
 	if (!stres) {
 		dev_err(&pdev->dev, "memory resource missing\n");
 		return -ENODEV;
 	}
 
-	pdata = dev_get_platdata(&pdev->dev);
-	if (!pdata) {
-		dev_err(&pdev->dev, "platform data is NULL\n");
-		return -EINVAL;
-	}
-
 	stdev = devm_kzalloc(&pdev->dev, sizeof(*stdev), GFP_KERNEL);
 	if (!stdev) {
 		dev_err(&pdev->dev, "kzalloc fail\n");
@@ -144,7 +143,7 @@ static int spear_thermal_probe(struct pl
 		goto put_clk;
 	}
 
-	stdev->flags = pdata->thermal_flags;
+	stdev->flags = val;
 	writel_relaxed(stdev->flags, stdev->thermal_base);
 
 	spear_thermal = thermal_zone_device_register("spear_thermal", 0,
@@ -189,6 +188,12 @@ static int spear_thermal_exit(struct pla
 	return 0;
 }
 
+static const struct of_device_id spear_thermal_id_table[] = {
+	{ .compatible = "st,thermal-spear1340" },
+	{}
+};
+MODULE_DEVICE_TABLE(of, spear_thermal_id_table);
+
 static struct platform_driver spear_thermal_driver = {
 	.probe = spear_thermal_probe,
 	.remove = spear_thermal_exit,
@@ -196,6 +201,7 @@ static struct platform_driver spear_ther
 		.name = "spear_thermal",
 		.owner = THIS_MODULE,
 		.pm = &spear_thermal_pm_ops,
+		.of_match_table = of_match_ptr(spear_thermal_id_table),
 	},
 };
 
diff -puN include/linux/platform_data/spear_thermal.h~drivers-thermal-spear_thermalc-add-device-tree-probing-capability /dev/null
--- a/include/linux/platform_data/spear_thermal.h
+++ /dev/null
@@ -1,26 +0,0 @@
-/*
- * SPEAr thermal driver platform data.
- *
- * Copyright (C) 2011-2012 ST Microelectronics
- * Author: Vincenzo Frascino <vincenzo.frascino@st.com>
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-#ifndef SPEAR_THERMAL_H
-#define SPEAR_THERMAL_H
-
-/* SPEAr Thermal Sensor Platform Data */
-struct spear_thermal_pdata {
-	/* flags used to enable thermal sensor */
-	unsigned int thermal_flags;
-};
