From: akpm@linux-foundation.org
Subject: + matroxfb-rectify-jitter-g450-g550.patch added to -mm tree
Date: Wed, 01 Aug 2007 15:40:48 -0700
Message-ID: <200708012240.l71Memtn021138@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39878 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754168AbXHAWl2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2007 18:41:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pc@us.ibm.com, adaplas@gmail.com, petr@vandrovec.name


The patch titled
     matroxfb: rectify jitter (G450/G550)
has been added to the -mm tree.  Its filename is
     matroxfb-rectify-jitter-g450-g550.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: matroxfb: rectify jitter (G450/G550)
From: Paul A. Clarke <pc@us.ibm.com>

This builds upon my previous attempts to resolve some jitter problems seen
with the Matrox G450 and G550 -based cards, including odd disparities observed
between x86 and Power -based machines in a somewhat less hackish way (removing
the hacked ifdefs).

Apparently, preference should be given to use the DVI PLL when frequencies
permit, the Standard PLL otherwise.  The max pixel clock for the panellink
interface is extracted from the PInS information on the card and used as a
limit to determine which PLL to use.

Signed-off-by: Paul A. Clarke <pc@us.ibm.com>
Acked-by: Petr Vandrovec <petr@vandrovec.name>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/matrox/g450_pll.c         |   23 ++++++++++++----------
 drivers/video/matrox/matroxfb_DAC1064.h |   15 ++++++++++++++
 drivers/video/matrox/matroxfb_base.h    |    1 
 drivers/video/matrox/matroxfb_misc.c    |    1 
 4 files changed, 30 insertions(+), 10 deletions(-)

diff -puN drivers/video/matrox/g450_pll.c~matroxfb-rectify-jitter-g450-g550 drivers/video/matrox/g450_pll.c
--- a/drivers/video/matrox/g450_pll.c~matroxfb-rectify-jitter-g450-g550
+++ a/drivers/video/matrox/g450_pll.c
@@ -331,16 +331,19 @@ static int __g450_setclk(WPMINFO unsigne
 					tmp |= M1064_XPIXCLKCTRL_PLL_UP;
 				}
 				matroxfb_DAC_out(PMINFO M1064_XPIXCLKCTRL, tmp);
-#ifdef __powerpc__
-				/* This is necessary to avoid jitter on PowerPC
-				 * (OpenFirmware) systems, but apparently
-				 * introduces jitter, at least on a x86-64
-				 * using DVI.
-				 * A simple workaround is disable for non-PPC.
-				 */
-				matroxfb_DAC_out(PMINFO M1064_XDVICLKCTRL, 0);
-#endif /* __powerpc__ */
-				matroxfb_DAC_out(PMINFO M1064_XPWRCTRL, xpwrctrl);
+				/* DVI PLL preferred for frequencies up to
+				   panel link max, standard PLL otherwise */
+				if (fout >= MINFO->max_pixel_clock_panellink)
+					tmp = 0;
+				else tmp =
+					M1064_XDVICLKCTRL_DVIDATAPATHSEL |
+					M1064_XDVICLKCTRL_C1DVICLKSEL |
+					M1064_XDVICLKCTRL_C1DVICLKEN |
+					M1064_XDVICLKCTRL_DVILOOPCTL |
+					M1064_XDVICLKCTRL_P1LOOPBWDTCTL;
+				matroxfb_DAC_out(PMINFO M1064_XDVICLKCTRL,tmp);
+				matroxfb_DAC_out(PMINFO M1064_XPWRCTRL,
+						 xpwrctrl);
 
 				matroxfb_DAC_unlock_irqrestore(flags);
 			}
diff -puN drivers/video/matrox/matroxfb_DAC1064.h~matroxfb-rectify-jitter-g450-g550 drivers/video/matrox/matroxfb_DAC1064.h
--- a/drivers/video/matrox/matroxfb_DAC1064.h~matroxfb-rectify-jitter-g450-g550
+++ a/drivers/video/matrox/matroxfb_DAC1064.h
@@ -33,6 +33,21 @@ void DAC1064_global_restore(WPMINFO2);
 #define     M1064_XCURCTRL_3COLOR	0x01	/* transparent, 0, 1, 2 */
 #define     M1064_XCURCTRL_XGA		0x02	/* 0, 1, transparent, complement */
 #define     M1064_XCURCTRL_XWIN		0x03	/* transparent, transparent, 0, 1 */
+	/* drive DVI by standard(0)/DVI(1) PLL */
+	/* if set(1), C?DVICLKEN and C?DVICLKSEL must be set(1) */
+#define      M1064_XDVICLKCTRL_DVIDATAPATHSEL   0x01
+	/* drive CRTC1 by standard(0)/DVI(1) PLL */
+#define      M1064_XDVICLKCTRL_C1DVICLKSEL      0x02
+	/* drive CRTC2 by standard(0)/DVI(1) PLL */
+#define      M1064_XDVICLKCTRL_C2DVICLKSEL      0x04
+	/* pixel clock allowed to(0)/blocked from(1) driving CRTC1 */
+#define      M1064_XDVICLKCTRL_C1DVICLKEN       0x08
+	/* DVI PLL loop filter bandwidth selection bits */
+#define      M1064_XDVICLKCTRL_DVILOOPCTL       0x30
+	/* CRTC2 pixel clock allowed to(0)/blocked from(1) driving CRTC2 */
+#define      M1064_XDVICLKCTRL_C2DVICLKEN       0x40
+	/* P1PLL loop filter bandwith selection */
+#define      M1064_XDVICLKCTRL_P1LOOPBWDTCTL    0x80
 #define M1064_XCURCOL0RED	0x08
 #define M1064_XCURCOL0GREEN	0x09
 #define M1064_XCURCOL0BLUE	0x0A
diff -puN drivers/video/matrox/matroxfb_base.h~matroxfb-rectify-jitter-g450-g550 drivers/video/matrox/matroxfb_base.h
--- a/drivers/video/matrox/matroxfb_base.h~matroxfb-rectify-jitter-g450-g550
+++ a/drivers/video/matrox/matroxfb_base.h
@@ -424,6 +424,7 @@ struct matrox_fb_info {
 		      } mmio;
 
 	unsigned int	max_pixel_clock;
+	unsigned int	max_pixel_clock_panellink;
 
 	struct matrox_switch*	hw_switch;
 
diff -puN drivers/video/matrox/matroxfb_misc.c~matroxfb-rectify-jitter-g450-g550 drivers/video/matrox/matroxfb_misc.c
--- a/drivers/video/matrox/matroxfb_misc.c~matroxfb-rectify-jitter-g450-g550
+++ a/drivers/video/matrox/matroxfb_misc.c
@@ -658,6 +658,7 @@ static int parse_pins5(WPMINFO const str
 		MINFO->values.reg.mctlwtst_core = (MINFO->values.reg.mctlwtst & ~7) |
 		                                  wtst_xlat[MINFO->values.reg.mctlwtst & 7];
 	}
+	MINFO->max_pixel_clock_panellink = bd->pins[47] * 4000;
 	return 0;
 }
 
_

Patches currently in -mm which might be from pc@us.ibm.com are

matroxfb-rectify-jitter-g450-g550.patch
