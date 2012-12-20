From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-tegrac-convert-to-dt-driver.patch added to -mm tree
Date: Thu, 20 Dec 2012 15:58:00 -0800
Message-ID: <20121220235801.2025B20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:53977 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab2LTX6D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Dec 2012 18:58:03 -0500
Received: by mail-fa0-f74.google.com with SMTP id t1so214481fae.3
        for <mm-commits@vger.kernel.org>; Thu, 20 Dec 2012 15:58:02 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: josephl@nvidia.com, swarren@wwwdotorg.org


The patch titled
     Subject: drivers/rtc/rtc-tegra.c: convert to DT driver
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-tegrac-convert-to-dt-driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joseph Lo <josephl@nvidia.com>
Subject: drivers/rtc/rtc-tegra.c: convert to DT driver

After Kernel 3.7, the Tegra device will only support booting with DT.  The
legacy Tegra RTC platform driver will not work anymore.  This patch
convert the driver to support DT.

Signed-off-by: Joseph Lo <josephl@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Joseph Lo <josephl@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-tegra.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/rtc/rtc-tegra.c~drivers-rtc-rtc-tegrac-convert-to-dt-driver drivers/rtc/rtc-tegra.c
--- a/drivers/rtc/rtc-tegra.c~drivers-rtc-rtc-tegrac-convert-to-dt-driver
+++ a/drivers/rtc/rtc-tegra.c
@@ -303,6 +303,12 @@ static struct rtc_class_ops tegra_rtc_op
 	.alarm_irq_enable = tegra_rtc_alarm_irq_enable,
 };
 
+static const struct of_device_id tegra_rtc_dt_match[] = {
+	{ .compatible = "nvidia,tegra20-rtc", },
+	{}
+};
+MODULE_DEVICE_TABLE(of, tegra_rtc_dt_match);
+
 static int __devinit tegra_rtc_probe(struct platform_device *pdev)
 {
 	struct tegra_rtc_info *info;
@@ -440,6 +446,7 @@ static struct platform_driver tegra_rtc_
 	.driver		= {
 		.name	= "tegra_rtc",
 		.owner	= THIS_MODULE,
+		.of_match_table = tegra_rtc_dt_match,
 	},
 #ifdef CONFIG_PM
 	.suspend	= tegra_rtc_suspend,
_

Patches currently in -mm which might be from josephl@nvidia.com are

origin.patch
drivers-rtc-rtc-tegrac-convert-to-dt-driver.patch

