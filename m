From: akpm@linux-foundation.org
Subject: + fbdev-fix-incorrect-timings-in-some-modedb-entries.patch added to -mm tree
Date: Wed, 01 Aug 2007 15:42:12 -0700
Message-ID: <200708012242.l71MgC4g021168@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54060 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753978AbXHAWmt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2007 18:42:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adaplas@gmail.com, johnlumby@hotmail.com


The patch titled
     fbdev: Fix incorrect timings in some modedb entries
has been added to the -mm tree.  Its filename is
     fbdev-fix-incorrect-timings-in-some-modedb-entries.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fbdev: Fix incorrect timings in some modedb entries
From: "Antonino A. Daplas" <adaplas@gmail.com>

Reported by: John Lumby <johnlumby@hotmail.com>

Some of the entries in the mode database does not match the comments and/or
the refresh field.  Adjust the timings so they match with both the comments
and the refresh rate.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/modedb.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/video/modedb.c~fbdev-fix-incorrect-timings-in-some-modedb-entries drivers/video/modedb.c
--- a/drivers/video/modedb.c~fbdev-fix-incorrect-timings-in-some-modedb-entries
+++ a/drivers/video/modedb.c
@@ -72,7 +72,7 @@ static const struct fb_videomode modedb[
 	0, FB_VMODE_NONINTERLACED
     }, {
 	/* 1152x864 @ 89 Hz interlaced, 44 kHz hsync */
-	NULL, 69, 1152, 864, 15384, 96, 16, 110, 1, 216, 10,
+	NULL, 89, 1152, 864, 15384, 96, 16, 110, 1, 216, 10,
 	0, FB_VMODE_INTERLACED
     }, {
 	/* 800x600 @ 72 Hz, 48.0 kHz hsync */
@@ -120,11 +120,11 @@ static const struct fb_videomode modedb[
 	0, FB_VMODE_NONINTERLACED
     }, {
 	/* 1400x1050 @ 60Hz, 63.9 kHz hsync */
-	NULL, 68, 1400, 1050, 9259, 136, 40, 13, 1, 112, 3,
+	NULL, 60, 1400, 1050, 9259, 136, 40, 13, 1, 112, 3,
 	0, FB_VMODE_NONINTERLACED   	
     }, {
 	/* 1400x1050 @ 75,107 Hz, 82,392 kHz +hsync +vsync*/
-	NULL, 75, 1400, 1050, 9271, 120, 56, 13, 0, 112, 3,
+	NULL, 75, 1400, 1050, 7190, 120, 56, 23, 10, 112, 13,
 	FB_SYNC_HOR_HIGH_ACT|FB_SYNC_VERT_HIGH_ACT, FB_VMODE_NONINTERLACED
     }, {
 	/* 1400x1050 @ 60 Hz, ? kHz +hsync +vsync*/
@@ -253,7 +253,7 @@ static const struct fb_videomode modedb[
 	FB_VMODE_NONINTERLACED
     }, {
 	/* 1152x768, 60 Hz, PowerBook G4 Titanium I and II */
-	NULL, 60, 1152, 768, 15386, 158, 26, 29, 3, 136, 6,
+	NULL, 60, 1152, 768, 14047, 158, 26, 29, 3, 136, 6,
 	FB_SYNC_HOR_HIGH_ACT|FB_SYNC_VERT_HIGH_ACT, FB_VMODE_NONINTERLACED
     }, {
 	/* 1366x768, 60 Hz, 47.403 kHz hsync, WXGA 16:9 aspect ratio */
@@ -306,7 +306,7 @@ const struct fb_videomode vesa_modes[] =
 	  FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
 	  FB_VMODE_NONINTERLACED, FB_MODE_IS_VESA },
         /* 12 1024x768i-43 VESA */
-	{ NULL, 53, 1024, 768, 22271, 56, 8, 41, 0, 176, 8,
+	{ NULL, 43, 1024, 768, 22271, 56, 8, 41, 0, 176, 8,
 	  FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
 	  FB_VMODE_INTERLACED, FB_MODE_IS_VESA },
 	/* 13 1024x768-60 VESA */
@@ -383,7 +383,7 @@ const struct fb_videomode vesa_modes[] =
 	{ NULL, 60, 1920, 1440, 4273, 344, 128, 56, 1, 200, 3,
 	  FB_SYNC_VERT_HIGH_ACT, FB_VMODE_NONINTERLACED, FB_MODE_IS_VESA },
 	/* 33 1920x1440-75 VESA */
-	{ NULL, 60, 1920, 1440, 3367, 352, 144, 56, 1, 224, 3,
+	{ NULL, 75, 1920, 1440, 3367, 352, 144, 56, 1, 224, 3,
 	  FB_SYNC_VERT_HIGH_ACT, FB_VMODE_NONINTERLACED, FB_MODE_IS_VESA },
 };
 EXPORT_SYMBOL(vesa_modes);
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
stifb-detect-cards-in-double-buffer-mode-more-reliably.patch
fbcon-kill-compile-warning.patch
pvr2fb-fix-oops-when-pseudo_palette-is-written.patch
pvr2fb-consolidated-cleanup-of-pvr2fbc.patch
pvr2fb-update-documentation-fb-pvr2fbtxt.patch
matroxfb-rectify-jitter-g450-g550.patch
fbdev-export-fb_destroy_modelist.patch
connector-change-connectors-max-message-size.patch
uvesafb-add-connector-entries.patch
uvesafb-the-driver-core.patch
uvesafb-documentation.patch
pm3fb-copyarea-and-partial-imageblit-suppor.patch
skeletonfb-wrong-field-name-fix.patch
pm3fb-header-file-reduction.patch
pm3fb-imageblit-improved.patch
pm3fb-3-small-fixes.patch
pm3fb-improvements-and-cleanups.patch
pm3fb-mtrr-support-and-noaccel-option.patch
pm2fb-mtrr-support-and-noaccel-option.patch
pm2fb-accelerated-imageblit.patch
pm2fb-source-code-improvements.patch
pm2fb-permedia-2v-initialization-fixes.patch
pm2fb-accelerated-24-bit-fillrect.patch
sm501fb-update-suspend-and-resume-code.patch
sm501fb-call-fb-suspend-function-during-suspend-and-resume.patch
sm501fb-ensure-panel-interface-is-not-tristated-when-setup.patch
mbxfb-improvements-and-new-features.patch
pxafb-add-support-for-other-palette-formats.patch
tridentfb-coding-style-improvement.patch
tdfxfb-coding-style-improvement.patch
tdfxfb-3-fixes.patch
tdfxfb-palette-fixes.patch
fbdev-fix-incorrect-timings-in-some-modedb-entries.patch
tdfxfb-code-improvements.patch
tdfxfb-hardware-cursor.patch
tdfxfb-mtrr-support.patch
pm2fb-checkpatch-fixes.patch
pm3fb-checkpatch-fixes.patch
