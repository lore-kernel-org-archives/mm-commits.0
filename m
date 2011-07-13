From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-adp8860_blc-remove-a-redundant-assignment-for-max_brightness.patch added to -mm tree
Date: Tue, 12 Jul 2011 17:03:27 -0700
Message-ID: <201107130003.p6D03RWS012415@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34269 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751203Ab1GMAD3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jul 2011 20:03:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, vapier@gentoo.org


The patch titled
     drivers/video/backlight/adp8860_bl.c: remove a redundant assignment for max_brightness
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-adp8860_blc-remove-a-redundant-assignment-for-max_brightness.patch

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
Subject: drivers/video/backlight/adp8860_bl.c: remove a redundant assignment for max_brightness
From: Axel Lin <axel.lin@gmail.com>

We have set props.max_brightness before registering backlight device.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/adp8860_bl.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/video/backlight/adp8860_bl.c~drivers-video-backlight-adp8860_blc-remove-a-redundant-assignment-for-max_brightness drivers/video/backlight/adp8860_bl.c
--- a/drivers/video/backlight/adp8860_bl.c~drivers-video-backlight-adp8860_blc-remove-a-redundant-assignment-for-max_brightness
+++ a/drivers/video/backlight/adp8860_bl.c
@@ -721,8 +721,7 @@ static int __devinit adp8860_probe(struc
 		goto out2;
 	}
 
-	bl->props.max_brightness =
-		bl->props.brightness = ADP8860_MAX_BRIGHTNESS;
+	bl->props.brightness = ADP8860_MAX_BRIGHTNESS;
 
 	data->bl = bl;
 
_

Patches currently in -mm which might be from axel.lin@gmail.com are

linux-next.patch
drivers-video-backlight-ld9040c-small-fixes.patch
drivers-video-backlight-adp8860_blc-remove-a-redundant-assignment-for-max_brightness.patch
backlight-add-ams369fg06-amoled-driver-unregister-backlight-device-when-unload-the-module.patch
backlight-ams369fg06-staticize-ams369fg06_shutdown.patch
backlight-set-backlight-type-and-max_brightness-before-backlights-are-registered.patch
drivers-video-backlight-aat2870_blc-fix-error-checking-for-backlight_device_register.patch
drivers-video-backlight-aat2870_blc-fix-setting-max_current.patch
drivers-video-backlight-aat2870_blc-make-it-buildable-as-a-module.patch
drivers-leds-leds-sunfirec-fix-sunfire_led_generic_probe-error-handling.patch
drivers-leds-leds-netxbig-make-leds_netxbig-depend-on-leds_class.patch

