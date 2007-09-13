From: akpm@linux-foundation.org
Subject: - radeonfb-add-new-module-parameter-to-force-pll-calculation.patch removed from -mm tree
Date: Thu, 13 Sep 2007 04:30:34 -0700
Message-ID: <200709131130.l8DBUYmj016344@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35477 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750915AbXIMLal (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Sep 2007 07:30:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aherrman@arcor.de, adaplas@pol.net, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     radeonfb: add new module parameter to force PLL calculation
has been removed from the -mm tree.  Its filename was
     radeonfb-add-new-module-parameter-to-force-pll-calculation.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
Subject: radeonfb: add new module parameter to force PLL calculation
From: Andreas Herrmann <aherrman@arcor.de>

On my Acer Aspire 5100 (with 0x5975) I need to force PLL caclulation.
Most probably the BIOS dividers are incorrect/insufficient. Without pll
calculation console goes blank.

Signed-off-by: Andreas Herrmann <aherrman@arcor.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/radeon_base.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/video/aty/radeon_base.c~radeonfb-add-new-module-parameter-to-force-pll-calculation drivers/video/aty/radeon_base.c
--- a/drivers/video/aty/radeon_base.c~radeonfb-add-new-module-parameter-to-force-pll-calculation
+++ a/drivers/video/aty/radeon_base.c
@@ -268,6 +268,7 @@ static int mirror = 0;
 static int panel_yres = 0;
 static int force_dfp = 0;
 static int force_measure_pll = 0;
+static int force_pll_calc = 0;
 #ifdef CONFIG_MTRR
 static int nomtrr = 0;
 #endif
@@ -1590,7 +1591,7 @@ static int radeonfb_set_par(struct fb_in
 
 		pixClock = 100000000 / rinfo->panel_info.clock;
 
-		if (rinfo->panel_info.use_bios_dividers) {
+		if (rinfo->panel_info.use_bios_dividers && !force_pll_calc) {
 			nopllcalc = 1;
 			newmode->ppll_div_3 = rinfo->panel_info.fbk_divider |
 				(rinfo->panel_info.post_divider << 16);
@@ -2495,6 +2496,8 @@ static int __init radeonfb_setup (char *
 			nomodeset = 1;
 		} else if (!strncmp(this_opt, "force_measure_pll", 17)) {
 			force_measure_pll = 1;
+		} else if (!strncmp(this_opt, "force_pll_calc", 17)) {
+			force_pll_calc = 1;
 		} else if (!strncmp(this_opt, "ignore_edid", 11)) {
 			ignore_edid = 1;
 #if defined(CONFIG_PM) && defined(CONFIG_X86)
@@ -2550,6 +2553,8 @@ module_param(monitor_layout, charp, 0);
 MODULE_PARM_DESC(monitor_layout, "Specify monitor mapping (like XFree86)");
 module_param(force_measure_pll, bool, 0);
 MODULE_PARM_DESC(force_measure_pll, "Force measurement of PLL (debug)");
+module_param(force_pll_calc, bool, 0400);
+MODULE_PARM_DESC(force_pll_calc, "Force calculation of PLL");
 #ifdef CONFIG_MTRR
 module_param(nomtrr, bool, 0);
 MODULE_PARM_DESC(nomtrr, "bool: disable use of MTRR registers");
_

Patches currently in -mm which might be from aherrman@arcor.de are

radeonfb-fix-setting-of-ppll_ref_div-for-rv370-5b60.patch
radeonfb-use-pci-device-id-in-hex-for-name-string.patch
radeonfb-add-new-module-parameter-to-force-pll-calculation.patch
radeonfb-add-new-module-parameter-to-force-pll-calculation-fix.patch
