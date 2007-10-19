From: akpm@linux-foundation.org
Subject: - fix-discrepancy-between-vdso-based-gettimeofday-and-sys_gettimeofday.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:41:35 -0700
Message-ID: <200710190341.l9J3fZ7P012832@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47933 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966263AbXJSD5L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:57:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tony@bakeyournoodle.com, ak@suse.de, benh@kernel.crashing.org, johnstul@us.ibm.com, paulus@samba.org, tglx@linutronix.de, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Fix discrepancy between VDSO based gettimeofday() and sys_gettimeofday().
has been removed from the -mm tree.  Its filename was
     fix-discrepancy-between-vdso-based-gettimeofday-and-sys_gettimeofday.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix discrepancy between VDSO based gettimeofday() and sys_gettimeofday().
From: Tony Breeds <tony@bakeyournoodle.com>

On platforms that copy sys_tz into the vdso (currently only x86_64, soon to
include powerpc), it is possible for the vdso to get out of sync if a user
calls (admittedly unusual) settimeofday(NULL, ptr).

This patch adds a hook for architectures that set
CONFIG_GENERIC_TIME_VSYSCALL to ensure when sys_tz is updated they can also
updatee their copy in the vdso.

Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Tony Luck <tony.luck@intel.com>
Acked-by: John Stultz <johnstul@us.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/time.c       |    5 +++++
 arch/x86/kernel/vsyscall_64.c |   11 ++++++++++-
 include/linux/clocksource.h   |    5 +++++
 kernel/time.c                 |    2 ++
 4 files changed, 22 insertions(+), 1 deletion(-)

diff -puN arch/ia64/kernel/time.c~fix-discrepancy-between-vdso-based-gettimeofday-and-sys_gettimeofday arch/ia64/kernel/time.c
--- a/arch/ia64/kernel/time.c~fix-discrepancy-between-vdso-based-gettimeofday-and-sys_gettimeofday
+++ a/arch/ia64/kernel/time.c
@@ -371,6 +371,11 @@ ia64_setup_printk_clock(void)
 		ia64_printk_clock = ia64_itc_printk_clock;
 }
 
+/* IA64 doesn't cache the timezone */
+void update_vsyscall_tz(void)
+{
+}
+
 void update_vsyscall(struct timespec *wall, struct clocksource *c)
 {
         unsigned long flags;
diff -puN arch/x86/kernel/vsyscall_64.c~fix-discrepancy-between-vdso-based-gettimeofday-and-sys_gettimeofday arch/x86/kernel/vsyscall_64.c
--- a/arch/x86/kernel/vsyscall_64.c~fix-discrepancy-between-vdso-based-gettimeofday-and-sys_gettimeofday
+++ a/arch/x86/kernel/vsyscall_64.c
@@ -64,6 +64,16 @@ struct vsyscall_gtod_data __vsyscall_gto
 	.sysctl_enabled = 1,
 };
 
+void update_vsyscall_tz(void)
+{
+	unsigned long flags;
+
+	write_seqlock_irqsave(&vsyscall_gtod_data.lock, flags);
+	/* sys_tz has changed */
+	vsyscall_gtod_data.sys_tz = sys_tz;
+	write_sequnlock_irqrestore(&vsyscall_gtod_data.lock, flags);
+}
+
 void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
 {
 	unsigned long flags;
@@ -77,7 +87,6 @@ void update_vsyscall(struct timespec *wa
 	vsyscall_gtod_data.clock.shift = clock->shift;
 	vsyscall_gtod_data.wall_time_sec = wall_time->tv_sec;
 	vsyscall_gtod_data.wall_time_nsec = wall_time->tv_nsec;
-	vsyscall_gtod_data.sys_tz = sys_tz;
 	vsyscall_gtod_data.wall_to_monotonic = wall_to_monotonic;
 	write_sequnlock_irqrestore(&vsyscall_gtod_data.lock, flags);
 }
diff -puN include/linux/clocksource.h~fix-discrepancy-between-vdso-based-gettimeofday-and-sys_gettimeofday include/linux/clocksource.h
--- a/include/linux/clocksource.h~fix-discrepancy-between-vdso-based-gettimeofday-and-sys_gettimeofday
+++ a/include/linux/clocksource.h
@@ -221,10 +221,15 @@ extern void clocksource_resume(void);
 
 #ifdef CONFIG_GENERIC_TIME_VSYSCALL
 extern void update_vsyscall(struct timespec *ts, struct clocksource *c);
+extern void update_vsyscall_tz(void);
 #else
 static inline void update_vsyscall(struct timespec *ts, struct clocksource *c)
 {
 }
+
+static inline void update_vsyscall_tz(void)
+{
+}
 #endif
 
 #endif /* _LINUX_CLOCKSOURCE_H */
diff -puN kernel/time.c~fix-discrepancy-between-vdso-based-gettimeofday-and-sys_gettimeofday kernel/time.c
--- a/kernel/time.c~fix-discrepancy-between-vdso-based-gettimeofday-and-sys_gettimeofday
+++ a/kernel/time.c
@@ -30,6 +30,7 @@
 #include <linux/module.h>
 #include <linux/timex.h>
 #include <linux/capability.h>
+#include <linux/clocksource.h>
 #include <linux/errno.h>
 #include <linux/syscalls.h>
 #include <linux/security.h>
@@ -158,6 +159,7 @@ int do_sys_settimeofday(struct timespec 
 	if (tz) {
 		/* SMP safe, global irq locking makes it work. */
 		sys_tz = *tz;
+		update_vsyscall_tz();
 		if (firsttime) {
 			firsttime = 0;
 			if (!tv)
_

Patches currently in -mm which might be from tony@bakeyournoodle.com are

origin.patch
