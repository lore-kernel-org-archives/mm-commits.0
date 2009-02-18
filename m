From: akpm@linux-foundation.org
Subject: + cirrusfb-use-5-6-5-rgb-for-16bpp-mode.patch added to -mm tree
Date: Tue, 17 Feb 2009 16:14:47 -0800
Message-ID: <200902180014.n1I0ElUU029506@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34426 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751342AbZBRAPZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Feb 2009 19:15:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, arthur.marsh@internode.on.net, geert.uytterhoeven@gmail.com


The patch titled
     cirrusfb: use 5-6-5 RGB for 16bpp mode
has been added to the -mm tree.  Its filename is
     cirrusfb-use-5-6-5-rgb-for-16bpp-mode.patch

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
Subject: cirrusfb: use 5-6-5 RGB for 16bpp mode
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Use the 5-6-5 RGB mode instead of the 5-5-5 mode at 16bpp depth.

It fixes colors in the 16bpp modes on Cirrus Laguna chips.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Geert Uytterhoeven <geert.uytterhoeven@gmail.com>
Cc: Arthur Marsh <arthur.marsh@internode.on.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/video/cirrusfb.c~cirrusfb-use-5-6-5-rgb-for-16bpp-mode drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~cirrusfb-use-5-6-5-rgb-for-16bpp-mode
+++ a/drivers/video/cirrusfb.c
@@ -499,12 +499,12 @@ static int cirrusfb_check_var(struct fb_
 			var->green.offset = -3;
 			var->blue.offset = 8;
 		} else {
-			var->red.offset = 10;
+			var->red.offset = 11;
 			var->green.offset = 5;
 			var->blue.offset = 0;
 		}
 		var->red.length = 5;
-		var->green.length = 5;
+		var->green.length = 6;
 		var->blue.length = 5;
 		break;
 
@@ -1180,7 +1180,7 @@ static int cirrusfb_set_par_foo(struct f
 		/* pixel mask: pass-through all planes */
 		WGen(cinfo, VGA_PEL_MSK, 0xff);
 #ifdef CONFIG_PCI
-		WHDR(cinfo, 0xc0);	/* Copy Xbh */
+		WHDR(cinfo, 0xc1);	/* Copy Xbh */
 #elif defined(CONFIG_ZORRO)
 		/* FIXME: CONFIG_PCI and CONFIG_ZORRO may be defined both */
 		WHDR(cinfo, 0xa0);	/* hidden dac reg: nothing special */
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

linux-next.patch
fbdev-drm-fix-kconfig-submenu-mess-in-graphics-support.patch
cirrusfb-fix-laguna-chipset-memory-detection-and-clock-setting.patch
cirrusfb-add-laguna-additional-overflow-register.patch
cirrusfb-add-mmio-registers-for-laguna-chipsets.patch
cirrusfb-do-not-calculate-line-length-twice.patch
cirrusfb-use-5-6-5-rgb-for-16bpp-mode.patch
drivers-video-sgivwfbc-fix-memory-leaks-in-removal-path.patch
tdfxfb-fix-memory-leaks-in-removal-path.patch
tridentfb-fix-memory-leaks-in-removal-path.patch
vfb-fix-memory-leaks-in-removal-path.patch
sstfb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
stifb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
valkyriefb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
68328fb-fix-cmap-memory-leaks.patch
amba-clcd-fix-cmap-memory-leaks.patch
amifb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
asiliantfb-fix-cmap-memory-leaks.patch

