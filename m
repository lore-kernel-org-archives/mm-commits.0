From: akpm@linux-foundation.org
Subject: + ps3-use-symbolic-names-for-video-modes.patch added to -mm tree
Date: Sat, 26 Jan 2008 21:14:24 -0800
Message-ID: <200801270514.m0R5EL9q030975@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54348 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750828AbYA0FOp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jan 2008 00:14:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com, adaplas@pol.net


The patch titled
     ps3: use symbolic names for video modes
has been added to the -mm tree.  Its filename is
     ps3-use-symbolic-names-for-video-modes.patch

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
Subject: ps3: use symbolic names for video modes
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Use symbolic names for video modes

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ps3/ps3av.c         |   39 ++++++++++++++++----------------
 drivers/video/ps3fb.c       |   17 ++++++++------
 include/asm-powerpc/ps3av.h |   41 ++++++++++++++++++++++++----------
 3 files changed, 60 insertions(+), 37 deletions(-)

diff -puN drivers/ps3/ps3av.c~ps3-use-symbolic-names-for-video-modes drivers/ps3/ps3av.c
--- a/drivers/ps3/ps3av.c~ps3-use-symbolic-names-for-video-modes
+++ a/drivers/ps3/ps3av.c
@@ -542,7 +542,7 @@ static void ps3av_set_videomode_packet(u
 
 static void ps3av_set_videomode_cont(u32 id, u32 old_id)
 {
-	static int vesa = 0;
+	static int vesa;
 	int res;
 
 	/* video signal off */
@@ -552,9 +552,9 @@ static void ps3av_set_videomode_cont(u32
 	 * AV backend needs non-VESA mode setting at least one time
 	 * when VESA mode is used.
 	 */
-	if (vesa == 0 && (id & PS3AV_MODE_MASK) >= 11) {
+	if (vesa == 0 && (id & PS3AV_MODE_MASK) >= PS3AV_MODE_WXGA) {
 		/* vesa mode */
-		ps3av_set_videomode_packet(2);	/* 480P */
+		ps3av_set_videomode_packet(PS3AV_MODE_480P);
 	}
 	vesa = 1;
 
@@ -594,20 +594,21 @@ static const struct {
 	unsigned mask : 19;
 	unsigned id :  4;
 } ps3av_preferred_modes[] = {
-	{ .mask = PS3AV_RESBIT_WUXGA		<< SHIFT_VESA,	.id = 13 },
-	{ .mask = PS3AV_RESBIT_1920x1080P	<< SHIFT_60,	.id = 5 },
-	{ .mask = PS3AV_RESBIT_1920x1080P	<< SHIFT_50,	.id = 10 },
-	{ .mask = PS3AV_RESBIT_1920x1080I	<< SHIFT_60,	.id = 4 },
-	{ .mask = PS3AV_RESBIT_1920x1080I	<< SHIFT_50,	.id = 9 },
-	{ .mask = PS3AV_RESBIT_SXGA		<< SHIFT_VESA,	.id = 12 },
-	{ .mask = PS3AV_RESBIT_WXGA		<< SHIFT_VESA,	.id = 11 },
-	{ .mask = PS3AV_RESBIT_1280x720P	<< SHIFT_60,	.id = 3 },
-	{ .mask = PS3AV_RESBIT_1280x720P	<< SHIFT_50,	.id = 8 },
-	{ .mask = PS3AV_RESBIT_720x480P		<< SHIFT_60,	.id = 2 },
-	{ .mask = PS3AV_RESBIT_720x576P		<< SHIFT_50,	.id = 7 },
+	{ PS3AV_RESBIT_WUXGA      << SHIFT_VESA, PS3AV_MODE_WUXGA   },
+	{ PS3AV_RESBIT_1920x1080P << SHIFT_60,   PS3AV_MODE_1080P60 },
+	{ PS3AV_RESBIT_1920x1080P << SHIFT_50,   PS3AV_MODE_1080P50 },
+	{ PS3AV_RESBIT_1920x1080I << SHIFT_60,   PS3AV_MODE_1080I60 },
+	{ PS3AV_RESBIT_1920x1080I << SHIFT_50,   PS3AV_MODE_1080I50 },
+	{ PS3AV_RESBIT_SXGA       << SHIFT_VESA, PS3AV_MODE_SXGA    },
+	{ PS3AV_RESBIT_WXGA       << SHIFT_VESA, PS3AV_MODE_WXGA    },
+	{ PS3AV_RESBIT_1280x720P  << SHIFT_60,   PS3AV_MODE_720P60  },
+	{ PS3AV_RESBIT_1280x720P  << SHIFT_50,   PS3AV_MODE_720P50  },
+	{ PS3AV_RESBIT_720x480P   << SHIFT_60,   PS3AV_MODE_480P    },
+	{ PS3AV_RESBIT_720x576P   << SHIFT_50,   PS3AV_MODE_576P    },
 };
 
-static int ps3av_resbit2id(u32 res_50, u32 res_60, u32 res_vesa)
+static enum ps3av_mode_num ps3av_resbit2id(u32 res_50, u32 res_60,
+					   u32 res_vesa)
 {
 	unsigned int i;
 	u32 res_all;
@@ -636,9 +637,9 @@ static int ps3av_resbit2id(u32 res_50, u
 	return 0;
 }
 
-static int ps3av_hdmi_get_id(struct ps3av_info_monitor *info)
+static enum ps3av_mode_num ps3av_hdmi_get_id(struct ps3av_info_monitor *info)
 {
-	int id;
+	enum ps3av_mode_num id;
 
 	if (safe_mode)
 		return PS3AV_DEFAULT_HDMI_MODE_ID_REG_60;
@@ -852,7 +853,7 @@ int ps3av_set_video_mode(u32 id)
 
 	/* auto mode */
 	option = id & ~PS3AV_MODE_MASK;
-	if ((id & PS3AV_MODE_MASK) == 0) {
+	if ((id & PS3AV_MODE_MASK) == PS3AV_MODE_AUTO) {
 		id = ps3av_auto_videomode(&ps3av->av_hw_conf);
 		if (id < 1) {
 			printk(KERN_ERR "%s: invalid id :%d\n", __func__, id);
@@ -958,7 +959,7 @@ static int ps3av_probe(struct ps3_system
 		return -ENOMEM;
 
 	mutex_init(&ps3av->mutex);
-	ps3av->ps3av_mode = 0;
+	ps3av->ps3av_mode = PS3AV_MODE_AUTO;
 	ps3av->dev = dev;
 
 	INIT_WORK(&ps3av->work, ps3avd);
diff -puN drivers/video/ps3fb.c~ps3-use-symbolic-names-for-video-modes drivers/video/ps3fb.c
--- a/drivers/video/ps3fb.c~ps3-use-symbolic-names-for-video-modes
+++ a/drivers/video/ps3fb.c
@@ -338,7 +338,7 @@ static int ps3fb_get_res_table(u32 xres,
 static unsigned int ps3fb_find_mode(const struct fb_var_screeninfo *var,
 				    u32 *ddr_line_length, u32 *xdr_line_length)
 {
-	unsigned int i, mode;
+	unsigned int i, fi, mode;
 
 	for (i = 0; i < ARRAY_SIZE(ps3fb_modedb); i++)
 		if (var->xres == ps3fb_modedb[i].xres &&
@@ -359,7 +359,8 @@ static unsigned int ps3fb_find_mode(cons
 
 found:
 	/* Cropped broadcast modes use the full line length */
-	*ddr_line_length = ps3fb_modedb[i < 10 ? i + 13 : i].xres * BPP;
+	fi = i < PS3AV_MODE_1080P50 ? i + PS3AV_MODE_WUXGA : i;
+	*ddr_line_length = ps3fb_modedb[fi].xres * BPP;
 
 	if (ps3_compare_firmware_version(1, 9, 0) >= 0) {
 		*xdr_line_length = GPU_ALIGN_UP(max(var->xres,
@@ -370,7 +371,9 @@ found:
 		*xdr_line_length = *ddr_line_length;
 
 	/* Full broadcast modes have the full mode bit set */
-	mode = i > 12 ? (i - 12) | PS3FB_FULL_MODE_BIT : i + 1;
+	mode = i+1;
+	if (mode > PS3AV_MODE_WUXGA)
+		mode = (mode - PS3AV_MODE_WUXGA) | PS3FB_FULL_MODE_BIT;
 
 	pr_debug("ps3fb_find_mode: mode %u\n", mode);
 
@@ -382,14 +385,14 @@ static const struct fb_videomode *ps3fb_
 	u32 mode = id & PS3AV_MODE_MASK;
 	u32 flags;
 
-	if (mode < 1 || mode > 13)
+	if (mode < PS3AV_MODE_480I || mode > PS3AV_MODE_WUXGA)
 		return NULL;
 
 	flags = id & ~PS3AV_MODE_MASK;
 
-	if (mode <= 10 && flags & PS3FB_FULL_MODE_BIT) {
+	if (mode <= PS3AV_MODE_1080P50 && flags & PS3FB_FULL_MODE_BIT) {
 		/* Full broadcast mode */
-		return &ps3fb_modedb[mode + 12];
+		return &ps3fb_modedb[mode + PS3AV_MODE_WUXGA - 1];
 	}
 
 	return &ps3fb_modedb[mode - 1];
@@ -1080,7 +1083,7 @@ static int __devinit ps3fb_probe(struct 
 
 	if (!ps3fb_mode)
 		ps3fb_mode = ps3av_get_mode();
-	dev_dbg(&dev->core, "ps3av_mode:%d\n", ps3fb_mode);
+	dev_dbg(&dev->core, "ps3fb_mode: %d\n", ps3fb_mode);
 
 	if (ps3fb_mode > 0 &&
 	    !ps3av_video_mode2res(ps3fb_mode, &xres, &yres)) {
diff -puN include/asm-powerpc/ps3av.h~ps3-use-symbolic-names-for-video-modes include/asm-powerpc/ps3av.h
--- a/include/asm-powerpc/ps3av.h~ps3-use-symbolic-names-for-video-modes
+++ a/include/asm-powerpc/ps3av.h
@@ -310,19 +310,25 @@
 #define PS3AV_MONITOR_TYPE_HDMI			1	/* HDMI */
 #define PS3AV_MONITOR_TYPE_DVI			2	/* DVI */
 
-#define PS3AV_DEFAULT_HDMI_MODE_ID_REG_60	2	/* 480p */
-#define PS3AV_DEFAULT_AVMULTI_MODE_ID_REG_60	1	/* 480i */
-#define PS3AV_DEFAULT_HDMI_MODE_ID_REG_50	7	/* 576p */
-#define PS3AV_DEFAULT_AVMULTI_MODE_ID_REG_50	6	/* 576i */
-
-#define PS3AV_REGION_60				0x01
-#define PS3AV_REGION_50				0x02
-#define PS3AV_REGION_RGB			0x10
-
-#define get_status(buf)				(((__u32 *)buf)[2])
-#define PS3AV_HDR_SIZE				4	/* version + size */
 
 /* for video mode */
+enum ps3av_mode_num {
+	PS3AV_MODE_AUTO				= 0,
+	PS3AV_MODE_480I				= 1,
+	PS3AV_MODE_480P				= 2,
+	PS3AV_MODE_720P60			= 3,
+	PS3AV_MODE_1080I60			= 4,
+	PS3AV_MODE_1080P60			= 5,
+	PS3AV_MODE_576I				= 6,
+	PS3AV_MODE_576P				= 7,
+	PS3AV_MODE_720P50			= 8,
+	PS3AV_MODE_1080I50			= 9,
+	PS3AV_MODE_1080P50			= 10,
+	PS3AV_MODE_WXGA				= 11,
+	PS3AV_MODE_SXGA				= 12,
+	PS3AV_MODE_WUXGA			= 13,
+};
+
 #define PS3AV_MODE_MASK				0x000F
 #define PS3AV_MODE_HDCP_OFF			0x1000	/* Retail PS3 product doesn't support this */
 #define PS3AV_MODE_DITHER			0x0800
@@ -333,6 +339,19 @@
 #define PS3AV_MODE_RGB				0x0020
 
 
+#define PS3AV_DEFAULT_HDMI_MODE_ID_REG_60	PS3AV_MODE_480P
+#define PS3AV_DEFAULT_AVMULTI_MODE_ID_REG_60	PS3AV_MODE_480I
+#define PS3AV_DEFAULT_HDMI_MODE_ID_REG_50	PS3AV_MODE_576P
+#define PS3AV_DEFAULT_AVMULTI_MODE_ID_REG_50	PS3AV_MODE_576I
+
+#define PS3AV_REGION_60				0x01
+#define PS3AV_REGION_50				0x02
+#define PS3AV_REGION_RGB			0x10
+
+#define get_status(buf)				(((__u32 *)buf)[2])
+#define PS3AV_HDR_SIZE				4	/* version + size */
+
+
 /** command packet structure **/
 struct ps3av_send_hdr {
 	u16 version;
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
