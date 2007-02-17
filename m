From: akpm@linux-foundation.org
Subject: - uninline-jiffiesh-functions.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:13:28 -0800
Message-ID: <200702170713.l1H7DSdD021457@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51260 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946561AbXBQHR5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:17:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, jeremy@goop.org, johnstul@us.ibm.com, tglx@linutronix.de, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Uninline jiffies.h functions
has been removed from the -mm tree.  Its filename was
     uninline-jiffiesh-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Uninline jiffies.h functions
From: Ingo Molnar <mingo@elte.hu>

There are loads of fat functions hidden in jiffies.h.  Uninline them.  No code
changes.

[jeremy@goop.org: export fix]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/jiffies.h |  216 ++------------------------------------
 kernel/time.c           |  213 +++++++++++++++++++++++++++++++++++++
 2 files changed, 229 insertions(+), 200 deletions(-)

diff -puN include/linux/jiffies.h~uninline-jiffiesh-functions include/linux/jiffies.h
--- a/include/linux/jiffies.h~uninline-jiffiesh-functions
+++ a/include/linux/jiffies.h
@@ -259,207 +259,23 @@ static inline u64 get_jiffies_64(void)
 #endif
 
 /*
- * Convert jiffies to milliseconds and back.
- *
- * Avoid unnecessary multiplications/divisions in the
- * two most common HZ cases:
+ * Convert various time units to each other:
  */
-static inline unsigned int jiffies_to_msecs(const unsigned long j)
-{
-#if HZ <= MSEC_PER_SEC && !(MSEC_PER_SEC % HZ)
-	return (MSEC_PER_SEC / HZ) * j;
-#elif HZ > MSEC_PER_SEC && !(HZ % MSEC_PER_SEC)
-	return (j + (HZ / MSEC_PER_SEC) - 1)/(HZ / MSEC_PER_SEC);
-#else
-	return (j * MSEC_PER_SEC) / HZ;
-#endif
-}
-
-static inline unsigned int jiffies_to_usecs(const unsigned long j)
-{
-#if HZ <= USEC_PER_SEC && !(USEC_PER_SEC % HZ)
-	return (USEC_PER_SEC / HZ) * j;
-#elif HZ > USEC_PER_SEC && !(HZ % USEC_PER_SEC)
-	return (j + (HZ / USEC_PER_SEC) - 1)/(HZ / USEC_PER_SEC);
-#else
-	return (j * USEC_PER_SEC) / HZ;
-#endif
-}
-
-static inline unsigned long msecs_to_jiffies(const unsigned int m)
-{
-	if (m > jiffies_to_msecs(MAX_JIFFY_OFFSET))
-		return MAX_JIFFY_OFFSET;
-#if HZ <= MSEC_PER_SEC && !(MSEC_PER_SEC % HZ)
-	return (m + (MSEC_PER_SEC / HZ) - 1) / (MSEC_PER_SEC / HZ);
-#elif HZ > MSEC_PER_SEC && !(HZ % MSEC_PER_SEC)
-	return m * (HZ / MSEC_PER_SEC);
-#else
-	return (m * HZ + MSEC_PER_SEC - 1) / MSEC_PER_SEC;
-#endif
-}
-
-static inline unsigned long usecs_to_jiffies(const unsigned int u)
-{
-	if (u > jiffies_to_usecs(MAX_JIFFY_OFFSET))
-		return MAX_JIFFY_OFFSET;
-#if HZ <= USEC_PER_SEC && !(USEC_PER_SEC % HZ)
-	return (u + (USEC_PER_SEC / HZ) - 1) / (USEC_PER_SEC / HZ);
-#elif HZ > USEC_PER_SEC && !(HZ % USEC_PER_SEC)
-	return u * (HZ / USEC_PER_SEC);
-#else
-	return (u * HZ + USEC_PER_SEC - 1) / USEC_PER_SEC;
-#endif
-}
-
-/*
- * The TICK_NSEC - 1 rounds up the value to the next resolution.  Note
- * that a remainder subtract here would not do the right thing as the
- * resolution values don't fall on second boundries.  I.e. the line:
- * nsec -= nsec % TICK_NSEC; is NOT a correct resolution rounding.
- *
- * Rather, we just shift the bits off the right.
- *
- * The >> (NSEC_JIFFIE_SC - SEC_JIFFIE_SC) converts the scaled nsec
- * value to a scaled second value.
- */
-static __inline__ unsigned long
-timespec_to_jiffies(const struct timespec *value)
-{
-	unsigned long sec = value->tv_sec;
-	long nsec = value->tv_nsec + TICK_NSEC - 1;
-
-	if (sec >= MAX_SEC_IN_JIFFIES){
-		sec = MAX_SEC_IN_JIFFIES;
-		nsec = 0;
-	}
-	return (((u64)sec * SEC_CONVERSION) +
-		(((u64)nsec * NSEC_CONVERSION) >>
-		 (NSEC_JIFFIE_SC - SEC_JIFFIE_SC))) >> SEC_JIFFIE_SC;
-
-}
-
-static __inline__ void
-jiffies_to_timespec(const unsigned long jiffies, struct timespec *value)
-{
-	/*
-	 * Convert jiffies to nanoseconds and separate with
-	 * one divide.
-	 */
-	u64 nsec = (u64)jiffies * TICK_NSEC;
-	value->tv_sec = div_long_long_rem(nsec, NSEC_PER_SEC, &value->tv_nsec);
-}
-
-/* Same for "timeval"
- *
- * Well, almost.  The problem here is that the real system resolution is
- * in nanoseconds and the value being converted is in micro seconds.
- * Also for some machines (those that use HZ = 1024, in-particular),
- * there is a LARGE error in the tick size in microseconds.
-
- * The solution we use is to do the rounding AFTER we convert the
- * microsecond part.  Thus the USEC_ROUND, the bits to be shifted off.
- * Instruction wise, this should cost only an additional add with carry
- * instruction above the way it was done above.
- */
-static __inline__ unsigned long
-timeval_to_jiffies(const struct timeval *value)
-{
-	unsigned long sec = value->tv_sec;
-	long usec = value->tv_usec;
-
-	if (sec >= MAX_SEC_IN_JIFFIES){
-		sec = MAX_SEC_IN_JIFFIES;
-		usec = 0;
-	}
-	return (((u64)sec * SEC_CONVERSION) +
-		(((u64)usec * USEC_CONVERSION + USEC_ROUND) >>
-		 (USEC_JIFFIE_SC - SEC_JIFFIE_SC))) >> SEC_JIFFIE_SC;
-}
-
-static __inline__ void
-jiffies_to_timeval(const unsigned long jiffies, struct timeval *value)
-{
-	/*
-	 * Convert jiffies to nanoseconds and separate with
-	 * one divide.
-	 */
-	u64 nsec = (u64)jiffies * TICK_NSEC;
-	long tv_usec;
-
-	value->tv_sec = div_long_long_rem(nsec, NSEC_PER_SEC, &tv_usec);
-	tv_usec /= NSEC_PER_USEC;
-	value->tv_usec = tv_usec;
-}
-
-/*
- * Convert jiffies/jiffies_64 to clock_t and back.
- */
-static inline clock_t jiffies_to_clock_t(long x)
-{
-#if (TICK_NSEC % (NSEC_PER_SEC / USER_HZ)) == 0
-	return x / (HZ / USER_HZ);
-#else
-	u64 tmp = (u64)x * TICK_NSEC;
-	do_div(tmp, (NSEC_PER_SEC / USER_HZ));
-	return (long)tmp;
-#endif
-}
+extern unsigned int jiffies_to_msecs(const unsigned long j);
+extern unsigned int jiffies_to_usecs(const unsigned long j);
+extern unsigned long msecs_to_jiffies(const unsigned int m);
+extern unsigned long usecs_to_jiffies(const unsigned int u);
+extern unsigned long timespec_to_jiffies(const struct timespec *value);
+extern void jiffies_to_timespec(const unsigned long jiffies,
+				struct timespec *value);
+extern unsigned long timeval_to_jiffies(const struct timeval *value);
+extern void jiffies_to_timeval(const unsigned long jiffies,
+			       struct timeval *value);
+extern clock_t jiffies_to_clock_t(long x);
+extern unsigned long clock_t_to_jiffies(unsigned long x);
+extern u64 jiffies_64_to_clock_t(u64 x);
+extern u64 nsec_to_clock_t(u64 x);
 
-static inline unsigned long clock_t_to_jiffies(unsigned long x)
-{
-#if (HZ % USER_HZ)==0
-	if (x >= ~0UL / (HZ / USER_HZ))
-		return ~0UL;
-	return x * (HZ / USER_HZ);
-#else
-	u64 jif;
-
-	/* Don't worry about loss of precision here .. */
-	if (x >= ~0UL / HZ * USER_HZ)
-		return ~0UL;
-
-	/* .. but do try to contain it here */
-	jif = x * (u64) HZ;
-	do_div(jif, USER_HZ);
-	return jif;
-#endif
-}
-
-static inline u64 jiffies_64_to_clock_t(u64 x)
-{
-#if (TICK_NSEC % (NSEC_PER_SEC / USER_HZ)) == 0
-	do_div(x, HZ / USER_HZ);
-#else
-	/*
-	 * There are better ways that don't overflow early,
-	 * but even this doesn't overflow in hundreds of years
-	 * in 64 bits, so..
-	 */
-	x *= TICK_NSEC;
-	do_div(x, (NSEC_PER_SEC / USER_HZ));
-#endif
-	return x;
-}
-
-static inline u64 nsec_to_clock_t(u64 x)
-{
-#if (NSEC_PER_SEC % USER_HZ) == 0
-	do_div(x, (NSEC_PER_SEC / USER_HZ));
-#elif (USER_HZ % 512) == 0
-	x *= USER_HZ/512;
-	do_div(x, (NSEC_PER_SEC / 512));
-#else
-	/*
-         * max relative error 5.7e-8 (1.8s per year) for USER_HZ <= 1024,
-         * overflow after 64.99 years.
-         * exact for HZ=60, 72, 90, 120, 144, 180, 300, 600, 900, ...
-         */
-	x *= 9;
-	do_div(x, (unsigned long)((9ull * NSEC_PER_SEC + (USER_HZ/2))
-	                          / USER_HZ));
-#endif
-	return x;
-}
+#define TIMESTAMP_SIZE	30
 
 #endif
diff -puN kernel/time.c~uninline-jiffiesh-functions kernel/time.c
--- a/kernel/time.c~uninline-jiffiesh-functions
+++ a/kernel/time.c
@@ -470,6 +470,219 @@ struct timeval ns_to_timeval(const s64 n
 	return tv;
 }
 
