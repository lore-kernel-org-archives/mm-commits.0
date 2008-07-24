From: akpm@linux-foundation.org
Subject: - neofb-simplify-clock-calculation.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:33:10 -0700
Message-ID: <200807242333.m6ONXAjo011906@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40991 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755491AbYGXXdM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:33:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     neofb: simplify clock calculation
has been removed from the -mm tree.  Its filename was
     neofb-simplify-clock-calculation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: neofb: simplify clock calculation
From: Krzysztof Helt <krzysztof.h1@wp.pl>

There is nothing to gain by converting value in kHz to fixed point MHz. 
Just calculate everything in kHz.

A reorder of the loop allows reducing number of iterations (check if
frequency is not too high already).

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/neofb.c |   32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff -puN drivers/video/neofb.c~neofb-simplify-clock-calculation drivers/video/neofb.c
--- a/drivers/video/neofb.c~neofb-simplify-clock-calculation
+++ a/drivers/video/neofb.c
@@ -201,7 +201,6 @@ static int neoFindMode(int xres, int yre
  *
  * Determine the closest clock frequency to the one requested.
  */
-#define REF_FREQ 0xe517		/* 14.31818 in 20.12 fixed point */
 #define MAX_N 127
 #define MAX_D 31
 #define MAX_F 1
@@ -211,27 +210,24 @@ static void neoCalcVCLK(const struct fb_
 {
 	int n, d, f;
 	int n_best = 0, d_best = 0, f_best = 0;
-	long f_best_diff = (0x7ffff << 12);	/* 20.12 */
-	long f_target = (freq << 12) / 1000;	/* 20.12 */
+	long f_best_diff = 0x7ffff;
 
 	for (f = 0; f <= MAX_F; f++)
-		for (n = 0; n <= MAX_N; n++)
-			for (d = 0; d <= MAX_D; d++) {
-				long f_out;	/* 20.12 */
-				long f_diff;	/* 20.12 */
-
-				f_out =
-				    ((((n + 1) << 12) / ((d +
-							  1) *
-							 (1 << f))) >> 12)
-				    * REF_FREQ;
-				f_diff = abs(f_out - f_target);
-				if (f_diff < f_best_diff) {
+		for (d = 0; d <= MAX_D; d++)
+			for (n = 0; n <= MAX_N; n++) {
+				long f_out;
+				long f_diff;
+
+				f_out = ((14318 * (n + 1)) / (d + 1)) >> f;
+				f_diff = abs(f_out - freq);
+				if (f_diff <= f_best_diff) {
 					f_best_diff = f_diff;
 					n_best = n;
 					d_best = d;
 					f_best = f;
 				}
+				if (f_out > freq)
+					break;
 			}
 
 	if (info->fix.accel == FB_ACCEL_NEOMAGIC_NM2200 ||
@@ -248,11 +244,11 @@ static void neoCalcVCLK(const struct fb_
 	par->VCLK3Denominator = d_best;
 
 #ifdef NEOFB_DEBUG
-	printk("neoVCLK: f:%d NumLow=%d NumHi=%d Den=%d Df=%d\n",
-	       f_target >> 12,
+	printk(KERN_DEBUG "neoVCLK: f:%ld NumLow=%d NumHi=%d Den=%d Df=%ld\n",
+	       freq,
 	       par->VCLK3NumeratorLow,
 	       par->VCLK3NumeratorHigh,
-	       par->VCLK3Denominator, f_best_diff >> 12);
+	       par->VCLK3Denominator, f_best_diff);
 #endif
 }
 
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch

