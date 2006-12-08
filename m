From: akpm@osdl.org
Subject: - clocksource-increase-initcall-priority.patch removed from -mm tree
Date: Fri, 08 Dec 2006 03:05:28 -0800
Message-ID: <200612081105.kB8B5Sel018642@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49036 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425396AbWLHLHB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 06:07:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     clocksource: increase initcall priority
has been removed from the -mm tree.  Its filename was
     clocksource-increase-initcall-priority.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: clocksource: increase initcall priority
From: Daniel Walker <dwalker@mvista.com>

This patch set is meant to modify the clocksource structure and API so that it
can be used by more than just the timekeeping code.  My motivation is mainly
that I feel the current clocksource interface could be used for much more than
just timekeeping.  So if we keep the clocksource interface (which I think we
should) then we should get everything out of it that we can.

This set modifies the API, then converts the time keeping code over to the new
API.  I also added a generic sched_clock() which just re-uses the clocksource
interface to provide a high quality scheduling clock (assuming a good
clocksource).  Several ARM board just output nanoseconds based on jiffies
which is still possible with the generic sched_clock().


This patch:

Since it's likely that this interface would get used during bootup I moved all
the clocksource registration into the postcore initcall.  This also eliminated
some clocksource shuffling during bootup.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/hpet.c          |    2 +-
 arch/i386/kernel/i8253.c         |    2 +-
 arch/i386/kernel/tsc.c           |    2 +-
 drivers/clocksource/acpi_pm.c    |    2 +-
 drivers/clocksource/cyclone.c    |    2 +-
 drivers/clocksource/scx200_hrt.c |    2 +-
 kernel/time/clocksource.c        |   15 +--------------
 kernel/time/jiffies.c            |    2 +-
 8 files changed, 8 insertions(+), 21 deletions(-)

diff -puN arch/i386/kernel/hpet.c~clocksource-increase-initcall-priority arch/i386/kernel/hpet.c
--- a/arch/i386/kernel/hpet.c~clocksource-increase-initcall-priority
+++ a/arch/i386/kernel/hpet.c
@@ -64,4 +64,4 @@ static int __init init_hpet_clocksource(
 	return clocksource_register(&clocksource_hpet);
 }
 
-module_init(init_hpet_clocksource);
+postcore_initcall(init_hpet_clocksource);
diff -puN arch/i386/kernel/i8253.c~clocksource-increase-initcall-priority arch/i386/kernel/i8253.c
--- a/arch/i386/kernel/i8253.c~clocksource-increase-initcall-priority
+++ a/arch/i386/kernel/i8253.c
@@ -194,4 +194,4 @@ static int __init init_pit_clocksource(v
 	clocksource_pit.mult = clocksource_hz2mult(CLOCK_TICK_RATE, 20);
 	return clocksource_register(&clocksource_pit);
 }
-module_init(init_pit_clocksource);
+postcore_initcall(init_pit_clocksource);
diff -puN arch/i386/kernel/tsc.c~clocksource-increase-initcall-priority arch/i386/kernel/tsc.c
--- a/arch/i386/kernel/tsc.c~clocksource-increase-initcall-priority
+++ a/arch/i386/kernel/tsc.c
@@ -488,4 +488,4 @@ static int __init init_tsc_clocksource(v
 	return 0;
 }
 
-module_init(init_tsc_clocksource);
+postcore_initcall(init_tsc_clocksource);
diff -puN drivers/clocksource/acpi_pm.c~clocksource-increase-initcall-priority drivers/clocksource/acpi_pm.c
--- a/drivers/clocksource/acpi_pm.c~clocksource-increase-initcall-priority
+++ a/drivers/clocksource/acpi_pm.c
@@ -174,4 +174,4 @@ pm_good:
 	return clocksource_register(&clocksource_acpi_pm);
 }
 
-module_init(init_acpi_pm_clocksource);
+postcore_initcall(init_acpi_pm_clocksource);
diff -puN drivers/clocksource/cyclone.c~clocksource-increase-initcall-priority drivers/clocksource/cyclone.c
--- a/drivers/clocksource/cyclone.c~clocksource-increase-initcall-priority
+++ a/drivers/clocksource/cyclone.c
@@ -116,4 +116,4 @@ static int __init init_cyclone_clocksour
 	return clocksource_register(&clocksource_cyclone);
 }
 
-module_init(init_cyclone_clocksource);
+postcore_initcall(init_cyclone_clocksource);
diff -puN drivers/clocksource/scx200_hrt.c~clocksource-increase-initcall-priority drivers/clocksource/scx200_hrt.c
--- a/drivers/clocksource/scx200_hrt.c~clocksource-increase-initcall-priority
+++ a/drivers/clocksource/scx200_hrt.c
@@ -94,7 +94,7 @@ static int __init init_hrt_clocksource(v
 	return clocksource_register(&cs_hrt);
 }
 
-module_init(init_hrt_clocksource);
+postcore_initcall(init_hrt_clocksource);
 
 MODULE_AUTHOR("Jim Cromie <jim.cromie@gmail.com>");
 MODULE_DESCRIPTION("clocksource on SCx200 HiRes Timer");
diff -puN kernel/time/clocksource.c~clocksource-increase-initcall-priority kernel/time/clocksource.c
--- a/kernel/time/clocksource.c~clocksource-increase-initcall-priority
+++ a/kernel/time/clocksource.c
@@ -50,19 +50,6 @@ static struct clocksource *next_clocksou
 static LIST_HEAD(clocksource_list);
 static DEFINE_SPINLOCK(clocksource_lock);
 static char override_name[32];
-static int finished_booting;
-
-/* clocksource_done_booting - Called near the end of bootup
- *
- * Hack to avoid lots of clocksource churn at boot time
- */
-static int __init clocksource_done_booting(void)
-{
-	finished_booting = 1;
-	return 0;
-}
-
-late_initcall(clocksource_done_booting);
 
 /**
  * clocksource_get_next - Returns the selected clocksource
@@ -73,7 +60,7 @@ struct clocksource *clocksource_get_next
 	unsigned long flags;
 
 	spin_lock_irqsave(&clocksource_lock, flags);
-	if (next_clocksource && finished_booting) {
+	if (next_clocksource) {
 		curr_clocksource = next_clocksource;
 		next_clocksource = NULL;
 	}
diff -puN kernel/time/jiffies.c~clocksource-increase-initcall-priority kernel/time/jiffies.c
--- a/kernel/time/jiffies.c~clocksource-increase-initcall-priority
+++ a/kernel/time/jiffies.c
@@ -70,4 +70,4 @@ static int __init init_jiffies_clocksour
 	return clocksource_register(&clocksource_jiffies);
 }
 
-module_init(init_jiffies_clocksource);
+postcore_initcall(init_jiffies_clocksource);
_

Patches currently in -mm which might be from dwalker@mvista.com are

clocksource-add-usage-of-config_sysfs.patch
clocksource-small-cleanup-2.patch
clocksource-small-cleanup-2-fix.patch
clocksource-small-acpi_pm-cleanup.patch
profile-likely-unlikely-macros.patch
profile_likely-export-do_check_likely.patch

