From: akpm@linux-foundation.org
Subject: + add-support-for-deferrable-timers.patch added to -mm tree
Date: Wed, 21 Mar 2007 16:53:23 -0700
Message-ID: <200703212353.l2LNrNOj007453@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59894 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934094AbXCUXya (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Mar 2007 19:54:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: venkatesh.pallipadi@intel.com, davej@codemonkey.org.uk, johnstul@us.ibm.com, mingo@elte.hu, oleg@tv-sign.ru, tglx@linutronix.de


The patch titled
     Add support for deferrable timers
has been added to the -mm tree.  Its filename is
     add-support-for-deferrable-timers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add support for deferrable timers
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Introduce a new flag for timers - 'deferrable timer' Timers that work normally
when system is busy.  But, will not cause CPU to come out of idle (just to
service this timer), when CPU is idle.  Instead, this timer will be serviced
when CPU eventually wakes up with a subsequent non-deferrable timer or any
other event.

The main advantage of this is to avoid unnecessary timer interrupts when CPU
is idle.  If the routine currently called by a timer can wait until next event
without any issues, this new timer can be used while setting up timer for that
routine.  This, with dynticks, allows CPUs to be lazy, allowing them to stay
in idle for extended period of time by reducing unnecesary wakeup and thereby
reducing the power consumption.

This patch: Builds this new timer on top of existing timer infrastructure.  It
uses last bit in 'base' pointer of timer_list structure to store this
deferrable timer flag.  __next_timer_interrupt() function skips over these
deferrable timers when CPU looks for next timer event for which it has to wake
up.

This is exported by a new interface init_timer_deferrable() that can be called
in place of regular init_timer().

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/timer.h |    9 ++++
 kernel/timer.c        |   78 ++++++++++++++++++++++++++++++++++++----
 2 files changed, 81 insertions(+), 6 deletions(-)

diff -puN include/linux/timer.h~add-support-for-deferrable-timers include/linux/timer.h
--- a/include/linux/timer.h~add-support-for-deferrable-timers
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
+void fastcall init_timer_deferrable(struct timer_list * timer);
 
 static inline void setup_timer(struct timer_list * timer,
 				void (*function)(unsigned long),
diff -puN kernel/timer.c~add-support-for-deferrable-timers kernel/timer.c
--- a/kernel/timer.c~add-support-for-deferrable-timers
+++ a/kernel/timer.c
@@ -74,7 +74,7 @@ struct tvec_t_base_s {
 	tvec_t tv3;
 	tvec_t tv4;
 	tvec_t tv5;
-} ____cacheline_aligned_in_smp;
+} ____cacheline_aligned;
 
 typedef struct tvec_t_base_s tvec_base_t;
 
@@ -82,6 +82,46 @@ tvec_base_t boot_tvec_bases;
 EXPORT_SYMBOL(boot_tvec_bases);
 static DEFINE_PER_CPU(tvec_base_t *, tvec_bases) = &boot_tvec_bases;
 
+/*
+ * The lowest bit of base ptr in timer is used as a flag to indicate
+ * 'deferrable' nature of the timer. Functions below help us manage that flag.
+ */
+static inline struct tvec_t_base_s *tbase_get_base_ptr(
+	struct tvec_t_base_s *base)
+{
+	return ((struct tvec_t_base_s *)
+			((unsigned long)base & (~TBASE_DEFERRABLE_FLAG)));
+}
+
+static inline unsigned long tbase_get_deferrable_flag(
+	struct tvec_t_base_s *base)
+{
+	return ((unsigned long)base & TBASE_DEFERRABLE_FLAG);
+}
+
+static inline struct tvec_t_base_s *tbase_set_deferrable_flag(
+	struct tvec_t_base_s *base)
+{
+	return ((struct tvec_t_base_s *)
+			((unsigned long)base | TBASE_DEFERRABLE_FLAG));
+}
+
+static inline struct tvec_t_base_s *tbase_clear_deferrable_flag(
+	struct tvec_t_base_s *base)
+{
+	return ((struct tvec_t_base_s *)
+			((unsigned long)base & (~TBASE_DEFERRABLE_FLAG)));
+}
+
+static inline struct tvec_t_base_s *tbase_merge_deferrable_flag(
+	struct tvec_t_base_s *base, unsigned long flag)
+{
+	if (flag & TBASE_DEFERRABLE_FLAG)
+		return tbase_set_deferrable_flag(base);
+	else
+		return tbase_clear_deferrable_flag(base);
+}
+
 /**
  * __round_jiffies - function to round jiffies to a full second
  * @j: the time in (absolute) jiffies that should be rounded
@@ -295,6 +335,13 @@ void fastcall init_timer(struct timer_li
 }
 EXPORT_SYMBOL(init_timer);
 
+void fastcall init_timer_deferrable(struct timer_list *timer)
+{
+	init_timer(timer);
+	timer->base = tbase_set_deferrable_flag(timer->base);
+}
+EXPORT_SYMBOL(init_timer_deferrable);
+
 static inline void detach_timer(struct timer_list *timer,
 				int clear_pending)
 {
@@ -325,7 +372,7 @@ static tvec_base_t *lock_timer_base(stru
 	tvec_base_t *base;
 
 	for (;;) {
-		base = timer->base;
+		base = tbase_get_base_ptr(timer->base);
 		if (likely(base != NULL)) {
 			spin_lock_irqsave(&base->lock, *flags);
 			if (likely(base == timer->base))
@@ -364,12 +411,15 @@ int __mod_timer(struct timer_list *timer
 		 * the timer is serialized wrt itself.
 		 */
 		if (likely(base->running_timer != timer)) {
+			unsigned long tflag;
+			tflag = tbase_get_deferrable_flag(timer->base);
 			/* See the comment in lock_timer_base() */
 			timer->base = NULL;
 			spin_unlock(&base->lock);
 			base = new_base;
 			spin_lock(&base->lock);
-			timer->base = base;
+			timer->base =
+				tbase_merge_deferrable_flag(new_base, tflag);
 		}
 	}
 
