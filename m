From: akpm@linux-foundation.org
Subject: [merged] drivers-video-exynos-exynos_mipi_dsic-convert-to-devm_ioremap_resource.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:43:42 -0700
Message-ID: <20130430184342.7DF2F31C0F7@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:46931 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932649Ab3D3Snn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:43:43 -0400
Received: by mail-vc0-f201.google.com with SMTP id gf12so84651vcb.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:43:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sachin.kamat@linaro.org, FlorianSchandinat@gmx.de, dh09.lee@samsung.com, thierry.reding@avionic-design.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/exynos/exynos_mipi_dsi.c: convert to devm_ioremap_resource()
has been removed from the -mm tree.  Its filename was
     drivers-video-exynos-exynos_mipi_dsic-convert-to-devm_ioremap_resource.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/video/exynos/exynos_mipi_dsi.c: convert to devm_ioremap_resource()

Use the newly introduced devm_ioremap_resource() instead of
devm_request_and_ioremap() which provides more consistent error handling.

devm_ioremap_resource() provides its own error messages; so all explicit
error messages can be removed from the failure code paths.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Donghwa Lee <dh09.lee@samsung.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/exynos/exynos_mipi_dsi.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/video/exynos/exynos_mipi_dsi.c~drivers-video-exynos-exynos_mipi_dsic-convert-to-devm_ioremap_resource drivers/video/exynos/exynos_mipi_dsi.c
--- a/drivers/video/exynos/exynos_mipi_dsi.c~drivers-video-exynos-exynos_mipi_dsic-convert-to-devm_ioremap_resource
+++ a/drivers/video/exynos/exynos_mipi_dsi.c
@@ -32,6 +32,7 @@
 #include <linux/notifier.h>
 #include <linux/regulator/consumer.h>
 #include <linux/pm_runtime.h>
+#include <linux/err.h>
 
 #include <video/exynos_mipi_dsim.h>
 
@@ -382,10 +383,9 @@ static int exynos_mipi_dsi_probe(struct
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
-	dsim->reg_base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!dsim->reg_base) {
-		dev_err(&pdev->dev, "failed to remap io region\n");
-		ret = -ENOMEM;
+	dsim->reg_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(dsim->reg_base)) {
+		ret = PTR_ERR(dsim->reg_base);
 		goto error;
 	}
 
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

origin.patch
linux-next.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch

