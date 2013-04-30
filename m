From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-tegra-use-module_platform_driver_probe.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:55:20 -0700
Message-ID: <20130430185520.6EB7231C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:56009 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933206Ab3D3SzV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:55:21 -0400
Received: by mail-ve0-f201.google.com with SMTP id m1so77274ves.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:55:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-tegra: use module_platform_driver_probe()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-tegra-use-module_platform_driver_probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-tegra: use module_platform_driver_probe()

Use module_platform_driver_probe() macro which makes the code smaller and
simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-tegra.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff -puN drivers/rtc/rtc-tegra.c~rtc-rtc-tegra-use-module_platform_driver_probe drivers/rtc/rtc-tegra.c
--- a/drivers/rtc/rtc-tegra.c~rtc-rtc-tegra-use-module_platform_driver_probe
+++ a/drivers/rtc/rtc-tegra.c
@@ -452,17 +452,7 @@ static struct platform_driver tegra_rtc_
 #endif
 };
 
-static int __init tegra_rtc_init(void)
-{
-	return platform_driver_probe(&tegra_rtc_driver, tegra_rtc_probe);
-}
-module_init(tegra_rtc_init);
