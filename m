From: akpm@linux-foundation.org
Subject: + tridentfb-fix-clock-settings-for-older-trident-96xx-chips.patch added to -mm tree
Date: Fri, 09 May 2008 14:03:51 -0700
Message-ID: <200805092103.m49L3pR5025536@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39786 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751897AbYEIVEV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 May 2008 17:04:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl


The patch titled
     tridentfb: fix clock settings for older Trident 96XX chips
has been added to the -mm tree.  Its filename is
     tridentfb-fix-clock-settings-for-older-trident-96xx-chips.patch

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
Subject: tridentfb: fix clock settings for older Trident 96XX chips
From: Krzysztof Helt <krzysztof.h1@wp.pl>

The Xorg code shows that Trident models 9660, 9680 and 9682 require a
different clock setting method.  Add the second clock setting method for older
models.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tridentfb.c |   31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff -puN drivers/video/tridentfb.c~tridentfb-fix-clock-settings-for-older-trident-96xx-chips drivers/video/tridentfb.c
--- a/drivers/video/tridentfb.c~tridentfb-fix-clock-settings-for-older-trident-96xx-chips
+++ a/drivers/video/tridentfb.c
@@ -85,6 +85,11 @@ MODULE_PARM_DESC(fp, "Define if flatpane
 module_param(crt, int, 0);
 MODULE_PARM_DESC(crt, "Define if CRT is connected");
 
+static int is_oldclock(int id)
+{
+	return (id == TGUI9660);
+}
+
 static int is_blade(int id)
 {
 	return	(id == BLADE3D) ||
@@ -659,23 +664,33 @@ static void set_screen_start(struct trid
 static void set_vclk(struct tridentfb_par *par, unsigned long freq)
 {
 	int m, n, k;
-	unsigned long f, fi, d, di;
-	unsigned char lo = 0, hi = 0;
+	unsigned long fi, d, di;
+	unsigned char best_m = 0, best_n = 0, best_k = 0;
+	unsigned char hi, lo;
 
 	d = 20000;
-	for (k = 2; k >= 0; k--)
-		for (m = 0; m < 63; m++)
-			for (n = 0; n < 128; n++) {
+	for (k = 1; k >= 0; k--)
+		for (m = 0; m < 32; m++)
+			for (n = 0; n < 122; n++) {
 				fi = ((14318l * (n + 8)) / (m + 2)) >> k;
 				if ((di = abs(fi - freq)) < d) {
 					d = di;
-					f = fi;
-					lo = n;
-					hi = (k << 6) | m;
+					best_n = n;
+					best_m = m;
+					best_k = k;
 				}
 				if (fi > freq)
 					break;
 			}
+
+	if (is_oldclock(par->chip_id)) {
+		lo = best_n | (best_m << 7);
+		hi = (best_m >> 1) | (best_k << 4);
+	} else {
+		lo = best_n;
+		hi = best_m | (best_k << 6);
+	}
+
 	if (is3Dchip(par->chip_id)) {
 		vga_mm_wseq(par->io_virt, ClockHigh, hi);
 		vga_mm_wseq(par->io_virt, ClockLow, lo);
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

tridentfb-remove-misplaced-enable_mmio.patch
tridentfb-improve-clock-setting-accuracy.patch
drivers-video-pnx4008-eliminate-double-free.patch
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
amifb-test-virtual-screen-range-before-subtraction-on-unsigned.patch
atafb-test-virtual-screen-range-before-subtraction-on-unsigned.patch

