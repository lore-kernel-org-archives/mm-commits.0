From: akpm@linux-foundation.org
Subject: + fb_videomode_to_var-reset-virtual-screen-parameters.patch added to -mm tree
Date: Fri, 09 Feb 2007 01:26:41 -0800
Message-ID: <200702090926.l199QfSe009504@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38621 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946260AbXBIJ1s (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 9 Feb 2007 04:27:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com, benh@kernel.crashing.org, jsimmons@infradead.org, paulus@samba.org


The patch titled
     fb_videomode_to_var: reset virtual screen parameters
has been added to the -mm tree.  Its filename is
     fb_videomode_to_var-reset-virtual-screen-parameters.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fb_videomode_to_var: reset virtual screen parameters
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

fb_videomode_to_var(): reset the virtual screen parameters when converting
from an fb_videomode to an fb_var_screeninfo.

Without this the old virtual screen parameters are kept.  Hence you cannot
switch to a video mode with a lower resolution on frame buffer devices that
don't support virtual screens and panning, as values are not supposed to be
rounded down when they don't fit.

I also reordered the assignments to match the order of the individual members.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: James Simmons <jsimmons@infradead.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/modedb.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/video/modedb.c~fb_videomode_to_var-reset-virtual-screen-parameters drivers/video/modedb.c
--- a/drivers/video/modedb.c~fb_videomode_to_var-reset-virtual-screen-parameters
+++ a/drivers/video/modedb.c
@@ -716,13 +716,17 @@ void fb_videomode_to_var(struct fb_var_s
 {
 	var->xres = mode->xres;
 	var->yres = mode->yres;
+	var->xres_virtual = mode->xres;
+	var->yres_virtual = mode->yres;
+	var->xoffset = 0;
+	var->yoffset = 0;
 	var->pixclock = mode->pixclock;
 	var->left_margin = mode->left_margin;
-	var->hsync_len = mode->hsync_len;
-	var->vsync_len = mode->vsync_len;
 	var->right_margin = mode->right_margin;
 	var->upper_margin = mode->upper_margin;
 	var->lower_margin = mode->lower_margin;
+	var->hsync_len = mode->hsync_len;
+	var->vsync_len = mode->vsync_len;
 	var->sync = mode->sync;
 	var->vmode = mode->vmode & FB_VMODE_MASK;
 }
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch
ps3-add-shutdown-to-virtual-uart-port-driver-framework.patch
ps3-av-settings-driver.patch
fbdev-modedb-allow-refresh-rates-for-named-video-modes.patch
fbdev-modedb-make-more-pointer-parameters-const.patch
fb_videomode_to_var-reset-virtual-screen-parameters.patch
ps3-preallocate-bootmem-memory-for-ps3fb.patch
ps3-virtual-frame-buffer-driver.patch
ps3-disable-display-flipping-during-mode-changes.patch
ps3-cleanup-ps3fb-before-clearing-hpte.patch
ps3-ps3av-fb-defconfig-updates.patch
