From: akpm@linux-foundation.org
Subject: - pm2fb-permedia-2v-hardware-cursor-support.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:42:59 -0700
Message-ID: <200710162042.l9GKgxd6015934@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46196 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965239AbXJPVNT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:13:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     pm2fb: Permedia 2V hardware cursor support
has been removed from the -mm tree.  Its filename was
     pm2fb-permedia-2v-hardware-cursor-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pm2fb: Permedia 2V hardware cursor support
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch adds hardware cursor support for Permedia 2V chips.
The hardware cursor is disabled by default. It does not blink - the
same issue is mentioned in the x11 driver.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pm2fb.c     |  137 ++++++++++++++++++++++++++++++++++++
 include/video/permedia2.h |    2 
 2 files changed, 139 insertions(+)

diff -puN drivers/video/pm2fb.c~pm2fb-permedia-2v-hardware-cursor-support drivers/video/pm2fb.c
--- a/drivers/video/pm2fb.c~pm2fb-permedia-2v-hardware-cursor-support
+++ a/drivers/video/pm2fb.c
@@ -66,6 +66,7 @@
 /*
  * Driver data
  */
+static int hwcursor;
 static char *mode __devinitdata;
 
 /*
@@ -1245,6 +1246,136 @@ static void pm2fb_imageblit(struct fb_in
 	pm2_WR(par, PM2R_SCISSOR_MODE, 0);
 }
 
+/*
+ *	Hardware cursor support.
+ */
+static const u8 cursor_bits_lookup[16] = {
+	0x00, 0x40, 0x10, 0x50, 0x04, 0x44, 0x14, 0x54,
+	0x01, 0x41, 0x11, 0x51, 0x05, 0x45, 0x15, 0x55
+};
+
+static int pm2vfb_cursor(struct fb_info *info, struct fb_cursor *cursor)
+{
+	struct pm2fb_par *par = info->par;
+	u8 mode;
+
+	if (!hwcursor)
+		return -EINVAL;	/* just to force soft_cursor() call */
+
+	/* Too large of a cursor or wrong bpp :-( */
+	if (cursor->image.width > 64 ||
+	    cursor->image.height > 64 ||
+	    cursor->image.depth > 1)
+		return -EINVAL;
+
+	mode = PM2F_CURSORMODE_TYPE_X;
+	if (cursor->enable)
+		mode |= PM2F_CURSORMODE_CURSOR_ENABLE;
+
+	pm2v_RDAC_WR(par, PM2VI_RD_CURSOR_MODE, mode);
+
+	/*
+	 * If the cursor is not be changed this means either we want the
+	 * current cursor state (if enable is set) or we want to query what
+	 * we can do with the cursor (if enable is not set)
+	 */
+	if (!cursor->set)
+		return 0;
+
+	if (cursor->set & FB_CUR_SETPOS) {
+		int x = cursor->image.dx - info->var.xoffset;
+		int y = cursor->image.dy - info->var.yoffset;
+
+		pm2v_RDAC_WR(par, PM2VI_RD_CURSOR_X_LOW, x & 0xff);
+		pm2v_RDAC_WR(par, PM2VI_RD_CURSOR_X_HIGH, (x >> 8) & 0xf);
+		pm2v_RDAC_WR(par, PM2VI_RD_CURSOR_Y_LOW, y & 0xff);
+		pm2v_RDAC_WR(par, PM2VI_RD_CURSOR_Y_HIGH, (y >> 8) & 0xf);
+	}
+
+	if (cursor->set & FB_CUR_SETHOT) {
+		pm2v_RDAC_WR(par, PM2VI_RD_CURSOR_X_HOT,
+			     cursor->hot.x & 0x3f);
+		pm2v_RDAC_WR(par, PM2VI_RD_CURSOR_Y_HOT,
+			     cursor->hot.y & 0x3f);
+	}
+
+	if (cursor->set & FB_CUR_SETCMAP) {
+		u32 fg_idx = cursor->image.fg_color;
+		u32 bg_idx = cursor->image.bg_color;
+		struct fb_cmap cmap = info->cmap;
+
+		/* the X11 driver says one should use these color registers */
+		pm2_WR(par, PM2VR_RD_INDEX_HIGH, PM2VI_RD_CURSOR_PALETTE >> 8);
+		pm2v_RDAC_WR(par, PM2VI_RD_CURSOR_PALETTE + 0,
+			     cmap.red[bg_idx] >> 8 );
+		pm2v_RDAC_WR(par, PM2VI_RD_CURSOR_PALETTE + 1,
+			     cmap.green[bg_idx] >> 8 );
+		pm2v_RDAC_WR(par, PM2VI_RD_CURSOR_PALETTE + 2,
+			     cmap.blue[bg_idx] >> 8 );
+
+		pm2v_RDAC_WR(par, PM2VI_RD_CURSOR_PALETTE + 3,
+			     cmap.red[fg_idx] >> 8 );
+		pm2v_RDAC_WR(par, PM2VI_RD_CURSOR_PALETTE + 4,
+			     cmap.green[fg_idx] >> 8 );
+		pm2v_RDAC_WR(par, PM2VI_RD_CURSOR_PALETTE + 5,
+			     cmap.blue[fg_idx] >> 8 );
+		pm2_WR(par, PM2VR_RD_INDEX_HIGH, 0);
+	}
+
+	if (cursor->set & (FB_CUR_SETSHAPE | FB_CUR_SETIMAGE)) {
+		u8 *bitmap = (u8 *)cursor->image.data;
+		u8 *mask = (u8 *)cursor->mask;
+		int i;
+		int pos = PM2VI_RD_CURSOR_PATTERN;
+
+		for (i = 0; i < cursor->image.height; i++) {
+			int j = (cursor->image.width + 7) >> 3;
+			int k = 8 - j;
+
+			pm2_WR(par, PM2VR_RD_INDEX_HIGH, pos >> 8);
+
+			for (; j > 0; j--) {
+				u8 data = *bitmap ^ *mask;
+
+				if (cursor->rop == ROP_COPY)
+					data = *mask & *bitmap;
+				/* Upper 4 bits of bitmap data */
+				pm2v_RDAC_WR(par, pos++,
+					cursor_bits_lookup[data >> 4] |
+					(cursor_bits_lookup[*mask >> 4] << 1));
+				/* Lower 4 bits of bitmap */
+				pm2v_RDAC_WR(par, pos++,
+					cursor_bits_lookup[data & 0xf] |
+					(cursor_bits_lookup[*mask & 0xf] << 1));
+				bitmap++;
+				mask++;
+			}
+			for (; k > 0; k--) {
+				pm2v_RDAC_WR(par, pos++, 0);
+				pm2v_RDAC_WR(par, pos++, 0);
+			}
+		}
+
+		while (pos < (1024 + PM2VI_RD_CURSOR_PATTERN)) {
+			pm2_WR(par, PM2VR_RD_INDEX_HIGH, pos >> 8);
+			pm2v_RDAC_WR(par, pos++, 0);
+		}
+
+		pm2_WR(par, PM2VR_RD_INDEX_HIGH, 0);
+	}
+	return 0;
+}
+
+static int pm2fb_cursor(struct fb_info *info, struct fb_cursor *cursor)
+{
+	struct pm2fb_par *par = info->par;
+
+	if (par->type == PM2_TYPE_PERMEDIA2V)
+		return pm2vfb_cursor(info, cursor);
+
+	return -ENXIO;
+}
+
 /* ------------ Hardware Independent Functions ------------ */
 
 /*
@@ -1262,6 +1393,7 @@ static struct fb_ops pm2fb_ops = {
 	.fb_copyarea	= pm2fb_copyarea,
 	.fb_imageblit	= pm2fb_imageblit,
 	.fb_sync	= pm2fb_sync,
+	.fb_cursor	= pm2fb_cursor,
 };
 
 /*
@@ -1550,6 +1682,8 @@ static int __init pm2fb_setup(char *opti
 			lowhsync = 1;
 		else if (!strcmp(this_opt, "lowvsync"))
 			lowvsync = 1;
+		else if (!strncmp(this_opt, "hwcursor=", 9))
+			hwcursor = simple_strtoul(this_opt + 9, NULL, 0);
 #ifdef CONFIG_MTRR
 		else if (!strncmp(this_opt, "nomtrr", 6))
 			nomtrr = 1;
@@ -1601,6 +1735,9 @@ module_param(lowvsync, bool, 0);
 MODULE_PARM_DESC(lowvsync, "Force vertical sync low regardless of mode");
 module_param(noaccel, bool, 0);
 MODULE_PARM_DESC(noaccel, "Disable acceleration");
+module_param(hwcursor, int, 0644);
+MODULE_PARM_DESC(hwcursor, "Enable hardware cursor "
+			"(1=enable, 0=disable, default=0)");
 #ifdef CONFIG_MTRR
 module_param(nomtrr, bool, 0);
 MODULE_PARM_DESC(nomtrr, "Disable MTRR support (0 or 1=disabled) (default=0)");
diff -puN include/video/permedia2.h~pm2fb-permedia-2v-hardware-cursor-support include/video/permedia2.h
--- a/include/video/permedia2.h~pm2fb-permedia-2v-hardware-cursor-support
+++ a/include/video/permedia2.h
@@ -232,6 +232,8 @@
 #define PM2F_APERTURE_STANDARD				0
 #define PM2F_APERTURE_BYTESWAP				1
 #define PM2F_APERTURE_HALFWORDSWAP			2
+#define PM2F_CURSORMODE_CURSOR_ENABLE			(1 << 0)
+#define PM2F_CURSORMODE_TYPE_X				(1 << 4)
 
 typedef enum {
 	PM2_TYPE_PERMEDIA2,
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
git-alsa.patch
cyber2000fb-checkpatch-fixes.patch
