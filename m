From: akpm@linux-foundation.org
Subject: + tridentfb-fix-224-color-logo-at-8-bpp.patch added to -mm tree
Date: Thu, 22 May 2008 16:50:27 -0700
Message-ID: <200805222350.m4MNoR2g027806@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46524 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759550AbYEVXu3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 May 2008 19:50:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl


The patch titled
     tridentfb: fix 224 color logo at 8 bpp
has been added to the -mm tree.  Its filename is
     tridentfb-fix-224-color-logo-at-8-bpp.patch

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
Subject: tridentfb: fix 224 color logo at 8 bpp
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Fix depth setting for 8 bpp mode.  The nice 224 color logo is not
displayed in 8 bpp depth without this fix.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tridentfb.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/video/tridentfb.c~tridentfb-fix-224-color-logo-at-8-bpp drivers/video/tridentfb.c
--- a/drivers/video/tridentfb.c~tridentfb-fix-224-color-logo-at-8-bpp
+++ a/drivers/video/tridentfb.c
@@ -878,11 +878,9 @@ static int tridentfb_check_var(struct fb
 	switch (bpp) {
 	case 8:
 		var->red.offset = 0;
-		var->green.offset = 0;
-		var->blue.offset = 0;
-		var->red.length = 6;
-		var->green.length = 6;
-		var->blue.length = 6;
+		var->red.length = 8;
+		var->green = var->red;
+		var->blue = var->red;
 		break;
 	case 16:
 		var->red.offset = 11;
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

sm501-reverse-fpen-vbiasen-flags-behaviour.patch
s3c2410-ensure-that-fb_blank_powerdown-shuts-down-the-controller.patch
s3c2410-add-error-print-if-we-cannot-add-attribute.patch
s3c2410-clean-out-changelog-header-and-tidy.patch
s3c2410-fix-driver-module_alias.patch
tridentfb-replace-macros-with-functions.patch
tridentfb-convert-fb_info-into-allocated-one.patch
tridentfb-move-global-pseudo-palette-into-structure.patch
tridentfb-move-global-chip_id-into-structure.patch
tridentfb-move-global-flat-panel-variable-into-structure.patch
tridentfb-convert-is_blade-and-is_xp-macros-into-functions.patch
tridentfb-move-global-acceleration-hooks-into-structure.patch
tridentfb-make-use-of-functions-and-constants-from-the-vgah.patch
tridentfb-fix-timing-calculations.patch
tridentfb-use-mmio-access-for-clock-setting.patch
tridentfb-fix-clock-settings-for-older-trident-96xx-chips.patch
tridentfb-improve-probe-function.patch
tridentfb-improved-register-values-on-tgui-9680.patch
tridentfb-add-tgui-9440-support.patch
tridentfb-fix-unitialized-pseudo_palette.patch
tridentfb-improve-check_var-function.patch
tridentfb-preserve-memory-type-settings.patch
tridentfb-fix-hi-color-modes-for-tgui-9440.patch
tridentfb-add-acceleration-for-tgui-families.patch
tridentfb-acceleration-code-improvements.patch
tridentfb-acceleration-bug-fixes.patch
tridentfb-various-pixclock-and-timing-improvements.patch
tridentfb-acceleration-constants-change.patch
tridentfb-source-code-improvements.patch
tridentfb-fix-console-freeze-when-switching-from-x11.patch
tridentfb-fix-224-color-logo-at-8-bpp.patch
amifb-test-virtual-screen-range-before-subtraction-on-unsigned.patch
atafb-test-virtual-screen-range-before-subtraction-on-unsigned.patch
fbcon-make-logo_height-a-local-variable.patch

