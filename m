From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-aat2870_blc-fix-setting-max_current.patch added to -mm tree
Date: Wed, 06 Jul 2011 15:18:02 -0700
Message-ID: <201107062218.p66MI2kD003072@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50211 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752831Ab1GFWSN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jul 2011 18:18:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, jinyoungp@nvidia.com, rpurdie@rpsys.net, sameo@linux.intel.com


The patch titled
     drivers/video/backlight/aat2870_bl.c: fix setting max_current
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-aat2870_blc-fix-setting-max_current.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/video/backlight/aat2870_bl.c: fix setting max_current
From: Axel Lin <axel.lin@gmail.com>

1. current implementation tests wrong value for setting aat2870_bl->max_current.
2. In current implementation, we cannot differentiate below 2 cases:
       a) if pdata->max_current is not set , or
       b) pdata->max_current is set to AAT2870_CURRENT_0_45 ( which is also 0 ).
   fix it by setting AAT2870_CURRENT_0_45 to be 1 and adjust the equation
   in aat2870_brightness() accordingly.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Tested-by: Jin Park <jinyoungp@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/aat2870_bl.c |    4 ++--
 include/linux/mfd/aat2870.h          |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/video/backlight/aat2870_bl.c~drivers-video-backlight-aat2870_blc-fix-setting-max_current drivers/video/backlight/aat2870_bl.c
--- a/drivers/video/backlight/aat2870_bl.c~drivers-video-backlight-aat2870_blc-fix-setting-max_current
+++ a/drivers/video/backlight/aat2870_bl.c
@@ -44,7 +44,7 @@ static inline int aat2870_brightness(str
 	struct backlight_device *bd = aat2870_bl->bd;
 	int val;
 
-	val = brightness * aat2870_bl->max_current;
+	val = brightness * (aat2870_bl->max_current - 1);
 	val /= bd->props.max_brightness;
 
 	return val;
@@ -175,7 +175,7 @@ static int aat2870_bl_probe(struct platf
 	else
 		aat2870_bl->channels = AAT2870_BL_CH_ALL;
 
-	if (pdata->max_brightness > 0)
+	if (pdata->max_current > 0)
 		aat2870_bl->max_current = pdata->max_current;
 	else
 		aat2870_bl->max_current = AAT2870_CURRENT_27_9;
diff -puN include/linux/mfd/aat2870.h~drivers-video-backlight-aat2870_blc-fix-setting-max_current include/linux/mfd/aat2870.h
--- a/include/linux/mfd/aat2870.h~drivers-video-backlight-aat2870_blc-fix-setting-max_current
+++ a/include/linux/mfd/aat2870.h
@@ -89,7 +89,7 @@ enum aat2870_id {
 
 /* Backlight current magnitude (mA) */
 enum aat2870_current {
-	AAT2870_CURRENT_0_45,
+	AAT2870_CURRENT_0_45 = 1,
 	AAT2870_CURRENT_0_90,
 	AAT2870_CURRENT_1_80,
 	AAT2870_CURRENT_2_70,
_

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
drivers-video-backlight-aat2870_blc-fix-setting-max_current.patch
linux-next.patch
drivers-video-backlight-ld9040c-small-fixes.patch
backlight-add-ams369fg06-amoled-driver-unregister-backlight-device-when-unload-the-module.patch
backlight-ams369fg06-staticize-ams369fg06_shutdown.patch
backlight-set-backlight-type-and-max_brightness-before-backlights-are-registered.patch
drivers-video-backlight-aat2870_blc-fix-error-checking-for-backlight_device_register.patch
drivers-leds-leds-sunfirec-fix-sunfire_led_generic_probe-error-handling.patch

