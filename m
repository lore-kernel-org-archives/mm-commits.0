From: akpm@osdl.org
Subject: - clocksource-small-cleanup-2.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:55:40 -0800
Message-ID: <200612130655.kBD6teEs030664@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58667 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932401AbWLMHGb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 02:06:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     clocksource: small cleanup
has been removed from the -mm tree.  Its filename was
     clocksource-small-cleanup-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: clocksource: small cleanup
From: Daniel Walker <dwalker@mvista.com>

Mostly changing alignment.  Just some general cleanup.

[akpm@osdl.org: build fix]
Signed-off-by: Daniel Walker <dwalker@mvista.com>
Acked-by: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/clocksource/acpi_pm.c |    6 +++---
 include/linux/clocksource.h   |    2 +-
 kernel/time/clocksource.c     |    6 +++---
 kernel/timer.c                |   16 +++++++++++-----
 4 files changed, 18 insertions(+), 12 deletions(-)

diff -puN drivers/clocksource/acpi_pm.c~clocksource-small-cleanup-2 drivers/clocksource/acpi_pm.c
--- a/drivers/clocksource/acpi_pm.c~clocksource-small-cleanup-2
+++ a/drivers/clocksource/acpi_pm.c
@@ -77,11 +77,11 @@ static struct clocksource clocksource_ac
 
 
 #ifdef CONFIG_PCI
-static int acpi_pm_good;
+static int __devinitdata acpi_pm_good;
 static int __init acpi_pm_good_setup(char *__str)
 {
-       acpi_pm_good = 1;
-       return 1;
+	acpi_pm_good = 1;
+	return 1;
 }
 __setup("acpi_pm_good", acpi_pm_good_setup);
 
diff -puN include/linux/clocksource.h~clocksource-small-cleanup-2 include/linux/clocksource.h
--- a/include/linux/clocksource.h~clocksource-small-cleanup-2
+++ a/include/linux/clocksource.h
@@ -159,7 +159,7 @@ static inline s64 cyc2ns(struct clocksou
  * Unless you're the timekeeping code, you should not be using this!
  */
 static inline void clocksource_calculate_interval(struct clocksource *c,
-						unsigned long length_nsec)
+					  	  unsigned long length_nsec)
 {
 	u64 tmp;
 
diff -puN kernel/time/clocksource.c~clocksource-small-cleanup-2 kernel/time/clocksource.c
--- a/kernel/time/clocksource.c~clocksource-small-cleanup-2
+++ a/kernel/time/clocksource.c
@@ -156,7 +156,7 @@ int clocksource_register(struct clocksou
 	/* check if clocksource is already registered */
 	if (is_registered_source(c)) {
 		printk("register_clocksource: Cannot register %s. "
-			"Already registered!", c->name);
+		       "Already registered!", c->name);
 		ret = -EBUSY;
 	} else {
 		/* register it */
@@ -276,10 +276,10 @@ sysfs_show_available_clocksources(struct
  * Sysfs setup bits:
  */
 static SYSDEV_ATTR(current_clocksource, 0600, sysfs_show_current_clocksources,
-			sysfs_override_clocksource);
+		   sysfs_override_clocksource);
 
 static SYSDEV_ATTR(available_clocksource, 0600,
-			sysfs_show_available_clocksources, NULL);
+		   sysfs_show_available_clocksources, NULL);
 
 static struct sysdev_class clocksource_sysclass = {
 	set_kset_name("clocksource"),
diff -puN kernel/timer.c~clocksource-small-cleanup-2 kernel/timer.c
--- a/kernel/timer.c~clocksource-small-cleanup-2
+++ a/kernel/timer.c
@@ -846,7 +846,7 @@ static int change_clocksource(void)
 		clock = new;
 		clock->cycle_last = now;
 		printk(KERN_INFO "Time: %s clocksource has been installed.\n",
-					clock->name);
+		       clock->name);
 		return 1;
 	} else if (clock->update_callback) {
 		return clock->update_callback();
@@ -854,7 +854,10 @@ static int change_clocksource(void)
 	return 0;
 }
 #else
-#define change_clocksource() (0)
+static inline int change_clocksource(void)
+{
+	return 0;
+}
 #endif
 
 /**
@@ -952,7 +955,8 @@ device_initcall(timekeeping_init_device)
  * If the error is already larger, we look ahead even further
  * to compensate for late or lost adjustments.
  */
-static __always_inline int clocksource_bigadjust(s64 error, s64 *interval, s64 *offset)
+static __always_inline int clocksource_bigadjust(s64 error, s64 *interval,
+						 s64 *offset)
 {
 	s64 tick_error, i;
 	u32 look_ahead, adj;
@@ -976,7 +980,8 @@ static __always_inline int clocksource_b
 	 * Now calculate the error in (1 << look_ahead) ticks, but first
 	 * remove the single look ahead already included in the error.
 	 */
-	tick_error = current_tick_length() >> (TICK_LENGTH_SHIFT - clock->shift + 1);
+	tick_error = current_tick_length() >>
+		(TICK_LENGTH_SHIFT - clock->shift + 1);
 	tick_error -= clock->xtime_interval >> 1;
 	error = ((error - tick_error) >> look_ahead) + tick_error;
 
@@ -1028,7 +1033,8 @@ static void clocksource_adjust(struct cl
 	clock->mult += adj;
 	clock->xtime_interval += interval;
 	clock->xtime_nsec -= offset;
-	clock->error -= (interval - offset) << (TICK_LENGTH_SHIFT - clock->shift);
+	clock->error -= (interval - offset) <<
+			(TICK_LENGTH_SHIFT - clock->shift);
 }
 
 /**
_

Patches currently in -mm which might be from dwalker@mvista.com are

origin.patch
profile-likely-unlikely-macros.patch
profile_likely-export-do_check_likely.patch
profile-likely-unlikely-macros_remove-likely-profiling-int-cast.patch

