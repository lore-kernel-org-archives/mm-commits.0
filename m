From: akpm@linux-foundation.org
Subject: - tdfxfb-fix-sdram-memory-size-detection.patch removed from -mm tree
Date: Wed, 03 Sep 2008 09:11:49 -0700
Message-ID: <200809031611.m83GBnKZ023797@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36466 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751834AbYICQMA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Sep 2008 12:12:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     tdfxfb: fix SDRAM memory size detection
has been removed from the -mm tree.  Its filename was
     tdfxfb-fix-sdram-memory-size-detection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tdfxfb: fix SDRAM memory size detection
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Fix memory detection on Voodoo3 cards with SDRAM memory.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tdfxfb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/tdfxfb.c~tdfxfb-fix-sdram-memory-size-detection drivers/video/tdfxfb.c
--- a/drivers/video/tdfxfb.c~tdfxfb-fix-sdram-memory-size-detection
+++ a/drivers/video/tdfxfb.c
@@ -426,7 +426,7 @@ static unsigned long do_lfb_size(struct 
 	if (dev_id < PCI_DEVICE_ID_3DFX_VOODOO5) {
 		/* Banshee/Voodoo3 */
 		chip_size = 2;
-		if (has_sgram && (draminit0 & DRAMINIT0_SGRAM_TYPE))
+		if (has_sgram && !(draminit0 & DRAMINIT0_SGRAM_TYPE))
 			chip_size = 1;
 	} else {
 		/* Voodoo4/5 */
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

