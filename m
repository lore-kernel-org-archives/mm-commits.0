From: akpm@osdl.org
Subject: - round_jiffies-infrastructure.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:55:32 -0800
Message-ID: <200612130655.kBD6tWlj030649@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57818 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965026AbWLMGzo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:55:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@linux.intel.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     round_jiffies infrastructure
has been removed from the -mm tree.  Its filename was
     round_jiffies-infrastructure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: round_jiffies infrastructure
From: Arjan van de Ven <arjan@linux.intel.com>

Introduce a round_jiffies() function as well as a round_jiffies_relative()
function.  These functions round a jiffies value to the next whole second. 
The primary purpose of this rounding is to cause all "we don't care exactly
when" timers to happen at the same jiffy.

This avoids multiple timers firing within the second for no real reason;
with dynamic ticks these extra timers cause wakeups from deep sleep CPU
sleep states and thus waste power.

The exact wakeup moment is skewed by the cpu number, to avoid all cpus from
waking up at the exact same time (and hitting the same lock/cachelines
there)

[akpm@osdl.org: fix variable type]
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/timer.h |    6 +
 kernel/timer.c        |  132 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 138 insertions(+)

diff -puN include/linux/timer.h~round_jiffies-infrastructure include/linux/timer.h
--- a/include/linux/timer.h~round_jiffies-infrastructure
+++ a/include/linux/timer.h
@@ -98,4 +98,10 @@ extern void run_local_timers(void);
 struct hrtimer;
 extern int it_real_fn(struct hrtimer *);
 
+unsigned long __round_jiffies(unsigned long j, int cpu);
+unsigned long __round_jiffies_relative(unsigned long j, int cpu);
+unsigned long round_jiffies(unsigned long j);
+unsigned long round_jiffies_relative(unsigned long j);
+
+
 #endif
diff -puN kernel/timer.c~round_jiffies-infrastructure kernel/timer.c
--- a/kernel/timer.c~round_jiffies-infrastructure
+++ a/kernel/timer.c
@@ -80,6 +80,138 @@ tvec_base_t boot_tvec_bases;
 EXPORT_SYMBOL(boot_tvec_bases);
 static DEFINE_PER_CPU(tvec_base_t *, tvec_bases) = &boot_tvec_bases;
 
