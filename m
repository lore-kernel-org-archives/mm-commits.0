From: akpm@linux-foundation.org
Subject: [merged] rtc-tegra-protect-suspend-resume-callbacks-with-config_pm_sleep.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:56:38 -0700
Message-ID: <20130430185638.6E03E5A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:53353 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933342Ab3D3S4j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:56:39 -0400
Received: by mail-gg0-f201.google.com with SMTP id y3so86857ggc.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:56:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ldewangan@nvidia.com, jg1.han@samsung.com, swarren@nvidia.com, thierry.reding@avionic-design.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-tegra.c: protect suspend/resume callbacks with CONFIG_PM_SLEEP
has been removed from the -mm tree.  Its filename was
     rtc-tegra-protect-suspend-resume-callbacks-with-config_pm_sleep.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Laxman Dewangan <ldewangan@nvidia.com>
Subject: drivers/rtc/rtc-tegra.c: protect suspend/resume callbacks with CONFIG_PM_SLEEP

CONFIG_PM doesn't actually enable any of the PM callbacks, it only allows
to enable CONFIG_PM_SLEEP and CONFIG_PM_RUNTIME.  This means if CONFIG_PM
is used to protect system sleep callbacks then it may end up unreferenced
if only runtime PM is enabled.  Hence protecting sleep callbacks with
CONFIG_PM_SLEEP.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>
Reviewed-by: Stephen Warren <swarren@nvidia.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-tegra.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-tegra.c~rtc-tegra-protect-suspend-resume-callbacks-with-config_pm_sleep drivers/rtc/rtc-tegra.c
--- a/drivers/rtc/rtc-tegra.c~rtc-tegra-protect-suspend-resume-callbacks-with-config_pm_sleep
+++ a/drivers/rtc/rtc-tegra.c
@@ -390,7 +390,7 @@ static int __exit tegra_rtc_remove(struc
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int tegra_rtc_suspend(struct platform_device *pdev, pm_message_t state)
 {
 	struct device *dev = &pdev->dev;
@@ -446,7 +446,7 @@ static struct platform_driver tegra_rtc_
 		.owner	= THIS_MODULE,
 		.of_match_table = tegra_rtc_dt_match,
 	},
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend	= tegra_rtc_suspend,
 	.resume		= tegra_rtc_resume,
 #endif
_

Patches currently in -mm which might be from ldewangan@nvidia.com are

origin.patch
linux-next.patch

