From: akpm@linux-foundation.org
Subject: - cirrusfb-drop-clock-fields-from-cirrusfb_regs-structure.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:17:22 -0700
Message-ID: <200810182317.m9INHMJb029074@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35288 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751742AbYJRXRY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:17:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     cirrusfb: drop clock fields from cirrusfb_regs structure
has been removed from the -mm tree.  Its filename was
     cirrusfb-drop-clock-fields-from-cirrusfb_regs-structure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cirrusfb: drop clock fields from cirrusfb_regs structure
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Move call to pixclock calculation into the cirrusfb_set_par_foo().  It
makes copy of clock registers redundant.

Simplify clock calculations further.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |   50 +++++++++++++++----------------------
 1 file changed, 21 insertions(+), 29 deletions(-)

diff -puN drivers/video/cirrusfb.c~cirrusfb-drop-clock-fields-from-cirrusfb_regs-structure drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~cirrusfb-drop-clock-fields-from-cirrusfb_regs-structure
+++ a/drivers/video/cirrusfb.c
@@ -327,10 +327,6 @@ static const struct {
 #endif /* CONFIG_ZORRO */
 
 struct cirrusfb_regs {
-	long freq;
-	long nom;
-	long den;
-	long div;
 	long multiplexing;
 	long mclk;
 	long divMCLK;
@@ -429,9 +425,7 @@ static void cirrusfb_RectFill(u8 __iomem
 			      u_short width, u_short height,
 			      u_char color, u_short line_length);
 
-static void bestclock(long freq, long *best,
-		      long *nom, long *den,
-		      long *div, long maxfreq);
+static void bestclock(long freq, int *nom, int *den, int *div);
 
 #ifdef CIRRUSFB_DEBUG
 static void cirrusfb_dump(void);
@@ -711,9 +705,6 @@ static int cirrusfb_decode_var(const str
 		break;
 	}
 #endif
-
-	bestclock(freq, &regs->freq, &regs->nom, &regs->den, &regs->div,
-		  maxclock);
 	regs->mclk = cirrusfb_get_mclk(freq, var->bits_per_pixel,
 					&regs->divMCLK);
 
@@ -756,6 +747,8 @@ static int cirrusfb_set_par_foo(struct f
 	const struct cirrusfb_board_info_rec *bi;
 	int hdispend, hsyncstart, hsyncend, htotal;
 	int yres, vdispend, vsyncstart, vsyncend, vtotal;
+	long freq;
+	int nom, den, div;
 
 	DPRINTK("ENTER\n");
 	DPRINTK("Requested mode: %dx%dx%d\n",
@@ -903,14 +896,17 @@ static int cirrusfb_set_par_foo(struct f
 	DPRINTK("CRT1a: %d\n", tmp);
 	vga_wcrt(regbase, CL_CRT1A, tmp);
 
+	freq = PICOS2KHZ(var->pixclock);
+	bestclock(freq, &nom, &den, &div);
+
 	/* set VCLK0 */
 	/* hardware RefClock: 14.31818 MHz */
 	/* formula: VClk = (OSC * N) / (D * (1+P)) */
 	/* Example: VClk = (14.31818 * 91) / (23 * (1+1)) = 28.325 MHz */
 
-	vga_wseq(regbase, CL_SEQRB, regs.nom);
-	tmp = regs.den << 1;
-	if (regs.div != 0)
+	vga_wseq(regbase, CL_SEQRB, nom);
+	tmp = den << 1;
+	if (div != 0)
 		tmp |= 1;
 
 	/* 6 bit denom; ONLY 5434!!! (bugged me 10 days) */
@@ -2923,16 +2919,14 @@ static void cirrusfb_RectFill(u8 __iomem
  * bestclock() - determine closest possible clock lower(?) than the
  * desired pixel clock
  **************************************************************************/
-static void bestclock(long freq, long *best, long *nom,
-		       long *den, long *div, long maxfreq)
+static void bestclock(long freq, int *nom, int *den, int *div)
 {
-	long n, h, d, f;
+	int n, d;
+	long h, diff;
 
-	assert(best != NULL);
 	assert(nom != NULL);
 	assert(den != NULL);
 	assert(div != NULL);
-	assert(maxfreq > 0);
 
 	*nom = 0;
 	*den = 0;
@@ -2943,16 +2937,12 @@ static void bestclock(long freq, long *b
 	if (freq < 8000)
 		freq = 8000;
 
-	if (freq > maxfreq)
-		freq = maxfreq;
-
-	*best = 0;
-	f = freq * 10;
+	diff = freq;
 
 	for (n = 32; n < 128; n++) {
 		int s = 0;
 
-		d = (143181 * n) / f;
+		d = (14318 * n) / freq;
 		if ((d >= 7) && (d <= 63)) {
 			int temp = d;
 
@@ -2961,8 +2951,9 @@ static void bestclock(long freq, long *b
 				temp >>= 1;
 			}
 			h = ((14318 * n) / temp) >> s;
-			if (abs(h - freq) < abs(*best - freq)) {
-				*best = h;
+			h = h > freq ? h - freq : freq - h;
+			if (h < diff) {
+				diff = h;
 				*nom = n;
 				*den = temp;
 				*div = s;
@@ -2975,8 +2966,9 @@ static void bestclock(long freq, long *b
 				d >>= 1;
 			}
 			h = ((14318 * n) / d) >> s;
-			if (abs(h - freq) < abs(*best - freq)) {
-				*best = h;
+			h = h > freq ? h - freq : freq - h;
+			if (h < diff) {
+				diff = h;
 				*nom = n;
 				*den = d;
 				*div = s;
@@ -2985,7 +2977,7 @@ static void bestclock(long freq, long *b
 	}
 
 	DPRINTK("Best possible values for given frequency:\n");
-	DPRINTK("	best: %ld kHz  nom: %ld  den: %ld  div: %ld\n",
+	DPRINTK("	freq: %ld kHz  nom: %d  den: %d  div: %d\n",
 		freq, *nom, *den, *div);
 
 	DPRINTK("EXIT\n");
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
fb-convert-lock-unlock_kernel-into-local-fb-mutex.patch

