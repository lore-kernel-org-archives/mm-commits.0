From: akpm@linux-foundation.org
Subject: + pm2fb-change-option-mode-to-mode_option.patch added to -mm tree
Date: Thu, 14 Feb 2008 13:56:52 -0800
Message-ID: <200802142156.m1ELuqQq004922@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38569 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752827AbYBNV5b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 16:57:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@pol.net, miki@dds.nl


The patch titled
     pm2fb: change option mode to mode_option
has been added to the -mm tree.  Its filename is
     pm2fb-change-option-mode-to-mode_option.patch

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
Subject: pm2fb: change option mode to mode_option
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Change the option "mode_option" into "mode".

This is one step toward changing all fb drivers to have common "mode_option"
parameter.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Alain Kalker <miki@dds.nl>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pm2fb.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/video/pm2fb.c~pm2fb-change-option-mode-to-mode_option drivers/video/pm2fb.c
--- a/drivers/video/pm2fb.c~pm2fb-change-option-mode-to-mode_option
+++ a/drivers/video/pm2fb.c
@@ -67,7 +67,7 @@
  * Driver data
  */
 static int hwcursor = 1;
-static char *mode __devinitdata;
+static char *mode_option __devinitdata;
 
 /*
  * The XFree GLINT driver will (I think to implement hardware cursor
@@ -1680,10 +1680,10 @@ static int __devinit pm2fb_probe(struct 
 		info->pixmap.scan_align = 1;
 	}
 
-	if (!mode)
-		mode = "640x480@60";
+	if (!mode_option)
+		mode_option = "640x480@60";
 
-	err = fb_find_mode(&info->var, info, mode, NULL, 0, NULL, 8);
+	err = fb_find_mode(&info->var, info, mode_option, NULL, 0, NULL, 8);
 	if (!err || err == 4)
 		info->var = pm2fb_var;
 
@@ -1797,7 +1797,7 @@ static int __init pm2fb_setup(char *opti
 		else if (!strncmp(this_opt, "noaccel", 7))
 			noaccel = 1;
 		else
-			mode = this_opt;
+			mode_option = this_opt;
 	}
 	return 0;
 }
@@ -1833,8 +1833,8 @@ static void __exit pm2fb_exit(void)
 #ifdef MODULE
 module_exit(pm2fb_exit);
 
-module_param(mode, charp, 0);
-MODULE_PARM_DESC(mode, "Preferred video mode e.g. '648x480-8@60'");
+module_param(mode_option, charp, 0);
+MODULE_PARM_DESC(mode_option, "Initial video mode e.g. '648x480-8@60'");
 module_param(lowhsync, bool, 0);
 MODULE_PARM_DESC(lowhsync, "Force horizontal sync low regardless of mode");
 module_param(lowvsync, bool, 0);
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

pm2fb-change-option-mode-to-mode_option.patch
tridentfb-change-option-mode-to-mode_option.patch
