From: akpm@linux-foundation.org
Subject: + calibrate-retry-with-wider-bounds-when-converge-seems-to-fail.patch added to -mm tree
Date: Fri, 11 Mar 2011 15:28:16 -0800
Message-ID: <201103112328.p2BNSH7I002192@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34948 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751147Ab1CKX2i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Mar 2011 18:28:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ext-phil.2.carmody@nokia.com, greg@kroah.com, hpa@zytor.com, mingo@elte.hu, sboyd@codeaurora.org, tglx@linutronix.de


The patch titled
     calibrate: retry with wider bounds when converge seems to fail
has been added to the -mm tree.  Its filename is
     calibrate-retry-with-wider-bounds-when-converge-seems-to-fail.patch

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

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
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
+	 * start, and larger range. (Only seen on x86_64.)
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

linux-next.patch
calibrate-extract-fall-back-calculation-into-own-helper.patch
calibrate-home-in-on-correct-lpj-value-more-quickly.patch
calibrate-retry-with-wider-bounds-when-converge-seems-to-fail.patch
calibrate-retry-with-wider-bounds-when-converge-seems-to-fail-fix.patch

