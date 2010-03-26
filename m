From: akpm@linux-foundation.org
Subject: [merged] lxfb-set-the-h-and-v-sync-polarity-of-the-flatpanel-output.patch removed from -mm tree
Date: Fri, 26 Mar 2010 12:37:28 -0400
Message-ID: <201003261938.o2QJcRds016688@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48581 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752910Ab0CZTij (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Mar 2010 15:38:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.grzeschik@pengutronix.de, dilinger@collabora.co.uk, mm-commits@vger.kernel.org


The patch titled
     lxfb: set the H- and V-SYNC polarity of the flatpanel output
has been removed from the -mm tree.  Its filename was
     lxfb-set-the-h-and-v-sync-polarity-of-the-flatpanel-output.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lxfb: set the H- and V-SYNC polarity of the flatpanel output
From: Michael Grzeschik <m.grzeschik@pengutronix.de>

Fixup for the flatpanel output.  The geode_modedb attribute flags are used
to set the SYNC polarity of the flatpanel.  Without this patch our
flatpanel registers stayed unconfigured, so we just saw garbage output.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc: Andres Salomon <dilinger@collabora.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/geode/lxfb.h     |    2 ++
 drivers/video/geode/lxfb_ops.c |   10 +++++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff -puN drivers/video/geode/lxfb.h~lxfb-set-the-h-and-v-sync-polarity-of-the-flatpanel-output drivers/video/geode/lxfb.h
--- a/drivers/video/geode/lxfb.h~lxfb-set-the-h-and-v-sync-polarity-of-the-flatpanel-output
+++ a/drivers/video/geode/lxfb.h
@@ -365,6 +365,8 @@ enum fp_registers {
 	FP_CRC, /* 0x458 */
 };
 
+#define FP_PT2_HSP			(1 << 22)
+#define FP_PT2_VSP			(1 << 23)
 #define FP_PT2_SCRC			(1 << 27)	/* shfclk free */
 
 #define FP_PM_P				(1 << 24)	/* panel power ctl */
diff -puN drivers/video/geode/lxfb_ops.c~lxfb-set-the-h-and-v-sync-polarity-of-the-flatpanel-output drivers/video/geode/lxfb_ops.c
--- a/drivers/video/geode/lxfb_ops.c~lxfb-set-the-h-and-v-sync-polarity-of-the-flatpanel-output
+++ a/drivers/video/geode/lxfb_ops.c
@@ -274,7 +274,15 @@ static void lx_graphics_enable(struct fb
 		u32 msrlo, msrhi;
 
 		write_fp(par, FP_PT1, 0);
-		write_fp(par, FP_PT2, FP_PT2_SCRC);
+		temp = FP_PT2_SCRC;
+
+		if (info->var.sync & FB_SYNC_HOR_HIGH_ACT)
+			temp |= FP_PT2_HSP;
+
+		if (info->var.sync & FB_SYNC_VERT_HIGH_ACT)
+			temp |= FP_PT2_VSP;
+
+		write_fp(par, FP_PT2, temp);
 		write_fp(par, FP_DFC, FP_DFC_BC);
 
 		msrlo = MSR_LX_MSR_PADSEL_TFT_SEL_LOW;
_

Patches currently in -mm which might be from m.grzeschik@pengutronix.de are

origin.patch

