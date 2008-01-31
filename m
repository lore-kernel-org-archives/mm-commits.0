From: akpm@linux-foundation.org
Subject: + fbcon-fix-color-generation-for-monochrome-framebuffer.patch added to -mm tree
Date: Thu, 31 Jan 2008 14:19:08 -0800
Message-ID: <200801312219.m0VMJ8So014234@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60737 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760381AbYAaWUQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 Jan 2008 17:20:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tpfaff@pcs.com, adaplas@pol.net


The patch titled
     fbcon: fix color generation for monochrome framebuffer
has been added to the -mm tree.  Its filename is
     fbcon-fix-color-generation-for-monochrome-framebuffer.patch

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
Subject: fbcon: fix color generation for monochrome framebuffer
From: Thomas Pfaff <tpfaff@pcs.com>

The current attr_fgcol_ec / attr_bgcol_ec macros do a simple shift of bits
to get the color from vc_video_erase_char.  For a monochrome display
however the attribute does not contain any color, only attribute bits. 
Furthermore the reverse bit is lost because it is shifted out, the
resulting color is always 0.

This can bee seen on a monochrome console either directly or by setting it
to inverse mode via "setterm -inversescreen on" .  Text is written with
correct color, fb_fillrects from a bit_clear / bit_clear_margins will get
wrong colors.

Signed-off-by: Thomas Pfaff <tpfaff@pcs.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/bitblit.c   |    4 +-
 drivers/video/console/fbcon.c     |    5 --
 drivers/video/console/fbcon.h     |   47 +++++++++++++++++++++++++---
 drivers/video/console/fbcon_ccw.c |    4 +-
 drivers/video/console/fbcon_cw.c  |    4 +-
 drivers/video/console/fbcon_ud.c  |    4 +-
 drivers/video/console/tileblit.c  |    4 +-
 drivers/video/pmag-aa-fb.c        |    2 -
 8 files changed, 55 insertions(+), 19 deletions(-)

