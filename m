From: akpm@linux-foundation.org
Subject: [merged] matroxfb-get-rid-of-unneeded-macros-wpminfo-and-friends.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:03:07 -0700
Message-ID: <200909232003.n8NK37lZ018590@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42305 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753899AbZIWUED (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:04:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, krzysztof.h1@poczta.fm, vandrove@vc.cvut.cz, mm-commits@vger.kernel.org


The patch titled
     matroxfb: get rid of unneeded macros WPMINFO and friends
has been removed from the -mm tree.  Its filename was
     matroxfb-get-rid-of-unneeded-macros-wpminfo-and-friends.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: matroxfb: get rid of unneeded macros WPMINFO and friends
From: Jean Delvare <khali@linux-fr.org>

With multihead support always enabled, these macros are no longer needed
and make the code harder to read.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Petr Vandrovec <vandrove@vc.cvut.cz>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/matrox/g450_pll.c         |  185 +++++++++-------
 drivers/video/matrox/g450_pll.h         |    8 
 drivers/video/matrox/i2c-matroxfb.c     |   12 -
 drivers/video/matrox/matroxfb_DAC1064.c |  248 ++++++++++++----------
 drivers/video/matrox/matroxfb_DAC1064.h |    4 
 drivers/video/matrox/matroxfb_Ti3026.c  |  172 +++++++--------
 drivers/video/matrox/matroxfb_accel.c   |   37 ++-
 drivers/video/matrox/matroxfb_accel.h   |    2 
 drivers/video/matrox/matroxfb_base.c    |  124 ++++++-----
 drivers/video/matrox/matroxfb_base.h    |   24 --
 drivers/video/matrox/matroxfb_crtc2.c   |   14 -
 drivers/video/matrox/matroxfb_g450.c    |   99 ++++----
 drivers/video/matrox/matroxfb_g450.h    |    8 
 drivers/video/matrox/matroxfb_misc.c    |   76 ++++--
 drivers/video/matrox/matroxfb_misc.h    |   13 -
 15 files changed, 581 insertions(+), 445 deletions(-)

diff -puN drivers/video/matrox/g450_pll.c~matroxfb-get-rid-of-unneeded-macros-wpminfo-and-friends drivers/video/matrox/g450_pll.c
--- a/drivers/video/matrox/g450_pll.c~matroxfb-get-rid-of-unneeded-macros-wpminfo-and-friends
+++ a/drivers/video/matrox/g450_pll.c
@@ -25,7 +25,9 @@ static inline unsigned int g450_f2vco(un
 	return (p & 0x40) ? fin : fin << ((p & 3) + 1);
 }
 
-static unsigned int g450_mnp2vco(CPMINFO unsigned int mnp) {
+static unsigned int g450_mnp2vco(const struct matrox_fb_info *minfo,
+				 unsigned int mnp)
+{
 	unsigned int m, n;
 
 	m = ((mnp >> 16) & 0x0FF) + 1;
@@ -33,8 +35,9 @@ static unsigned int g450_mnp2vco(CPMINFO
 	return (minfo->features.pll.ref_freq * n + (m >> 1)) / m;
 }
 
-unsigned int g450_mnp2f(CPMINFO unsigned int mnp) {
-	return g450_vco2f(mnp, g450_mnp2vco(PMINFO mnp));
+unsigned int g450_mnp2f(const struct matrox_fb_info *minfo, unsigned int mnp)
+{
+	return g450_vco2f(mnp, g450_mnp2vco(minfo, mnp));
 }
 
 static inline unsigned int pll_freq_delta(unsigned int f1, unsigned int f2) {
@@ -49,7 +52,10 @@ static inline unsigned int pll_freq_delt
 #define NO_MORE_MNP	0x01FFFFFF
 #define G450_MNP_FREQBITS	(0xFFFFFF43)	/* do not mask high byte so we'll catch NO_MORE_MNP */
 
-static unsigned int g450_nextpll(CPMINFO const struct matrox_pll_limits* pi, unsigned int* fvco, unsigned int mnp) {
+static unsigned int g450_nextpll(const struct matrox_fb_info *minfo,
+				 const struct matrox_pll_limits *pi,
+				 unsigned int *fvco, unsigned int mnp)
+{
 	unsigned int m, n, p;
 	unsigned int tvco = *fvco;
 
@@ -95,7 +101,10 @@ static unsigned int g450_nextpll(CPMINFO
 	return (m << 16) | (n << 8) | p;
 }
 
-static unsigned int g450_firstpll(CPMINFO const struct matrox_pll_limits* pi, unsigned int* vco, unsigned int fout) {
+static unsigned int g450_firstpll(const struct matrox_fb_info *minfo,
+				  const struct matrox_pll_limits *pi,
+				  unsigned int *vco, unsigned int fout)
+{
 	unsigned int p;
 	unsigned int vcomax;
 
@@ -121,88 +130,94 @@ static unsigned int g450_firstpll(CPMINF
 		}
 		*vco = tvco;
 	}
-	return g450_nextpll(PMINFO pi, vco, 0xFF0000 | p);
+	return g450_nextpll(minfo, pi, vco, 0xFF0000 | p);
 }
 
-static inline unsigned int g450_setpll(CPMINFO unsigned int mnp, unsigned int pll) {
+static inline unsigned int g450_setpll(const struct matrox_fb_info *minfo,
+				       unsigned int mnp, unsigned int pll)
+{
 	switch (pll) {
 		case M_PIXEL_PLL_A:
-			matroxfb_DAC_out(PMINFO M1064_XPIXPLLAM, mnp >> 16);
-			matroxfb_DAC_out(PMINFO M1064_XPIXPLLAN, mnp >> 8);
-			matroxfb_DAC_out(PMINFO M1064_XPIXPLLAP, mnp);
+			matroxfb_DAC_out(minfo, M1064_XPIXPLLAM, mnp >> 16);
+			matroxfb_DAC_out(minfo, M1064_XPIXPLLAN, mnp >> 8);
+			matroxfb_DAC_out(minfo, M1064_XPIXPLLAP, mnp);
 			return M1064_XPIXPLLSTAT;
 
 		case M_PIXEL_PLL_B:
-			matroxfb_DAC_out(PMINFO M1064_XPIXPLLBM, mnp >> 16);
-			matroxfb_DAC_out(PMINFO M1064_XPIXPLLBN, mnp >> 8);
-			matroxfb_DAC_out(PMINFO M1064_XPIXPLLBP, mnp);
+			matroxfb_DAC_out(minfo, M1064_XPIXPLLBM, mnp >> 16);
+			matroxfb_DAC_out(minfo, M1064_XPIXPLLBN, mnp >> 8);
+			matroxfb_DAC_out(minfo, M1064_XPIXPLLBP, mnp);
 			return M1064_XPIXPLLSTAT;
 
 		case M_PIXEL_PLL_C:
-			matroxfb_DAC_out(PMINFO M1064_XPIXPLLCM, mnp >> 16);
-			matroxfb_DAC_out(PMINFO M1064_XPIXPLLCN, mnp >> 8);
-			matroxfb_DAC_out(PMINFO M1064_XPIXPLLCP, mnp);
+			matroxfb_DAC_out(minfo, M1064_XPIXPLLCM, mnp >> 16);
+			matroxfb_DAC_out(minfo, M1064_XPIXPLLCN, mnp >> 8);
+			matroxfb_DAC_out(minfo, M1064_XPIXPLLCP, mnp);
 			return M1064_XPIXPLLSTAT;
 
 		case M_SYSTEM_PLL:
-			matroxfb_DAC_out(PMINFO DAC1064_XSYSPLLM, mnp >> 16);
-			matroxfb_DAC_out(PMINFO DAC1064_XSYSPLLN, mnp >> 8);
-			matroxfb_DAC_out(PMINFO DAC1064_XSYSPLLP, mnp);
+			matroxfb_DAC_out(minfo, DAC1064_XSYSPLLM, mnp >> 16);
+			matroxfb_DAC_out(minfo, DAC1064_XSYSPLLN, mnp >> 8);
+			matroxfb_DAC_out(minfo, DAC1064_XSYSPLLP, mnp);
 			return DAC1064_XSYSPLLSTAT;
 
 		case M_VIDEO_PLL:
-			matroxfb_DAC_out(PMINFO M1064_XVIDPLLM, mnp >> 16);
-			matroxfb_DAC_out(PMINFO M1064_XVIDPLLN, mnp >> 8);
-			matroxfb_DAC_out(PMINFO M1064_XVIDPLLP, mnp);
+			matroxfb_DAC_out(minfo, M1064_XVIDPLLM, mnp >> 16);
+			matroxfb_DAC_out(minfo, M1064_XVIDPLLN, mnp >> 8);
+			matroxfb_DAC_out(minfo, M1064_XVIDPLLP, mnp);
 			return M1064_XVIDPLLSTAT;
 	}
 	return 0;
 }
 
-static inline unsigned int g450_cmppll(CPMINFO unsigned int mnp, unsigned int pll) {
+static inline unsigned int g450_cmppll(const struct matrox_fb_info *minfo,
+				       unsigned int mnp, unsigned int pll)
+{
 	unsigned char m = mnp >> 16;
 	unsigned char n = mnp >> 8;
 	unsigned char p = mnp;
 
 	switch (pll) {
 		case M_PIXEL_PLL_A:
-			return (matroxfb_DAC_in(PMINFO M1064_XPIXPLLAM) != m ||
-				matroxfb_DAC_in(PMINFO M1064_XPIXPLLAN) != n ||
-				matroxfb_DAC_in(PMINFO M1064_XPIXPLLAP) != p);
+			return (matroxfb_DAC_in(minfo, M1064_XPIXPLLAM) != m ||
+				matroxfb_DAC_in(minfo, M1064_XPIXPLLAN) != n ||
+				matroxfb_DAC_in(minfo, M1064_XPIXPLLAP) != p);
 
 		case M_PIXEL_PLL_B:
-			return (matroxfb_DAC_in(PMINFO M1064_XPIXPLLBM) != m ||
-				matroxfb_DAC_in(PMINFO M1064_XPIXPLLBN) != n ||
-				matroxfb_DAC_in(PMINFO M1064_XPIXPLLBP) != p);
+			return (matroxfb_DAC_in(minfo, M1064_XPIXPLLBM) != m ||
+				matroxfb_DAC_in(minfo, M1064_XPIXPLLBN) != n ||
+				matroxfb_DAC_in(minfo, M1064_XPIXPLLBP) != p);
 
 		case M_PIXEL_PLL_C:
-			return (matroxfb_DAC_in(PMINFO M1064_XPIXPLLCM) != m ||
-				matroxfb_DAC_in(PMINFO M1064_XPIXPLLCN) != n ||
-				matroxfb_DAC_in(PMINFO M1064_XPIXPLLCP) != p);
+			return (matroxfb_DAC_in(minfo, M1064_XPIXPLLCM) != m ||
+				matroxfb_DAC_in(minfo, M1064_XPIXPLLCN) != n ||
+				matroxfb_DAC_in(minfo, M1064_XPIXPLLCP) != p);
 
 		case M_SYSTEM_PLL:
-			return (matroxfb_DAC_in(PMINFO DAC1064_XSYSPLLM) != m ||
-				matroxfb_DAC_in(PMINFO DAC1064_XSYSPLLN) != n ||
-				matroxfb_DAC_in(PMINFO DAC1064_XSYSPLLP) != p);
+			return (matroxfb_DAC_in(minfo, DAC1064_XSYSPLLM) != m ||
+				matroxfb_DAC_in(minfo, DAC1064_XSYSPLLN) != n ||
+				matroxfb_DAC_in(minfo, DAC1064_XSYSPLLP) != p);
 
 		case M_VIDEO_PLL:
-			return (matroxfb_DAC_in(PMINFO M1064_XVIDPLLM) != m ||
-				matroxfb_DAC_in(PMINFO M1064_XVIDPLLN) != n ||
-				matroxfb_DAC_in(PMINFO M1064_XVIDPLLP) != p);
+			return (matroxfb_DAC_in(minfo, M1064_XVIDPLLM) != m ||
+				matroxfb_DAC_in(minfo, M1064_XVIDPLLN) != n ||
+				matroxfb_DAC_in(minfo, M1064_XVIDPLLP) != p);
 	}
 	return 1;
 }
 
-static inline int g450_isplllocked(CPMINFO unsigned int regidx) {
+static inline int g450_isplllocked(const struct matrox_fb_info *minfo,
+				   unsigned int regidx)
+{
 	unsigned int j;
 
 	for (j = 0; j < 1000; j++) {
-		if (matroxfb_DAC_in(PMINFO regidx) & 0x40) {
+		if (matroxfb_DAC_in(minfo, regidx) & 0x40) {
 			unsigned int r = 0;
 			int i;
 
 			for (i = 0; i < 100; i++) {
-				r += matroxfb_DAC_in(PMINFO regidx) & 0x40;
+				r += matroxfb_DAC_in(minfo, regidx) & 0x40;
 			}
 			return r >= (90 * 0x40);
 		}
@@ -211,8 +226,10 @@ static inline int g450_isplllocked(CPMIN
 	return 0;
 }
 
-static int g450_testpll(CPMINFO unsigned int mnp, unsigned int pll) {
-	return g450_isplllocked(PMINFO g450_setpll(PMINFO mnp, pll));
+static int g450_testpll(const struct matrox_fb_info *minfo, unsigned int mnp,
+			unsigned int pll)
+{
+	return g450_isplllocked(minfo, g450_setpll(minfo, mnp, pll));
 }
 
 static void updatehwstate_clk(struct matrox_hw_state* hw, unsigned int mnp, unsigned int pll) {
@@ -225,13 +242,19 @@ static void updatehwstate_clk(struct mat
 	}
 }
 
-void matroxfb_g450_setpll_cond(WPMINFO unsigned int mnp, unsigned int pll) {
-	if (g450_cmppll(PMINFO mnp, pll)) {
-		g450_setpll(PMINFO mnp, pll);
+void matroxfb_g450_setpll_cond(struct matrox_fb_info *minfo, unsigned int mnp,
+			       unsigned int pll)
+{
+	if (g450_cmppll(minfo, mnp, pll)) {
+		g450_setpll(minfo, mnp, pll);
 	}
 }
 
-static inline unsigned int g450_findworkingpll(WPMINFO unsigned int pll, unsigned int* mnparray, unsigned int mnpcount) {
+static inline unsigned int g450_findworkingpll(struct matrox_fb_info *minfo,
+					       unsigned int pll,
+					       unsigned int *mnparray,
+					       unsigned int mnpcount)
+{
 	unsigned int found = 0;
 	unsigned int idx;
 	unsigned int mnpfound = mnparray[0];
@@ -255,22 +278,22 @@ static inline unsigned int g450_findwork
 		while (sptr >= sarray) {
 			unsigned int mnp = *sptr--;
 		
-			if (g450_testpll(PMINFO mnp - 0x0300, pll) &&
-			    g450_testpll(PMINFO mnp + 0x0300, pll) &&
-			    g450_testpll(PMINFO mnp - 0x0200, pll) &&
-			    g450_testpll(PMINFO mnp + 0x0200, pll) &&
-			    g450_testpll(PMINFO mnp - 0x0100, pll) &&
-			    g450_testpll(PMINFO mnp + 0x0100, pll)) {
-				if (g450_testpll(PMINFO mnp, pll)) {
+			if (g450_testpll(minfo, mnp - 0x0300, pll) &&
+			    g450_testpll(minfo, mnp + 0x0300, pll) &&
+			    g450_testpll(minfo, mnp - 0x0200, pll) &&
+			    g450_testpll(minfo, mnp + 0x0200, pll) &&
+			    g450_testpll(minfo, mnp - 0x0100, pll) &&
+			    g450_testpll(minfo, mnp + 0x0100, pll)) {
+				if (g450_testpll(minfo, mnp, pll)) {
 					return mnp;
 				}
-			} else if (!found && g450_testpll(PMINFO mnp, pll)) {
+			} else if (!found && g450_testpll(minfo, mnp, pll)) {
 				mnpfound = mnp;
 				found = 1;
 			}
 		}
 	}
-	g450_setpll(PMINFO mnpfound, pll);
+	g450_setpll(minfo, mnpfound, pll);
 	return mnpfound;
 }
 
@@ -283,7 +306,9 @@ static void g450_addcache(struct matrox_
 	ci->data[0].mnp_value = mnp_value;
 }
 
-static int g450_checkcache(WPMINFO struct matrox_pll_cache* ci, unsigned int mnp_key) {
+static int g450_checkcache(struct matrox_fb_info *minfo,
+			   struct matrox_pll_cache *ci, unsigned int mnp_key)
+{
 	unsigned int i;
 	
 	mnp_key &= G450_MNP_FREQBITS;
@@ -303,8 +328,10 @@ static int g450_checkcache(WPMINFO struc
 	return NO_MORE_MNP;
 }
 
-static int __g450_setclk(WPMINFO unsigned int fout, unsigned int pll, 
-		unsigned int* mnparray, unsigned int* deltaarray) {
+static int __g450_setclk(struct matrox_fb_info *minfo, unsigned int fout,
+			 unsigned int pll, unsigned int *mnparray,
+			 unsigned int *deltaarray)
+{
 	unsigned int mnpcount;
 	unsigned int pixel_vco;
 	const struct matrox_pll_limits* pi;
@@ -321,16 +348,16 @@ static int __g450_setclk(WPMINFO unsigne
 				
 				matroxfb_DAC_lock_irqsave(flags);
 
-				xpwrctrl = matroxfb_DAC_in(PMINFO M1064_XPWRCTRL);
-				matroxfb_DAC_out(PMINFO M1064_XPWRCTRL, xpwrctrl & ~M1064_XPWRCTRL_PANELPDN);
+				xpwrctrl = matroxfb_DAC_in(minfo, M1064_XPWRCTRL);
+				matroxfb_DAC_out(minfo, M1064_XPWRCTRL, xpwrctrl & ~M1064_XPWRCTRL_PANELPDN);
 				mga_outb(M_SEQ_INDEX, M_SEQ1);
 				mga_outb(M_SEQ_DATA, mga_inb(M_SEQ_DATA) | M_SEQ1_SCROFF);
-				tmp = matroxfb_DAC_in(PMINFO M1064_XPIXCLKCTRL);
+				tmp = matroxfb_DAC_in(minfo, M1064_XPIXCLKCTRL);
 				tmp |= M1064_XPIXCLKCTRL_DIS;
 				if (!(tmp & M1064_XPIXCLKCTRL_PLL_UP)) {
 					tmp |= M1064_XPIXCLKCTRL_PLL_UP;
 				}
-				matroxfb_DAC_out(PMINFO M1064_XPIXCLKCTRL, tmp);
+				matroxfb_DAC_out(minfo, M1064_XPIXCLKCTRL, tmp);
 				/* DVI PLL preferred for frequencies up to
 				   panel link max, standard PLL otherwise */
 				if (fout >= minfo->max_pixel_clock_panellink)
@@ -341,8 +368,8 @@ static int __g450_setclk(WPMINFO unsigne
 					M1064_XDVICLKCTRL_C1DVICLKEN |
 					M1064_XDVICLKCTRL_DVILOOPCTL |
 					M1064_XDVICLKCTRL_P1LOOPBWDTCTL;
-				matroxfb_DAC_out(PMINFO M1064_XDVICLKCTRL,tmp);
-				matroxfb_DAC_out(PMINFO M1064_XPWRCTRL,
+				matroxfb_DAC_out(minfo, M1064_XDVICLKCTRL, tmp);
+				matroxfb_DAC_out(minfo, M1064_XPWRCTRL,
 						 xpwrctrl);
 
 				matroxfb_DAC_unlock_irqrestore(flags);
@@ -385,14 +412,14 @@ static int __g450_setclk(WPMINFO unsigne
 				unsigned long flags;
 				
 				matroxfb_DAC_lock_irqsave(flags);
-				tmp = matroxfb_DAC_in(PMINFO M1064_XPWRCTRL);
+				tmp = matroxfb_DAC_in(minfo, M1064_XPWRCTRL);
 				if (!(tmp & 2)) {
-					matroxfb_DAC_out(PMINFO M1064_XPWRCTRL, tmp | 2);
+					matroxfb_DAC_out(minfo, M1064_XPWRCTRL, tmp | 2);
 				}
 				
-				mnp = matroxfb_DAC_in(PMINFO M1064_XPIXPLLCM) << 16;
-				mnp |= matroxfb_DAC_in(PMINFO M1064_XPIXPLLCN) << 8;
-				pixel_vco = g450_mnp2vco(PMINFO mnp);
+				mnp = matroxfb_DAC_in(minfo, M1064_XPIXPLLCM) << 16;
+				mnp |= matroxfb_DAC_in(minfo, M1064_XPIXPLLCN) << 8;
+				pixel_vco = g450_mnp2vco(minfo, mnp);
 				matroxfb_DAC_unlock_irqrestore(flags);
 			}
 			pi = &minfo->limits.video;
@@ -407,12 +434,12 @@ static int __g450_setclk(WPMINFO unsigne
 		unsigned int mnp;
 		unsigned int xvco;
 
-		for(mnp = g450_firstpll(PMINFO pi, &xvco, fout); mnp != NO_MORE_MNP; mnp = g450_nextpll(PMINFO pi, &xvco, mnp)) {
+		for (mnp = g450_firstpll(minfo, pi, &xvco, fout); mnp != NO_MORE_MNP; mnp = g450_nextpll(minfo, pi, &xvco, mnp)) {
 			unsigned int idx;
 			unsigned int vco;
 			unsigned int delta;
 
-			vco = g450_mnp2vco(PMINFO mnp);
+			vco = g450_mnp2vco(minfo, mnp);
 #if 0			
 			if (pll == M_VIDEO_PLL) {
 				unsigned int big, small;
@@ -444,7 +471,7 @@ static int __g450_setclk(WPMINFO unsigne
 					 * (freqs near VCOmin aren't as stable)
 					 */
 					if (delta == deltaarray[idx-1]
-					    && vco != g450_mnp2vco(PMINFO mnparray[idx-1])
+					    && vco != g450_mnp2vco(minfo, mnparray[idx-1])
 					    && vco < (pi->vcomin * 17 / 16)) {
 						break;
 					}
@@ -468,11 +495,11 @@ static int __g450_setclk(WPMINFO unsigne
 		unsigned int mnp;
 		
 		matroxfb_DAC_lock_irqsave(flags);
-		mnp = g450_checkcache(PMINFO ci, mnparray[0]);
+		mnp = g450_checkcache(minfo, ci, mnparray[0]);
 		if (mnp != NO_MORE_MNP) {
-			matroxfb_g450_setpll_cond(PMINFO mnp, pll);
+			matroxfb_g450_setpll_cond(minfo, mnp, pll);
 		} else {
-			mnp = g450_findworkingpll(PMINFO pll, mnparray, mnpcount);
+			mnp = g450_findworkingpll(minfo, pll, mnparray, mnpcount);
 			g450_addcache(ci, mnparray[0], mnp);
 		}
 		updatehwstate_clk(&minfo->hw, mnp, pll);
@@ -485,14 +512,16 @@ static int __g450_setclk(WPMINFO unsigne
  * Currently there is 5(p) * 10(m) = 50 possible values. */
 #define MNP_TABLE_SIZE  64
 
-int matroxfb_g450_setclk(WPMINFO unsigned int fout, unsigned int pll) {
+int matroxfb_g450_setclk(struct matrox_fb_info *minfo, unsigned int fout,
+			 unsigned int pll)
+{
 	unsigned int* arr;
 	
 	arr = kmalloc(sizeof(*arr) * MNP_TABLE_SIZE * 2, GFP_KERNEL);
 	if (arr) {
 		int r;
 
-		r = __g450_setclk(PMINFO fout, pll, arr, arr + MNP_TABLE_SIZE);
+		r = __g450_setclk(minfo, fout, pll, arr, arr + MNP_TABLE_SIZE);
 		kfree(arr);
 		return r;
 	}
diff -puN drivers/video/matrox/g450_pll.h~matroxfb-get-rid-of-unneeded-macros-wpminfo-and-friends drivers/video/matrox/g450_pll.h
--- a/drivers/video/matrox/g450_pll.h~matroxfb-get-rid-of-unneeded-macros-wpminfo-and-friends
+++ a/drivers/video/matrox/g450_pll.h
@@ -3,8 +3,10 @@
 
 #include "matroxfb_base.h"
 
-int matroxfb_g450_setclk(WPMINFO unsigned int fout, unsigned int pll);
-unsigned int g450_mnp2f(CPMINFO unsigned int mnp);
-void matroxfb_g450_setpll_cond(WPMINFO unsigned int mnp, unsigned int pll);
+int matroxfb_g450_setclk(struct matrox_fb_info *minfo, unsigned int fout,
+			 unsigned int pll);
+unsigned int g450_mnp2f(const struct matrox_fb_info *minfo, unsigned int mnp);
+void matroxfb_g450_setpll_cond(struct matrox_fb_info *minfo, unsigned int mnp,
+			       unsigned int pll);
 
 #endif	/* __G450_PLL_H__ */
diff -puN drivers/video/matrox/i2c-matroxfb.c~matroxfb-get-rid-of-unneeded-macros-wpminfo-and-friends drivers/video/matrox/i2c-matroxfb.c
--- a/drivers/video/matrox/i2c-matroxfb.c~matroxfb-get-rid-of-unneeded-macros-wpminfo-and-friends
+++ a/drivers/video/matrox/i2c-matroxfb.c
@@ -41,7 +41,7 @@ static int matroxfb_read_gpio(struct mat
 	int v;
 
 	matroxfb_DAC_lock_irqsave(flags);
-	v = matroxfb_DAC_in(PMINFO DAC_XGENIODATA);
+	v = matroxfb_DAC_in(minfo, DAC_XGENIODATA);
 	matroxfb_DAC_unlock_irqrestore(flags);
 	return v;
 }
@@ -51,10 +51,10 @@ static void matroxfb_set_gpio(struct mat
 	int v;
 
 	matroxfb_DAC_lock_irqsave(flags);
-	v = (matroxfb_DAC_in(PMINFO DAC_XGENIOCTRL) & mask) | val;
-	matroxfb_DAC_out(PMINFO DAC_XGENIOCTRL, v);
+	v = (matroxfb_DAC_in(minfo, DAC_XGENIOCTRL) & mask) | val;
+	matroxfb_DAC_out(minfo, DAC_XGENIOCTRL, v);
 	/* We must reset GENIODATA very often... XFree plays with this register */
-	matroxfb_DAC_out(PMINFO DAC_XGENIODATA, 0x00);
+	matroxfb_DAC_out(minfo, DAC_XGENIODATA, 0x00);
 	matroxfb_DAC_unlock_irqrestore(flags);
 }
 
@@ -149,8 +149,8 @@ static void* i2c_matroxfb_probe(struct m
 		return NULL;
 
 	matroxfb_DAC_lock_irqsave(flags);
-	matroxfb_DAC_out(PMINFO DAC_XGENIODATA, 0xFF);
-	matroxfb_DAC_out(PMINFO DAC_XGENIOCTRL, 0x00);
+	matroxfb_DAC_out(minfo, DAC_XGENIODATA, 0xFF);
+	matroxfb_DAC_out(minfo, DAC_XGENIOCTRL, 0x00);
 	matroxfb_DAC_unlock_irqrestore(flags);
 
 	switch (minfo->chip) {
diff -puN drivers/video/matrox/matroxfb_DAC1064.c~matroxfb-get-rid-of-unneeded-macros-wpminfo-and-friends drivers/video/matrox/matroxfb_DAC1064.c
--- a/drivers/video/matrox/matroxfb_DAC1064.c~matroxfb-get-rid-of-unneeded-macros-wpminfo-and-friends
+++ a/drivers/video/matrox/matroxfb_DAC1064.c
@@ -33,7 +33,11 @@
 #define DAC1064_OPT_MDIV2	0x00
 #define DAC1064_OPT_RESERVED	0x10
 
-static void DAC1064_calcclock(CPMINFO unsigned int freq, unsigned int fmax, unsigned int* in, unsigned int* feed, unsigned int* post) {
+static void DAC1064_calcclock(const struct matrox_fb_info *minfo,
+			      unsigned int freq, unsigned int fmax,
+			      unsigned int *in, unsigned int *feed,
+			      unsigned int *post)
+{
 	unsigned int fvco;
 	unsigned int p;
 
@@ -41,7 +45,7 @@ static void DAC1064_calcclock(CPMINFO un
 	
 	/* only for devices older than G450 */
 
-	fvco = PLL_calcclock(PMINFO freq, fmax, in, feed, &p);
+	fvco = PLL_calcclock(minfo, freq, fmax, in, feed, &p);
 	
 	p = (1 << p) - 1;
 	if (fvco <= 100000)
@@ -80,18 +84,21 @@ static const unsigned char MGA1064_DAC[]
 		0x00,
 		0x00, 0x00, 0xFF, 0xFF};
 
-static void DAC1064_setpclk(WPMINFO unsigned long fout) {
+static void DAC1064_setpclk(struct matrox_fb_info *minfo, unsigned long fout)
+{
 	unsigned int m, n, p;
 
 	DBG(__func__)
 
-	DAC1064_calcclock(PMINFO fout, minfo->max_pixel_clock, &m, &n, &p);
+	DAC1064_calcclock(minfo, fout, minfo->max_pixel_clock, &m, &n, &p);
 	minfo->hw.DACclk[0] = m;
 	minfo->hw.DACclk[1] = n;
 	minfo->hw.DACclk[2] = p;
 }
 
-static void DAC1064_setmclk(WPMINFO int oscinfo, unsigned long fmem) {
+static void DAC1064_setmclk(struct matrox_fb_info *minfo, int oscinfo,
+			    unsigned long fmem)
+{
 	u_int32_t mx;
 	struct matrox_hw_state *hw = &minfo->hw;
 
@@ -99,9 +106,9 @@ static void DAC1064_setmclk(WPMINFO int 
 
 	if (minfo->devflags.noinit) {
 		/* read MCLK and give up... */
-		hw->DACclk[3] = inDAC1064(PMINFO DAC1064_XSYSPLLM);
-		hw->DACclk[4] = inDAC1064(PMINFO DAC1064_XSYSPLLN);
-		hw->DACclk[5] = inDAC1064(PMINFO DAC1064_XSYSPLLP);
+		hw->DACclk[3] = inDAC1064(minfo, DAC1064_XSYSPLLM);
+		hw->DACclk[4] = inDAC1064(minfo, DAC1064_XSYSPLLN);
+		hw->DACclk[5] = inDAC1064(minfo, DAC1064_XSYSPLLP);
 		return;
 	}
 	mx = hw->MXoptionReg | 0x00000004;
@@ -131,12 +138,12 @@ static void DAC1064_setmclk(WPMINFO int 
 		   perfect... */
 		/* (bit 2 of PCI_OPTION_REG must be 0... and bits 0,1 must not
 		   select PLL... because of PLL can be stopped at this time) */
-		DAC1064_calcclock(PMINFO fmem, minfo->max_pixel_clock, &m, &n, &p);
-		outDAC1064(PMINFO DAC1064_XSYSPLLM, hw->DACclk[3] = m);
-		outDAC1064(PMINFO DAC1064_XSYSPLLN, hw->DACclk[4] = n);
-		outDAC1064(PMINFO DAC1064_XSYSPLLP, hw->DACclk[5] = p);
+		DAC1064_calcclock(minfo, fmem, minfo->max_pixel_clock, &m, &n, &p);
+		outDAC1064(minfo, DAC1064_XSYSPLLM, hw->DACclk[3] = m);
+		outDAC1064(minfo, DAC1064_XSYSPLLN, hw->DACclk[4] = n);
+		outDAC1064(minfo, DAC1064_XSYSPLLP, hw->DACclk[5] = p);
 		for (clk = 65536; clk; --clk) {
-			if (inDAC1064(PMINFO DAC1064_XSYSPLLSTAT) & 0x40)
+			if (inDAC1064(minfo, DAC1064_XSYSPLLSTAT) & 0x40)
 				break;
 		}
 		if (!clk)
@@ -154,7 +161,8 @@ static void DAC1064_setmclk(WPMINFO int 
 }
 
 #ifdef CONFIG_FB_MATROX_G
-static void g450_set_plls(WPMINFO2) {
+static void g450_set_plls(struct matrox_fb_info *minfo)
+{
 	u_int32_t c2_ctl;
 	unsigned int pxc;
 	struct matrox_hw_state *hw = &minfo->hw;
@@ -184,16 +192,16 @@ static void g450_set_plls(WPMINFO2) {
 		c2_ctl |=  0x0006;	/* Use video PLL */
 		hw->DACreg[POS1064_XPWRCTRL] |= 0x02;
 		
-		outDAC1064(PMINFO M1064_XPWRCTRL, hw->DACreg[POS1064_XPWRCTRL]);
-		matroxfb_g450_setpll_cond(PMINFO videomnp, M_VIDEO_PLL);
+		outDAC1064(minfo, M1064_XPWRCTRL, hw->DACreg[POS1064_XPWRCTRL]);
+		matroxfb_g450_setpll_cond(minfo, videomnp, M_VIDEO_PLL);
 	}
 
 	hw->DACreg[POS1064_XPIXCLKCTRL] &= ~M1064_XPIXCLKCTRL_PLL_UP;
 	if (pixelmnp >= 0) {
 		hw->DACreg[POS1064_XPIXCLKCTRL] |= M1064_XPIXCLKCTRL_PLL_UP;
 		
-		outDAC1064(PMINFO M1064_XPIXCLKCTRL, hw->DACreg[POS1064_XPIXCLKCTRL]);
-		matroxfb_g450_setpll_cond(PMINFO pixelmnp, M_PIXEL_PLL_C);
+		outDAC1064(minfo, M1064_XPIXCLKCTRL, hw->DACreg[POS1064_XPIXCLKCTRL]);
+		matroxfb_g450_setpll_cond(minfo, pixelmnp, M_PIXEL_PLL_C);
 	}
 	if (c2_ctl != hw->crtc2.ctl) {
 		hw->crtc2.ctl = c2_ctl;
@@ -245,7 +253,8 @@ static void g450_set_plls(WPMINFO2) {
 }
 #endif
 
-void DAC1064_global_init(WPMINFO2) {
+void DAC1064_global_init(struct matrox_fb_info *minfo)
+{
 	struct matrox_hw_state *hw = &minfo->hw;
 
 	hw->DACreg[POS1064_XMISCCTRL] &= M1064_XMISCCTRL_DAC_WIDTHMASK;
@@ -299,7 +308,7 @@ void DAC1064_global_init(WPMINFO2) {
 				break;
 		}
 		/* Now set timming related variables... */
-		g450_set_plls(PMINFO2);
+		g450_set_plls(minfo);
 	} else
 #endif
 	{
@@ -318,24 +327,26 @@ void DAC1064_global_init(WPMINFO2) {
 	}
 }
 
-void DAC1064_global_restore(WPMINFO2) {
+void DAC1064_global_restore(struct matrox_fb_info *minfo)
+{
 	struct matrox_hw_state *hw = &minfo->hw;
 
-	outDAC1064(PMINFO M1064_XPIXCLKCTRL, hw->DACreg[POS1064_XPIXCLKCTRL]);
-	outDAC1064(PMINFO M1064_XMISCCTRL, hw->DACreg[POS1064_XMISCCTRL]);
+	outDAC1064(minfo, M1064_XPIXCLKCTRL, hw->DACreg[POS1064_XPIXCLKCTRL]);
+	outDAC1064(minfo, M1064_XMISCCTRL, hw->DACreg[POS1064_XMISCCTRL]);
 	if (minfo->devflags.accelerator == FB_ACCEL_MATROX_MGAG400) {
-		outDAC1064(PMINFO 0x20, 0x04);
-		outDAC1064(PMINFO 0x1F, minfo->devflags.dfp_type);
+		outDAC1064(minfo, 0x20, 0x04);
+		outDAC1064(minfo, 0x1F, minfo->devflags.dfp_type);
 		if (minfo->devflags.g450dac) {
-			outDAC1064(PMINFO M1064_XSYNCCTRL, 0xCC);
-			outDAC1064(PMINFO M1064_XPWRCTRL, hw->DACreg[POS1064_XPWRCTRL]);
-			outDAC1064(PMINFO M1064_XPANMODE, hw->DACreg[POS1064_XPANMODE]);
-			outDAC1064(PMINFO M1064_XOUTPUTCONN, hw->DACreg[POS1064_XOUTPUTCONN]);
+			outDAC1064(minfo, M1064_XSYNCCTRL, 0xCC);
+			outDAC1064(minfo, M1064_XPWRCTRL, hw->DACreg[POS1064_XPWRCTRL]);
+			outDAC1064(minfo, M1064_XPANMODE, hw->DACreg[POS1064_XPANMODE]);
+			outDAC1064(minfo, M1064_XOUTPUTCONN, hw->DACreg[POS1064_XOUTPUTCONN]);
 		}
 	}
 }
 
-static int DAC1064_init_1(WPMINFO struct my_timming* m) {
+static int DAC1064_init_1(struct matrox_fb_info *minfo, struct my_timming *m)
+{
 	struct matrox_hw_state *hw = &minfo->hw;
 
 	DBG(__func__)
@@ -367,11 +378,12 @@ static int DAC1064_init_1(WPMINFO struct
 	hw->DACreg[POS1064_XCURADDL] = 0;
 	hw->DACreg[POS1064_XCURADDH] = 0;
 
-	DAC1064_global_init(PMINFO2);
+	DAC1064_global_init(minfo);
 	return 0;
 }
 
-static int DAC1064_init_2(WPMINFO struct my_timming* m) {
+static int DAC1064_init_2(struct matrox_fb_info *minfo, struct my_timming *m)
+{
 	struct matrox_hw_state *hw = &minfo->hw;
 
 	DBG(__func__)
@@ -413,7 +425,8 @@ static int DAC1064_init_2(WPMINFO struct
 	return 0;
 }
 
-static void DAC1064_restore_1(WPMINFO2) {
+static void DAC1064_restore_1(struct matrox_fb_info *minfo)
+{
 	struct matrox_hw_state *hw = &minfo->hw;
 
 	CRITFLAGS
@@ -422,28 +435,29 @@ static void DAC1064_restore_1(WPMINFO2) 
 
 	CRITBEGIN
 
-	if ((inDAC1064(PMINFO DAC1064_XSYSPLLM) != hw->DACclk[3]) ||
-	    (inDAC1064(PMINFO DAC1064_XSYSPLLN) != hw->DACclk[4]) ||
-	    (inDAC1064(PMINFO DAC1064_XSYSPLLP) != hw->DACclk[5])) {
-		outDAC1064(PMINFO DAC1064_XSYSPLLM, hw->DACclk[3]);
-		outDAC1064(PMINFO DAC1064_XSYSPLLN, hw->DACclk[4]);
-		outDAC1064(PMINFO DAC1064_XSYSPLLP, hw->DACclk[5]);
+	if ((inDAC1064(minfo, DAC1064_XSYSPLLM) != hw->DACclk[3]) ||
+	    (inDAC1064(minfo, DAC1064_XSYSPLLN) != hw->DACclk[4]) ||
+	    (inDAC1064(minfo, DAC1064_XSYSPLLP) != hw->DACclk[5])) {
+		outDAC1064(minfo, DAC1064_XSYSPLLM, hw->DACclk[3]);
+		outDAC1064(minfo, DAC1064_XSYSPLLN, hw->DACclk[4]);
+		outDAC1064(minfo, DAC1064_XSYSPLLP, hw->DACclk[5]);
 	}
 	{
 		unsigned int i;
 
 		for (i = 0; i < sizeof(MGA1064_DAC_regs); i++) {
 			if ((i != POS1064_XPIXCLKCTRL) && (i != POS1064_XMISCCTRL))
-				outDAC1064(PMINFO MGA1064_DAC_regs[i], hw->DACreg[i]);
+				outDAC1064(minfo, MGA1064_DAC_regs[i], hw->DACreg[i]);
 		}
 	}
 
-	DAC1064_global_restore(PMINFO2);
+	DAC1064_global_restore(minfo);
 
 	CRITEND
 };
 
-static void DAC1064_restore_2(WPMINFO2) {
+static void DAC1064_restore_2(struct matrox_fb_info *minfo)
+{
 #ifdef DEBUG
 	unsigned int i;
 #endif
@@ -470,14 +484,14 @@ static int m1064_compute(void* out, stru
 		int tmout;
 		CRITFLAGS
 
-		DAC1064_setpclk(PMINFO m->pixclock);
+		DAC1064_setpclk(minfo, m->pixclock);
 
 		CRITBEGIN
 
 		for (i = 0; i < 3; i++)
-			outDAC1064(PMINFO M1064_XPIXPLLCM + i, minfo->hw.DACclk[i]);
+			outDAC1064(minfo, M1064_XPIXPLLCM + i, minfo->hw.DACclk[i]);
 		for (tmout = 500000; tmout; tmout--) {
-			if (inDAC1064(PMINFO M1064_XPIXPLLSTAT) & 0x40)
+			if (inDAC1064(minfo, M1064_XPIXPLLSTAT) & 0x40)
 				break;
 			udelay(10);
 		};
@@ -500,9 +514,9 @@ static struct matrox_altout m1064 = {
 static int g450_compute(void* out, struct my_timming* m) {
 #define minfo ((struct matrox_fb_info*)out)
 	if (m->mnp < 0) {
-		m->mnp = matroxfb_g450_setclk(PMINFO m->pixclock, (m->crtc == MATROXFB_SRC_CRTC1) ? M_PIXEL_PLL_C : M_VIDEO_PLL);
+		m->mnp = matroxfb_g450_setclk(minfo, m->pixclock, (m->crtc == MATROXFB_SRC_CRTC1) ? M_PIXEL_PLL_C : M_VIDEO_PLL);
 		if (m->mnp >= 0) {
-			m->pixclock = g450_mnp2f(PMINFO m->mnp);
+			m->pixclock = g450_mnp2f(minfo, m->mnp);
 		}
 	}
 #undef minfo
@@ -518,13 +532,14 @@ static struct matrox_altout g450out = {
 #endif /* NEED_DAC1064 */
 
 #ifdef CONFIG_FB_MATROX_MYSTIQUE
-static int MGA1064_init(WPMINFO struct my_timming* m) {
+static int MGA1064_init(struct matrox_fb_info *minfo, struct my_timming *m)
+{
 	struct matrox_hw_state *hw = &minfo->hw;
 
 	DBG(__func__)
 
-	if (DAC1064_init_1(PMINFO m)) return 1;
-	if (matroxfb_vgaHWinit(PMINFO m)) return 1;
+	if (DAC1064_init_1(minfo, m)) return 1;
+	if (matroxfb_vgaHWinit(minfo, m)) return 1;
 
 	hw->MiscOutReg = 0xCB;
 	if (m->sync & FB_SYNC_HOR_HIGH_ACT)
@@ -534,20 +549,21 @@ static int MGA1064_init(WPMINFO struct m
 	if (m->sync & FB_SYNC_COMP_HIGH_ACT) /* should be only FB_SYNC_COMP */
 		hw->CRTCEXT[3] |= 0x40;
 
-	if (DAC1064_init_2(PMINFO m)) return 1;
+	if (DAC1064_init_2(minfo, m)) return 1;
 	return 0;
 }
 #endif
 
 #ifdef CONFIG_FB_MATROX_G
-static int MGAG100_init(WPMINFO struct my_timming* m) {
+static int MGAG100_init(struct matrox_fb_info *minfo, struct my_timming *m)
+{
 	struct matrox_hw_state *hw = &minfo->hw;
 
 	DBG(__func__)
 
-	if (DAC1064_init_1(PMINFO m)) return 1;
+	if (DAC1064_init_1(minfo, m)) return 1;
 	hw->MXoptionReg &= ~0x2000;
-	if (matroxfb_vgaHWinit(PMINFO m)) return 1;
+	if (matroxfb_vgaHWinit(minfo, m)) return 1;
 
 	hw->MiscOutReg = 0xEF;
 	if (m->sync & FB_SYNC_HOR_HIGH_ACT)
@@ -557,13 +573,14 @@ static int MGAG100_init(WPMINFO struct m
 	if (m->sync & FB_SYNC_COMP_HIGH_ACT) /* should be only FB_SYNC_COMP */
 		hw->CRTCEXT[3] |= 0x40;
 
-	if (DAC1064_init_2(PMINFO m)) return 1;
+	if (DAC1064_init_2(minfo, m)) return 1;
 	return 0;
 }
 #endif	/* G */
 
 #ifdef CONFIG_FB_MATROX_MYSTIQUE
-static void MGA1064_ramdac_init(WPMINFO2) {
+static void MGA1064_ramdac_init(struct matrox_fb_info *minfo)
+{
 
 	DBG(__func__)
 
@@ -577,7 +594,7 @@ static void MGA1064_ramdac_init(WPMINFO2
 	minfo->features.pll.post_shift_max = 3;
 	minfo->features.DAC1064.xvrefctrl = DAC1064_XVREFCTRL_EXTERNAL;
 	/* maybe cmdline MCLK= ?, doc says gclk=44MHz, mclk=66MHz... it was 55/83 with old values */
-	DAC1064_setmclk(PMINFO DAC1064_OPT_MDIV2 | DAC1064_OPT_GDIV3 | DAC1064_OPT_SCLK_PLL, 133333);
+	DAC1064_setmclk(minfo, DAC1064_OPT_MDIV2 | DAC1064_OPT_GDIV3 | DAC1064_OPT_SCLK_PLL, 133333);
 }
 #endif
 
@@ -589,23 +606,25 @@ static int x7AF4 = 0x10;	/* flags, maybe
 static int def50 = 0;	/* reg50, & 0x0F, & 0x3000 (only 0x0000, 0x1000, 0x2000 (0x3000 disallowed and treated as 0) */
 #endif
 
-static void MGAG100_progPixClock(CPMINFO int flags, int m, int n, int p) {
+static void MGAG100_progPixClock(const struct matrox_fb_info *minfo, int flags,
+				 int m, int n, int p)
+{
 	int reg;
 	int selClk;
 	int clk;
 
 	DBG(__func__)
 
-	outDAC1064(PMINFO M1064_XPIXCLKCTRL, inDAC1064(PMINFO M1064_XPIXCLKCTRL) | M1064_XPIXCLKCTRL_DIS |
+	outDAC1064(minfo, M1064_XPIXCLKCTRL, inDAC1064(minfo, M1064_XPIXCLKCTRL) | M1064_XPIXCLKCTRL_DIS |
 		   M1064_XPIXCLKCTRL_PLL_UP);
 	switch (flags & 3) {
 		case 0:		reg = M1064_XPIXPLLAM; break;
 		case 1:		reg = M1064_XPIXPLLBM; break;
 		default:	reg = M1064_XPIXPLLCM; break;
 	}
-	outDAC1064(PMINFO reg++, m);
-	outDAC1064(PMINFO reg++, n);
-	outDAC1064(PMINFO reg, p);
+	outDAC1064(minfo, reg++, m);
+	outDAC1064(minfo, reg++, n);
+	outDAC1064(minfo, reg, p);
 	selClk = mga_inb(M_MISC_REG_READ) & ~0xC;
 	/* there should be flags & 0x03 & case 0/1/else */
 	/* and we should first select source and after that we should wait for PLL */
@@ -617,34 +636,37 @@ static void MGAG100_progPixClock(CPMINFO
 	}
 	mga_outb(M_MISC_REG, selClk);
 	for (clk = 500000; clk; clk--) {
-		if (inDAC1064(PMINFO M1064_XPIXPLLSTAT) & 0x40)
+		if (inDAC1064(minfo, M1064_XPIXPLLSTAT) & 0x40)
 			break;
 		udelay(10);
 	};
 	if (!clk)
 		printk(KERN_ERR "matroxfb: Pixel PLL%c not locked after usual time\n", (reg-M1064_XPIXPLLAM-2)/4 + 'A');
-	selClk = inDAC1064(PMINFO M1064_XPIXCLKCTRL) & ~M1064_XPIXCLKCTRL_SRC_MASK;
+	selClk = inDAC1064(minfo, M1064_XPIXCLKCTRL) & ~M1064_XPIXCLKCTRL_SRC_MASK;
 	switch (flags & 0x0C) {
 		case 0x00:	selClk |= M1064_XPIXCLKCTRL_SRC_PCI; break;
 		case 0x04:	selClk |= M1064_XPIXCLKCTRL_SRC_PLL; break;
 		default:	selClk |= M1064_XPIXCLKCTRL_SRC_EXT; break;
 	}
-	outDAC1064(PMINFO M1064_XPIXCLKCTRL, selClk);
-	outDAC1064(PMINFO M1064_XPIXCLKCTRL, inDAC1064(PMINFO M1064_XPIXCLKCTRL) & ~M1064_XPIXCLKCTRL_DIS);
+	outDAC1064(minfo, M1064_XPIXCLKCTRL, selClk);
+	outDAC1064(minfo, M1064_XPIXCLKCTRL, inDAC1064(minfo, M1064_XPIXCLKCTRL) & ~M1064_XPIXCLKCTRL_DIS);
 }
 
-static void MGAG100_setPixClock(CPMINFO int flags, int freq) {
+static void MGAG100_setPixClock(const struct matrox_fb_info *minfo, int flags,
+				int freq)
+{
 	unsigned int m, n, p;
 
 	DBG(__func__)
 
-	DAC1064_calcclock(PMINFO freq, minfo->max_pixel_clock, &m, &n, &p);
-	MGAG100_progPixClock(PMINFO flags, m, n, p);
+	DAC1064_calcclock(minfo, freq, minfo->max_pixel_clock, &m, &n, &p);
+	MGAG100_progPixClock(minfo, flags, m, n, p);
 }
 #endif
 
 #ifdef CONFIG_FB_MATROX_MYSTIQUE
-static int MGA1064_preinit(WPMINFO2) {
+static int MGA1064_preinit(struct matrox_fb_info *minfo)
+{
 	static const int vxres_mystique[] = { 512,        640, 768,  800,  832,  960,
 					     1024, 1152, 1280,      1600, 1664, 1920,
 					     2048,    0};
@@ -681,16 +703,18 @@ static int MGA1064_preinit(WPMINFO2) {
 	return 0;
 }
 
-static void MGA1064_reset(WPMINFO2) {
+static void MGA1064_reset(struct matrox_fb_info *minfo)
+{
 
 	DBG(__func__);
 
-	MGA1064_ramdac_init(PMINFO2);
+	MGA1064_ramdac_init(minfo);
 }
 #endif
 
 #ifdef CONFIG_FB_MATROX_G
-static void g450_mclk_init(WPMINFO2) {
+static void g450_mclk_init(struct matrox_fb_info *minfo)
+{
 	/* switch all clocks to PCI source */
 	pci_write_config_dword(minfo->pcidev, PCI_OPTION_REG, minfo->hw.MXoptionReg | 4);
 	pci_write_config_dword(minfo->pcidev, PCI_OPTION3_REG, minfo->values.reg.opt3 & ~0x00300C03);
@@ -699,17 +723,17 @@ static void g450_mclk_init(WPMINFO2) {
 	if (((minfo->values.reg.opt3 & 0x000003) == 0x000003) ||
 	    ((minfo->values.reg.opt3 & 0x000C00) == 0x000C00) ||
 	    ((minfo->values.reg.opt3 & 0x300000) == 0x300000)) {
-		matroxfb_g450_setclk(PMINFO minfo->values.pll.video, M_VIDEO_PLL);
+		matroxfb_g450_setclk(minfo, minfo->values.pll.video, M_VIDEO_PLL);
 	} else {
 		unsigned long flags;
 		unsigned int pwr;
 		
 		matroxfb_DAC_lock_irqsave(flags);
-		pwr = inDAC1064(PMINFO M1064_XPWRCTRL) & ~0x02;
-		outDAC1064(PMINFO M1064_XPWRCTRL, pwr);
+		pwr = inDAC1064(minfo, M1064_XPWRCTRL) & ~0x02;
+		outDAC1064(minfo, M1064_XPWRCTRL, pwr);
 		matroxfb_DAC_unlock_irqrestore(flags);
 	}
-	matroxfb_g450_setclk(PMINFO minfo->values.pll.system, M_SYSTEM_PLL);
+	matroxfb_g450_setclk(minfo, minfo->values.pll.system, M_SYSTEM_PLL);
 	
 	/* switch clocks to their real PLL source(s) */
 	pci_write_config_dword(minfo->pcidev, PCI_OPTION_REG, minfo->hw.MXoptionReg | 4);
@@ -718,7 +742,8 @@ static void g450_mclk_init(WPMINFO2) {
 
 }
 
-static void g450_memory_init(WPMINFO2) {
+static void g450_memory_init(struct matrox_fb_info *minfo)
+{
 	/* disable memory refresh */
 	minfo->hw.MXoptionReg &= ~0x001F8000;
 	pci_write_config_dword(minfo->pcidev, PCI_OPTION_REG, minfo->hw.MXoptionReg);
@@ -760,7 +785,8 @@ static void g450_memory_init(WPMINFO2) {
 	
 }
 
-static void g450_preinit(WPMINFO2) {
+static void g450_preinit(struct matrox_fb_info *minfo)
+{
 	u_int32_t c2ctl;
 	u_int8_t curctl;
 	u_int8_t c1ctl;
@@ -783,24 +809,24 @@ static void g450_preinit(WPMINFO2) {
 	c2ctl = mga_inl(M_C2CTL);
 	mga_outl(M_C2CTL, c2ctl & ~1);
 	/* stop cursor */
-	curctl = inDAC1064(PMINFO M1064_XCURCTRL);
-	outDAC1064(PMINFO M1064_XCURCTRL, 0);
+	curctl = inDAC1064(minfo, M1064_XCURCTRL);
+	outDAC1064(minfo, M1064_XCURCTRL, 0);
 	/* stop crtc1 */
 	c1ctl = mga_readr(M_SEQ_INDEX, 1);
 	mga_setr(M_SEQ_INDEX, 1, c1ctl | 0x20);
 
-	g450_mclk_init(PMINFO2);
-	g450_memory_init(PMINFO2);
+	g450_mclk_init(minfo);
+	g450_memory_init(minfo);
 	
 	/* set legacy VGA clock sources for DOSEmu or VMware... */
-	matroxfb_g450_setclk(PMINFO 25175, M_PIXEL_PLL_A);
-	matroxfb_g450_setclk(PMINFO 28322, M_PIXEL_PLL_B);
+	matroxfb_g450_setclk(minfo, 25175, M_PIXEL_PLL_A);
+	matroxfb_g450_setclk(minfo, 28322, M_PIXEL_PLL_B);
 
 	/* restore crtc1 */
 	mga_setr(M_SEQ_INDEX, 1, c1ctl);
 	
 	/* restore cursor */
-	outDAC1064(PMINFO M1064_XCURCTRL, curctl);
+	outDAC1064(minfo, M1064_XCURCTRL, curctl);
 
 	/* restore crtc2 */
 	mga_outl(M_C2CTL, c2ctl);
@@ -808,7 +834,8 @@ static void g450_preinit(WPMINFO2) {
 	return;
 }
 
-static int MGAG100_preinit(WPMINFO2) {
+static int MGAG100_preinit(struct matrox_fb_info *minfo)
+{
 	static const int vxres_g100[] = {  512,        640, 768,  800,  832,  960,
                                           1024, 1152, 1280,      1600, 1664, 1920,
                                           2048, 0};
@@ -862,7 +889,7 @@ static int MGAG100_preinit(WPMINFO2) {
 	if (minfo->devflags.noinit)
 		return 0;
 	if (minfo->devflags.g450dac) {
-		g450_preinit(PMINFO2);
+		g450_preinit(minfo);
 		return 0;
 	}
 	hw->MXoptionReg &= 0xC0000100;
@@ -874,7 +901,7 @@ static int MGAG100_preinit(WPMINFO2) {
 	if (minfo->devflags.nopciretry)
 		hw->MXoptionReg |=  0x20000000;
 	pci_write_config_dword(minfo->pcidev, PCI_OPTION_REG, hw->MXoptionReg);
-	DAC1064_setmclk(PMINFO DAC1064_OPT_MDIV2 | DAC1064_OPT_GDIV3 | DAC1064_OPT_SCLK_PCI, 133333);
+	DAC1064_setmclk(minfo, DAC1064_OPT_MDIV2 | DAC1064_OPT_GDIV3 | DAC1064_OPT_SCLK_PCI, 133333);
 
 	if (minfo->devflags.accelerator == FB_ACCEL_MATROX_MGAG100) {
 		pci_read_config_dword(minfo->pcidev, PCI_OPTION2_REG, &reg50);
@@ -952,7 +979,8 @@ static int MGAG100_preinit(WPMINFO2) {
 	return 0;
 }
 
-static void MGAG100_reset(WPMINFO2) {
+static void MGAG100_reset(struct matrox_fb_info *minfo)
+{
 	u_int8_t b;
 	struct matrox_hw_state *hw = &minfo->hw;
 
@@ -981,35 +1009,36 @@ static void MGAG100_reset(WPMINFO2) {
 	}
 	if (minfo->devflags.g450dac) {
 		/* either leave MCLK as is... or they were set in preinit */
-		hw->DACclk[3] = inDAC1064(PMINFO DAC1064_XSYSPLLM);
-		hw->DACclk[4] = inDAC1064(PMINFO DAC1064_XSYSPLLN);
-		hw->DACclk[5] = inDAC1064(PMINFO DAC1064_XSYSPLLP);
+		hw->DACclk[3] = inDAC1064(minfo, DAC1064_XSYSPLLM);
+		hw->DACclk[4] = inDAC1064(minfo, DAC1064_XSYSPLLN);
+		hw->DACclk[5] = inDAC1064(minfo, DAC1064_XSYSPLLP);
 	} else {
-		DAC1064_setmclk(PMINFO DAC1064_OPT_RESERVED | DAC1064_OPT_MDIV2 | DAC1064_OPT_GDIV1 | DAC1064_OPT_SCLK_PLL, 133333);
+		DAC1064_setmclk(minfo, DAC1064_OPT_RESERVED | DAC1064_OPT_MDIV2 | DAC1064_OPT_GDIV1 | DAC1064_OPT_SCLK_PLL, 133333);
 	}
 	if (minfo->devflags.accelerator == FB_ACCEL_MATROX_MGAG400) {
 		if (minfo->devflags.dfp_type == -1) {
-			minfo->devflags.dfp_type = inDAC1064(PMINFO 0x1F);
+			minfo->devflags.dfp_type = inDAC1064(minfo, 0x1F);
 		}
 	}
 	if (minfo->devflags.noinit)
 		return;
 	if (minfo->devflags.g450dac) {
 	} else {
-		MGAG100_setPixClock(PMINFO 4, 25175);
-		MGAG100_setPixClock(PMINFO 5, 28322);
+		MGAG100_setPixClock(minfo, 4, 25175);
+		MGAG100_setPixClock(minfo, 5, 28322);
 		if (x7AF4 & 0x10) {
-			b = inDAC1064(PMINFO M1064_XGENIODATA) & ~1;
-			outDAC1064(PMINFO M1064_XGENIODATA, b);
-			b = inDAC1064(PMINFO M1064_XGENIOCTRL) | 1;
-			outDAC1064(PMINFO M1064_XGENIOCTRL, b);
+			b = inDAC1064(minfo, M1064_XGENIODATA) & ~1;
+			outDAC1064(minfo, M1064_XGENIODATA, b);
+			b = inDAC1064(minfo, M1064_XGENIOCTRL) | 1;
+			outDAC1064(minfo, M1064_XGENIOCTRL, b);
 		}
 	}
 }
 #endif
 
 #ifdef CONFIG_FB_MATROX_MYSTIQUE
-static void MGA1064_restore(WPMINFO2) {
+static void MGA1064_restore(struct matrox_fb_info *minfo)
+{
 	int i;
 	struct matrox_hw_state *hw = &minfo->hw;
 
@@ -1025,17 +1054,18 @@ static void MGA1064_restore(WPMINFO2) {
 
 	CRITEND
 
-	DAC1064_restore_1(PMINFO2);
-	matroxfb_vgaHWrestore(PMINFO2);
+	DAC1064_restore_1(minfo);
+	matroxfb_vgaHWrestore(minfo);
 	minfo->crtc1.panpos = -1;
 	for (i = 0; i < 6; i++)
 		mga_setr(M_EXTVGA_INDEX, i, hw->CRTCEXT[i]);
-	DAC1064_restore_2(PMINFO2);
+	DAC1064_restore_2(minfo);
 }
 #endif
 
 #ifdef CONFIG_FB_MATROX_G
-static void MGAG100_restore(WPMINFO2) {
+static void MGAG100_restore(struct matrox_fb_info *minfo)
+{
 	int i;
 	struct matrox_hw_state *hw = &minfo->hw;
 
@@ -1048,8 +1078,8 @@ static void MGAG100_restore(WPMINFO2) {
 	pci_write_config_dword(minfo->pcidev, PCI_OPTION_REG, hw->MXoptionReg);
 	CRITEND
 
-	DAC1064_restore_1(PMINFO2);
-	matroxfb_vgaHWrestore(PMINFO2);
+	DAC1064_restore_1(minfo);
+	matroxfb_vgaHWrestore(minfo);
 #ifdef CONFIG_FB_MATROX_32MB
 	if (minfo->devflags.support32MB)
 		mga_setr(M_EXTVGA_INDEX, 8, hw->CRTCEXT[8]);
@@ -1057,7 +1087,7 @@ static void MGAG100_restore(WPMINFO2) {
 	minfo->crtc1.panpos = -1;
 	for (i = 0; i < 6; i++)
 		mga_setr(M_EXTVGA_INDEX, i, hw->CRTCEXT[i]);
-	DAC1064_restore_2(PMINFO2);
+	DAC1064_restore_2(minfo);
 }
 #endif
 
diff -puN drivers/video/matrox/matroxfb_DAC1064.h~matroxfb-get-rid-of-unneeded-macros-wpminfo-and-friends drivers/video/matrox/matroxfb_DAC1064.h
--- a/drivers/video/matrox/matroxfb_DAC1064.h~matroxfb-get-rid-of-unneeded-macros-wpminfo-and-friends
+++ a/drivers/video/matrox/matroxfb_DAC1064.h
@@ -11,8 +11,8 @@ extern struct matrox_switch matrox_mysti
 extern struct matrox_switch matrox_G100;
 #endif
 #ifdef NEED_DAC1064
-void DAC1064_global_init(WPMINFO2);
-void DAC1064_global_restore(WPMINFO2);
+void DAC1064_global_init(struct matrox_fb_info *minfo);
+void DAC1064_global_restore(struct matrox_fb_info *minfo);
 #endif
 
 #define M1064_INDEX	0x00
diff -puN drivers/video/matrox/matroxfb_Ti3026.c~matroxfb-get-rid-of-unneeded-macros-wpminfo-and-friends drivers/video/matrox/matroxfb_Ti3026.c
--- a/drivers/video/matrox/matroxfb_Ti3026.c~matroxfb-get-rid-of-unneeded-macros-wpminfo-and-friends
+++ a/drivers/video/matrox/matroxfb_Ti3026.c
@@ -279,27 +279,31 @@ static const unsigned char MGADACbpp32[]
   TVP3026_XCOLKEYCTRL_ZOOM1,
   0x00, 0x00, TVP3026_XCURCTRL_DIS };
 
-static int Ti3026_calcclock(CPMINFO unsigned int freq, unsigned int fmax, int* in, int* feed, int* post) {
+static int Ti3026_calcclock(const struct matrox_fb_info *minfo,
+			    unsigned int freq, unsigned int fmax, int *in,
+			    int *feed, int *post)
+{
 	unsigned int fvco;
 	unsigned int lin, lfeed, lpost;
 
 	DBG(__func__)
 
-	fvco = PLL_calcclock(PMINFO freq, fmax, &lin, &lfeed, &lpost);
+	fvco = PLL_calcclock(minfo, freq, fmax, &lin, &lfeed, &lpost);
 	fvco >>= (*post = lpost);
 	*in = 64 - lin;
 	*feed = 64 - lfeed;
 	return fvco;
 }
 
-static int Ti3026_setpclk(WPMINFO int clk) {
+static int Ti3026_setpclk(struct matrox_fb_info *minfo, int clk)
+{
 	unsigned int f_pll;
 	unsigned int pixfeed, pixin, pixpost;
 	struct matrox_hw_state *hw = &minfo->hw;
 
 	DBG(__func__)
 
-	f_pll = Ti3026_calcclock(PMINFO clk, minfo->max_pixel_clock, &pixin, &pixfeed, &pixpost);
+	f_pll = Ti3026_calcclock(minfo, clk, minfo->max_pixel_clock, &pixin, &pixfeed, &pixpost);
 
 	hw->DACclk[0] = pixin | 0xC0;
 	hw->DACclk[1] = pixfeed;
@@ -361,7 +365,8 @@ static int Ti3026_setpclk(WPMINFO int cl
 	return 0;
 }
 
-static int Ti3026_init(WPMINFO struct my_timming* m) {
+static int Ti3026_init(struct matrox_fb_info *minfo, struct my_timming *m)
+{
 	u_int8_t muxctrl = isInterleave(minfo) ? TVP3026_XMUXCTRL_MEMORY_64BIT : TVP3026_XMUXCTRL_MEMORY_32BIT;
 	struct matrox_hw_state *hw = &minfo->hw;
 
@@ -400,7 +405,7 @@ static int Ti3026_init(WPMINFO struct my
 		default:
 			return 1;	/* TODO: failed */
 	}
-	if (matroxfb_vgaHWinit(PMINFO m)) return 1;
+	if (matroxfb_vgaHWinit(minfo, m)) return 1;
 
 	/* set SYNC */
 	hw->MiscOutReg = 0xCB;
@@ -429,11 +434,12 @@ static int Ti3026_init(WPMINFO struct my
 	if (isInterleave(minfo)) hw->MXoptionReg |= 0x00001000;
 
 	/* set DAC */
-	Ti3026_setpclk(PMINFO m->pixclock);
+	Ti3026_setpclk(minfo, m->pixclock);
 	return 0;
 }
 
-static void ti3026_setMCLK(WPMINFO int fout){
+static void ti3026_setMCLK(struct matrox_fb_info *minfo, int fout)
+{
 	unsigned int f_pll;
 	unsigned int pclk_m, pclk_n, pclk_p;
 	unsigned int mclk_m, mclk_n, mclk_p;
@@ -442,29 +448,29 @@ static void ti3026_setMCLK(WPMINFO int f
 
 	DBG(__func__)
 
-	f_pll = Ti3026_calcclock(PMINFO fout, minfo->max_pixel_clock, &mclk_n, &mclk_m, &mclk_p);
+	f_pll = Ti3026_calcclock(minfo, fout, minfo->max_pixel_clock, &mclk_n, &mclk_m, &mclk_p);
 
 	/* save pclk */
-	outTi3026(PMINFO TVP3026_XPLLADDR, 0xFC);
-	pclk_n = inTi3026(PMINFO TVP3026_XPIXPLLDATA);
-	outTi3026(PMINFO TVP3026_XPLLADDR, 0xFD);
-	pclk_m = inTi3026(PMINFO TVP3026_XPIXPLLDATA);
-	outTi3026(PMINFO TVP3026_XPLLADDR, 0xFE);
-	pclk_p = inTi3026(PMINFO TVP3026_XPIXPLLDATA);
+	outTi3026(minfo, TVP3026_XPLLADDR, 0xFC);
+	pclk_n = inTi3026(minfo, TVP3026_XPIXPLLDATA);
+	outTi3026(minfo, TVP3026_XPLLADDR, 0xFD);
+	pclk_m = inTi3026(minfo, TVP3026_XPIXPLLDATA);
+	outTi3026(minfo, TVP3026_XPLLADDR, 0xFE);
+	pclk_p = inTi3026(minfo, TVP3026_XPIXPLLDATA);
 
 	/* stop pclk */
-	outTi3026(PMINFO TVP3026_XPLLADDR, 0xFE);
-	outTi3026(PMINFO TVP3026_XPIXPLLDATA, 0x00);
+	outTi3026(minfo, TVP3026_XPLLADDR, 0xFE);
+	outTi3026(minfo, TVP3026_XPIXPLLDATA, 0x00);
 
 	/* set pclk to new mclk */
-	outTi3026(PMINFO TVP3026_XPLLADDR, 0xFC);
-	outTi3026(PMINFO TVP3026_XPIXPLLDATA, mclk_n | 0xC0);
-	outTi3026(PMINFO TVP3026_XPIXPLLDATA, mclk_m);
-	outTi3026(PMINFO TVP3026_XPIXPLLDATA, mclk_p | 0xB0);
+	outTi3026(minfo, TVP3026_XPLLADDR, 0xFC);
+	outTi3026(minfo, TVP3026_XPIXPLLDATA, mclk_n | 0xC0);
+	outTi3026(minfo, TVP3026_XPIXPLLDATA, mclk_m);
+	outTi3026(minfo, TVP3026_XPIXPLLDATA, mclk_p | 0xB0);
 
 	/* wait for PLL to lock */
 	for (tmout = 500000; tmout; tmout--) {
-		if (inTi3026(PMINFO TVP3026_XPIXPLLDATA) & 0x40)
+		if (inTi3026(minfo, TVP3026_XPIXPLLDATA) & 0x40)
 			break;
 		udelay(10);
 	};
@@ -472,23 +478,23 @@ static void ti3026_setMCLK(WPMINFO int f
 		printk(KERN_ERR "matroxfb: Temporary pixel PLL not locked after 5 secs\n");
 
 	/* output pclk on mclk pin */
-	mclk_ctl = inTi3026(PMINFO TVP3026_XMEMPLLCTRL);
-	outTi3026(PMINFO TVP3026_XMEMPLLCTRL, mclk_ctl & 0xE7);
-	outTi3026(PMINFO TVP3026_XMEMPLLCTRL, (mclk_ctl & 0xE7) | TVP3026_XMEMPLLCTRL_STROBEMKC4);
+	mclk_ctl = inTi3026(minfo, TVP3026_XMEMPLLCTRL);
+	outTi3026(minfo, TVP3026_XMEMPLLCTRL, mclk_ctl & 0xE7);
+	outTi3026(minfo, TVP3026_XMEMPLLCTRL, (mclk_ctl & 0xE7) | TVP3026_XMEMPLLCTRL_STROBEMKC4);
 
 	/* stop MCLK */
-	outTi3026(PMINFO TVP3026_XPLLADDR, 0xFB);
-	outTi3026(PMINFO TVP3026_XMEMPLLDATA, 0x00);
+	outTi3026(minfo, TVP3026_XPLLADDR, 0xFB);
+	outTi3026(minfo, TVP3026_XMEMPLLDATA, 0x00);
 
 	/* set mclk to new freq */
-	outTi3026(PMINFO TVP3026_XPLLADDR, 0xF3);
-	outTi3026(PMINFO TVP3026_XMEMPLLDATA, mclk_n | 0xC0);
-	outTi3026(PMINFO TVP3026_XMEMPLLDATA, mclk_m);
-	outTi3026(PMINFO TVP3026_XMEMPLLDATA, mclk_p | 0xB0);
+	outTi3026(minfo, TVP3026_XPLLADDR, 0xF3);
+	outTi3026(minfo, TVP3026_XMEMPLLDATA, mclk_n | 0xC0);
+	outTi3026(minfo, TVP3026_XMEMPLLDATA, mclk_m);
+	outTi3026(minfo, TVP3026_XMEMPLLDATA, mclk_p | 0xB0);
 
 	/* wait for PLL to lock */
 	for (tmout = 500000; tmout; tmout--) {
-		if (inTi3026(PMINFO TVP3026_XMEMPLLDATA) & 0x40)
+		if (inTi3026(minfo, TVP3026_XMEMPLLDATA) & 0x40)
 			break;
 		udelay(10);
 	}
@@ -509,22 +515,22 @@ static void ti3026_setMCLK(WPMINFO int f
 	pci_write_config_dword(minfo->pcidev, PCI_OPTION_REG, minfo->hw.MXoptionReg);
 
 	/* output MCLK to MCLK pin */
-	outTi3026(PMINFO TVP3026_XMEMPLLCTRL, (mclk_ctl & 0xE7) | TVP3026_XMEMPLLCTRL_MCLK_MCLKPLL);
-	outTi3026(PMINFO TVP3026_XMEMPLLCTRL, (mclk_ctl       ) | TVP3026_XMEMPLLCTRL_MCLK_MCLKPLL | TVP3026_XMEMPLLCTRL_STROBEMKC4);
+	outTi3026(minfo, TVP3026_XMEMPLLCTRL, (mclk_ctl & 0xE7) | TVP3026_XMEMPLLCTRL_MCLK_MCLKPLL);
+	outTi3026(minfo, TVP3026_XMEMPLLCTRL, (mclk_ctl       ) | TVP3026_XMEMPLLCTRL_MCLK_MCLKPLL | TVP3026_XMEMPLLCTRL_STROBEMKC4);
 
 	/* stop PCLK */
-	outTi3026(PMINFO TVP3026_XPLLADDR, 0xFE);
-	outTi3026(PMINFO TVP3026_XPIXPLLDATA, 0x00);
+	outTi3026(minfo, TVP3026_XPLLADDR, 0xFE);
+	outTi3026(minfo, TVP3026_XPIXPLLDATA, 0x00);
 
 	/* restore pclk */
-	outTi3026(PMINFO TVP3026_XPLLADDR, 0xFC);
-	outTi3026(PMINFO TVP3026_XPIXPLLDATA, pclk_n);
-	outTi3026(PMINFO TVP3026_XPIXPLLDATA, pclk_m);
-	outTi3026(PMINFO TVP3026_XPIXPLLDATA, pclk_p);
+	outTi3026(minfo, TVP3026_XPLLADDR, 0xFC);
+	outTi3026(minfo, TVP3026_XPIXPLLDATA, pclk_n);
+	outTi3026(minfo, TVP3026_XPIXPLLDATA, pclk_m);
+	outTi3026(minfo, TVP3026_XPIXPLLDATA, pclk_p);
 
 	/* wait for PLL to lock */
 	for (tmout = 500000; tmout; tmout--) {
-		if (inTi3026(PMINFO TVP3026_XPIXPLLDATA) & 0x40)
+		if (inTi3026(minfo, TVP3026_XPIXPLLDATA) & 0x40)
 			break;
 		udelay(10);
 	}
@@ -532,8 +538,8 @@ static void ti3026_setMCLK(WPMINFO int f
 		printk(KERN_ERR "matroxfb: Pixel PLL not locked after 5 secs\n");
 }
 
-static void ti3026_ramdac_init(WPMINFO2) {
-
+static void ti3026_ramdac_init(struct matrox_fb_info *minfo)
+{
 	DBG(__func__)
 
 	minfo->features.pll.vco_freq_min = 110000;
@@ -545,10 +551,11 @@ static void ti3026_ramdac_init(WPMINFO2)
 	minfo->features.pll.post_shift_max = 3;
 	if (minfo->devflags.noinit)
 		return;
-	ti3026_setMCLK(PMINFO 60000);
+	ti3026_setMCLK(minfo, 60000);
 }
 
-static void Ti3026_restore(WPMINFO2) {
+static void Ti3026_restore(struct matrox_fb_info *minfo)
+{
 	int i;
 	unsigned char progdac[6];
 	struct matrox_hw_state *hw = &minfo->hw;
@@ -569,7 +576,7 @@ static void Ti3026_restore(WPMINFO2) {
 
 	CRITEND
 
-	matroxfb_vgaHWrestore(PMINFO2);
+	matroxfb_vgaHWrestore(minfo);
 
 	CRITBEGIN
 
@@ -578,18 +585,18 @@ static void Ti3026_restore(WPMINFO2) {
 		mga_setr(M_EXTVGA_INDEX, i, hw->CRTCEXT[i]);
 
 	for (i = 0; i < 21; i++) {
-		outTi3026(PMINFO DACseq[i], hw->DACreg[i]);
+		outTi3026(minfo, DACseq[i], hw->DACreg[i]);
 	}
 
-	outTi3026(PMINFO TVP3026_XPLLADDR, 0x00);
-	progdac[0] = inTi3026(PMINFO TVP3026_XPIXPLLDATA);
-	progdac[3] = inTi3026(PMINFO TVP3026_XLOOPPLLDATA);
-	outTi3026(PMINFO TVP3026_XPLLADDR, 0x15);
-	progdac[1] = inTi3026(PMINFO TVP3026_XPIXPLLDATA);
-	progdac[4] = inTi3026(PMINFO TVP3026_XLOOPPLLDATA);
-	outTi3026(PMINFO TVP3026_XPLLADDR, 0x2A);
-	progdac[2] = inTi3026(PMINFO TVP3026_XPIXPLLDATA);
-	progdac[5] = inTi3026(PMINFO TVP3026_XLOOPPLLDATA);
+	outTi3026(minfo, TVP3026_XPLLADDR, 0x00);
+	progdac[0] = inTi3026(minfo, TVP3026_XPIXPLLDATA);
+	progdac[3] = inTi3026(minfo, TVP3026_XLOOPPLLDATA);
+	outTi3026(minfo, TVP3026_XPLLADDR, 0x15);
+	progdac[1] = inTi3026(minfo, TVP3026_XPIXPLLDATA);
+	progdac[4] = inTi3026(minfo, TVP3026_XLOOPPLLDATA);
+	outTi3026(minfo, TVP3026_XPLLADDR, 0x2A);
+	progdac[2] = inTi3026(minfo, TVP3026_XPIXPLLDATA);
+	progdac[5] = inTi3026(minfo, TVP3026_XLOOPPLLDATA);
 
 	CRITEND
 	if (memcmp(hw->DACclk, progdac, 6)) {
@@ -598,20 +605,20 @@ static void Ti3026_restore(WPMINFO2) {
 		/* Maybe even we should call schedule() ? */
 
 		CRITBEGIN
-		outTi3026(PMINFO TVP3026_XCLKCTRL, hw->DACreg[POS3026_XCLKCTRL]);
-		outTi3026(PMINFO TVP3026_XPLLADDR, 0x2A);
-		outTi3026(PMINFO TVP3026_XLOOPPLLDATA, 0);
-		outTi3026(PMINFO TVP3026_XPIXPLLDATA, 0);
+		outTi3026(minfo, TVP3026_XCLKCTRL, hw->DACreg[POS3026_XCLKCTRL]);
+		outTi3026(minfo, TVP3026_XPLLADDR, 0x2A);
+		outTi3026(minfo, TVP3026_XLOOPPLLDATA, 0);
+		outTi3026(minfo, TVP3026_XPIXPLLDATA, 0);
 
-		outTi3026(PMINFO TVP3026_XPLLADDR, 0x00);
+		outTi3026(minfo, TVP3026_XPLLADDR, 0x00);
 		for (i = 0; i < 3; i++)
-			outTi3026(PMINFO TVP3026_XPIXPLLDATA, hw->DACclk[i]);
+			outTi3026(minfo, TVP3026_XPIXPLLDATA, hw->DACclk[i]);
 		/* wait for PLL only if PLL clock requested (always for PowerMode, never for VGA) */
 		if (hw->MiscOutReg & 0x08) {
 			int tmout;
-			outTi3026(PMINFO TVP3026_XPLLADDR, 0x3F);
+			outTi3026(minfo, TVP3026_XPLLADDR, 0x3F);
 			for (tmout = 500000; tmout; --tmout) {
-				if (inTi3026(PMINFO TVP3026_XPIXPLLDATA) & 0x40)
+				if (inTi3026(minfo, TVP3026_XPIXPLLDATA) & 0x40)
 					break;
 				udelay(10);
 			}
@@ -624,18 +631,18 @@ static void Ti3026_restore(WPMINFO2) {
 				dprintk(KERN_INFO "PixelPLL: %d\n", 500000-tmout);
 			CRITBEGIN
 		}
-		outTi3026(PMINFO TVP3026_XMEMPLLCTRL, hw->DACreg[POS3026_XMEMPLLCTRL]);
-		outTi3026(PMINFO TVP3026_XPLLADDR, 0x00);
+		outTi3026(minfo, TVP3026_XMEMPLLCTRL, hw->DACreg[POS3026_XMEMPLLCTRL]);
+		outTi3026(minfo, TVP3026_XPLLADDR, 0x00);
 		for (i = 3; i < 6; i++)
-			outTi3026(PMINFO TVP3026_XLOOPPLLDATA, hw->DACclk[i]);
+			outTi3026(minfo, TVP3026_XLOOPPLLDATA, hw->DACclk[i]);
 		CRITEND
 		if ((hw->MiscOutReg & 0x08) && ((hw->DACclk[5] & 0x80) == 0x80)) {
 			int tmout;
 
 			CRITBEGIN
-			outTi3026(PMINFO TVP3026_XPLLADDR, 0x3F);
+			outTi3026(minfo, TVP3026_XPLLADDR, 0x3F);
 			for (tmout = 500000; tmout; --tmout) {
-				if (inTi3026(PMINFO TVP3026_XLOOPPLLDATA) & 0x40)
+				if (inTi3026(minfo, TVP3026_XLOOPPLLDATA) & 0x40)
 					break;
 				udelay(10);
 			}
@@ -660,18 +667,19 @@ static void Ti3026_restore(WPMINFO2) {
 #endif
 }
 
-static void Ti3026_reset(WPMINFO2) {
-
+static void Ti3026_reset(struct matrox_fb_info *minfo)
+{
 	DBG(__func__)
 
-	ti3026_ramdac_init(PMINFO2);
+	ti3026_ramdac_init(minfo);
 }
 
 static struct matrox_altout ti3026_output = {
 	.name	 = "Primary output",
 };
 
-static int Ti3026_preinit(WPMINFO2) {
+static int Ti3026_preinit(struct matrox_fb_info *minfo)
+{
 	static const int vxres_mill2[] = { 512,        640, 768,  800,  832,  960,
 					  1024, 1152, 1280,      1600, 1664, 1920,
 					  2048, 0};
@@ -706,19 +714,19 @@ static int Ti3026_preinit(WPMINFO2) {
 		hw->MXoptionReg |=  0x20000000;
 	pci_write_config_dword(minfo->pcidev, PCI_OPTION_REG, hw->MXoptionReg);
 
-	minfo->accel.ramdac_rev = inTi3026(PMINFO TVP3026_XSILICONREV);
+	minfo->accel.ramdac_rev = inTi3026(minfo, TVP3026_XSILICONREV);
 
-	outTi3026(PMINFO TVP3026_XCLKCTRL, TVP3026_XCLKCTRL_SRC_CLK0VGA | TVP3026_XCLKCTRL_CLKSTOPPED);
-	outTi3026(PMINFO TVP3026_XTRUECOLORCTRL, TVP3026_XTRUECOLORCTRL_PSEUDOCOLOR);
-	outTi3026(PMINFO TVP3026_XMUXCTRL, TVP3026_XMUXCTRL_VGA);
-
-	outTi3026(PMINFO TVP3026_XPLLADDR, 0x2A);
-	outTi3026(PMINFO TVP3026_XLOOPPLLDATA, 0x00);
-	outTi3026(PMINFO TVP3026_XPIXPLLDATA, 0x00);
+	outTi3026(minfo, TVP3026_XCLKCTRL, TVP3026_XCLKCTRL_SRC_CLK0VGA | TVP3026_XCLKCTRL_CLKSTOPPED);
+	outTi3026(minfo, TVP3026_XTRUECOLORCTRL, TVP3026_XTRUECOLORCTRL_PSEUDOCOLOR);
+	outTi3026(minfo, TVP3026_XMUXCTRL, TVP3026_XMUXCTRL_VGA);
+
+	outTi3026(minfo, TVP3026_XPLLADDR, 0x2A);
+	outTi3026(minfo, TVP3026_XLOOPPLLDATA, 0x00);
+	outTi3026(minfo, TVP3026_XPIXPLLDATA, 0x00);
 
 	mga_outb(M_MISC_REG, 0x67);
 
-	outTi3026(PMINFO TVP3026_XMEMPLLCTRL, TVP3026_XMEMPLLCTRL_STROBEMKC4 | TVP3026_XMEMPLLCTRL_MCLK_MCLKPLL);
+	outTi3026(minfo, TVP3026_XMEMPLLCTRL, TVP3026_XMEMPLLCTRL_STROBEMKC4 | TVP3026_XMEMPLLCTRL_MCLK_MCLKPLL);
 
 	mga_outl(M_RESET, 1);
 	udelay(250);
diff -puN drivers/video/matrox/matroxfb_accel.c~matroxfb-get-rid-of-unneeded-macros-wpminfo-and-friends drivers/video/matrox/matroxfb_accel.c
--- a/drivers/video/matrox/matroxfb_accel.c~matroxfb-get-rid-of-unneeded-macros-wpminfo-and-friends
+++ a/drivers/video/matrox/matroxfb_accel.c
@@ -107,7 +107,8 @@ static void matroxfb_imageblit(struct fb
 static void matroxfb_cfb4_fillrect(struct fb_info* info, const struct fb_fillrect* rect);
 static void matroxfb_cfb4_copyarea(struct fb_info* info, const struct fb_copyarea* area);
 
-void matrox_cfbX_init(WPMINFO2) {
+void matrox_cfbX_init(struct matrox_fb_info *minfo)
+{
 	u_int32_t maccess;
 	u_int32_t mpitch;
 	u_int32_t mopmode;
@@ -195,7 +196,9 @@ void matrox_cfbX_init(WPMINFO2) {
 
 EXPORT_SYMBOL(matrox_cfbX_init);
 
-static void matrox_accel_bmove(WPMINFO int vxres, int sy, int sx, int dy, int dx, int height, int width) {
+static void matrox_accel_bmove(struct matrox_fb_info *minfo, int vxres, int sy,
+			       int sx, int dy, int dx, int height, int width)
+{
 	int start, end;
 	CRITFLAGS
 
@@ -231,7 +234,10 @@ static void matrox_accel_bmove(WPMINFO i
 	CRITEND
 }
 
-static void matrox_accel_bmove_lin(WPMINFO int vxres, int sy, int sx, int dy, int dx, int height, int width) {
+static void matrox_accel_bmove_lin(struct matrox_fb_info *minfo, int vxres,
+				   int sy, int sx, int dy, int dx, int height,
+				   int width)
+{
 	int start, end;
 	CRITFLAGS
 
@@ -274,17 +280,18 @@ static void matroxfb_cfb4_copyarea(struc
 	if ((area->sx | area->dx | area->width) & 1)
 		cfb_copyarea(info, area);
 	else
-		matrox_accel_bmove_lin(PMINFO minfo->fbcon.var.xres_virtual >> 1, area->sy, area->sx >> 1, area->dy, area->dx >> 1, area->height, area->width >> 1);
+		matrox_accel_bmove_lin(minfo, minfo->fbcon.var.xres_virtual >> 1, area->sy, area->sx >> 1, area->dy, area->dx >> 1, area->height, area->width >> 1);
 }
 
 static void matroxfb_copyarea(struct fb_info* info, const struct fb_copyarea* area) {
 	MINFO_FROM_INFO(info);
 
-	matrox_accel_bmove(PMINFO minfo->fbcon.var.xres_virtual, area->sy, area->sx, area->dy, area->dx, area->height, area->width);
+	matrox_accel_bmove(minfo, minfo->fbcon.var.xres_virtual, area->sy, area->sx, area->dy, area->dx, area->height, area->width);
 }
 
-static void matroxfb_accel_clear(WPMINFO u_int32_t color, int sy, int sx, int height,
-		int width) {
+static void matroxfb_accel_clear(struct matrox_fb_info *minfo, u_int32_t color,
+				 int sy, int sx, int height, int width)
+{
 	CRITFLAGS
 
 	DBG(__func__)
@@ -306,12 +313,14 @@ static void matroxfb_fillrect(struct fb_
 
 	switch (rect->rop) {
 		case ROP_COPY:
-			matroxfb_accel_clear(PMINFO ((u_int32_t*)info->pseudo_palette)[rect->color], rect->dy, rect->dx, rect->height, rect->width);
+			matroxfb_accel_clear(minfo, ((u_int32_t *)info->pseudo_palette)[rect->color], rect->dy, rect->dx, rect->height, rect->width);
 			break;
 	}
 }
 
-static void matroxfb_cfb4_clear(WPMINFO u_int32_t bgx, int sy, int sx, int height, int width) {
+static void matroxfb_cfb4_clear(struct matrox_fb_info *minfo, u_int32_t bgx,
+				int sy, int sx, int height, int width)
+{
 	int whattodo;
 	CRITFLAGS
 
@@ -371,13 +380,15 @@ static void matroxfb_cfb4_fillrect(struc
 
 	switch (rect->rop) {
 		case ROP_COPY:
-			matroxfb_cfb4_clear(PMINFO ((u_int32_t*)info->pseudo_palette)[rect->color], rect->dy, rect->dx, rect->height, rect->width);
+			matroxfb_cfb4_clear(minfo, ((u_int32_t *)info->pseudo_palette)[rect->color], rect->dy, rect->dx, rect->height, rect->width);
 			break;
 	}
 }
 
-static void matroxfb_1bpp_imageblit(WPMINFO u_int32_t fgx, u_int32_t bgx,
-		const u_int8_t* chardata, int width, int height, int yy, int xx) {
+static void matroxfb_1bpp_imageblit(struct matrox_fb_info *minfo, u_int32_t fgx,
+				    u_int32_t bgx, const u_int8_t *chardata,
+				    int width, int height, int yy, int xx)
+{
 	u_int32_t step;
 	u_int32_t ydstlen;
 	u_int32_t xlen;
@@ -476,7 +487,7 @@ static void matroxfb_imageblit(struct fb
 
 		fgx = ((u_int32_t*)info->pseudo_palette)[image->fg_color];
 		bgx = ((u_int32_t*)info->pseudo_palette)[image->bg_color];
-		matroxfb_1bpp_imageblit(PMINFO fgx, bgx, image->data, image->width, image->height, image->dy, image->dx);
+		matroxfb_1bpp_imageblit(minfo, fgx, bgx, image->data, image->width, image->height, image->dy, image->dx);
 	} else {
 		/* Danger! image->depth is useless: logo painting code always
 		   passes framebuffer color depth here, although logo data are
diff -puN drivers/video/matrox/matroxfb_accel.h~matroxfb-get-rid-of-unneeded-macros-wpminfo-and-friends drivers/video/matrox/matroxfb_accel.h
--- a/drivers/video/matrox/matroxfb_accel.h~matroxfb-get-rid-of-unneeded-macros-wpminfo-and-friends
+++ a/drivers/video/matrox/matroxfb_accel.h
@@ -3,6 +3,6 @@
 
 #include "matroxfb_base.h"
 
-void matrox_cfbX_init(WPMINFO2);
+void matrox_cfbX_init(struct matrox_fb_info *minfo);
 
 #endif
diff -puN drivers/video/matrox/matroxfb_base.c~matroxfb-get-rid-of-unneeded-macros-wpminfo-and-friends drivers/video/matrox/matroxfb_base.c
--- a/drivers/video/matrox/matroxfb_base.c~matroxfb-get-rid-of-unneeded-macros-wpminfo-and-friends
+++ a/drivers/video/matrox/matroxfb_base.c
@@ -154,7 +154,8 @@ static struct fb_var_screeninfo vesafb_d
 
 
 /* --------------------------------------------------------------------- */
-static void update_crtc2(WPMINFO unsigned int pos) {
+static void update_crtc2(struct matrox_fb_info *minfo, unsigned int pos)
+{
 	struct matroxfb_dh_fb_info *info = minfo->crtc2.info;
 
 	/* Make sure that displays are compatible */
@@ -177,7 +178,8 @@ static void update_crtc2(WPMINFO unsigne
 	}
 }
 
-static void matroxfb_crtc1_panpos(WPMINFO2) {
+static void matroxfb_crtc1_panpos(struct matrox_fb_info *minfo)
+{
 	if (minfo->crtc1.panpos >= 0) {
 		unsigned long flags;
 		int panpos;
@@ -210,7 +212,7 @@ static irqreturn_t matrox_irq(int irq, v
 	if (status & 0x20) {
 		mga_outl(M_ICLEAR, 0x20);
 		minfo->crtc1.vsync.cnt++;
-		matroxfb_crtc1_panpos(PMINFO2);
+		matroxfb_crtc1_panpos(minfo);
 		wake_up_interruptible(&minfo->crtc1.vsync.wait);
 		handled = 1;
 	}
@@ -223,7 +225,8 @@ static irqreturn_t matrox_irq(int irq, v
 	return IRQ_RETVAL(handled);
 }
 
-int matroxfb_enable_irq(WPMINFO int reenable) {
+int matroxfb_enable_irq(struct matrox_fb_info *minfo, int reenable)
+{
 	u_int32_t bm;
 
 	if (minfo->devflags.accelerator == FB_ACCEL_MATROX_MGAG400)
@@ -252,10 +255,11 @@ int matroxfb_enable_irq(WPMINFO int reen
 	return 0;
 }
 
-static void matroxfb_disable_irq(WPMINFO2) {
+static void matroxfb_disable_irq(struct matrox_fb_info *minfo)
+{
 	if (test_and_clear_bit(0, &minfo->irq_flags)) {
 		/* Flush pending pan-at-vbl request... */
-		matroxfb_crtc1_panpos(PMINFO2);
+		matroxfb_crtc1_panpos(minfo);
 		if (minfo->devflags.accelerator == FB_ACCEL_MATROX_MGAG400)
 			mga_outl(M_IEN, mga_inl(M_IEN) & ~0x220);
 		else
@@ -264,7 +268,8 @@ static void matroxfb_disable_irq(WPMINFO
 	}
 }
 
-int matroxfb_wait_for_sync(WPMINFO u_int32_t crtc) {
+int matroxfb_wait_for_sync(struct matrox_fb_info *minfo, u_int32_t crtc)
+{
 	struct matrox_vsync *vs;
 	unsigned int cnt;
 	int ret;
@@ -282,7 +287,7 @@ int matroxfb_wait_for_sync(WPMINFO u_int
 		default:
 			return -ENODEV;
 	}
-	ret = matroxfb_enable_irq(PMINFO 0);
+	ret = matroxfb_enable_irq(minfo, 0);
 	if (ret) {
 		return ret;
 	}
@@ -293,7 +298,7 @@ int matroxfb_wait_for_sync(WPMINFO u_int
 		return ret;
 	}
 	if (ret == 0) {
-		matroxfb_enable_irq(PMINFO 1);
+		matroxfb_enable_irq(minfo, 1);
 		return -ETIMEDOUT;
 	}
 	return 0;
@@ -301,7 +306,9 @@ int matroxfb_wait_for_sync(WPMINFO u_int
 
 /* --------------------------------------------------------------------- */
 
-static void matrox_pan_var(WPMINFO struct fb_var_screeninfo *var) {
+static void matrox_pan_var(struct matrox_fb_info *minfo,
+			   struct fb_var_screeninfo *var)
+{
 	unsigned int pos;
 	unsigned short p0, p1, p2;
 #ifdef CONFIG_FB_MATROX_32MB
@@ -329,7 +336,7 @@ static void matrox_pan_var(WPMINFO struc
 #endif
 
 	/* FB_ACTIVATE_VBL and we can acquire interrupts? Honor FB_ACTIVATE_VBL then... */
-	vbl = (var->activate & FB_ACTIVATE_VBL) && (matroxfb_enable_irq(PMINFO 0) == 0);
+	vbl = (var->activate & FB_ACTIVATE_VBL) && (matroxfb_enable_irq(minfo, 0) == 0);
 
 	CRITBEGIN
 
@@ -349,12 +356,13 @@ static void matrox_pan_var(WPMINFO struc
 	}
 	matroxfb_DAC_unlock_irqrestore(flags);
 
-	update_crtc2(PMINFO pos);
+	update_crtc2(minfo, pos);
 
 	CRITEND
 }
 
-static void matroxfb_remove(WPMINFO int dummy) {
+static void matroxfb_remove(struct matrox_fb_info *minfo, int dummy)
+{
 	/* Currently we are holding big kernel lock on all dead & usecount updates.
 	 * Destroy everything after all users release it. Especially do not unregister
 	 * framebuffer and iounmap memory, neither fbmem nor fbcon-cfb* does not check
@@ -370,7 +378,7 @@ static void matroxfb_remove(WPMINFO int 
 	}
 	matroxfb_unregister_device(minfo);
 	unregister_framebuffer(&minfo->fbcon);
-	matroxfb_g450_shutdown(PMINFO2);
+	matroxfb_g450_shutdown(minfo);
 #ifdef CONFIG_MTRR
 	if (minfo->mtrr.vram_valid)
 		mtrr_del(minfo->mtrr.vram, minfo->video.base, minfo->video.len);
@@ -410,11 +418,11 @@ static int matroxfb_release(struct fb_in
 
 	if (user) {
 		if (0 == --minfo->userusecount) {
-			matroxfb_disable_irq(PMINFO2);
+			matroxfb_disable_irq(minfo);
 		}
 	}
 	if (!(--minfo->usecount) && minfo->dead) {
-		matroxfb_remove(PMINFO 0);
+		matroxfb_remove(minfo, 0);
 	}
 	return(0);
 }
@@ -425,11 +433,13 @@ static int matroxfb_pan_display(struct f
 
 	DBG(__func__)
 
-	matrox_pan_var(PMINFO var);
+	matrox_pan_var(minfo, var);
 	return 0;
 }
 
-static int matroxfb_get_final_bppShift(CPMINFO int bpp) {
+static int matroxfb_get_final_bppShift(const struct matrox_fb_info *minfo,
+				       int bpp)
+{
 	int bppshft2;
 
 	DBG(__func__)
@@ -445,7 +455,9 @@ static int matroxfb_get_final_bppShift(C
 	return bppshft2;
 }
 
-static int matroxfb_test_and_set_rounding(CPMINFO int xres, int bpp) {
+static int matroxfb_test_and_set_rounding(const struct matrox_fb_info *minfo,
+					  int xres, int bpp)
+{
 	int over;
 	int rounding;
 
@@ -476,7 +488,9 @@ static int matroxfb_test_and_set_roundin
 	return xres;
 }
 
-static int matroxfb_pitch_adjust(CPMINFO int xres, int bpp) {
+static int matroxfb_pitch_adjust(const struct matrox_fb_info *minfo, int xres,
+				 int bpp)
+{
 	const int* width;
 	int xres_new;
 
@@ -488,14 +502,14 @@ static int matroxfb_pitch_adjust(CPMINFO
 
 	if (minfo->devflags.precise_width) {
 		while (*width) {
-			if ((*width >= xres) && (matroxfb_test_and_set_rounding(PMINFO *width, bpp) == *width)) {
+			if ((*width >= xres) && (matroxfb_test_and_set_rounding(minfo, *width, bpp) == *width)) {
 				break;
 			}
 			width++;
 		}
 		xres_new = *width;
 	} else {
-		xres_new = matroxfb_test_and_set_rounding(PMINFO xres, bpp);
+		xres_new = matroxfb_test_and_set_rounding(minfo, xres, bpp);
 	}
 	return xres_new;
 }
@@ -522,7 +536,10 @@ static int matroxfb_get_cmap_len(struct 
 	return 16;	/* return something reasonable... or panic()? */
 }
 
-static int matroxfb_decode_var(CPMINFO struct fb_var_screeninfo *var, int *visual, int *video_cmap_len, unsigned int* ydstorg) {
+static int matroxfb_decode_var(const struct matrox_fb_info *minfo,
+			       struct fb_var_screeninfo *var, int *visual,
+			       int *video_cmap_len, unsigned int* ydstorg)
+{
 	struct RGBT {
 		unsigned char bpp;
 		struct {
@@ -564,7 +581,7 @@ static int matroxfb_decode_var(CPMINFO s
 	if (var->xres_virtual < var->xres)
 		var->xres_virtual = var->xres;
 
-	var->xres_virtual = matroxfb_pitch_adjust(PMINFO var->xres_virtual, bpp);
+	var->xres_virtual = matroxfb_pitch_adjust(minfo, var->xres_virtual, bpp);
 	memlen = var->xres_virtual * bpp * var->yres_virtual / 8;
 	if (memlen > vramlen) {
 		var->yres_virtual = vramlen * 8 / (var->xres_virtual * bpp);
@@ -700,7 +717,7 @@ static int matroxfb_setcolreg(unsigned r
 	return 0;
 }
 
-static void matroxfb_init_fix(WPMINFO2)
+static void matroxfb_init_fix(struct matrox_fb_info *minfo)
 {
 	struct fb_fix_screeninfo *fix = &minfo->fbcon.fix;
 	DBG(__func__)
@@ -715,7 +732,7 @@ static void matroxfb_init_fix(WPMINFO2)
 	fix->accel = minfo->devflags.accelerator;
 }
 
-static void matroxfb_update_fix(WPMINFO2)
+static void matroxfb_update_fix(struct matrox_fb_info *minfo)
 {
 	struct fb_fix_screeninfo *fix = &minfo->fbcon.fix;
 	DBG(__func__)
@@ -737,7 +754,7 @@ static int matroxfb_check_var(struct fb_
 	if (minfo->dead) {
 		return -ENXIO;
 	}
-	if ((err = matroxfb_decode_var(PMINFO var, &visual, &cmap_len, &ydstorg)) != 0)
+	if ((err = matroxfb_decode_var(minfo, var, &visual, &cmap_len, &ydstorg)) != 0)
 		return err;
 	return 0;
 }
@@ -758,10 +775,10 @@ static int matroxfb_set_par(struct fb_in
 	}
 
 	var = &info->var;
-	if ((err = matroxfb_decode_var(PMINFO var, &visual, &cmap_len, &ydstorg)) != 0)
+	if ((err = matroxfb_decode_var(minfo, var, &visual, &cmap_len, &ydstorg)) != 0)
 		return err;
 	minfo->fbcon.screen_base = vaddr_va(minfo->video.vbase) + ydstorg;
-	matroxfb_update_fix(PMINFO2);
+	matroxfb_update_fix(minfo);
 	minfo->fbcon.fix.visual = visual;
 	minfo->fbcon.fix.type = FB_TYPE_PACKED_PIXELS;
 	minfo->fbcon.fix.type_aux = 0;
@@ -777,7 +794,7 @@ static int matroxfb_set_par(struct fb_in
 			minfo->curr.ydstorg.pixels = ydstorg;
 		else
 			minfo->curr.ydstorg.pixels = (ydstorg * 8) / var->bits_per_pixel;
-		minfo->curr.final_bppShift = matroxfb_get_final_bppShift(PMINFO var->bits_per_pixel);
+		minfo->curr.final_bppShift = matroxfb_get_final_bppShift(minfo, var->bits_per_pixel);
 		{	struct my_timming mt;
 			struct matrox_hw_state* hw;
 			int out;
@@ -805,7 +822,7 @@ static int matroxfb_set_par(struct fb_in
 			up_read(&minfo->altout.lock);
 			minfo->crtc1.pixclock = mt.pixclock;
 			minfo->crtc1.mnp = mt.mnp;
-			minfo->hw_switch->init(PMINFO &mt);
+			minfo->hw_switch->init(minfo, &mt);
 			pos = (var->yoffset * var->xres_virtual + var->xoffset) * minfo->curr.final_bppShift / 32;
 			pos += minfo->curr.ydstorg.chunks;
 
@@ -813,8 +830,8 @@ static int matroxfb_set_par(struct fb_in
 			hw->CRTC[0x0C] = (pos & 0xFF00) >> 8;
 			hw->CRTCEXT[0] = (hw->CRTCEXT[0] & 0xF0) | ((pos >> 16) & 0x0F) | ((pos >> 14) & 0x40);
 			hw->CRTCEXT[8] = pos >> 21;
-			minfo->hw_switch->restore(PMINFO2);
-			update_crtc2(PMINFO pos);
+			minfo->hw_switch->restore(minfo);
+			update_crtc2(minfo, pos);
 			down_read(&minfo->altout.lock);
 			for (out = 0; out < MATROXFB_MAX_OUTPUTS; out++) {
 				if (minfo->outputs[out].src == MATROXFB_SRC_CRTC1 &&
@@ -829,18 +846,19 @@ static int matroxfb_set_par(struct fb_in
 				}
 			}
 			up_read(&minfo->altout.lock);
-			matrox_cfbX_init(PMINFO2);
+			matrox_cfbX_init(minfo);
 		}
 	}
 	minfo->initialized = 1;
 	return 0;
 }
 
-static int matroxfb_get_vblank(WPMINFO struct fb_vblank *vblank)
+static int matroxfb_get_vblank(struct matrox_fb_info *minfo,
+			       struct fb_vblank *vblank)
 {
 	unsigned int sts1;
 
-	matroxfb_enable_irq(PMINFO 0);
+	matroxfb_enable_irq(minfo, 0);
 	memset(vblank, 0, sizeof(*vblank));
 	vblank->flags = FB_VBLANK_HAVE_VCOUNT | FB_VBLANK_HAVE_VSYNC |
 			FB_VBLANK_HAVE_VBLANK | FB_VBLANK_HAVE_HBLANK;
@@ -886,7 +904,7 @@ static int matroxfb_ioctl(struct fb_info
 				struct fb_vblank vblank;
 				int err;
 
-				err = matroxfb_get_vblank(PMINFO &vblank);
+				err = matroxfb_get_vblank(minfo, &vblank);
 				if (err)
 					return err;
 				if (copy_to_user(argp, &vblank, sizeof(vblank)))
@@ -900,7 +918,7 @@ static int matroxfb_ioctl(struct fb_info
 				if (get_user(crt, (u_int32_t __user *)arg))
 					return -EFAULT;
 
-				return matroxfb_wait_for_sync(PMINFO crt);
+				return matroxfb_wait_for_sync(minfo, crt);
 			}
 		case MATROXFB_SET_OUTPUT_MODE:
 			{
@@ -1277,7 +1295,9 @@ static char outputs[8];			/* "matrox:out
 static char videomode[64];		/* "matrox:mode:xxxxx" or "matrox:xxxxx" */
 #endif
 
-static int matroxfb_getmemory(WPMINFO unsigned int maxSize, unsigned int *realSize){
+static int matroxfb_getmemory(struct matrox_fb_info *minfo,
+			      unsigned int maxSize, unsigned int *realSize)
+{
 	vaddr_t vm;
 	unsigned int offs;
 	unsigned int offs2;
@@ -1554,7 +1574,8 @@ static struct fb_videomode defaultmode =
 
 static int hotplug = 0;
 
-static void setDefaultOutputs(WPMINFO2) {
+static void setDefaultOutputs(struct matrox_fb_info *minfo)
+{
 	unsigned int i;
 	const char* ptr;
 
@@ -1587,7 +1608,8 @@ static void setDefaultOutputs(WPMINFO2) 
 	outputs[0] = 0;
 }
 
-static int initMatrox2(WPMINFO struct board* b){
+static int initMatrox2(struct matrox_fb_info *minfo, struct board *b)
+{
 	unsigned long ctrlptr_phys = 0;
 	unsigned long video_base_phys = 0;
 	unsigned int memsize;
@@ -1636,7 +1658,7 @@ static int initMatrox2(WPMINFO struct bo
 	minfo->devflags.g450dac = (b->flags & DEVF_G450DAC) != 0;
 	minfo->devflags.textstep = minfo->devflags.vgastep * minfo->devflags.textmode;
 	minfo->devflags.textvram = 65536 / minfo->devflags.textmode;
-	setDefaultOutputs(PMINFO2);
+	setDefaultOutputs(minfo);
 	if (b->flags & DEVF_PANELLINK_CAPABLE) {
 		minfo->outputs[2].data = minfo;
 		minfo->outputs[2].output = &panellink_output;
@@ -1719,13 +1741,13 @@ static int initMatrox2(WPMINFO struct bo
 	}
 
 	err = -ENXIO;
-	matroxfb_read_pins(PMINFO2);
-	if (minfo->hw_switch->preinit(PMINFO2)) {
+	matroxfb_read_pins(minfo);
+	if (minfo->hw_switch->preinit(minfo)) {
 		goto failVideoIO;
 	}
 
 	err = -ENOMEM;
-	if (!matroxfb_getmemory(PMINFO memsize, &minfo->video.len) || !minfo->video.len) {
+	if (!matroxfb_getmemory(minfo, memsize, &minfo->video.len) || !minfo->video.len) {
 		printk(KERN_ERR "matroxfb: cannot determine memory size\n");
 		goto failVideoIO;
 	}
@@ -1745,8 +1767,8 @@ static int initMatrox2(WPMINFO struct bo
 
 	if (!minfo->devflags.novga)
 		request_region(0x3C0, 32, "matrox");
-	matroxfb_g450_connect(PMINFO2);
-	minfo->hw_switch->reset(PMINFO2);
+	matroxfb_g450_connect(minfo);
+	minfo->hw_switch->reset(minfo);
 
 	minfo->fbcon.monspecs.hfmin = 0;
 	minfo->fbcon.monspecs.hfmax = fh;
@@ -1870,7 +1892,7 @@ static int initMatrox2(WPMINFO struct bo
 		vesafb_defined.yres_virtual = 65536; /* large enough to be INF, but small enough
 							to yres_virtual * xres_virtual < 2^32 */
 	}
-	matroxfb_init_fix(PMINFO2);
+	matroxfb_init_fix(minfo);
 	minfo->fbcon.screen_base = vaddr_va(minfo->video.vbase);
 	/* Normalize values (namely yres_virtual) */
 	matroxfb_check_var(&vesafb_defined, &minfo->fbcon);
@@ -1910,7 +1932,7 @@ static int initMatrox2(WPMINFO struct bo
 
 	return 0;
 failVideoIO:;
-	matroxfb_g450_shutdown(PMINFO2);
+	matroxfb_g450_shutdown(minfo);
 	mga_iounmap(minfo->video.vbase);
 failCtrlIO:;
 	mga_iounmap(minfo->mmio.vbase);
@@ -2075,7 +2097,7 @@ static int matroxfb_probe(struct pci_dev
 	init_waitqueue_head(&minfo->crtc2.vsync.wait);
 	minfo->crtc1.panpos = -1;
 
-	err = initMatrox2(PMINFO b);
+	err = initMatrox2(minfo, b);
 	if (!err) {
 		matroxfb_register_device(minfo);
 		return 0;
@@ -2088,7 +2110,7 @@ static void pci_remove_matrox(struct pci
 	struct matrox_fb_info* minfo;
 
 	minfo = pci_get_drvdata(pdev);
-	matroxfb_remove(PMINFO 1);
+	matroxfb_remove(minfo, 1);
 }
 
 static struct pci_device_id matroxfb_devices[] = {
diff -puN drivers/video/matrox/matroxfb_base.h~matroxfb-get-rid-of-unneeded-macros-wpminfo-and-friends drivers/video/matrox/matroxfb_base.h
--- a/drivers/video/matrox/matroxfb_base.h~matroxfb-get-rid-of-unneeded-macros-wpminfo-and-friends
+++ a/drivers/video/matrox/matroxfb_base.h
@@ -524,22 +524,15 @@ struct matrox_fb_info {
 
 #define info2minfo(info) container_of(info, struct matrox_fb_info, fbcon)
 
-#define WPMINFO2 struct matrox_fb_info* minfo
-#define WPMINFO  WPMINFO2 ,
-#define CPMINFO2 const struct matrox_fb_info* minfo
-#define CPMINFO	 CPMINFO2 ,
-#define PMINFO2  minfo
-#define PMINFO   PMINFO2 ,
-
 #define MINFO_FROM(x)	   struct matrox_fb_info* minfo = x
 
 #define MINFO_FROM_INFO(x) MINFO_FROM(info2minfo(x))
 
 struct matrox_switch {
-	int	(*preinit)(WPMINFO2);
-	void	(*reset)(WPMINFO2);
-	int	(*init)(WPMINFO struct my_timming*);
-	void	(*restore)(WPMINFO2);
+	int	(*preinit)(struct matrox_fb_info *minfo);
+	void	(*reset)(struct matrox_fb_info *minfo);
+	int	(*init)(struct matrox_fb_info *minfo, struct my_timming*);
+	void	(*restore)(struct matrox_fb_info *minfo);
 };
 
 struct matroxfb_driver {
@@ -729,11 +722,12 @@ void matroxfb_unregister_driver(struct m
 #define matroxfb_DAC_unlock()                 spin_unlock(&minfo->lock.DAC)
 #define matroxfb_DAC_lock_irqsave(flags)      spin_lock_irqsave(&minfo->lock.DAC, flags)
 #define matroxfb_DAC_unlock_irqrestore(flags) spin_unlock_irqrestore(&minfo->lock.DAC, flags)
-extern void matroxfb_DAC_out(CPMINFO int reg, int val);
-extern int matroxfb_DAC_in(CPMINFO int reg);
+extern void matroxfb_DAC_out(const struct matrox_fb_info *minfo, int reg,
+			     int val);
+extern int matroxfb_DAC_in(const struct matrox_fb_info *minfo, int reg);
 extern void matroxfb_var2my(struct fb_var_screeninfo* fvsi, struct my_timming* mt);
-extern int matroxfb_wait_for_sync(WPMINFO u_int32_t crtc);
-extern int matroxfb_enable_irq(WPMINFO int reenable);
+extern int matroxfb_wait_for_sync(struct matrox_fb_info *minfo, u_int32_t crtc);
+extern int matroxfb_enable_irq(struct matrox_fb_info *minfo, int reenable);
 
 #ifdef MATROXFB_USE_SPINLOCKS
 #define CRITBEGIN  spin_lock_irqsave(&minfo->lock.accel, critflags);
diff -puN drivers/video/matrox/matroxfb_crtc2.c~matroxfb-get-rid-of-unneeded-macros-wpminfo-and-friends drivers/video/matrox/matroxfb_crtc2.c
--- a/drivers/video/matrox/matroxfb_crtc2.c~matroxfb-get-rid-of-unneeded-macros-wpminfo-and-friends
+++ a/drivers/video/matrox/matroxfb_crtc2.c
@@ -369,8 +369,8 @@ static int matroxfb_dh_set_par(struct fb
 		} else {
 			matroxfb_dh_disable(m2info);
 		}
-		DAC1064_global_init(PMINFO2);
-		DAC1064_global_restore(PMINFO2);
+		DAC1064_global_init(minfo);
+		DAC1064_global_restore(minfo);
 		down_read(&minfo->altout.lock);
 		for (out = 0; out < MATROXFB_MAX_OUTPUTS; out++) {
 			if (minfo->outputs[out].src == MATROXFB_SRC_CRTC2 &&
@@ -401,7 +401,7 @@ static int matroxfb_dh_pan_display(struc
 static int matroxfb_dh_get_vblank(const struct matroxfb_dh_fb_info* m2info, struct fb_vblank* vblank) {
 	MINFO_FROM(m2info->primary_dev);
 
-	matroxfb_enable_irq(PMINFO 0);
+	matroxfb_enable_irq(minfo, 0);
 	memset(vblank, 0, sizeof(*vblank));
 	vblank->flags = FB_VBLANK_HAVE_VCOUNT | FB_VBLANK_HAVE_VBLANK;
 	/* mask out reserved bits + field number (odd/even) */
@@ -449,7 +449,7 @@ static int matroxfb_dh_ioctl(struct fb_i
 
 				if (crt != 0)
 					return -ENODEV;
-				return matroxfb_wait_for_sync(PMINFO 1);
+				return matroxfb_wait_for_sync(minfo, 1);
 			}
 		case MATROXFB_SET_OUTPUT_MODE:
 		case MATROXFB_GET_OUTPUT_MODE:
@@ -595,7 +595,9 @@ static struct fb_var_screeninfo matroxfb
 		0, {0,0,0,0,0}
 };
 
-static int matroxfb_dh_regit(CPMINFO struct matroxfb_dh_fb_info* m2info) {
+static int matroxfb_dh_regit(const struct matrox_fb_info *minfo,
+			     struct matroxfb_dh_fb_info *m2info)
+{
 #define minfo (m2info->primary_dev)
 	void* oldcrtc2;
 
@@ -649,7 +651,7 @@ static int matroxfb_dh_regit(CPMINFO str
 
 static int matroxfb_dh_registerfb(struct matroxfb_dh_fb_info* m2info) {
 #define minfo (m2info->primary_dev)
-	if (matroxfb_dh_regit(PMINFO m2info)) {
+	if (matroxfb_dh_regit(minfo, m2info)) {
 		printk(KERN_ERR "matroxfb_crtc2: secondary head failed to register\n");
 		return -1;
 	}
diff -puN drivers/video/matrox/matroxfb_g450.c~matroxfb-get-rid-of-unneeded-macros-wpminfo-and-friends drivers/video/matrox/matroxfb_g450.c
--- a/drivers/video/matrox/matroxfb_g450.c~matroxfb-get-rid-of-unneeded-macros-wpminfo-and-friends
+++ a/drivers/video/matrox/matroxfb_g450.c
@@ -80,50 +80,57 @@ static int get_ctrl_id(__u32 v4l2_id) {
 	return -EINVAL;
 }
 
-static inline int* get_ctrl_ptr(WPMINFO unsigned int idx) {
+static inline int *get_ctrl_ptr(struct matrox_fb_info *minfo, unsigned int idx)
+{
 	return (int*)((char*)minfo + g450_controls[idx].control);
 }
 
-static void tvo_fill_defaults(WPMINFO2) {
+static void tvo_fill_defaults(struct matrox_fb_info *minfo)
+{
 	unsigned int i;
 	
 	for (i = 0; i < G450CTRLS; i++) {
-		*get_ctrl_ptr(PMINFO i) = g450_controls[i].desc.default_value;
+		*get_ctrl_ptr(minfo, i) = g450_controls[i].desc.default_value;
 	}
 }
 
-static int cve2_get_reg(WPMINFO int reg) {
+static int cve2_get_reg(struct matrox_fb_info *minfo, int reg)
+{
 	unsigned long flags;
 	int val;
 	
 	matroxfb_DAC_lock_irqsave(flags);
-	matroxfb_DAC_out(PMINFO 0x87, reg);
-	val = matroxfb_DAC_in(PMINFO 0x88);
+	matroxfb_DAC_out(minfo, 0x87, reg);
+	val = matroxfb_DAC_in(minfo, 0x88);
 	matroxfb_DAC_unlock_irqrestore(flags);
 	return val;
 }
 
-static void cve2_set_reg(WPMINFO int reg, int val) {
+static void cve2_set_reg(struct matrox_fb_info *minfo, int reg, int val)
+{
 	unsigned long flags;
 
 	matroxfb_DAC_lock_irqsave(flags);
-	matroxfb_DAC_out(PMINFO 0x87, reg);
-	matroxfb_DAC_out(PMINFO 0x88, val);
+	matroxfb_DAC_out(minfo, 0x87, reg);
+	matroxfb_DAC_out(minfo, 0x88, val);
 	matroxfb_DAC_unlock_irqrestore(flags);
 }
 
-static void cve2_set_reg10(WPMINFO int reg, int val) {
+static void cve2_set_reg10(struct matrox_fb_info *minfo, int reg, int val)
+{
 	unsigned long flags;
 
 	matroxfb_DAC_lock_irqsave(flags);
-	matroxfb_DAC_out(PMINFO 0x87, reg);
-	matroxfb_DAC_out(PMINFO 0x88, val >> 2);
-	matroxfb_DAC_out(PMINFO 0x87, reg + 1);
-	matroxfb_DAC_out(PMINFO 0x88, val & 3);
+	matroxfb_DAC_out(minfo, 0x87, reg);
+	matroxfb_DAC_out(minfo, 0x88, val >> 2);
+	matroxfb_DAC_out(minfo, 0x87, reg + 1);
+	matroxfb_DAC_out(minfo, 0x88, val & 3);
 	matroxfb_DAC_unlock_irqrestore(flags);
 }
 
-static void g450_compute_bwlevel(CPMINFO int *bl, int *wl) {
+static void g450_compute_bwlevel(const struct matrox_fb_info *minfo, int *bl,
+				 int *wl)
+{
 	const int b = minfo->altout.tvo_params.brightness + BLMIN;
 	const int c = minfo->altout.tvo_params.contrast;
 
@@ -162,7 +169,7 @@ static int g450_set_ctrl(void* md, struc
 	/*
 	 * Check if changed.
 	 */
-	if (p->value == *get_ctrl_ptr(PMINFO i)) return 0;
+	if (p->value == *get_ctrl_ptr(minfo, i)) return 0;
 
 	/*
 	 * Check limits.
@@ -173,31 +180,31 @@ static int g450_set_ctrl(void* md, struc
 	/*
 	 * Store new value.
 	 */
-	*get_ctrl_ptr(PMINFO i) = p->value;
+	*get_ctrl_ptr(minfo, i) = p->value;
 
 	switch (p->id) {
 		case V4L2_CID_BRIGHTNESS:
 		case V4L2_CID_CONTRAST:
 			{
 				int blacklevel, whitelevel;
-				g450_compute_bwlevel(PMINFO &blacklevel, &whitelevel);
-				cve2_set_reg10(PMINFO 0x0e, blacklevel);
-				cve2_set_reg10(PMINFO 0x1e, whitelevel);
+				g450_compute_bwlevel(minfo, &blacklevel, &whitelevel);
+				cve2_set_reg10(minfo, 0x0e, blacklevel);
+				cve2_set_reg10(minfo, 0x1e, whitelevel);
 			}
 			break;
 		case V4L2_CID_SATURATION:
-			cve2_set_reg(PMINFO 0x20, p->value);
-			cve2_set_reg(PMINFO 0x22, p->value);
+			cve2_set_reg(minfo, 0x20, p->value);
+			cve2_set_reg(minfo, 0x22, p->value);
 			break;
 		case V4L2_CID_HUE:
-			cve2_set_reg(PMINFO 0x25, p->value);
+			cve2_set_reg(minfo, 0x25, p->value);
 			break;
 		case MATROXFB_CID_TESTOUT:
 			{
-				unsigned char val = cve2_get_reg (PMINFO 0x05);
+				unsigned char val = cve2_get_reg(minfo, 0x05);
 				if (p->value) val |=  0x02;
 				else          val &= ~0x02;
-				cve2_set_reg(PMINFO 0x05, val);
+				cve2_set_reg(minfo, 0x05, val);
 			}
 			break;
 	}
@@ -212,7 +219,7 @@ static int g450_get_ctrl(void* md, struc
 	
 	i = get_ctrl_id(p->id);
 	if (i < 0) return -EINVAL;
-	p->value = *get_ctrl_ptr(PMINFO i);
+	p->value = *get_ctrl_ptr(minfo, i);
 	return 0;
 }
 
@@ -226,7 +233,9 @@ struct output_desc {
 	unsigned int	v_total;
 };
 
-static void computeRegs(WPMINFO struct mavenregs* r, struct my_timming* mt, const struct output_desc* outd) {
+static void computeRegs(struct matrox_fb_info *minfo, struct mavenregs *r,
+			struct my_timming *mt, const struct output_desc *outd)
+{
 	u_int32_t chromasc;
 	u_int32_t hlen;
 	u_int32_t hsl;
@@ -251,10 +260,10 @@ static void computeRegs(WPMINFO struct m
 
 	dprintk(KERN_DEBUG "Want %u kHz pixclock\n", (unsigned int)piic);
 	
-	mnp = matroxfb_g450_setclk(PMINFO piic, M_VIDEO_PLL);
+	mnp = matroxfb_g450_setclk(minfo, piic, M_VIDEO_PLL);
 	
 	mt->mnp = mnp;
-	mt->pixclock = g450_mnp2f(PMINFO mnp);
+	mt->pixclock = g450_mnp2f(minfo, mnp);
 
 	dprintk(KERN_DEBUG "MNP=%08X\n", mnp);
 
@@ -490,20 +499,22 @@ static void cve2_init_TVdata(int norm, s
  	return;
 }
 
-#define LR(x) cve2_set_reg(PMINFO (x), m->regs[(x)])
-static void cve2_init_TV(WPMINFO const struct mavenregs* m) {
+#define LR(x) cve2_set_reg(minfo, (x), m->regs[(x)])
+static void cve2_init_TV(struct matrox_fb_info *minfo,
+			 const struct mavenregs *m)
+{
 	int i;
 
 	LR(0x80);
 	LR(0x82); LR(0x83);
 	LR(0x84); LR(0x85);
 	
-	cve2_set_reg(PMINFO 0x3E, 0x01);
+	cve2_set_reg(minfo, 0x3E, 0x01);
 	
 	for (i = 0; i < 0x3E; i++) {
 		LR(i);
 	}
-	cve2_set_reg(PMINFO 0x3E, 0x00);
+	cve2_set_reg(minfo, 0x3E, 0x00);
 }
 
 static int matroxfb_g450_compute(void* md, struct my_timming* mt) {
@@ -518,7 +529,7 @@ static int matroxfb_g450_compute(void* m
 		cve2_init_TVdata(minfo->outputs[1].mode, &minfo->hw.maven, &outd);
 		{
 			int blacklevel, whitelevel;
-			g450_compute_bwlevel(PMINFO &blacklevel, &whitelevel);
+			g450_compute_bwlevel(minfo, &blacklevel, &whitelevel);
 			minfo->hw.maven.regs[0x0E] = blacklevel >> 2;
 			minfo->hw.maven.regs[0x0F] = blacklevel & 3;
 			minfo->hw.maven.regs[0x1E] = whitelevel >> 2;
@@ -533,12 +544,12 @@ static int matroxfb_g450_compute(void* m
 				minfo->hw.maven.regs[0x05] |= 0x02;
 			}
 		}
-		computeRegs(PMINFO &minfo->hw.maven, mt, outd);
+		computeRegs(minfo, &minfo->hw.maven, mt, outd);
 	} else if (mt->mnp < 0) {
 		/* We must program clocks before CRTC2, otherwise interlaced mode
 		   startup may fail */
-		mt->mnp = matroxfb_g450_setclk(PMINFO mt->pixclock, (mt->crtc == MATROXFB_SRC_CRTC1) ? M_PIXEL_PLL_C : M_VIDEO_PLL);
-		mt->pixclock = g450_mnp2f(PMINFO mt->mnp);
+		mt->mnp = matroxfb_g450_setclk(minfo, mt->pixclock, (mt->crtc == MATROXFB_SRC_CRTC1) ? M_PIXEL_PLL_C : M_VIDEO_PLL);
+		mt->pixclock = g450_mnp2f(minfo, mt->mnp);
 	}
 	dprintk(KERN_DEBUG "Pixclock = %u\n", mt->pixclock);
 	return 0;
@@ -548,7 +559,7 @@ static int matroxfb_g450_program(void* m
 	MINFO_FROM(md);
 	
 	if (minfo->outputs[1].mode != MATROXFB_OUTPUT_MODE_MONITOR) {
-		cve2_init_TV(PMINFO &minfo->hw.maven);
+		cve2_init_TV(minfo, &minfo->hw.maven);
 	}
 	return 0;
 }
@@ -567,8 +578,8 @@ static int g450_dvi_compute(void* md, st
 	MINFO_FROM(md);
 
 	if (mt->mnp < 0) {
-		mt->mnp = matroxfb_g450_setclk(PMINFO mt->pixclock, (mt->crtc == MATROXFB_SRC_CRTC1) ? M_PIXEL_PLL_C : M_VIDEO_PLL);
-		mt->pixclock = g450_mnp2f(PMINFO mt->mnp);
+		mt->mnp = matroxfb_g450_setclk(minfo, mt->pixclock, (mt->crtc == MATROXFB_SRC_CRTC1) ? M_PIXEL_PLL_C : M_VIDEO_PLL);
+		mt->pixclock = g450_mnp2f(minfo, mt->mnp);
 	}
 	return 0;
 }
@@ -588,10 +599,11 @@ static struct matrox_altout matroxfb_g45
 	.compute	= g450_dvi_compute,
 };
 
-void matroxfb_g450_connect(WPMINFO2) {
+void matroxfb_g450_connect(struct matrox_fb_info *minfo)
+{
 	if (minfo->devflags.g450dac) {
 		down_write(&minfo->altout.lock);
-		tvo_fill_defaults(PMINFO2);
+		tvo_fill_defaults(minfo);
 		minfo->outputs[1].src = minfo->outputs[1].default_src;
 		minfo->outputs[1].data = minfo;
 		minfo->outputs[1].output = &matroxfb_g450_altout;
@@ -604,7 +616,8 @@ void matroxfb_g450_connect(WPMINFO2) {
 	}
 }
 
-void matroxfb_g450_shutdown(WPMINFO2) {
+void matroxfb_g450_shutdown(struct matrox_fb_info *minfo)
+{
 	if (minfo->devflags.g450dac) {
 		down_write(&minfo->altout.lock);
 		minfo->outputs[1].src = MATROXFB_SRC_NONE;
diff -puN drivers/video/matrox/matroxfb_g450.h~matroxfb-get-rid-of-unneeded-macros-wpminfo-and-friends drivers/video/matrox/matroxfb_g450.h
--- a/drivers/video/matrox/matroxfb_g450.h~matroxfb-get-rid-of-unneeded-macros-wpminfo-and-friends
+++ a/drivers/video/matrox/matroxfb_g450.h
@@ -4,11 +4,11 @@
 #include "matroxfb_base.h"
 
 #ifdef CONFIG_FB_MATROX_G
-void matroxfb_g450_connect(WPMINFO2);
-void matroxfb_g450_shutdown(WPMINFO2);
+void matroxfb_g450_connect(struct matrox_fb_info *minfo);
+void matroxfb_g450_shutdown(struct matrox_fb_info *minfo);
 #else
-static inline void matroxfb_g450_connect(WPMINFO2) { };
-static inline void matroxfb_g450_shutdown(WPMINFO2) { };
+static inline void matroxfb_g450_connect(struct matrox_fb_info *minfo) { };
+static inline void matroxfb_g450_shutdown(struct matrox_fb_info *minfo) { };
 #endif
 
 #endif /* __MATROXFB_G450_H__ */
diff -puN drivers/video/matrox/matroxfb_misc.c~matroxfb-get-rid-of-unneeded-macros-wpminfo-and-friends drivers/video/matrox/matroxfb_misc.c
--- a/drivers/video/matrox/matroxfb_misc.c~matroxfb-get-rid-of-unneeded-macros-wpminfo-and-friends
+++ a/drivers/video/matrox/matroxfb_misc.c
@@ -89,13 +89,15 @@
 #include <linux/interrupt.h>
 #include <linux/matroxfb.h>
 
-void matroxfb_DAC_out(CPMINFO int reg, int val) {
+void matroxfb_DAC_out(const struct matrox_fb_info *minfo, int reg, int val)
+{
 	DBG_REG(__func__)
 	mga_outb(M_RAMDAC_BASE+M_X_INDEX, reg);
 	mga_outb(M_RAMDAC_BASE+M_X_DATAREG, val);
 }
 
-int matroxfb_DAC_in(CPMINFO int reg) {
+int matroxfb_DAC_in(const struct matrox_fb_info *minfo, int reg)
+{
 	DBG_REG(__func__)
 	mga_outb(M_RAMDAC_BASE+M_X_INDEX, reg);
 	return mga_inb(M_RAMDAC_BASE+M_X_DATAREG);
@@ -184,7 +186,8 @@ int matroxfb_PLL_calcclock(const struct 
 	return bestvco;
 }
 
-int matroxfb_vgaHWinit(WPMINFO struct my_timming* m) {
+int matroxfb_vgaHWinit(struct matrox_fb_info *minfo, struct my_timming *m)
+{
 	unsigned int hd, hs, he, hbe, ht;
 	unsigned int vd, vs, ve, vt, lc;
 	unsigned int wd;
@@ -331,7 +334,8 @@ int matroxfb_vgaHWinit(WPMINFO struct my
 	return 0;
 };
 
-void matroxfb_vgaHWrestore(WPMINFO2) {
+void matroxfb_vgaHWrestore(struct matrox_fb_info *minfo)
+{
 	int i;
 	struct matrox_hw_state * const hw = &minfo->hw;
 	CRITFLAGS
@@ -522,7 +526,9 @@ static void parse_bios(unsigned char __i
 #endif
 }
 
-static int parse_pins1(WPMINFO const struct matrox_bios* bd) {
+static int parse_pins1(struct matrox_fb_info *minfo,
+		       const struct matrox_bios *bd)
+{
 	unsigned int maxdac;
 
 	switch (bd->pins[22]) {
@@ -542,7 +548,8 @@ static int parse_pins1(WPMINFO const str
 	return 0;
 }
 
-static void default_pins1(WPMINFO2) {
+static void default_pins1(struct matrox_fb_info *minfo)
+{
 	/* Millennium */
 	minfo->limits.pixel.vcomax	= 220000;
 	minfo->values.pll.system	=  50000;
@@ -550,7 +557,9 @@ static void default_pins1(WPMINFO2) {
 	minfo->values.reg.mctlwtst	= 0x00030101;
 }
 
-static int parse_pins2(WPMINFO const struct matrox_bios* bd) {
+static int parse_pins2(struct matrox_fb_info *minfo,
+		       const struct matrox_bios *bd)
+{
 	minfo->limits.pixel.vcomax	=
 	minfo->limits.system.vcomax	= (bd->pins[41] == 0xFF) ? 230000 : ((bd->pins[41] + 100) * 1000);
 	minfo->values.reg.mctlwtst	= ((bd->pins[51] & 0x01) ? 0x00000001 : 0) |
@@ -562,7 +571,8 @@ static int parse_pins2(WPMINFO const str
 	return 0;
 }
 
-static void default_pins2(WPMINFO2) {
+static void default_pins2(struct matrox_fb_info *minfo)
+{
 	/* Millennium II, Mystique */
 	minfo->limits.pixel.vcomax	=
 	minfo->limits.system.vcomax	= 230000;
@@ -571,7 +581,9 @@ static void default_pins2(WPMINFO2) {
 	minfo->features.pll.ref_freq	=  14318;
 }
 
-static int parse_pins3(WPMINFO const struct matrox_bios* bd) {
+static int parse_pins3(struct matrox_fb_info *minfo,
+		       const struct matrox_bios *bd)
+{
 	minfo->limits.pixel.vcomax	=
 	minfo->limits.system.vcomax	= (bd->pins[36] == 0xFF) ? 230000			: ((bd->pins[36] + 100) * 1000);
 	minfo->values.reg.mctlwtst	= get_unaligned_le32(bd->pins + 48) == 0xFFFFFFFF ?
@@ -587,7 +599,8 @@ static int parse_pins3(WPMINFO const str
 	return 0;
 }
 
-static void default_pins3(WPMINFO2) {
+static void default_pins3(struct matrox_fb_info *minfo)
+{
 	/* G100, G200 */
 	minfo->limits.pixel.vcomax	=
 	minfo->limits.system.vcomax	= 230000;
@@ -598,7 +611,9 @@ static void default_pins3(WPMINFO2) {
 	minfo->features.pll.ref_freq	=  27000;
 }
 
-static int parse_pins4(WPMINFO const struct matrox_bios* bd) {
+static int parse_pins4(struct matrox_fb_info *minfo,
+		       const struct matrox_bios *bd)
+{
 	minfo->limits.pixel.vcomax	= (bd->pins[ 39] == 0xFF) ? 230000			: bd->pins[ 39] * 4000;
 	minfo->limits.system.vcomax	= (bd->pins[ 38] == 0xFF) ? minfo->limits.pixel.vcomax	: bd->pins[ 38] * 4000;
 	minfo->values.reg.mctlwtst	= get_unaligned_le32(bd->pins + 71);
@@ -615,7 +630,8 @@ static int parse_pins4(WPMINFO const str
 	return 0;
 }
 
-static void default_pins4(WPMINFO2) {
+static void default_pins4(struct matrox_fb_info *minfo)
+{
 	/* G400 */
 	minfo->limits.pixel.vcomax	=
 	minfo->limits.system.vcomax	= 252000;
@@ -627,7 +643,9 @@ static void default_pins4(WPMINFO2) {
 	minfo->features.pll.ref_freq	= 27000;
 }
 
-static int parse_pins5(WPMINFO const struct matrox_bios* bd) {
+static int parse_pins5(struct matrox_fb_info *minfo,
+		       const struct matrox_bios *bd)
+{
 	unsigned int mult;
 	
 	mult = bd->pins[4]?8000:6000;
@@ -662,7 +680,8 @@ static int parse_pins5(WPMINFO const str
 	return 0;
 }
 
-static void default_pins5(WPMINFO2) {
+static void default_pins5(struct matrox_fb_info *minfo)
+{
 	/* Mine 16MB G450 with SDRAM DDR */
 	minfo->limits.pixel.vcomax	=
 	minfo->limits.system.vcomax	=
@@ -686,20 +705,22 @@ static void default_pins5(WPMINFO2) {
 	minfo->values.reg.maccess	= 0x00004000;
 }
 
-static int matroxfb_set_limits(WPMINFO const struct matrox_bios* bd) {
+static int matroxfb_set_limits(struct matrox_fb_info *minfo,
+			       const struct matrox_bios *bd)
+{
 	unsigned int pins_version;
 	static const unsigned int pinslen[] = { 64, 64, 64, 128, 128 };
 
 	switch (minfo->chip) {
-		case MGA_2064:	default_pins1(PMINFO2); break;
+		case MGA_2064:	default_pins1(minfo); break;
 		case MGA_2164:
 		case MGA_1064:
-		case MGA_1164:	default_pins2(PMINFO2); break;
+		case MGA_1164:	default_pins2(minfo); break;
 		case MGA_G100:
-		case MGA_G200:	default_pins3(PMINFO2); break;
-		case MGA_G400:	default_pins4(PMINFO2); break;
+		case MGA_G200:	default_pins3(minfo); break;
+		case MGA_G400:	default_pins4(minfo); break;
 		case MGA_G450:
-		case MGA_G550:	default_pins5(PMINFO2); break;
+		case MGA_G550:	default_pins5(minfo); break;
 	}
 	if (!bd->bios_valid) {
 		printk(KERN_INFO "matroxfb: Your Matrox device does not have BIOS\n");
@@ -724,22 +745,23 @@ static int matroxfb_set_limits(WPMINFO c
 	}
 	switch (pins_version) {
 		case 1:
-			return parse_pins1(PMINFO bd);
+			return parse_pins1(minfo, bd);
 		case 2:
-			return parse_pins2(PMINFO bd);
+			return parse_pins2(minfo, bd);
 		case 3:
-			return parse_pins3(PMINFO bd);
+			return parse_pins3(minfo, bd);
 		case 4:
-			return parse_pins4(PMINFO bd);
+			return parse_pins4(minfo, bd);
 		case 5:
-			return parse_pins5(PMINFO bd);
+			return parse_pins5(minfo, bd);
 		default:
 			printk(KERN_DEBUG "matroxfb: Powerup info version %u is not yet supported\n", pins_version);
 			return -1;
 	}
 }
 
-void matroxfb_read_pins(WPMINFO2) {
+void matroxfb_read_pins(struct matrox_fb_info *minfo)
+{
 	u32 opt;
 	u32 biosbase;
 	u32 fbbase;
@@ -775,7 +797,7 @@ void matroxfb_read_pins(WPMINFO2) {
 		}
 	}
 #endif
-	matroxfb_set_limits(PMINFO &minfo->bios);
+	matroxfb_set_limits(minfo, &minfo->bios);
 	printk(KERN_INFO "PInS memtype = %u\n",
 	       (minfo->values.reg.opt & 0x1C00) >> 10);
 }
diff -puN drivers/video/matrox/matroxfb_misc.h~matroxfb-get-rid-of-unneeded-macros-wpminfo-and-friends drivers/video/matrox/matroxfb_misc.h
--- a/drivers/video/matrox/matroxfb_misc.h~matroxfb-get-rid-of-unneeded-macros-wpminfo-and-friends
+++ a/drivers/video/matrox/matroxfb_misc.h
@@ -6,13 +6,16 @@
 /* also for modules */
 int matroxfb_PLL_calcclock(const struct matrox_pll_features* pll, unsigned int freq, unsigned int fmax,
 	unsigned int* in, unsigned int* feed, unsigned int* post);
-static inline int PLL_calcclock(CPMINFO unsigned int freq, unsigned int fmax,
-		unsigned int* in, unsigned int* feed, unsigned int* post) {
+static inline int PLL_calcclock(const struct matrox_fb_info *minfo,
+				unsigned int freq, unsigned int fmax,
+				unsigned int *in, unsigned int *feed,
+				unsigned int *post)
+{
 	return matroxfb_PLL_calcclock(&minfo->features.pll, freq, fmax, in, feed, post);
 }
 
-int matroxfb_vgaHWinit(WPMINFO struct my_timming* m);
-void matroxfb_vgaHWrestore(WPMINFO2);
-void matroxfb_read_pins(WPMINFO2);
+int matroxfb_vgaHWinit(struct matrox_fb_info *minfo, struct my_timming* m);
+void matroxfb_vgaHWrestore(struct matrox_fb_info *minfo);
+void matroxfb_read_pins(struct matrox_fb_info *minfo);
 
 #endif	/* __MATROXFB_MISC_H__ */
_

Patches currently in -mm which might be from khali@linux-fr.org are

origin.patch
linux-next.patch
hwmon-driver-for-texas-instruments-amc6821-chip.patch
rtc-set-wakeup-capability-for-i2c-and-spi-rtc-drivers.patch

