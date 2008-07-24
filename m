From: akpm@linux-foundation.org
Subject: - tridentfb-fix-clock-settings-for-older-trident-96xx-chips.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:30:59 -0700
Message-ID: <200807242330.m6ONUxNl011570@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47088 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756012AbYGXXbB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:31:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     tridentfb: fix clock settings for older Trident 96XX chips
has been removed from the -mm tree.  Its filename was
     tridentfb-fix-clock-settings-for-older-trident-96xx-chips.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

