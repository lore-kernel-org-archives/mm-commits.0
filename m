From: akpm@linux-foundation.org
Subject: + ps3fb-reorganize-modedb-handling.patch added to -mm tree
Date: Sat, 26 Jan 2008 21:14:36 -0800
Message-ID: <200801270514.m0R5EXMK031013@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51783 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750995AbYA0FOy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jan 2008 00:14:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com, adaplas@pol.net


The patch titled
     ps3fb: reorganize modedb handling
has been added to the -mm tree.  Its filename is
     ps3fb-reorganize-modedb-handling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ps3fb: reorganize modedb handling
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Reorganize modedb handling:
  - Reorder the video modes in ps3fb_modedb, for easier indexing using
    PS3AV_MODE_* numbers,
  - Introduce ps3fb_native_vmode(), to convert from native (PS3AV_MODE_*) mode
    numbers to struct fb_videomode *,
  - Rename and move ps3fb_default_mode() to ps3fb_vmode().

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/ps3fb.c |  116 ++++++++++++++++++++--------------------
 1 file changed, 60 insertions(+), 56 deletions(-)

diff -puN drivers/video/ps3fb.c~ps3fb-reorganize-modedb-handling drivers/video/ps3fb.c
--- a/drivers/video/ps3fb.c~ps3fb-reorganize-modedb-handling
+++ a/drivers/video/ps3fb.c
@@ -146,6 +146,8 @@ struct ps3fb_par {
 };
 
 
+#define FIRST_NATIVE_MODE_INDEX	10
+
 static const struct fb_videomode ps3fb_modedb[] = {
     /* 60 Hz broadcast modes (modes "1" to "5") */
     {
@@ -193,24 +195,7 @@ static const struct fb_videomode ps3fb_m
         FB_SYNC_BROADCAST, FB_VMODE_NONINTERLACED
     },
 
-    /* VESA modes (modes "11" to "13") */
-    {
-	/* WXGA */
-	"wxga", 60, 1280, 768, 12924, 160, 24, 29, 3, 136, 6,
-	0, FB_VMODE_NONINTERLACED,
-	FB_MODE_IS_VESA
-    }, {
-	/* SXGA */
-	"sxga", 60, 1280, 1024, 9259, 248, 48, 38, 1, 112, 3,
-	FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT, FB_VMODE_NONINTERLACED,
-	FB_MODE_IS_VESA
-    }, {
-	/* WUXGA */
-	"wuxga", 60, 1920, 1200, 6494, 80, 48, 26, 3, 32, 6,
-	FB_SYNC_HOR_HIGH_ACT, FB_VMODE_NONINTERLACED,
-	FB_MODE_IS_VESA
-    },
-
+    [FIRST_NATIVE_MODE_INDEX] =
     /* 60 Hz broadcast modes (full resolution versions of modes "1" to "5") */
     {
 	/* 480if */
@@ -255,6 +240,24 @@ static const struct fb_videomode ps3fb_m
 	/* 1080pf */
 	"1080pf", 50, 1920, 1080, 6734, 148, 484, 36, 4, 88, 5,
 	FB_SYNC_BROADCAST, FB_VMODE_NONINTERLACED
+    },
+
+    /* VESA modes (modes "11" to "13") */
+    {
+	/* WXGA */
+	"wxga", 60, 1280, 768, 12924, 160, 24, 29, 3, 136, 6,
+	0, FB_VMODE_NONINTERLACED,
+	FB_MODE_IS_VESA
+    }, {
+	/* SXGA */
+	"sxga", 60, 1280, 1024, 9259, 248, 48, 38, 1, 112, 3,
+	FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT, FB_VMODE_NONINTERLACED,
+	FB_MODE_IS_VESA
+    }, {
+	/* WUXGA */
+	"wuxga", 60, 1920, 1200, 6494, 80, 48, 26, 3, 32, 6,
+	FB_SYNC_HOR_HIGH_ACT, FB_VMODE_NONINTERLACED,
+	FB_MODE_IS_VESA
     }
 };
 
@@ -298,20 +301,43 @@ static int ps3fb_cmp_mode(const struct f
 	return 0;
 }
 