+/**
+ * __round_jiffies - function to round jiffies to a full second
+ * @j: the time in (absolute) jiffies that should be rounded
+ * @cpu: the processor number on which the timeout will happen
+ *
+ * __round_jiffies rounds an absolute time in the future (in jiffies)
+ * up or down to (approximately) full seconds. This is useful for timers
+ * for which the exact time they fire does not matter too much, as long as
+ * they fire approximately every X seconds.
+ *
+ * By rounding these timers to whole seconds, all such timers will fire
+ * at the same time, rather than at various times spread out. The goal
+ * of this is to have the CPU wake up less, which saves power.
+ *
+ * The exact rounding is skewed for each processor to avoid all
+ * processors firing at the exact same time, which could lead
+ * to lock contention or spurious cache line bouncing.
+ *
+ * The return value is the rounded version of the "j" parameter.
+ */
+unsigned long __round_jiffies(unsigned long j, int cpu)
+{
+	int rem;
+	unsigned long original = j;
+
+	/*
+	 * We don't want all cpus firing their timers at once hitting the
+	 * same lock or cachelines, so we skew each extra cpu with an extra
+	 * 3 jiffies. This 3 jiffies came originally from the mm/ code which
+	 * already did this.
+	 * The skew is done by adding 3*cpunr, then round, then subtract this
+	 * extra offset again.
+	 */
+	j += cpu * 3;
+
+	rem = j % HZ;
+
+	/*
+	 * If the target jiffie is just after a whole second (which can happen
+	 * due to delays of the timer irq, long irq off times etc etc) then
+	 * we should round down to the whole second, not up. Use 1/4th second
+	 * as cutoff for this rounding as an extreme upper bound for this.
+	 */
+	if (rem < HZ/4) /* round down */
+		j = j - rem;
+	else /* round up */
+		j = j - rem + HZ;
+
+	/* now that we have rounded, subtract the extra skew again */
+	j -= cpu * 3;
+
+	if (j <= jiffies) /* rounding ate our timeout entirely; */
+		return original;
+	return j;
+}
+EXPORT_SYMBOL_GPL(__round_jiffies);
+
+/**
+ * __round_jiffies_relative - function to round jiffies to a full second
+ * @j: the time in (relative) jiffies that should be rounded
+ * @cpu: the processor number on which the timeout will happen
+ *
+ * __round_jiffies_relative rounds a time delta  in the future (in jiffies)
+ * up or down to (approximately) full seconds. This is useful for timers
+ * for which the exact time they fire does not matter too much, as long as
+ * they fire approximately every X seconds.
+ *
+ * By rounding these timers to whole seconds, all such timers will fire
+ * at the same time, rather than at various times spread out. The goal
+ * of this is to have the CPU wake up less, which saves power.
+ *
+ * The exact rounding is skewed for each processor to avoid all
+ * processors firing at the exact same time, which could lead
+ * to lock contention or spurious cache line bouncing.
+ *
+ * The return value is the rounded version of the "j" parameter.
+ */
+unsigned long __round_jiffies_relative(unsigned long j, int cpu)
+{
+	/*
+	 * In theory the following code can skip a jiffy in case jiffies
+	 * increments right between the addition and the later subtraction.
+	 * However since the entire point of this function is to use approximate
+	 * timeouts, it's entirely ok to not handle that.
+	 */
+	return  __round_jiffies(j + jiffies, cpu) - jiffies;
+}
+EXPORT_SYMBOL_GPL(__round_jiffies_relative);
+
+/**
+ * round_jiffies - function to round jiffies to a full second
+ * @j: the time in (absolute) jiffies that should be rounded
+ *
+ * round_jiffies rounds an absolute time in the future (in jiffies)
+ * up or down to (approximately) full seconds. This is useful for timers
+ * for which the exact time they fire does not matter too much, as long as
+ * they fire approximately every X seconds.
+ *
+ * By rounding these timers to whole seconds, all such timers will fire
+ * at the same time, rather than at various times spread out. The goal
+ * of this is to have the CPU wake up less, which saves power.
+ *
+ * The return value is the rounded version of the "j" parameter.
+ */
+unsigned long round_jiffies(unsigned long j)
+{
+	return __round_jiffies(j, raw_smp_processor_id());
+}
+EXPORT_SYMBOL_GPL(round_jiffies);
+
+/**
+ * round_jiffies_relative - function to round jiffies to a full second
+ * @j: the time in (relative) jiffies that should be rounded
+ *
+ * round_jiffies_relative rounds a time delta  in the future (in jiffies)
+ * up or down to (approximately) full seconds. This is useful for timers
+ * for which the exact time they fire does not matter too much, as long as
+ * they fire approximately every X seconds.
+ *
+ * By rounding these timers to whole seconds, all such timers will fire
+ * at the same time, rather than at various times spread out. The goal
+ * of this is to have the CPU wake up less, which saves power.
+ *
+ * The return value is the rounded version of the "j" parameter.
+ */
+unsigned long round_jiffies_relative(unsigned long j)
+{
+	return __round_jiffies_relative(j, raw_smp_processor_id());
+}
+EXPORT_SYMBOL_GPL(round_jiffies_relative);
+
+
 static inline void set_running_timer(tvec_base_t *base,
 					struct timer_list *timer)
 {
_

Patches currently in -mm which might be from arjan@linux.intel.com are

origin.patch
user-of-the-jiffies-rounding-patch-ata-subsystem.patch
user-of-the-jiffies-rounding-code-networking.patch

