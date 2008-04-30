From: akpm@linux-foundation.org
Subject: - vt-fix-background-color-on-line-feed.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:41:41 -0700
Message-ID: <200804300541.m3U5ff3t029071@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39917 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757177AbYD3FmY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:42:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@computergmbh.de, adaplas@pol.net, alan@lxorguk.ukuu.org.uk, hpa@zytor.com, mm-commits@vger.kernel.org


The patch titled
     vt: fix background color on line feed
has been removed from the -mm tree.  Its filename was
     vt-fix-background-color-on-line-feed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vt: fix background color on line feed
From: Jan Engelhardt <jengelh@computergmbh.de>

A command that causes a line feed while a background color is active,
such as

	perl -e 'print "x" x 60, "\e[44m", "x" x 40, "\e[0m\n"'
and
	perl -e 'print "x" x 40, "\e[44m\n", "x" x 40, "\e[0m\n"'

causes the line that was started as a result of the line feed to be completely
filled with the currently active background color instead of the default
color.

When scrolling, part of the current screen is memcpy'd/memmove'd to the new
region, and the new line(s) that will appear as a result are cleared using
memset.  However, the lines are cleared with vc->vc_video_erase_char, causing
them to be colored with the currently active background color.  This is
different from X11 terminal emulators which always paint the new lines with
the default background color (e.g.  `xterm -bg black`).

