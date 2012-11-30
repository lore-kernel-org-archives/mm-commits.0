From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-tps65910c-enable-rtc-power-domain-on-initialization.patch added to -mm tree
Date: Thu, 29 Nov 2012 17:56:46 -0800
Message-ID: <20121130015647.2983320004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:50108 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457Ab2K3B4u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Nov 2012 20:56:50 -0500
Received: by mail-la0-f74.google.com with SMTP id v3so1059419lag.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Nov 2012 17:56:49 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Milo.Kim@ti.com, a.zummo@towertech.it, milo.kim@ti.com, sameo@linux.intel.com, sivaramn@nvidia.com, vbyravarasu@nvidia.com


The patch titled
     Subject: drivers/rtc/rtc-tps65910.c: enable RTC power domain on initialization
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-tps65910c-enable-rtc-power-domain-on-initialization.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kim, Milo" <Milo.Kim@ti.com>
Subject: drivers/rtc/rtc-tps65910.c: enable RTC power domain on initialization

Enabling RTC HW block depends on the default value of TPS65910 register. 
In some mode, RTC block is disabled by default.(eg.  AM3517 Craneboard) In
this case, RTC_PWDN(RTC power down) bit should be cleared to enable the
RTC HW block.

This patch also works in case that RTC block is active by default, because
there is no side effect even if the bit is updated again.

Tested on AM3517 Craneboard.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Cc: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Sivaram Nair <sivaramn@nvidia.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-tps65910.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/rtc/rtc-tps65910.c~drivers-rtc-rtc-tps65910c-enable-rtc-power-domain-on-initialization drivers/rtc/rtc-tps65910.c
--- a/drivers/rtc/rtc-tps65910.c~drivers-rtc-rtc-tps65910c-enable-rtc-power-domain-on-initialization
+++ a/drivers/rtc/rtc-tps65910.c
@@ -247,6 +247,13 @@ static int __devinit tps65910_rtc_probe(
 		return ret;
 
 	dev_dbg(&pdev->dev, "Enabling rtc-tps65910.\n");
+
+	/* Enable RTC digital power domain */
+	ret = regmap_update_bits(tps65910->regmap, TPS65910_DEVCTRL,
+		DEVCTRL_RTC_PWDN_MASK, 0 << DEVCTRL_RTC_PWDN_SHIFT);
+	if (ret < 0)
+		return ret;
+
 	rtc_reg = TPS65910_RTC_CTRL_STOP_RTC;
 	ret = regmap_write(tps65910->regmap, TPS65910_RTC_CTRL, rtc_reg);
 	if (ret < 0)
_

Patches currently in -mm which might be from Milo.Kim@ti.com are

drivers-rtc-rtc-tps65910c-fix-invalid-pointer-access-on-_remove.patch
linux-next.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
drivers-video-backlight-lp855x_blc-remove-unnecessary-mutex-code.patch
drivers-rtc-rtc-tps65910c-enable-rtc-power-domain-on-initialization.patch

