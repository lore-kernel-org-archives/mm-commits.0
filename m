From: akpm@linux-foundation.org
Subject: + cirrusfb-fix-threshold-register-mask-for-laguna-chips.patch added to -mm tree
Date: Thu, 19 Mar 2009 15:43:27 -0700
Message-ID: <200903192247.n2JMl2Vl014087@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51424 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753835AbZCSWsN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Mar 2009 18:48:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl


The patch titled
     cirrusfb: fix threshold register mask for Laguna chips
has been added to the -mm tree.  Its filename is
     cirrusfb-fix-threshold-register-mask-for-laguna-chips.patch

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
Subject: cirrusfb: fix threshold register mask for Laguna chips
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Fix threshold register mask for Laguna chips otherwise some 8bpp modes are
garbled after selecting a 24bpp mode.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/cirrusfb.c~cirrusfb-fix-threshold-register-mask-for-laguna-chips drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~cirrusfb-fix-threshold-register-mask-for-laguna-chips
+++ a/drivers/video/cirrusfb.c
@@ -875,7 +875,7 @@ static int cirrusfb_set_par_foo(struct f
 		threshold = fb_readw(cinfo->laguna_mmio + 0xea);
 		control &= ~0x6800;
 		format = 0;
-		threshold &= 0xffe0 & 0x3fbf;
+		threshold &= 0xffc0 & 0x3fbf;
 	}
 	if (nom) {
 		tmp = den << 1;
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

