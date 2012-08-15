From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-ltv350qvc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch added to -mm tree
Date: Wed, 15 Aug 2012 16:25:59 -0700
Message-ID: <20120815232600.8A9245C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:34325 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab2HOX0D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Aug 2012 19:26:03 -0400
Received: by lbbge1 with SMTP id ge1so102710lbb.1
        for <mm-commits@vger.kernel.org>; Wed, 15 Aug 2012 16:26:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, broonie@opensource.wolfsonmicro.com, hskinnemoen@gmail.com, rpurdie@rpsys.net, sachin.kamat@linaro.org


The patch titled
     Subject: drivers/video/backlight/ltv350qv.c: use usleep_range() instead of msleep() for small sleeps
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-ltv350qvc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
drivers-video-backlight-da9052_blc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
drivers-video-backlight-ltv350qvc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
drivers-video-backlight-kb3886_blc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch

