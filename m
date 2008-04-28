From: akpm@linux-foundation.org
Subject: - gxfb-move-msr-bit-fields-into-gxfbh.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:57:43 -0700
Message-ID: <200804282157.m3SLvhVU018422@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60336 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965214AbYD1V57 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:57:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, adaplas@pol.net, dilinger@debian.org, jordan.crouse@amd.com, mm-commits@vger.kernel.org


The patch titled
     gxfb: move MSR bit fields into gxfb.h
has been removed from the -mm tree.  Its filename was
     gxfb-move-msr-bit-fields-into-gxfbh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gxfb: move MSR bit fields into gxfb.h
From: Andres Salomon <dilinger@queued.net>

This continues the gxfb header cleanups.  MSRs are defined in geode.h; the
specific bits we care about are defined in gxfb.h.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: Jordan Crouse <jordan.crouse@amd.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/geode/display_gx.h |    3 ---
 drivers/video/geode/gxfb.h       |   16 ++++++++++++++++
 drivers/video/geode/gxfb_core.c  |    2 +-
 drivers/video/geode/video_gx.c   |    4 ++--
 drivers/video/geode/video_gx.h   |   14 --------------
 5 files changed, 19 insertions(+), 20 deletions(-)

diff -puN drivers/video/geode/display_gx.h~gxfb-move-msr-bit-fields-into-gxfbh drivers/video/geode/display_gx.h
--- a/drivers/video/geode/display_gx.h~gxfb-move-msr-bit-fields-into-gxfbh
+++ a/drivers/video/geode/display_gx.h
@@ -16,7 +16,4 @@ int gx_line_delta(int xres, int bpp);
 
 extern struct geode_dc_ops gx_dc_ops;
 
-/* MSR that tells us if a TFT or CRT is attached */
-#define GLD_MSR_CONFIG_DM_FP 0x40
-
 #endif /* !__DISPLAY_GX1_H__ */
diff -puN drivers/video/geode/gxfb.h~gxfb-move-msr-bit-fields-into-gxfbh drivers/video/geode/gxfb.h
--- a/drivers/video/geode/gxfb.h~gxfb-move-msr-bit-fields-into-gxfbh
+++ a/drivers/video/geode/gxfb.h
@@ -252,4 +252,20 @@ static inline void write_fp(struct geode
 	writel(val, par->vid_regs + 8*reg + VP_FP_START);
 }
 
+
+/* MSRs are defined in asm/geode.h; their bitfields are here */
+
+#define MSR_GLCP_SYS_RSTPLL_DOTPOSTDIV3	(1 << 3)
+#define MSR_GLCP_SYS_RSTPLL_DOTPREMULT2	(1 << 2)
+#define MSR_GLCP_SYS_RSTPLL_DOTPREDIV2	(1 << 1)
+
+#define MSR_GLCP_DOTPLL_LOCK		(1 << 25)	/* r/o */
+#define MSR_GLCP_DOTPLL_BYPASS		(1 << 15)
+#define MSR_GLCP_DOTPLL_DOTRESET	(1 << 0)
+
+#define MSR_GX_MSR_PADSEL_MASK		0x3FFFFFFF	/* undocumented? */
+#define MSR_GX_MSR_PADSEL_TFT		0x1FFFFFFF	/* undocumented? */
+
+#define MSR_GX_GLD_MSR_CONFIG_FP	(1 << 3)
+
 #endif
diff -puN drivers/video/geode/gxfb_core.c~gxfb-move-msr-bit-fields-into-gxfbh drivers/video/geode/gxfb_core.c
--- a/drivers/video/geode/gxfb_core.c~gxfb-move-msr-bit-fields-into-gxfbh
+++ a/drivers/video/geode/gxfb_core.c
@@ -328,7 +328,7 @@ static int __init gxfb_probe(struct pci_
 
 	rdmsrl(MSR_GX_GLD_MSR_CONFIG, val);
 
-	if ((val & GLD_MSR_CONFIG_DM_FP) == GLD_MSR_CONFIG_DM_FP)
+	if ((val & MSR_GX_GLD_MSR_CONFIG_FP) == MSR_GX_GLD_MSR_CONFIG_FP)
 		par->enable_crt = 0;
 	else
 		par->enable_crt = 1;
diff -puN drivers/video/geode/video_gx.c~gxfb-move-msr-bit-fields-into-gxfbh drivers/video/geode/video_gx.c
--- a/drivers/video/geode/video_gx.c~gxfb-move-msr-bit-fields-into-gxfbh
+++ a/drivers/video/geode/video_gx.c
@@ -187,8 +187,8 @@ gx_configure_tft(struct fb_info *info)
 	/* Set up the DF pad select MSR */
 
 	rdmsrl(MSR_GX_MSR_PADSEL, val);
-	val &= ~GX_VP_PAD_SELECT_MASK;
-	val |= GX_VP_PAD_SELECT_TFT;
+	val &= ~MSR_GX_MSR_PADSEL_MASK;
+	val |= MSR_GX_MSR_PADSEL_TFT;
 	wrmsrl(MSR_GX_MSR_PADSEL, val);
 
 	/* Turn off the panel */
diff -puN drivers/video/geode/video_gx.h~gxfb-move-msr-bit-fields-into-gxfbh drivers/video/geode/video_gx.h
--- a/drivers/video/geode/video_gx.h~gxfb-move-msr-bit-fields-into-gxfbh
+++ a/drivers/video/geode/video_gx.h
@@ -13,18 +13,4 @@
 
 extern struct geode_vid_ops gx_vid_ops;
 
-/* GX Flatpanel control MSR */
-#define GX_VP_PAD_SELECT_MASK          0x3FFFFFFF
-#define GX_VP_PAD_SELECT_TFT           0x1FFFFFFF
-
-/* Geode GX clock control MSRs */
-
-#  define MSR_GLCP_SYS_RSTPLL_DOTPREDIV2	(0x0000000000000002ull)
-#  define MSR_GLCP_SYS_RSTPLL_DOTPREMULT2	(0x0000000000000004ull)
-#  define MSR_GLCP_SYS_RSTPLL_DOTPOSTDIV3	(0x0000000000000008ull)
-
-#  define MSR_GLCP_DOTPLL_DOTRESET		(0x0000000000000001ull)
-#  define MSR_GLCP_DOTPLL_BYPASS		(0x0000000000008000ull)
-#  define MSR_GLCP_DOTPLL_LOCK			(0x0000000002000000ull)
