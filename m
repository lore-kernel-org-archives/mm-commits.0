From: akpm@linux-foundation.org
Subject: [merged] rtc-omap-dt-support.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:07:26 -0800
Message-ID: <20121218200727.3928D20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f73.google.com ([74.125.82.73]:54623 "EHLO
	mail-wg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755078Ab2LRUHa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:07:30 -0500
Received: by mail-wg0-f73.google.com with SMTP id dt12so63314wgb.0
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:07:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: afzal@ti.com, a.zummo@towertech.it, grant.likely@secretlab.ca, hvaibhav@ti.com, khilman@ti.com, linux@arm.linux.org.uk, nsekhar@ti.com, zonque@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: omap: dt support
has been removed from the -mm tree.  Its filename was
     rtc-omap-dt-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Afzal Mohammed <afzal@ti.com>
Subject: rtc: omap: dt support

Enhance rtc-omap driver with DT capability

Signed-off-by: Afzal Mohammed <afzal@ti.com>
Acked-by: Sekhar Nori <nsekhar@ti.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Kevin Hilman <khilman@ti.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Daniel Mack <zonque@gmail.com>
Cc: Vaibhav Hiremath <hvaibhav@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/rtc/rtc-omap.txt |   17 ++++++++++
 drivers/rtc/rtc-omap.c                             |   18 +++++++++++
 2 files changed, 35 insertions(+)

diff -puN /dev/null Documentation/devicetree/bindings/rtc/rtc-omap.txt
--- /dev/null
+++ a/Documentation/devicetree/bindings/rtc/rtc-omap.txt
@@ -0,0 +1,17 @@
+TI Real Time Clock
+
+Required properties:
+- compatible: "ti,da830-rtc"
+- reg: Address range of rtc register set
+- interrupts: rtc timer, alarm interrupts in order
+- interrupt-parent: phandle for the interrupt controller
+
+Example:
+
+rtc@1c23000 {
+	compatible = "ti,da830-rtc";
+	reg = <0x23000 0x1000>;
+	interrupts = <19
+		      19>;
+	interrupt-parent = <&intc>;
+};
diff -puN drivers/rtc/rtc-omap.c~rtc-omap-dt-support drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~rtc-omap-dt-support
+++ a/drivers/rtc/rtc-omap.c
@@ -20,6 +20,8 @@
 #include <linux/rtc.h>
 #include <linux/bcd.h>
 #include <linux/platform_device.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
 
 #include <asm/io.h>
 
@@ -298,6 +300,8 @@ static struct rtc_class_ops omap_rtc_ops
 static int omap_rtc_alarm;
 static int omap_rtc_timer;
 
+#define	OMAP_RTC_DATA_DA830_IDX	1
+
 static struct platform_device_id omap_rtc_devtype[] = {
 	{
 		.name	= DRIVER_NAME,
@@ -309,12 +313,25 @@ static struct platform_device_id omap_rt
 };
 MODULE_DEVICE_TABLE(platform, omap_rtc_devtype);
 
+static const struct of_device_id omap_rtc_of_match[] = {
+	{	.compatible	= "ti,da830-rtc",
+		.data		= &omap_rtc_devtype[OMAP_RTC_DATA_DA830_IDX],
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, omap_rtc_of_match);
+
 static int __init omap_rtc_probe(struct platform_device *pdev)
 {
 	struct resource		*res, *mem;
 	struct rtc_device	*rtc;
 	u8			reg, new_ctrl;
 	const struct platform_device_id *id_entry;
+	const struct of_device_id *of_id;
+
+	of_id = of_match_device(omap_rtc_of_match, &pdev->dev);
+	if (of_id)
+		pdev->id_entry = of_id->data;
 
 	omap_rtc_timer = platform_get_irq(pdev, 0);
 	if (omap_rtc_timer <= 0) {
@@ -510,6 +527,7 @@ static struct platform_driver omap_rtc_d
 	.driver		= {
 		.name	= DRIVER_NAME,
 		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(omap_rtc_of_match),
 	},
 	.id_table	= omap_rtc_devtype,
 };
_

Patches currently in -mm which might be from afzal@ti.com are

origin.patch

