From: akpm@linux-foundation.org
Subject: - rivafb-fix-initial-brightness.patch removed from -mm tree
Date: Sun, 25 Mar 2007 17:05:46 -0800
Message-ID: <200703260105.l2Q15kac008731@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38560 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933387AbXCZBF5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 21:05:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: agx@sigxcpu.org, adaplas@pol.net, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     rivafb: fix initial brightness
has been removed from the -mm tree.  Its filename was
     rivafb-fix-initial-brightness.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rivafb: fix initial brightness
From: Guido Guenther <agx@sigxcpu.org>

This is the rivafb equivalent of 238576e12fef1d52751c6e08db2d0bdb0e248caf. 
It fixes rivafb having a default backlight brightness of 0 (no picture at
all) on a PBook 6,1.

Signed-off-by: Guido Guenther <agx@sigxcpu.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Acked-by: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/riva/fbdev.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/video/riva/fbdev.c~rivafb-fix-initial-brightness drivers/video/riva/fbdev.c
--- a/drivers/video/riva/fbdev.c~rivafb-fix-initial-brightness
+++ a/drivers/video/riva/fbdev.c
@@ -285,8 +285,6 @@ static const struct riva_regs reg_templa
 #define MAX_LEVEL 0x534
 #define LEVEL_STEP ((MAX_LEVEL - MIN_LEVEL) / FB_BACKLIGHT_MAX)
 
-static struct backlight_properties riva_bl_data;
-
 static int riva_bl_get_level_brightness(struct riva_par *par,
 		int level)
 {
@@ -372,7 +370,7 @@ static void riva_bl_init(struct riva_par
 		FB_BACKLIGHT_MAX);
 
 	bd->props.max_brightness = FB_BACKLIGHT_LEVELS - 1;
-	bd->props.brightness = riva_bl_data.max_brightness;
+	bd->props.brightness = bd->props.max_brightness;
 	bd->props.power = FB_BLANK_UNBLANK;
 	backlight_update_status(bd);
 
_

Patches currently in -mm which might be from agx@sigxcpu.org are
