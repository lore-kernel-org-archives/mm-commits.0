From: akpm@linux-foundation.org
Subject: + tdfxfb-fix-sdram-memory-size-detection.patch added to -mm tree
Date: Thu, 28 Aug 2008 16:37:16 -0700
Message-ID: <200808282337.m7SNbGt6020373@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35902 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757350AbYH1Xh2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Aug 2008 19:37:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, geert@linux-m68k.org


The patch titled
     tdfxfb: fix SDRAM memory size detection
has been added to the -mm tree.  Its filename is
     tdfxfb-fix-sdram-memory-size-detection.patch

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

cirrusfb-check_par-fixes.patch
tdfxfb-fix-sdram-memory-size-detection.patch
tdfxfb-fix-frame-buffer-name-overrun.patch
linux-next.patch
fb-metronome-printk-format-warning.patch
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

