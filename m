From: akpm@linux-foundation.org
Subject: - clocksource-remove-the-update-callback.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:14:06 -0800
Message-ID: <200702170714.l1H7E6NH021503@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51253 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946556AbXBQHRk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:17:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, johnstul@us.ibm.com, mingo@elte.hu, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     clocksource: Remove the update callback
has been removed from the -mm tree.  Its filename was
     clocksource-remove-the-update-callback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: clocksource: Remove the update callback
From: Thomas Gleixner <tglx@linutronix.de>

The clocksource code allows direct updates of the rating of a given
clocksource now.  Change TSC unstable tracking to use this interface and
remove the update callback.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/tsc.c      |   50 +++++++++++-----------------------
 include/linux/clocksource.h |    2 -
 kernel/timer.c              |    2 -
 3 files changed, 17 insertions(+), 37 deletions(-)

diff -puN arch/i386/kernel/tsc.c~clocksource-remove-the-update-callback arch/i386/kernel/tsc.c
--- a/arch/i386/kernel/tsc.c~clocksource-remove-the-update-callback
+++ a/arch/i386/kernel/tsc.c
@@ -60,12 +60,6 @@ static inline int check_tsc_unstable(voi
 	return tsc_unstable;
 }
 
-void mark_tsc_unstable(void)
-{
-	tsc_unstable = 1;
-}
-EXPORT_SYMBOL_GPL(mark_tsc_unstable);
-
 /* Accellerators for sched_clock()
  * convert from cycles(64bits) => nanoseconds (64bits)
  *  basic equation:
@@ -295,7 +289,6 @@ core_initcall(cpufreq_tsc);
 /* clock source code */
 
 static unsigned long current_tsc_khz = 0;
-static int tsc_update_callback(void);
 
 static cycle_t read_tsc(void)
 {
@@ -313,37 +306,28 @@ static struct clocksource clocksource_ts
 	.mask			= CLOCKSOURCE_MASK(64),
 	.mult			= 0, /* to be set */
 	.shift			= 22,
-	.update_callback	= tsc_update_callback,
 	.flags			= CLOCK_SOURCE_IS_CONTINUOUS |
 				  CLOCK_SOURCE_MUST_VERIFY,
 };
 
-static int tsc_update_callback(void)
+void mark_tsc_unstable(void)
 {
-	int change = 0;
-
-	/* check to see if we should switch to the safe clocksource: */
-	if (clocksource_tsc.rating != 0 && check_tsc_unstable()) {
-		clocksource_change_rating(&clocksource_tsc, 0);
-		change = 1;
-	}
-
-	/* only update if tsc_khz has changed: */
-	if (current_tsc_khz != tsc_khz) {
-		current_tsc_khz = tsc_khz;
-		clocksource_tsc.mult = clocksource_khz2mult(current_tsc_khz,
-							clocksource_tsc.shift);
-		change = 1;
+	if (!tsc_unstable) {
+		tsc_unstable = 1;
+		/* Can be called before registration */
+		if (clocksource_tsc.mult)
+			clocksource_change_rating(&clocksource_tsc, 0);
+		else
+			clocksource_tsc.rating = 0;
 	}
-
-	return change;
 }
+EXPORT_SYMBOL_GPL(mark_tsc_unstable);
 
 static int __init dmi_mark_tsc_unstable(struct dmi_system_id *d)
 {
 	printk(KERN_NOTICE "%s detected: marking TSC unstable.\n",
 		       d->ident);
-	mark_tsc_unstable();
+	tsc_unstable = 1;
 	return 0;
 }
 
@@ -415,11 +399,12 @@ __cpuinit int unsynchronized_tsc(void)
 	 * Intel systems are normally all synchronized.
 	 * Exceptions must mark TSC as unstable:
 	 */
-	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL)
- 		return 0;
-
-	/* assume multi socket systems are not synchronized: */
- 	return num_possible_cpus() > 1;
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL) {
+		/* assume multi socket systems are not synchronized: */
+		if (num_possible_cpus() > 1)
+			tsc_unstable = 1;
+	}
+	return tsc_unstable;
 }
 
 static int __init init_tsc_clocksource(void)
@@ -429,8 +414,7 @@ static int __init init_tsc_clocksource(v
 		/* check blacklist */
 		dmi_check_system(bad_tsc_dmi_table);
 
-		if (unsynchronized_tsc()) /* mark unstable if unsynced */
-			mark_tsc_unstable();
+		unsynchronized_tsc();
 		current_tsc_khz = tsc_khz;
 		clocksource_tsc.mult = clocksource_khz2mult(current_tsc_khz,
 							clocksource_tsc.shift);
diff -puN include/linux/clocksource.h~clocksource-remove-the-update-callback include/linux/clocksource.h
--- a/include/linux/clocksource.h~clocksource-remove-the-update-callback
+++ a/include/linux/clocksource.h
@@ -44,7 +44,6 @@ typedef u64 cycle_t;
  *			subtraction of non 64 bit counters
  * @mult:		cycle to nanosecond multiplier
  * @shift:		cycle to nanosecond divisor (power of two)
- * @update_callback:	called when safe to alter clocksource values
  * @flags:		flags describing special properties
  * @cycle_interval:	Used internally by timekeeping core, please ignore.
  * @xtime_interval:	Used internally by timekeeping core, please ignore.
@@ -57,7 +56,6 @@ struct clocksource {
 	cycle_t mask;
 	u32 mult;
 	u32 shift;
-	int (*update_callback)(void);
 	unsigned long flags;
 
 	/* timekeeping specific data, ignore */
diff -puN kernel/timer.c~clocksource-remove-the-update-callback kernel/timer.c
--- a/kernel/timer.c~clocksource-remove-the-update-callback
+++ a/kernel/timer.c
@@ -848,8 +848,6 @@ static int change_clocksource(void)
 		printk(KERN_INFO "Time: %s clocksource has been installed.\n",
 		       clock->name);
 		return 1;
-	} else if (clock->update_callback) {
-		return clock->update_callback();
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-acpi.patch
git-block.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-3.patch
