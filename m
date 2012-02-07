From: akpm@linux-foundation.org
Subject: + leds-lm3530-fix-setting-pltfm-als_vmax.patch added to -mm tree
Date: Tue, 07 Feb 2012 12:57:01 -0800
Message-ID: <20120207205701.A9D42A035C@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:41382 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756533Ab2BGU5D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Feb 2012 15:57:03 -0500
Received: by ghrr17 with SMTP id r17so741060ghr.1
        for <mm-commits@vger.kernel.org>; Tue, 07 Feb 2012 12:57:02 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, milo.kim@ti.com, rpurdie@rpsys.net, shreshthakumar.sahu@stericsson.com


The patch titled
     Subject: drivers/leds/leds-lm3530.c: fix setting pltfm->als_vmax
has been added to the -mm tree.  Its filename is
     leds-lm3530-fix-setting-pltfm-als_vmax.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Axel Lin <axel.lin@gmail.com>
Subject: drivers/leds/leds-lm3530.c: fix setting pltfm->als_vmax

In current code, pltfm->als_vmin is set to LM3530_ALS_WINDOW_mV and
pltfm->als_vmax is 0.  This does not make sense.  I think what we want
here is setting pltfm->als_vmax to LM3530_ALS_WINDOW_mV.

Both als_vmin and als_vmax local variables will be set to pltfm->als_vmin
and pltfm->als_vmax by a few lines latter.  Thus also remove a redundant
assignment for als_vmin and als_vmax in this patch.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
Acked-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Tested-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lm3530.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/leds/leds-lm3530.c~leds-lm3530-fix-setting-pltfm-als_vmax drivers/leds/leds-lm3530.c
--- a/drivers/leds/leds-lm3530.c~leds-lm3530-fix-setting-pltfm-als_vmax
+++ a/drivers/leds/leds-lm3530.c
@@ -164,8 +164,8 @@ static int lm3530_init_registers(struct 
 
 	if (drvdata->mode == LM3530_BL_MODE_ALS) {
 		if (pltfm->als_vmax == 0) {
-			pltfm->als_vmin = als_vmin = 0;
-			pltfm->als_vmin = als_vmax = LM3530_ALS_WINDOW_mV;
+			pltfm->als_vmin = 0;
+			pltfm->als_vmax = LM3530_ALS_WINDOW_mV;
 		}
 
 		als_vmin = pltfm->als_vmin;
_
Subject: Subject: drivers/leds/leds-lm3530.c: fix setting pltfm->als_vmax

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
leds-lm3530-fix-setting-pltfm-als_vmax.patch
linux-next.patch
platform-drivers-x86-convert-drivers-platform-x86-to-use-module_platform_driver.patch
backlight-convert-backlight-i2c-drivers-to-module_i2c_driver.patch
backlight-convert-backlight-spi-drivers-to-module_spi_driver.patch
backlight-new-backlight-driver-for-lp855x-devices-fix.patch
backlight-lp855x_blc-check-platform-data-in-lp855x_probe.patch
backlight-lp855x_blc-small-cleanups.patch
rtc-convert-rtc-spi-drivers-to-module_spi_driver.patch
rtc-convert-rtc-i2c-drivers-to-module_i2c_driver.patch

