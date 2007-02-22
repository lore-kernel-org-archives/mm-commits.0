From: akpm@linux-foundation.org
Subject: - atyfb-system-hangs-at-bootup-prior-to-enabling-framebuffer-console.patch removed from -mm tree
Date: Wed, 21 Feb 2007 19:48:13 -0800
Message-ID: <200702220348.l1M3mEXD003653@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35953 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932632AbXBVDsp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 22:48:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: syrjala@sci.fi, adaplas@pol.net, jsimmons@infradead.org, mm-commits@vger.kernel.org


The patch titled
     atyfb: system hangs at bootup prior to enabling framebuffer console
has been removed from the -mm tree.  Its filename was
     atyfb-system-hangs-at-bootup-prior-to-enabling-framebuffer-console.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: atyfb: system hangs at bootup prior to enabling framebuffer console
From: Ville Syrjala <syrjala@sci.fi>

More than 50% of the time my laptop hangs when booting with

... video=atyfb:1400x1050.

I have seen similar occurrences reported here and there with recent 2.6
kernels but nothing very clear as to whether this is a known problem or
whether a patch or workaround has already been provided.

I was just able to reproduce the problem by switching from drivers/ide
to libata. In my case the laptop would hang on every boot. Apparently
using libata changed the timing enough to trigger the bug.

Cc "Antonino A. Daplas" <adaplas@pol.net>
Acked-by: James Simmons <jsimmons@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/mach64_ct.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN drivers/video/aty/mach64_ct.c~atyfb-system-hangs-at-bootup-prior-to-enabling-framebuffer-console drivers/video/aty/mach64_ct.c
--- a/drivers/video/aty/mach64_ct.c~atyfb-system-hangs-at-bootup-prior-to-enabling-framebuffer-console
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
+		 * The sclk has been started. Wait for the PLL to lock. 5 ms
+		 * should be enough according to mach64 programmers guide.
 		 */
-		for (i=0;i<=0x1ffff;i++);
+		mdelay(5);
 	}
 
 	aty_st_pll_ct(PLL_REF_DIV, pll->ct.pll_ref_div, par);
_

Patches currently in -mm which might be from syrjala@sci.fi are

atyfb-system-hangs-at-bootup-prior-to-enabling-framebuffer-console.patch
