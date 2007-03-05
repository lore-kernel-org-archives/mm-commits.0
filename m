From: akpm@linux-foundation.org
Subject: + cleanup-unify-tsc_unstable-and-tsc_disable.patch added to -mm tree
Date: Sun, 04 Mar 2007 22:56:21 -0800
Message-ID: <200703050656.l256uLVJ012072@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33663 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752697AbXCEG5L (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 01:57:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: guichaz@gmail.com, guichaz@yahoo.fr, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     Cleanup: Unify tsc_unstable and tsc_disable
has been added to the -mm tree.  Its filename is
     cleanup-unify-tsc_unstable-and-tsc_disable.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Cleanup: Unify tsc_unstable and tsc_disable
From: "Guillaume Chazarain" <guichaz@gmail.com>

tsc_unstable and tsc_disable serve the same purpose.

Signed-off-by: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/tsc.c |   26 ++++++++------------------
 1 file changed, 8 insertions(+), 18 deletions(-)

diff -puN arch/i386/kernel/tsc.c~cleanup-unify-tsc_unstable-and-tsc_disable arch/i386/kernel/tsc.c
--- a/arch/i386/kernel/tsc.c~cleanup-unify-tsc_unstable-and-tsc_disable
+++ a/arch/i386/kernel/tsc.c
@@ -50,16 +50,6 @@ static int __init tsc_setup(char *str)
 
 __setup("notsc", tsc_setup);
 
-/*
- * code to mark and check if the TSC is unstable
- * due to cpufreq or due to unsynced TSCs
- */
-static int tsc_unstable;
-
-static inline int check_tsc_unstable(void)
-{
-	return tsc_unstable;
-}
 
 /* Accellerators for sched_clock()
  * convert from cycles(64bits) => nanoseconds (64bits)
@@ -106,7 +96,7 @@ unsigned long long sched_clock(void)
 	/*
 	 * Fall back to jiffies if there's no TSC available:
 	 */
-	if (tsc_unstable || unlikely(tsc_disable))
+	if (unlikely(tsc_disable))
 		/* No locking but a rare wrong value is not a big deal: */
 		return (jiffies_64 - INITIAL_JIFFIES) * (1000000000 / HZ);
 
@@ -282,8 +272,8 @@ static struct clocksource clocksource_ts
 
 void mark_tsc_unstable(void)
 {
-	if (!tsc_unstable) {
-		tsc_unstable = 1;
+	if (!tsc_disable) {
+		tsc_disable = 1;
 		/* Can be called before registration */
 		if (clocksource_tsc.mult)
 			clocksource_change_rating(&clocksource_tsc, 0);
@@ -297,7 +287,7 @@ static int __init dmi_mark_tsc_unstable(
 {
 	printk(KERN_NOTICE "%s detected: marking TSC unstable.\n",
 		       d->ident);
-	tsc_unstable = 1;
+	tsc_disable = 1;
 	return 0;
 }
 
@@ -320,7 +310,7 @@ static struct dmi_system_id __initdata b
  */
 __cpuinit int unsynchronized_tsc(void)
 {
-	if (!cpu_has_tsc || tsc_unstable)
+	if (!cpu_has_tsc || tsc_disable)
 		return 1;
 	/*
 	 * Intel systems are normally all synchronized.
@@ -329,9 +319,9 @@ __cpuinit int unsynchronized_tsc(void)
 	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL) {
 		/* assume multi socket systems are not synchronized: */
 		if (num_possible_cpus() > 1)
-			tsc_unstable = 1;
+			tsc_disable = 1;
 	}
-	return tsc_unstable;
+	return tsc_disable;
 }
 
 /*
@@ -381,7 +371,7 @@ void __init tsc_init(void)
 	clocksource_tsc.mult = clocksource_khz2mult(current_tsc_khz,
 							clocksource_tsc.shift);
 	/* lower the rating if we already know its unstable: */
-	if (check_tsc_unstable()) {
+	if (tsc_disable) {
 		clocksource_tsc.rating = 0;
 		clocksource_tsc.flags &= ~CLOCK_SOURCE_IS_CONTINUOUS;
 	}
_

Patches currently in -mm which might be from guichaz@gmail.com are

bugfix-dont-use-the-tsc-in-sched_clock-if-unstable.patch
cleanup-unify-tsc_unstable-and-tsc_disable.patch
possible-bugfix-make-dmi_mark_tsc_unstable-call-mark_tsc_unstable.patch
