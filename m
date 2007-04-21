From: akpm@linux-foundation.org
Subject: + timer_stats-slimmed-down-using-statistics-infrastucture.patch added to -mm tree
Date: Fri, 20 Apr 2007 17:18:18 -0700
Message-ID: <200704210018.l3L0IJBN027188@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41945 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753678AbXDUATW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 20:19:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mp3@de.ibm.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     timer_stats slimmed down: using statistics infrastucture
has been added to the -mm tree.  Its filename is
     timer_stats-slimmed-down-using-statistics-infrastucture.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: timer_stats slimmed down: using statistics infrastucture
From: Martin Peschke <mp3@de.ibm.com>

This patch implements timer_stats based on the statistics infrastructure.

Here is some sample output, which even somewhat
resembles /proc/timer_stats.
(>80 char lines because of symbol names, sorry for line breaks).

It reads:
<statistic name> <basket> <hits> <label>

with label being:
<pid> <task name> <start_fn>(<stop_fn>)

[root@t2930041 timer_stats]# cat data
expired missed 0x0
expired - 5381   1019 multipathd       do_nanosleep (hrtimer_wakeup)
expired - 2707      1 swapper          queue_delayed_work_on
(delayed_work_timer_fn)
expired - 2707      1 swapper          queue_delayed_work_on
(delayed_work_timer_fn)
expired - 2707      1 swapper          queue_delayed_work_on
(delayed_work_timer_fn)
expired - 2707      1 swapper          queue_delayed_work_on
(delayed_work_timer_fn)
expired - 1353      1 swapper          neigh_table_init_no_netlink
(neigh_periodic_timer)
expired - 1083      0 swapper          page_writeback_init (wb_timer_fn)
expired - 1083   1021 multipathd       schedule_timeout
(process_timeout)
expired - 1081      1 init             schedule_timeout
(process_timeout)
expired - 677       1 swapper          neigh_table_init_no_netlink
(neigh_periodic_timer)
expired - 278       0 swapper          sk_reset_timer (tcp_delack_timer)
expired - 193       1 swapper          nfsd_export_init
(delayed_work_timer_fn)
expired - 181     975 syslogd          do_setitimer (it_real_fn)
expired - 104    1296 sshd             sk_reset_timer (tcp_write_timer)
expired - 90        1 swapper          ip_rt_init (rt_check_expire)
expired - 90     1244 crond            do_nanosleep (hrtimer_wakeup)
expired - 54      896 ip               __netdev_watchdog_up
(dev_watchdog)
expired - 44        1 swapper          inet_initpeers
(peer_check_expire)
expired - 44        0 swapper          addrconf_verify (addrconf_verify)
.
.
.
expired - 1      1368 sadc             schedule_timeout
(process_timeout)
expired - 1      1370 sadc             blk_plug_device
(blk_unplug_timeout)
expired - 1      1370 sadc             schedule_timeout
(process_timeout)

# cat /debug/timer_stats/definition
name=expired state=on units=timer/occurrence type=sparse entries=1024
data=[6920660.417313] started=[6920660.417313] stopped=[    0.000000]

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/timer_stats.c |  385 +++++-------------------------------
 kernel/timer.c            |    2 
 2 files changed, 59 insertions(+), 328 deletions(-)

diff -puN kernel/time/timer_stats.c~timer_stats-slimmed-down-using-statistics-infrastucture kernel/time/timer_stats.c
--- a/kernel/time/timer_stats.c~timer_stats-slimmed-down-using-statistics-infrastucture
+++ a/kernel/time/timer_stats.c
@@ -26,197 +26,95 @@
  * the pid and cmdline from the owner process if applicable.
  *
  * Start/stop data collection:
- * # echo 1[0] >/proc/timer_stats
+ * # echo state=on[off] > /debug/timer_stats/definition
  *
  * Display the information collected so far:
- * # cat /proc/timer_stats
+ * # cat /debug/timer_stats/data
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
 
-#include <linux/proc_fs.h>
 #include <linux/module.h>
-#include <linux/spinlock.h>
 #include <linux/sched.h>
 #include <linux/seq_file.h>
 #include <linux/kallsyms.h>
-
-#include <asm/uaccess.h>
+#include <linux/statistic.h>
 
 /*
  * This is our basic unit of interest: a timer expiry event identified
  * by the timer, its start/expire functions and the PID of the task that
  * started the timer. We count the number of times an event happens:
  */
