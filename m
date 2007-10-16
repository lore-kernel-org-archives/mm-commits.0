From: akpm@linux-foundation.org
Subject: - pm2fb-hardware-cursor-support-for-the-permedia2.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:44:03 -0700
Message-ID: <200710162044.l9GKi3A7016109@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55143 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935526AbXJPVLZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:11:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     pm2fb: hardware cursor support for the Permedia2
has been removed from the -mm tree.  Its filename was
     pm2fb-hardware-cursor-support-for-the-permedia2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pm2fb: hardware cursor support for the Permedia2
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch adds hardware cursor support for the Permedia 2 chip.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pm2fb.c     |  125 ++++++++++++++++++++++++++++++++----
 include/video/permedia2.h |    7 ++
 2 files changed, 120 insertions(+), 12 deletions(-)

diff -puN drivers/video/pm2fb.c~pm2fb-hardware-cursor-support-for-the-permedia2 drivers/video/pm2fb.c
--- a/drivers/video/pm2fb.c~pm2fb-hardware-cursor-support-for-the-permedia2
+++ a/drivers/video/pm2fb.c
@@ -1257,18 +1257,8 @@ static const u8 cursor_bits_lookup[16] =
 static int pm2vfb_cursor(struct fb_info *info, struct fb_cursor *cursor)
 {
 	struct pm2fb_par *par = info->par;
-	u8 mode;
-
-	if (!hwcursor)
-		return -EINVAL;	/* just to force soft_cursor() call */
-
-	/* Too large of a cursor or wrong bpp :-( */
-	if (cursor->image.width > 64 ||
-	    cursor->image.height > 64 ||
-	    cursor->image.depth > 1)
-		return -EINVAL;
+	u8 mode = PM2F_CURSORMODE_TYPE_X;
 
-	mode = PM2F_CURSORMODE_TYPE_X;
 	if (cursor->enable)
 		mode |= PM2F_CURSORMODE_CURSOR_ENABLE;
 
@@ -1369,11 +1359,122 @@ static int pm2vfb_cursor(struct fb_info 
 static int pm2fb_cursor(struct fb_info *info, struct fb_cursor *cursor)
 {
 	struct pm2fb_par *par = info->par;
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
 
 	if (par->type == PM2_TYPE_PERMEDIA2V)
 		return pm2vfb_cursor(info, cursor);
 
-	return -ENXIO;
+	mode = 0;
+	if (cursor->enable)
+		 mode = 0x43;
+
+	pm2_RDAC_WR(par, PM2I_RD_CURSOR_CONTROL, mode);
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
+		int x, y;
+
+		x = cursor->image.dx + 63;
+		y = cursor->image.dy + 63;
+		WAIT_FIFO(par, 4);
+		pm2_WR(par, PM2R_RD_CURSOR_X_LSB, x & 0xff);
+		pm2_WR(par, PM2R_RD_CURSOR_X_MSB, (x >> 8) & 0x7);
+		pm2_WR(par, PM2R_RD_CURSOR_Y_LSB, y & 0xff);
+		pm2_WR(par, PM2R_RD_CURSOR_Y_MSB, (y >> 8) & 0x7);
+	}
+
+	if (cursor->set & FB_CUR_SETCMAP) {
+		u32 fg_idx = cursor->image.fg_color;
+		u32 bg_idx = cursor->image.bg_color;
+
+		WAIT_FIFO(par, 7);
+		pm2_WR(par, PM2R_RD_CURSOR_COLOR_ADDRESS, 1);
+		pm2_WR(par, PM2R_RD_CURSOR_COLOR_DATA,
+			info->cmap.red[bg_idx] >> 8);
+		pm2_WR(par, PM2R_RD_CURSOR_COLOR_DATA,
+			info->cmap.green[bg_idx] >> 8);
+		pm2_WR(par, PM2R_RD_CURSOR_COLOR_DATA,
+			info->cmap.blue[bg_idx] >> 8);
+
+		pm2_WR(par, PM2R_RD_CURSOR_COLOR_DATA,
+			info->cmap.red[fg_idx] >> 8);
+		pm2_WR(par, PM2R_RD_CURSOR_COLOR_DATA,
+			info->cmap.green[fg_idx] >> 8);
+		pm2_WR(par, PM2R_RD_CURSOR_COLOR_DATA,
+			info->cmap.blue[fg_idx] >> 8);
+	}
+
+	if (cursor->set & (FB_CUR_SETSHAPE | FB_CUR_SETIMAGE)) {
+		u8 *bitmap = (u8 *)cursor->image.data;
+		u8 *mask = (u8 *)cursor->mask;
+		int i;
+
+		WAIT_FIFO(par, 1);
+		pm2_WR(par, PM2R_RD_PALETTE_WRITE_ADDRESS, 0);
+
+		for (i = 0; i < cursor->image.height; i++) {
+			int j = (cursor->image.width + 7) >> 3;
+			int k = 8 - j;
+
+			WAIT_FIFO(par, 8);
+			for (; j > 0; j--) {
+				u8 data = *bitmap ^ *mask;
+
+				if (cursor->rop == ROP_COPY)
+					data = *mask & *bitmap;
+				/* bitmap data */
+				pm2_WR(par, PM2R_RD_CURSOR_DATA, data);
+				bitmap++;
+				mask++;
+			}
+			for (; k > 0; k--)
+				pm2_WR(par, PM2R_RD_CURSOR_DATA, 0);
+		}
+		for (; i < 64; i++) {
+			int j = 8;
+			WAIT_FIFO(par, 8);
+			while (j-- > 0)
+				pm2_WR(par, PM2R_RD_CURSOR_DATA, 0);
+		}
+
+		mask = (u8 *)cursor->mask;
+		for (i = 0; i < cursor->image.height; i++) {
+			int j = (cursor->image.width + 7) >> 3;
+			int k = 8 - j;
+
+			WAIT_FIFO(par, 8);
+			for (; j > 0; j--) {
+				/* mask */
+				pm2_WR(par, PM2R_RD_CURSOR_DATA, *mask);
+				mask++;
+			}
+			for (; k > 0; k--)
+				pm2_WR(par, PM2R_RD_CURSOR_DATA, 0);
+		}
+		for (; i < 64; i++) {
+			int j = 8;
+			WAIT_FIFO(par, 8);
+			while (j-- > 0)
+				pm2_WR(par, PM2R_RD_CURSOR_DATA, 0);
+		}
+	}
+	return 0;
 }
 
 /* ------------ Hardware Independent Functions ------------ */
diff -puN include/video/permedia2.h~pm2fb-hardware-cursor-support-for-the-permedia2 include/video/permedia2.h
--- a/include/video/permedia2.h~pm2fb-hardware-cursor-support-for-the-permedia2
+++ a/include/video/permedia2.h
@@ -58,7 +58,14 @@
 #define PM2R_RD_PALETTE_DATA				0x4008
 #define PM2R_RD_PIXEL_MASK				0x4010
 #define PM2R_RD_PALETTE_READ_ADDRESS			0x4018
+#define PM2R_RD_CURSOR_COLOR_ADDRESS		        0x4020
+#define PM2R_RD_CURSOR_COLOR_DATA		        0x4028
 #define PM2R_RD_INDEXED_DATA				0x4050
+#define PM2R_RD_CURSOR_DATA				0x4058
+#define PM2R_RD_CURSOR_X_LSB				0x4060
+#define PM2R_RD_CURSOR_X_MSB				0x4068
+#define PM2R_RD_CURSOR_Y_LSB				0x4070
+#define PM2R_RD_CURSOR_Y_MSB				0x4078
 
 #define PM2R_START_X_DOM				0x8000
 #define PM2R_D_X_DOM					0x8008
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
git-alsa.patch
cyber2000fb-checkpatch-fixes.patch
