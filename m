From: akpm@linux-foundation.org
Subject: - add-support-for-deferrable-timers-respun-fix-2.patch removed from -mm tree
Date: Mon, 30 Apr 2007 13:00:01 -0700
Message-ID: <200704302000.l3UK05bf013635@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53953 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423618AbXD3UAR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 16:00:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: venkatesh.pallipadi@intel.com, mm-commits@vger.kernel.org


The patch titled
     Add support for deferrable timers (respun-Mar28)
has been removed from the -mm tree.  Its filename was
     add-support-for-deferrable-timers-respun-fix-2.patch

This patch was dropped because it was folded into add-support-for-deferrable-timers-respun.patch

------------------------------------------------------
Subject: Add support for deferrable timers (respun-Mar28)
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>

Introduce a new flag for timers - deferrable:
Timers that work normally when system is busy. But, will not cause CPU to
come out of idle (just to service this timer), when CPU is idle. Instead,
this timer will be serviced when CPU eventually wakes up with a subsequent
non-deferrable timer.

The main advantage of this is to avoid unnecessary timer interrupts when
CPU is idle. If the routine currently called by a timer can wait until next
event without any issues, this new timer can be used to setup timer event
for that routine. This, with dynticks, allows CPUs to be lazy, allowing them
to stay in idle for extended period of time by reducing unnecesary wakeup and
thereby reducing the power consumption.

This patch:
Builds this new timer on top of existing timer infrastructure. It uses
last bit in 'base' pointer of timer_list structure to store this
deferrable timer flag. __next_timer_interrupt() function
skips over these deferrable timers when CPU looks for
next timer event for which it has to wake up.

This is exported by a new interface init_timer_deferrable() that can
be called in place of regular init_timer().

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/timer.h |    2 -
 kernel/timer.c        |   52 +++++++++++++++-------------------------
 2 files changed, 20 insertions(+), 34 deletions(-)

diff -puN include/linux/timer.h~add-support-for-deferrable-timers-respun-fix-2 include/linux/timer.h
--- a/include/linux/timer.h~add-support-for-deferrable-timers-respun-fix-2
+++ a/include/linux/timer.h
@@ -8,8 +8,6 @@
 
 struct tvec_t_base_s;
 
-extern struct tvec_t_base_s boot_tvec_bases;
-
 struct timer_list {
 	struct list_head entry;
 	unsigned long expires;
diff -puN kernel/timer.c~add-support-for-deferrable-timers-respun-fix-2 kernel/timer.c
--- a/kernel/timer.c~add-support-for-deferrable-timers-respun-fix-2
+++ a/kernel/timer.c
@@ -48,13 +48,6 @@ u64 jiffies_64 __cacheline_aligned_in_sm
 EXPORT_SYMBOL(jiffies_64);
 
 /*
- * Note that all tvec_bases is 2 byte aligned and lower bit of base in
- * timer_list is guaranteed to be zero. Use the LSB for the new flag to
- * indicate whether the timer is deferrable
- */
-#define TBASE_DEFERRABLE_FLAG		(0x1)
-
-/*
  * per-CPU timer vector definitions:
  */
 #define TVN_BITS (CONFIG_BASE_SMALL ? 4 : 6)
@@ -90,38 +83,34 @@ EXPORT_SYMBOL(boot_tvec_bases);
 static DEFINE_PER_CPU(tvec_base_t *, tvec_bases) = &boot_tvec_bases;
 
 /*
- * The lowest bit of base ptr in timer is used as a flag to indicate
- * 'deferrable' nature of the timer. Functions below help us manage that flag.
+ * Note that all tvec_bases is 2 byte aligned and lower bit of
+ * base in timer_list is guaranteed to be zero. Use the LSB for
+ * the new flag to indicate whether the timer is deferrable
  */
-static inline unsigned int tbase_get_deferrable(struct tvec_t_base_s *base)
-{
-	return ((unsigned int)base & TBASE_DEFERRABLE_FLAG);
-}
+#define TBASE_DEFERRABLE_FLAG		(0x1)
 
-static inline unsigned int timer_get_deferrable(struct timer_list *timer)
+/* Functions below help us manage 'deferrable' flag */
+static inline unsigned int tbase_get_deferrable(tvec_base_t *base)
 {
-	return tbase_get_deferrable(timer->base);
+	return ((unsigned int)(unsigned long)base & TBASE_DEFERRABLE_FLAG);
 }
 
-static inline struct tvec_t_base_s *tbase_get_base(struct tvec_t_base_s *base)
+static inline tvec_base_t *tbase_get_base(tvec_base_t *base)
 {
-	return ((struct tvec_t_base_s *)((unsigned long)base &
-	                                 ~TBASE_DEFERRABLE_FLAG));
+	return ((tvec_base_t *)((unsigned long)base & ~TBASE_DEFERRABLE_FLAG));
 }
 
 static inline void timer_set_deferrable(struct timer_list *timer)
 {
-	timer->base = ((struct tvec_t_base_s *)((unsigned long)(timer->base) |
-	                                        TBASE_DEFERRABLE_FLAG));
+	timer->base = ((tvec_base_t *)((unsigned long)(timer->base) |
+	                               TBASE_DEFERRABLE_FLAG));
 }
 
-/* new_base is guaranteed to have last bit not set, in all callers below */
-static inline void timer_set_base(struct timer_list *timer,
-					struct tvec_t_base_s *old_base,
-					struct tvec_t_base_s *new_base)
+static inline void
+timer_set_base(struct timer_list *timer, tvec_base_t *new_base)
 {
-	timer->base = (struct tvec_t_base_s *)((unsigned long)(new_base) |
-	                                       tbase_get_deferrable(old_base));
+	timer->base = (tvec_base_t *)((unsigned long)(new_base) |
+	                              tbase_get_deferrable(timer->base));
 }
 
 /**
@@ -414,13 +403,12 @@ int __mod_timer(struct timer_list *timer
 		 * the timer is serialized wrt itself.
 		 */
 		if (likely(base->running_timer != timer)) {
-			tvec_base_t *old_base = timer->base;
 			/* See the comment in lock_timer_base() */
-			timer->base = NULL;
+			timer_set_base(timer, NULL);
 			spin_unlock(&base->lock);
 			base = new_base;
 			spin_lock(&base->lock);
-			timer_set_base(timer, old_base, base);
+			timer_set_base(timer, base);
 		}
 	}
 
@@ -448,7 +436,7 @@ void add_timer_on(struct timer_list *tim
 	timer_stats_timer_set_start_info(timer);
   	BUG_ON(timer_pending(timer) || !timer->function);
 	spin_lock_irqsave(&base->lock, flags);
-	timer_set_base(timer, timer->base, base);
+	timer_set_base(timer, base);
 	internal_add_timer(base, timer);
 	spin_unlock_irqrestore(&base->lock, flags);
 }
@@ -685,7 +673,7 @@ static unsigned long __next_timer_interr
 	index = slot = timer_jiffies & TVR_MASK;
 	do {
 		list_for_each_entry(nte, base->tv1.vec + slot, entry) {
- 			if (timer_get_deferrable(nte))
+ 			if (tbase_get_deferrable(nte->base))
  				continue;
 
 			found = 1;
@@ -1717,7 +1705,7 @@ static void migrate_timer_list(tvec_base
 	while (!list_empty(head)) {
 		timer = list_entry(head->next, struct timer_list, entry);
 		detach_timer(timer, 0);
-		timer_set_base(timer, timer->base, new_base);
+		timer_set_base(timer, new_base);
 		internal_add_timer(new_base, timer);
 	}
 }
_

Patches currently in -mm which might be from venkatesh.pallipadi@intel.com are

git-acpi.patch
cpuidle-hang-fix.patch
add-support-for-deferrable-timers-respun.patch
add-support-for-deferrable-timers-respun-fix-2.patch
add-a-new-deferrable-delayed-work-init.patch
workqueue-fix-freezeable-workqueues-implementation.patch
workqueue-fix-flush_workqueue-vs-cpu_dead-race.patch
workqueue-dont-clear-cwq-thread-until-it-exits.patch
workqueue-dont-migrate-pending-works-from-the-dead-cpu.patch
