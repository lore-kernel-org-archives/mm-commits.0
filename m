From: akpm@linux-foundation.org
Subject: + viafb-remove-duplicated-mode-information.patch added to -mm tree
Date: Wed, 19 Aug 2009 11:49:56 -0700
Message-ID: <200908191849.n7JInu96025628@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57323 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753001AbZHSSuR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Aug 2009 14:50:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn


The patch titled
     viafb: remove duplicated mode information
has been added to the -mm tree.  Its filename is
     viafb-remove-duplicated-mode-information.patch

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
Subject: viafb: remove duplicated mode information
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

Remove the mode information from viafbdev.c and uses the one of viamode.c
instead.  This is possible because horizontal and vertical address are the
same as horizontal and vertical resolution.  The reduced blanking modes in
the table are no problem because they have a higher index than the normal
modes and therefore always the normal modes are selected just as the old
behaviour.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Cc: Joseph Chan <JosephChan@via.com.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/viafbdev.c |   57 ++++-----------------------------
 drivers/video/via/viafbdev.h |    6 ---
 2 files changed, 9 insertions(+), 54 deletions(-)

diff -puN drivers/video/via/viafbdev.c~viafb-remove-duplicated-mode-information drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c~viafb-remove-duplicated-mode-information
+++ a/drivers/video/via/viafbdev.c
@@ -53,51 +53,6 @@ static void retrieve_device_setting(stru
 static void viafb_set_video_device(u32 video_dev_info);
 static void viafb_get_video_device(u32 *video_dev_info);
 
-/* Mode information */
-static const struct viafb_modeinfo viafb_modentry[] = {
-	{480, 640, VIA_RES_480X640},
-	{640, 480, VIA_RES_640X480},
-	{800, 480, VIA_RES_800X480},
-	{800, 600, VIA_RES_800X600},
-	{1024, 768, VIA_RES_1024X768},
-	{1152, 864, VIA_RES_1152X864},
-	{1280, 1024, VIA_RES_1280X1024},
-	{1600, 1200, VIA_RES_1600X1200},
-	{1440, 1050, VIA_RES_1440X1050},
-	{1280, 768, VIA_RES_1280X768,},
-	{1280, 800, VIA_RES_1280X800},
-	{1280, 960, VIA_RES_1280X960},
-	{1920, 1440, VIA_RES_1920X1440},
-	{848, 480, VIA_RES_848X480},
-	{1400, 1050, VIA_RES_1400X1050},
-	{720, 480, VIA_RES_720X480},
-	{720, 576, VIA_RES_720X576},
-	{1024, 512, VIA_RES_1024X512},
-	{1024, 576, VIA_RES_1024X576},
-	{1024, 600, VIA_RES_1024X600},
-	{1280, 720, VIA_RES_1280X720},
-	{1920, 1080, VIA_RES_1920X1080},
-	{1366, 768, VIA_RES_1368X768},
-	{1680, 1050, VIA_RES_1680X1050},
-	{960, 600, VIA_RES_960X600},
-	{1000, 600, VIA_RES_1000X600},
-	{1024, 576, VIA_RES_1024X576},
-	{1024, 600, VIA_RES_1024X600},
-	{1088, 612, VIA_RES_1088X612},
-	{1152, 720, VIA_RES_1152X720},
-	{1200, 720, VIA_RES_1200X720},
-	{1280, 600, VIA_RES_1280X600},
-	{1360, 768, VIA_RES_1360X768},
-	{1440, 900, VIA_RES_1440X900},
-	{1600, 900, VIA_RES_1600X900},
-	{1600, 1024, VIA_RES_1600X1024},
-	{1792, 1344, VIA_RES_1792X1344},
-	{1856, 1392, VIA_RES_1856X1392},
-	{1920, 1200, VIA_RES_1920X1200},
-	{2048, 1536, VIA_RES_2048X1536},
-	{0, 0, VIA_RES_INVALID}
-};
-
 static struct fb_ops viafb_ops;
 
 
@@ -1239,12 +1194,16 @@ int viafb_get_mode_index(int hres, int v
 	u32 i;
 	DEBUG_MSG(KERN_INFO "viafb_get_mode_index!\n");
 
-	for (i = 0; viafb_modentry[i].mode_index != VIA_RES_INVALID; i++)
-		if (viafb_modentry[i].xres == hres &&
-			viafb_modentry[i].yres == vres)
+	for (i = 0; i < NUM_TOTAL_MODETABLE; i++)
+		if (CLE266Modes[i].mode_array &&
+			CLE266Modes[i].crtc[0].crtc.hor_addr == hres &&
+			CLE266Modes[i].crtc[0].crtc.ver_addr == vres)
 			break;
 
-	return viafb_modentry[i].mode_index;
+	if (i == NUM_TOTAL_MODETABLE)
+		return VIA_RES_INVALID;
+
+	return CLE266Modes[i].ModeIndex;
 }
 
 static void check_available_device_to_enable(int device_id)
diff -puN drivers/video/via/viafbdev.h~viafb-remove-duplicated-mode-information drivers/video/via/viafbdev.h
--- a/drivers/video/via/viafbdev.h~viafb-remove-duplicated-mode-information
+++ a/drivers/video/via/viafbdev.h
@@ -70,11 +70,7 @@ struct viafb_par {
 	int video_on_lcd;
 
 };
-struct viafb_modeinfo {
-	u32 xres;
-	u32 yres;
-	int mode_index;
-};
+
 extern unsigned int viafb_second_virtual_yres;
 extern unsigned int viafb_second_virtual_xres;
 extern unsigned int viafb_second_offset;
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

