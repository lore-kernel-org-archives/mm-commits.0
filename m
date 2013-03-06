From: akpm@linux-foundation.org
Subject: + drivers-video-exynos-exynos_mipi_dsic-convert-to-devm_ioremap_resource.patch added to -mm tree
Date: Wed, 06 Mar 2013 15:06:30 -0800
Message-ID: <20130306230630.75C5031C11E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:55173 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309Ab3CFXGb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Mar 2013 18:06:31 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so930351vea.2
        for <mm-commits@vger.kernel.org>; Wed, 06 Mar 2013 15:06:31 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sachin.kamat@linaro.org, FlorianSchandinat@gmx.de, dh09.lee@samsung.com, thierry.reding@avionic-design.de


The patch titled
     Subject: drivers/video/exynos/exynos_mipi_dsi.c: convert to devm_ioremap_resource()
has been added to the -mm tree.  Its filename is
     drivers-video-exynos-exynos_mipi_dsic-convert-to-devm_ioremap_resource.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
 
@@ -384,10 +385,9 @@ static int exynos_mipi_dsi_probe(struct
 
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

linux-next.patch
drivers-video-exynos-exynos_mipi_dsic-convert-to-devm_ioremap_resource.patch

