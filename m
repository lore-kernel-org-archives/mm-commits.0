From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-pcf8563c-add-device-tree-support.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:52:52 -0700
Message-ID: <20120731185253.0D6065C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:39268 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756355Ab2GaSwz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:52:55 -0400
Received: by lbbgp10 with SMTP id gp10so295545lbb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:52:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nbowler@elliptictech.com, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-pcf8563.c: add device tree support
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-pcf8563c-add-device-tree-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nick Bowler <nbowler@elliptictech.com>
Subject: drivers/rtc/rtc-pcf8563.c: add device tree support

Set the of_match_table for this driver so that devices can be described
in the device tree.

Signed-off-by: Nick Bowler <nbowler@elliptictech.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf8563.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN drivers/rtc/rtc-pcf8563.c~drivers-rtc-rtc-pcf8563c-add-device-tree-support drivers/rtc/rtc-pcf8563.c
--- a/drivers/rtc/rtc-pcf8563.c~drivers-rtc-rtc-pcf8563c-add-device-tree-support
+++ a/drivers/rtc/rtc-pcf8563.c
@@ -19,6 +19,7 @@
 #include <linux/rtc.h>
 #include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/of.h>
 
 #define DRV_VERSION "0.4.3"
 
@@ -285,10 +286,19 @@ static const struct i2c_device_id pcf856
 };
 MODULE_DEVICE_TABLE(i2c, pcf8563_id);
 
+#ifdef CONFIG_OF
+static const struct of_device_id pcf8563_of_match[] __devinitconst = {
+	{ .compatible = "nxp,pcf8563" },
+	{}
+};
+MODULE_DEVICE_TABLE(of, pcf8563_of_match);
+#endif
+
 static struct i2c_driver pcf8563_driver = {
 	.driver		= {
 		.name	= "rtc-pcf8563",
 		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(pcf8563_of_match),
 	},
 	.probe		= pcf8563_probe,
 	.remove		= pcf8563_remove,
_

Patches currently in -mm which might be from nbowler@elliptictech.com are

origin.patch

