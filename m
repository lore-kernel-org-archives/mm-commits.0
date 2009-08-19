From: akpm@linux-foundation.org
Subject: + viafb-clean-up-duoview.patch added to -mm tree
Date: Wed, 19 Aug 2009 11:49:58 -0700
Message-ID: <200908191849.n7JInw1v025631@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44835 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752826AbZHSSuQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Aug 2009 14:50:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn


The patch titled
     viafb: clean up duoview
has been added to the -mm tree.  Its filename is
     viafb-clean-up-duoview.patch

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
Subject: viafb: clean up duoview
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

Clean the duoview handling up by replacing the varible with the funtion in
the only place where it is used.  This is a code cleanup only, no runtime
change expected.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Cc: Joseph Chan <JosephChan@via.com.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/viafbdev.c |   18 ++----------------
 drivers/video/via/viafbdev.h |    1 -
 2 files changed, 2 insertions(+), 17 deletions(-)

diff -puN drivers/video/via/viafbdev.c~viafb-clean-up-duoview drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c~viafb-clean-up-duoview
+++ a/drivers/video/via/viafbdev.c
@@ -1009,7 +1009,8 @@ static int viafb_cursor(struct fb_info *
 		return -ENODEV;
 
 	/* When duoview and using lcd , use soft cursor */
-	if (viafb_LCD_ON || ((struct viafb_par *)(info->par))->duoview)
+	if (viafb_LCD_ON || (!viafb_SAMM_ON &&
+		viafb_LCD2_ON + viafb_DVI_ON + viafb_CRT_ON == 2))
 		return -ENODEV;
 
 	viafb_show_hw_cursor(info, HW_Cursor_OFF);
@@ -1379,18 +1380,6 @@ static int get_primary_device(void)
 	return primary_device;
 }
 
-static u8 is_duoview(void)
-{
-	if (0 == viafb_SAMM_ON) {
-		if (viafb_LCD_ON + viafb_LCD2_ON +
-			viafb_DVI_ON + viafb_CRT_ON == 2)
-			return true;
-		return false;
-	} else {
-		return false;
-	}
-}
-
 static void apply_second_mode_setting(struct fb_var_screeninfo
 	*sec_var)
 {
@@ -1499,8 +1488,6 @@ static int apply_device_setting(struct v
 		need_set_mode = 1;
 	}
 
-	viaparinfo->duoview = is_duoview();
-
 	if (!need_set_mode) {
 		;
 	} else {
@@ -1621,7 +1608,6 @@ static void parse_active_dev(void)
 		viafb_CRT_ON = STATE_ON;
 		viafb_SAMM_ON = STATE_OFF;
 	}
-	viaparinfo->duoview = is_duoview();
 }
 
 static void parse_video_dev(void)
diff -puN drivers/video/via/viafbdev.h~viafb-clean-up-duoview drivers/video/via/viafbdev.h
--- a/drivers/video/via/viafbdev.h~viafb-clean-up-duoview
+++ a/drivers/video/via/viafbdev.h
@@ -52,7 +52,6 @@ struct viafb_par {
 	u32 VQ_end;		/* Virtual Queue End Address */
 	u32 iga_path;
 	struct proc_dir_entry *proc_entry;	/*viafb proc entry */
-	u8 duoview;		/*Is working in duoview mode? */
 
 	/* I2C stuff */
 	struct via_i2c_stuff i2c_stuff;
_

Patches currently in -mm which might be from FlorianSchandinat@gmx.de are

viafb-remove-duplicated-cx700-register-init.patch
viafb-remove-temporary-start-address-setting.patch
viafb-merge-viafb_update_viafb_par-in-viafb_update_fix.patch
viafb-split-viafb_set_start_addr-up.patch
viafb-fix-ioremap_nocache-error-handling.patch
viafb-clean-up-viamodeh.patch
viafb-remove-duplicated-mode-information.patch
viafb-clean-up-duoview.patch
viafb-clean-up-virtual-memory-handling.patch
fb-fix-fb_pan_display-range-check.patch

