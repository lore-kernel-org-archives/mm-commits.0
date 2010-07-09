From: akpm@linux-foundation.org
Subject: + s3c-fb-integrate-palette-setup-code-into-main-driver.patch added to -mm tree
Date: Fri, 09 Jul 2010 16:08:57 -0700
Message-ID: <201007092308.o69N8vPQ030958@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49680 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754044Ab0GIXNd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jul 2010 19:13:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben-linux@fluff.org, inki.dae@samsung.com, m.szyprowski@samsung.com, p.osciak@samsung.com


The patch titled
     s3c-fb: integrate palette setup code into main driver
has been added to the -mm tree.  Its filename is
     s3c-fb-integrate-palette-setup-code-into-main-driver.patch

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
Subject: s3c-fb: integrate palette setup code into main driver
From: Ben Dooks <ben-linux@fluff.org>

Remove the palette setup code from the header files and put it into the
main driver.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
Cc: InKi Dae <inki.dae@samsung.com>
Cc: KyungMin Park <kyungmin.park.samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/plat-samsung/include/plat/regs-fb-v4.h |   34 --------------
 drivers/video/s3c-fb.c                          |   33 +++++++++++++
 2 files changed, 32 insertions(+), 35 deletions(-)

diff -puN arch/arm/plat-samsung/include/plat/regs-fb-v4.h~s3c-fb-integrate-palette-setup-code-into-main-driver arch/arm/plat-samsung/include/plat/regs-fb-v4.h
--- a/arch/arm/plat-samsung/include/plat/regs-fb-v4.h~s3c-fb-integrate-palette-setup-code-into-main-driver
+++ a/arch/arm/plat-samsung/include/plat/regs-fb-v4.h
@@ -137,40 +137,6 @@
 #define WPALCON_W2PAL_16BPP_A555		(1 << 6)
 
 
-/* system specific implementation code for palette sizes, and other
- * information that changes depending on which architecture is being
- * compiled.
-*/
-
-struct s3c_fb_palette {
-	struct fb_bitfield	r;
-	struct fb_bitfield	g;
-	struct fb_bitfield	b;
-	struct fb_bitfield	a;
-};
-
-static inline void s3c_fb_init_palette(unsigned int window,
-				       struct s3c_fb_palette *palette)
-{
-	if (window < 2) {
-		/* Windows 0/1 are 8/8/8 or A/8/8/8 */
-		palette->r.offset = 16;
-		palette->r.length = 8;
-		palette->g.offset = 8;
-		palette->g.length = 8;
-		palette->b.offset = 0;
-		palette->b.length = 8;
-	} else {
-		/* currently we assume RGB 5/6/5 */
-		palette->r.offset = 11;
-		palette->r.length = 5;
-		palette->g.offset = 5;
-		palette->g.length = 6;
-		palette->b.offset = 0;
-		palette->b.length = 5;
-	}
-}
-
 /* Notes on per-window bpp settings
  *
  * Value	Win0	 Win1	  Win2	   Win3	    Win 4
diff -puN drivers/video/s3c-fb.c~s3c-fb-integrate-palette-setup-code-into-main-driver drivers/video/s3c-fb.c
--- a/drivers/video/s3c-fb.c~s3c-fb-integrate-palette-setup-code-into-main-driver
+++ a/drivers/video/s3c-fb.c
@@ -116,6 +116,20 @@ struct s3c_fb_driverdata {
 };
 
 /**
+ * struct s3c_fb_palette - palette information
+ * @r: Red bitfield.
+ * @g: Green bitfield.
+ * @b: Blue bitfield.
+ * @a: Alpha bitfield.
+ */
+struct s3c_fb_palette {
+	struct fb_bitfield	r;
+	struct fb_bitfield	g;
+	struct fb_bitfield	b;
+	struct fb_bitfield	a;
+};
+
+/**
  * struct s3c_fb_win - per window private data for each framebuffer.
  * @windata: The platform data supplied for the window configuration.
  * @parent: The hardware that this window is part of.
@@ -866,7 +880,24 @@ static int __devinit s3c_fb_probe_win(st
 	}
 
 	/* setup the r/b/g positions for the window's palette */
-	s3c_fb_init_palette(win_no, &win->palette);
+	if (win->variant.palette_16bpp) {
+		/* Set RGB 5:6:5 as default */
+		win->palette.r.offset = 11;
+		win->palette.r.length = 5;
+		win->palette.g.offset = 5;
+		win->palette.g.length = 6;
+		win->palette.b.offset = 0;
+		win->palette.b.length = 5;
+
+	} else {
+		/* Set 8bpp or 8bpp and 1bit alpha */
+		win->palette.r.offset = 16;
+		win->palette.r.length = 8;
+		win->palette.g.offset = 8;
+		win->palette.g.length = 8;
+		win->palette.b.offset = 0;
+		win->palette.b.length = 8;
+	}
 
 	/* setup the initial video mode from the window */
 	fb_videomode_to_var(&fbinfo->var, initmode);
_

Patches currently in -mm which might be from ben-linux@fluff.org are

linux-next.patch
s3c-fb-change-to-depending-on-config_s3c_fb_dev.patch
s3c-fb-add-default-window-feature.patch
s3c-fb-fix-distortedness-situation-for-the-mode-more-then-24bpp.patch
s3c-fb-only-init-window-colour-key-controls-for-windows-with-blending.patch
s3c-fb-initial-move-to-unifying-the-header-files.patch
s3c-fb-udpate-to-support-s3c2416-s3c2443-style-hardware.patch
s3c-fb-integrate-palette-setup-code-into-main-driver.patch
s3c-fb-fix-various-null-references-on-framebuffer-memory-alloc-failure.patch
s3c-fb-correct-framesel1-bitfield-defines-for-vidintcon0-register.patch
s3c-fb-separate-s5pc100-and-s5pv210-framebuffer-driver-data-structures.patch
s3c-fb-add-device-name-initialization.patch
s3c-fb-add-support-for-display-panning.patch
s3c-fb-add-wait-for-vsync-ioctl.patch
s3c-fb-window-3-of-64xx-does-not-have-an-osd_d-register.patch
s3c-fb-add-shadowcon-shadow-register-locking-support-for-s5pv210.patch
s3c-fb-correct-window-osd-size-and-alpha-register-handling.patch
s3c-fb-protect-window-specific-registers-during-updates.patch
s3c-fb-fix-section-mismatch.patch
s3c-fb-add-support-for-dma-channel-control-on-s5pv210.patch
panic-keep-blinking-in-spite-of-long-spin-timer-mode.patch

