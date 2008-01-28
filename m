From: akpm@linux-foundation.org
Subject: + pm2fb-big-endian-fix.patch added to -mm tree
Date: Sun, 27 Jan 2008 21:25:20 -0800
Message-ID: <200801280526.m0S5QEmv013847@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52568 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751388AbYA1F0a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 00:26:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@pol.net, davem@davemloft.net, geert@linux-m68k.org


The patch titled
     pm2fb: big endian fix
has been added to the -mm tree.  Its filename is
     pm2fb-big-endian-fix.patch

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
Subject: pm2fb: big endian fix
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Fix garbled letters on big endian machines with acceleration enabled.

This makes pm2fb works fine with full acceleration on sparc machine (card
known as Sun PGX-32 or TechSource Raptor GFX-8P).

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pm2fb.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN drivers/video/pm2fb.c~pm2fb-big-endian-fix drivers/video/pm2fb.c
--- a/drivers/video/pm2fb.c~pm2fb-big-endian-fix
+++ a/drivers/video/pm2fb.c
@@ -1159,6 +1159,11 @@ static void pm2fb_imageblit(struct fb_in
 	u32 fgx, bgx;
 	const u32 *src = (const u32 *)image->data;
 	u32 xres = (info->var.xres + 31) & ~31;
+	int raster_mode = 1; /* invert bits */
+
+#ifdef __LITTLE_ENDIAN
+	raster_mode |= 3 << 7; /* reverse byte order */
+#endif
 
 	if (info->state != FBINFO_STATE_RUNNING)
 		return;
@@ -1208,9 +1213,8 @@ static void pm2fb_imageblit(struct fb_in
 		pm2_WR(par, PM2R_RENDER,
 			PM2F_RENDER_RECTANGLE |
 			PM2F_INCREASE_X | PM2F_INCREASE_Y);
-		/* BitMapPackEachScanline & invert bits and byte order*/
-		/* force background */
-		pm2_WR(par, PM2R_RASTERIZER_MODE,  (1 << 9) | 1 | (3 << 7));
+		/* BitMapPackEachScanline */
+		pm2_WR(par, PM2R_RASTERIZER_MODE, raster_mode | (1 << 9));
 		pm2_WR(par, PM2R_CONSTANT_COLOR, fgx);
 		pm2_WR(par, PM2R_RENDER,
 			PM2F_RENDER_RECTANGLE |
@@ -1224,8 +1228,7 @@ static void pm2fb_imageblit(struct fb_in
 			PM2F_RENDER_RECTANGLE |
 			PM2F_RENDER_FASTFILL |
 			PM2F_INCREASE_X | PM2F_INCREASE_Y);
-		/* invert bits and byte order*/
-		pm2_WR(par, PM2R_RASTERIZER_MODE,  1 | (3 << 7));
+		pm2_WR(par, PM2R_RASTERIZER_MODE, raster_mode);
 		pm2_WR(par, PM2R_FB_BLOCK_COLOR, fgx);
 		pm2_WR(par, PM2R_RENDER,
 			PM2F_RENDER_RECTANGLE |
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

s3c2410_fb-fix-line-length-calculation.patch
git-alsa.patch
git-scsi-misc.patch
drivers-video-pm3fbc-section-fix.patch
pm2fb-big-endian-fix.patch
