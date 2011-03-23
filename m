From: akpm@linux-foundation.org
Subject: [merged] calibrate-retry-with-wider-bounds-when-converge-seems-to-fail.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:39:10 -0700
Message-ID: <201103232042.p2NKglUY028799@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47041 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933384Ab1CWUzz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:55:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ext-phil.2.carmody@nokia.com, greg@kroah.com, hpa@zytor.com, mingo@elte.hu, sboyd@codeaurora.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     calibrate: retry with wider bounds when converge seems to fail
has been removed from the -mm tree.  Its filename was
     calibrate-retry-with-wider-bounds-when-converge-seems-to-fail.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: calibrate: retry with wider bounds when converge seems to fail
From: Phil Carmody <ext-phil.2.carmody@nokia.com>

Systems with unmaskable interrupts such as SMIs may massively
underestimate loops_per_jiffy, and fail to converge anywhere near the real
value.  A case seen on x86_64 was an initial estimate of 256<<12, which
converged to 511<<12 where the real value should have been over 630<<12. 
This admitedly requires bypassing the TSC calibration (lpj_fine), and a
failure to settle in the direct calibration too, but is physically
possible.  This failure does not depend on my previous calibration
optimisation, but by luck is easy to fix with the optimisation in place
with a trivial retry loop.

In the context of the optimised converging method, as we can no longer
trust the starting estimate, enlarge the search bounds exponentially so
that the number of retries is logarithmically bounded.

[akpm@linux-foundation.org: mention x86_64 SMIs in comment]
Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Tested-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/calibrate.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff -puN init/calibrate.c~calibrate-retry-with-wider-bounds-when-converge-seems-to-fail init/calibrate.c
--- a/init/calibrate.c~calibrate-retry-with-wider-bounds-when-converge-seems-to-fail
+++ a/init/calibrate.c
@@ -122,7 +122,7 @@ static unsigned long __cpuinit calibrate
 static unsigned long __cpuinit calibrate_delay_converge(void)
 {
 	/* First stage - slowly accelerate to find initial bounds */
-	unsigned long lpj, ticks, loopadd, chop_limit;
+	unsigned long lpj, lpj_base, ticks, loopadd, loopadd_base, chop_limit;
 	int trials = 0, band = 0, trial_in_band = 0;
 
 	lpj = (1<<12);
@@ -146,14 +146,18 @@ static unsigned long __cpuinit calibrate
 	 * the largest likely undershoot. This defines our chop bounds.
 	 */
 	trials -= band;
-	loopadd = lpj * band;
-	lpj *= trials;
-	chop_limit = lpj >> (LPS_PREC + 1);
+	loopadd_base = lpj * band;
+	lpj_base = lpj * trials;
+
+recalibrate:
+	lpj = lpj_base;
+	loopadd = loopadd_base;
 
 	/*
 	 * Do a binary approximation to get lpj set to
 	 * equal one clock (up to LPS_PREC bits)
 	 */
+	chop_limit = lpj >> LPS_PREC;
 	while (loopadd > chop_limit) {
 		lpj += loopadd;
 		ticks = jiffies;
@@ -165,6 +169,16 @@ static unsigned long __cpuinit calibrate
 			lpj -= loopadd;
 		loopadd >>= 1;
 	}
+	/*
+	 * If we incremented every single time possible, presume we've
+	 * massively underestimated initially, and retry with a higher
+	 * start, and larger range. (Only seen on x86_64, due to SMIs)
+	 */
+	if (lpj + loopadd * 2 == lpj_base + loopadd_base * 2) {
+		lpj_base = lpj;
+		loopadd_base <<= 2;
+		goto recalibrate;
+	}
 
 	return lpj;
 }
_

Patches currently in -mm which might be from ext-phil.2.carmody@nokia.com are

origin.patch
linux-next.patch

