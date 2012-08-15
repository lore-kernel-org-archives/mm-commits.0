From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-da9052_blc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch added to -mm tree
Date: Wed, 15 Aug 2012 16:25:56 -0700
Message-ID: <20120815232557.312AA1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:47927 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab2HOXZ6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Aug 2012 19:25:58 -0400
Received: by obbwc20 with SMTP id wc20so1537814obb.1
        for <mm-commits@vger.kernel.org>; Wed, 15 Aug 2012 16:25:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, ashish.jangam@kpitcummins.com, broonie@opensource.wolfsonmicro.com, rpurdie@rpsys.net, sachin.kamat@linaro.org


The patch titled
     Subject: drivers/video/backlight/da9052_bl.c: use usleep_range() instead of msleep() for small sleeps
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-da9052_blc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch

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

linux-next.patch
drivers-video-backlight-da9052_blc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
drivers-video-backlight-ltv350qvc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
drivers-video-backlight-kb3886_blc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch

