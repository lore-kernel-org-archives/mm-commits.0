From: akpm@linux-foundation.org
Subject: - add-support-for-deferrable-timers-respun.patch removed from -mm tree
Date: Tue, 08 May 2007 19:47:57 -0700
Message-ID: <200705090247.l492lvG6009037@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38455 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934873AbXEICsT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:48:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: venkatesh.pallipadi@intel.com, davej@codemonkey.org.uk, mingo@elte.hu, oleg@tv-sign.ru, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Add support for deferrable timers
has been removed from the -mm tree.  Its filename was
     add-support-for-deferrable-timers-respun.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add support for deferrable timers
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>

Introduce a new flag for timers - deferrable: Timers that work normally
when system is busy.  But, will not cause CPU to come out of idle (just to
service this timer), when CPU is idle.  Instead, this timer will be
serviced when CPU eventually wakes up with a subsequent non-deferrable
timer.

The main advantage of this is to avoid unnecessary timer interrupts when
CPU is idle.  If the routine currently called by a timer can wait until
next event without any issues, this new timer can be used to setup timer
event for that routine.  This, with dynticks, allows CPUs to be lazy,
allowing them to stay in idle for extended period of time by reducing
unnecesary wakeup and thereby reducing the power consumption.

This patch:

Builds this new timer on top of existing timer infrastructure.  It uses
last bit in 'base' pointer of timer_list structure to store this deferrable
timer flag.  __next_timer_interrupt() function skips over these deferrable
timers when CPU looks for next timer event for which it has to wake up.

This is exported by a new interface init_timer_deferrable() that can be
called in place of regular init_timer().

[akpm@linux-foundation.org: Privatise a #define]
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/timer.h |    1 
 kernel/timer.c        |   65 +++++++++++++++++++++++++++++++++++-----
 2 files changed, 58 insertions(+), 8 deletions(-)

diff -puN include/linux/timer.h~add-support-for-deferrable-timers-respun include/linux/timer.h
--- a/include/linux/timer.h~add-support-for-deferrable-timers-respun
+++ a/include/linux/timer.h
@@ -37,6 +37,7 @@ extern struct tvec_t_base_s boot_tvec_ba
 		TIMER_INITIALIZER(_function, _expires, _data)
 
 void fastcall init_timer(struct timer_list * timer);
+void fastcall init_timer_deferrable(struct timer_list *timer);
 
 static inline void setup_timer(struct timer_list * timer,
 				void (*function)(unsigned long),
diff -puN kernel/timer.c~add-support-for-deferrable-timers-respun kernel/timer.c
--- a/kernel/timer.c~add-support-for-deferrable-timers-respun
+++ a/kernel/timer.c
@@ -74,7 +74,7 @@ struct tvec_t_base_s {
 	tvec_t tv3;
 	tvec_t tv4;
 	tvec_t tv5;
-} ____cacheline_aligned_in_smp;
+} ____cacheline_aligned;
 
 typedef struct tvec_t_base_s tvec_base_t;
 
@@ -82,6 +82,37 @@ tvec_base_t boot_tvec_bases;
 EXPORT_SYMBOL(boot_tvec_bases);
 static DEFINE_PER_CPU(tvec_base_t *, tvec_bases) = &boot_tvec_bases;
 
+/*
+ * Note that all tvec_bases is 2 byte aligned and lower bit of
+ * base in timer_list is guaranteed to be zero. Use the LSB for
+ * the new flag to indicate whether the timer is deferrable
+ */
+#define TBASE_DEFERRABLE_FLAG		(0x1)
+
+/* Functions below help us manage 'deferrable' flag */
+static inline unsigned int tbase_get_deferrable(tvec_base_t *base)
+{
+	return ((unsigned int)(unsigned long)base & TBASE_DEFERRABLE_FLAG);
+}
+
+static inline tvec_base_t *tbase_get_base(tvec_base_t *base)
+{
+	return ((tvec_base_t *)((unsigned long)base & ~TBASE_DEFERRABLE_FLAG));
+}
+
+static inline void timer_set_deferrable(struct timer_list *timer)
+{
+	timer->base = ((tvec_base_t *)((unsigned long)(timer->base) |
+	                               TBASE_DEFERRABLE_FLAG));
+}
+
+static inline void
+timer_set_base(struct timer_list *timer, tvec_base_t *new_base)
+{
+	timer->base = (tvec_base_t *)((unsigned long)(new_base) |
+	                              tbase_get_deferrable(timer->base));
+}
+
 /**
  * __round_jiffies - function to round jiffies to a full second
  * @j: the time in (absolute) jiffies that should be rounded
@@ -295,6 +326,13 @@ void fastcall init_timer(struct timer_li
 }
 EXPORT_SYMBOL(init_timer);
 
+void fastcall init_timer_deferrable(struct timer_list *timer)
+{
+	init_timer(timer);
+	timer_set_deferrable(timer);
+}
+EXPORT_SYMBOL(init_timer_deferrable);
+
 static inline void detach_timer(struct timer_list *timer,
 				int clear_pending)
 {
@@ -325,10 +363,11 @@ static tvec_base_t *lock_timer_base(stru
 	tvec_base_t *base;
 
 	for (;;) {
-		base = timer->base;
+		tvec_base_t *prelock_base = timer->base;
+		base = tbase_get_base(prelock_base);
 		if (likely(base != NULL)) {
 			spin_lock_irqsave(&base->lock, *flags);
-			if (likely(base == timer->base))
+			if (likely(prelock_base == timer->base))
 				return base;
 			/* The timer has migrated to another CPU */
 			spin_unlock_irqrestore(&base->lock, *flags);
@@ -365,11 +404,11 @@ int __mod_timer(struct timer_list *timer
 		 */
 		if (likely(base->running_timer != timer)) {
 			/* See the comment in lock_timer_base() */
-			timer->base = NULL;
+			timer_set_base(timer, NULL);
 			spin_unlock(&base->lock);
 			base = new_base;
 			spin_lock(&base->lock);
-			timer->base = base;
+			timer_set_base(timer, base);
 		}
 	}
 
@@ -397,7 +436,7 @@ void add_timer_on(struct timer_list *tim
 	timer_stats_timer_set_start_info(timer);
   	BUG_ON(timer_pending(timer) || !timer->function);
 	spin_lock_irqsave(&base->lock, flags);
-	timer->base = base;
+	timer_set_base(timer, base);
 	internal_add_timer(base, timer);
 	spin_unlock_irqrestore(&base->lock, flags);
 }
@@ -550,7 +589,7 @@ static int cascade(tvec_base_t *base, tv
 	 * don't have to detach them individually.
 	 */
 	list_for_each_entry_safe(timer, tmp, &tv_list, entry) {
-		BUG_ON(timer->base != base);
+		BUG_ON(tbase_get_base(timer->base) != base);
 		internal_add_timer(base, timer);
 	}
 
@@ -636,6 +675,9 @@ static unsigned long __next_timer_interr
 	index = slot = timer_jiffies & TVR_MASK;
 	do {
 		list_for_each_entry(nte, base->tv1.vec + slot, entry) {
+ 			if (tbase_get_deferrable(nte->base))
+ 				continue;
+
 			found = 1;
 			expires = nte->expires;
 			/* Look at the cascade bucket(s)? */
@@ -1617,6 +1659,13 @@ static int __devinit init_timers_cpu(int
 						cpu_to_node(cpu));
 			if (!base)
 				return -ENOMEM;
+
+			/* Make sure that tvec_base is 2 byte aligned */
+			if (tbase_get_deferrable(base)) {
+				WARN_ON(1);
+				kfree(base);
+				return -ENOMEM;
+			}
 			memset(base, 0, sizeof(*base));
 			per_cpu(tvec_bases, cpu) = base;
 		} else {
@@ -1658,7 +1707,7 @@ static void migrate_timer_list(tvec_base
 	while (!list_empty(head)) {
 		timer = list_entry(head->next, struct timer_list, entry);
 		detach_timer(timer, 0);
-		timer->base = new_base;
+		timer_set_base(timer, new_base);
 		internal_add_timer(new_base, timer);
 	}
 }
_

Patches currently in -mm which might be from venkatesh.pallipadi@intel.com are

origin.patch
git-acpi.patch
workqueue-fix-freezeable-workqueues-implementation.patch
workqueue-fix-flush_workqueue-vs-cpu_dead-race.patch
workqueue-dont-clear-cwq-thread-until-it-exits.patch
workqueue-dont-migrate-pending-works-from-the-dead-cpu.patch
