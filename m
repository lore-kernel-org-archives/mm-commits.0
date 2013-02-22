From: akpm@linux-foundation.org
Subject: [merged] drivers-video-exynos-exynos_mipi_dsic-fix-an-error-check-condition.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:38:25 -0800
Message-ID: <20130222203825.B123331C208@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:35016 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757336Ab3BVUi0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:38:26 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so103571yen.2
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:38:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sachin.kamat@linaro.org, FlorianSchandinat@gmx.de, dh09.lee@samsung.com, inki.dae@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/exynos/exynos_mipi_dsi.c: fix an error check condition
has been removed from the -mm tree.  Its filename was
     drivers-video-exynos-exynos_mipi_dsic-fix-an-error-check-condition.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/video/exynos/exynos_mipi_dsi.c: fix an error check condition

Checking an unsigned variable for negative value returns false.  Hence use
the macro to fix it.

Fixes the following smatch warning:
drivers/video/exynos/exynos_mipi_dsi.c:417 exynos_mipi_dsi_probe() warn:
unsigned 'dsim->irq' is never less than zero.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Acked-by: Donghwa Lee <dh09.lee@samsung.com>
Cc: Inki Dae <inki.dae@samsung.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/exynos/exynos_mipi_dsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/exynos/exynos_mipi_dsi.c~drivers-video-exynos-exynos_mipi_dsic-fix-an-error-check-condition drivers/video/exynos/exynos_mipi_dsi.c
--- a/drivers/video/exynos/exynos_mipi_dsi.c~drivers-video-exynos-exynos_mipi_dsic-fix-an-error-check-condition
+++ a/drivers/video/exynos/exynos_mipi_dsi.c
@@ -414,7 +414,7 @@ static int exynos_mipi_dsi_probe(struct 
 	}
 
 	dsim->irq = platform_get_irq(pdev, 0);
-	if (dsim->irq < 0) {
+	if (IS_ERR_VALUE(dsim->irq)) {
 		dev_err(&pdev->dev, "failed to request dsim irq resource\n");
 		ret = -EINVAL;
 		goto err_platform_get_irq;
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

origin.patch
linux-next.patch

