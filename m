From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-ltv350qvc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:14:47 -0700
Message-ID: <20121005201448.293185C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:39884 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757235Ab2JEUOu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:14:50 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so139817wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:14:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, broonie@opensource.wolfsonmicro.com, hskinnemoen@gmail.com, rpurdie@rpsys.net, sachin.kamat@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/ltv350qv.c: use usleep_range() instead of msleep() for small sleeps
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-ltv350qvc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/video/backlight/ltv350qv.c: use usleep_range() instead of msleep() for small sleeps

Since msleep() might not sleep for the desired amount when less than 20ms,
use usleep_range().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ltv350qv.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/video/backlight/ltv350qv.c~drivers-video-backlight-ltv350qvc-use-usleep_range-instead-of-msleep-for-small-sleeps drivers/video/backlight/ltv350qv.c
--- a/drivers/video/backlight/ltv350qv.c~drivers-video-backlight-ltv350qvc-use-usleep_range-instead-of-msleep-for-small-sleeps
+++ a/drivers/video/backlight/ltv350qv.c
@@ -75,7 +75,7 @@ static int ltv350qv_power_on(struct ltv3
 	/* Power On Reset Display off State */
 	if (ltv350qv_write_reg(lcd, LTV_PWRCTL1, 0x0000))
 		goto err;
-	msleep(15);
+	usleep_range(15000, 16000);
 
 	/* Power Setting Function 1 */
 	if (ltv350qv_write_reg(lcd, LTV_PWRCTL1, LTV_VCOM_DISABLE))
@@ -153,7 +153,7 @@ err_settings:
 err_power2:
 err_power1:
 	ltv350qv_write_reg(lcd, LTV_PWRCTL2, 0x0000);
-	msleep(1);
+	usleep_range(1000, 1100);
 err:
 	ltv350qv_write_reg(lcd, LTV_PWRCTL1, LTV_VCOM_DISABLE);
 	return -EIO;
@@ -175,7 +175,7 @@ static int ltv350qv_power_off(struct ltv
 	ret |= ltv350qv_write_reg(lcd, LTV_PWRCTL2, 0x0000);
 
 	/* Wait at least 1 ms */
-	msleep(1);
+	usleep_range(1000, 1100);
 
 	/* Power down setting 2 */
 	ret |= ltv350qv_write_reg(lcd, LTV_PWRCTL1, LTV_VCOM_DISABLE);
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch

