From: akpm@linux-foundation.org
Subject: [merged] fbdev-drop-custom-atoi-from-drivers-video-modedbc.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:35:37 -0800
Message-ID: <200912162035.nBGKZbgG013109@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55667 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935400AbZLPUfr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:35:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ext-andriy.shevchenko@nokia.com, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     fbdev: drop custom atoi from drivers/video/modedb.c
has been removed from the -mm tree.  Its filename was
     fbdev-drop-custom-atoi-from-drivers-video-modedbc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: drop custom atoi from drivers/video/modedb.c
From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Kernel has simple_strtol() implementation which could be used as atoi().

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/modedb.c |   24 +++++-------------------
 1 file changed, 5 insertions(+), 19 deletions(-)

diff -puN drivers/video/modedb.c~fbdev-drop-custom-atoi-from-drivers-video-modedbc drivers/video/modedb.c
--- a/drivers/video/modedb.c~fbdev-drop-custom-atoi-from-drivers-video-modedbc
+++ a/drivers/video/modedb.c
@@ -13,6 +13,7 @@
 
 #include <linux/module.h>
 #include <linux/fb.h>
+#include <linux/kernel.h>
 
 #undef DEBUG
 
@@ -402,21 +403,6 @@ const struct fb_videomode vesa_modes[] =
 EXPORT_SYMBOL(vesa_modes);
 #endif /* CONFIG_FB_MODE_HELPERS */
 
-static int my_atoi(const char *name)
-{
-    int val = 0;
-
-    for (;; name++) {
-	switch (*name) {
-	    case '0' ... '9':
-		val = 10*val+(*name-'0');
-		break;
-	    default:
-		return val;
-	}
-    }
-}
-
 /**
  *	fb_try_mode - test a video mode
  *	@var: frame buffer user defined part of display
@@ -539,7 +525,7 @@ int fb_find_mode(struct fb_var_screeninf
 		    namelen = i;
 		    if (!refresh_specified && !bpp_specified &&
 			!yres_specified) {
-			refresh = my_atoi(&name[i+1]);
+			refresh = simple_strtol(&name[i+1], NULL, 10);
 			refresh_specified = 1;
 			if (cvt || rb)
 			    cvt = 0;
@@ -549,7 +535,7 @@ int fb_find_mode(struct fb_var_screeninf
 		case '-':
 		    namelen = i;
 		    if (!bpp_specified && !yres_specified) {
-			bpp = my_atoi(&name[i+1]);
+			bpp = simple_strtol(&name[i+1], NULL, 10);
 			bpp_specified = 1;
 			if (cvt || rb)
 			    cvt = 0;
@@ -558,7 +544,7 @@ int fb_find_mode(struct fb_var_screeninf
 		    break;
 		case 'x':
 		    if (!yres_specified) {
-			yres = my_atoi(&name[i+1]);
+			yres = simple_strtol(&name[i+1], NULL, 10);
 			yres_specified = 1;
 		    } else
 			goto done;
@@ -586,7 +572,7 @@ int fb_find_mode(struct fb_var_screeninf
 	    }
 	}
 	if (i < 0 && yres_specified) {
-	    xres = my_atoi(name);
+	    xres = simple_strtol(name, NULL, 10);
 	    res_specified = 1;
 	}
 done:
_

Patches currently in -mm which might be from ext-andriy.shevchenko@nokia.com are

origin.patch

