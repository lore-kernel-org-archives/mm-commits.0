From: akpm@linux-foundation.org
Subject: + neofb-kill-some-redundant-code.patch added to -mm tree
Date: Tue, 19 Aug 2008 13:43:40 -0700
Message-ID: <200808192043.m7JKheSx005426@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49501 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752534AbYHSUnm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Aug 2008 16:43:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl


The patch titled
     neofb: kill some redundant code
has been added to the -mm tree.  Its filename is
     neofb-kill-some-redundant-code.patch

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
Subject: neofb: kill some redundant code
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Move common code outside if/else or switch/case clauses.

Drop checks done twice inside the neofb_check_var().

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/neofb.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff -puN drivers/video/neofb.c~neofb-kill-some-redundant-code drivers/video/neofb.c
--- a/drivers/video/neofb.c~neofb-kill-some-redundant-code
+++ a/drivers/video/neofb.c
@@ -426,11 +426,11 @@ static void vgaHWProtect(int on)
 {
 	unsigned char tmp;
 
+	tmp = vga_rseq(NULL, 0x01);
 	if (on) {
 		/*
 		 * Turn off screen and disable sequencer.
 		 */
-		tmp = vga_rseq(NULL, 0x01);
 		vga_wseq(NULL, 0x00, 0x01);		/* Synchronous Reset */
 		vga_wseq(NULL, 0x01, tmp | 0x20);	/* disable the display */
 
@@ -439,7 +439,6 @@ static void vgaHWProtect(int on)
 		/*
 		 * Reenable sequencer, then turn on screen.
 		 */
-		tmp = vga_rseq(NULL, 0x01);
 		vga_wseq(NULL, 0x01, tmp & ~0x20);	/* reenable display */
 		vga_wseq(NULL, 0x00, 0x03);		/* clear synchronousreset */
 
@@ -648,10 +647,10 @@ neofb_check_var(struct fb_var_screeninfo
 	var->blue.msb_right = 0;
 	var->transp.msb_right = 0;
 
+	var->transp.offset = 0;
+	var->transp.length = 0;
 	switch (var->bits_per_pixel) {
 	case 8:		/* PSEUDOCOLOUR, 256 */
-		var->transp.offset = 0;
-		var->transp.length = 0;
 		var->red.offset = 0;
 		var->red.length = 8;
 		var->green.offset = 0;
@@ -661,8 +660,6 @@ neofb_check_var(struct fb_var_screeninfo
 		break;
 
 	case 16:		/* DIRECTCOLOUR, 64k */
-		var->transp.offset = 0;
-		var->transp.length = 0;
 		var->red.offset = 11;
 		var->red.length = 5;
 		var->green.offset = 5;
@@ -672,8 +669,6 @@ neofb_check_var(struct fb_var_screeninfo
 		break;
 
 	case 24:		/* TRUECOLOUR, 16m */
-		var->transp.offset = 0;
-		var->transp.length = 0;
 		var->red.offset = 16;
 		var->red.length = 8;
 		var->green.offset = 8;
@@ -704,8 +699,6 @@ neofb_check_var(struct fb_var_screeninfo
 	if (vramlen > 4 * 1024 * 1024)
 		vramlen = 4 * 1024 * 1024;
 
-	if (var->yres_virtual < var->yres)
-		var->yres_virtual = var->yres;
 	if (var->xres_virtual < var->xres)
 		var->xres_virtual = var->xres;
 
@@ -722,8 +715,6 @@ neofb_check_var(struct fb_var_screeninfo
 	   if it was possible. We should return -EINVAL, but I disagree */
 	if (var->yres_virtual < var->yres)
 		var->yres = var->yres_virtual;
-	if (var->xres_virtual < var->xres)
-		var->xres = var->xres_virtual;
 	if (var->xoffset + var->xres > var->xres_virtual)
 		var->xoffset = var->xres_virtual - var->xres;
 	if (var->yoffset + var->yres > var->yres_virtual)
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
pm2fb-free-cmap-memory-on-module-remove.patch
linux-next.patch
video-framebuffer-add-fuctional-power-management-support-to-blackfin-bf54x-lq043-framebuffer-driver.patch
rtc-m48t59-reduce-structure-m48t59_private.patch
rtc-m48t59-add-support-for-m48t02-and-m48t59-chips-2nd-rev.patch
fb-convert-lock-unlock_kernel-into-local-fb-mutex.patch
neofb-reduce-panning-function.patch
fbdev-kconfig-update.patch
fbdev-kconfig-update-fix.patch
neofb-kill-some-redundant-code.patch