@@ -393,11 +443,13 @@ void add_timer_on(struct timer_list *tim
 {
 	tvec_base_t *base = per_cpu(tvec_bases, cpu);
   	unsigned long flags;
+	unsigned long tflag;
 
 	timer_stats_timer_set_start_info(timer);
   	BUG_ON(timer_pending(timer) || !timer->function);
 	spin_lock_irqsave(&base->lock, flags);
-	timer->base = base;
+	tflag = tbase_get_deferrable_flag(timer->base);
+	timer->base = tbase_merge_deferrable_flag(base, tflag);
 	internal_add_timer(base, timer);
 	spin_unlock_irqrestore(&base->lock, flags);
 }
@@ -524,6 +576,8 @@ out:
  */
 int del_timer_sync(struct timer_list *timer)
 {
+	/* Force change the timer flag to be non-deferrable */
+	timer->base = tbase_clear_deferrable_flag(timer->base);
 	for (;;) {
 		int ret = try_to_del_timer_sync(timer);
 		if (ret >= 0)
@@ -548,7 +602,7 @@ static int cascade(tvec_base_t *base, tv
 	 * don't have to detach them individually.
 	 */
 	list_for_each_entry_safe(timer, tmp, &tv_list, entry) {
-		BUG_ON(timer->base != base);
+		BUG_ON(tbase_get_base_ptr(timer->base) != base);
 		internal_add_timer(base, timer);
 	}
 
@@ -634,6 +688,9 @@ static unsigned long __next_timer_interr
 	index = slot = timer_jiffies & TVR_MASK;
 	do {
 		list_for_each_entry(nte, base->tv1.vec + slot, entry) {
+ 			if (tbase_get_deferrable_flag(nte->base))
+ 				continue;
+
 			found = 1;
 			expires = nte->expires;
 			/* Look at the cascade bucket(s)? */
@@ -1602,6 +1659,13 @@ static int __devinit init_timers_cpu(int
 						cpu_to_node(cpu));
 			if (!base)
 				return -ENOMEM;
+
+			/* Make sure that tvec_base is 2 byte aligned */
+			if (tbase_get_deferrable_flag(base)) {
+				WARN_ON(1);
+				kfree(base);
+				return -ENOMEM;
+			}
 			memset(base, 0, sizeof(*base));
 			per_cpu(tvec_bases, cpu) = base;
 		} else {
@@ -1641,9 +1705,11 @@ static void migrate_timer_list(tvec_base
 	struct timer_list *timer;
 
 	while (!list_empty(head)) {
+		unsigned long tflag;
 		timer = list_entry(head->next, struct timer_list, entry);
+		tflag = tbase_get_deferrable_flag(timer->base);
 		detach_timer(timer, 0);
-		timer->base = new_base;
+		timer->base = tbase_merge_deferrable_flag(new_base, tflag);
 		internal_add_timer(new_base, timer);
 	}
 }
_

Patches currently in -mm which might be from venkatesh.pallipadi@intel.com are

git-acpi.patch
workqueue-fix-freezeable-workqueues-implementation.patch
workqueue-fix-flush_workqueue-vs-cpu_dead-race.patch
workqueue-dont-clear-cwq-thread-until-it-exits.patch
workqueue-dont-migrate-pending-works-from-the-dead-cpu.patch
add-support-for-deferrable-timers.patch
add-support-for-deferrable-timers-tidy.patch
export-deferrable-timer-through-workqueue-and-use-it-in-ondemand-governor.patch
export-deferrable-timer-through-workqueue-and-use-it-in-ondemand-governor-tidy.patch
