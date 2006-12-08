From: akpm@osdl.org
Subject: - clocksource-small-cleanup.patch removed from -mm tree
Date: Fri, 08 Dec 2006 03:05:31 -0800
Message-ID: <200612081105.kB8B5V6b018645@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:48940 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425386AbWLHLG2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 06:06:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     clocksource: small cleanup
has been removed from the -mm tree.  Its filename was
     clocksource-small-cleanup.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: clocksource: small cleanup
From: Daniel Walker <dwalker@mvista.com>

Mostly changing alignment. Just some general cleanup.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Acked-by: John Stultz <johnstul@us.ibm.com>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/clocksource.h |    2 +-
 kernel/time/clocksource.c   |    6 +++---
 kernel/timer.c              |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff -puN include/linux/clocksource.h~clocksource-small-cleanup include/linux/clocksource.h
--- a/include/linux/clocksource.h~clocksource-small-cleanup
+++ a/include/linux/clocksource.h
@@ -159,7 +159,7 @@ static inline s64 cyc2ns(struct clocksou
  * Unless you're the timekeeping code, you should not be using this!
  */
 static inline void clocksource_calculate_interval(struct clocksource *c,
-						unsigned long length_nsec)
+					  	  unsigned long length_nsec)
 {
 	u64 tmp;
 
diff -puN kernel/time/clocksource.c~clocksource-small-cleanup kernel/time/clocksource.c
--- a/kernel/time/clocksource.c~clocksource-small-cleanup
+++ a/kernel/time/clocksource.c
@@ -143,7 +143,7 @@ int clocksource_register(struct clocksou
 	/* check if clocksource is already registered */
 	if (is_registered_source(c)) {
 		printk("register_clocksource: Cannot register %s. "
-			"Already registered!", c->name);
+		       "Already registered!", c->name);
 		ret = -EBUSY;
 	} else {
 		/* register it */
@@ -262,10 +262,10 @@ sysfs_show_available_clocksources(struct
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
diff -puN kernel/timer.c~clocksource-small-cleanup kernel/timer.c
--- a/kernel/timer.c~clocksource-small-cleanup
+++ a/kernel/timer.c
@@ -786,7 +786,7 @@ static int change_clocksource(void)
 		clock = new;
 		clock->cycle_last = now;
 		printk(KERN_INFO "Time: %s clocksource has been installed.\n",
-					clock->name);
+		       clock->name);
 		return 1;
 	} else if (clock->update_callback) {
 		return clock->update_callback();
@@ -794,7 +794,7 @@ static int change_clocksource(void)
 	return 0;
 }
 #else
-#define change_clocksource() (0)
+#define change_clocksource()	do { 0; } while(0)
 #endif
 
 /**
_

Patches currently in -mm which might be from dwalker@mvista.com are

clocksource-add-usage-of-config_sysfs.patch
clocksource-small-cleanup-2.patch
clocksource-small-cleanup-2-fix.patch
clocksource-small-acpi_pm-cleanup.patch
profile-likely-unlikely-macros.patch
profile_likely-export-do_check_likely.patch

