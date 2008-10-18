From: akpm@linux-foundation.org
Subject: - cirrusfb-remove-24-bpp-mode.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:17:12 -0700
Message-ID: <200810182317.m9INHCrB029036@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33861 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751792AbYJRXRO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:17:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     cirrusfb: remove 24 bpp mode
has been removed from the -mm tree.  Its filename was
     cirrusfb-remove-24-bpp-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cirrusfb: remove 24 bpp mode
From: Krzysztof Helt <krzysztof.h1@wp.pl>

The 24 bpp mode is not implemented.  Disallow it in the
cirrusfb_check_var() and remove it from checks.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN drivers/video/cirrusfb.c~cirrusfb-remove-24-bpp-mode drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~cirrusfb-remove-24-bpp-mode
+++ a/drivers/video/cirrusfb.c
@@ -638,7 +638,6 @@ static int cirrusfb_check_var(struct fb_
 		break;		/* 8 pixel per byte, only 1/4th of mem usable */
 	case 8:
 	case 16:
-	case 24:
 	case 32:
 		break;		/* 1 pixel == 1 byte */
 	default:
@@ -713,7 +712,6 @@ static int cirrusfb_check_var(struct fb_
 		var->blue.length = 5;
 		break;
 
-	case 24:
 	case 32:
 		if (isPReP) {
 			var->red.offset = 8;
@@ -782,7 +780,6 @@ static int cirrusfb_decode_var(const str
 		break;
 
 	case 16:
-	case 24:
 	case 32:
 		info->fix.line_length = var->xres_virtual * maxclockidx;
 		info->fix.visual = FB_VISUAL_DIRECTCOLOR;
@@ -1360,7 +1357,7 @@ static int cirrusfb_set_par_foo(struct f
 	 */
 
 	else if (var->bits_per_pixel == 32) {
-		DPRINTK("cirrusfb: preparing for 24/32 bit deep display\n");
+		DPRINTK("cirrusfb: preparing for 32 bit deep display\n");
 		switch (cinfo->btype) {
 		case BT_SD64:
 			/* Extended Sequencer Mode: 256c col. mode */
@@ -2233,7 +2230,7 @@ static int cirrusfb_set_fbinfo(struct fb
 	if (cinfo->btype == BT_GD5480) {
 		if (var->bits_per_pixel == 16)
 			info->screen_base += 1 * MB_;
-		if (var->bits_per_pixel == 24 || var->bits_per_pixel == 32)
+		if (var->bits_per_pixel == 32)
 			info->screen_base += 2 * MB_;
 	}
 
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
fb-convert-lock-unlock_kernel-into-local-fb-mutex.patch

