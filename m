From: akpm@linux-foundation.org
Subject: + vt-add-color-support-to-the-underline-and-italic-attributes.patch added to -mm tree
Date: Sun, 01 Apr 2007 22:35:29 -0700
Message-ID: <200704020535.l325ZT1k025106@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36223 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753313AbXDBFfl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 2 Apr 2007 01:35:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@linux01.gwdg.de, adaplas@pol.net, jengelh@gmx.de


The patch titled
     vt: add color support to the "underline" and "italic" attributes
has been added to the -mm tree.  Its filename is
     vt-add-color-support-to-the-underline-and-italic-attributes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: vt: add color support to the "underline" and "italic" attributes
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Add color support to the "underline" and "italic" attributes as in
OpenBSD/NetBSD-style (vt220) and xterm.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt.c               |   34 ++++++++++++++++++++++++------
 drivers/video/console/mdacon.c  |    3 +-
 drivers/video/console/promcon.c |    3 +-
 drivers/video/console/sticon.c  |    2 -
 drivers/video/console/vgacon.c  |   12 +++++++---
 include/linux/console.h         |    2 -
 include/linux/console_struct.h  |    3 ++
 7 files changed, 45 insertions(+), 14 deletions(-)

diff -puN drivers/char/vt.c~vt-add-color-support-to-the-underline-and-italic-attributes drivers/char/vt.c
--- a/drivers/char/vt.c~vt-add-color-support-to-the-underline-and-italic-attributes
+++ a/drivers/char/vt.c
@@ -348,10 +348,12 @@ void update_region(struct vc_data *vc, u
 
 /* Structure of attributes is hardware-dependent */
 
-static u8 build_attr(struct vc_data *vc, u8 _color, u8 _intensity, u8 _blink, u8 _underline, u8 _reverse)
+static u8 build_attr(struct vc_data *vc, u8 _color, u8 _intensity, u8 _blink,
+    u8 _underline, u8 _reverse, u8 _italic)
 {
 	if (vc->vc_sw->con_build_attr)
-		return vc->vc_sw->con_build_attr(vc, _color, _intensity, _blink, _underline, _reverse);
+		return vc->vc_sw->con_build_attr(vc, _color, _intensity,
+		       _blink, _underline, _reverse, _italic);
 
 #ifndef VT_BUF_VRAM_ONLY
 /*
@@ -368,10 +370,13 @@ static u8 build_attr(struct vc_data *vc,
 	u8 a = vc->vc_color;
 	if (!vc->vc_can_do_color)
 		return _intensity |
+		       (_italic ? 2 : 0) |
 		       (_underline ? 4 : 0) |
 		       (_reverse ? 8 : 0) |
 		       (_blink ? 0x80 : 0);
-	if (_underline)
+	if (_italic)
+		a = (a & 0xF0) | vc->vc_itcolor;
+	else if (_underline)
 		a = (a & 0xf0) | vc->vc_ulcolor;
 	else if (_intensity == 0)
 		a = (a & 0xf0) | vc->vc_ulcolor;
@@ -392,8 +397,10 @@ static u8 build_attr(struct vc_data *vc,
 
 static void update_attr(struct vc_data *vc)
 {
-	vc->vc_attr = build_attr(vc, vc->vc_color, vc->vc_intensity, vc->vc_blink, vc->vc_underline, vc->vc_reverse ^ vc->vc_decscnm);
-	vc->vc_video_erase_char = (build_attr(vc, vc->vc_color, 1, vc->vc_blink, 0, vc->vc_decscnm) << 8) | ' ';
+	vc->vc_attr = build_attr(vc, vc->vc_color, vc->vc_intensity,
+	              vc->vc_blink, vc->vc_underline,
+	              vc->vc_reverse ^ vc->vc_decscnm, vc->vc_italic);
+	vc->vc_video_erase_char = (build_attr(vc, vc->vc_color, 1, vc->vc_blink, 0, vc->vc_decscnm, 0) << 8) | ' ';
 }
 
 /* Note: inverting the screen twice should revert to the original state */
@@ -1136,6 +1143,7 @@ static void csi_X(struct vc_data *vc, in
 static void default_attr(struct vc_data *vc)
 {
 	vc->vc_intensity = 1;
+	vc->vc_italic = 0;
 	vc->vc_underline = 0;
 	vc->vc_reverse = 0;
 	vc->vc_blink = 0;
@@ -1158,6 +1166,9 @@ static void csi_m(struct vc_data *vc)
 			case 2:
 				vc->vc_intensity = 0;
 				break;
+			case 3:
+				vc->vc_italic = 1;
+				break;
 			case 4:
 				vc->vc_underline = 1;
 				break;
@@ -1198,6 +1209,9 @@ static void csi_m(struct vc_data *vc)
 			case 22:
 				vc->vc_intensity = 1;
 				break;
+			case 23:
+				vc->vc_italic = 0;
+				break;
 			case 24:
 				vc->vc_underline = 0;
 				break;
@@ -1458,6 +1472,7 @@ static void save_cur(struct vc_data *vc)
 	vc->vc_saved_x		= vc->vc_x;
 	vc->vc_saved_y		= vc->vc_y;
 	vc->vc_s_intensity	= vc->vc_intensity;
+	vc->vc_s_italic         = vc->vc_italic;
 	vc->vc_s_underline	= vc->vc_underline;
 	vc->vc_s_blink		= vc->vc_blink;
 	vc->vc_s_reverse	= vc->vc_reverse;
@@ -1472,6 +1487,7 @@ static void restore_cur(struct vc_data *
 {
 	gotoxy(vc, vc->vc_saved_x, vc->vc_saved_y);
 	vc->vc_intensity	= vc->vc_s_intensity;
+	vc->vc_italic		= vc->vc_s_italic;
 	vc->vc_underline	= vc->vc_s_underline;
 	vc->vc_blink		= vc->vc_s_blink;
 	vc->vc_reverse		= vc->vc_s_reverse;
@@ -2585,6 +2601,11 @@ static void con_close(struct tty_struct 
 	mutex_unlock(&tty_mutex);
 }
 
+static int default_italic_color    = 2; // green (ASCII)
+static int default_underline_color = 3; // cyan (ASCII)
+module_param_named(italic, default_italic_color, int, S_IRUGO | S_IWUSR);
+module_param_named(underline, default_underline_color, int, S_IRUGO | S_IWUSR);
+
 static void vc_init(struct vc_data *vc, unsigned int rows,
 		    unsigned int cols, int do_clear)
 {
@@ -2604,7 +2625,8 @@ static void vc_init(struct vc_data *vc, 
 		vc->vc_palette[k++] = default_blu[j] ;
 	}
 	vc->vc_def_color       = 0x07;   /* white */
-	vc->vc_ulcolor		= 0x0f;   /* bold white */
+	vc->vc_ulcolor         = default_underline_color;
+	vc->vc_itcolor         = default_italic_color;
 	vc->vc_halfcolor       = 0x08;   /* grey */
 	init_waitqueue_head(&vc->paste_wait);
 	reset_terminal(vc, do_clear);
diff -puN drivers/video/console/mdacon.c~vt-add-color-support-to-the-underline-and-italic-attributes drivers/video/console/mdacon.c
--- a/drivers/video/console/mdacon.c~vt-add-color-support-to-the-underline-and-italic-attributes
+++ a/drivers/video/console/mdacon.c
@@ -384,7 +384,7 @@ static inline u16 mda_convert_attr(u16 c
 }
 
 static u8 mdacon_build_attr(struct vc_data *c, u8 color, u8 intensity, 
-			    u8 blink, u8 underline, u8 reverse)
+			    u8 blink, u8 underline, u8 reverse, u8 italic)
 {
 	/* The attribute is just a bit vector:
 	 *
@@ -397,6 +397,7 @@ static u8 mdacon_build_attr(struct vc_da
 	return (intensity & 3) |
 		((underline & 1) << 2) |
 		((reverse   & 1) << 3) |
+		(!!italic << 4) |
 		((blink     & 1) << 7);
 }
 
diff -puN drivers/video/console/promcon.c~vt-add-color-support-to-the-underline-and-italic-attributes drivers/video/console/promcon.c
--- a/drivers/video/console/promcon.c~vt-add-color-support-to-the-underline-and-italic-attributes
+++ a/drivers/video/console/promcon.c
@@ -548,7 +548,8 @@ promcon_scroll(struct vc_data *conp, int
 }
 
 #if !(PROMCON_COLOR)
-static u8 promcon_build_attr(struct vc_data *conp, u8 _color, u8 _intensity, u8 _blink, u8 _underline, u8 _reverse)
+static u8 promcon_build_attr(struct vc_data *conp, u8 _color, u8 _intensity,
+    u8 _blink, u8 _underline, u8 _reverse, u8 _italic)
 {
 	return (_reverse) ? 0xf : 0x7;
 }
diff -puN drivers/video/console/sticon.c~vt-add-color-support-to-the-underline-and-italic-attributes drivers/video/console/sticon.c
--- a/drivers/video/console/sticon.c~vt-add-color-support-to-the-underline-and-italic-attributes
+++ a/drivers/video/console/sticon.c
@@ -314,7 +314,7 @@ static unsigned long sticon_getxy(struct
 }
 
 static u8 sticon_build_attr(struct vc_data *conp, u8 color, u8 intens,
-			    u8 blink, u8 underline, u8 reverse)
+			    u8 blink, u8 underline, u8 reverse, u8 italic)
 {
     u8 attr = ((color & 0x70) >> 1) | ((color & 7));
 
diff -puN drivers/video/console/vgacon.c~vt-add-color-support-to-the-underline-and-italic-attributes drivers/video/console/vgacon.c
--- a/drivers/video/console/vgacon.c~vt-add-color-support-to-the-underline-and-italic-attributes
+++ a/drivers/video/console/vgacon.c
@@ -87,7 +87,7 @@ static void vgacon_save_screen(struct vc
 static int vgacon_scroll(struct vc_data *c, int t, int b, int dir,
 			 int lines);
 static u8 vgacon_build_attr(struct vc_data *c, u8 color, u8 intensity,
-			    u8 blink, u8 underline, u8 reverse);
+			    u8 blink, u8 underline, u8 reverse, u8);
 static void vgacon_invert_region(struct vc_data *c, u16 * p, int count);
 static unsigned long vgacon_uni_pagedir[2];
 
@@ -578,12 +578,14 @@ static void vgacon_deinit(struct vc_data
 }
 
 static u8 vgacon_build_attr(struct vc_data *c, u8 color, u8 intensity,
-			    u8 blink, u8 underline, u8 reverse)
+			    u8 blink, u8 underline, u8 reverse, u8 italic)
 {
 	u8 attr = color;
 
 	if (vga_can_do_color) {
-		if (underline)
+		if (italic)
+			attr = (attr & 0xF0) | c->vc_itcolor;
+		else if (underline)
 			attr = (attr & 0xf0) | c->vc_ulcolor;
 		else if (intensity == 0)
 			attr = (attr & 0xf0) | c->vc_halfcolor;
@@ -597,7 +599,9 @@ static u8 vgacon_build_attr(struct vc_da
 	if (intensity == 2)
 		attr ^= 0x08;
 	if (!vga_can_do_color) {
-		if (underline)
+		if (italic)
+			attr = (attr & 0xF8) | 0x02;
+		else if (underline)
 			attr = (attr & 0xf8) | 0x01;
 		else if (intensity == 0)
 			attr = (attr & 0xf0) | 0x08;
diff -puN include/linux/console.h~vt-add-color-support-to-the-underline-and-italic-attributes include/linux/console.h
--- a/include/linux/console.h~vt-add-color-support-to-the-underline-and-italic-attributes
+++ a/include/linux/console.h
@@ -51,7 +51,7 @@ struct consw {
 	int	(*con_scrolldelta)(struct vc_data *, int);
 	int	(*con_set_origin)(struct vc_data *);
 	void	(*con_save_screen)(struct vc_data *);
-	u8	(*con_build_attr)(struct vc_data *, u8, u8, u8, u8, u8);
+	u8	(*con_build_attr)(struct vc_data *, u8, u8, u8, u8, u8, u8);
 	void	(*con_invert_region)(struct vc_data *, u16 *, int);
 	u16    *(*con_screen_pos)(struct vc_data *, int);
 	unsigned long (*con_getxy)(struct vc_data *, unsigned long, int *, int *);
diff -puN include/linux/console_struct.h~vt-add-color-support-to-the-underline-and-italic-attributes include/linux/console_struct.h
--- a/include/linux/console_struct.h~vt-add-color-support-to-the-underline-and-italic-attributes
+++ a/include/linux/console_struct.h
@@ -37,6 +37,7 @@ struct vc_data {
 	unsigned char	vc_color;		/* Foreground & background */
 	unsigned char	vc_s_color;		/* Saved foreground & background */
 	unsigned char	vc_ulcolor;		/* Color for underline mode */
+	unsigned char   vc_itcolor;
 	unsigned char	vc_halfcolor;		/* Color for half intensity mode */
 	/* cursor */
 	unsigned int	vc_cursor_type;
@@ -71,10 +72,12 @@ struct vc_data {
 	unsigned int	vc_deccolm	: 1;	/* 80/132 Column Mode */
 	/* attribute flags */
 	unsigned int	vc_intensity	: 2;	/* 0=half-bright, 1=normal, 2=bold */
+	unsigned int    vc_italic:1;
 	unsigned int	vc_underline	: 1;
 	unsigned int	vc_blink	: 1;
 	unsigned int	vc_reverse	: 1;
 	unsigned int	vc_s_intensity	: 2;	/* saved rendition */
+	unsigned int    vc_s_italic:1;
 	unsigned int	vc_s_underline	: 1;
 	unsigned int	vc_s_blink	: 1;
 	unsigned int	vc_s_reverse	: 1;
_

Patches currently in -mm which might be from jengelh@linux01.gwdg.de are

git-kbuild.patch
remove-artificial-software-max_loop-limit.patch
vt-allow-for-the-palette-to-be-exposed-and-changed-via-sysfs.patch
vt-add-color-support-to-the-underline-and-italic-attributes.patch
