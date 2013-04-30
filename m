From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-palmasc-add-dt-support.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:58:37 -0700
Message-ID: <20130430185837.788B231C2AA@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:39274 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933458Ab3D3S6i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:58:38 -0400
Received: by mail-qc0-f201.google.com with SMTP id o22so87098qcr.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:58:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ldewangan@nvidia.com, grant.likely@secretlab.ca, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-palmas.c: add dt support
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-palmasc-add-dt-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Laxman Dewangan <ldewangan@nvidia.com>
Subject: drivers/rtc/rtc-palmas.c: add dt support

Add of_device_id table for Palma RTC to be enable the driver from DT file.

The driver can be registered from DT file as:
	palmas: tps65913@58 {
		:::::::::::
		palmas_rtc {
			compatible = "ti,palmas-rtc";
			interrupt-parent = <&palmas>;
			interrupts = <8 0>;
		};
	};

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-palmas.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN drivers/rtc/rtc-palmas.c~drivers-rtc-rtc-palmasc-add-dt-support drivers/rtc/rtc-palmas.c
--- a/drivers/rtc/rtc-palmas.c~drivers-rtc-rtc-palmasc-add-dt-support
+++ a/drivers/rtc/rtc-palmas.c
@@ -30,6 +30,7 @@
 #include <linux/kernel.h>
 #include <linux/mfd/palmas.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/rtc.h>
 #include <linux/types.h>
 #include <linux/platform_device.h>
@@ -316,6 +317,14 @@ static const struct dev_pm_ops palmas_rt
 	SET_SYSTEM_SLEEP_PM_OPS(palmas_rtc_suspend, palmas_rtc_resume)
 };
 
+#ifdef CONFIG_OF
+static struct of_device_id of_palmas_rtc_match[] = {
+	{ .compatible = "ti,palmas-rtc"},
+	{ },
+};
+MODULE_DEVICE_TABLE(of, of_palmas_rtc_match);
+#endif
+
 static struct platform_driver palmas_rtc_driver = {
 	.probe		= palmas_rtc_probe,
 	.remove		= palmas_rtc_remove,
@@ -323,6 +332,7 @@ static struct platform_driver palmas_rtc
 		.owner	= THIS_MODULE,
 		.name	= "palmas-rtc",
 		.pm	= &palmas_rtc_pm_ops,
+		.of_match_table = of_match_ptr(of_palmas_rtc_match),
 	},
 };
 
_

Patches currently in -mm which might be from ldewangan@nvidia.com are

origin.patch
linux-next.patch

