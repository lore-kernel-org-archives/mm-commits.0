From: akpm@linux-foundation.org
Subject: [merged] drivers-video-via-fix-continuation-line-formats.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:57:09 -0400
Message-ID: <201003150657.o2F6vg6B016393@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45563 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756997Ab0COG5q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:57:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, FlorianSchandinat@gmx.de, mm-commits@vger.kernel.org


The patch titled
     drivers/video/via: fix continuation line formats
has been removed from the -mm tree.  Its filename was
     drivers-video-via-fix-continuation-line-formats.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/video/via: fix continuation line formats
From: Joe Perches <joe@perches.com>

String constants that are continued on subsequent lines with \ will cause
spurious whitespace in the resulting output.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/dvi.c |    8 ++++----
 drivers/video/via/lcd.c |   12 ++++++------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff -puN drivers/video/via/dvi.c~drivers-video-via-fix-continuation-line-formats drivers/video/via/dvi.c
--- a/drivers/video/via/dvi.c~drivers-video-via-fix-continuation-line-formats
+++ a/drivers/video/via/dvi.c
@@ -411,8 +411,8 @@ static void dvi_get_panel_size_from_DDCv
 		tmds_setting->max_vres = 1080;
 		break;
 	default:
-		DEBUG_MSG(KERN_INFO "Unknown panel size max resolution = %d !\
-					 set default panel size.\n", max_h);
+		DEBUG_MSG(KERN_INFO "Unknown panel size max resolution = %d ! "
+					 "set default panel size.\n", max_h);
 		break;
 	}
 
@@ -460,8 +460,8 @@ static void dvi_get_panel_size_from_DDCv
 		tmds_setting->max_vres = 1200;
 		break;
 	default:
-		DEBUG_MSG(KERN_INFO "Unknown panel size max resolution = %d!\
-			set default panel size.\n", tmds_setting->max_hres);
+		DEBUG_MSG(KERN_INFO "Unknown panel size max resolution = %d! "
+			"set default panel size.\n", tmds_setting->max_hres);
 		break;
 	}
 
diff -puN drivers/video/via/lcd.c~drivers-video-via-fix-continuation-line-formats drivers/video/via/lcd.c
--- a/drivers/video/via/lcd.c~drivers-video-via-fix-continuation-line-formats
+++ a/drivers/video/via/lcd.c
@@ -136,13 +136,13 @@ static bool lvds_identify_integratedlvds
 		if (viaparinfo->chip_info->lvds_chip_info.lvds_chip_name) {
 			viaparinfo->chip_info->lvds_chip_info2.lvds_chip_name =
 			    INTEGRATED_LVDS;
-			DEBUG_MSG(KERN_INFO "Support two dual channel LVDS!\
-				  (Internal LVDS + External LVDS)\n");
+			DEBUG_MSG(KERN_INFO "Support two dual channel LVDS! "
+				  "(Internal LVDS + External LVDS)\n");
 		} else {
 			viaparinfo->chip_info->lvds_chip_info.lvds_chip_name =
 			    INTEGRATED_LVDS;
-			DEBUG_MSG(KERN_INFO "Not found external LVDS,\
-				  so can't support two dual channel LVDS!\n");
+			DEBUG_MSG(KERN_INFO "Not found external LVDS, "
+				  "so can't support two dual channel LVDS!\n");
 		}
 	} else if (viafb_display_hardware_layout == HW_LAYOUT_LCD1_LCD2) {
 		/* Two single channel LCD (Internal LVDS + Internal LVDS): */
@@ -150,8 +150,8 @@ static bool lvds_identify_integratedlvds
 		INTEGRATED_LVDS;
 		viaparinfo->chip_info->lvds_chip_info2.lvds_chip_name =
 			INTEGRATED_LVDS;
-		DEBUG_MSG(KERN_INFO "Support two single channel LVDS!\
-			  (Internal LVDS + Internal LVDS)\n");
+		DEBUG_MSG(KERN_INFO "Support two single channel LVDS! "
+			  "(Internal LVDS + Internal LVDS)\n");
 	} else if (viafb_display_hardware_layout != HW_LAYOUT_DVI_ONLY) {
 		/* If we have found external LVDS, just use it,
 		   otherwise, we will use internal LVDS as default. */
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
drivers-gpu-drm-i915-intel_biosc-fix-continuation-line-formats.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-qla2xxx-qla_osc-fix-continuation-line-formats.patch
drivers-scsi-chc-dont-use-vprintk-as-macro.patch
vsprintfc-use-noinline_for_stack.patch

