From: akpm@linux-foundation.org
Subject: + atyfb-reorganize-clock-init.patch added to -mm tree
Date: Sun, 29 Apr 2007 02:33:46 -0700
Message-ID: <200704290933.l3T9XkTW012975@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58364 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755121AbXD2Jdy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Apr 2007 05:33:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: syrjala@sci.fi, adaplas@gmail.com


The patch titled
     atyfb: reorganize clock init
has been added to the -mm tree.  Its filename is
     atyfb-reorganize-clock-init.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: atyfb: reorganize clock init
From: Ville Syrjala <syrjala@sci.fi>

Reorganize atyfb clock init code so command line clock overrides are effective
for all chips.  The old code would silently ignore some of the command line
clock overrides with some chips.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/atyfb_base.c |   32 +++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff -puN drivers/video/aty/atyfb_base.c~atyfb-reorganize-clock-init drivers/video/aty/atyfb_base.c
--- a/drivers/video/aty/atyfb_base.c~atyfb-reorganize-clock-init
+++ a/drivers/video/aty/atyfb_base.c
@@ -2297,20 +2297,6 @@ static int __devinit aty_init(struct fb_
 		par->pll_limits.xclk = 53;
 	}
 #endif
-	if (pll)
-		par->pll_limits.pll_max = pll;
-	if (mclk)
-		par->pll_limits.mclk = mclk;
-	if (xclk)
-		par->pll_limits.xclk = xclk;
-
-	aty_calc_mem_refresh(par, par->pll_limits.xclk);
-	par->pll_per = 1000000/par->pll_limits.pll_max;
-	par->mclk_per = 1000000/par->pll_limits.mclk;
-	par->xclk_per = 1000000/par->pll_limits.xclk;
-
-	par->ref_clk_per = 1000000000000ULL / 14318180;
-	xtal = "14.31818";
 
 #ifdef CONFIG_FB_ATY_GX
 	if (!M64_HAS(INTEGRATED)) {
@@ -2392,7 +2378,25 @@ static int __devinit aty_init(struct fb_
 		if (par->pll_limits.mclk == 67 && par->ram_type < SDRAM)
 			par->pll_limits.mclk = 63;
 	}
+#endif
 
+	/* Allow command line to override clocks. */
+	if (pll)
+		par->pll_limits.pll_max = pll;
+	if (mclk)
+		par->pll_limits.mclk = mclk;
+	if (xclk)
+		par->pll_limits.xclk = xclk;
+
+	aty_calc_mem_refresh(par, par->pll_limits.xclk);
+	par->pll_per = 1000000/par->pll_limits.pll_max;
+	par->mclk_per = 1000000/par->pll_limits.mclk;
+	par->xclk_per = 1000000/par->pll_limits.xclk;
+
+	par->ref_clk_per = 1000000000000ULL / 14318180;
+	xtal = "14.31818";
+
+#ifdef CONFIG_FB_ATY_CT
 	if (M64_HAS(GTB_DSP)) {
 		u8 pll_ref_div = aty_ld_pll_ct(PLL_REF_DIV, par);
 
_

Patches currently in -mm which might be from syrjala@sci.fi are

origin.patch
git-input.patch
pnp-notice-whether-we-have-pnp-devices-pnpbios-or-pnpacpi.patch
pnp-workaround-hp-bios-defect-that-leaves-smcf010-device-partly-enabled.patch
smsc-ircc2-tidy-up-module-parameter-checking.patch
smsc-ircc2-add-pnp-support.patch
x86-serial-convert-legacy-com-ports-to-platform-devices.patch
x86-serial-convert-legacy-com-ports-to-platform-devices-fix.patch
atyfb-increase-spll-delay.patch
atyfb-reorganize-clock-init.patch
atyfb-halve-xclk-with-mobility-and-32bit-memory.patch
