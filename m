From: akpm@linux-foundation.org
Subject: [merged] video-exynos_dp-move-disable_irq-to-exynos_dp_suspend.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:38:49 -0800
Message-ID: <20130222203849.9D79D5A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:59573 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757125Ab3BVUiv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:38:51 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so103419vea.2
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:38:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ajaykumar.rs@samsung.com, FlorianSchandinat@gmx.de, jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: video: exynos_dp: move disable_irq() to exynos_dp_suspend()
has been removed from the -mm tree.  Its filename was
     video-exynos_dp-move-disable_irq-to-exynos_dp_suspend.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ajay Kumar <ajaykumar.rs@samsung.com>
Subject: video: exynos_dp: move disable_irq() to exynos_dp_suspend()

disable_irq() should be moved to exynos_dp_suspend(), because enable_irq()
is called at exynos_dp_resume().

Signed-off-by: Ajay Kumar <ajaykumar.rs@samsung.com>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/exynos/exynos_dp_core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/exynos/exynos_dp_core.c~video-exynos_dp-move-disable_irq-to-exynos_dp_suspend drivers/video/exynos/exynos_dp_core.c
--- a/drivers/video/exynos/exynos_dp_core.c~video-exynos_dp-move-disable_irq-to-exynos_dp_suspend
+++ a/drivers/video/exynos/exynos_dp_core.c
@@ -1126,8 +1126,6 @@ static int exynos_dp_remove(struct platf
 	struct exynos_dp_platdata *pdata = pdev->dev.platform_data;
 	struct exynos_dp_device *dp = platform_get_drvdata(pdev);
 
-	disable_irq(dp->irq);
