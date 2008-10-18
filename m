From: akpm@linux-foundation.org
Subject: - cirrusfb-do-not-change-mclk-for-alpine-chips.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:17:29 -0700
Message-ID: <200810182317.m9INHTVp029104@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48471 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751796AbYJRXRb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:17:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     cirrusfb: do not change MCLK for Alpine chips
has been removed from the -mm tree.  Its filename was
     cirrusfb-do-not-change-mclk-for-alpine-chips.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
fb-convert-lock-unlock_kernel-into-local-fb-mutex.patch

