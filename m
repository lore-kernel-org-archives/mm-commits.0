From: akpm@linux-foundation.org
Subject: + tridentfb-blade3d-clock-fixes.patch added to -mm tree
Date: Fri, 30 May 2008 13:48:04 -0700
Message-ID: <200805302048.m4UKm4ej010752@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38310 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753226AbYE3UsH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 May 2008 16:48:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl


The patch titled
     tridentfb: Blade3D clock fixes
has been added to the -mm tree.  Its filename is
     tridentfb-blade3d-clock-fixes.patch

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
Subject: tridentfb: Blade3D clock fixes
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch fixes following problems:
- does not allow the m parameter to reach 0 as
  it locks the graphics core (power cycle needed)
- for the newer chips (with new clock registers)
  does not allow of n / m ratio below 4 as it gives
  unstable image on the Blade3D core
- extend shift parameter (k) range  to 2 for the newer
  chips to cope with the n /m >= 4 limit at low resolution
  (bandwidth) modes
- prefer modes with higher n / m ratio (higher k values)

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tridentfb.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/video/tridentfb.c~tridentfb-blade3d-clock-fixes drivers/video/tridentfb.c
--- a/drivers/video/tridentfb.c~tridentfb-blade3d-clock-fixes
+++ a/drivers/video/tridentfb.c
@@ -672,15 +672,16 @@ static void set_vclk(struct tridentfb_pa
 	unsigned long fi, d, di;
 	unsigned char best_m = 0, best_n = 0, best_k = 0;
 	unsigned char hi, lo;
+	unsigned char shift = !is_oldclock(par->chip_id) ? 2 : 1;
 
 	d = 20000;
-	for (k = 1; k >= 0; k--)
-		for (m = 0; m < 32; m++) {
-			n = 2 * (m + 2) - 8;
+	for (k = shift; k >= 0; k--)
+		for (m = 1; m < 32; m++) {
+			n = ((m + 2) << shift) - 8;
 			for (n = (n < 0 ? 0 : n); n < 122; n++) {
 				fi = ((14318l * (n + 8)) / (m + 2)) >> k;
 				di = abs(fi - freq);
-				if (di <= d) {
+				if (di < d || (di == d && k == best_k)) {
 					d = di;
 					best_n = n;
 					best_m = m;
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

modedb-fix-incorrect-sync-and-vmode-flags-for-cvt-modes.patch
fbcon-fix-wrong-vmode-bits-copied-on-console-switch.patch
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
amifb-test-virtual-screen-range-before-subtraction-on-unsigned.patch
atafb-test-virtual-screen-range-before-subtraction-on-unsigned.patch
fbcon-make-logo_height-a-local-variable.patch
uvesafb-change-mode-parameter-to-mode_option.patch
tridentfb-documentation-update.patch
tdfxfb-add-mode_option-module-parameter.patch
vga16fb-source-code-improvement.patch
tdfxfb-remove-ypan-checks-done-by-a-higher-layer.patch

