From: akpm@linux-foundation.org
Subject: - tridentfb-y-panning-fixes.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:31:31 -0700
Message-ID: <200807242331.m6ONVVTj011639@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33115 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756502AbYGXXbd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:31:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     tridentfb: y-panning fixes
has been removed from the -mm tree.  Its filename was
     tridentfb-y-panning-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tridentfb: y-panning fixes
From: Krzysztof Helt <krzysztof.h1@wp.pl>

The Trident cards uses only 20-bit address of screen start in double
words.  This allows addressing for only 4MB of video memory so check this.

Also remove some redundant checks and assignments.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tridentfb.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN drivers/video/tridentfb.c~tridentfb-y-panning-fixes drivers/video/tridentfb.c
--- a/drivers/video/tridentfb.c~tridentfb-y-panning-fixes
+++ a/drivers/video/tridentfb.c
@@ -870,8 +870,10 @@ static int tridentfb_check_var(struct fb
 		line_length = var->xres_virtual * bpp / 8;
 	}
 
-	if (var->yres > var->yres_virtual)
-		var->yres_virtual = var->yres;
+	/* datasheet specifies how to set panning only up to 4 MB */
+	if (line_length * (var->yres_virtual - var->yres) > (4 << 20))
+		var->yres_virtual = ((4 << 20) / line_length) + var->yres;
+
 	if (line_length * var->yres_virtual > info->fix.smem_len)
 		return -EINVAL;
 
@@ -944,8 +946,6 @@ static int tridentfb_pan_display(struct 
 	debug("enter\n");
 	offset = (var->xoffset + (var->yoffset * var->xres_virtual))
 		* var->bits_per_pixel / 32;
-	info->var.xoffset = var->xoffset;
-	info->var.yoffset = var->yoffset;
 	set_screen_start(par, offset);
 	debug("exit\n");
 	return 0;
@@ -1225,7 +1225,6 @@ static int tridentfb_setcolreg(unsigned 
 				((blue & 0xFF00) >> 8);
 	}
 
-/* 	debug("exit\n"); */
 	return 0;
 }
 
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch

