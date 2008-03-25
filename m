From: akpm@linux-foundation.org
Subject: + gxfb-add-power-management-functionality-fix.patch added to -mm tree
Date: Tue, 25 Mar 2008 12:42:49 -0700
Message-ID: <200803251942.m2PJgnNp010099@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45834 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750760AbYCYTn7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Mar 2008 15:43:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@queued.net, adaplas@pol.net, dilinger@debian.org, jordan.crouse@amd.com


The patch titled
     gxfb: two suspend/resume fixes
has been added to the -mm tree.  Its filename is
     gxfb-add-power-management-functionality-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gxfb: two suspend/resume fixes
From: Andres Salomon <dilinger@queued.net>

Two suspend/resume fixes:
  - we weren't saving/restoring the palette correctly; I wasn't setting
    PAL_ADDRESS correctly.
  - the original GP restore code had an off-by-one bug that I happily
    reproduced in this code.  This fixes that, which fixes the RASTER_MODE
    register not getting set.

And drop an unnecessary comment.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: Jordan Crouse <jordan.crouse@amd.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/geode/suspend_gx.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/video/geode/suspend_gx.c~gxfb-add-power-management-functionality-fix drivers/video/geode/suspend_gx.c
--- a/drivers/video/geode/suspend_gx.c~gxfb-add-power-management-functionality-fix
+++ a/drivers/video/geode/suspend_gx.c
@@ -39,7 +39,7 @@ static void gx_save_regs(struct gxfb_par
 	memcpy(par->fp, par->vid_regs + VP_FP_START, sizeof(par->fp));
 
 	/* save the palette */
-	write_gp(par, DC_PAL_ADDRESS, 0);
+	write_dc(par, DC_PAL_ADDRESS, 0);
 	for (i = 0; i < ARRAY_SIZE(par->pal); i++)
 		par->pal[i] = read_dc(par, DC_PAL_DATA);
 }
@@ -73,10 +73,10 @@ static void gx_restore_gfx_proc(struct g
 
 	for (i = 0; i < ARRAY_SIZE(par->gp); i++) {
 		switch (i) {
-		case GP_RASTER_MODE:
 		case GP_VECTOR_MODE:
 		case GP_BLT_MODE:
 		case GP_BLT_STATUS:
+		case GP_HST_SRC:
 			/* don't restore these registers */
 			break;
 		default:
@@ -130,7 +130,7 @@ static void gx_restore_display_ctlr(stru
 	}
 
 	/* restore the palette */
-	write_gp(par, DC_PAL_ADDRESS, 0);
+	write_dc(par, DC_PAL_ADDRESS, 0);
 	for (i = 0; i < ARRAY_SIZE(par->pal); i++)
 		write_dc(par, DC_PAL_DATA, par->pal[i]);
 }
@@ -163,7 +163,7 @@ static void gx_restore_video_proc(struct
 		case VP_RSVD_3:
 		case VP_CRC32:
 		case VP_AWT:
-		case VP_VTM:    /* this is r/w, shouldn't we restore?  -dil */
+		case VP_VTM:
 			/* don't restore these registers */
 			break;
 		default:
_

Patches currently in -mm which might be from dilinger@queued.net are

x86-geode-msr-cleanup.patch
gxfb-use-pci_device-for-gxfbs-pci-device-table.patch
gxfb-replace-fbsize-config-option-with-a-module-parameter.patch
gxfb-create-dc-vp-fp-specific-handlers-rather-than-using-readl-writel.patch
gxfb-clean-up-register-definitions.patch
gxfb-move-msr-bit-fields-into-gxfbh.patch
gxfb-stop-sharing-code-with-gx1fb.patch
gxfb-add-power-management-functionality.patch
gxfb-add-power-management-functionality-fix.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch-fix.patch

