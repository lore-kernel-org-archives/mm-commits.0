From: akpm@osdl.org
Subject: - gxfb-fixup-flatpanel-detection.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:14:43 -0800
Message-ID: <200612082014.kB8KEhE7003211@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59869 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946857AbWLHUOy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:14:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jordan.crouse@amd.com, adaplas@pol.net, jsimmons@infradead.org, mm-commits@vger.kernel.org


The patch titled
     gxfb: Fixup flatpanel detection
has been removed from the -mm tree.  Its filename was
     gxfb-fixup-flatpanel-detection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: gxfb: Fixup flatpanel detection
From: Jordan Crouse <jordan.crouse@amd.com>

Use the right MSR and bits to detect if the GX is strapped for TFT or CRT

Signed-off-by: Jordan Crouse <jordan.crouse@amd.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Acked-by: James Simmons <jsimmons@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/geode/display_gx.h |    2 +-
 drivers/video/geode/gxfb_core.c  |    2 +-
 drivers/video/geode/video_gx.h   |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/video/geode/display_gx.h~gxfb-fixup-flatpanel-detection drivers/video/geode/display_gx.h
--- a/drivers/video/geode/display_gx.h~gxfb-fixup-flatpanel-detection
+++ a/drivers/video/geode/display_gx.h
@@ -18,7 +18,7 @@ extern struct geode_dc_ops gx_dc_ops;
 
 /* MSR that tells us if a TFT or CRT is attached */
 #define GLD_MSR_CONFIG   0xC0002001
-#define GLD_MSR_CONFIG_FMT_FP 0x01
+#define GLD_MSR_CONFIG_DM_FP 0x40
 
 /* Display controller registers */
 
diff -puN drivers/video/geode/gxfb_core.c~gxfb-fixup-flatpanel-detection drivers/video/geode/gxfb_core.c
--- a/drivers/video/geode/gxfb_core.c~gxfb-fixup-flatpanel-detection
+++ a/drivers/video/geode/gxfb_core.c
@@ -328,7 +328,7 @@ static int __init gxfb_probe(struct pci_
 
 	rdmsrl(GLD_MSR_CONFIG, val);
 
-	if (val & GLD_MSR_CONFIG_FMT_FP)
+	if ((val & GLD_MSR_CONFIG_DM_FP) == GLD_MSR_CONFIG_DM_FP)
 		par->enable_crt = 0;
 	else
 		par->enable_crt = 1;
diff -puN drivers/video/geode/video_gx.h~gxfb-fixup-flatpanel-detection drivers/video/geode/video_gx.h
--- a/drivers/video/geode/video_gx.h~gxfb-fixup-flatpanel-detection
+++ a/drivers/video/geode/video_gx.h
@@ -14,7 +14,7 @@
 extern struct geode_vid_ops gx_vid_ops;
 
 /* GX Flatpanel control MSR */
-#define GX_VP_MSR_PAD_SELECT           0x2011
+#define GX_VP_MSR_PAD_SELECT           0xC0002011
 #define GX_VP_PAD_SELECT_MASK          0x3FFFFFFF
 #define GX_VP_PAD_SELECT_TFT           0x1FFFFFFF
 
_

Patches currently in -mm which might be from jordan.crouse@amd.com are

origin.patch
gxfb-fixup-flatpanel-detection.patch
gxfb-turn-on-the-flatpanel-power-and-data.patch
acpi-clear-gpe-before-disabling-it.patch

