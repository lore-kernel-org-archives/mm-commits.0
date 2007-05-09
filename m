From: akpm@linux-foundation.org
Subject: - atyfb-halve-xclk-with-mobility-and-32bit-memory.patch removed from -mm tree
Date: Tue, 08 May 2007 20:02:21 -0700
Message-ID: <200705090302.l4932LTd010825@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52361 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1033249AbXEIDC0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:02:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: syrjala@sci.fi, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     atyfb: halve XCLK with Mobility and 32bit memory
has been removed from the -mm tree.  Its filename was
     atyfb-halve-xclk-with-mobility-and-32bit-memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: atyfb: halve XCLK with Mobility and 32bit memory
From: Ville Syrjala <syrjala@sci.fi>

Laptops with Rage Mobility and 32bit memory interface seem to require halved
XCLK to operate correctly.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/atyfb_base.c |    3 +++
 include/video/mach64.h         |    1 +
 2 files changed, 4 insertions(+)

diff -puN drivers/video/aty/atyfb_base.c~atyfb-halve-xclk-with-mobility-and-32bit-memory drivers/video/aty/atyfb_base.c
--- a/drivers/video/aty/atyfb_base.c~atyfb-halve-xclk-with-mobility-and-32bit-memory
+++ a/drivers/video/aty/atyfb_base.c
@@ -2377,6 +2377,9 @@ static int __devinit aty_init(struct fb_
 		/* for many chips, the mclk is 67 MHz for SDRAM, 63 MHz otherwise */
 		if (par->pll_limits.mclk == 67 && par->ram_type < SDRAM)
 			par->pll_limits.mclk = 63;
+		/* Mobility + 32bit memory interface need halved XCLK. */
+		if (M64_HAS(MOBIL_BUS) && par->ram_type == SDRAM32)
+			par->pll_limits.xclk = (par->pll_limits.xclk + 1) >> 1;
 	}
 #endif
 
diff -puN include/video/mach64.h~atyfb-halve-xclk-with-mobility-and-32bit-memory include/video/mach64.h
--- a/include/video/mach64.h~atyfb-halve-xclk-with-mobility-and-32bit-memory
+++ a/include/video/mach64.h
@@ -885,6 +885,7 @@
 #define SDRAM			4
 #define SGRAM			5
 #define WRAM			6
+#define SDRAM32			6
 
 #define DAC_INTERNAL		0x00
 #define DAC_IBMRGB514		0x01
_

Patches currently in -mm which might be from syrjala@sci.fi are

origin.patch
