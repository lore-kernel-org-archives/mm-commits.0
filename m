From: akpm@linux-foundation.org
Subject: + fbdev-section-cleanup-in-vfb.patch added to -mm tree
Date: Wed, 31 Mar 2010 14:44:43 -0700
Message-ID: <201003312144.o2VLihsh010461@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45960 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932641Ab0CaVpL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Mar 2010 17:45:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: henne@nachtwindheim.de, arnaud.patard@rtp-net.org, krzysztof.h1@poczta.fm


The patch titled
     fbdev: vfb: fix section mismatches
has been added to the -mm tree.  Its filename is
     fbdev-section-cleanup-in-vfb.patch

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
Subject: fbdev: vfb: fix section mismatches
From: Henrik Kretzschmar <henne@nachtwindheim.de>

Fix section mismatches in the vfb driver.

WARNING: drivers/video/vfb.o(.devinit.text+0xf8): Section mismatch in reference from the function vfb_probe() to the variable .init.data:vfb_default
The function __devinit vfb_probe() references
a variable __initdata vfb_default.
If vfb_default is only used by vfb_probe then
annotate vfb_default with a matching annotation.

WARNING: drivers/video/vfb.o(.devinit.text+0x114): Section mismatch in reference from the function vfb_probe() to the variable .init.data:vfb_fix
The function __devinit vfb_probe() references
a variable __initdata vfb_fix.
If vfb_fix is only used by vfb_probe then
annotate vfb_fix with a matching annotation.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/vfb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/vfb.c~fbdev-section-cleanup-in-vfb drivers/video/vfb.c
--- a/drivers/video/vfb.c~fbdev-section-cleanup-in-vfb
+++ a/drivers/video/vfb.c
@@ -78,7 +78,7 @@ static void rvfree(void *mem, unsigned l
 	vfree(mem);
 }
 
-static struct fb_var_screeninfo vfb_default __initdata = {
+static struct fb_var_screeninfo vfb_default __devinitdata = {
 	.xres =		640,
 	.yres =		480,
 	.xres_virtual =	640,
@@ -100,7 +100,7 @@ static struct fb_var_screeninfo vfb_defa
       	.vmode =	FB_VMODE_NONINTERLACED,
 };
 
-static struct fb_fix_screeninfo vfb_fix __initdata = {
+static struct fb_fix_screeninfo vfb_fix __devinitdata = {
 	.id =		"Virtual FB",
 	.type =		FB_TYPE_PACKED_PIXELS,
 	.visual =	FB_VISUAL_PSEUDOCOLOR,
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

