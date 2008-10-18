From: akpm@linux-foundation.org
Subject: - cirrusfb-use-modedb-and-add-mode_option-parameter-2nd-rev.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:17:16 -0700
Message-ID: <200810182317.m9INHGn5029056@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41302 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751806AbYJRXRa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:17:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     cirrusfb: use modedb and add mode_option parameter
has been removed from the -mm tree.  Its filename was
     cirrusfb-use-modedb-and-add-mode_option-parameter-2nd-rev.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cirrusfb: use modedb and add mode_option parameter
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Use modedb for initial mode instead of table of few predefined modes.

Add mode_option module parameter as a step toward unification of frame
buffers' parameters.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |  126 ++++++-------------------------------
 1 file changed, 21 insertions(+), 105 deletions(-)

diff -puN drivers/video/cirrusfb.c~cirrusfb-use-modedb-and-add-mode_option-parameter-2nd-rev drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~cirrusfb-use-modedb-and-add-mode_option-parameter-2nd-rev
+++ a/drivers/video/cirrusfb.c
@@ -372,98 +372,8 @@ struct cirrusfb_info {
 	void (*unmap)(struct fb_info *info);
 };
 
-static unsigned cirrusfb_def_mode = 1;
 static int noaccel;
-
-/*
- *    Predefined Video Modes
- */
-
-static const struct {
-	const char *name;
-	struct fb_var_screeninfo var;
-} cirrusfb_predefined[] = {
-	{
-		/* autodetect mode */
-		.name	= "Autodetect",
-	}, {
-		/* 640x480, 31.25 kHz, 60 Hz, 25 MHz PixClock */
-		.name	= "640x480",
-		.var	= {
-			.xres		= 640,
-			.yres		= 480,
-			.xres_virtual	= 640,
-			.yres_virtual	= 480,
-			.bits_per_pixel	= 8,
-			.red		= { .length = 8 },
-			.green		= { .length = 8 },
-			.blue		= { .length = 8 },
-			.width		= -1,
-			.height		= -1,
-			.pixclock	= 40000,
-			.left_margin	= 48,
-			.right_margin	= 16,
-			.upper_margin	= 32,
-			.lower_margin	= 8,
-			.hsync_len	= 96,
-			.vsync_len	= 4,
-			.sync	= FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
-			.vmode		= FB_VMODE_NONINTERLACED
-		 }
-	}, {
-		/* 800x600, 48 kHz, 76 Hz, 50 MHz PixClock */
-		.name	= "800x600",
-		.var	= {
-			.xres		= 800,
-			.yres		= 600,
-			.xres_virtual	= 800,
-			.yres_virtual	= 600,
-			.bits_per_pixel	= 8,
-			.red		= { .length = 8 },
-			.green		= { .length = 8 },
-			.blue		= { .length = 8 },
-			.width		= -1,
-			.height		= -1,
-			.pixclock	= 20000,
-			.left_margin	= 128,
-			.right_margin	= 16,
-			.upper_margin	= 24,
-			.lower_margin	= 2,
-			.hsync_len	= 96,
-			.vsync_len	= 6,
-			.vmode		= FB_VMODE_NONINTERLACED
-		 }
-	}, {
-		/*
-		 * Modeline from XF86Config:
-		 * Mode "1024x768" 80  1024 1136 1340 1432  768 770 774 805
-		 */
-		/* 1024x768, 55.8 kHz, 70 Hz, 80 MHz PixClock */
-		.name	= "1024x768",
-		.var	= {
-			.xres		= 1024,
-			.yres		= 768,
-			.xres_virtual	= 1024,
-			.yres_virtual	= 768,
-			.bits_per_pixel	= 8,
-			.red		= { .length = 8 },
-			.green		= { .length = 8 },
-			.blue		= { .length = 8 },
-			.width		= -1,
-			.height		= -1,
-			.pixclock	= 12500,
-			.left_margin	= 144,
-			.right_margin	= 32,
-			.upper_margin	= 30,
-			.lower_margin	= 2,
-			.hsync_len	= 192,
-			.vsync_len	= 6,
-			.vmode		= FB_VMODE_NONINTERLACED
-		}
-	}
-};
-
-#define NUM_TOTAL_MODES    ARRAY_SIZE(cirrusfb_predefined)
+static char *mode_option __devinitdata = "640x480@60";
 
 /****************************************************************************/
 /**** BEGIN PROTOTYPES ******************************************************/
@@ -2267,23 +2177,27 @@ static int cirrusfb_register(struct fb_i
 	/* sanity checks */
 	assert(btype != BT_NONE);
 
+	/* set all the vital stuff */
+	cirrusfb_set_fbinfo(info);
+
 	DPRINTK("cirrusfb: (RAM start set to: 0x%p)\n", info->screen_base);
 
-	/* Make pretend we've set the var so our structures are in a "good" */
-	/* state, even though we haven't written the mode to the hw yet...  */
-	info->var = cirrusfb_predefined[cirrusfb_def_mode].var;
+	err = fb_find_mode(&info->var, info, mode_option, NULL, 0, NULL, 8);
+	if (!err) {
+		DPRINTK("wrong initial video mode\n");
+		err = -EINVAL;
+		goto err_dealloc_cmap;
+	}
+
 	info->var.activate = FB_ACTIVATE_NOW;
 
 	err = cirrusfb_decode_var(&info->var, &cinfo->currentmode, info);
 	if (err < 0) {
 		/* should never happen */
 		DPRINTK("choking on default var... umm, no good.\n");
-		goto err_unmap_cirrusfb;
+		goto err_dealloc_cmap;
 	}
 
-	/* set all the vital stuff */
-	cirrusfb_set_fbinfo(info);
-
 	err = register_framebuffer(info);
 	if (err < 0) {
 		printk(KERN_ERR "cirrusfb: could not register "
@@ -2296,7 +2210,6 @@ static int cirrusfb_register(struct fb_i
 
 err_dealloc_cmap:
 	fb_dealloc_cmap(&info->cmap);
-err_unmap_cirrusfb:
 	cinfo->unmap(info);
 	framebuffer_release(info);
 	return err;
@@ -2608,17 +2521,17 @@ static int __init cirrusfb_setup(char *o
 		return 0;
 
 	while ((this_opt = strsep(&options, ",")) != NULL) {
-		if (!*this_opt) continue;
+		if (!*this_opt)
+			continue;
 
 		DPRINTK("cirrusfb_setup: option '%s'\n", this_opt);
 
-		for (i = 0; i < NUM_TOTAL_MODES; i++) {
-			sprintf(s, "mode:%s", cirrusfb_predefined[i].name);
-			if (strcmp(this_opt, s) == 0)
-				cirrusfb_def_mode = i;
-		}
 		if (!strcmp(this_opt, "noaccel"))
 			noaccel = 1;
+		else if (!strncmp(this_opt, "mode:", 5))
+			mode_option = this_opt + 5;
+		else
+			mode_option = this_opt;
 	}
 	return 0;
 }
@@ -2644,6 +2557,9 @@ static void __exit cirrusfb_exit(void)
 
 module_init(cirrusfb_init);
 
+module_param(mode_option, charp, 0);
+MODULE_PARM_DESC(mode_option, "Initial video mode e.g. '648x480-8@60'");
+
 #ifdef MODULE
 module_exit(cirrusfb_exit);
 #endif
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
fb-convert-lock-unlock_kernel-into-local-fb-mutex.patch

