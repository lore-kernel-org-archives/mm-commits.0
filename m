From: akpm@linux-foundation.org
Subject: [merged] spitz-backlight-fix-brightness-limiting.patch removed from -mm tree
Date: Mon, 09 Nov 2009 11:55:24 -0800
Message-ID: <200911091955.nA9JtOIo023796@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50960 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753925AbZKITzc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2009 14:55:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@ucw.cz, eric.y.miao@gmail.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     spitz backlight: fix brightness limiting
has been removed from the -mm tree.  Its filename was
     spitz-backlight-fix-brightness-limiting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch
drivers-video-msm-update-to-new-kernel.patch
scripts-get_maintainerpl-add-roles-and-rolestats.patch
scripts-get_maintainerpl-fix-non-with-git-blame-and-cleanups.patch
msm_sdccc-add-missing-include-fix-compilation.patch
msm_sdccc-add-missing-include-fix-compilation-checkpatch-fixes.patch
lis3lv02d-axis-remap-and-resource-setup-release.patch
lis3lv02d-i2c-support.patch
fatfs-use-common-time_to_tm-in-fat_time_unix2fat.patch

