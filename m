From: akpm@linux-foundation.org
Subject: + tridentfb-change-option-mode-to-mode_option.patch added to -mm tree
Date: Thu, 14 Feb 2008 13:56:55 -0800
Message-ID: <200802142156.m1ELuten004927@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38776 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752827AbYBNV5c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 16:57:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@pol.net, miki@dds.nl


The patch titled
     tridentfb: change option mode to mode_option
has been added to the -mm tree.  Its filename is
     tridentfb-change-option-mode-to-mode_option.patch

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
Subject: tridentfb: change option mode to mode_option
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Change the option "mode_option" into "mode".  It also adds __init attribute to
tridentfb_setup function.

This is one step toward changing all fb drivers to have common "mode_option"
parameter.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Alain Kalker <miki@dds.nl>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tridentfb.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN drivers/video/tridentfb.c~tridentfb-change-option-mode-to-mode_option drivers/video/tridentfb.c
--- a/drivers/video/tridentfb.c~tridentfb-change-option-mode-to-mode_option
+++ a/drivers/video/tridentfb.c
@@ -58,7 +58,7 @@ static int displaytype;
 /* defaults which are normally overriden by user values */
 
 /* video mode */
-static char *mode = "640x480";
+static char *mode_option __devinitdata = "640x480";
 static int bpp = 8;
 
 static int noaccel;
@@ -73,7 +73,8 @@ static int memsize;
 static int memdiff;
 static int nativex;
 
-module_param(mode, charp, 0);
+module_param(mode_option, charp, 0);
+MODULE_PARM_DESC(mode_option, "Initial video mode e.g. '648x480-8@60'");
 module_param(bpp, int, 0);
 module_param(center, int, 0);
 module_param(stretch, int, 0);
@@ -1286,7 +1287,8 @@ static int __devinit trident_pci_probe(s
 #endif
 	fb_info.pseudo_palette = pseudo_pal;
 
-	if (!fb_find_mode(&default_var, &fb_info, mode, NULL, 0, NULL, bpp)) {
+	if (!fb_find_mode(&default_var, &fb_info,
+			  mode_option, NULL, 0, NULL, bpp)) {
 		err = -EINVAL;
 		goto out_unmap;
 	}
@@ -1366,7 +1368,7 @@ static struct pci_driver tridentfb_pci_d
  *	video=trident:800x600,bpp=16,noaccel
  */
 #ifndef MODULE
-static int tridentfb_setup(char *options)
+static int __init tridentfb_setup(char *options)
 {
 	char *opt;
 	if (!options || !*options)
@@ -1393,7 +1395,7 @@ static int tridentfb_setup(char *options
 		else if (!strncmp(opt, "nativex=", 8))
 			nativex = simple_strtoul(opt + 8, NULL, 0);
 		else
-			mode = opt;
+			mode_option = opt;
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

pm2fb-change-option-mode-to-mode_option.patch
tridentfb-change-option-mode-to-mode_option.patch
