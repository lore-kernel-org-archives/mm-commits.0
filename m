From: akpm@linux-foundation.org
Subject: + ps3fb-fix-spurious-mode-change-failures.patch added to -mm tree
Date: Fri, 14 Sep 2007 19:25:24 -0700
Message-ID: <200709150225.l8F2PObS002961@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33138 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755519AbXIOCZd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Sep 2007 22:25:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com, adaplas@gmail.com, geoffrey.levand@am.sony.com


The patch titled
     ps3fb: Fix spurious mode change failures
has been added to the -mm tree.  Its filename is
     ps3fb-fix-spurious-mode-change-failures.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ps3fb: Fix spurious mode change failures
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

ps3fb: Add a `mode' parameter to ps3fb_get_res_table(), as in some cases it
should check the full-screen flag of the _new_ video mode instead of the
current video mode.

This bug caused spurious mode change failures when switching between
fullscreen and non-fullscreen modes using fbset, while ps3-video-mode worked
fine.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
CC: Geoff Levand <geoffrey.levand@am.sony.com>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/ps3fb.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN drivers/video/ps3fb.c~ps3fb-fix-spurious-mode-change-failures drivers/video/ps3fb.c
--- a/drivers/video/ps3fb.c~ps3fb-fix-spurious-mode-change-failures
+++ a/drivers/video/ps3fb.c
@@ -303,13 +303,13 @@ module_param(ps3fb_mode, int, 0);
 
 static char *mode_option __devinitdata;
 
-static int ps3fb_get_res_table(u32 xres, u32 yres)
+static int ps3fb_get_res_table(u32 xres, u32 yres, int mode)
 {
 	int full_mode;
 	unsigned int i;
 	u32 x, y, f;
 
-	full_mode = (ps3fb_mode & PS3FB_FULL_MODE_BIT) ? PS3FB_RES_FULL : 0;
+	full_mode = (mode & PS3FB_FULL_MODE_BIT) ? PS3FB_RES_FULL : 0;
 	for (i = 0;; i++) {
 		x = ps3fb_res[i].xres;
 		y = ps3fb_res[i].yres;
@@ -527,7 +527,7 @@ static int ps3fb_check_var(struct fb_var
 	}
 
 	/* Memory limit */
-	i = ps3fb_get_res_table(var->xres, var->yres);
+	i = ps3fb_get_res_table(var->xres, var->yres, mode);
 	if (ps3fb_res[i].xres*ps3fb_res[i].yres*BPP > ps3fb_videomemory.size) {
 		DPRINTK("Not enough memory\n");
 		return -ENOMEM;
@@ -553,13 +553,14 @@ static int ps3fb_set_par(struct fb_info 
 	DPRINTK("xres:%d xv:%d yres:%d yv:%d clock:%d\n",
 		info->var.xres, info->var.xres_virtual,
 		info->var.yres, info->var.yres_virtual, info->var.pixclock);
-	i = ps3fb_get_res_table(info->var.xres, info->var.yres);
-	ps3fb.res_index = i;
 
 	mode = ps3fb_find_mode(&info->var, &info->fix.line_length);
 	if (!mode)
 		return -EINVAL;
 
+	i = ps3fb_get_res_table(info->var.xres, info->var.yres, mode);
+	ps3fb.res_index = i;
+
 	offset = FB_OFF(i) + VP_OFF(i);
 	info->fix.smem_len = ps3fb_videomemory.size - offset;
 	info->screen_base = (char __iomem *)ps3fb.xdr_ea + offset;
@@ -610,7 +611,7 @@ static int ps3fb_mmap(struct fb_info *in
 	unsigned long size, offset;
 	int i;
 
-	i = ps3fb_get_res_table(info->var.xres, info->var.yres);
+	i = ps3fb_get_res_table(info->var.xres, info->var.yres, ps3fb_mode);
 	if (i == -1)
 		return -EINVAL;
 
@@ -999,7 +1000,7 @@ static int __devinit ps3fb_probe(struct 
 
 	if (ps3fb_mode > 0 &&
 	    !ps3av_video_mode2res(ps3fb_mode, &xres, &yres)) {
-		ps3fb.res_index = ps3fb_get_res_table(xres, yres);
+		ps3fb.res_index = ps3fb_get_res_table(xres, yres, ps3fb_mode);
 		DPRINTK("res_index:%d\n", ps3fb.res_index);
 	} else
 		ps3fb.res_index = GPU_RES_INDEX;
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

git-scsi-misc.patch
fbdev-fb_create_modedb-non-static-int-first-=-1.patch
fbdev-fb_create_modedb-non-static-int-first-=-1-fix.patch
ps3-fix-black-and-white-stripes.patch
ps3fb-fix-spurious-mode-change-failures.patch
