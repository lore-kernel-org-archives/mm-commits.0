From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-kb3886_blc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch added to -mm tree
Date: Wed, 15 Aug 2012 16:26:03 -0700
Message-ID: <20120815232604.41047100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:47927 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab2HOX0F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Aug 2012 19:26:05 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so1537814obb.1
        for <mm-commits@vger.kernel.org>; Wed, 15 Aug 2012 16:26:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, broonie@opensource.wolfsonmicro.com, private@claudio.ch, rpurdie@rpsys.net, sachin.kamat@linaro.org


The patch titled
     Subject: drivers/video/backlight/kb3886_bl.c: use usleep_range() instead of msleep() for small sleeps
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-kb3886_blc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch

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
Subject: drivers/video/backlight/kb3886_bl.c: use usleep_range() instead of msleep() for small sleeps

Since msleep() might not sleep for the desired amount when less than 20ms,
use usleep_range().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Claudio Nieder <private@claudio.ch>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/kb3886_bl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/backlight/kb3886_bl.c~drivers-video-backlight-kb3886_blc-use-usleep_range-instead-of-msleep-for-small-sleeps drivers/video/backlight/kb3886_bl.c
--- a/drivers/video/backlight/kb3886_bl.c~drivers-video-backlight-kb3886_blc-use-usleep_range-instead-of-msleep-for-small-sleeps
+++ a/drivers/video/backlight/kb3886_bl.c
@@ -34,9 +34,9 @@ static void kb3886_bl_set_intensity(int 
 	mutex_lock(&bl_mutex);
 	intensity = intensity&0xff;
 	outb(KB3886_ADC_DAC_PWM, KB3886_PARENT);
-	msleep(10);
+	usleep_range(10000, 11000);
 	outb(KB3886_PWM0_WRITE, KB3886_IO);
-	msleep(10);
+	usleep_range(10000, 11000);
 	outb(intensity, KB3886_IO);
 	mutex_unlock(&bl_mutex);
 }
_

Patches currently in -mm which might be from jg1.han@samsung.com are

linux-next.patch
drivers-video-backlight-da9052_blc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
drivers-video-backlight-ltv350qvc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
drivers-video-backlight-kb3886_blc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch

