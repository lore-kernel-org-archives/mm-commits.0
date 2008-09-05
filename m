From: akpm@linux-foundation.org
Subject: + cirrusfb-do-not-change-mclk-for-alpine-chips.patch added to -mm tree
Date: Fri, 05 Sep 2008 14:55:59 -0700
Message-ID: <200809052156.m85Lu0lS022252@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47085 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751911AbYIEV4d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Sep 2008 17:56:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl


The patch titled
     cirrusfb: do not change MCLK for Alpine chips
has been added to the -mm tree.  Its filename is
     cirrusfb-do-not-change-mclk-for-alpine-chips.patch

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
Subject: cirrusfb: do not change MCLK for Alpine chips
From: Krzysztof Helt <krzysztof.h1@wp.pl>

A memory clock value (MCLK) is changed to a minimum required by a current
mode bandwidth.  This usually lowers the MCLK to its minimum (50 MHz) thus
decreasing the card performance.  Just leave the MCLK value set by card
BIOS.

The CL-GD5446 Technical Reference Manual point 9.9.1.3 states that if a
pixclock value is close (~1%) to the MCLK or MCLK/2 this may result in a
jitter on the screen.  A countermeasure is to use the MCLK as pixclock
source instead of a VCLK.  The patch implements this as well.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |  121 ++++++++++++++++---------------------
 1 file changed, 54 insertions(+), 67 deletions(-)

diff -puN drivers/video/cirrusfb.c~cirrusfb-do-not-change-mclk-for-alpine-chips drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~cirrusfb-do-not-change-mclk-for-alpine-chips
+++ a/drivers/video/cirrusfb.c
@@ -327,9 +327,7 @@ static const struct {
 #endif /* CONFIG_ZORRO */
 
 struct cirrusfb_regs {
-	long multiplexing;
-	long mclk;
-	long divMCLK;
+	int multiplexing;
 };
 
 #ifdef CIRRUSFB_DEBUG
@@ -461,45 +459,28 @@ static int cirrusfb_release(struct fb_in
 /****************************************************************************/
 /**** BEGIN Hardware specific Routines **************************************/
 
-/* Get a good MCLK value */
-static long cirrusfb_get_mclk(long freq, int bpp, long *div)
+/* Check if the MCLK is not a better clock source */
+static int cirrusfb_check_mclk(struct cirrusfb_info *cinfo, long freq)
 {
-	long mclk;
+	long mclk = vga_rseq(cinfo->regbase, CL_SEQR1F) & 0x3f;
 
-	assert(div != NULL);
-
-	/* Calculate MCLK, in case VCLK is high enough to require > 50MHz.
-	 * Assume a 64-bit data path for now.  The formula is:
-	 * ((B * PCLK * 2)/W) * 1.2
-	 * B = bytes per pixel, PCLK = pixclock, W = data width in bytes */
-	mclk = ((bpp / 8) * freq * 2) / 4;
-	mclk = (mclk * 12) / 10;
-	if (mclk < 50000)
-		mclk = 50000;
-	DPRINTK("Use MCLK of %ld kHz\n", mclk);
-
-	/* Calculate value for SR1F.  Multiply by 2 so we can round up. */
-	mclk = ((mclk * 16) / 14318);
-	mclk = (mclk + 1) / 2;
-	DPRINTK("Set SR1F[5:0] to 0x%lx\n", mclk);
+	/* Read MCLK value */
+	mclk = (14318 * mclk) >> 3;
+	DPRINTK("Read MCLK of %ld kHz\n", mclk);
 
 	/* Determine if we should use MCLK instead of VCLK, and if so, what we
-	   * should divide it by to get VCLK */
-	switch (freq) {
-	case 24751 ... 25249:
-		*div = 2;
-		DPRINTK("Using VCLK = MCLK/2\n");
-		break;
-	case 49501 ... 50499:
-		*div = 1;
+	 * should divide it by to get VCLK
+	 */
+
+	if (abs(freq - mclk) < 250) {
 		DPRINTK("Using VCLK = MCLK\n");
-		break;
-	default:
-		*div = 0;
-		break;
+		return 1;
+	} else if (abs(freq - (mclk / 2)) < 250) {
+		DPRINTK("Using VCLK = MCLK/2\n");
+		return 2;
 	}
 
-	return mclk;
+	return 0;
 }
 
 static int cirrusfb_check_var(struct fb_var_screeninfo *var,
@@ -705,30 +686,27 @@ static int cirrusfb_decode_var(const str
 		break;
 	}
 #endif
-	regs->mclk = cirrusfb_get_mclk(freq, var->bits_per_pixel,
-					&regs->divMCLK);
-
 	return 0;
 }
 
-static void cirrusfb_set_mclk(const struct cirrusfb_info *cinfo, int val,
-				int div)
+static void cirrusfb_set_mclk_as_source(const struct cirrusfb_info *cinfo,
+					int div)
 {
+	unsigned char old1f, old1e;
 	assert(cinfo != NULL);
+	old1f = vga_rseq(cinfo->regbase, CL_SEQR1F) & ~0x40;
 
-	if (div == 2) {
-		/* VCLK = MCLK/2 */
-		unsigned char old = vga_rseq(cinfo->regbase, CL_SEQR1E);
-		vga_wseq(cinfo->regbase, CL_SEQR1E, old | 0x1);
-		vga_wseq(cinfo->regbase, CL_SEQR1F, 0x40 | (val & 0x3f));
-	} else if (div == 1) {
-		/* VCLK = MCLK */
-		unsigned char old = vga_rseq(cinfo->regbase, CL_SEQR1E);
-		vga_wseq(cinfo->regbase, CL_SEQR1E, old & ~0x1);
-		vga_wseq(cinfo->regbase, CL_SEQR1F, 0x40 | (val & 0x3f));
-	} else {
-		vga_wseq(cinfo->regbase, CL_SEQR1F, val & 0x3f);
+	if (div) {
+		DPRINTK("Set %s as pixclock source.\n",
+					(div == 2) ? "MCLK/2" : "MCLK");
+		old1f |= 0x40;
+		old1e = vga_rseq(cinfo->regbase, CL_SEQR1E) & ~0x1;
+		if (div == 2)
+			old1e |= 1;
+
+		vga_wseq(cinfo->regbase, CL_SEQR1E, old1e);
 	}
+	vga_wseq(cinfo->regbase, CL_SEQR1F, old1f);
 }
 
 /*************************************************************************
@@ -904,19 +882,31 @@ static int cirrusfb_set_par_foo(struct f
 	/* formula: VClk = (OSC * N) / (D * (1+P)) */
 	/* Example: VClk = (14.31818 * 91) / (23 * (1+1)) = 28.325 MHz */
 
-	vga_wseq(regbase, CL_SEQRB, nom);
-	tmp = den << 1;
-	if (div != 0)
-		tmp |= 1;
-
-	/* 6 bit denom; ONLY 5434!!! (bugged me 10 days) */
-	if ((cinfo->btype == BT_SD64) ||
-	    (cinfo->btype == BT_ALPINE) ||
-	    (cinfo->btype == BT_GD5480))
-		tmp |= 0x80;
+	if (cinfo->btype == BT_ALPINE) {
+		/* if freq is close to mclk or mclk/2 select mclk
+		 * as clock source
+		 */
+		int divMCLK = cirrusfb_check_mclk(cinfo, freq);
+		if (divMCLK)  {
+			nom = 0;
+			cirrusfb_set_mclk_as_source(cinfo, divMCLK);
+		}
+	}
+	if (nom) {
+		vga_wseq(regbase, CL_SEQRB, nom);
+		tmp = den << 1;
+		if (div != 0)
+			tmp |= 1;
+
+		/* 6 bit denom; ONLY 5434!!! (bugged me 10 days) */
+		if ((cinfo->btype == BT_SD64) ||
+		    (cinfo->btype == BT_ALPINE) ||
+		    (cinfo->btype == BT_GD5480))
+			tmp |= 0x80;
 
-	DPRINTK("CL_SEQR1B: %ld\n", (long) tmp);
-	vga_wseq(regbase, CL_SEQR1B, tmp);
+		DPRINTK("CL_SEQR1B: %ld\n", (long) tmp);
+		vga_wseq(regbase, CL_SEQR1B, tmp);
+	}
 
 	if (yres >= 1024)
 		/* 1280x1024 */
@@ -1106,7 +1096,6 @@ static int cirrusfb_set_par_foo(struct f
 
 		case BT_ALPINE:
 			DPRINTK(" (for GD543x)\n");
-			cirrusfb_set_mclk(cinfo, regs.mclk, regs.divMCLK);
 			/* We already set SRF and SR1F */
 			break;
 
@@ -1179,7 +1168,6 @@ static int cirrusfb_set_par_foo(struct f
 		case BT_ALPINE:
 			DPRINTK(" (for GD543x)\n");
 			vga_wseq(regbase, CL_SEQR7, 0xa7);
-			cirrusfb_set_mclk(cinfo, regs.mclk, regs.divMCLK);
 			break;
 
 		case BT_GD5480:
@@ -1257,7 +1245,6 @@ static int cirrusfb_set_par_foo(struct f
 		case BT_ALPINE:
 			DPRINTK(" (for GD543x)\n");
 			vga_wseq(regbase, CL_SEQR7, 0xa9);
-			cirrusfb_set_mclk(cinfo, regs.mclk, regs.divMCLK);
 			break;
 
 		case BT_GD5480:
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
atmel_lcdfb-fix-oops-in-rmmod-when-framebuffer-fails-to-register.patch
linux-next.patch
fb-metronome-printk-format-warning.patch
sched-fix-compilation-with-gcc-346.patch
x86-delay-early-cpu-initialization-until-cpuid-is-done.patch
x86-move-mtrr-cpu-cap-setting-early-in-early_init_xxxx.patch
fb-convert-lock-unlock_kernel-into-local-fb-mutex.patch
neofb-reduce-panning-function.patch
viafb-accelc-accelh-update.patch
viafb-viafbdevc-update.patch
fbdev-kconfig-update.patch
fbdev-kconfig-update-fix.patch
neofb-kill-some-redundant-code.patch
vga16fb-remove-open_lock-mutex.patch
neofb-remove-open_lock-mutex.patch
tdfxfb-do-not-make-changes-to-default-tdfx_fix.patch
intelfb-support-945gme-as-used-in-asus-eee-901.patch
cirrusfb-remove-information-about-memory-size-during-mode-change.patch
cirrusfb-simplify-clock-calculation.patch
cirrusfb-remove-24-bpp-mode.patch
cirrusfb-drop-device-pointers-from-cirrusfb_info.patch
cirrusfb-use-modedb-and-add-mode_option-parameter-2nd-rev.patch
cirrusfb-add-__devinit-attribute-to-probing-functions.patch
cirrusfb-eliminate-crt-registers-from-global-structure.patch
cirrusfb-eliminate-crt-registers-from-global-structure-fix-up-debug-printk-types.patch
cirrusfb-drop-clock-fields-from-cirrusfb_regs-structure.patch
cirrusfb-add-noaccel-module-parameter.patch
cirrusfb-fix-16bpp-modes.patch
cirrusfb-do-not-change-mclk-for-alpine-chips.patch
atmel_lcdfb-disallow-setting-larger-resolution-than-the-framebuffer-memory-can-handle.patch

