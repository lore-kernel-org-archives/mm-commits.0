From: akpm@linux-foundation.org
Subject: [merged] rtc-tegra-set-irq-name-as-device-name.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:56:44 -0700
Message-ID: <20130430185644.7CE4B31C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:61043 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933309Ab3D3S4q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:56:46 -0400
Received: by mail-qa0-f74.google.com with SMTP id bs12so88229qab.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:56:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ldewangan@nvidia.com, jg1.han@samsung.com, swarren@nvidia.com, thierry.reding@avionic-design.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-tegra.c: set irq name as device name
has been removed from the -mm tree.  Its filename was
     rtc-tegra-set-irq-name-as-device-name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Laxman Dewangan <ldewangan@nvidia.com>
Subject: drivers/rtc/rtc-tegra.c: set irq name as device name

The irq name of tegra rtc shows as "rtc alarm" which actually does not
reflect the name related to driver.

Passing the device name to have the irq names with driver name.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>
Reviewed-by: Stephen Warren <swarren@nvidia.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-tegra.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-tegra.c~rtc-tegra-set-irq-name-as-device-name drivers/rtc/rtc-tegra.c
--- a/drivers/rtc/rtc-tegra.c~rtc-tegra-set-irq-name-as-device-name
+++ a/drivers/rtc/rtc-tegra.c
@@ -362,7 +362,7 @@ static int __init tegra_rtc_probe(struct
 
 	ret = devm_request_irq(&pdev->dev, info->tegra_rtc_irq,
 			tegra_rtc_irq_handler, IRQF_TRIGGER_HIGH,
-			"rtc alarm", &pdev->dev);
+			dev_name(&pdev->dev), &pdev->dev);
 	if (ret) {
 		dev_err(&pdev->dev,
 			"Unable to request interrupt for device (err=%d).\n",
_

Patches currently in -mm which might be from ldewangan@nvidia.com are

origin.patch
linux-next.patch

