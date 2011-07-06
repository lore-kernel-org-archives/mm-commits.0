From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-aat2870_blc-fix-error-checking-for-backlight_device_register.patch added to -mm tree
Date: Wed, 06 Jul 2011 15:16:57 -0700
Message-ID: <201107062216.p66MGvAE003025@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39382 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752113Ab1GFWRI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jul 2011 18:17:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, jinyoungp@nvidia.com, rpurdie@rpsys.net, sameo@linux.intel.com


The patch titled
     drivers/video/backlight/aat2870_bl.c: fix error checking for backlight_device_register
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-aat2870_blc-fix-error-checking-for-backlight_device_register.patch

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
Subject: drivers/video/backlight/aat2870_bl.c: fix error checking for backlight_device_register
From: Axel Lin <axel.lin@gmail.com>

backlight_device_register() returns ERR_PTR() on error.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Jin Park <jinyoungp@nvidia.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/aat2870_bl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/backlight/aat2870_bl.c~drivers-video-backlight-aat2870_blc-fix-error-checking-for-backlight_device_register drivers/video/backlight/aat2870_bl.c
--- a/drivers/video/backlight/aat2870_bl.c~drivers-video-backlight-aat2870_blc-fix-error-checking-for-backlight_device_register
+++ a/drivers/video/backlight/aat2870_bl.c
@@ -158,10 +158,10 @@ static int aat2870_bl_probe(struct platf
 	props.type = BACKLIGHT_RAW;
 	bd = backlight_device_register("aat2870-backlight", &pdev->dev,
 				       aat2870_bl, &aat2870_bl_ops, &props);
-	if (!bd) {
+	if (IS_ERR(bd)) {
 		dev_err(&pdev->dev,
 			"Failed allocate memory for backlight device\n");
-		ret = -ENOMEM;
+		ret = PTR_ERR(bd);
 		goto out_kfree;
 	}
 
_

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
linux-next.patch
drivers-video-backlight-ld9040c-small-fixes.patch
backlight-add-ams369fg06-amoled-driver-unregister-backlight-device-when-unload-the-module.patch
backlight-ams369fg06-staticize-ams369fg06_shutdown.patch
backlight-set-backlight-type-and-max_brightness-before-backlights-are-registered.patch
drivers-video-backlight-aat2870_blc-fix-error-checking-for-backlight_device_register.patch
drivers-leds-leds-sunfirec-fix-sunfire_led_generic_probe-error-handling.patch

