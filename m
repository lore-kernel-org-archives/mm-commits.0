From: akpm@linux-foundation.org
Subject: + ps3fb-inline-macros-that-are-used-only-once.patch added to -mm tree
Date: Sat, 26 Jan 2008 21:14:28 -0800
Message-ID: <200801270514.m0R5EPbl030981@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33233 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750922AbYA0FOt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jan 2008 00:14:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com, adaplas@pol.net


The patch titled
     ps3fb: open-code macros that are used only once
has been added to the -mm tree.  Its filename is
     ps3fb-inline-macros-that-are-used-only-once.patch

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
Subject: ps3fb: open-code macros that are used only once
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Open-code the X_OFF(), Y_OFF(), WIDTH(), HEIGHT(), and VP_OFF() macros, as
they're used in one place only

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/ps3fb.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff -puN drivers/video/ps3fb.c~ps3fb-inline-macros-that-are-used-only-once drivers/video/ps3fb.c
--- a/drivers/video/ps3fb.c~ps3fb-inline-macros-that-are-used-only-once
+++ a/drivers/video/ps3fb.c
@@ -287,15 +287,8 @@ static const struct fb_videomode ps3fb_m
 #define HEAD_A
 #define HEAD_B
 
-#define X_OFF(i)	(ps3fb_res[i].xoff)	/* left/right margin (pixel) */
-#define Y_OFF(i)	(ps3fb_res[i].yoff)	/* top/bottom margin (pixel) */
-#define WIDTH(i)	(ps3fb_res[i].xres)	/* width of FB */
-#define HEIGHT(i)	(ps3fb_res[i].yres)	/* height of FB */
 #define BPP		4			/* number of bytes per pixel */
 
-/* Start of the virtual frame buffer (relative to fullscreen ) */
-#define VP_OFF(i)	((WIDTH(i) * Y_OFF(i) + X_OFF(i)) * BPP)
-
 
 static int ps3fb_mode;
 module_param(ps3fb_mode, int, 0);
@@ -611,7 +604,10 @@ static int ps3fb_set_par(struct fb_info 
 
 	par->width = info->var.xres;
 	par->height = info->var.yres;
-	offset = VP_OFF(i);
+
+	/* Start of the virtual frame buffer (relative to fullscreen) */
+	offset = ps3fb_res[i].yoff * ddr_line_length + ps3fb_res[i].xoff * BPP;
+
 	par->fb_offset = GPU_ALIGN_UP(offset);
 	par->full_offset = par->fb_offset - offset;
 	par->pan_offset = info->var.yoffset * xdr_line_length +
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
