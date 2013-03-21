From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-palmasc-add-dt-support.patch added to -mm tree
Date: Thu, 21 Mar 2013 14:50:42 -0700
Message-ID: <20130321215042.6EEC531C0AC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:34570 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab3CUVun (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Mar 2013 17:50:43 -0400
Received: by mail-qa0-f73.google.com with SMTP id g10so316653qah.0
        for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2013 14:50:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ldewangan@nvidia.com


The patch titled
     Subject: drivers/rtc/rtc-palmas.c: add dt support
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-palmasc-add-dt-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
rtc-tegra-protect-suspend-resume-callbacks-with-config_pm_sleep.patch
rtc-tegra-use-struct-dev_pm_ops-for-power-management.patch
rtc-tegra-set-irq-name-as-device-name.patch
rtc-tegra-use-managed-rtc_device_register.patch
rtc-tegra-use-managed-rtc_device_register-fix.patch
drivers-rtc-rtc-palmasc-add-dt-support.patch

