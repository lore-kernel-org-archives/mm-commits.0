From: akpm@linux-foundation.org
Subject: + rtc-rk808-add-rtc-driver-for-rk808-fix-2.patch added to -mm
 tree
Date: Thu, 11 Sep 2014 12:48:27 -0700
Message-ID: <5411fc8b.YSe6s0gyTyaSI8i/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42819 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbaIKTs2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Sep 2014 15:48:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zyw@rock-chips.com, dianders@chromium.org, heiko@sntech.de, zhangqing@rock-chips.com, mm-commits@vger.kernel.org


The patch titled
     Subject: RTC: RK808: remove tm_def structure
has been added to the -mm tree.  Its filename is
     rtc-rk808-add-rtc-driver-for-rk808-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-rk808-add-rtc-driver-for-rk808-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-rk808-add-rtc-driver-for-rk808-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chris Zhong <zyw@rock-chips.com>
Subject: RTC: RK808: remove tm_def structure

If the date/time is invalid at bootup, there's no reason to set it to
a bogus value. We can just let the data and time be invalid until
someone makes it valid.

Signed-off-by: Chris Zhong <zyw@rock-chips.com>
Cc: Zhang Qing <zhangqing@rock-chips.com>
Reviewed-by: Doug Anderson <dianders@chromium.org>
Tested-by: Doug Anderson <dianders@chromium.org>
Tested-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-rk808.c |   17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff -puN drivers/rtc/rtc-rk808.c~rtc-rk808-add-rtc-driver-for-rk808-fix-2 drivers/rtc/rtc-rk808.c
--- a/drivers/rtc/rtc-rk808.c~rtc-rk808-add-rtc-driver-for-rk808-fix-2
+++ a/drivers/rtc/rtc-rk808.c
@@ -325,17 +325,6 @@ static int rk808_rtc_resume(struct devic
 static SIMPLE_DEV_PM_OPS(rk808_rtc_pm_ops,
 	rk808_rtc_suspend, rk808_rtc_resume);
 
-/* 2014.1.1 12:00:00 Saturday */
-static struct rtc_time tm_def = {
-	.tm_wday = 6,
-	.tm_year = 114,
-	.tm_mon = 0,
-	.tm_mday = 1,
-	.tm_hour = 12,
-	.tm_min = 0,
-	.tm_sec = 0,
-};
-
 static int rk808_rtc_probe(struct platform_device *pdev)
 {
 	struct rk808 *rk808 = dev_get_drvdata(pdev->dev.parent);
@@ -376,10 +365,8 @@ static int rk808_rtc_probe(struct platfo
 		return ret;
 	}
 	ret = rtc_valid_tm(&tm);
-	if (ret) {
-		dev_warn(&pdev->dev, "invalid date/time and init time\n");
-		rk808_rtc_set_time(&pdev->dev, &tm_def);
-	}
+	if (ret)
+		dev_warn(&pdev->dev, "invalid date/time\n");
 
 	device_init_wakeup(&pdev->dev, 1);
 
_

Patches currently in -mm which might be from zyw@rock-chips.com are

rtc-rk808-add-rtc-driver-for-rk808.patch
rtc-rk808-add-rtc-driver-for-rk808-fix.patch
rtc-rk808-add-rtc-driver-for-rk808-fix-2.patch
clk-rk808-add-clkout-driver-for-rk808.patch
linux-next.patch