The clear operation (\e[1J and \e[2J) also use vc_video_erase_char, so a new
vc->vc_scrl_erase_char is introduced with contains the erase character used
for scrolling, which is built from vc->vc_def_color instead of vc->vc_color.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt.c              |    7 ++++---
 drivers/video/console/fbcon.c  |    8 ++++----
 drivers/video/console/mdacon.c |    2 +-
 drivers/video/console/sticon.c |    4 ++--
 drivers/video/console/vgacon.c |    4 ++--
 include/linux/console_struct.h |    1 +
 6 files changed, 14 insertions(+), 12 deletions(-)

diff -puN drivers/char/vt.c~vt-fix-background-color-on-line-feed drivers/char/vt.c
--- a/drivers/char/vt.c~vt-fix-background-color-on-line-feed
+++ a/drivers/char/vt.c
@@ -301,7 +301,7 @@ static void scrup(struct vc_data *vc, un
 	d = (unsigned short *)(vc->vc_origin + vc->vc_size_row * t);
 	s = (unsigned short *)(vc->vc_origin + vc->vc_size_row * (t + nr));
 	scr_memmovew(d, s, (b - t - nr) * vc->vc_size_row);
-	scr_memsetw(d + (b - t - nr) * vc->vc_cols, vc->vc_video_erase_char,
+	scr_memsetw(d + (b - t - nr) * vc->vc_cols, vc->vc_scrl_erase_char,
 		    vc->vc_size_row * nr);
 }
 
@@ -319,7 +319,7 @@ static void scrdown(struct vc_data *vc, 
 	s = (unsigned short *)(vc->vc_origin + vc->vc_size_row * t);
 	step = vc->vc_cols * nr;
 	scr_memmovew(s + step, s, (b - t - nr) * vc->vc_size_row);
-	scr_memsetw(s, vc->vc_video_erase_char, 2 * step);
+	scr_memsetw(s, vc->vc_scrl_erase_char, 2 * step);
 }
 
 static void do_update_region(struct vc_data *vc, unsigned long start, int count)
@@ -400,7 +400,7 @@ static u8 build_attr(struct vc_data *vc,
  *  Bit 7   : blink
  */
 	{
-	u8 a = vc->vc_color;
+	u8 a = _color;
 	if (!vc->vc_can_do_color)
 		return _intensity |
 		       (_italic ? 2 : 0) |
@@ -434,6 +434,7 @@ static void update_attr(struct vc_data *
 	              vc->vc_blink, vc->vc_underline,
 	              vc->vc_reverse ^ vc->vc_decscnm, vc->vc_italic);
 	vc->vc_video_erase_char = (build_attr(vc, vc->vc_color, 1, vc->vc_blink, 0, vc->vc_decscnm, 0) << 8) | ' ';
+	vc->vc_scrl_erase_char = (build_attr(vc, vc->vc_def_color, 1, false, false, false, false) << 8) | ' ';
 }
 
 /* Note: inverting the screen twice should revert to the original state */
diff -puN drivers/video/console/fbcon.c~vt-fix-background-color-on-line-feed drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~vt-fix-background-color-on-line-feed
+++ a/drivers/video/console/fbcon.c
@@ -1881,7 +1881,7 @@ static int fbcon_scroll(struct vc_data *
 			scr_memsetw((unsigned short *) (vc->vc_origin +
 							vc->vc_size_row *
 							(b - count)),
-				    vc->vc_video_erase_char,
+				    vc->vc_scrl_erase_char,
 				    vc->vc_size_row * count);
 			return 1;
 			break;
@@ -1953,7 +1953,7 @@ static int fbcon_scroll(struct vc_data *
 			scr_memsetw((unsigned short *) (vc->vc_origin +
 							vc->vc_size_row *
 							(b - count)),
-				    vc->vc_video_erase_char,
+				    vc->vc_scrl_erase_char,
 				    vc->vc_size_row * count);
 			return 1;
 		}
@@ -1972,7 +1972,7 @@ static int fbcon_scroll(struct vc_data *
 			scr_memsetw((unsigned short *) (vc->vc_origin +
 							vc->vc_size_row *
 							t),
-				    vc->vc_video_erase_char,
+				    vc->vc_scrl_erase_char,
 				    vc->vc_size_row * count);
 			return 1;
 			break;
@@ -2042,7 +2042,7 @@ static int fbcon_scroll(struct vc_data *
 			scr_memsetw((unsigned short *) (vc->vc_origin +
 							vc->vc_size_row *
 							t),
-				    vc->vc_video_erase_char,
+				    vc->vc_scrl_erase_char,
 				    vc->vc_size_row * count);
 			return 1;
 		}
diff -puN drivers/video/console/mdacon.c~vt-fix-background-color-on-line-feed drivers/video/console/mdacon.c
--- a/drivers/video/console/mdacon.c~vt-fix-background-color-on-line-feed
+++ a/drivers/video/console/mdacon.c
@@ -531,7 +531,7 @@ static void mdacon_cursor(struct vc_data
 
 static int mdacon_scroll(struct vc_data *c, int t, int b, int dir, int lines)
 {
-	u16 eattr = mda_convert_attr(c->vc_video_erase_char);
+	u16 eattr = mda_convert_attr(c->vc_scrl_erase_char);
 
 	if (!lines)
 		return 0;
diff -puN drivers/video/console/sticon.c~vt-fix-background-color-on-line-feed drivers/video/console/sticon.c
--- a/drivers/video/console/sticon.c~vt-fix-background-color-on-line-feed
+++ a/drivers/video/console/sticon.c
@@ -170,12 +170,12 @@ static int sticon_scroll(struct vc_data 
     switch (dir) {
     case SM_UP:
 	sti_bmove(sti, t + count, 0, t, 0, b - t - count, conp->vc_cols);
-	sti_clear(sti, b - count, 0, count, conp->vc_cols, conp->vc_video_erase_char);
+	sti_clear(sti, b - count, 0, count, conp->vc_cols, conp->vc_scrl_erase_char);
 	break;
 
     case SM_DOWN:
 	sti_bmove(sti, t, 0, t + count, 0, b - t - count, conp->vc_cols);
-	sti_clear(sti, t, 0, count, conp->vc_cols, conp->vc_video_erase_char);
+	sti_clear(sti, t, 0, count, conp->vc_cols, conp->vc_scrl_erase_char);
 	break;
     }
 
diff -puN drivers/video/console/vgacon.c~vt-fix-background-color-on-line-feed drivers/video/console/vgacon.c
--- a/drivers/video/console/vgacon.c~vt-fix-background-color-on-line-feed
+++ a/drivers/video/console/vgacon.c
@@ -1350,7 +1350,7 @@ static int vgacon_scroll(struct vc_data 
 		} else
 			c->vc_origin += delta;
 		scr_memsetw((u16 *) (c->vc_origin + c->vc_screenbuf_size -
-				     delta), c->vc_video_erase_char,
+				     delta), c->vc_scrl_erase_char,
 			    delta);
 	} else {
 		if (oldo - delta < vga_vram_base) {
@@ -1363,7 +1363,7 @@ static int vgacon_scroll(struct vc_data 
 		} else
 			c->vc_origin -= delta;
 		c->vc_scr_end = c->vc_origin + c->vc_screenbuf_size;
-		scr_memsetw((u16 *) (c->vc_origin), c->vc_video_erase_char,
+		scr_memsetw((u16 *) (c->vc_origin), c->vc_scrl_erase_char,
 			    delta);
 	}
 	c->vc_scr_end = c->vc_origin + c->vc_screenbuf_size;
diff -puN include/linux/console_struct.h~vt-fix-background-color-on-line-feed include/linux/console_struct.h
--- a/include/linux/console_struct.h~vt-fix-background-color-on-line-feed
+++ a/include/linux/console_struct.h
@@ -53,6 +53,7 @@ struct vc_data {
 	unsigned short	vc_hi_font_mask;	/* [#] Attribute set for upper 256 chars of font or 0 if not supported */
 	struct console_font vc_font;		/* Current VC font set */
 	unsigned short	vc_video_erase_char;	/* Background erase character */
+	unsigned short	vc_scrl_erase_char;	/* Erase character for scroll */
 	/* VT terminal data */
 	unsigned int	vc_state;		/* Escape sequence parser state */
 	unsigned int	vc_npar,vc_par[NPAR];	/* Parameters of current escape sequence */
_

Patches currently in -mm which might be from jengelh@computergmbh.de are

origin.patch
git-kvm.patch
git-unionfs.patch