diff -puN drivers/video/console/bitblit.c~fbcon-fix-color-generation-for-monochrome-framebuffer drivers/video/console/bitblit.c
--- a/drivers/video/console/bitblit.c~fbcon-fix-color-generation-for-monochrome-framebuffer
+++ a/drivers/video/console/bitblit.c
@@ -63,7 +63,7 @@ static void bit_clear(struct vc_data *vc
 	int bgshift = (vc->vc_hi_font_mask) ? 13 : 12;
 	struct fb_fillrect region;
 
-	region.color = attr_bgcol_ec(bgshift, vc);
+	region.color = attr_bgcol_ec(bgshift, vc, info);
 	region.dx = sx * vc->vc_font.width;
 	region.dy = sy * vc->vc_font.height;
 	region.width = width * vc->vc_font.width;
@@ -213,7 +213,7 @@ static void bit_clear_margins(struct vc_
 	unsigned int bs = info->var.yres - bh;
 	struct fb_fillrect region;
 
-	region.color = attr_bgcol_ec(bgshift, vc);
+	region.color = attr_bgcol_ec(bgshift, vc, info);
 	region.rop = ROP_COPY;
 
 	if (rw && !bottom_only) {
diff -puN drivers/video/console/fbcon.c~fbcon-fix-color-generation-for-monochrome-framebuffer drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~fbcon-fix-color-generation-for-monochrome-framebuffer
+++ a/drivers/video/console/fbcon.c
@@ -334,10 +334,7 @@ static inline int get_color(struct vc_da
 	switch (depth) {
 	case 1:
 	{
-		int col = ~(0xfff << (max(info->var.green.length,
-					  max(info->var.red.length,
-					      info->var.blue.length)))) & 0xff;
-
+		int col = mono_col(info);
 		/* 0 or 1 */
 		int fg = (info->fix.visual != FB_VISUAL_MONO01) ? col : 0;
 		int bg = (info->fix.visual != FB_VISUAL_MONO01) ? 0 : col;
diff -puN drivers/video/console/fbcon.h~fbcon-fix-color-generation-for-monochrome-framebuffer drivers/video/console/fbcon.h
--- a/drivers/video/console/fbcon.h~fbcon-fix-color-generation-for-monochrome-framebuffer
+++ a/drivers/video/console/fbcon.h
@@ -93,10 +93,6 @@ struct fbcon_ops {
 	(((s) >> (fgshift)) & 0x0f)
 #define attr_bgcol(bgshift,s)    \
 	(((s) >> (bgshift)) & 0x0f)
-#define	attr_bgcol_ec(bgshift,vc) \
-	((vc) ? (((vc)->vc_video_erase_char >> (bgshift)) & 0x0f) : 0)
-#define attr_fgcol_ec(fgshift,vc) \
-	((vc) ? (((vc)->vc_video_erase_char >> (fgshift)) & 0x0f) : 0)
 
 /* Monochrome */
 #define attr_bold(s) \
@@ -108,6 +104,49 @@ struct fbcon_ops {
 #define attr_blink(s) \
 	((s) & 0x8000)
 	
+#define mono_col(info)							\
+	(~(0xfff << (max((info)->var.green.length,			\
+			 max((info)->var.red.length,			\
+			     (info)->var.blue.length)))) & 0xff)
+
+static inline int attr_col_ec(int shift, struct vc_data *vc,
+			      struct fb_info *info, int is_fg)
+{
+	int is_mono01;
+	int col;
+	int fg;
+	int bg;
+
+	if (!vc)
+		return 0;
+
+	if (vc->vc_can_do_color)
+		return is_fg ? attr_fgcol(shift,vc->vc_video_erase_char)
+			: attr_bgcol(shift,vc->vc_video_erase_char);
+
+	if (!info)
+		return 0;
+
+	col = mono_col(info);
+	is_mono01 = info->fix.visual == FB_VISUAL_MONO01;
+
+	if (attr_reverse(vc->vc_video_erase_char)) {
+		fg = is_mono01 ? col : 0;
+		bg = is_mono01 ? 0 : col;
+	}
+	else {
+		fg = is_mono01 ? 0 : col;
+		bg = is_mono01 ? col : 0;
+	}
+
+	return is_fg ? fg : bg;
+}
+
+#define attr_bgcol_ec(bgshift,vc,info)		\
+	attr_col_ec(bgshift,vc,info,0);
+#define attr_fgcol_ec(fgshift,vc,info)		\
+	attr_col_ec(fgshift,vc,info,1);
+
 /* Font */
 #define REFCOUNT(fd)	(((int *)(fd))[-1])
 #define FNTSIZE(fd)	(((int *)(fd))[-2])
diff -puN drivers/video/console/fbcon_ccw.c~fbcon-fix-color-generation-for-monochrome-framebuffer drivers/video/console/fbcon_ccw.c
--- a/drivers/video/console/fbcon_ccw.c~fbcon-fix-color-generation-for-monochrome-framebuffer
+++ a/drivers/video/console/fbcon_ccw.c
@@ -84,7 +84,7 @@ static void ccw_clear(struct vc_data *vc
 	int bgshift = (vc->vc_hi_font_mask) ? 13 : 12;
 	u32 vyres = GETVYRES(ops->p->scrollmode, info);
 
-	region.color = attr_bgcol_ec(bgshift,vc);
+	region.color = attr_bgcol_ec(bgshift,vc,info);
 	region.dx = sy * vc->vc_font.height;
 	region.dy = vyres - ((sx + width) * vc->vc_font.width);
 	region.height = width * vc->vc_font.width;
@@ -198,7 +198,7 @@ static void ccw_clear_margins(struct vc_
 	struct fb_fillrect region;
 	int bgshift = (vc->vc_hi_font_mask) ? 13 : 12;
 
-	region.color = attr_bgcol_ec(bgshift,vc);
+	region.color = attr_bgcol_ec(bgshift,vc,info);
 	region.rop = ROP_COPY;
 
 	if (rw && !bottom_only) {
diff -puN drivers/video/console/fbcon_cw.c~fbcon-fix-color-generation-for-monochrome-framebuffer drivers/video/console/fbcon_cw.c
--- a/drivers/video/console/fbcon_cw.c~fbcon-fix-color-generation-for-monochrome-framebuffer
+++ a/drivers/video/console/fbcon_cw.c
@@ -70,7 +70,7 @@ static void cw_clear(struct vc_data *vc,
 	int bgshift = (vc->vc_hi_font_mask) ? 13 : 12;
 	u32 vxres = GETVXRES(ops->p->scrollmode, info);
 
-	region.color = attr_bgcol_ec(bgshift,vc);
+	region.color = attr_bgcol_ec(bgshift,vc,info);
 	region.dx = vxres - ((sy + height) * vc->vc_font.height);
 	region.dy = sx *  vc->vc_font.width;
 	region.height = width * vc->vc_font.width;
@@ -182,7 +182,7 @@ static void cw_clear_margins(struct vc_d
 	struct fb_fillrect region;
 	int bgshift = (vc->vc_hi_font_mask) ? 13 : 12;
 
-	region.color = attr_bgcol_ec(bgshift,vc);
+	region.color = attr_bgcol_ec(bgshift,vc,info);
 	region.rop = ROP_COPY;
 
 	if (rw && !bottom_only) {
diff -puN drivers/video/console/fbcon_ud.c~fbcon-fix-color-generation-for-monochrome-framebuffer drivers/video/console/fbcon_ud.c
--- a/drivers/video/console/fbcon_ud.c~fbcon-fix-color-generation-for-monochrome-framebuffer
+++ a/drivers/video/console/fbcon_ud.c
@@ -71,7 +71,7 @@ static void ud_clear(struct vc_data *vc,
 	u32 vyres = GETVYRES(ops->p->scrollmode, info);
 	u32 vxres = GETVXRES(ops->p->scrollmode, info);
 
-	region.color = attr_bgcol_ec(bgshift,vc);
+	region.color = attr_bgcol_ec(bgshift,vc,info);
 	region.dy = vyres - ((sy + height) * vc->vc_font.height);
 	region.dx = vxres - ((sx + width) *  vc->vc_font.width);
 	region.width = width * vc->vc_font.width;
@@ -228,7 +228,7 @@ static void ud_clear_margins(struct vc_d
 	struct fb_fillrect region;
 	int bgshift = (vc->vc_hi_font_mask) ? 13 : 12;
 
-	region.color = attr_bgcol_ec(bgshift,vc);
+	region.color = attr_bgcol_ec(bgshift,vc,info);
 	region.rop = ROP_COPY;
 
 	if (rw && !bottom_only) {
diff -puN drivers/video/console/tileblit.c~fbcon-fix-color-generation-for-monochrome-framebuffer drivers/video/console/tileblit.c
--- a/drivers/video/console/tileblit.c~fbcon-fix-color-generation-for-monochrome-framebuffer
+++ a/drivers/video/console/tileblit.c
@@ -40,8 +40,8 @@ static void tile_clear(struct vc_data *v
 
 	rect.index = vc->vc_video_erase_char &
 		((vc->vc_hi_font_mask) ? 0x1ff : 0xff);
-	rect.fg = attr_fgcol_ec(fgshift, vc);
-	rect.bg = attr_bgcol_ec(bgshift, vc);
+	rect.fg = attr_fgcol_ec(fgshift, vc, info);
+	rect.bg = attr_bgcol_ec(bgshift, vc, info);
 	rect.sx = sx;
 	rect.sy = sy;
 	rect.width = width;
diff -puN drivers/video/pmag-aa-fb.c~fbcon-fix-color-generation-for-monochrome-framebuffer drivers/video/pmag-aa-fb.c
--- a/drivers/video/pmag-aa-fb.c~fbcon-fix-color-generation-for-monochrome-framebuffer
+++ a/drivers/video/pmag-aa-fb.c
@@ -150,7 +150,7 @@ static int aafbcon_set_font(struct displ
 {
 	struct aafb_info *info = (struct aafb_info *)disp->fb_info;
 	struct aafb_cursor *c = &info->cursor;
-	u8 fgc = ~attr_bgcol_ec(disp, disp->conp);
+	u8 fgc = ~attr_bgcol_ec(disp, disp->conp, &info->info);
 
 	if (width > 64 || height > 64 || width < 0 || height < 0)
 		return -EINVAL;
_

Patches currently in -mm which might be from tpfaff@pcs.com are

fbcon-fix-color-generation-for-monochrome-framebuffer.patch
