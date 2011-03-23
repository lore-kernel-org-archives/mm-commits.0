From: akpm@linux-foundation.org
Subject: [merged] calibrate-home-in-on-correct-lpj-value-more-quickly.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:39:07 -0700
Message-ID: <201103232042.p2NKghHI028796@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41177 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933435Ab1CWUni (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:43:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ext-phil.2.carmody@nokia.com, greg@kroah.com, hpa@zytor.com, mingo@elte.hu, sboyd@codeaurora.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     calibrate: home in on correct lpj value more quickly
has been removed from the -mm tree.  Its filename was
     calibrate-home-in-on-correct-lpj-value-more-quickly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: calibrate: home in on correct lpj value more quickly
From: Phil Carmody <ext-phil.2.carmody@nokia.com>

Binary chop with a jiffy-resync on each step to find an upper bound is
slow, so just race in a tight-ish loop to find an underestimate.

If done with lots of individual steps, sometimes several hundreds of
iterations would be required, which would impose a significant overhead,
and make the initial estimate very low.  By taking slowly increasing steps
there will be less overhead.

E.g.  an x86_64 2.67GHz could have fitted in 613 individual small delays,
but in reality should have been able to fit in a single delay 644 times
longer, so underestimated by 31 steps.  To reach the equivalent of 644
small delays with the accelerating scheme now requires about 130
iterations, so has <1/4th of the overhead, and can therefore be expected
to underestimate by only 7 steps.

As now we have a better initial estimate we can binary chop over a smaller
range.  With the loop overhead in the initial estimate kept low, and the
step sizes moderate, we won't have under-estimated by much, so chose as
tight a range as we can.

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Tested-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/calibrate.c |   57 ++++++++++++++++++++++++++-------------------
 1 file changed, 34 insertions(+), 23 deletions(-)

diff -puN init/calibrate.c~calibrate-home-in-on-correct-lpj-value-more-quickly init/calibrate.c
--- a/init/calibrate.c~calibrate-home-in-on-correct-lpj-value-more-quickly
+++ a/init/calibrate.c
@@ -110,8 +110,8 @@ static unsigned long __cpuinit calibrate
 
 /*
  * This is the number of bits of precision for the loops_per_jiffy.  Each
- * bit takes on average 1.5/HZ seconds.  This (like the original) is a little
- * better than 1%
+ * time we refine our estimate after the first takes 1.5/HZ seconds, so try
+ * to start with a good estimate.
  * For the boot cpu we can skip the delay calibration and assign it a value
  * calculated based on the timer frequency.
  * For the rest of the CPUs we cannot assume that the timer frequency is same as
@@ -121,38 +121,49 @@ static unsigned long __cpuinit calibrate
 
 static unsigned long __cpuinit calibrate_delay_converge(void)
 {
-	unsigned long lpj, ticks, loopbit;
-	int lps_precision = LPS_PREC;
+	/* First stage - slowly accelerate to find initial bounds */
+	unsigned long lpj, ticks, loopadd, chop_limit;
+	int trials = 0, band = 0, trial_in_band = 0;
 
 	lpj = (1<<12);
-	while ((lpj <<= 1) != 0) {
-		/* wait for "start of" clock tick */
-		ticks = jiffies;
-		while (ticks == jiffies)
-			/* nothing */;
-		/* Go .. */
-		ticks = jiffies;
-		__delay(lpj);
-		ticks = jiffies - ticks;
-		if (ticks)
-			break;
-	}
+
+	/* wait for "start of" clock tick */
+	ticks = jiffies;
+	while (ticks == jiffies)
+		; /* nothing */
+	/* Go .. */
+	ticks = jiffies;
+	do {
+		if (++trial_in_band == (1<<band)) {
+			++band;
+			trial_in_band = 0;
+		}
+		__delay(lpj * band);
+		trials += band;
+	} while (ticks == jiffies);
+	/*
+	 * We overshot, so retreat to a clear underestimate. Then estimate
+	 * the largest likely undershoot. This defines our chop bounds.
+	 */
+	trials -= band;
+	loopadd = lpj * band;
+	lpj *= trials;
+	chop_limit = lpj >> (LPS_PREC + 1);
 
 	/*
 	 * Do a binary approximation to get lpj set to
-	 * equal one clock (up to lps_precision bits)
+	 * equal one clock (up to LPS_PREC bits)
 	 */
-	lpj >>= 1;
-	loopbit = lpj;
-	while (lps_precision-- && (loopbit >>= 1)) {
-		lpj |= loopbit;
+	while (loopadd > chop_limit) {
+		lpj += loopadd;
 		ticks = jiffies;
 		while (ticks == jiffies)
-			/* nothing */;
+			; /* nothing */
 		ticks = jiffies;
 		__delay(lpj);
 		if (jiffies != ticks)	/* longer than 1 tick */
-			lpj &= ~loopbit;
+			lpj -= loopadd;
+		loopadd >>= 1;
 	}
 
 	return lpj;
_

Patches currently in -mm which might be from ext-phil.2.carmody@nokia.com are

origin.patch
linux-next.patch

