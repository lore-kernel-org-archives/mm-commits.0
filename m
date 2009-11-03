From: akpm@linux-foundation.org
Subject: + spitz-backlight-fix-brightness-limiting.patch added to -mm tree
Date: Tue, 03 Nov 2009 13:32:37 -0800
Message-ID: <200911032132.nA3LWbEK023017@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42705 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754417AbZKCVgG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Nov 2009 16:36:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pavel@ucw.cz, eric.y.miao@gmail.com, rpurdie@rpsys.net


The patch titled
     spitz backlight: fix brightness limiting
has been added to the -mm tree.  Its filename is
     spitz-backlight-fix-brightness-limiting.patch

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
Subject: spitz backlight: fix brightness limiting
From: Pavel Machek <pavel@ucw.cz>

On spitz (& similar) machines, if battery is running low, backlight needs
to be limited to lower step.  Unfortunately, current code uses &= for
limiting, turning backlight off completely for some backlight settings. 
Fix that.

Signed-off-by: Pavel Machek <pavel@ucw.cz>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/video/backlight/corgi_lcd.c~spitz-backlight-fix-brightness-limiting drivers/video/backlight/corgi_lcd.c
--- a/drivers/video/backlight/corgi_lcd.c~spitz-backlight-fix-brightness-limiting
+++ a/drivers/video/backlight/corgi_lcd.c
@@ -433,8 +433,9 @@ static int corgi_bl_update_status(struct
 
 	if (corgibl_flags & CORGIBL_SUSPENDED)
 		intensity = 0;
-	if (corgibl_flags & CORGIBL_BATTLOW)
-		intensity &= lcd->limit_mask;
+
+	if ((corgibl_flags & CORGIBL_BATTLOW) && intensity > lcd->limit_mask)
+		intensity = lcd->limit_mask;
 
 	return corgi_bl_set_intensity(lcd, intensity);
 }
_

Patches currently in -mm which might be from pavel@ucw.cz are

origin.patch
linux-next.patch
spitz-backlight-fix-brightness-limiting.patch
scripts-get_maintainerpl-add-roles-and-rolestats.patch
scripts-get_maintainerpl-fix-non-with-git-blame-and-cleanups.patch
lis3lv02d-axis-remap-and-resource-setup-release.patch
lis3lv02d-i2c-support.patch
fatfs-use-common-time_to_tm-in-fat_time_unix2fat.patch

