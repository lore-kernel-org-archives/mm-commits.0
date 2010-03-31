From: akpm@linux-foundation.org
Subject: + fbdev-section-cleanup-in-vesafb.patch added to -mm tree
Date: Wed, 31 Mar 2010 14:44:41 -0700
Message-ID: <201003312144.o2VLifB0010456@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47228 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932645Ab0CaVpS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Mar 2010 17:45:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: henne@nachtwindheim.de, arnaud.patard@rtp-net.org, pjones@redhat.com


The patch titled
     fbdev: vesafb: fix section mismatches
has been added to the -mm tree.  Its filename is
     fbdev-section-cleanup-in-vesafb.patch

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
Subject: fbdev: vesafb: fix section mismatches
From: Henrik Kretzschmar <henne@nachtwindheim.de>

Fix section mismatches in the vesafb driver.

WARNING: drivers/video/built-in.o(.devinit.text+0x19495): Section mismatch in reference from the function vesafb_probe() to the variable .init.data:vesafb_fix
The function __devinit vesafb_probe() references
a variable __initdata vesafb_fix.
If vesafb_fix is only used by vesafb_probe then
annotate vesafb_fix with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x194a5): Section mismatch in reference from the function vesafb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit vesafb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by vesafb_probe then
annotate (unknown) with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x194d5): Section mismatch in reference from the function vesafb_probe() to the variable .init.data:vesafb_defined
The function __devinit vesafb_probe() references
a variable __initdata vesafb_defined.
If vesafb_defined is only used by vesafb_probe then
annotate vesafb_defined with a matching annotation.

...
fbdev: section cleanup in vesafb

This patch cleans up the sections in the vesafb driver.

WARNING: drivers/video/built-in.o(.devinit.text+0x19495): Section mismatch in reference from the function vesafb_probe() to the variable .init.data:vesafb_fix
The function __devinit vesafb_probe() references
a variable __initdata vesafb_fix.
If vesafb_fix is only used by vesafb_probe then
annotate vesafb_fix with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x194a5): Section mismatch in reference from the function vesafb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit vesafb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by vesafb_probe then
annotate (unknown) with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x194d5): Section mismatch in reference from the function vesafb_probe() to the variable .init.data:vesafb_defined
The function __devinit vesafb_probe() references
a variable __initdata vesafb_defined.
If vesafb_defined is only used by vesafb_probe then
annotate vesafb_defined with a matching annotation.

...

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: Peter Jones <pjones@redhat.com>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/vesafb.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/video/vesafb.c~fbdev-section-cleanup-in-vesafb drivers/video/vesafb.c
--- a/drivers/video/vesafb.c~fbdev-section-cleanup-in-vesafb
+++ a/drivers/video/vesafb.c
@@ -29,7 +29,7 @@
 
 /* --------------------------------------------------------------------- */
 
-static struct fb_var_screeninfo vesafb_defined __initdata = {
+static struct fb_var_screeninfo vesafb_defined __devinitdata = {
 	.activate	= FB_ACTIVATE_NOW,
 	.height		= -1,
 	.width		= -1,
@@ -40,7 +40,7 @@ static struct fb_var_screeninfo vesafb_d
 	.vmode		= FB_VMODE_NONINTERLACED,
 };
 
-static struct fb_fix_screeninfo vesafb_fix __initdata = {
+static struct fb_fix_screeninfo vesafb_fix __devinitdata = {
 	.id	= "VESA VGA",
 	.type	= FB_TYPE_PACKED_PIXELS,
 	.accel	= FB_ACCEL_NONE,
@@ -48,8 +48,8 @@ static struct fb_fix_screeninfo vesafb_f
 
 static int   inverse    __read_mostly;
 static int   mtrr       __read_mostly;		/* disable mtrr */
-static int   vram_remap __initdata;		/* Set amount of memory to be used */
-static int   vram_total __initdata;		/* Set total amount of memory */
+static int   vram_remap __devinitdata;		/* Set amount of memory to be used */
+static int   vram_total __devinitdata;		/* Set total amount of memory */
 static int   pmi_setpal __read_mostly = 1;	/* pmi for palette changes ??? */
 static int   ypan       __read_mostly;		/* 0..nothing, 1..ypan, 2..ywrap */
 static void  (*pmi_start)(void) __read_mostly;
_

Patches currently in -mm which might be from henne@nachtwindheim.de are

linux-next.patch
fbdev-section-cleanup-in-arcfb.patch
fbdev-section-cleanup-in-efifb.patch
fbdev-section-cleanup-in-hgafb.patch
fbdev-section-cleanup-in-vesafb.patch
fbdev-section-cleanup-in-vfb.patch
fbdev-section-cleanup-in-vga16fb.patch
fbdev-section-cleanup-in-w100fb.patch
auxdisplay-section-cleanup-in-cfag12864bfb-driver.patch