+static const struct fb_videomode *ps3fb_native_vmode(enum ps3av_mode_num id)
+{
+	return &ps3fb_modedb[FIRST_NATIVE_MODE_INDEX + id - 1];
+}
+
+static const struct fb_videomode *ps3fb_vmode(int id)
+{
+	u32 mode = id & PS3AV_MODE_MASK;
+
+	if (mode < PS3AV_MODE_480I || mode > PS3AV_MODE_WUXGA)
+		return NULL;
+
+	if (mode <= PS3AV_MODE_1080P50 && !(id & PS3AV_MODE_FULL)) {
+		/* Non-fullscreen broadcast mode */
+		return &ps3fb_modedb[mode - 1];
+	}
+
+	return ps3fb_native_vmode(mode);
+}
+
 static unsigned int ps3fb_find_mode(struct fb_var_screeninfo *var,
 				    u32 *ddr_line_length, u32 *xdr_line_length)
 {
-	unsigned int i, mode;
+	unsigned int id;
+	const struct fb_videomode *vmode;
 
-	for (i = PS3AV_MODE_1080P50; i < ARRAY_SIZE(ps3fb_modedb); i++)
-		if (!ps3fb_cmp_mode(&ps3fb_modedb[i], var))
+	for (id = PS3AV_MODE_480I; id <= PS3AV_MODE_WUXGA; id++) {
+		vmode = ps3fb_native_vmode(id);
+		if (!ps3fb_cmp_mode(vmode, var))
 			goto found;
+	}
 
-	pr_debug("ps3fb_find_mode: mode not found\n");
+	pr_debug("%s: mode not found\n", __func__);
 	return 0;
 
 found:
-	*ddr_line_length = ps3fb_modedb[i].xres * BPP;
+	*ddr_line_length = vmode->xres * BPP;
 
 	if (!var->xres) {
 		var->xres = 1;
@@ -330,36 +356,14 @@ found:
 	} else
 		*xdr_line_length = *ddr_line_length;
 
-	mode = i+1;
-	if (mode > PS3AV_MODE_WUXGA) {
-		mode -= PS3AV_MODE_WUXGA;
+	if (vmode->sync & FB_SYNC_BROADCAST) {
 		/* Full broadcast modes have the full mode bit set */
-		if (ps3fb_modedb[i].xres == var->xres &&
-		    ps3fb_modedb[i].yres == var->yres)
-			mode |= PS3AV_MODE_FULL;
-	}
-
-	pr_debug("ps3fb_find_mode: mode %u\n", mode);
-
-	return mode;
-}
-
-static const struct fb_videomode *ps3fb_default_mode(int id)
-{
-	u32 mode = id & PS3AV_MODE_MASK;
-	u32 flags;
-
-	if (mode < PS3AV_MODE_480I || mode > PS3AV_MODE_WUXGA)
-		return NULL;
-
-	flags = id & ~PS3AV_MODE_MASK;
-
-	if (mode <= PS3AV_MODE_1080P50 && flags & PS3AV_MODE_FULL) {
-		/* Full broadcast mode */
-		return &ps3fb_modedb[mode + PS3AV_MODE_WUXGA - 1];
+		if (vmode->xres == var->xres && vmode->yres == var->yres)
+			id |= PS3AV_MODE_FULL;
 	}
 
-	return &ps3fb_modedb[mode - 1];
+	pr_debug("%s: mode %u\n", __func__, id);
+	return id;
 }
 
 static void ps3fb_sync_image(struct device *dev, u64 frame_offset,
@@ -553,7 +557,7 @@ static int ps3fb_set_par(struct fb_info 
 	if (!mode)
 		return -EINVAL;
 
-	vmode = ps3fb_default_mode(mode | PS3AV_MODE_FULL);
+	vmode = ps3fb_native_vmode(mode & PS3AV_MODE_MASK);
 
 	info->fix.smem_start = virt_to_abs(ps3fb.xdr_ea);
 	info->fix.smem_len = ps3fb.xdr_size;
@@ -767,7 +771,7 @@ static int ps3fb_ioctl(struct fb_info *i
 	case PS3FB_IOCTL_SETMODE:
 		{
 			struct ps3fb_par *par = info->par;
-			const struct fb_videomode *mode;
+			const struct fb_videomode *vmode;
 			struct fb_var_screeninfo var;
 
 			if (copy_from_user(&val, argp, sizeof(val)))
@@ -780,10 +784,10 @@ static int ps3fb_ioctl(struct fb_info *i
 			}
 			dev_dbg(info->device, "PS3FB_IOCTL_SETMODE:%x\n", val);
 			retval = -EINVAL;
-			mode = ps3fb_default_mode(val);
-			if (mode) {
+			vmode = ps3fb_vmode(val);
+			if (vmode) {
 				var = info->var;
-				fb_videomode_to_var(&var, mode);
+				fb_videomode_to_var(&var, vmode);
 				acquire_console_sem();
 				info->flags |= FBINFO_MISC_USEREVENT;
 				/* Force, in case only special bits changed */
@@ -1141,7 +1145,7 @@ static int __devinit ps3fb_probe(struct 
 
 	if (!fb_find_mode(&info->var, info, mode_option, ps3fb_modedb,
 			  ARRAY_SIZE(ps3fb_modedb),
-			  ps3fb_default_mode(par->new_mode_id), 32)) {
+			  ps3fb_vmode(par->new_mode_id), 32)) {
 		retval = -EINVAL;
 		goto err_fb_dealloc;
 	}
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

git-powerpc.patch
git-kbuild.patch
git-x86.patch
ps3-checkpatch-drivers-ps3-ps3-sys-managerc.patch
ps3-checkpatch-drivers-ps3-ps3-vuartc.patch
ps3av-ps3av_get_scanmode-and-ps3av_get_refresh_rate-are-unused.patch
ps3-use-symbolic-names-for-video-modes.patch
ps3fb-kill-ps3fb_full_mode_bit.patch
ps3fb-inline-macros-that-are-used-only-once.patch
ps3fb-kill-ps3fb_res.patch
ps3fb-make-frame-buffer-offsets-unsigned-int.patch
ps3fb-add-support-for-configurable-black-borders.patch
ps3fb-reorganize-modedb-handling.patch
ps3fb-round-up-video-modes.patch
ps3fb-cleanup-sweep.patch
ps3fb-fix-modedb-typos.patch