-struct entry {
-	/*
-	 * Hash list:
-	 */
-	struct entry		*next;
-
-	/*
-	 * Hash keys:
-	 */
-	void			*timer;
-	void			*start_func;
-	void			*expire_func;
-	pid_t			pid;
-
-	/*
-	 * Number of timeout events:
-	 */
-	unsigned long		count;
-
+struct tstat_key {
+	void	*timer;
+	void	*start_func;
+	void	*expire_func;
+	pid_t	pid;
 	/*
 	 * We save the command-line string to preserve
 	 * this information past task exit:
 	 */
-	char			comm[TASK_COMM_LEN + 1];
-
-} ____cacheline_aligned_in_smp;
-
-/*
- * Spinlock protecting the tables - not taken during lookup:
- */
-static DEFINE_SPINLOCK(table_lock);
-
-/*
- * Per-CPU lookup locks for fast hash lookup:
- */
-static DEFINE_PER_CPU(spinlock_t, lookup_lock);
-
-/*
- * Mutex to serialize state changes with show-stats activities:
- */
-static DEFINE_MUTEX(show_mutex);
-
-/*
- * Collection status, active/inactive:
- */
-static int __read_mostly active;
-
-/*
- * Beginning/end timestamps of measurement:
- */
-static ktime_t time_start, time_stop;
-
-/*
- * tstat entry structs only get allocated while collection is
- * active and never freed during that time - this simplifies
- * things quite a bit.
- *
- * They get freed when a new collection period is started.
- */
-#define MAX_ENTRIES_BITS	10
-#define MAX_ENTRIES		(1UL << MAX_ENTRIES_BITS)
-
-static unsigned long nr_entries;
-static struct entry entries[MAX_ENTRIES];
-
-static atomic_t overflow_count;
-
-static void reset_entries(void)
-{
-	nr_entries = 0;
-	memset(entries, 0, sizeof(entries));
-	atomic_set(&overflow_count, 0);
-}
+	char	comm[TASK_COMM_LEN + 1];
+};
 
-static struct entry *alloc_entry(void)
+static void tstat_print_symbol(struct seq_file *m, unsigned long addr)
 {
-	if (nr_entries >= MAX_ENTRIES)
-		return NULL;
-
-	return entries + nr_entries++;
-}
-
-/*
- * The entries are in a hash-table, for fast lookup:
- */
-#define TSTAT_HASH_BITS		(MAX_ENTRIES_BITS - 1)
-#define TSTAT_HASH_SIZE		(1UL << TSTAT_HASH_BITS)
-#define TSTAT_HASH_MASK		(TSTAT_HASH_SIZE - 1)
-
-#define __tstat_hashfn(entry)						\
-	(((unsigned long)(entry)->timer       ^				\
-	  (unsigned long)(entry)->start_func  ^				\
-	  (unsigned long)(entry)->expire_func ^				\
-	  (unsigned long)(entry)->pid		) & TSTAT_HASH_MASK)
-
-#define tstat_hashentry(entry)	(tstat_hash_table + __tstat_hashfn(entry))
-
-static struct entry *tstat_hash_table[TSTAT_HASH_SIZE] __read_mostly;
+	char symname[KSYM_NAME_LEN+1];
 
-static int match_entries(struct entry *entry1, struct entry *entry2)
-{
-	return entry1->timer       == entry2->timer	  &&
-	       entry1->start_func  == entry2->start_func  &&
-	       entry1->expire_func == entry2->expire_func &&
-	       entry1->pid	   == entry2->pid;
+	if (lookup_symbol_name(addr, symname) < 0)
+		seq_printf(m, "<%p>", (void *)addr);
+	else
+		seq_printf(m, "%s", symname);
 }
 
-/*
- * Look up whether an entry matching this item is present
- * in the hash already. Must be called with irqs off and the
- * lookup lock held:
- */
-static struct entry *tstat_lookup(struct entry *entry, char *comm)
+static void tstat_label(struct statistic_interface *interface, int i,
+			void *_key, struct seq_file *m)
 {
-	struct entry **head, *curr, *prev;
+	struct tstat_key *key = _key;
 
-	head = tstat_hashentry(entry);
-	curr = *head;
+	seq_printf(m, "\t%5d %-16s ", key->pid, key->comm);
+	tstat_print_symbol(m, (unsigned long)key->start_func);
+	seq_puts(m, " (");
+	tstat_print_symbol(m, (unsigned long)key->expire_func);
+	seq_puts(m, ")");
+}
 
