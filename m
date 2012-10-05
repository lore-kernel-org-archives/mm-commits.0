From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-kb3886_blc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:14:51 -0700
Message-ID: <20121005201451.B39AC100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:37482 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757235Ab2JEUOw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:14:52 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so236000ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:14:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, broonie@opensource.wolfsonmicro.com, private@claudio.ch, rpurdie@rpsys.net, sachin.kamat@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/kb3886_bl.c: use usleep_range() instead of msleep() for small sleeps
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-kb3886_blc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

