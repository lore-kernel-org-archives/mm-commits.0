From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-da9052_blc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:14:44 -0700
Message-ID: <20121005201444.C03A9100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:36136 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757235Ab2JEUOq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:14:46 -0400
Received: by mail-vc0-f202.google.com with SMTP id fy27so236520vcb.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:14:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, ashish.jangam@kpitcummins.com, broonie@opensource.wolfsonmicro.com, rpurdie@rpsys.net, sachin.kamat@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/da9052_bl.c: use usleep_range() instead of msleep() for small sleeps
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-da9052_blc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/video/backlight/da9052_bl.c: use usleep_range() instead of msleep() for small sleeps

Since msleep() might not sleep for the desired amount when less than 20ms,
use usleep_range().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/da9052_bl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/da9052_bl.c~drivers-video-backlight-da9052_blc-use-usleep_range-instead-of-msleep-for-small-sleeps drivers/video/backlight/da9052_bl.c
--- a/drivers/video/backlight/da9052_bl.c~drivers-video-backlight-da9052_blc-use-usleep_range-instead-of-msleep-for-small-sleeps
+++ a/drivers/video/backlight/da9052_bl.c
@@ -72,7 +72,7 @@ static int da9052_adjust_wled_brightness
 	if (ret < 0)
 		return ret;
 
-	msleep(10);
+	usleep_range(10000, 11000);
 
 	if (wleds->brightness) {
 		ret = da9052_reg_write(wleds->da9052, wled_bank[wleds->led_reg],
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch

