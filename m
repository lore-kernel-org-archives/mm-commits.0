From: akpm@linux-foundation.org
Subject: [merged] cirrusfb-use-5-6-5-rgb-for-16bpp-mode.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:42:34 -0700
Message-ID: <200904011842.n31IgY6L009746@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36387 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757924AbZDAT1b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:27:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, arthur.marsh@internode.on.net, geert.uytterhoeven@gmail.com, mm-commits@vger.kernel.org


The patch titled
     cirrusfb: use 5-6-5 RGB for 16bpp mode
has been removed from the -mm tree.  Its filename was
     cirrusfb-use-5-6-5-rgb-for-16bpp-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
tdfxfb-move-i2c-functionality-into-the-tdfxfb.patch
tdfxfb-make-use-of-ddc-information-about-connected-monitor.patch

