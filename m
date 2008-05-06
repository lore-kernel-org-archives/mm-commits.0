From: akpm@linux-foundation.org
Subject: + tridentfb-move-global-chip_id-into-structure.patch added to -mm tree
Date: Mon, 05 May 2008 23:12:23 -0700
Message-ID: <200805060612.m466CNNk025131@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52737 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754197AbYEFGM4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 02:12:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@pol.net


The patch titled
     tridentfb: move global chip_id into structure
has been added to the -mm tree.  Its filename is
     tridentfb-move-global-chip_id-into-structure.patch

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
Subject: tridentfb: move global chip_id into structure
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch moves the chip_id into tridentfb_par structure and removes global
chip_id related constants.

It also bumps version of the driver to 0.7.9

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tridentfb.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff -puN drivers/video/tridentfb.c~tridentfb-move-global-chip_id-into-structure drivers/video/tridentfb.c
--- a/drivers/video/tridentfb.c~tridentfb-move-global-chip_id-into-structure
+++ a/drivers/video/tridentfb.c
@@ -24,11 +24,12 @@
 #include <linux/delay.h>
 #include <video/trident.h>
 
-#define VERSION		"0.7.8-NEWAPI"
+#define VERSION		"0.7.9-NEWAPI"
 
 struct tridentfb_par {
 	void __iomem *io_virt;	/* iospace virtual memory address */
 	u32 pseudo_pal[16];
+	int chip_id;
 };
 
 static unsigned char eng_oper;	/* engine operation... */
@@ -42,9 +43,6 @@ static struct fb_fix_screeninfo tridentf
 	.accel = FB_ACCEL_NONE,
 };
 
-static int chip_id;
-
-static int defaultaccel;
 static int displaytype;
 
 /* defaults which are normally overriden by user values */
@@ -79,9 +77,6 @@ module_param(nativex, int, 0);
 module_param(fp, int, 0);
 module_param(crt, int, 0);
 
-static int chip3D;
-static int chipcyber;
-
 static int is3Dchip(int id)
 {
 	return ((id == BLADE3D) || (id == CYBERBLADEE4) ||
@@ -658,7 +653,7 @@ static void set_lwidth(struct tridentfb_
 /* For resolutions smaller than FP resolution stretch */
 static void screen_stretch(struct tridentfb_par *par)
 {
-	if (chip_id != CYBERBLADEXPAi1)
+	if (par->chip_id != CYBERBLADEXPAi1)
 		write3CE(par, BiosReg, 0);
 	else
 		write3CE(par, BiosReg, 8);
@@ -706,7 +701,7 @@ static void set_vclk(struct tridentfb_pa
 				if (fi > freq)
 					break;
 			}
-	if (chip3D) {
+	if (is3Dchip(par->chip_id)) {
 		write3C4(par, ClockHigh, hi);
 		write3C4(par, ClockLow, lo);
 	} else {
@@ -739,7 +734,7 @@ static unsigned int __devinit get_displa
 {
 	if (fp)
 		return DISPLAY_FP;
-	if (crt || !chipcyber)
+	if (crt || !iscyber(par->chip_id))
 		return DISPLAY_CRT;
 	return (read3CE(par, FPConfig) & 0x10) ? DISPLAY_FP : DISPLAY_CRT;
 }
@@ -754,7 +749,7 @@ static unsigned int __devinit get_memsiz
 	if (memsize)
 		k = memsize * Kb;
 	else
-		switch (chip_id) {
+		switch (par->chip_id) {
 		case CYBER9525DVD:
 			k = 2560 * Kb;
 			break;
@@ -1034,7 +1029,7 @@ static int tridentfb_set_par(struct fb_i
 	write3X4(par, PixelBusReg, tmp);
 
 	tmp = 0x10;
-	if (chipcyber)
+	if (iscyber(par->chip_id))
 		tmp |= 0x20;
 	write3X4(par, DRAMControl, tmp);	/* both IO, linear enable */
 
@@ -1062,7 +1057,7 @@ static int tridentfb_set_par(struct fb_i
 	write3CE(par, 0x6, 0x05);	/* graphics mode */
 	write3CE(par, 0x7, 0x0F);	/* planes? */
 
-	if (chip_id == CYBERBLADEXPAi1) {
+	if (par->chip_id == CYBERBLADEXPAi1) {
 		/* This fixes snow-effect in 32 bpp */
 		write3X4(par, CRTHSyncStart, 0x84);
 	}
@@ -1217,6 +1212,9 @@ static int __devinit trident_pci_probe(s
 	unsigned char revision;
 	struct fb_info *info;
 	struct tridentfb_par *default_par;
+	int defaultaccel;
+	int chip3D;
+	int chip_id;
 
 	err = pci_enable_device(dev);
 	if (err)
@@ -1269,7 +1267,6 @@ static int __devinit trident_pci_probe(s
 	}
 
 	chip3D = is3Dchip(chip_id);
-	chipcyber = iscyber(chip_id);
 
 	if (is_xp(chip_id)) {
 		acc = &accel_xp;
@@ -1279,6 +1276,8 @@ static int __devinit trident_pci_probe(s
 		acc = &accel_image;
 	}
 
+	default_par->chip_id = chip_id;
+
 	/* acceleration is on by default for 3D chips */
 	defaultaccel = chip3D && !noaccel;
 
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

tridentfb-remove-misplaced-enable_mmio.patch
tridentfb-improve-clock-setting-accuracy.patch
tridentfb-replace-macros-with-functions.patch
tridentfb-convert-fb_info-into-allocated-one.patch
tridentfb-move-global-pseudo-palette-into-structure.patch
tridentfb-move-global-chip_id-into-structure.patch
tridentfb-move-global-flat-panel-variable-into-structure.patch
tridentfb-convert-is_blade-and-is_xp-macros-into-functions.patch
tridentfb-move-global-acceleration-hooks-into-structure.patch
tridentfb-make-use-of-functions-and-constants-from-the-vgah.patch

