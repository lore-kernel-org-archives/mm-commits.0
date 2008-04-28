From: akpm@linux-foundation.org
Subject: - s3fb-add-option-mode_option.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:58:09 -0700
Message-ID: <200804282158.m3SLw9Zu018468@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60056 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965290AbYD1V6L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:58:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     s3fb: add option mode_option
has been removed from the -mm tree.  Its filename was
     s3fb-add-option-mode_option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: s3fb: add option mode_option
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Add the option "mode_option".  It also moves mtrr variable to devinitdata
section.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3fb.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff -puN drivers/video/s3fb.c~s3fb-add-option-mode_option drivers/video/s3fb.c
--- a/drivers/video/s3fb.c~s3fb-add-option-mode_option
+++ a/drivers/video/s3fb.c
@@ -132,10 +132,10 @@ static const struct svga_timing_regs s3_
 /* Module parameters */
 
 
-static char *mode = "640x480-8@60";
+static char *mode_option __devinitdata = "640x480-8@60";
 
 #ifdef CONFIG_MTRR
-static int mtrr = 1;
+static int mtrr __devinitdata = 1;
 #endif
 
 static int fasttext = 1;
@@ -145,8 +145,10 @@ MODULE_AUTHOR("(c) 2006-2007 Ondrej Zaji
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("fbdev driver for S3 Trio/Virge");
 
-module_param(mode, charp, 0444);
-MODULE_PARM_DESC(mode, "Default video mode ('640x480-8@60', etc)");
+module_param(mode_option, charp, 0444);
+MODULE_PARM_DESC(mode_option, "Default video mode ('640x480-8@60', etc)");
+module_param_named(mode, mode_option, charp, 0444);
+MODULE_PARM_DESC(mode, "Default video mode ('640x480-8@60', etc) (deprecated)");
 
 #ifdef CONFIG_MTRR
 module_param(mtrr, int, 0444);
@@ -960,10 +962,10 @@ static int __devinit s3_pci_probe(struct
 	info->pseudo_palette = (void*) (par->pseudo_palette);
 
 	/* Prepare startup mode */
-	rc = fb_find_mode(&(info->var), info, mode, NULL, 0, NULL, 8);
+	rc = fb_find_mode(&(info->var), info, mode_option, NULL, 0, NULL, 8);
 	if (! ((rc == 1) || (rc == 2))) {
 		rc = -EINVAL;
-		dev_err(&(dev->dev), "mode %s not found\n", mode);
+		dev_err(&(dev->dev), "mode %s not found\n", mode_option);
 		goto err_find_mode;
 	}
 
@@ -1168,7 +1170,7 @@ static int  __init s3fb_setup(char *opti
 		else if (!strncmp(opt, "fasttext:", 9))
 			fasttext = simple_strtoul(opt + 9, NULL, 0);
 		else
-			mode = opt;
+			mode_option = opt;
 	}
 
 	return 0;
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch

