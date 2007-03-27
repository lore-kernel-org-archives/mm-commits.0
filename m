From: akpm@linux-foundation.org
Subject: + add-support-for-deferrable-timers-respun.patch added to -mm tree
Date: Tue, 27 Mar 2007 13:56:28 -0700
Message-ID: <200703272056.l2RKuSmT027568@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42758 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934210AbXC0U5I (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Mar 2007 16:57:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: venkatesh.pallipadi@intel.com, davej@codemonkey.org.uk, mingo@elte.hu, oleg@tv-sign.ru, tglx@linutronix.de


The patch titled
     Add support for deferrable timers
has been added to the -mm tree.  Its filename is
     add-support-for-deferrable-timers-respun.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/timer.h |    9 +++++
 kernel/timer.c        |   68 +++++++++++++++++++++++++++++++++++-----
 2 files changed, 70 insertions(+), 7 deletions(-)

diff -puN include/linux/timer.h~add-support-for-deferrable-timers-respun include/linux/timer.h
--- a/include/linux/timer.h~add-support-for-deferrable-timers-respun
+++ a/include/linux/timer.h
@@ -8,6 +8,14 @@
 
 struct tvec_t_base_s;
 
+extern struct tvec_t_base_s boot_tvec_bases;
+/*
+ * Note that all tvec_bases is 2 byte aligned and lower bit of
+ * base in timer_list is guaranteed to be zero. Use the LSB for
+ * the new flag to indicate whether the timer is deferrable
+ */
+#define TBASE_DEFERRABLE_FLAG		(0x1)
+
 struct timer_list {
 	struct list_head entry;
 	unsigned long expires;
@@ -37,6 +45,7 @@ extern struct tvec_t_base_s boot_tvec_ba
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
 
@@ -82,6 +82,41 @@ tvec_base_t boot_tvec_bases;
 EXPORT_SYMBOL(boot_tvec_bases);
 static DEFINE_PER_CPU(tvec_base_t *, tvec_bases) = &boot_tvec_bases;
 
+/*
+ * The lowest bit of base ptr in timer is used as a flag to indicate
+ * 'deferrable' nature of the timer. Functions below help us manage that flag.
+ */
+static inline unsigned int tbase_get_deferrable(struct tvec_t_base_s *base)
+{
+	return ((unsigned int)base & TBASE_DEFERRABLE_FLAG);
+}
+
+static inline unsigned int timer_get_deferrable(struct timer_list *timer)
+{
+	return tbase_get_deferrable(timer->base);
+}
+
+static inline struct tvec_t_base_s *timer_get_base(struct timer_list *timer)
+{
+	return ((struct tvec_t_base_s *)((unsigned long)(timer->base) &
+	                                 ~TBASE_DEFERRABLE_FLAG));
+}
+
+static inline void timer_set_deferrable(struct timer_list *timer)
+{
+	timer->base = ((struct tvec_t_base_s *)((unsigned long)(timer->base) |
+	                                        TBASE_DEFERRABLE_FLAG));
+}
+
+/* new_base is guaranteed to have last bit not set, in all callers below */
+static inline void timer_set_base(struct timer_list *timer,
+					struct tvec_t_base_s *old_base,
+					struct tvec_t_base_s *new_base)
+{
+	timer->base = (struct tvec_t_base_s *)((unsigned long)(new_base) |
+	                                       tbase_get_deferrable(old_base));
+}
+
 /**
  * __round_jiffies - function to round jiffies to a full second
  * @j: the time in (absolute) jiffies that should be rounded
@@ -295,6 +330,13 @@ void fastcall init_timer(struct timer_li
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
@@ -325,10 +367,11 @@ static tvec_base_t *lock_timer_base(stru
 	tvec_base_t *base;
 
 	for (;;) {
-		base = timer->base;
+		tvec_base_t *prelock_base = timer->base;
+		base = timer_get_base(timer);
 		if (likely(base != NULL)) {
 			spin_lock_irqsave(&base->lock, *flags);
-			if (likely(base == timer->base))
+			if (likely(prelock_base == timer->base))
 				return base;
 			/* The timer has migrated to another CPU */
 			spin_unlock_irqrestore(&base->lock, *flags);
@@ -364,12 +407,13 @@ int __mod_timer(struct timer_list *timer
 		 * the timer is serialized wrt itself.
 		 */
 		if (likely(base->running_timer != timer)) {
+			tvec_base_t *old_base = timer->base;
 			/* See the comment in lock_timer_base() */
 			timer->base = NULL;
 			spin_unlock(&base->lock);
 			base = new_base;
 			spin_lock(&base->lock);
-			timer->base = base;
+			timer_set_base(timer, old_base, base);
 		}
 	}
 
@@ -397,7 +441,7 @@ void add_timer_on(struct timer_list *tim
 	timer_stats_timer_set_start_info(timer);
   	BUG_ON(timer_pending(timer) || !timer->function);
 	spin_lock_irqsave(&base->lock, flags);
-	timer->base = base;
+	timer_set_base(timer, timer->base, base);
 	internal_add_timer(base, timer);
 	spin_unlock_irqrestore(&base->lock, flags);
 }
@@ -548,7 +592,7 @@ static int cascade(tvec_base_t *base, tv
 	 * don't have to detach them individually.
 	 */
 	list_for_each_entry_safe(timer, tmp, &tv_list, entry) {
-		BUG_ON(timer->base != base);
+		BUG_ON(timer_get_base(timer) != base);
 		internal_add_timer(base, timer);
 	}
 
@@ -634,6 +678,9 @@ static unsigned long __next_timer_interr
 	index = slot = timer_jiffies & TVR_MASK;
 	do {
 		list_for_each_entry(nte, base->tv1.vec + slot, entry) {
+ 			if (timer_get_deferrable(nte))
+ 				continue;
+
 			found = 1;
 			expires = nte->expires;
 			/* Look at the cascade bucket(s)? */
@@ -1615,6 +1662,13 @@ static int __devinit init_timers_cpu(int
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
@@ -1656,7 +1710,7 @@ static void migrate_timer_list(tvec_base
 	while (!list_empty(head)) {
 		timer = list_entry(head->next, struct timer_list, entry);
 		detach_timer(timer, 0);
-		timer->base = new_base;
+		timer_set_base(timer, timer->base, new_base);
 		internal_add_timer(new_base, timer);
 	}
 }
_

Patches currently in -mm which might be from venkatesh.pallipadi@intel.com are

git-acpi.patch
cpuidle-fix-boot-hang.patch
cpuidle-unsigned-bitfield.patch
add-support-for-deferrable-timers-respun.patch
add-support-for-deferrable-timers-respun-tidy.patch
workqueue-fix-freezeable-workqueues-implementation.patch
workqueue-fix-flush_workqueue-vs-cpu_dead-race.patch
workqueue-dont-clear-cwq-thread-until-it-exits.patch
workqueue-dont-migrate-pending-works-from-the-dead-cpu.patch
