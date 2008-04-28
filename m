From: akpm@linux-foundation.org
Subject: - vt8623fb-change-option-mode-to-mode_option.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:58:05 -0700
Message-ID: <200804282158.m3SLw5xO018462@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55898 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936046AbYD1V6H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:58:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     vt8623fb: change option mode to mode_option
has been removed from the -mm tree.  Its filename was
     vt8623fb-change-option-mode-to-mode_option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vt8623fb: change option mode to mode_option
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Change the option "mode" into "mode_option".

This is one step toward changing all fb drivers to have common "mode_option"
parameter.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/vt8623fb.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/video/vt8623fb.c~vt8623fb-change-option-mode-to-mode_option drivers/video/vt8623fb.c
--- a/drivers/video/vt8623fb.c~vt8623fb-change-option-mode-to-mode_option
+++ a/drivers/video/vt8623fb.c
@@ -100,7 +100,7 @@ static struct svga_timing_regs vt8623_ti
 
 /* Module parameters */
 
-static char *mode = "640x480-8@60";
+static char *mode_option = "640x480-8@60";
 
 #ifdef CONFIG_MTRR
 static int mtrr = 1;
@@ -110,8 +110,8 @@ MODULE_AUTHOR("(c) 2006 Ondrej Zajicek <
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("fbdev driver for integrated graphics core in VIA VT8623 [CLE266]");
 
-module_param(mode, charp, 0644);
-MODULE_PARM_DESC(mode, "Default video mode ('640x480-8@60', etc)");
+module_param(mode_option, charp, 0644);
+MODULE_PARM_DESC(mode_option, "Default video mode ('640x480-8@60', etc)");
 
 #ifdef CONFIG_MTRR
 module_param(mtrr, int, 0444);
@@ -722,10 +722,10 @@ static int __devinit vt8623_pci_probe(st
 
 	/* Prepare startup mode */
 
-	rc = fb_find_mode(&(info->var), info, mode, NULL, 0, NULL, 8);
+	rc = fb_find_mode(&(info->var), info, mode_option, NULL, 0, NULL, 8);
 	if (! ((rc == 1) || (rc == 2))) {
 		rc = -EINVAL;
-		dev_err(&(dev->dev), "mode %s not found\n", mode);
+		dev_err(&(dev->dev), "mode %s not found\n", mode_option);
 		goto err_find_mode;
 	}
 
@@ -913,7 +913,7 @@ static int __init vt8623fb_init(void)
 		return -ENODEV;
 
 	if (option && *option)
-		mode = option;
+		mode_option = option;
 #endif
 
 	pr_debug("vt8623fb: initializing\n");
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch

