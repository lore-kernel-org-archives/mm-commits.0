From: akpm@linux-foundation.org
Subject: + vt8623fb-change-option-mode-to-mode_option.patch added to -mm tree
Date: Thu, 14 Feb 2008 13:59:48 -0800
Message-ID: <200802142159.m1ELxmZ5005084@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44221 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755401AbYBNV7u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 16:59:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@pol.net


The patch titled
     vt8623fb: change option mode to mode_option
has been added to the -mm tree.  Its filename is
     vt8623fb-change-option-mode-to-mode_option.patch

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

pm2fb-change-option-mode-to-mode_option.patch
tridentfb-change-option-mode-to-mode_option.patch
pm3fb-change-option-mode-to-mode_option.patch
update-modedbtxt-documentation-about-mode_option-parameter-change.patch
vt8623fb-change-option-mode-to-mode_option.patch
