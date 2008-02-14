From: akpm@linux-foundation.org
Subject: + fbdev-make-the-best-fit-section-of-fb_find_mode-return-the-closest-matching-mode.patch added to -mm tree
Date: Thu, 14 Feb 2008 14:11:04 -0800
Message-ID: <200802142211.m1EMB4YY005528@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38068 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755401AbYBNWLK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 17:11:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: spock@gentoo.org, adaplas@pol.net, krzysztof.h1@poczta.fm


The patch titled
     fbdev: make the best-fit section of fb_find_mode return the closest matching mode
has been added to the -mm tree.  Its filename is
     fbdev-make-the-best-fit-section-of-fb_find_mode-return-the-closest-matching-mode.patch

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
Subject: fbdev: make the best-fit section of fb_find_mode return the closest matching mode
From: Michal Januszewski <spock@gentoo.org>

Currently, if a perfect match in terms of resolution is not found,
fb_find_mode() only looks for a best-fit mode among modes with a higher
resolution than the one requested.  Thus, if the user requests a resolution
higher than the largest supported one, they are dropped to the default mode
(usually a low resolution one).

Change this behaviour so that all valid video modes are considered when
looking for a best-fit mode, while still preferring modes with a higher
resolution.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/modedb.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff -puN drivers/video/modedb.c~fbdev-make-the-best-fit-section-of-fb_find_mode-return-the-closest-matching-mode drivers/video/modedb.c
--- a/drivers/video/modedb.c~fbdev-make-the-best-fit-section-of-fb_find_mode-return-the-closest-matching-mode
+++ a/drivers/video/modedb.c
@@ -522,7 +522,7 @@ int fb_find_mode(struct fb_var_screeninf
 	int res_specified = 0, bpp_specified = 0, refresh_specified = 0;
 	unsigned int xres = 0, yres = 0, bpp = default_bpp, refresh = 0;
 	int yres_specified = 0, cvt = 0, rb = 0, interlace = 0, margins = 0;
-	u32 best, diff;
+	u32 best, diff, tdiff;
 
 	for (i = namelen-1; i >= 0; i--) {
 	    switch (name[i]) {
@@ -651,19 +651,27 @@ done:
 		return (refresh_specified) ? 2 : 1;
 	}
 
-	diff = xres + yres;
+	diff = 2 * (xres + yres);
 	best = -1;
 	DPRINTK("Trying best-fit modes\n");
 	for (i = 0; i < dbsize; i++) {
-	    if (xres <= db[i].xres && yres <= db[i].yres) {
 		DPRINTK("Trying %ix%i\n", db[i].xres, db[i].yres);
 		if (!fb_try_mode(var, info, &db[i], bpp)) {
-		    if (diff > (db[i].xres - xres) + (db[i].yres - yres)) {
-			diff = (db[i].xres - xres) + (db[i].yres - yres);
-			best = i;
-		    }
+			tdiff = abs(db[i].xres - xres) +
+				abs(db[i].yres - yres);
+
+			/*
+			 * Penalize modes with resolutions smaller
+			 * than requested.
+			 */
+			if (xres > db[i].xres || yres > db[i].yres)
+				tdiff += xres + yres;
+
+			if (diff > tdiff) {
+				diff = tdiff;
+				best = i;
+			}
 		}
-	    }
 	}
 	if (best != -1) {
 	    fb_try_mode(var, info, &db[best], bpp);
_

Patches currently in -mm which might be from spock@gentoo.org are

drivers-video-uvesafbc-fix-section-mismatch-warning-in-param_set_scroll.patch
fbdev-make-the-best-fit-section-of-fb_find_mode-return-the-closest-matching-mode.patch
