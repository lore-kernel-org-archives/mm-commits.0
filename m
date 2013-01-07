From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-tegrac-convert-to-dt-driver.patch removed from -mm tree
Date: Mon, 07 Jan 2013 11:24:55 -0800
Message-ID: <20130107192456.E896520004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:59702 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab3AGTY7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2013 14:24:59 -0500
Received: by mail-ea0-f202.google.com with SMTP id j12so1261586eaa.5
        for <mm-commits@vger.kernel.org>; Mon, 07 Jan 2013 11:24:58 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: josephl@nvidia.com, swarren@wwwdotorg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-tegra.c: convert to DT driver
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-tegrac-convert-to-dt-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 static int tegra_rtc_probe(struct platform_device *pdev)
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
linux-next.patch

