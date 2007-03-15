From: akpm@linux-foundation.org
Subject: + bool-fbdevs-must-depend-on-fb-=-y.patch added to -mm tree
Date: Thu, 15 Mar 2007 11:48:18 -0800
Message-ID: <200703151848.l2FImKfd023237@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35341 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812AbXCOSsy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 14:48:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com, adaplas@pol.net, viro@zeniv.linux.org.uk


The patch titled
     bool fbdevs must depend on FB = y
has been added to the -mm tree.  Its filename is
     bool-fbdevs-must-depend-on-fb-=-y.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: bool fbdevs must depend on FB = y
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Frame buffer device drivers that cannot be built as modules must depend on
`FB = y'.  Correct the 3 remaining offenders.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/video/Kconfig~bool-fbdevs-must-depend-on-fb-=-y drivers/video/Kconfig
--- a/drivers/video/Kconfig~bool-fbdevs-must-depend-on-fb-=-y
+++ a/drivers/video/Kconfig
@@ -1320,7 +1320,7 @@ config FB_AU1100
 
 config FB_AU1200
 	bool "Au1200 LCD Driver"
-	depends on FB && MIPS && SOC_AU1200
+	depends on (FB = y) && MIPS && SOC_AU1200
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
@@ -1470,7 +1470,7 @@ config FB_G364
 
 config FB_68328
 	bool "Motorola 68328 native frame buffer support"
-	depends on FB && (M68328 || M68EZ328 || M68VZ328)
+	depends on (FB = y) && (M68328 || M68EZ328 || M68VZ328)
  	select FB_CFB_FILLRECT
  	select FB_CFB_COPYAREA
  	select FB_CFB_IMAGEBLIT
@@ -1616,7 +1616,7 @@ config FB_IBM_GXT4500
 
 config FB_PS3
 	bool "PS3 GPU framebuffer driver"
-	depends on FB && PS3_PS3AV
+	depends on (FB = y) && PS3_PS3AV
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

bool-fbdevs-must-depend-on-fb-=-y.patch
ps3fb-thread-updates.patch
ps3av-thread-updates.patch
ps3fb-kill-superfluous-zero-initializations.patch
ps3fb-atomic-fixes.patch
ps3av-misc-updates.patch
fbdev-avoid-vertical-overflow-when-making-space-for-the-logo.patch
fbdev-fb_do_show_logo-updates.patch
fbdev-correct-image-offsets-when-rotating-logo.patch
