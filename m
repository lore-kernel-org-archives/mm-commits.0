From: akpm@linux-foundation.org
Subject: [merged] radeon-p2g2clk_always_onb-tested-twice-should-2nd-be-p2g2clk_dac_always_onb.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:39:40 -0700
Message-ID: <200906171839.n5HIde0t005659@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47665 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753474AbZFQSk2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:40:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, benh@kernel.crashing.org, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     radeon: P2G2CLK_ALWAYS_ONb tested twice, should 2nd be P2G2CLK_DAC_ALWAYS_ONb?
has been removed from the -mm tree.  Its filename was
     radeon-p2g2clk_always_onb-tested-twice-should-2nd-be-p2g2clk_dac_always_onb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: radeon: P2G2CLK_ALWAYS_ONb tested twice, should 2nd be P2G2CLK_DAC_ALWAYS_ONb?
From: Roel Kluin <roel.kluin@gmail.com>

P2G2CLK_ALWAYS_ONb is tested twice, 2nd should be P2G2CLK_DAC_ALWAYS_ONb.

[akpm@linux-foundation.org: remove duplicated bitwise-OR of PIXCLKS_CNTL__R300_P2G2CLK_ALWAYS_ONb too]
Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/radeon_pm.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/video/aty/radeon_pm.c~radeon-p2g2clk_always_onb-tested-twice-should-2nd-be-p2g2clk_dac_always_onb drivers/video/aty/radeon_pm.c
--- a/drivers/video/aty/radeon_pm.c~radeon-p2g2clk_always_onb-tested-twice-should-2nd-be-p2g2clk_dac_always_onb
+++ a/drivers/video/aty/radeon_pm.c
@@ -213,7 +213,6 @@ static void radeon_pm_disable_dynamic_mo
 			 PIXCLKS_CNTL__R300_PIXCLK_TRANS_ALWAYS_ONb	|
 			 PIXCLKS_CNTL__R300_PIXCLK_TVO_ALWAYS_ONb	|
 			 PIXCLKS_CNTL__R300_P2G2CLK_ALWAYS_ONb		|
-			 PIXCLKS_CNTL__R300_P2G2CLK_ALWAYS_ONb		|
 			 PIXCLKS_CNTL__R300_DISP_DAC_PIXCLK_DAC2_BLANK_OFF);
                 OUTPLL(pllPIXCLKS_CNTL, tmp);
 
@@ -395,7 +394,7 @@ static void radeon_pm_enable_dynamic_mod
 			PIXCLKS_CNTL__R300_PIXCLK_TRANS_ALWAYS_ONb      |
 			PIXCLKS_CNTL__R300_PIXCLK_TVO_ALWAYS_ONb        |
 			PIXCLKS_CNTL__R300_P2G2CLK_ALWAYS_ONb           |
-			PIXCLKS_CNTL__R300_P2G2CLK_ALWAYS_ONb);
+			PIXCLKS_CNTL__R300_P2G2CLK_DAC_ALWAYS_ONb);
 		OUTPLL(pllPIXCLKS_CNTL, tmp);
 
 		tmp = INPLL(pllMCLK_MISC);
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
serial-fix-off-by-one-errors.patch
usb-mutually-exclusive-port_status.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
spi_bfin5xx-limit-reaches-1.patch
platinumfb-misplaced-parenthesis.patch
ufs-sector_t-cannot-be-negative.patch
dtlk-off-by-one-in-readwrite_tts.patch