+/*
+ * Convert jiffies to milliseconds and back.
+ *
+ * Avoid unnecessary multiplications/divisions in the
+ * two most common HZ cases:
+ */
+unsigned int jiffies_to_msecs(const unsigned long j)
+{
+#if HZ <= MSEC_PER_SEC && !(MSEC_PER_SEC % HZ)
+	return (MSEC_PER_SEC / HZ) * j;
+#elif HZ > MSEC_PER_SEC && !(HZ % MSEC_PER_SEC)
+	return (j + (HZ / MSEC_PER_SEC) - 1)/(HZ / MSEC_PER_SEC);
+#else
+	return (j * MSEC_PER_SEC) / HZ;
+#endif
+}
+EXPORT_SYMBOL(jiffies_to_msecs);
+
+unsigned int jiffies_to_usecs(const unsigned long j)
+{
+#if HZ <= USEC_PER_SEC && !(USEC_PER_SEC % HZ)
+	return (USEC_PER_SEC / HZ) * j;
+#elif HZ > USEC_PER_SEC && !(HZ % USEC_PER_SEC)
+	return (j + (HZ / USEC_PER_SEC) - 1)/(HZ / USEC_PER_SEC);
+#else
+	return (j * USEC_PER_SEC) / HZ;
+#endif
+}
+EXPORT_SYMBOL(jiffies_to_usecs);
+
+unsigned long msecs_to_jiffies(const unsigned int m)
+{
+	if (m > jiffies_to_msecs(MAX_JIFFY_OFFSET))
+		return MAX_JIFFY_OFFSET;
+#if HZ <= MSEC_PER_SEC && !(MSEC_PER_SEC % HZ)
+	return (m + (MSEC_PER_SEC / HZ) - 1) / (MSEC_PER_SEC / HZ);
+#elif HZ > MSEC_PER_SEC && !(HZ % MSEC_PER_SEC)
+	return m * (HZ / MSEC_PER_SEC);
+#else
+	return (m * HZ + MSEC_PER_SEC - 1) / MSEC_PER_SEC;
+#endif
+}
+EXPORT_SYMBOL(msecs_to_jiffies);
+
+unsigned long usecs_to_jiffies(const unsigned int u)
+{
+	if (u > jiffies_to_usecs(MAX_JIFFY_OFFSET))
+		return MAX_JIFFY_OFFSET;
+#if HZ <= USEC_PER_SEC && !(USEC_PER_SEC % HZ)
+	return (u + (USEC_PER_SEC / HZ) - 1) / (USEC_PER_SEC / HZ);
+#elif HZ > USEC_PER_SEC && !(HZ % USEC_PER_SEC)
+	return u * (HZ / USEC_PER_SEC);
+#else
+	return (u * HZ + USEC_PER_SEC - 1) / USEC_PER_SEC;
+#endif
+}
+EXPORT_SYMBOL(usecs_to_jiffies);
+
+/*
+ * The TICK_NSEC - 1 rounds up the value to the next resolution.  Note
+ * that a remainder subtract here would not do the right thing as the
+ * resolution values don't fall on second boundries.  I.e. the line:
+ * nsec -= nsec % TICK_NSEC; is NOT a correct resolution rounding.
+ *
+ * Rather, we just shift the bits off the right.
+ *
+ * The >> (NSEC_JIFFIE_SC - SEC_JIFFIE_SC) converts the scaled nsec
+ * value to a scaled second value.
+ */
+unsigned long
+timespec_to_jiffies(const struct timespec *value)
+{
+	unsigned long sec = value->tv_sec;
+	long nsec = value->tv_nsec + TICK_NSEC - 1;
+
+	if (sec >= MAX_SEC_IN_JIFFIES){
+		sec = MAX_SEC_IN_JIFFIES;
+		nsec = 0;
+	}
+	return (((u64)sec * SEC_CONVERSION) +
+		(((u64)nsec * NSEC_CONVERSION) >>
+		 (NSEC_JIFFIE_SC - SEC_JIFFIE_SC))) >> SEC_JIFFIE_SC;
+
+}
+EXPORT_SYMBOL(timespec_to_jiffies);
+
+void
+jiffies_to_timespec(const unsigned long jiffies, struct timespec *value)
+{
+	/*
+	 * Convert jiffies to nanoseconds and separate with
+	 * one divide.
+	 */
+	u64 nsec = (u64)jiffies * TICK_NSEC;
+	value->tv_sec = div_long_long_rem(nsec, NSEC_PER_SEC, &value->tv_nsec);
+}
+EXPORT_SYMBOL(jiffies_to_timespec);
+
+/* Same for "timeval"
+ *
+ * Well, almost.  The problem here is that the real system resolution is
+ * in nanoseconds and the value being converted is in micro seconds.
+ * Also for some machines (those that use HZ = 1024, in-particular),
+ * there is a LARGE error in the tick size in microseconds.
+
+ * The solution we use is to do the rounding AFTER we convert the
+ * microsecond part.  Thus the USEC_ROUND, the bits to be shifted off.
+ * Instruction wise, this should cost only an additional add with carry
+ * instruction above the way it was done above.
+ */
+unsigned long
+timeval_to_jiffies(const struct timeval *value)
+{
+	unsigned long sec = value->tv_sec;
+	long usec = value->tv_usec;
+
+	if (sec >= MAX_SEC_IN_JIFFIES){
+		sec = MAX_SEC_IN_JIFFIES;
+		usec = 0;
+	}
+	return (((u64)sec * SEC_CONVERSION) +
+		(((u64)usec * USEC_CONVERSION + USEC_ROUND) >>
+		 (USEC_JIFFIE_SC - SEC_JIFFIE_SC))) >> SEC_JIFFIE_SC;
+}
+
+void jiffies_to_timeval(const unsigned long jiffies, struct timeval *value)
+{
+	/*
+	 * Convert jiffies to nanoseconds and separate with
+	 * one divide.
+	 */
+	u64 nsec = (u64)jiffies * TICK_NSEC;
+	long tv_usec;
+
+	value->tv_sec = div_long_long_rem(nsec, NSEC_PER_SEC, &tv_usec);
+	tv_usec /= NSEC_PER_USEC;
+	value->tv_usec = tv_usec;
+}
+
+/*
+ * Convert jiffies/jiffies_64 to clock_t and back.
+ */
+clock_t jiffies_to_clock_t(long x)
+{
+#if (TICK_NSEC % (NSEC_PER_SEC / USER_HZ)) == 0
+	return x / (HZ / USER_HZ);
+#else
+	u64 tmp = (u64)x * TICK_NSEC;
+	do_div(tmp, (NSEC_PER_SEC / USER_HZ));
+	return (long)tmp;
+#endif
+}
+EXPORT_SYMBOL(jiffies_to_clock_t);
+
+unsigned long clock_t_to_jiffies(unsigned long x)
+{
+#if (HZ % USER_HZ)==0
+	if (x >= ~0UL / (HZ / USER_HZ))
+		return ~0UL;
+	return x * (HZ / USER_HZ);
+#else
+	u64 jif;
+
+	/* Don't worry about loss of precision here .. */
+	if (x >= ~0UL / HZ * USER_HZ)
+		return ~0UL;
+
+	/* .. but do try to contain it here */
+	jif = x * (u64) HZ;
+	do_div(jif, USER_HZ);
+	return jif;
+#endif
+}
+EXPORT_SYMBOL(clock_t_to_jiffies);
+
+u64 jiffies_64_to_clock_t(u64 x)
+{
+#if (TICK_NSEC % (NSEC_PER_SEC / USER_HZ)) == 0
+	do_div(x, HZ / USER_HZ);
+#else
+	/*
+	 * There are better ways that don't overflow early,
+	 * but even this doesn't overflow in hundreds of years
+	 * in 64 bits, so..
+	 */
+	x *= TICK_NSEC;
+	do_div(x, (NSEC_PER_SEC / USER_HZ));
+#endif
+	return x;
+}
+
+EXPORT_SYMBOL(jiffies_64_to_clock_t);
+
+u64 nsec_to_clock_t(u64 x)
+{
+#if (NSEC_PER_SEC % USER_HZ) == 0
+	do_div(x, (NSEC_PER_SEC / USER_HZ));
+#elif (USER_HZ % 512) == 0
+	x *= USER_HZ/512;
+	do_div(x, (NSEC_PER_SEC / 512));
+#else
+	/*
+         * max relative error 5.7e-8 (1.8s per year) for USER_HZ <= 1024,
+         * overflow after 64.99 years.
+         * exact for HZ=60, 72, 90, 120, 144, 180, 300, 600, 900, ...
+         */
+	x *= 9;
+	do_div(x, (unsigned long)((9ull * NSEC_PER_SEC + (USER_HZ/2)) /
+				  USER_HZ));
+#endif
+	return x;
+}
+
 #if (BITS_PER_LONG < 64)
 u64 get_jiffies_64(void)
 {
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
git-acpi.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch.patch
spin_lock_irq-enable-interrupts-while-spinning-x86_64-implementation.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
simplify-the-stacktrace-code.patch
lockdep-debug_locks-check-after-check_chain_key.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
softlockup-trivial-s-99-max_rt_prio.patch
schedule_on_each_cpu-use-preempt_disable.patch
workqueue-kill-run_scheduled_work.patch
workqueue-dont-save-interrupts-in-run_workqueue.patch
workqueue-make-cancel_rearming_delayed_workqueue-work-on-idle-dwork.patch
workqueue-introduce-cpu_singlethread_map.patch
workqueue-introduce-workqueue_struct-singlethread.patch
workqueue-make-init_workqueues-__init.patch
fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine.patch
fsaio-rename-__lock_page-to-lock_page_blocking.patch
fsaio-interfaces-to-initialize-and-to-test-a-wait-bit-key.patch
fsaio-add-a-default-io-wait-bit-field-in-task-struct.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio.patch
fsaio-enable-asynchronous-wait-page-and-lock-page.patch
fsaio-filesystem-aio-read.patch
fsaio-aio-o_sync-filesystem-write.patch
aio-is-unlikely.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
sched-cleanup-remove-task_t-convert-to-struct-task_struct-prefetch.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-3.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
vdso-print-fatal-signals.patch
vdso-improve-print_fatal_signals-support-by-adding-memory-maps.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
lockdep-show-held-locks-when-showing-a-stackdump-fix.patch
lockdep-show-held-locks-when-showing-a-stackdump-fix-2.patch
kmap_atomic-debugging.patch
