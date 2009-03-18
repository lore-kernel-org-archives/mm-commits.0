From: akpm@linux-foundation.org
Subject: + fb-hide-hardware-cursor-in-graphics-mode-mach64.patch added to -mm tree
Date: Wed, 18 Mar 2009 16:49:34 -0700
Message-ID: <200903182352.n2INqulR031666@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48727 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753184AbZCRXzc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Mar 2009 19:55:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, geert@linux-m68k.org, risto.suominen@gmail.com


The patch titled
     fb: hide hardware cursor in graphics mode (Mach64)
has been added to the -mm tree.  Its filename is
     fb-hide-hardware-cursor-in-graphics-mode-mach64.patch

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
Subject: fb: hide hardware cursor in graphics mode (Mach64)
From: Krzysztof Helt <krzysztof.h1@wp.pl>

A hardware cursor is left enabled in the fb_set_par() which is called when a
new console is created.  This is inconsistent with software cursor's
behaviour.

Also, this makes a hardware cursor always visible in the Xfbdev (Xorg kdrive)
server.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Risto Suominen <risto.suominen@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/mach64_accel.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/video/aty/mach64_accel.c~fb-hide-hardware-cursor-in-graphics-mode-mach64 drivers/video/aty/mach64_accel.c
--- a/drivers/video/aty/mach64_accel.c~fb-hide-hardware-cursor-in-graphics-mode-mach64
+++ a/drivers/video/aty/mach64_accel.c
@@ -39,7 +39,8 @@ void aty_reset_engine(const struct atyfb
 {
 	/* reset engine */
 	aty_st_le32(GEN_TEST_CNTL,
-		aty_ld_le32(GEN_TEST_CNTL, par) & ~GUI_ENGINE_ENABLE, par);
+		aty_ld_le32(GEN_TEST_CNTL, par) &
+		~(GUI_ENGINE_ENABLE | HWCURSOR_ENABLE), par);
 	/* enable engine */
 	aty_st_le32(GEN_TEST_CNTL,
 		aty_ld_le32(GEN_TEST_CNTL, par) | GUI_ENGINE_ENABLE, par);
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
cirrusfb-add-accelerator-constant.patch
cirrusfb-set-mclk-in-one-place.patch
nvidiafb-remove-open_lock-mutex.patch
fb-hide-hardware-cursor-in-graphics-mode-mach64.patch
atyfb-speed-up-mach64-cursor.patch

