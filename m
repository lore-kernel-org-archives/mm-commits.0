From: akpm@linux-foundation.org
Subject: - neofb-kill-some-redundant-code.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:16:57 -0700
Message-ID: <200810182316.m9INGvC8028917@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57171 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751634AbYJRXQ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:16:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     neofb: kill some redundant code
has been removed from the -mm tree.  Its filename was
     neofb-kill-some-redundant-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
fb-convert-lock-unlock_kernel-into-local-fb-mutex.patch

