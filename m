From: akpm@linux-foundation.org
Subject: - x86-geode-msr-cleanup.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:57:26 -0700
Message-ID: <200804282157.m3SLvQWW018398@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47044 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965165AbYD1V5k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:57:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, dilinger@debian.org, jordan.crouse@amd.com, mm-commits@vger.kernel.org


The patch titled
     x86: geode: MSR cleanup
has been removed from the -mm tree.  Its filename was
     x86-geode-msr-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: geode: MSR cleanup
From: Andres Salomon <dilinger@queued.net>

This cleans up a few MSR-using drivers in the following manner:
  - Ensures MSRs are all defined in asm/geode.h, rather than in misc
    places
  - Makes the naming consistent; cs553[56] ones begin with MSR_,
    GX-specific ones start with MSR_GX_, and LX-specific ones start
    with MSR_LX_.  Also, make the names match the data sheet.
  - Use MSR names rather than numbers in source code
  - Document the fact that the LX's MSR_PADSEL has the wrong value
    in the data sheet.  That's, uh, good to note.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Acked-by: Jordan Crouse <jordan.crouse@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/mfgpt_32.c       |    8 ++++----
 drivers/video/geode/display_gx.h |    1 -
 drivers/video/geode/gxfb_core.c  |    3 ++-
 drivers/video/geode/lxfb.h       |    8 --------
 drivers/video/geode/lxfb_ops.c   |   19 ++++++++++---------
 drivers/video/geode/video_gx.c   |    5 +++--
 drivers/video/geode/video_gx.h   |    3 ---
 include/asm-x86/geode.h          |   16 +++++++++++++---
 8 files changed, 32 insertions(+), 31 deletions(-)

diff -puN arch/x86/kernel/mfgpt_32.c~x86-geode-msr-cleanup arch/x86/kernel/mfgpt_32.c
--- a/arch/x86/kernel/mfgpt_32.c~x86-geode-msr-cleanup
+++ a/arch/x86/kernel/mfgpt_32.c
@@ -63,7 +63,7 @@ static int __init mfgpt_fix(char *s)
 
 	/* The following udocumented bit resets the MFGPT timers */
 	val = 0xFF; dummy = 0;
-	wrmsr(0x5140002B, val, dummy);
+	wrmsr(MSR_MFGPT_SETUP, val, dummy);
 	return 1;
 }
 __setup("mfgptfix", mfgpt_fix);
@@ -127,17 +127,17 @@ int geode_mfgpt_toggle_event(int timer, 
 		 * 6; that is, resets for 7 and 8 will be ignored.  Is this
 		 * a problem?   -dilinger
 		 */
-		msr = MFGPT_NR_MSR;
+		msr = MSR_MFGPT_NR;
 		mask = 1 << (timer + 24);
 		break;
 
 	case MFGPT_EVENT_NMI:
-		msr = MFGPT_NR_MSR;
+		msr = MSR_MFGPT_NR;
 		mask = 1 << (timer + shift);
 		break;
 
 	case MFGPT_EVENT_IRQ:
-		msr = MFGPT_IRQ_MSR;
+		msr = MSR_MFGPT_IRQ;
 		mask = 1 << (timer + shift);
 		break;
 
diff -puN drivers/video/geode/display_gx.h~x86-geode-msr-cleanup drivers/video/geode/display_gx.h
--- a/drivers/video/geode/display_gx.h~x86-geode-msr-cleanup
+++ a/drivers/video/geode/display_gx.h
@@ -17,7 +17,6 @@ int gx_line_delta(int xres, int bpp);
 extern struct geode_dc_ops gx_dc_ops;
 
 /* MSR that tells us if a TFT or CRT is attached */
-#define GLD_MSR_CONFIG   0xC0002001
 #define GLD_MSR_CONFIG_DM_FP 0x40
 
 /* Display controller registers */
diff -puN drivers/video/geode/gxfb_core.c~x86-geode-msr-cleanup drivers/video/geode/gxfb_core.c
--- a/drivers/video/geode/gxfb_core.c~x86-geode-msr-cleanup
+++ a/drivers/video/geode/gxfb_core.c
@@ -30,6 +30,7 @@
 #include <linux/fb.h>
 #include <linux/init.h>
 #include <linux/pci.h>
+#include <asm/geode.h>
 
 #include "geodefb.h"
 #include "display_gx.h"
@@ -326,7 +327,7 @@ static int __init gxfb_probe(struct pci_
 
 	/* Figure out if this is a TFT or CRT part */
 
-	rdmsrl(GLD_MSR_CONFIG, val);
+	rdmsrl(MSR_GX_GLD_MSR_CONFIG, val);
 
 	if ((val & GLD_MSR_CONFIG_DM_FP) == GLD_MSR_CONFIG_DM_FP)
 		par->enable_crt = 0;
diff -puN drivers/video/geode/lxfb.h~x86-geode-msr-cleanup drivers/video/geode/lxfb.h
--- a/drivers/video/geode/lxfb.h~x86-geode-msr-cleanup
+++ a/drivers/video/geode/lxfb.h
@@ -31,14 +31,6 @@ void lx_set_palette_reg(struct fb_info *
 
 /* MSRS */
 
-#define MSR_LX_GLD_CONFIG    0x48002001
-#define MSR_LX_GLCP_DOTPLL   0x4c000015
-#define MSR_LX_DF_PADSEL     0x48002011
-#define MSR_LX_DC_SPARE      0x80000011
-#define MSR_LX_DF_GLCONFIG   0x48002001
-
-#define MSR_LX_GLIU0_P2D_RO0 0x10000029
-
 #define GLCP_DOTPLL_RESET    (1 << 0)
 #define GLCP_DOTPLL_BYPASS   (1 << 15)
 #define GLCP_DOTPLL_HALFPIX  (1 << 24)
diff -puN drivers/video/geode/lxfb_ops.c~x86-geode-msr-cleanup drivers/video/geode/lxfb_ops.c
--- a/drivers/video/geode/lxfb_ops.c~x86-geode-msr-cleanup
+++ a/drivers/video/geode/lxfb_ops.c
@@ -13,6 +13,7 @@
 #include <linux/fb.h>
 #include <linux/uaccess.h>
 #include <linux/delay.h>
+#include <asm/geode.h>
 
 #include "lxfb.h"
 
@@ -101,7 +102,7 @@ static void lx_set_dotpll(u32 pllval)
 	u32 dotpll_lo, dotpll_hi;
 	int i;
 
-	rdmsr(MSR_LX_GLCP_DOTPLL, dotpll_lo, dotpll_hi);
+	rdmsr(MSR_GLCP_DOTPLL, dotpll_lo, dotpll_hi);
 
 	if ((dotpll_lo & GLCP_DOTPLL_LOCK) && (dotpll_hi == pllval))
 		return;
@@ -110,7 +111,7 @@ static void lx_set_dotpll(u32 pllval)
 	dotpll_lo &= ~(GLCP_DOTPLL_BYPASS | GLCP_DOTPLL_HALFPIX);
 	dotpll_lo |= GLCP_DOTPLL_RESET;
 
-	wrmsr(MSR_LX_GLCP_DOTPLL, dotpll_lo, dotpll_hi);
+	wrmsr(MSR_GLCP_DOTPLL, dotpll_lo, dotpll_hi);
 
 	/* Wait 100us for the PLL to lock */
 
@@ -119,7 +120,7 @@ static void lx_set_dotpll(u32 pllval)
 	/* Now, loop for the lock bit */
 
 	for (i = 0; i < 1000; i++) {
-		rdmsr(MSR_LX_GLCP_DOTPLL, dotpll_lo, dotpll_hi);
+		rdmsr(MSR_GLCP_DOTPLL, dotpll_lo, dotpll_hi);
 		if (dotpll_lo & GLCP_DOTPLL_LOCK)
 			break;
 	}
@@ -127,7 +128,7 @@ static void lx_set_dotpll(u32 pllval)
 	/* Clear the reset bit */
 
 	dotpll_lo &= ~GLCP_DOTPLL_RESET;
-	wrmsr(MSR_LX_GLCP_DOTPLL, dotpll_lo, dotpll_hi);
+	wrmsr(MSR_GLCP_DOTPLL, dotpll_lo, dotpll_hi);
 }
 
 /* Set the clock based on the frequency specified by the current mode */
@@ -255,7 +256,7 @@ static void lx_graphics_enable(struct fb
 		msrlo = DF_DEFAULT_TFT_PAD_SEL_LOW;
 		msrhi = DF_DEFAULT_TFT_PAD_SEL_HIGH;
 
-		wrmsr(MSR_LX_DF_PADSEL, msrlo, msrhi);
+		wrmsr(MSR_LX_MSR_PADSEL, msrlo, msrhi);
 	}
 
 	if (par->output & OUTPUT_CRT) {
@@ -321,7 +322,7 @@ void lx_set_mode(struct fb_info *info)
 
 	/* Set output mode */
 
-	rdmsrl(MSR_LX_DF_GLCONFIG, msrval);
+	rdmsrl(MSR_LX_GLD_MSR_CONFIG, msrval);
 	msrval &= ~DF_CONFIG_OUTPUT_MASK;
 
 	if (par->output & OUTPUT_PANEL) {
@@ -335,7 +336,7 @@ void lx_set_mode(struct fb_info *info)
 		msrval |= DF_OUTPUT_CRT;
 	}
 
-	wrmsrl(MSR_LX_DF_GLCONFIG, msrval);
+	wrmsrl(MSR_LX_GLD_MSR_CONFIG, msrval);
 
 	/* Clear the various buffers */
 	/* FIXME:  Adjust for panning here */
@@ -383,13 +384,13 @@ void lx_set_mode(struct fb_info *info)
 
 	/* Set default watermark values */
 
-	rdmsrl(MSR_LX_DC_SPARE, msrval);
+	rdmsrl(MSR_LX_SPARE_MSR, msrval);
 
 	msrval &= ~(DC_SPARE_DISABLE_CFIFO_HGO | DC_SPARE_VFIFO_ARB_SELECT |
 		    DC_SPARE_LOAD_WM_LPEN_MASK | DC_SPARE_WM_LPEN_OVRD |
 		    DC_SPARE_DISABLE_INIT_VID_PRI | DC_SPARE_DISABLE_VFIFO_WM);
 	msrval |= DC_SPARE_DISABLE_VFIFO_WM | DC_SPARE_DISABLE_INIT_VID_PRI;
-	wrmsrl(MSR_LX_DC_SPARE, msrval);
+	wrmsrl(MSR_LX_SPARE_MSR, msrval);
 
 	gcfg = DC_GCFG_DFLE;   /* Display fifo enable */
 	gcfg |= 0xB600;         /* Set default priority */
diff -puN drivers/video/geode/video_gx.c~x86-geode-msr-cleanup drivers/video/geode/video_gx.c
--- a/drivers/video/geode/video_gx.c~x86-geode-msr-cleanup
+++ a/drivers/video/geode/video_gx.c
@@ -16,6 +16,7 @@
 #include <asm/io.h>
 #include <asm/delay.h>
 #include <asm/msr.h>
+#include <asm/geode.h>
 
 #include "geodefb.h"
 #include "video_gx.h"
@@ -184,10 +185,10 @@ gx_configure_tft(struct fb_info *info)
 
 	/* Set up the DF pad select MSR */
 
-	rdmsrl(GX_VP_MSR_PAD_SELECT, val);
+	rdmsrl(MSR_GX_MSR_PADSEL, val);
 	val &= ~GX_VP_PAD_SELECT_MASK;
 	val |= GX_VP_PAD_SELECT_TFT;
-	wrmsrl(GX_VP_MSR_PAD_SELECT, val);
+	wrmsrl(MSR_GX_MSR_PADSEL, val);
 
 	/* Turn off the panel */
 
diff -puN drivers/video/geode/video_gx.h~x86-geode-msr-cleanup drivers/video/geode/video_gx.h
--- a/drivers/video/geode/video_gx.h~x86-geode-msr-cleanup
+++ a/drivers/video/geode/video_gx.h
@@ -14,7 +14,6 @@
 extern struct geode_vid_ops gx_vid_ops;
 
 /* GX Flatpanel control MSR */
-#define GX_VP_MSR_PAD_SELECT           0xC0002011
 #define GX_VP_PAD_SELECT_MASK          0x3FFFFFFF
 #define GX_VP_PAD_SELECT_TFT           0x1FFFFFFF
 
@@ -59,12 +58,10 @@ extern struct geode_vid_ops gx_vid_ops;
 
 /* Geode GX clock control MSRs */
 
-#define MSR_GLCP_SYS_RSTPLL	0x4c000014
 #  define MSR_GLCP_SYS_RSTPLL_DOTPREDIV2	(0x0000000000000002ull)
 #  define MSR_GLCP_SYS_RSTPLL_DOTPREMULT2	(0x0000000000000004ull)
 #  define MSR_GLCP_SYS_RSTPLL_DOTPOSTDIV3	(0x0000000000000008ull)
 
-#define MSR_GLCP_DOTPLL		0x4c000015
 #  define MSR_GLCP_DOTPLL_DOTRESET		(0x0000000000000001ull)
 #  define MSR_GLCP_DOTPLL_BYPASS		(0x0000000000008000ull)
 #  define MSR_GLCP_DOTPLL_LOCK			(0x0000000002000000ull)
diff -puN include/asm-x86/geode.h~x86-geode-msr-cleanup include/asm-x86/geode.h
--- a/include/asm-x86/geode.h~x86-geode-msr-cleanup
+++ a/include/asm-x86/geode.h
@@ -30,7 +30,11 @@ extern int geode_get_dev_base(unsigned i
 
 /* MSRS */
 
-#define GX_GLCP_SYS_RSTPLL	0x4C000014
+#define MSR_LX_GLD_MSR_CONFIG	0x48002001
+#define MSR_LX_MSR_PADSEL	0x48002011	/* NOT 0x48000011; the data
+						 * sheet has the wrong value */
+#define MSR_GLCP_SYS_RSTPLL	0x4C000014
+#define MSR_GLCP_DOTPLL		0x4C000015
 
 #define MSR_LBAR_SMB		0x5140000B
 #define MSR_LBAR_GPIO		0x5140000C
@@ -45,8 +49,14 @@ extern int geode_get_dev_base(unsigned i
 #define MSR_PIC_ZSEL_LOW	0x51400022
 #define MSR_PIC_ZSEL_HIGH	0x51400023
 
-#define MFGPT_IRQ_MSR		0x51400028
-#define MFGPT_NR_MSR		0x51400029
+#define MSR_MFGPT_IRQ		0x51400028
+#define MSR_MFGPT_NR		0x51400029
+#define MSR_MFGPT_SETUP		0x5140002B
+
+#define MSR_LX_SPARE_MSR	0x80000011	/* DC-specific */
+
+#define MSR_GX_GLD_MSR_CONFIG	0xC0002001
+#define MSR_GX_MSR_PADSEL	0xC0002011
 
 /* Resource Sizes */
 
_

Patches currently in -mm which might be from dilinger@queued.net are

origin.patch
git-kbuild.patch
x86-olpc-add-one-laptop-per-child-architecture-support.patch

