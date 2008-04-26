From: akpm@linux-foundation.org
Subject: - time-close-small-window-for-vsyscall-time-inconsistencies.patch removed from -mm tree
Date: Sat, 26 Apr 2008 09:40:33 -0700
Message-ID: <200804261640.m3QGeX9e031043@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51768 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756394AbYDZQlx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Apr 2008 12:41:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johnstul@us.ibm.com, mingo@elte.hu, paulus@samba.org, tglx@linutronix.de, tony.luck@intel.com, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     time: close small window for vsyscall time inconsistencies
has been removed from the -mm tree.  Its filename was
     time-close-small-window-for-vsyscall-time-inconsistencies.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: time: close small window for vsyscall time inconsistencies
From: john stultz <johnstul@us.ibm.com>

So Thomas and Ingo pointed out to me that they were occasionally seeing small
1ns inconsistencies from clock_gettime() (and more rarely, 1us inconsistencies
from gettimeofday() when the 1ns inconsistency occurred on a us boundary)

Looking over the code, the only possible reason I could find would be from an
interaction with the vsyscall code.

In update_wall_time(), if we read the hardware at time A and start
accumulating time, and adjusting the clocksource frequency, slowing it for
ntp.

Right before we call update_vsyscall(), another processor makes a vsyscall
gettimeofday call, reading the hardware at time B, but using the clocksource
frequency and offsets from pre-time A.

The update_vsyscall then runs, and updates the clocksource frequency with a
slower frequency.

Another processor immediately calls vsyscall gettimeofday, reading the
hardware (lets imagine its very slow hardware) at time B (or very shortly
there after), and then uses the post-time A clocksource frequency which has
been slowed.

Since we're using basically the same hardware value B, but using inconsistency
to occur.

The solution, is to block the vsyscall reads prior to the hardware read at
time A.  Basically synchronizing the vsyscall gettimeofday calls with the
entire update_wall_time function() rather then just the update_vsyscall call.

Since each update_vsyscall is implemented in an arch specific way, we've added
a update_vsyscall_lock/unlock function pair that can be called from arch
generic code.

[akpm@linux-foundation.org: coding=style fixes]
Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/time.c       |   19 ++++++++++++++-----
 arch/powerpc/kernel/time.c    |   23 +++++++++++++++++------
 arch/x86/kernel/vsyscall_64.c |   18 ++++++++++++++----
 include/linux/clocksource.h   |   10 ++++++++++
 kernel/time/timekeeping.c     |    8 +++++++-
 5 files changed, 62 insertions(+), 16 deletions(-)

diff -puN arch/ia64/kernel/time.c~time-close-small-window-for-vsyscall-time-inconsistencies arch/ia64/kernel/time.c
--- a/arch/ia64/kernel/time.c~time-close-small-window-for-vsyscall-time-inconsistencies
+++ a/arch/ia64/kernel/time.c
@@ -349,11 +349,22 @@ void update_vsyscall_tz(void)
 {
 }
 
-void update_vsyscall(struct timespec *wall, struct clocksource *c)
+/* update_vsyscall_lock/unlock:
+ *    methods for timekeeping core to block vsyscalls during update
+ */
+void update_vsyscall_lock(unsigned long *flags)
+{
+	write_seqlock_irqsave(&fsyscall_gtod_data.lock, *flags);
+}
+
+void update_vsyscall_unlock(unsigned long *flags)
 {
-        unsigned long flags;
+	write_sequnlock_irqrestore(&fsyscall_gtod_data.lock, *flags);
+}
 
-        write_seqlock_irqsave(&fsyscall_gtod_data.lock, flags);
+/* Assumes fsyscall_gtod_data.lock has been taken via update_vsyscall_lock() */
+void update_vsyscall(struct timespec *wall, struct clocksource *c)
+{
 
         /* copy fsyscall clock data */
         fsyscall_gtod_data.clk_mask = c->mask;
@@ -375,7 +386,5 @@ void update_vsyscall(struct timespec *wa
 		fsyscall_gtod_data.monotonic_time.tv_nsec -= NSEC_PER_SEC;
 		fsyscall_gtod_data.monotonic_time.tv_sec++;
 	}
-
-        write_sequnlock_irqrestore(&fsyscall_gtod_data.lock, flags);
 }
 
