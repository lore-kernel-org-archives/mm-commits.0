From: akpm@linux-foundation.org
Subject: + drm-dont-use-own-implementation-of-atoi.patch added to -mm tree
Date: Fri, 22 Jan 2010 14:54:50 -0800
Message-ID: <201001222254.o0MMsoNk000996@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40088 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755198Ab0AVWzB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Jan 2010 17:55:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ext-andriy.shevchenko@nokia.com, airlied@linux.ie, jbarnes@virtuousgeek.org


The patch titled
     drivers/gpu/drm/drm_fb_helper.c: don't use private implementation of atoi()
has been added to the -mm tree.  Its filename is
     drm-dont-use-own-implementation-of-atoi.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/gpu/drm/drm_fb_helper.c: don't use private implementation of atoi()
From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Kernel has simple_strtol() which would be used as atoi().

This is quite the same fix as in 2cb96f86628d6e97fcbda5fe4d8d74876239834c
("fbdev: drop custom atoi from drivers/video/modedb.c") because code in
drivers/gpu/drm/drm_fb_helper.c is based on drivers/video/modedb.c.

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_fb_helper.c |   24 +++++-------------------
 1 file changed, 5 insertions(+), 19 deletions(-)

diff -puN drivers/gpu/drm/drm_fb_helper.c~drm-dont-use-own-implementation-of-atoi drivers/gpu/drm/drm_fb_helper.c
--- a/drivers/gpu/drm/drm_fb_helper.c~drm-dont-use-own-implementation-of-atoi
+++ a/drivers/gpu/drm/drm_fb_helper.c
@@ -27,6 +27,7 @@
  *      Dave Airlie <airlied@linux.ie>
  *      Jesse Barnes <jesse.barnes@intel.com>
  */
+#include <linux/kernel.h>
 #include <linux/sysrq.h>
 #include <linux/fb.h>
 #include <linux/kgdb.h>
@@ -51,21 +52,6 @@ int drm_fb_helper_add_connector(struct d
 }
 EXPORT_SYMBOL(drm_fb_helper_add_connector);
 
-static int my_atoi(const char *name)
-{
-	int val = 0;
-
-	for (;; name++) {
-		switch (*name) {
-		case '0' ... '9':
-			val = 10*val+(*name-'0');
-			break;
-		default:
-			return val;
-		}
-	}
-}
-
 /**
  * drm_fb_helper_connector_parse_command_line - parse command line for connector
  * @connector - connector to parse line for
@@ -112,7 +98,7 @@ static bool drm_fb_helper_connector_pars
 			namelen = i;
 			if (!refresh_specified && !bpp_specified &&
 			    !yres_specified) {
-				refresh = my_atoi(&name[i+1]);
+				refresh = simple_strtol(&name[i+1], NULL, 10);
 				refresh_specified = 1;
 				if (cvt || rb)
 					cvt = 0;
@@ -122,7 +108,7 @@ static bool drm_fb_helper_connector_pars
 		case '-':
 			namelen = i;
 			if (!bpp_specified && !yres_specified) {
-				bpp = my_atoi(&name[i+1]);
+				bpp = simple_strtol(&name[i+1], NULL, 10);
 				bpp_specified = 1;
 				if (cvt || rb)
 					cvt = 0;
@@ -131,7 +117,7 @@ static bool drm_fb_helper_connector_pars
 			break;
 		case 'x':
 			if (!yres_specified) {
-				yres = my_atoi(&name[i+1]);
+				yres = simple_strtol(&name[i+1], NULL, 10);
 				yres_specified = 1;
 			} else
 				goto done;
@@ -171,7 +157,7 @@ static bool drm_fb_helper_connector_pars
 		}
 	}
 	if (i < 0 && yres_specified) {
-		xres = my_atoi(name);
+		xres = simple_strtol(name, NULL, 10);
 		res_specified = 1;
 	}
 done:
_

Patches currently in -mm which might be from ext-andriy.shevchenko@nokia.com are

linux-next.patch
arch-x86-mm-gupc-fix-minor-spelling-error-in-comments.patch
drm-dont-use-own-implementation-of-atoi.patch
staging-dont-use-custom-implementation-of-atoi.patch

