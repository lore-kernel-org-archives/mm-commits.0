From: akpm@linux-foundation.org
Subject: + watchdog-s3c2410-watchdog-cleanup-and-switch-to-unlocked_ioctl-fix.patch added to -mm tree
Date: Sat, 05 Jul 2008 13:58:35 -0700
Message-ID: <200807052058.m65KwZ7N006112@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52558 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752744AbYGEU70 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 5 Jul 2008 16:59:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, alan@lxorguk.ukuu.org.uk, wim@iguana.be


The patch titled
     s3c2410_wdt: remove duplicated function __s3c2410wdt_stop
has been added to the -mm tree.  Its filename is
     watchdog-s3c2410-watchdog-cleanup-and-switch-to-unlocked_ioctl-fix.patch

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
Subject: s3c2410_wdt: remove duplicated function __s3c2410wdt_stop
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Remove the duplicated function __s3c2410wdt_stop() and remove return value
from the s3c2410wdt_start().

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/s3c2410_wdt.c |   13 -------------
 1 file changed, 13 deletions(-)

diff -puN drivers/watchdog/s3c2410_wdt.c~watchdog-s3c2410-watchdog-cleanup-and-switch-to-unlocked_ioctl-fix drivers/watchdog/s3c2410_wdt.c
--- a/drivers/watchdog/s3c2410_wdt.c~watchdog-s3c2410-watchdog-cleanup-and-switch-to-unlocked_ioctl-fix
+++ a/drivers/watchdog/s3c2410_wdt.c
@@ -119,17 +119,6 @@ static void __s3c2410wdt_stop(void)
 {
 	unsigned long wtcon;
 
-	spin_lock(&wdt_lock);
-	wtcon = readl(wdt_base + S3C2410_WTCON);
-	wtcon &= ~(S3C2410_WTCON_ENABLE | S3C2410_WTCON_RSTEN);
-	writel(wtcon, wdt_base + S3C2410_WTCON);
-	spin_unlock(&wdt_lock);
-}
-
-static void __s3c2410wdt_stop(void)
-{
-	unsigned long wtcon;
-
 	wtcon = readl(wdt_base + S3C2410_WTCON);
 	wtcon &= ~(S3C2410_WTCON_ENABLE | S3C2410_WTCON_RSTEN);
 	writel(wtcon, wdt_base + S3C2410_WTCON);
@@ -168,8 +157,6 @@ static void s3c2410wdt_start(void)
 	writel(wdt_count, wdt_base + S3C2410_WTCNT);
 	writel(wtcon, wdt_base + S3C2410_WTCON);
 	spin_unlock(&wdt_lock);
-
-	return 0;
 }
 
 static int s3c2410wdt_set_heartbeat(int timeout)
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
linux-next.patch
watchdog-s3c2410-watchdog-cleanup-and-switch-to-unlocked_ioctl-fix.patch
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
tridentfb-y-panning-fixes.patch
tridentfb-blade3d-clock-fixes.patch
tridentfb-add-imageblit-acceleration-for-blade3d-family.patch
amifb-test-virtual-screen-range-before-subtraction-on-unsigned.patch
atafb-test-virtual-screen-range-before-subtraction-on-unsigned.patch
fbcon-make-logo_height-a-local-variable.patch
uvesafb-change-mode-parameter-to-mode_option.patch
tridentfb-documentation-update.patch
tdfxfb-add-mode_option-module-parameter.patch
vga16fb-source-code-improvement.patch
tdfxfb-remove-ypan-checks-done-by-a-higher-layer.patch
vfb-only-enable-if-explicitly-requested-when-compiled-in.patch
hgafb-convert-to-new-platform-driver-api-bugzilla-9689.patch
skeletonfb-update-to-correct-platform-driver-usage.patch
neofb-simplify-clock-calculation.patch
neofb-drop-redundant-code.patch
neofb-drop-the-xtimings-structure.patch

