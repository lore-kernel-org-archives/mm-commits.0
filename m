From: akpm@linux-foundation.org
Subject: - timerc-cleanup-recently-introduced-whitespace-damage.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:04:31 -0700
Message-ID: <200707192004.l6JK4VUE019958@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33093 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760626AbXGSURA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:17:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     timer.c: cleanup recently introduced whitespace damage
has been removed from the -mm tree.  Its filename was
     timerc-cleanup-recently-introduced-whitespace-damage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: timer.c: cleanup recently introduced whitespace damage
From: Thomas Gleixner <tglx@linutronix.de>

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/timer.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff -puN kernel/timer.c~timerc-cleanup-recently-introduced-whitespace-damage kernel/timer.c
--- a/kernel/timer.c~timerc-cleanup-recently-introduced-whitespace-damage
+++ a/kernel/timer.c
@@ -103,14 +103,14 @@ static inline tvec_base_t *tbase_get_bas
 static inline void timer_set_deferrable(struct timer_list *timer)
 {
 	timer->base = ((tvec_base_t *)((unsigned long)(timer->base) |
-	                               TBASE_DEFERRABLE_FLAG));
+				       TBASE_DEFERRABLE_FLAG));
 }
 
 static inline void
 timer_set_base(struct timer_list *timer, tvec_base_t *new_base)
 {
 	timer->base = (tvec_base_t *)((unsigned long)(new_base) |
-	                              tbase_get_deferrable(timer->base));
+				      tbase_get_deferrable(timer->base));
 }
 
 /**
@@ -445,10 +445,10 @@ EXPORT_SYMBOL(__mod_timer);
 void add_timer_on(struct timer_list *timer, int cpu)
 {
 	tvec_base_t *base = per_cpu(tvec_bases, cpu);
-  	unsigned long flags;
+	unsigned long flags;
 
 	timer_stats_timer_set_start_info(timer);
-  	BUG_ON(timer_pending(timer) || !timer->function);
+	BUG_ON(timer_pending(timer) || !timer->function);
 	spin_lock_irqsave(&base->lock, flags);
 	timer_set_base(timer, base);
 	internal_add_timer(base, timer);
@@ -627,7 +627,7 @@ static inline void __run_timers(tvec_bas
 	while (time_after_eq(jiffies, base->timer_jiffies)) {
 		struct list_head work_list;
 		struct list_head *head = &work_list;
- 		int index = base->timer_jiffies & TVR_MASK;
+		int index = base->timer_jiffies & TVR_MASK;
 
 		/*
 		 * Cascade timers:
@@ -644,8 +644,8 @@ static inline void __run_timers(tvec_bas
 			unsigned long data;
 
 			timer = list_first_entry(head, struct timer_list,entry);
- 			fn = timer->function;
- 			data = timer->data;
+			fn = timer->function;
+			data = timer->data;
 
 			timer_stats_account_timer(timer);
 
@@ -689,8 +689,8 @@ static unsigned long __next_timer_interr
 	index = slot = timer_jiffies & TVR_MASK;
 	do {
 		list_for_each_entry(nte, base->tv1.vec + slot, entry) {
- 			if (tbase_get_deferrable(nte->base))
- 				continue;
+			if (tbase_get_deferrable(nte->base))
+				continue;
 
 			found = 1;
 			expires = nte->expires;
@@ -834,7 +834,7 @@ void update_process_times(int user_tick)
 	if (rcu_pending(cpu))
 		rcu_check_callbacks(cpu, user_tick);
 	scheduler_tick();
- 	run_posix_cpu_timers(p);
+	run_posix_cpu_timers(p);
 }
 
 /*
@@ -909,7 +909,7 @@ static inline void update_times(unsigned
 	update_wall_time();
 	calc_load(ticks);
 }
-  
+
 /*
  * The 64-bit jiffies value is not atomic - you MUST NOT read it
  * without sampling the sequence number in xtime_lock.
@@ -1105,7 +1105,7 @@ asmlinkage long sys_gettid(void)
 /**
  * do_sysinfo - fill in sysinfo struct
  * @info: pointer to buffer to fill
- */ 
+ */
 int do_sysinfo(struct sysinfo *info)
 {
 	unsigned long mem_total, sav_total;
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-acpi.patch
acpi-move-timer-broadcast-and-pmtimer-access-before-c3-arbiter-shutdown.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
clockevents-remove-prototypes-of-removed-functions.patch
clockevents-fix-resume-logic.patch
lguest-the-host-code-lguest-vs-clockevents-fix-resume-logic.patch
clockevents-fix-device-replacement.patch
tick-management-spread-timer-interrupt.patch
highres-improve-debug-output.patch
hrtimer-speedup-hrtimer_enqueue.patch
ntp-move-the-cmos-update-code-into-ntpc.patch
i386-pit-stop-only-when-in-periodic-or-oneshot-mode.patch
acpi-remove-the-useless-ifdef-code.patch
x86_64-hpet-restore-vread.patch
x86_64-restore-restore-nohpet-cmdline.patch
x86_64-block-irq-balancing-for-timer.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-enable-high-resolution-timers-and-dynticks.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
geode-mfgpt-clock-event-device-support.patch
