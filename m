From: akpm@linux-foundation.org
Subject: - atyfb-replace-busy-loop-with-mdelay.patch removed from -mm tree
Date: Mon, 05 Mar 2007 15:53:59 -0800
Message-ID: <200703052353.l25NrxNA005079@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41831 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932330AbXCEXyV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 18:54:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: syrjala@sci.fi, adaplas@pol.net, jsimmons@infradead.org, mm-commits@vger.kernel.org


The patch titled
     atyfb: replace busy loop with mdelay()
has been removed from the -mm tree.  Its filename was
     atyfb-replace-busy-loop-with-mdelay.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: atyfb: replace busy loop with mdelay()
From: Ville Syrjala <syrjala@sci.fi>

Replace a busy loop with mdelay() in atyfb clock setup code. This fixes
boot hangs several people have experienced.

Signed-off-by: Ville Syrjala <syrjala@sci.fi>
Acked-by: James Simmons <jsimmons@infradead.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/mach64_ct.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN drivers/video/aty/mach64_ct.c~atyfb-replace-busy-loop-with-mdelay drivers/video/aty/mach64_ct.c
--- a/drivers/video/aty/mach64_ct.c~atyfb-replace-busy-loop-with-mdelay
+++ a/drivers/video/aty/mach64_ct.c
@@ -598,7 +598,6 @@ static void aty_resume_pll_ct(const stru
 	struct atyfb_par *par = info->par;
 
 	if (par->mclk_per != par->xclk_per) {
-		int i;
 		/*
 		* This disables the sclk, crashes the computer as reported:
 		* aty_st_pll_ct(SPLL_CNTL2, 3, info);
@@ -609,12 +608,10 @@ static void aty_resume_pll_ct(const stru
 		aty_st_pll_ct(SCLK_FB_DIV, pll->ct.sclk_fb_div, par);
 		aty_st_pll_ct(SPLL_CNTL2, pll->ct.spll_cntl2, par);
 		/*
-		 * The sclk has been started. However, I believe the first clock
-		 * ticks it generates are not very stable. Hope this primitive loop
-		 * helps for Rage Mobilities that sometimes crash when
-		 * we switch to sclk. (Daniel Mantione, 13-05-2003)
+		 * SCLK has been started. Wait for the PLL to lock. 5 ms
+		 * should be enough according to mach64 programmer's guide.
 		 */
-		for (i=0;i<=0x1ffff;i++);
+		mdelay(5);
 	}
 
 	aty_st_pll_ct(PLL_REF_DIV, pll->ct.pll_ref_div, par);
_

Patches currently in -mm which might be from syrjala@sci.fi are

atyfb-replace-busy-loop-with-mdelay.patch
