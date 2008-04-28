From: akpm@linux-foundation.org
Subject: - arkfb-add-option-mode_option.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:58:07 -0700
Message-ID: <200804282158.m3SLw7bN018465@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45740 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965271AbYD1V6J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:58:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     arkfb: add option mode_option
has been removed from the -mm tree.  Its filename was
     arkfb-add-option-mode_option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arkfb: add option mode_option
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Add the option "mode_option".  This is one step toward changing all fb
drivers to have common "mode_option" parameter.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/arkfb.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN drivers/video/arkfb.c~arkfb-add-option-mode_option drivers/video/arkfb.c
--- a/drivers/video/arkfb.c~arkfb-add-option-mode_option
+++ a/drivers/video/arkfb.c
@@ -101,7 +101,7 @@ static const struct svga_timing_regs ark
 
 /* Module parameters */
 
-static char *mode = "640x480-8@60";
+static char *mode_option __devinitdata = "640x480-8@60";
 
 #ifdef CONFIG_MTRR
 static int mtrr = 1;
@@ -111,8 +111,10 @@ MODULE_AUTHOR("(c) 2007 Ondrej Zajicek <
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("fbdev driver for ARK 2000PV");
 
-module_param(mode, charp, 0444);
-MODULE_PARM_DESC(mode, "Default video mode ('640x480-8@60', etc)");
+module_param(mode_option, charp, 0444);
+MODULE_PARM_DESC(mode_option, "Default video mode ('640x480-8@60', etc)");
+module_param_named(mode, mode_option, charp, 0444);
+MODULE_PARM_DESC(mode, "Default video mode ('640x480-8@60', etc) (deprecated)");
 
 #ifdef CONFIG_MTRR
 module_param(mtrr, int, 0444);
@@ -999,10 +1001,10 @@ static int __devinit ark_pci_probe(struc
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
 
@@ -1190,7 +1192,7 @@ static int __init arkfb_init(void)
 		return -ENODEV;
 
 	if (option && *option)
-		mode = option;
+		mode_option = option;
 #endif
 
 	pr_debug("arkfb: initializing\n");
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch

