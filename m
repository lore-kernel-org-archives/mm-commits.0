From: akpm@linux-foundation.org
Subject: + drivers-video-exynos-exynos_mipi_dsic-fix-an-error-check-condition.patch added to -mm tree
Date: Tue, 12 Feb 2013 15:42:09 -0800
Message-ID: <20130212234210.303615A410E@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:34151 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab3BLXmN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Feb 2013 18:42:13 -0500
Received: by mail-vb0-f74.google.com with SMTP id r6so74394vbi.3
        for <mm-commits@vger.kernel.org>; Tue, 12 Feb 2013 15:42:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sachin.kamat@linaro.org, FlorianSchandinat@gmx.de, dh09.lee@samsung.com, inki.dae@samsung.com


The patch titled
     Subject: drivers/video/exynos/exynos_mipi_dsi.c: fix an error check condition
has been added to the -mm tree.  Its filename is
     drivers-video-exynos-exynos_mipi_dsic-fix-an-error-check-condition.patch

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

linux-next.patch
drivers-video-exynos-s6e8ax0c-use-devm_-apis-in-s6e8ax0c.patch
drivers-video-exynos-exynos_mipi_dsic-fix-an-error-check-condition.patch
drivers-video-exynos-exynos_mipi_dsic-use-devm_-apis.patch
backlight-add-lms501kf03-lcd-driver.patch
drivers-video-backlight-ld9040c-use-devm_regulator_bulk_get-api.patch
drivers-rtc-use-of_match_ptr-macro.patch
drivers-rtc-use-of_match_ptr-macro-fix.patch

