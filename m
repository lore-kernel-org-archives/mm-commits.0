From: akpm@linux-foundation.org
Subject: - generic-vsyscall-gtod-support-for-generic_time.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:15:29 -0800
Message-ID: <200702170715.l1H7FTVD021631@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51503 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946606AbXBQHYP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:24:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johnstul@us.ibm.com, ak@muc.de, mingo@elte.hu, tglx@linutronix.de, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     generic: vsyscall-gtod support for GENERIC_TIME
has been removed from the -mm tree.  Its filename was
     generic-vsyscall-gtod-support-for-generic_time.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: generic: vsyscall-gtod support for GENERIC_TIME
From: john stultz <johnstul@us.ibm.com>

Provides generic infrastructure for vsyscall-gtod.

[akpm@osdl.org: cleanup]
Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@muc.de>
Cc: Roman Zippel <zippel@linux-m68k.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/clocksource.h |   10 ++++++++++
 kernel/timer.c              |    1 +
 2 files changed, 11 insertions(+)

diff -puN include/linux/clocksource.h~generic-vsyscall-gtod-support-for-generic_time include/linux/clocksource.h
--- a/include/linux/clocksource.h~generic-vsyscall-gtod-support-for-generic_time
+++ a/include/linux/clocksource.h
@@ -47,6 +47,7 @@ struct clocksource;
  * @mult:		cycle to nanosecond multiplier
  * @shift:		cycle to nanosecond divisor (power of two)
  * @flags:		flags describing special properties
+ * @vread:		vsyscall based read
  * @cycle_interval:	Used internally by timekeeping core, please ignore.
  * @xtime_interval:	Used internally by timekeeping core, please ignore.
  */
@@ -59,6 +60,7 @@ struct clocksource {
 	u32 mult;
 	u32 shift;
 	unsigned long flags;
+	cycle_t (*vread)(void);
 
 	/* timekeeping specific data, ignore */
 	cycle_t cycle_last, cycle_interval;
@@ -197,4 +199,12 @@ extern int clocksource_register(struct c
 extern struct clocksource* clocksource_get_next(void);
 extern void clocksource_change_rating(struct clocksource *cs, int rating);
 
+#ifdef CONFIG_GENERIC_TIME_VSYSCALL
+extern void update_vsyscall(struct timespec *ts, struct clocksource *c);
+#else
+static inline void update_vsyscall(struct timespec *ts, struct clocksource *c)
+{
+}
+#endif
+
 #endif /* _LINUX_CLOCKSOURCE_H */
diff -puN kernel/timer.c~generic-vsyscall-gtod-support-for-generic_time kernel/timer.c
--- a/kernel/timer.c~generic-vsyscall-gtod-support-for-generic_time
+++ a/kernel/timer.c
@@ -1174,6 +1174,7 @@ static void update_wall_time(void)
 
 	/* check to see if there is a new clocksource to use */
 	change_clocksource();
+	update_vsyscall(&xtime, clock);
 }
 
 /*
_

Patches currently in -mm which might be from johnstul@us.ibm.com are

origin.patch
git-acpi.patch
profile-likely-unlikely-macros-x86_64-fix.patch
