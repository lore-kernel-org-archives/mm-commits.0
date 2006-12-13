From: akpm@osdl.org
Subject: + debugging-feature-add-proc-timer_stat.patch added to -mm tree
Date: Wed, 13 Dec 2006 14:44:40 -0800
Message-ID: <200612132244.kBDMieXl022916@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:54005 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788AbWLMW6d (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 17:58:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu, ak@suse.de, johnstul@us.ibm.com, tglx@linutronix.de, zippel@linux-m68k.org


The patch titled
     debugging feature: add /proc/timer_stat
has been added to the -mm tree.  Its filename is
     debugging-feature-add-proc-timer_stat.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: debugging feature: add /proc/timer_stat
From: Ingo Molnar <mingo@elte.hu>

Add /proc/timer_stats support: debugging feature to profile timer
expiration. Both the starting site, process/PID and the expiration
function is captured. This allows the quick identification of timer
event sources in a system.

Sample output:

# echo 1 > /proc/timer_stats
# cat /proc/timer_stats
Timer Stats Version: v0.1
Sample period: 4.010 s
  24,     0 swapper          hrtimer_stop_sched_tick (hrtimer_sched_tick)
  11,     0 swapper          sk_reset_timer (tcp_delack_timer)
   6,     0 swapper          hrtimer_stop_sched_tick (hrtimer_sched_tick)
   2,     1 swapper          queue_delayed_work_on (delayed_work_timer_fn)
  17,     0 swapper          hrtimer_restart_sched_tick (hrtimer_sched_tick)
   2,     1 swapper          queue_delayed_work_on (delayed_work_timer_fn)
   4,  2050 pcscd            do_nanosleep (hrtimer_wakeup)
   5,  4179 sshd             sk_reset_timer (tcp_write_timer)
   4,  2248 yum-updatesd     schedule_timeout (process_timeout)
  18,     0 swapper          hrtimer_restart_sched_tick (hrtimer_sched_tick)
   3,     0 swapper          sk_reset_timer (tcp_delack_timer)
   1,     1 swapper          neigh_table_init_no_netlink (neigh_periodic_timer)
   2,     1 swapper          e1000_up (e1000_watchdog)
   1,     1 init             schedule_timeout (process_timeout)
100 total events, 25.24 events/sec

[ cleanups and hrtimers support from Thomas Gleixner <tglx@linutronix.de> ]

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/hrtimer/timer_stats.txt |   68 +++
 include/linux/hrtimer.h               |   53 +++
 include/linux/timer.h                 |   55 +++
 kernel/hrtimer.c                      |   26 +
 kernel/time/Makefile                  |    3 
 kernel/time/timer_stats.c             |  411 ++++++++++++++++++++++++
 kernel/timer.c                        |   31 +
 kernel/workqueue.c                    |    7 
 lib/Kconfig.debug                     |   11 
 9 files changed, 659 insertions(+), 6 deletions(-)

diff -puN /dev/null Documentation/hrtimer/timer_stats.txt
--- /dev/null
+++ a/Documentation/hrtimer/timer_stats.txt
@@ -0,0 +1,68 @@
+timer_stats - timer usage statistics
+------------------------------------
+
+timer_stats is a debugging facility to make the timer (ab)usage in a Linux
+system visible to kernel and userspace developers. It is not intended for
+production usage as it adds significant overhead to the (hr)timer code and the
+(hr)timer data structures.
+
+timer_stats should be used by kernel and userspace developers to verify that
+their code does not make unduly use of timers. This helps to avoid unnecessary
+wakeups, which should be avoided to optimize power consumption.
+
+It can be enabled by CONFIG_TIMER_STATS in the "Kernel hacking" configuration
+section.
+
+timer_stats collects information about the timer events which are fired in a
+Linux system over a sample period:
+
+- the pid of the task(process) which initialized the timer
+- the name of the process which initialized the timer
+- the function where the timer was intialized
+- the callback function which is associated to the timer
+- the number of events (callbacks)
+
+timer_stats adds an entry to /proc: /proc/timer_stats
+
+This entry is used to control the statistics functionality and to read out the
+sampled information.
+
+The timer_stats functionality is inactive on bootup.
+
+To activate a sample period issue:
+# echo 1 >/proc/timer_stats
+
+To stop a sample period issue:
+# echo 0 >/proc/timer_stats
+
+The statistics can be retrieved by:
+# cat /proc/timer_stats
+
+The readout of /proc/timer_stats automatically disables sampling. The sampled
+information is kept until a new sample period is started. This allows multiple
+readouts.
+
+Sample output of /proc/timer_stats:
+
+Timerstats sample period: 3.888770 s
+  12,     0 swapper          hrtimer_stop_sched_tick (hrtimer_sched_tick)
+  15,     1 swapper          hcd_submit_urb (rh_timer_func)
+   4,   959 kedac            schedule_timeout (process_timeout)
+   1,     0 swapper          page_writeback_init (wb_timer_fn)
+  28,     0 swapper          hrtimer_stop_sched_tick (hrtimer_sched_tick)
+  22,  2948 IRQ 4            tty_flip_buffer_push (delayed_work_timer_fn)
+   3,  3100 bash             schedule_timeout (process_timeout)
+   1,     1 swapper          queue_delayed_work_on (delayed_work_timer_fn)
+   1,     1 swapper          queue_delayed_work_on (delayed_work_timer_fn)
+   1,     1 swapper          neigh_table_init_no_netlink (neigh_periodic_timer)
+   1,  2292 ip               __netdev_watchdog_up (dev_watchdog)
+   1,    23 events/1         do_cache_clean (delayed_work_timer_fn)
+90 total events, 30.0 events/sec
+
+The first column is the number of events, the second column the pid, the third
+column is the name of the process. The forth column shows the function which
+initialized the timer and in parantheses the callback function which was
+executed on expiry.
+
+    Thomas, Ingo
+
diff -puN include/linux/hrtimer.h~debugging-feature-add-proc-timer_stat include/linux/hrtimer.h
--- a/include/linux/hrtimer.h~debugging-feature-add-proc-timer_stat
+++ a/include/linux/hrtimer.h
@@ -102,8 +102,14 @@ enum hrtimer_cb_mode {
  * @cb_mode:	high resolution timer feature to select the callback execution
  *		 mode
  * @cb_entry:	list head to enqueue an expired timer into the callback list
+ * @start_site:	timer statistics field to store the site where the timer
+ *		was started
+ * @start_comm: timer statistics field to store the name of the process which
+ *		started the timer
+ * @start_pid: timer statistics field to store the pid of the task which
+ *		started the timer
  *
- * The hrtimer structure must be initialized by init_hrtimer_#CLOCKTYPE()
+ * The hrtimer structure must be initialized by hrtimer_init()
  */
 struct hrtimer {
 	struct rb_node			node;
@@ -115,6 +121,11 @@ struct hrtimer {
 	enum hrtimer_cb_mode		cb_mode;
 	struct list_head		cb_entry;
 #endif
+#ifdef CONFIG_TIMER_STATS
+	void				*start_site;
+	char				start_comm[16];
+	int				start_pid;
+#endif
 };
 
 /**
@@ -333,4 +344,44 @@ static inline void show_no_hz_stats(stru
 /* Bootup initialization: */
 extern void __init hrtimers_init(void);
 
+/*
+ * Timer-statistics info:
+ */
+#ifdef CONFIG_TIMER_STATS
+
+extern void timer_stats_update_stats(void *timer, pid_t pid, void *startf,
+				     void *timerf, char * comm);
+
+static inline void timer_stats_account_hrtimer(struct hrtimer *timer)
+{
+	timer_stats_update_stats(timer, timer->start_pid, timer->start_site,
+				 timer->function, timer->start_comm);
+}
+
+extern void __timer_stats_hrtimer_set_start_info(struct hrtimer *timer,
+						 void *addr);
+
+static inline void timer_stats_hrtimer_set_start_info(struct hrtimer *timer)
+{
+	__timer_stats_hrtimer_set_start_info(timer, __builtin_return_address(0));
+}
+
+static inline void timer_stats_hrtimer_clear_start_info(struct hrtimer *timer)
+{
+	timer->start_site = NULL;
+}
+#else
+static inline void timer_stats_account_hrtimer(struct hrtimer *timer)
+{
+}
+
+static inline void timer_stats_hrtimer_set_start_info(struct hrtimer *timer)
+{
+}
+
+static inline void timer_stats_hrtimer_clear_start_info(struct hrtimer *timer)
+{
+}
+#endif
+
 #endif
diff -puN include/linux/timer.h~debugging-feature-add-proc-timer_stat include/linux/timer.h
--- a/include/linux/timer.h~debugging-feature-add-proc-timer_stat
+++ a/include/linux/timer.h
@@ -2,6 +2,7 @@
 #define _LINUX_TIMER_H
 
 #include <linux/list.h>
+#include <linux/ktime.h>
 #include <linux/spinlock.h>
 #include <linux/stddef.h>
 
@@ -15,6 +16,11 @@ struct timer_list {
 	unsigned long data;
 
 	struct tvec_t_base_s *base;
+#ifdef CONFIG_TIMER_STATS
+	void *start_site;
+	char start_comm[16];
+	int start_pid;
+#endif
 };
 
 extern struct tvec_t_base_s boot_tvec_bases;
@@ -73,6 +79,55 @@ extern unsigned long next_timer_interrup
  */
 extern unsigned long get_next_timer_interrupt(unsigned long now);
 
+/*
+ * Timer-statistics info:
+ */
+#ifdef CONFIG_TIMER_STATS
+
+extern void init_timer_stats(void);
+
+extern void timer_stats_update_stats(void *timer, pid_t pid, void *startf,
+				     void *timerf, char * comm);
+
+static inline void timer_stats_account_timer(struct timer_list *timer)
+{
+	timer_stats_update_stats(timer, timer->start_pid, timer->start_site,
+				 timer->function, timer->start_comm);
+}
+
+extern void __timer_stats_timer_set_start_info(struct timer_list *timer,
+					       void *addr);
+
+static inline void timer_stats_timer_set_start_info(struct timer_list *timer)
+{
+	__timer_stats_timer_set_start_info(timer, __builtin_return_address(0));
+}
+
+static inline void timer_stats_timer_clear_start_info(struct timer_list *timer)
+{
+	timer->start_site = NULL;
+}
+#else
+static inline void init_timer_stats(void)
+{
+}
+
+static inline void timer_stats_account_timer(struct timer_list *timer)
+{
+}
+
+static inline void timer_stats_timer_set_start_info(struct timer_list *timer)
+{
+}
+
+static inline void timer_stats_timer_clear_start_info(struct timer_list *timer)
+{
+}
+#endif
+
+extern void delayed_work_timer_fn(unsigned long __data);
+
+
 /***
  * add_timer - start a timer
  * @timer: the timer to be added
diff -puN kernel/hrtimer.c~debugging-feature-add-proc-timer_stat kernel/hrtimer.c
--- a/kernel/hrtimer.c~debugging-feature-add-proc-timer_stat
+++ a/kernel/hrtimer.c
@@ -984,6 +984,18 @@ static inline void hrtimer_resume_jiffy_
 
 #endif /* CONFIG_HIGH_RES_TIMERS */
 
+#ifdef CONFIG_TIMER_STATS
+void __timer_stats_hrtimer_set_start_info(struct hrtimer *timer, void *addr)
+{
+	if (timer->start_site)
+		return;
+
+	timer->start_site = addr;
+	memcpy(timer->start_comm, current->comm, TASK_COMM_LEN);
+	timer->start_pid = current->pid;
+}
+#endif
+
 /*
  * Timekeeping resumed notification
  */
@@ -1152,6 +1164,7 @@ remove_hrtimer(struct hrtimer *timer, st
 		 * reprogramming happens in the interrupt handler. This is a
 		 * rare case and less expensive than a smp call.
 		 */
+		timer_stats_hrtimer_clear_start_info(timer);
 		reprogram = base->cpu_base == &__get_cpu_var(hrtimer_bases);
 		__remove_hrtimer(timer, base, HRTIMER_STATE_INACTIVE,
 				 reprogram);
@@ -1200,6 +1213,8 @@ hrtimer_start(struct hrtimer *timer, kti
 	}
 	timer->expires = tim;
 
+	timer_stats_hrtimer_set_start_info(timer);
+
 	enqueue_hrtimer(timer, new_base, base == new_base);
 
 	unlock_hrtimer_base(timer, &flags);
@@ -1332,6 +1347,12 @@ void hrtimer_init(struct hrtimer *timer,
 
 	timer->base = &cpu_base->clock_base[clock_id];
 	hrtimer_init_timer_hres(timer);
+
+#ifdef CONFIG_TIMER_STATS
+	timer->start_site = NULL;
+	timer->start_pid = -1;
+	memset(timer->start_comm, 0, TASK_COMM_LEN);
+#endif
 }
 EXPORT_SYMBOL_GPL(hrtimer_init);
 
@@ -1412,6 +1433,7 @@ void hrtimer_interrupt(void)
 
 			__remove_hrtimer(timer, base,
 					 HRTIMER_STATE_CALLBACK, 0);
+			timer_stats_account_hrtimer(timer);
 
 			/*
 			 * Note: We clear the CALLBACK bit after
@@ -1456,6 +1478,8 @@ static void run_hrtimer_softirq(struct s
 		timer = list_entry(cpu_base->cb_pending.next,
 				   struct hrtimer, cb_entry);
 
+		timer_stats_account_hrtimer(timer);
+
 		fn = timer->function;
 		__remove_hrtimer(timer, timer->base, HRTIMER_STATE_CALLBACK, 0);
 		spin_unlock_irq(&cpu_base->lock);
@@ -1512,6 +1536,8 @@ static inline void run_hrtimer_queue(str
 		if (base->softirq_time.tv64 <= timer->expires.tv64)
 			break;
 
+		timer_stats_account_hrtimer(timer);
+
 		fn = timer->function;
 		__remove_hrtimer(timer, base, HRTIMER_STATE_CALLBACK, 0);
 		spin_unlock_irq(&cpu_base->lock);
diff -puN kernel/time/Makefile~debugging-feature-add-proc-timer_stat kernel/time/Makefile
--- a/kernel/time/Makefile~debugging-feature-add-proc-timer_stat
+++ a/kernel/time/Makefile
@@ -1,3 +1,4 @@
 obj-y += ntp.o clocksource.o jiffies.o
 
-obj-$(CONFIG_GENERIC_CLOCKEVENTS) += clockevents.o
+obj-$(CONFIG_GENERIC_CLOCKEVENTS)	+= clockevents.o
+obj-$(CONFIG_TIMER_STATS)		+= timer_stats.o
diff -puN /dev/null kernel/time/timer_stats.c
--- /dev/null
+++ a/kernel/time/timer_stats.c
@@ -0,0 +1,411 @@
+/*
+ * kernel/time/timer_stats.c
+ *
+ * Collect timer usage statistics.
+ *
+ * Copyright(C) 2006, Red Hat, Inc., Ingo Molnar
+ * Copyright(C) 2006 Timesys Corp., Thomas Gleixner <tglx@timesys.com>
+ *
+ * timer_stats is based on timer_top, a similar functionality which was part of
+ * Con Kolivas dyntick patch set. It was developed by Daniel Petrini at the
+ * Instituto Nokia de Tecnologia - INdT - Manaus. timer_top's design was based
+ * on dynamic allocation of the statistics entries and linear search based
+ * lookup combined with a global lock, rather than the static array, hash
+ * and per-CPU locking which is used by timer_stats. It was written for the
+ * pre hrtimer kernel code and therefore did not take hrtimers into account.
+ * Nevertheless it provided the base for the timer_stats implementation and
+ * was a helpful source of inspiration. Kudos to Daniel and the Nokia folks
+ * for this effort.
+ *
+ * timer_top.c is
+ *	Copyright (C) 2005 Instituto Nokia de Tecnologia - INdT - Manaus
+ *	Written by Daniel Petrini <d.pensator@gmail.com>
+ *	timer_top.c was released under the GNU General Public License version 2
+ *
+ * We export the addresses and counting of timer functions being called,
+ * the pid and cmdline from the owner process if applicable.
+ *
+ * Start/stop data collection:
+ * # echo 1[0] >/proc/timer_stats
+ *
+ * Display the information collected so far:
+ * # cat /proc/timer_stats
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/proc_fs.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/sched.h>
+#include <linux/seq_file.h>
+#include <linux/kallsyms.h>
+
+#include <asm/uaccess.h>
+
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
+	void			*timer;
+	void			*start_func;
+	void			*expire_func;
+	pid_t			pid;
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
+	char			comm[TASK_COMM_LEN + 1];
+
+} ____cacheline_aligned_in_smp;
+
+/*
+ * Spinlock protecting the tables - not taken during lookup:
+ */
+static DEFINE_SPINLOCK(table_lock);
+
+/*
+ * Per-CPU lookup locks for fast hash lookup:
+ */
+static DEFINE_PER_CPU(spinlock_t, lookup_lock);
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
+
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
+
+/**
+ * timer_stats_update_stats - Update the statistics for a timer.
+ * @timer:	pointer to either a timer_list or a hrtimer
+ * @pid:	the pid of the task which set up the timer
+ * @startf:	pointer to the function which did the timer setup
+ * @timerf:	pointer to the timer callback function of the timer
+ * @comm:	name of the process which set up the timer
+ *
+ * When the timer is already registered, then the event counter is
+ * incremented. Otherwise the timer is registered in a free slot.
+ */
+void timer_stats_update_stats(void *timer, pid_t pid, void *startf,
+			      void *timerf, char * comm)
+{
+	/*
+	 * It doesnt matter which lock we take:
+	 */
+	spinlock_t *lock = &per_cpu(lookup_lock, raw_smp_processor_id());
+	struct entry *entry, input;
+	unsigned long flags;
+
+	input.timer = timer;
+	input.start_func = startf;
+	input.expire_func = timerf;
+	input.pid = pid;
+
+	spin_lock_irqsave(lock, flags);
+	if (!active)
+		goto out_unlock;
+
+	entry = tstat_lookup(&input, comm);
+	if (likely(entry))
+		entry->count++;
+	else
+		atomic_inc(&overflow_count);
+
+ out_unlock:
+	spin_unlock_irqrestore(lock, flags);
+}
+
+static void print_name_offset(struct seq_file *m, unsigned long addr)
+{
+	char namebuf[KSYM_NAME_LEN+1];
+	unsigned long size, offset;
+	const char *sym_name;
+	char *modname;
+
+	sym_name = kallsyms_lookup(addr, &size, &offset, &modname, namebuf);
+	if (sym_name)
+		seq_printf(m, "%s", sym_name);
+	else
+		seq_printf(m, "<%p>", (void *)addr);
+}
+
+static int tstats_show(struct seq_file *m, void *v)
+{
+	struct timespec period;
+	struct entry *entry;
+	unsigned long ms;
+	long events = 0;
+	ktime_t time;
+	int i;
+
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
+
+		print_name_offset(m, (unsigned long)entry->start_func);
+		seq_puts(m, " (");
+		print_name_offset(m, (unsigned long)entry->expire_func);
+		seq_puts(m, ")\n");
+
+		events += entry->count;
+	}
+
+	ms += period.tv_sec * 1000;
+	if (!ms)
+		ms = 1;
+
+	if (events && period.tv_sec)
+		seq_printf(m, "%ld total events, %ld.%ld events/sec\n", events,
+			   events / period.tv_sec, events * 1000 / ms);
+	else
+		seq_printf(m, "%ld total events\n", events);
+
+	mutex_unlock(&show_mutex);
+
+	return 0;
+}
+
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
+static ssize_t tstats_write(struct file *file, const char __user *buf,
+			    size_t count, loff_t *offs)
+{
+	char ctl[2];
+
+	if (count != 2 || *offs)
+		return -EINVAL;
+
+	if (copy_from_user(ctl, buf, count))
+		return -EFAULT;
+
+	mutex_lock(&show_mutex);
+	switch (ctl[0]) {
+	case '0':
+		if (active) {
+			active = 0;
+			time_stop = ktime_get();
+			sync_access();
+		}
+		break;
+	case '1':
+		if (!active) {
+			reset_entries();
+			time_start = ktime_get();
+			active = 1;
+		}
+		break;
+	default:
+		count = -EINVAL;
+	}
+	mutex_unlock(&show_mutex);
+
+	return count;
+}
+
+static int tstats_open(struct inode *inode, struct file *filp)
+{
+	return single_open(filp, tstats_show, NULL);
+}
+
+static struct file_operations tstats_fops = {
+	.open		= tstats_open,
+	.read		= seq_read,
+	.write		= tstats_write,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
+void __init init_timer_stats(void)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		spin_lock_init(&per_cpu(lookup_lock, cpu));
+}
+
+static int __init init_tstats_procfs(void)
+{
+	struct proc_dir_entry *pe;
+
+	pe = create_proc_entry("timer_stats", 0644, NULL);
+	if (!pe)
+		return -ENOMEM;
+
+	pe->proc_fops = &tstats_fops;
+
+	return 0;
+}
+__initcall(init_tstats_procfs);
diff -puN kernel/timer.c~debugging-feature-add-proc-timer_stat kernel/timer.c
--- a/kernel/timer.c~debugging-feature-add-proc-timer_stat
+++ a/kernel/timer.c
@@ -34,6 +34,7 @@
 #include <linux/cpu.h>
 #include <linux/syscalls.h>
 #include <linux/delay.h>
+#include <linux/kallsyms.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -262,6 +263,18 @@ static void internal_add_timer(tvec_base
 	list_add_tail(&timer->entry, vec);
 }
 
+#ifdef CONFIG_TIMER_STATS
+void __timer_stats_timer_set_start_info(struct timer_list *timer, void *addr)
+{
+	if (timer->start_site)
+		return;
+
+	timer->start_site = addr;
+	memcpy(timer->start_comm, current->comm, TASK_COMM_LEN);
+	timer->start_pid = current->pid;
+}
+#endif
+
 /**
  * init_timer - initialize a timer.
  * @timer: the timer to be initialized
@@ -273,11 +286,16 @@ void fastcall init_timer(struct timer_li
 {
 	timer->entry.next = NULL;
 	timer->base = __raw_get_cpu_var(tvec_bases);
+#ifdef CONFIG_TIMER_STATS
+	timer->start_site = NULL;
+	timer->start_pid = -1;
+	memset(timer->start_comm, 0, TASK_COMM_LEN);
+#endif
 }
 EXPORT_SYMBOL(init_timer);
 
 static inline void detach_timer(struct timer_list *timer,
-					int clear_pending)
+				int clear_pending)
 {
 	struct list_head *entry = &timer->entry;
 
@@ -324,6 +342,7 @@ int __mod_timer(struct timer_list *timer
 	unsigned long flags;
 	int ret = 0;
 
+	timer_stats_timer_set_start_info(timer);
 	BUG_ON(!timer->function);
 
 	base = lock_timer_base(timer, &flags);
@@ -374,6 +393,7 @@ void add_timer_on(struct timer_list *tim
 	tvec_base_t *base = per_cpu(tvec_bases, cpu);
   	unsigned long flags;
 
+	timer_stats_timer_set_start_info(timer);
   	BUG_ON(timer_pending(timer) || !timer->function);
 	spin_lock_irqsave(&base->lock, flags);
 	timer->base = base;
@@ -406,6 +426,7 @@ int mod_timer(struct timer_list *timer, 
 {
 	BUG_ON(!timer->function);
 
+	timer_stats_timer_set_start_info(timer);
 	/*
 	 * This is a common optimization triggered by the
 	 * networking code - if the timer is re-modified
@@ -436,6 +457,7 @@ int del_timer(struct timer_list *timer)
 	unsigned long flags;
 	int ret = 0;
 
+	timer_stats_timer_clear_start_info(timer);
 	if (timer_pending(timer)) {
 		base = lock_timer_base(timer, &flags);
 		if (timer_pending(timer)) {
@@ -569,6 +591,8 @@ static inline void __run_timers(tvec_bas
  			fn = timer->function;
  			data = timer->data;
 
+			timer_stats_account_timer(timer);
+
 			set_running_timer(base, timer);
 			detach_timer(timer, 1);
 			spin_unlock_irq(&base->lock);
@@ -1254,7 +1278,8 @@ static void run_timer_softirq(struct sof
 {
 	tvec_base_t *base = __get_cpu_var(tvec_bases);
 
- 	hrtimer_run_queues();
+	hrtimer_run_queues();
+
 	if (time_after_eq(jiffies, base->timer_jiffies))
 		__run_timers(base);
 }
@@ -1693,6 +1718,8 @@ void __init init_timers(void)
 	int err = timer_cpu_notify(&timers_nb, (unsigned long)CPU_UP_PREPARE,
 				(void *)(long)smp_processor_id());
 
+	init_timer_stats();
+
 	BUG_ON(err == NOTIFY_BAD);
 	register_cpu_notifier(&timers_nb);
 	open_softirq(TIMER_SOFTIRQ, run_timer_softirq, NULL);
diff -puN kernel/workqueue.c~debugging-feature-add-proc-timer_stat kernel/workqueue.c
--- a/kernel/workqueue.c~debugging-feature-add-proc-timer_stat
+++ a/kernel/workqueue.c
@@ -218,7 +218,7 @@ int fastcall queue_work(struct workqueue
 }
 EXPORT_SYMBOL_GPL(queue_work);
 
-static void delayed_work_timer_fn(unsigned long __data)
+void delayed_work_timer_fn(unsigned long __data)
 {
 	struct delayed_work *dwork = (struct delayed_work *)__data;
 	struct workqueue_struct *wq = get_wq_data(&dwork->work);
@@ -245,6 +245,7 @@ int fastcall queue_delayed_work(struct w
 	struct timer_list *timer = &dwork->timer;
 	struct work_struct *work = &dwork->work;
 
+	timer_stats_timer_set_start_info(timer);
 	if (delay == 0)
 		return queue_work(wq, work);
 
@@ -593,8 +594,10 @@ EXPORT_SYMBOL(schedule_work);
  * After waiting for a given time this puts a job in the kernel-global
  * workqueue.
  */
-int fastcall schedule_delayed_work(struct delayed_work *dwork, unsigned long delay)
+int fastcall schedule_delayed_work(struct delayed_work *dwork,
+					unsigned long delay)
 {
+	timer_stats_timer_set_start_info(&dwork->timer);
 	return queue_delayed_work(keventd_wq, dwork, delay);
 }
 EXPORT_SYMBOL(schedule_delayed_work);
diff -puN lib/Kconfig.debug~debugging-feature-add-proc-timer_stat lib/Kconfig.debug
--- a/lib/Kconfig.debug~debugging-feature-add-proc-timer_stat
+++ a/lib/Kconfig.debug
@@ -125,6 +125,17 @@ config SCHEDSTATS
 	  application, you can say N to avoid the very slight overhead
 	  this adds.
 
+config TIMER_STATS
+	bool "Collect kernel timers statistics"
+	depends on DEBUG_KERNEL && PROC_FS
+	help
+	  If you say Y here, additional code will be inserted into the
+	  timer routines to collect statistics about kernel timers being
+	  reprogrammed. The statistics can be read from /proc/timer_stats.
+	  The statistics collection is started by writing 1 to /proc/timer_stats,
+	  writing 0 stops it. This feature is useful to collect information
+	  about timer usage patterns in kernel and userspace.
+
 config DEBUG_SLAB
 	bool "Debug slab memory allocations"
 	depends on DEBUG_KERNEL && SLAB
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

