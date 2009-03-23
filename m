From: akpm@linux-foundation.org
Subject: + tridentfb-delete-acceleration-kconfig-option.patch added to -mm tree
Date: Sun, 22 Mar 2009 18:04:30 -0700
Message-ID: <200903230108.n2N18mvU002379@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35359 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756065AbZCWBKU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 22 Mar 2009 21:10:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl


The patch titled
     tridentfb: delete acceleration Kconfig option
has been added to the -mm tree.  Its filename is
     tridentfb-delete-acceleration-kconfig-option.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tridentfb: delete acceleration Kconfig option
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Remove Kconfig option for tridentfb acceleration.  The acceleration can be
switched off with modules "noaccel" parameter.

The acceleration for Trident chips was fixed in the 2.6.27 kernel.

Also, add CyberXXX and CyberBlade names to Kconfig option's name.  It should
make easier to find the tridentfb choice for cyblafb driver's users.  The
cyblafb driver has been replaced by the tridentfb driver.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig     |    9 +--------
 drivers/video/tridentfb.c |   12 ------------
 2 files changed, 1 insertion(+), 20 deletions(-)

diff -puN drivers/video/Kconfig~tridentfb-delete-acceleration-kconfig-option drivers/video/Kconfig
--- a/drivers/video/Kconfig~tridentfb-delete-acceleration-kconfig-option
+++ a/drivers/video/Kconfig
@@ -1598,7 +1598,7 @@ config FB_VT8623
 	  VIA VT8623 [Apollo CLE266] chipset.
 
 config FB_TRIDENT
-	tristate "Trident support"
+	tristate "Trident/CyberXXX/CyberBlade support"
 	depends on FB && PCI
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
@@ -1617,13 +1617,6 @@ config FB_TRIDENT
 	  To compile this driver as a module, choose M here: the
 	  module will be called tridentfb.
 
-config FB_TRIDENT_ACCEL
-	bool "Trident Acceleration functions (EXPERIMENTAL)"
-	depends on FB_TRIDENT && EXPERIMENTAL
-	---help---
-	This will compile the Trident frame buffer device with
-	acceleration functions.
-
 config FB_ARK
 	tristate "ARK 2000PV support"
 	depends on FB && PCI
diff -puN drivers/video/tridentfb.c~tridentfb-delete-acceleration-kconfig-option drivers/video/tridentfb.c
--- a/drivers/video/tridentfb.c~tridentfb-delete-acceleration-kconfig-option
+++ a/drivers/video/tridentfb.c
@@ -490,7 +490,6 @@ static void tgui_copy_rect(struct triden
 /*
  * Accel functions called by the upper layers
  */
-#ifdef CONFIG_FB_TRIDENT_ACCEL
 static void tridentfb_fillrect(struct fb_info *info,
 			       const struct fb_fillrect *fr)
 {
@@ -565,11 +564,6 @@ static int tridentfb_sync(struct fb_info
 		par->wait_engine(par);
 	return 0;
 }
-#else
-#define tridentfb_fillrect cfb_fillrect
-#define tridentfb_copyarea cfb_copyarea
-#define tridentfb_imageblit cfb_imageblit
-#endif /* CONFIG_FB_TRIDENT_ACCEL */
 
 /*
  * Hardware access functions
@@ -1333,9 +1327,7 @@ static struct fb_ops tridentfb_ops = {
 	.fb_fillrect = tridentfb_fillrect,
 	.fb_copyarea = tridentfb_copyarea,
 	.fb_imageblit = tridentfb_imageblit,
-#ifdef CONFIG_FB_TRIDENT_ACCEL
 	.fb_sync = tridentfb_sync,
-#endif
 };
 
 static int __devinit trident_pci_probe(struct pci_dev *dev,
@@ -1359,10 +1351,6 @@ static int __devinit trident_pci_probe(s
 
 	chip_id = id->device;
 
-#ifndef CONFIG_FB_TRIDENT_ACCEL
-	noaccel = 1;
-#endif
-
 	/* If PCI id is 0x9660 then further detect chip type */
 
 	if (chip_id == TGUI9660) {
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
linux-next.patch
cirrusfb-convert-printks-to-dev_foo-fix-fix3.patch
cirrusfb-fix-laguna-chipset-memory-detection-and-clock-setting.patch
cirrusfb-add-laguna-additional-overflow-register.patch
cirrusfb-add-mmio-registers-for-laguna-chipsets.patch
cirrusfb-do-not-calculate-line-length-twice.patch
cirrusfb-use-5-6-5-rgb-for-16bpp-mode.patch
cirrusfb-various-improvements.patch
cirrusfb-laguna-chipset-8bpp-fix.patch
cirrusfb-check_var-improvements.patch
cirrusfb-various-laguna-fixes.patch
cirrusfb-acceleration-improvements.patch
cirrusfb-add-imageblit-function.patch
cirrusfb-fix-error-paths-in-cirrusfb_xxx_register.patch
cirrusfb-fix-error-paths-in-cirrusfb_xxx_register-fix.patch
cirrusfb-gd5446-fixes.patch
cirrusfb-use-24bpp-instead-of-32bpp.patch
cirrusfb-fix-clock-doubling.patch
cirrusfb-fix-clock-doubling-fix.patch
cirrusfb-add-accelerator-constant.patch
cirrusfb-add-accelerator-constantpatch-compilation-fix.patch
cirrusfb-set-mclk-in-one-place.patch
cirrusfb-set-mclk-in-one-place-fix.patch
cirrusfb-gd5434-aka-sd64-support-fixed.patch
cirrusfb-fix-threshold-register-mask-for-laguna-chips.patch
drivers-video-sgivwfbc-fix-memory-leaks-in-removal-path.patch
tdfxfb-fix-memory-leaks-in-removal-path.patch
tridentfb-fix-memory-leaks-in-removal-path.patch
vfb-fix-memory-leaks-in-removal-path.patch
sstfb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
stifb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
valkyriefb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
68328fb-fix-cmap-memory-leaks.patch
amba-clcd-fix-cmap-memory-leaks.patch
amifb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
asiliantfb-fix-cmap-memory-leaks.patch
asiliantfb-fix-cmap-memory-leaks-fix.patch
remove-cyblafb-driver.patch
nvidiafb-remove-open_lock-mutex.patch
fb-hide-hardware-cursor-in-graphics-mode-mach64.patch
atyfb-speed-up-mach64-cursor.patch
tridentfb-delete-acceleration-kconfig-option.patch

