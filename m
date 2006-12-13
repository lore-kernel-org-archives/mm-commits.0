From: akpm@osdl.org
Subject: - updated-debugging-feature-timer-stats-fixes.patch removed from -mm tree
Date: Wed, 13 Dec 2006 14:50:12 -0800
Message-ID: <200612132250.kBDMoCfP023208@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53134 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768AbWLMWuV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 17:50:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     timer stats: updates
has been removed from the -mm tree.  Its filename was
     updated-debugging-feature-timer-stats-fixes.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: timer stats: updates
From: Ingo Molnar <mingo@elte.hu>

this is a major update to the /proc/timer_stats code and interface:

 - change from linear list walking and global locking to a
   scalable design: hash table and per-CPU locks for lookup,
   global lock for adding new buckets (rare) and mutex for
   serializing state changes with displaying stats.

 - state transition simplification: active/inactive.

 - dont auto-stop collection of events when displaying /proc/timer_stats

 - include version information in /proc/timer_stats output

 - include count of missed events (overflow count)

 - sanitize start/stop time calculations

 - change /proc/timer_stat from 0666 to 0644 ...

 - fix bugs in milliseconds calculation and display

 - fix division by zero bug

 - add comments

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/clockchips.h |   25 ++
 include/linux/timer.h      |    6 
 kernel/time/clockevents.c  |   49 +---
 kernel/time/timer_stats.c  |  345 +++++++++++++++++++++++++----------
 kernel/timer.c             |    2 
 5 files changed, 305 insertions(+), 122 deletions(-)

diff -puN include/linux/timer.h~updated-debugging-feature-timer-stats-fixes include/linux/timer.h
--- a/include/linux/timer.h~updated-debugging-feature-timer-stats-fixes
+++ a/include/linux/timer.h
@@ -84,6 +84,8 @@ extern unsigned long get_next_timer_inte
  */
 #ifdef CONFIG_TIMER_STATS
 
+extern void init_timer_stats(void);
+
 extern void timer_stats_update_stats(void *timer, pid_t pid, void *startf,
 				     void *timerf, char * comm);
 
@@ -106,6 +108,10 @@ static inline void timer_stats_timer_cle
 	timer->start_site = NULL;
 }
 #else
+static inline void init_timer_stats(void)
+{
+}
+
 static inline void timer_stats_account_timer(struct timer_list *timer)
 {
 }
diff -puN kernel/time/timer_stats.c~updated-debugging-feature-timer-stats-fixes kernel/time/timer_stats.c
--- a/kernel/time/timer_stats.c~updated-debugging-feature-timer-stats-fixes
+++ a/kernel/time/timer_stats.c
@@ -9,12 +9,13 @@
  * timer_stats is based on timer_top, a similar functionality which was part of
  * Con Kolivas dyntick patch set. It was developed by Daniel Petrini at the
  * Instituto Nokia de Tecnologia - INdT - Manaus. timer_top's design was based
- * on dynamic allocation of the statistics entries rather than the static array
- * which is used by timer_stats. It was written for the pre hrtimer kernel code
- * and therefor did not take hrtimers into account. Nevertheless it provided
- * the base for the timer_stats implementation and was a helpful source of
- * inspiration in the first place. Kudos to Daniel and the Nokia folks for this
- * effort.
+ * on dynamic allocation of the statistics entries and linear search based
+ * lookup combined with a global lock, rather than the static array, hash
+ * and per-CPU locking which is used by timer_stats. It was written for the
+ * pre hrtimer kernel code and therefore did not take hrtimers into account.
+ * Nevertheless it provided the base for the timer_stats implementation and
+ * was a helpful source of inspiration. Kudos to Daniel and the Nokia folks
+ * for this effort.
  *
  * timer_top.c is
  *	Copyright (C) 2005 Instituto Nokia de Tecnologia - INdT - Manaus
@@ -27,7 +28,7 @@
  * Start/stop data collection:
  * # echo 1[0] >/proc/timer_stats
  *
- * Display the collected information:
+ * Display the information collected so far:
  * # cat /proc/timer_stats
  *
  * This program is free software; you can redistribute it and/or modify
@@ -35,7 +36,6 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/list.h>
 #include <linux/proc_fs.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
@@ -45,28 +45,175 @@
 
 #include <asm/uaccess.h>
 
-enum tstats_stat {
-	TSTATS_INACTIVE,
-	TSTATS_ACTIVE,
-	TSTATS_READOUT,
-	TSTATS_RESET,
-};
-
-struct tstats_entry {
+/*
+ * This is our basic unit of interest: a timer expiry event identified
+ * by the timer, its start/expire functions and the PID of the task that
+ * started the timer. We count the number of times an event happens:
+ */
+struct entry {
+	/*
+	 * Hash list:
+	 */
+	struct entry		*next;
+
+	/*
+	 * Hash keys:
+	 */
 	void			*timer;
 	void			*start_func;
 	void			*expire_func;
-	unsigned long		counter;
 	pid_t			pid;
+
+	/*
+	 * Number of timeout events:
+	 */
+	unsigned long		count;
+
+	/*
+	 * We save the command-line string to preserve
+	 * this information past task exit:
+	 */
 	char			comm[TASK_COMM_LEN + 1];
-};
 
-#define TSTATS_MAX_ENTRIES	1024
+} ____cacheline_aligned_in_smp;
+
+/*
+ * Spinlock protecting the tables - not taken during lookup:
+ */
+static DEFINE_RAW_SPINLOCK(table_lock);
+
+/*
+ * Per-CPU lookup locks for fast hash lookup:
+ */
+static DEFINE_PER_CPU(raw_spinlock_t, lookup_lock);
+
+/*
+ * Mutex to serialize state changes with show-stats activities:
+ */
+static DEFINE_MUTEX(show_mutex);
+
+/*
+ * Collection status, active/inactive:
+ */
+static int __read_mostly active;
+
+/*
+ * Beginning/end timestamps of measurement:
+ */
+static ktime_t time_start, time_stop;
+
+/*
+ * tstat entry structs only get allocated while collection is
+ * active and never freed during that time - this simplifies
+ * things quite a bit.
+ *
+ * They get freed when a new collection period is started.
+ */
+#define MAX_ENTRIES_BITS	10
+#define MAX_ENTRIES		(1UL << MAX_ENTRIES_BITS)
+
+unsigned long nr_entries;
+static struct entry entries[MAX_ENTRIES];
+
+static atomic_t overflow_count;
+
+static void reset_entries(void)
+{
+	nr_entries = 0;
+	memset(entries, 0, sizeof(entries));
+	atomic_set(&overflow_count, 0);
+}
+
+static struct entry *alloc_entry(void)
+{
+	if (nr_entries >= MAX_ENTRIES)
+		return NULL;
+
+	return entries + nr_entries++;
+}
+
+/*
+ * The entries are in a hash-table, for fast lookup:
+ */
+#define TSTAT_HASH_BITS		(MAX_ENTRIES_BITS - 1)
+#define TSTAT_HASH_SIZE		(1UL << TSTAT_HASH_BITS)
+#define TSTAT_HASH_MASK		(TSTAT_HASH_SIZE - 1)
+
+#define __tstat_hashfn(entry)						\
+	(((unsigned long)(entry)->timer       ^				\
+	  (unsigned long)(entry)->start_func  ^				\
+	  (unsigned long)(entry)->expire_func ^				\
+	  (unsigned long)(entry)->pid		) & TSTAT_HASH_MASK)
+
+#define tstat_hashentry(entry)	(tstat_hash_table + __tstat_hashfn(entry))
+
+static struct entry *tstat_hash_table[TSTAT_HASH_SIZE] __read_mostly;
+
+static int match_entries(struct entry *entry1, struct entry *entry2)
+{
+	return entry1->timer       == entry2->timer	  &&
+	       entry1->start_func  == entry2->start_func  &&
+	       entry1->expire_func == entry2->expire_func &&
+	       entry1->pid	   == entry2->pid;
+}
+
+/*
+ * Look up whether an entry matching this item is present
+ * in the hash already. Must be called with irqs off and the
+ * lookup lock held:
+ */
+static struct entry *tstat_lookup(struct entry *entry, char *comm)
+{
+	struct entry **head, *curr, *prev;
+
+	head = tstat_hashentry(entry);
+	curr = *head;
+
+	/*
+	 * The fastpath is when the entry is already hashed,
+	 * we do this with the lookup lock held, but with the
+	 * table lock not held:
+	 */
+	while (curr) {
+		if (match_entries(curr, entry))
+			return curr;
+
+		curr = curr->next;
+	}
+	/*
+	 * Slowpath: allocate, set up and link a new hash entry:
+	 */
+	prev = NULL;
+	curr = *head;
+
+	spin_lock(&table_lock);
+	/*
+	 * Make sure we have not raced with another CPU:
+	 */
+	while (curr) {
+		if (match_entries(curr, entry))
+			goto out_unlock;
+
+		prev = curr;
+		curr = curr->next;
+	}
 
-static struct tstats_entry tstats[TSTATS_MAX_ENTRIES];
-static DEFINE_SPINLOCK(tstats_lock);
-static enum tstats_stat tstats_status;
-static ktime_t tstats_time;
+	curr = alloc_entry();
+	if (curr) {
+		*curr = *entry;
+		curr->count = 0;
+		memcpy(curr->comm, comm, TASK_COMM_LEN);
+		if (prev)
+			prev->next = curr;
+		else
+			*head = curr;
+		curr->next = NULL;
+	}
+ out_unlock:
+	spin_unlock(&table_lock);
+
+	return curr;
+}
 
 /**
  * timer_stats_update_stats - Update the statistics for a timer.
@@ -82,37 +229,30 @@ static ktime_t tstats_time;
 void timer_stats_update_stats(void *timer, pid_t pid, void *startf,
 			      void *timerf, char * comm)
 {
-	struct tstats_entry *entry = tstats;
+	/*
+	 * It doesnt matter which lock we take:
+	 */
+	raw_spinlock_t *lock = &per_cpu(lookup_lock, raw_smp_processor_id());
+	struct entry *entry, input;
 	unsigned long flags;
