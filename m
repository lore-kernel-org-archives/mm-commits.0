From: akpm@linux-foundation.org
Subject: + atyfb-halve-xclk-with-mobility-and-32bit-memory.patch added to -mm tree
Date: Sun, 29 Apr 2007 02:33:48 -0700
Message-ID: <200704290933.l3T9XmYk012981@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49872 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755118AbXD2Jd4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Apr 2007 05:33:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: syrjala@sci.fi, adaplas@gmail.com


The patch titled
     atyfb: halve XCLK with Mobility and 32bit memory
has been added to the -mm tree.  Its filename is
     atyfb-halve-xclk-with-mobility-and-32bit-memory.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
