From: akpm@linux-foundation.org
Subject: - tdfxfb-fix-frame-buffer-name-overrun.patch removed from -mm tree
Date: Wed, 03 Sep 2008 09:11:51 -0700
Message-ID: <200809031611.m83GBpmc023800@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33385 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751851AbYICQMC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Sep 2008 12:12:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     tdfxfb: fix frame buffer name overrun
has been removed from the -mm tree.  Its filename was
     tdfxfb-fix-frame-buffer-name-overrun.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tdfxfb: fix frame buffer name overrun
From: Krzysztof Helt <krzysztof.h1@wp.pl>

If there are more then one graphics card handled by the tdfxfb driver the
name of the frame buffer overruns reserved size.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tdfxfb.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/video/tdfxfb.c~tdfxfb-fix-frame-buffer-name-overrun drivers/video/tdfxfb.c
--- a/drivers/video/tdfxfb.c~tdfxfb-fix-frame-buffer-name-overrun
+++ a/drivers/video/tdfxfb.c
@@ -95,7 +95,6 @@ static inline int mtrr_del(int reg, unsi
 #define VOODOO5_MAX_PIXCLOCK 350000
 
 static struct fb_fix_screeninfo tdfx_fix __devinitdata = {
-	.id =		"3Dfx",
 	.type =		FB_TYPE_PACKED_PIXELS,
 	.visual =	FB_VISUAL_PSEUDOCOLOR,
 	.ypanstep =	1,
@@ -1200,15 +1199,15 @@ static int __devinit tdfxfb_probe(struct
 	/* Configure the default fb_fix_screeninfo first */
 	switch (pdev->device) {
 	case PCI_DEVICE_ID_3DFX_BANSHEE:
-		strcat(tdfx_fix.id, " Banshee");
+		strcpy(tdfx_fix.id, "3Dfx Banshee");
 		default_par->max_pixclock = BANSHEE_MAX_PIXCLOCK;
 		break;
 	case PCI_DEVICE_ID_3DFX_VOODOO3:
-		strcat(tdfx_fix.id, " Voodoo3");
+		strcpy(tdfx_fix.id, "3Dfx Voodoo3");
 		default_par->max_pixclock = VOODOO3_MAX_PIXCLOCK;
 		break;
 	case PCI_DEVICE_ID_3DFX_VOODOO5:
-		strcat(tdfx_fix.id, " Voodoo5");
+		strcpy(tdfx_fix.id, "3Dfx Voodoo5");
 		default_par->max_pixclock = VOODOO5_MAX_PIXCLOCK;
 		break;
 	}
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
linux-next.patch
fb-metronome-printk-format-warning.patch
x86-delay-early-cpu-initialization-until-cpuid-is-done.patch
x86-move-mtrr-cpu-cap-setting-early-in-early_init_xxxx.patch
rtc-m48t59-reduce-structure-m48t59_private.patch
rtc-m48t59-add-support-for-m48t02-and-m48t59-chips-2nd-rev.patch
fb-convert-lock-unlock_kernel-into-local-fb-mutex.patch
neofb-reduce-panning-function.patch
viafb-accelc-accelh-update.patch
viafb-viafbdevc-update.patch
fbdev-kconfig-update.patch
fbdev-kconfig-update-fix.patch
neofb-kill-some-redundant-code.patch
vga16fb-remove-open_lock-mutex.patch
neofb-remove-open_lock-mutex.patch
cirrusfb-remove-information-about-memory-size-during-mode-change.patch
cirrusfb-simplify-clock-calculation.patch
cirrusfb-remove-24-bpp-mode.patch
cirrusfb-drop-device-pointers-from-cirrusfb_info.patch
tdfxfb-do-not-make-changes-to-default-tdfx_fix.patch
intelfb-support-945gme-as-used-in-asus-eee-901.patch
cirrusfb-use-modedb-and-add-mode_option-parameter-2nd-rev.patch

