From: akpm@linux-foundation.org
Subject: + tridentfb-improve-check_var-function.patch added to -mm tree
Date: Mon, 12 May 2008 22:46:46 -0700
Message-ID: <200805130546.m4D5kktf027368@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46188 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754719AbYEMFqx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 01:46:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@pol.net


The patch titled
     tridentfb: improve check_var function
has been added to the -mm tree.  Its filename is
     tridentfb-improve-check_var-function.patch

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
Subject: tridentfb: improve check_var function
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Do some additional checks (like pixelclock versus ramdac speed) to
eliminate modes which do not work.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tridentfb.c |   34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff -puN drivers/video/tridentfb.c~tridentfb-improve-check_var-function drivers/video/tridentfb.c
--- a/drivers/video/tridentfb.c~tridentfb-improve-check_var-function
+++ a/drivers/video/tridentfb.c
@@ -829,6 +829,7 @@ static int tridentfb_check_var(struct fb
 {
 	struct tridentfb_par *par = info->par;
 	int bpp = var->bits_per_pixel;
+	int ramdac = 230000; /* 230MHz for most 3D chips */
 	debug("enter\n");
 
 	/* check color depth */
@@ -837,6 +838,12 @@ static int tridentfb_check_var(struct fb
 	/* check whether resolution fits on panel and in memory */
 	if (par->flatpanel && nativex && var->xres > nativex)
 		return -EINVAL;
+	/* various resolution checks */
+	var->xres = (var->xres + 7) & ~0x7;
+	if (var->xres != var->xres_virtual)
+		var->xres_virtual = var->xres;
+	if (var->yres > var->yres_virtual)
+		var->yres_virtual = var->yres;
 	if (var->xres * var->yres_virtual * bpp / 8 > info->fix.smem_len)
 		return -EINVAL;
 
@@ -868,6 +875,33 @@ static int tridentfb_check_var(struct fb
 	default:
 		return -EINVAL;
 	}
+
+	if (is_xp(par->chip_id))
+		ramdac = 350000;
+
+	switch (par->chip_id) {
+	case TGUI9440:
+		ramdac = 90000;
+		break;
+	case CYBER9320:
+	case TGUI9660:
+		ramdac = 135000;
+		break;
+	case PROVIDIA9685:
+	case CYBER9388:
+	case CYBER9382:
+	case CYBER9385:
+		ramdac = 170000;
+		break;
+	}
+
+	/* The clock is doubled for 32 bpp */
+	if (bpp == 32)
+		ramdac /= 2;
+
+	if (PICOS2KHZ(var->pixclock) > ramdac)
+		return -EINVAL;
+
 	debug("exit\n");
 
 	return 0;
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

tridentfb-remove-misplaced-enable_mmio.patch
tridentfb-improve-clock-setting-accuracy.patch
drivers-video-pnx4008-eliminate-double-free.patch
tridentfb-replace-macros-with-functions.patch
tridentfb-convert-fb_info-into-allocated-one.patch
tridentfb-move-global-pseudo-palette-into-structure.patch
tridentfb-move-global-chip_id-into-structure.patch
tridentfb-move-global-flat-panel-variable-into-structure.patch
tridentfb-convert-is_blade-and-is_xp-macros-into-functions.patch
tridentfb-move-global-acceleration-hooks-into-structure.patch
tridentfb-make-use-of-functions-and-constants-from-the-vgah.patch
tridentfb-fix-timing-calculations.patch
tridentfb-use-mmio-access-for-clock-setting.patch
tridentfb-fix-clock-settings-for-older-trident-96xx-chips.patch
tridentfb-improve-probe-function.patch
tridentfb-improved-register-values-on-tgui-9680.patch
tridentfb-add-tgui-9440-support.patch
tridentfb-fix-unitialized-pseudo_palette.patch
tridentfb-improve-check_var-function.patch
amifb-test-virtual-screen-range-before-subtraction-on-unsigned.patch
atafb-test-virtual-screen-range-before-subtraction-on-unsigned.patch