-	/*
-	 * The fastpath is when the entry is already hashed,
-	 * we do this with the lookup lock held, but with the
-	 * table lock not held:
-	 */
-	while (curr) {
-		if (match_entries(curr, entry))
-			return curr;
+enum tstat_enum {
+	TSTAT_EXPIRED,
+	_TSTAT_NUMBER,
+};
 
-		curr = curr->next;
+static struct statistic_info tstat_info[] = {
+	[TSTAT_EXPIRED] = {
+		.name	  = "expired",
+		.x_unit	  = "timer",
+		.y_unit	  = "occurrence",
+		.defaults = "type=sparse entries=1024",
+		.flags	  = STATISTIC_FLAGS_KEY,
+		.key_size = sizeof(struct tstat_key)
 	}
-	/*
-	 * Slowpath: allocate, set up and link a new hash entry:
-	 */
-	prev = NULL;
-	curr = *head;
-
-	spin_lock(&table_lock);
-	/*
-	 * Make sure we have not raced with another CPU:
-	 */
-	while (curr) {
-		if (match_entries(curr, entry))
-			goto out_unlock;
+};
 
-		prev = curr;
-		curr = curr->next;
-	}
+struct statistic tstat_stat[_TSTAT_NUMBER];
 
-	curr = alloc_entry();
-	if (curr) {
-		*curr = *entry;
-		curr->count = 0;
-		memcpy(curr->comm, comm, TASK_COMM_LEN);
-		if (prev)
-			prev->next = curr;
-		else
-			*head = curr;
-		curr->next = NULL;
-	}
- out_unlock:
-	spin_unlock(&table_lock);
+struct statistic_interface tstat_interface = {
+	.stat	= tstat_stat,
+	.info	= tstat_info,
+	.number	= _TSTAT_NUMBER,
+	.label	= tstat_label,
+};
 
-	return curr;
+static int __init tstat_init(void)
+{
+	statistic_create(&tstat_interface, "timer_stats");
+	return 0;
 }
+__initcall(tstat_init);
 
 /**
- * timer_stats_update_stats - Update the statistics for a timer.
+ * tstat_inc - Update the statistics for a timer.
  * @timer:	pointer to either a timer_list or a hrtimer
  * @pid:	the pid of the task which set up the timer
  * @startf:	pointer to the function which did the timer setup
@@ -229,179 +127,14 @@ static struct entry *tstat_lookup(struct
 void timer_stats_update_stats(void *timer, pid_t pid, void *startf,
 			      void *timerf, char * comm)
 {
-	/*
-	 * It doesnt matter which lock we take:
-	 */
-	spinlock_t *lock = &per_cpu(lookup_lock, raw_smp_processor_id());
-	struct entry *entry, input;
-	unsigned long flags;
-
-	input.timer = timer;
-	input.start_func = startf;
-	input.expire_func = timerf;
-	input.pid = pid;
-
-	spin_lock_irqsave(lock, flags);
-	if (!active)
-		goto out_unlock;
-
-	entry = tstat_lookup(&input, comm);
-	if (likely(entry))
-		entry->count++;
-	else
-		atomic_inc(&overflow_count);
-
- out_unlock:
-	spin_unlock_irqrestore(lock, flags);
-}
-
-static void print_name_offset(struct seq_file *m, unsigned long addr)
-{
-	char symname[KSYM_NAME_LEN+1];
-
-	if (lookup_symbol_name(addr, symname) < 0)
-		seq_printf(m, "<%p>", (void *)addr);
-	else
-		seq_printf(m, "%s", symname);
-}
-
-static int tstats_show(struct seq_file *m, void *v)
-{
-	struct timespec period;
-	struct entry *entry;
-	unsigned long ms;
-	long events = 0;
-	ktime_t time;
-	int i;
-
-	mutex_lock(&show_mutex);
-	/*
-	 * If still active then calculate up to now:
-	 */
-	if (active)
-		time_stop = ktime_get();
-
-	time = ktime_sub(time_stop, time_start);
-
-	period = ktime_to_timespec(time);
-	ms = period.tv_nsec / 1000000;
-
-	seq_puts(m, "Timer Stats Version: v0.1\n");
-	seq_printf(m, "Sample period: %ld.%03ld s\n", period.tv_sec, ms);
-	if (atomic_read(&overflow_count))
-		seq_printf(m, "Overflow: %d entries\n",
-			atomic_read(&overflow_count));
-
-	for (i = 0; i < nr_entries; i++) {
-		entry = entries + i;
-		seq_printf(m, "%4lu, %5d %-16s ",
-				entry->count, entry->pid, entry->comm);
-
-		print_name_offset(m, (unsigned long)entry->start_func);
-		seq_puts(m, " (");
-		print_name_offset(m, (unsigned long)entry->expire_func);
-		seq_puts(m, ")\n");
-
-		events += entry->count;
-	}
-
-	ms += period.tv_sec * 1000;
-	if (!ms)
-		ms = 1;
-
-	if (events && period.tv_sec)
-		seq_printf(m, "%ld total events, %ld.%ld events/sec\n", events,
-			   events / period.tv_sec, events * 1000 / ms);
-	else
-		seq_printf(m, "%ld total events\n", events);
-
-	mutex_unlock(&show_mutex);
-
-	return 0;
-}
-
-/*
- * After a state change, make sure all concurrent lookup/update
- * activities have stopped:
- */
-static void sync_access(void)
-{
-	unsigned long flags;
-	int cpu;
-
-	for_each_online_cpu(cpu) {
-		spin_lock_irqsave(&per_cpu(lookup_lock, cpu), flags);
-		/* nothing */
-		spin_unlock_irqrestore(&per_cpu(lookup_lock, cpu), flags);
-	}
-}
-
-static ssize_t tstats_write(struct file *file, const char __user *buf,
-			    size_t count, loff_t *offs)
-{
-	char ctl[2];
+	struct tstat_key key;
 
-	if (count != 2 || *offs)
-		return -EINVAL;
+	memset(&key, 0, sizeof(struct tstat_key)); /* FIXME: get rid of it? */
+	key.timer = timer;
+	key.start_func = startf;
+	key.expire_func = timerf;
+	key.pid = pid;
+	memcpy(key.comm, comm, TASK_COMM_LEN);
 
-	if (copy_from_user(ctl, buf, count))
-		return -EFAULT;
-
-	mutex_lock(&show_mutex);
-	switch (ctl[0]) {
-	case '0':
-		if (active) {
-			active = 0;
-			time_stop = ktime_get();
-			sync_access();
-		}
-		break;
-	case '1':
-		if (!active) {
-			reset_entries();
-			time_start = ktime_get();
-			active = 1;
-		}
-		break;
-	default:
-		count = -EINVAL;
-	}
-	mutex_unlock(&show_mutex);
-
-	return count;
-}
-
-static int tstats_open(struct inode *inode, struct file *filp)
-{
-	return single_open(filp, tstats_show, NULL);
-}
-
-static struct file_operations tstats_fops = {
-	.open		= tstats_open,
-	.read		= seq_read,
-	.write		= tstats_write,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
-void __init init_timer_stats(void)
-{
-	int cpu;
-
-	for_each_possible_cpu(cpu)
-		spin_lock_init(&per_cpu(lookup_lock, cpu));
-}
-
-static int __init init_tstats_procfs(void)
-{
-	struct proc_dir_entry *pe;
-
-	pe = create_proc_entry("timer_stats", 0644, NULL);
-	if (!pe)
-		return -ENOMEM;
-
-	pe->proc_fops = &tstats_fops;
-
-	return 0;
+	statistic_inc_as_key(STAT_SPARSE, tstat_stat, TSTAT_EXPIRED, &key);
 }
-__initcall(init_tstats_procfs);
diff -puN kernel/timer.c~timer_stats-slimmed-down-using-statistics-infrastucture kernel/timer.c
--- a/kernel/timer.c~timer_stats-slimmed-down-using-statistics-infrastucture
+++ a/kernel/timer.c
@@ -1315,8 +1315,6 @@ void __init init_timers(void)
 	int err = timer_cpu_notify(&timers_nb, (unsigned long)CPU_UP_PREPARE,
 				(void *)(long)smp_processor_id());
 
-	init_timer_stats();
-
 	BUG_ON(err == NOTIFY_BAD);
 	register_cpu_notifier(&timers_nb);
 	open_softirq(TIMER_SOFTIRQ, run_timer_softirq, NULL);
_

Patches currently in -mm which might be from mp3@de.ibm.com are

sunrpc-cleanup-use-seq_release_private-where-appropriate.patch
kallsyms-cleanup-use-seq_release_private-where-appropriate.patch
proc-cleanup-use-seq_release_private-where-appropriate.patch
md-cleanup-use-seq_release_private-where-appropriate.patch
statistics-infrastructure-prerequisite-list.patch
statistics-infrastructure-prerequisite-parser.patch
statistics-infrastructure-prerequisite-parser-fix.patch
add-for_each_substring-and-match_substring.patch
statistics-infrastructure-prerequisite-timestamp.patch
statistics-infrastructure-make-printk_clock-a-generic-kernel-wide-nsec-resolution.patch
statistics-infrastructure-documentation.patch
statistics-infrastructure.patch
statistics-infrastructure-add-for_each_substring-and-match_substring-exploitation.patch
statistics-infrastructure-fix-parsing-of-statistics-type-attribute.patch
statistics-infrastructure-simplify-statistics-debugfs-write-function.patch
statistics-infrastructure-simplify-statistics-debugfs-read-functions.patch
statistics-infrastructure-fix-string-termination.patch
statistics-infrastructure-small-cleanup-in-debugfs-write-function.patch
statistics-infrastructure-fix-cpu-hot-unplug-related-memory-leak.patch
statistics-infrastructure-timer_stats-slimmed-down-statistics-prereq-cleanup.patch
statistics-infrastructure-timer_stats-slimmed-down-statistics-prereq-labels.patch
statistics-infrastructure-timer_stats-slimmed-down-statistics-prereq-keys.patch
statistics-infrastructure-exploitation-zfcp.patch
timer_stats-slimmed-down-using-statistics-infrastucture.patch