diff -puN arch/powerpc/kernel/time.c~time-close-small-window-for-vsyscall-time-inconsistencies arch/powerpc/kernel/time.c
--- a/arch/powerpc/kernel/time.c~time-close-small-window-for-vsyscall-time-inconsistencies
+++ a/arch/powerpc/kernel/time.c
@@ -456,8 +456,6 @@ static inline void update_gtod(u64 new_t
 	vdso_data->tb_to_xs = new_tb_to_xs;
 	vdso_data->wtom_clock_sec = wall_to_monotonic.tv_sec;
 	vdso_data->wtom_clock_nsec = wall_to_monotonic.tv_nsec;
-	smp_wmb();
-	++(vdso_data->tb_update_count);
 }
 
 #ifdef CONFIG_SMP
@@ -801,6 +799,23 @@ static cycle_t timebase_read(void)
 	return (cycle_t)get_tb();
 }
 
+/* update_vsyscall_lock/unlock:
+ *    methods for timekeeping core to block vsyscalls during update
+ */
+void update_vsyscall_lock(unsigned long *flags)
+{
+	/* Make userspace gettimeofday spin until we're done. */
+	++vdso_data->tb_update_count;
+	smp_mb();
+}
+
+void update_vsyscall_unlock(unsigned long *flags)
+{
+	smp_wmb();
+	++(vdso_data->tb_update_count);
+}
+
+/* Assumes update_vsyscall_lock() has been called */
 void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
 {
 	u64 t2x, stamp_xsec;
@@ -808,10 +823,6 @@ void update_vsyscall(struct timespec *wa
 	if (clock != &clocksource_timebase)
 		return;
 
-	/* Make userspace gettimeofday spin until we're done. */
-	++vdso_data->tb_update_count;
-	smp_mb();
-
 	/* XXX this assumes clock->shift == 22 */
 	/* 4611686018 ~= 2^(20+64-22) / 1e9 */
 	t2x = (u64) clock->mult * 4611686018ULL;
diff -puN arch/x86/kernel/vsyscall_64.c~time-close-small-window-for-vsyscall-time-inconsistencies arch/x86/kernel/vsyscall_64.c
--- a/arch/x86/kernel/vsyscall_64.c~time-close-small-window-for-vsyscall-time-inconsistencies
+++ a/arch/x86/kernel/vsyscall_64.c
@@ -69,11 +69,22 @@ void update_vsyscall_tz(void)
 	write_sequnlock_irqrestore(&vsyscall_gtod_data.lock, flags);
 }
 
-void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
+/* update_vsyscall_lock/unlock:
+ *    methods for timekeeping core to block vsyscalls during update
+ */
+void update_vsyscall_lock(unsigned long *flags)
 {
-	unsigned long flags;
+	write_seqlock_irqsave(&vsyscall_gtod_data.lock, *flags);
+}
 
-	write_seqlock_irqsave(&vsyscall_gtod_data.lock, flags);
+void update_vsyscall_unlock(unsigned long *flags)
+{
+	write_sequnlock_irqrestore(&vsyscall_gtod_data.lock, *flags);
+}
+
+/* Assumes vsyscall_gtod_data.lock has been taken via update_vsyscall_lock() */
+void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
+{
 	/* copy vsyscall data */
 	vsyscall_gtod_data.clock.vread = clock->vread;
 	vsyscall_gtod_data.clock.cycle_last = clock->cycle_last;
@@ -83,7 +94,6 @@ void update_vsyscall(struct timespec *wa
 	vsyscall_gtod_data.wall_time_sec = wall_time->tv_sec;
 	vsyscall_gtod_data.wall_time_nsec = wall_time->tv_nsec;
 	vsyscall_gtod_data.wall_to_monotonic = wall_to_monotonic;
-	write_sequnlock_irqrestore(&vsyscall_gtod_data.lock, flags);
 }
 
 /* RED-PEN may want to readd seq locking, but then the variable should be
diff -puN include/linux/clocksource.h~time-close-small-window-for-vsyscall-time-inconsistencies include/linux/clocksource.h
--- a/include/linux/clocksource.h~time-close-small-window-for-vsyscall-time-inconsistencies
+++ a/include/linux/clocksource.h
@@ -222,9 +222,19 @@ extern void clocksource_change_rating(st
 extern void clocksource_resume(void);
 
 #ifdef CONFIG_GENERIC_TIME_VSYSCALL
+void update_vsyscall_lock(unsigned long *flags);
+void update_vsyscall_unlock(unsigned long *flags);
 extern void update_vsyscall(struct timespec *ts, struct clocksource *c);
 extern void update_vsyscall_tz(void);
 #else
+static inline void update_vsyscall_lock(unsigned long *flags)
+{
+}
+
+static inline void update_vsyscall_unlock(unsigned long *flags)
+{
+}
+
 static inline void update_vsyscall(struct timespec *ts, struct clocksource *c)
 {
 }
diff -puN kernel/time/timekeeping.c~time-close-small-window-for-vsyscall-time-inconsistencies kernel/time/timekeeping.c
--- a/kernel/time/timekeeping.c~time-close-small-window-for-vsyscall-time-inconsistencies
+++ a/kernel/time/timekeeping.c
@@ -129,7 +129,7 @@ EXPORT_SYMBOL(do_gettimeofday);
  */
 int do_settimeofday(struct timespec *tv)
 {
-	unsigned long flags;
+	unsigned long flags, vflags;
 	time_t wtm_sec, sec = tv->tv_sec;
 	long wtm_nsec, nsec = tv->tv_nsec;
 
@@ -137,6 +137,7 @@ int do_settimeofday(struct timespec *tv)
 		return -EINVAL;
 
 	write_seqlock_irqsave(&xtime_lock, flags);
+	update_vsyscall_lock(&vflags);
 
 	nsec -= __get_nsec_offset();
 
@@ -152,6 +153,7 @@ int do_settimeofday(struct timespec *tv)
 
 	update_vsyscall(&xtime, clock);
 
+	update_vsyscall_unlock(&vflags);
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
 	/* signal hrtimers about time change */
@@ -442,12 +444,15 @@ static void clocksource_adjust(s64 offse
  */
 void update_wall_time(void)
 {
+	unsigned long flags;
 	cycle_t offset;
 
 	/* Make sure we're fully resumed: */
 	if (unlikely(timekeeping_suspended))
 		return;
 
+	/* grab the vsyscall lock to block vsyscalls during update */
+	update_vsyscall_lock(&flags);
 #ifdef CONFIG_GENERIC_TIME
 	offset = (clocksource_read(clock) - clock->cycle_last) & clock->mask;
 #else
@@ -487,6 +492,7 @@ void update_wall_time(void)
 	/* check to see if there is a new clocksource to use */
 	change_clocksource();
 	update_vsyscall(&xtime, clock);
+	update_vsyscall_unlock(&flags);
 }
 
 /**
_

Patches currently in -mm which might be from johnstul@us.ibm.com are

git-hrt.patch
proper-extern-for-late_time_init.patch
introduce-explicit-signed-unsigned-64bit-divide.patch
convert-a-few-do_div-user.patch
remove-div_long_long_rem.patch
ntp-cleanup-ntpc.patch
ntp-ntp4-user-space-bits-update.patch
ntp-increase-time_freq-resolution.patch
ntp-increase-time_offset-resolution.patch
ntp-support-for-tai.patch
ntp-rename-tick_length_shift-to-ntp_scale_shift.patch
ntp-remove-current_tick_length.patch
ntp-handle-leap-second-via-timer.patch

