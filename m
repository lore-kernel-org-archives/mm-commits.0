From: akpm@linux-foundation.org
Subject: [merged] calibrate-extract-fall-back-calculation-into-own-helper.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:39:04 -0700
Message-ID: <201103232042.p2NKgeFs028787@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52291 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933369Ab1CWUzw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:55:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ext-phil.2.carmody@nokia.com, greg@kroah.com, hpa@zytor.com, mingo@elte.hu, sboyd@codeaurora.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     calibrate: extract fall-back calculation into own helper
has been removed from the -mm tree.  Its filename was
     calibrate-extract-fall-back-calculation-into-own-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: calibrate: extract fall-back calculation into own helper
From: Phil Carmody <ext-phil.2.carmody@nokia.com>

The motivation for this patch series is that currently our OMAP calibrates
itself using the trial-and-error binary chop fallback that some other
architectures no longer need to perform.  This is a lengthy process,
taking 0.2s in an environment where boot time is of great interest.

Patch 2/4 has two optimisations.  Firstly, it replaces the initial
repeated- doubling to find the relevant power of 2 with a tight loop that
just does as much as it can in a jiffy.  Secondly, it doesn't binary chop
over an entire power of 2 range, it choses a much smaller range based on
how much it squeezed in, and failed to squeeze in, during the first stage.
 Both are significant optimisations, and bring our calibration down from
23 jiffies to 5, and, in the process, often arrive at a more accurate lpj
value.

The 'bands' and 'sub-logarithmic' growth may look over-engineered, but
they only cost a small level of inaccuracy in the initial guess (for all
architectures) in order to avoid the very large inaccuracies that appeared
during testing (on x86_64 architectures, and presumably others with less
metronomic operation).  Note that due to the existence of the TSC and
other timers, the x86_64 will not typically use this fallback routine, but
I wanted to code defensively, able to cope with all kinds of processor
behaviours and kernel command line options.

Patch 3/4 is an additional trap for the nightmare scenario where the
initial estimate is very inaccurate, possibly due to things like SMIs.
It simply retries with a larger bound.

Stephen said:

I tried this patch set out on an MSM7630.
: 
: Before:
: 
: Calibrating delay loop... 681.57 BogoMIPS (lpj=3407872)
: 
: After:
: 
: Calibrating delay loop... 680.75 BogoMIPS (lpj=3403776)
: 
: But the really good news is calibration time dropped from ~247ms to ~56ms.
:  Sadly we won't be able to benefit from this should my udelay patches make
: it into ARM because we would be using calibrate_delay_direct() instead (at
: least on machines who choose to).  Can we somehow reapply the logic behind
: this to calibrate_delay_direct()?  That would be even better, but this is
: definitely a boot time improvement.
: 
: Or maybe we could just replace calibrate_delay_direct() with this fallback
: calculation?  If __delay() is a thin wrapper around read_current_timer()
: it should work just as well (plus patch 3 makes it handle SMIs).  I'll try
: that out.

This patch:

... so that it can be modified more clinically.

This is almost entirely cosmetic. The only change to the operation
is that the global variable is only set once after the estimation is
completed, rather than taking on all the intermediate values. However,
there are no readers of that variable, so this change is unimportant.

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Tested-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/calibrate.c |   73 ++++++++++++++++++++++++---------------------
 1 file changed, 40 insertions(+), 33 deletions(-)

diff -puN init/calibrate.c~calibrate-extract-fall-back-calculation-into-own-helper init/calibrate.c
--- a/init/calibrate.c~calibrate-extract-fall-back-calculation-into-own-helper
+++ a/init/calibrate.c
@@ -119,10 +119,47 @@ static unsigned long __cpuinit calibrate
  */
 #define LPS_PREC 8
 
-void __cpuinit calibrate_delay(void)
+static unsigned long __cpuinit calibrate_delay_converge(void)
 {
-	unsigned long ticks, loopbit;
+	unsigned long lpj, ticks, loopbit;
 	int lps_precision = LPS_PREC;
+
+	lpj = (1<<12);
+	while ((lpj <<= 1) != 0) {
+		/* wait for "start of" clock tick */
+		ticks = jiffies;
+		while (ticks == jiffies)
+			/* nothing */;
+		/* Go .. */
+		ticks = jiffies;
+		__delay(lpj);
+		ticks = jiffies - ticks;
+		if (ticks)
+			break;
+	}
+
+	/*
+	 * Do a binary approximation to get lpj set to
+	 * equal one clock (up to lps_precision bits)
+	 */
+	lpj >>= 1;
+	loopbit = lpj;
+	while (lps_precision-- && (loopbit >>= 1)) {
+		lpj |= loopbit;
+		ticks = jiffies;
+		while (ticks == jiffies)
+			/* nothing */;
+		ticks = jiffies;
+		__delay(lpj);
+		if (jiffies != ticks)	/* longer than 1 tick */
+			lpj &= ~loopbit;
+	}
+
+	return lpj;
+}
+
+void __cpuinit calibrate_delay(void)
+{
 	static bool printed;
 
 	if (preset_lpj) {
@@ -139,39 +176,9 @@ void __cpuinit calibrate_delay(void)
 			pr_info("Calibrating delay using timer "
 				"specific routine.. ");
 	} else {
-		loops_per_jiffy = (1<<12);
-
 		if (!printed)
 			pr_info("Calibrating delay loop... ");
-		while ((loops_per_jiffy <<= 1) != 0) {
-			/* wait for "start of" clock tick */
-			ticks = jiffies;
-			while (ticks == jiffies)
-				/* nothing */;
-			/* Go .. */
-			ticks = jiffies;
-			__delay(loops_per_jiffy);
-			ticks = jiffies - ticks;
-			if (ticks)
-				break;
-		}
-
-		/*
-		 * Do a binary approximation to get loops_per_jiffy set to
-		 * equal one clock (up to lps_precision bits)
-		 */
-		loops_per_jiffy >>= 1;
-		loopbit = loops_per_jiffy;
-		while (lps_precision-- && (loopbit >>= 1)) {
-			loops_per_jiffy |= loopbit;
-			ticks = jiffies;
-			while (ticks == jiffies)
-				/* nothing */;
-			ticks = jiffies;
-			__delay(loops_per_jiffy);
-			if (jiffies != ticks)	/* longer than 1 tick */
-				loops_per_jiffy &= ~loopbit;
-		}
+		loops_per_jiffy = calibrate_delay_converge();
 	}
 	if (!printed)
 		pr_cont("%lu.%02lu BogoMIPS (lpj=%lu)\n",
_

Patches currently in -mm which might be from ext-phil.2.carmody@nokia.com are

origin.patch
linux-next.patch