-	int i;
 
-	spin_lock_irqsave(&tstats_lock, flags);
-	if (tstats_status != TSTATS_ACTIVE)
-		goto out_unlock;
+	input.timer = timer;
+	input.start_func = startf;
+	input.expire_func = timerf;
+	input.pid = pid;
 
-	for (i = 0; i < TSTATS_MAX_ENTRIES; i++, entry++) {
-		if (entry->timer == timer &&
-		    entry->start_func == startf &&
-		    entry->expire_func == timerf &&
-		    entry->pid == pid) {
+	spin_lock_irqsave(lock, flags);
+	if (!active)
+		goto out_unlock;
 
-			entry->counter++;
-			break;
-		}
-		if (!entry->timer) {
-			entry->timer = timer;
-			entry->start_func = startf;
-			entry->expire_func = timerf;
-			entry->counter = 1;
-			entry->pid = pid;
-			memcpy(entry->comm, comm, TASK_COMM_LEN);
-			entry->comm[TASK_COMM_LEN] = 0;
-			break;
-		}
-	}
+	entry = tstat_lookup(&input, comm);
+	if (likely(entry))
+		entry->count++;
+	else
+		atomic_inc(&overflow_count);
 
  out_unlock:
-	spin_unlock_irqrestore(&tstats_lock, flags);
+	spin_unlock_irqrestore(lock, flags);
 }
 
 static void print_name_offset(struct seq_file *m, unsigned long addr)
@@ -131,53 +271,75 @@ static void print_name_offset(struct seq
 
 static int tstats_show(struct seq_file *m, void *v)
 {
-	struct tstats_entry *entry = tstats;
 	struct timespec period;
+	struct entry *entry;
 	unsigned long ms;
 	long events = 0;
+	ktime_t time;
 	int i;
 
-	spin_lock_irq(&tstats_lock);
-	switch(tstats_status) {
-	case TSTATS_ACTIVE:
-		tstats_time = ktime_sub(ktime_get(), tstats_time);
-	case TSTATS_INACTIVE:
-		tstats_status = TSTATS_READOUT;
-		break;
-	default:
-		spin_unlock_irq(&tstats_lock);
-		return -EBUSY;
-	}
-	spin_unlock_irq(&tstats_lock);
-
-	period = ktime_to_timespec(tstats_time);
-	ms = period.tv_nsec % 1000000;
-
-	seq_printf(m, "Timerstats sample period: %ld.%3ld s\n",
-		   period.tv_sec, ms);
-
-	for (i = 0; i < TSTATS_MAX_ENTRIES && entry->timer; i++, entry++) {
-		seq_printf(m, "%4lu, %5d %-16s ", entry->counter, entry->pid,
-			   entry->comm);
+	mutex_lock(&show_mutex);
+	/*
+	 * If still active then calculate up to now:
+	 */
+	if (active)
+		time_stop = ktime_get();
+
+	time = ktime_sub(time_stop, time_start);
+
+	period = ktime_to_timespec(time);
+	ms = period.tv_nsec / 1000000;
+
+	seq_puts(m, "Timer Stats Version: v0.1\n");
+	seq_printf(m, "Sample period: %ld.%03ld s\n", period.tv_sec, ms);
+	if (atomic_read(&overflow_count))
+		seq_printf(m, "Overflow: %d entries\n",
+			atomic_read(&overflow_count));
+
+	for (i = 0; i < nr_entries; i++) {
+		entry = entries + i;
+		seq_printf(m, "%4lu, %5d %-16s ",
+				entry->count, entry->pid, entry->comm);
 
 		print_name_offset(m, (unsigned long)entry->start_func);
 		seq_puts(m, " (");
 		print_name_offset(m, (unsigned long)entry->expire_func);
 		seq_puts(m, ")\n");
-		events += entry->counter;
+
+		events += entry->count;
 	}
 
 	ms += period.tv_sec * 1000;
+	if (!ms)
+		ms = 1;
+
 	if (events && period.tv_sec)
 		seq_printf(m, "%ld total events, %ld.%ld events/sec\n", events,
 			   events / period.tv_sec, events * 1000 / ms);
 	else
 		seq_printf(m, "%ld total events\n", events);
 
-	tstats_status = TSTATS_INACTIVE;
+	mutex_unlock(&show_mutex);
+
 	return 0;
 }
 
+/*
+ * After a state change, make sure all concurrent lookup/update
+ * activities have stopped:
+ */
+static void sync_access(void)
+{
+	unsigned long flags;
+	int cpu;
+
+	for_each_online_cpu(cpu) {
+		spin_lock_irqsave(&per_cpu(lookup_lock, cpu), flags);
+		/* nothing */
+		spin_unlock_irqrestore(&per_cpu(lookup_lock, cpu), flags);
+	}
+}
+
 static ssize_t tstats_write(struct file *file, const char __user *buf,
 			    size_t count, loff_t *offs)
 {
@@ -189,28 +351,26 @@ static ssize_t tstats_write(struct file 
 	if (copy_from_user(ctl, buf, count))
 		return -EFAULT;
 
+	mutex_lock(&show_mutex);
 	switch (ctl[0]) {
 	case '0':
-		spin_lock_irq(&tstats_lock);
-		if (tstats_status == TSTATS_ACTIVE) {
-			tstats_status = TSTATS_INACTIVE;
-			tstats_time = ktime_sub(ktime_get(), tstats_time);
+		if (active) {
+			active = 0;
+			time_stop = ktime_get();
+			sync_access();
 		}
-		spin_unlock_irq(&tstats_lock);
 		break;
 	case '1':
-		spin_lock_irq(&tstats_lock);
-		if (tstats_status == TSTATS_INACTIVE) {
-			tstats_status = TSTATS_RESET;
-			memset(tstats, 0, sizeof(tstats));
-			tstats_time = ktime_get();
-			tstats_status = TSTATS_ACTIVE;
+		if (!active) {
+			reset_entries();
+			time_start = ktime_get();
+			active = 1;
 		}
-		spin_unlock_irq(&tstats_lock);
 		break;
 	default:
 		count = -EINVAL;
 	}
+	mutex_unlock(&show_mutex);
 
 	return count;
 }
@@ -228,12 +388,19 @@ static struct file_operations tstats_fop
 	.release	= seq_release,
 };
 
-static int __init init_tstats(void)
+void __init init_timer_stats(void)
 {
-	struct proc_dir_entry *pe;
+	int cpu;
 
-	pe = create_proc_entry("timer_stats", 0666, NULL);
+	for_each_possible_cpu(cpu)
+		spin_lock_init(&per_cpu(lookup_lock, cpu));
+}
+
+static int __init init_tstats_procfs(void)
+{
+	struct proc_dir_entry *pe;
 
+	pe = create_proc_entry("timer_stats", 0644, NULL);
 	if (!pe)
 		return -ENOMEM;
 
@@ -241,4 +408,4 @@ static int __init init_tstats(void)
 
 	return 0;
 }
-module_init(init_tstats);
+__initcall(init_tstats_procfs);
diff -puN kernel/timer.c~updated-debugging-feature-timer-stats-fixes kernel/timer.c
--- a/kernel/timer.c~updated-debugging-feature-timer-stats-fixes
+++ a/kernel/timer.c
@@ -1716,6 +1716,8 @@ void __init init_timers(void)
 	int err = timer_cpu_notify(&timers_nb, (unsigned long)CPU_UP_PREPARE,
 				(void *)(long)smp_processor_id());
 
+	init_timer_stats();
+
 	BUG_ON(err == NOTIFY_BAD);
 	register_cpu_notifier(&timers_nb);
 	open_softirq(TIMER_SOFTIRQ, run_timer_softirq, NULL);
diff -puN include/linux/clockchips.h~updated-debugging-feature-timer-stats-fixes include/linux/clockchips.h
--- a/include/linux/clockchips.h~updated-debugging-feature-timer-stats-fixes
+++ a/include/linux/clockchips.h
@@ -12,6 +12,7 @@
 
 #include <linux/clocksource.h>
 #include <linux/interrupt.h>
+#include <linux/cpumask.h>
 
 struct clock_event_device;
 
@@ -102,6 +103,27 @@ static inline unsigned long div_sc(unsig
 	return (unsigned long) tmp;
 }
 
+#define MAX_CLOCK_EVENTS	4
+#define GLOBAL_CLOCK_EVENT	MAX_CLOCK_EVENTS
+
+struct event_descr {
+	struct clock_event_device *event;
+	unsigned int mode;
+	unsigned int real_caps;
+	struct irqaction action;
+};
+
+struct local_events {
+	int installed;
+	struct event_descr events[MAX_CLOCK_EVENTS];
+	struct clock_event_device *nextevt;
+	ktime_t	expires_next;
+};
+
+extern struct event_descr global_eventdevice;
+
+DECLARE_PER_CPU(struct local_events, local_eventdevices);
+
 /* Clock event layer functions */
 extern int register_local_clockevent(struct clock_event_device *);
 extern int register_global_clockevent(struct clock_event_device *);
@@ -120,6 +142,9 @@ extern void clockevents_set_broadcast(st
 extern void clockevents_set_global_broadcast(struct clock_event_device *evt,
 					     int broadcast);
 extern int clockevents_register_broadcast(void (*fun)(cpumask_t *mask));
+extern cpumask_t tick_broadcast_mask;
+extern cpumask_t event_broadcast_mask;
+
 #else
 static inline void clockevents_set_broadcast(struct clock_event_device *evt,
 					     int broadcast)
diff -puN kernel/time/clockevents.c~updated-debugging-feature-timer-stats-fixes kernel/time/clockevents.c
--- a/kernel/time/clockevents.c~updated-debugging-feature-timer-stats-fixes
+++ a/kernel/time/clockevents.c
@@ -35,25 +35,8 @@
 #include <linux/profile.h>
 #include <linux/sysdev.h>
 
-#define MAX_CLOCK_EVENTS	4
-#define GLOBAL_CLOCK_EVENT	MAX_CLOCK_EVENTS
-
-struct event_descr {
-	struct clock_event_device *event;
-	unsigned int mode;
-	unsigned int real_caps;
-	struct irqaction action;
-};
-
-struct local_events {
-	int installed;
-	struct event_descr events[MAX_CLOCK_EVENTS];
-	struct clock_event_device *nextevt;
-	ktime_t	expires_next;
-};
-
 /* Variables related to the global event device */
-static __read_mostly struct event_descr global_eventdevice;
+__read_mostly struct event_descr global_eventdevice;
 
 /*
  * Lock to protect the above.
@@ -65,7 +48,7 @@ static __read_mostly struct event_descr 
 static DEFINE_SPINLOCK(events_lock);
 
 /* Variables related to the per cpu local event devices */
-static DEFINE_PER_CPU(struct local_events, local_eventdevices);
+DEFINE_PER_CPU(struct local_events, local_eventdevices);
 
 #ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
 static void clockevents_check_broadcast(struct event_descr *descr);
@@ -522,8 +505,8 @@ int clockevents_set_next_event(ktime_t e
 
 #ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
 
-static cpumask_t global_event_broadcast;
-static cpumask_t local_event_broadcast;
+cpumask_t tick_broadcast_mask;
+cpumask_t event_broadcast_mask;
 static void (*broadcast_function)(cpumask_t *mask);
 static void (*global_event_handler)(struct pt_regs *regs);
 
@@ -535,13 +518,13 @@ static void (*global_event_handler)(stru
 static void clockevents_reprogram_broadcast(void)
 {
 	struct clock_event_device *glblevt = global_eventdevice.event;
-	struct local_events *dev;
 	ktime_t expires = { .tv64 = KTIME_MAX };
+	struct local_events *dev;
 	int64_t delta;
 	int cpu;
 
-	for (cpu = first_cpu(local_event_broadcast); cpu != NR_CPUS;
-	     cpu = next_cpu(cpu, local_event_broadcast)) {
+	for (cpu = first_cpu(event_broadcast_mask); cpu != NR_CPUS;
+	     cpu = next_cpu(cpu, event_broadcast_mask)) {
 		dev = &per_cpu(local_eventdevices, cpu);
 		if (dev->expires_next.tv64 < expires.tv64)
 			expires = dev->expires_next;
@@ -571,10 +554,10 @@ void clockevents_set_broadcast(struct cl
 	spin_lock_irqsave(&events_lock, flags);
 
 	if (broadcast) {
-		cpu_set(cpu, local_event_broadcast);
+		cpu_set(cpu, event_broadcast_mask);
 		evt->set_mode(CLOCK_EVT_SHUTDOWN, evt);
 	} else {
-		cpu_clear(cpu, local_event_broadcast);
+		cpu_clear(cpu, event_broadcast_mask);
 		evt->set_mode(CLOCK_EVT_ONESHOT, evt);
 		if (devices->expires_next.tv64 != KTIME_MAX)
 			clockevents_set_next_event(devices->expires_next, 1);
@@ -600,14 +583,14 @@ void clockevents_set_global_broadcast(st
 	spin_lock_irqsave(&events_lock, flags);
 
 	if (broadcast) {
-		if (!cpu_isset(cpu, global_event_broadcast)) {
-			cpu_set(cpu, global_event_broadcast);
+		if (!cpu_isset(cpu, tick_broadcast_mask)) {
+			cpu_set(cpu, tick_broadcast_mask);
 			if (devices->nextevt != evt)
 				evt->set_mode(CLOCK_EVT_SHUTDOWN, evt);
 		}
 	} else {
-		if (cpu_isset(cpu, global_event_broadcast)) {
-			cpu_clear(cpu, global_event_broadcast);
+		if (cpu_isset(cpu, tick_broadcast_mask)) {
+			cpu_clear(cpu, tick_broadcast_mask);
 			if (devices->nextevt != evt)
 				evt->set_mode(CLOCK_EVT_PERIODIC, evt);
 		}
@@ -623,7 +606,7 @@ static void handle_tick_broadcast(struct
 {
 	/* Call the original handler global tick handler */
 	global_event_handler(regs);
-	broadcast_function(&global_event_broadcast);
+	broadcast_function(&tick_broadcast_mask);
 }
 
 /*
@@ -638,8 +621,8 @@ static void handle_nextevt_broadcast(str
 
 	spin_lock(&events_lock);
 	/* Find all expired events */
-	for (cpu = first_cpu(local_event_broadcast); cpu != NR_CPUS;
-	     cpu = next_cpu(cpu, local_event_broadcast)) {
+	for (cpu = first_cpu(event_broadcast_mask); cpu != NR_CPUS;
+	     cpu = next_cpu(cpu, event_broadcast_mask)) {
 		devices = &per_cpu(local_eventdevices, cpu);
 		if (devices->expires_next.tv64 <= now.tv64) {
 			devices->expires_next.tv64 = KTIME_MAX;
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
debug-add-sysrq_always_enabled-boot-option.patch
lockdep-filter-off-by-default.patch
lockdep-improve-verbose-messages.patch
lockdep-improve-lockdep_reset.patch
lockdep-clean-up-very_verbose-define.patch
lockdep-use-chain-hash-on-config_debug_lockdep-too.patch
lockdep-print-irq-trace-info-on-asserts.patch
lockdep-fix-possible-races-while-disabling-lock-debugging.patch
optimize-calc_load.patch
acpi-i686-x86_64-fix-laptop-bootup-hang-in-init_acpi.patch
revert-i386-fix-the-verify_quirk_intel_irqbalance.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
convert-i386-pda-code-to-use-%fs.patch
convert-i386-pda-code-to-use-%fs-fixes.patch
genapic-optimize-fix-apic-mode-setup-2.patch
genapic-always-use-physical-delivery-mode-on-8-cpus.patch
genapic-remove-es7000-workaround.patch
genapic-remove-clustered-apic-mode.patch
genapic-default-to-physical-mode-on-hotplug-cpu-kernels.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
gtod-uninline-jiffiesh.patch
gtod-fix-multiple-conversion-bugs-in-msecs_to_jiffies.patch
gtod-fix-timeout-overflow.patch
gtod-persistent-clock-support-core.patch
gtod-persistent-clock-support-i386.patch
dynticks-uninline-irq_enter.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
hrtimers-namespace-and-enum-cleanup.patch
hrtimers-clean-up-locking.patch
hrtimers-add-state-tracking.patch
hrtimers-clean-up-callback-tracking.patch
hrtimers-move-and-add-documentation.patch
acpi-include-fix.patch
acpi-keep-track-of-timer-broadcast.patch
acpi-add-state-propagation-for-dynamic-broadcasting.patch
acpi-cleanups-allow-early-access-to-pmtimer.patch
i386-apic-clean-up-the-apic-code.patch
clockevents-core.patch
clockevents-i386-drivers.patch
clockevents-i386-hpet-driver.patch
i386-apic-rework-and-fix-local-apic-calibration.patch
high-res-timers-core.patch
high-res-timers-core-do-itimer-rearming-in-process-context.patch
high-res-timers-allow-tsc-clocksource-if-pmtimer-present.patch
dynticks-core.patch
dynticks-add-nohz-stats-to-proc-stat.patch
dynticks-i386-support-idle-handler-callbacks.patch
dynticks-i386-prepare-nmi-watchdog.patch
high-res-timers-dynticks-i386-support-enable-in-kconfig.patch
debugging-feature-add-proc-timer_stat.patch
debugging-feature-proc-timer_list.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
sched-cleanup-remove-task_t-convert-to-struct-task_struct-prefetch.patch
detect-atomic-counter-underflows.patch
debug-shared-irqs.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
vdso-print-fatal-signals.patch
vdso-improve-print_fatal_signals-support-by-adding-memory-maps.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
lockdep-show-held-locks-when-showing-a-stackdump-fix.patch
lockdep-show-held-locks-when-showing-a-stackdump-fix-2.patch
kmap_atomic-debugging.patch

