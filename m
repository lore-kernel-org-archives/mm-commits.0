From: akpm@linux-foundation.org
Subject: - lockstat-core-infrastructure.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:03:40 -0700
Message-ID: <200707192003.l6JK3eCc019881@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37981 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932201AbXGSU1b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:27:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, jbaron@redhat.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     lockstat: core infrastructure
has been removed from the -mm tree.  Its filename was
     lockstat-core-infrastructure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lockstat: core infrastructure
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Introduce the core lock statistics code.

Lock statistics provides lock wait-time and hold-time (as well as the count
of corresponding contention and acquisitions events). Also, the first few
call-sites that encounter contention are tracked.

Lock wait-time is the time spent waiting on the lock. This provides insight
into the locking scheme, that is, a heavily contended lock is indicative of
a too coarse locking scheme.

Lock hold-time is the duration the lock was held, this provides a reference for
the wait-time numbers, so they can be put into perspective.

  1)
    lock
  2)
    ... do stuff ..
    unlock
  3)

The time between 1 and 2 is the wait-time. The time between 2 and 3 is the
hold-time.

The lockdep held-lock tracking code is reused, because it already collects locks
into meaningful groups (classes), and because it is an existing infrastructure
for lock instrumentation.

Currently lockdep tracks lock acquisition with two hooks:

  lock()
    lock_acquire()
    _lock()

 ... code protected by lock ...

  unlock()
    lock_release()
    _unlock()

We need to extend this with two more hooks, in order to measure contention.

  lock_contended() - used to measure contention events
  lock_acquired()  - completion of the contention

These are then placed the following way:

  lock()
    lock_acquire()
    if (!_try_lock())
      lock_contended()
      _lock()
      lock_acquired()

 ... do locked stuff ...

  unlock()
    lock_release()
    _unlock()

(Note: the try_lock() 'trick' is used to avoid instrumenting all platform
       dependent lock primitive implementations.)

It is also possible to toggle the two lockdep features at runtime using:

  /proc/sys/kernel/prove_locking
  /proc/sys/kernel/lock_stat

(esp. turning off the O(n^2) prove_locking functionaliy can help)

[akpm@linux-foundation.org: build fixes]
[akpm@linux-foundation.org: nuke unneeded ifdefs]
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Jason Baron <jbaron@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/lockdep.h |   53 ++++++++
 kernel/lockdep.c        |  247 ++++++++++++++++++++++++++++++++++++++
 kernel/sysctl.c         |   22 +++
 lib/Kconfig.debug       |   11 +
 4 files changed, 333 insertions(+)

diff -puN include/linux/lockdep.h~lockstat-core-infrastructure include/linux/lockdep.h
--- a/include/linux/lockdep.h~lockstat-core-infrastructure
+++ a/include/linux/lockdep.h
@@ -9,6 +9,7 @@
 #define __LINUX_LOCKDEP_H
 
 struct task_struct;
+struct lockdep_map;
 
 #ifdef CONFIG_LOCKDEP
 
@@ -114,8 +115,32 @@ struct lock_class {
 
 	const char			*name;
 	int				name_version;
+
+#ifdef CONFIG_LOCK_STAT
+	unsigned long			contention_point[4];
+#endif
+};
+
+#ifdef CONFIG_LOCK_STAT
+struct lock_time {
+	s64				min;
+	s64				max;
+	s64				total;
+	unsigned long			nr;
 };
 
+struct lock_class_stats {
+	unsigned long			contention_point[4];
+	struct lock_time		read_waittime;
+	struct lock_time		write_waittime;
+	struct lock_time		read_holdtime;
+	struct lock_time		write_holdtime;
+};
+
+struct lock_class_stats lock_stats(struct lock_class *class);
+void clear_lock_stats(struct lock_class *class);
+#endif
+
 /*
  * Map the lock object (the lock instance) to the lock-class object.
  * This is embedded into specific lock instances:
@@ -165,6 +190,10 @@ struct held_lock {
 	unsigned long			acquire_ip;
 	struct lockdep_map		*instance;
 
+#ifdef CONFIG_LOCK_STAT
+	u64 				waittime_stamp;
+	u64				holdtime_stamp;
+#endif
 	/*
 	 * The lock-stack is unified in that the lock chains of interrupt
 	 * contexts nest ontop of process context chains, but we 'separate'
@@ -281,6 +310,30 @@ struct lock_class_key { };
 
 #endif /* !LOCKDEP */
 
+#ifdef CONFIG_LOCK_STAT
+
+extern void lock_contended(struct lockdep_map *lock, unsigned long ip);
+extern void lock_acquired(struct lockdep_map *lock);
+
+#define LOCK_CONTENDED(_lock, try, lock)			\
+do {								\
+	if (!try(_lock)) {					\
+		lock_contended(&(_lock)->dep_map, _RET_IP_);	\
+		lock(_lock);					\
+		lock_acquired(&(_lock)->dep_map);		\
+	}							\
+} while (0)
+
+#else /* CONFIG_LOCK_STAT */
+
+#define lock_contended(lockdep_map, ip) do {} while (0)
+#define lock_acquired(lockdep_map) do {} while (0)
+
+#define LOCK_CONTENDED(_lock, try, lock) \
+	lock(_lock)
+
+#endif /* CONFIG_LOCK_STAT */
+
 #if defined(CONFIG_TRACE_IRQFLAGS) && defined(CONFIG_GENERIC_HARDIRQS)
 extern void early_init_irq_lock_class(void);
 #else
diff -puN kernel/lockdep.c~lockstat-core-infrastructure kernel/lockdep.c
--- a/kernel/lockdep.c~lockstat-core-infrastructure
+++ a/kernel/lockdep.c
@@ -42,6 +42,20 @@
 
 #include "lockdep_internals.h"
 
+#ifdef CONFIG_PROVE_LOCKING
+int prove_locking = 1;
+module_param(prove_locking, int, 0644);
+#else
+#define prove_locking 0
+#endif
+
+#ifdef CONFIG_LOCK_STAT
+int lock_stat = 1;
+module_param(lock_stat, int, 0644);
+#else
+#define lock_stat 0
+#endif
+
 /*
  * lockdep_lock: protects the lockdep graph, the hashes and the
  *               class/list/hash allocators.
@@ -104,6 +118,70 @@ static struct lock_list list_entries[MAX
 unsigned long nr_lock_classes;
 static struct lock_class lock_classes[MAX_LOCKDEP_KEYS];
 
+#ifdef CONFIG_LOCK_STAT
+static DEFINE_PER_CPU(struct lock_class_stats[MAX_LOCKDEP_KEYS], lock_stats);
+
+static int lock_contention_point(struct lock_class *class, unsigned long ip)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(class->contention_point); i++) {
+		if (class->contention_point[i] == 0) {
+			class->contention_point[i] = ip;
+			break;
+		}
+		if (class->contention_point[i] == ip)
+			break;
+	}
+
+	return i;
+}
+
+static void lock_time_inc(struct lock_time *lt, s64 time)
+{
+	if (time > lt->max)
+		lt->max = time;
+
+	if (time < lt->min || !lt->min)
+		lt->min = time;
+
+	lt->total += time;
+	lt->nr++;
+}
+
+static struct lock_class_stats *get_lock_stats(struct lock_class *class)
+{
+	return &get_cpu_var(lock_stats)[class - lock_classes];
+}
+
+static void put_lock_stats(struct lock_class_stats *stats)
+{
+	put_cpu_var(lock_stats);
+}
+
+static void lock_release_holdtime(struct held_lock *hlock)
+{
+	struct lock_class_stats *stats;
+	s64 holdtime;
+
+	if (!lock_stat)
+		return;
+
+	holdtime = sched_clock() - hlock->holdtime_stamp;
+
+	stats = get_lock_stats(hlock->class);
+	if (hlock->read)
+		lock_time_inc(&stats->read_holdtime, holdtime);
+	else
+		lock_time_inc(&stats->write_holdtime, holdtime);
+	put_lock_stats(stats);
+}
+#else
+static inline void lock_release_holdtime(struct held_lock *hlock)
+{
+}
+#endif
+
 /*
  * We keep a global list of all lock classes. The list only grows,
  * never shrinks. The list is only accessed with the lockdep
@@ -2221,6 +2299,9 @@ static int __lock_acquire(struct lockdep
 	int chain_head = 0;
 	u64 chain_key;
 
+	if (!prove_locking)
+		check = 1;
+
 	if (unlikely(!debug_locks))
 		return 0;
 
@@ -2271,6 +2352,10 @@ static int __lock_acquire(struct lockdep
 	hlock->read = read;
 	hlock->check = check;
 	hlock->hardirqs_off = hardirqs_off;
+#ifdef CONFIG_LOCK_STAT
+	hlock->waittime_stamp = 0;
+	hlock->holdtime_stamp = sched_clock();
+#endif
 
 	if (check == 2 && !mark_irqflags(curr, hlock))
 		return 0;
@@ -2411,6 +2496,8 @@ lock_release_non_nested(struct task_stru
 	return print_unlock_inbalance_bug(curr, lock, ip);
 
 found_it:
+	lock_release_holdtime(hlock);
+
 	/*
 	 * We have the right lock to unlock, 'hlock' points to it.
 	 * Now we remove it from the stack, and add back the other
@@ -2463,6 +2550,8 @@ static int lock_release_nested(struct ta
 
 	curr->curr_chain_key = hlock->prev_chain_key;
 
+	lock_release_holdtime(hlock);
+
 #ifdef CONFIG_DEBUG_LOCKDEP
 	hlock->prev_chain_key = 0;
 	hlock->class = NULL;
@@ -2537,6 +2626,9 @@ void lock_acquire(struct lockdep_map *lo
 {
 	unsigned long flags;
 
+	if (unlikely(!lock_stat && !prove_locking))
+		return;
+
 	if (unlikely(current->lockdep_recursion))
 		return;
 
@@ -2556,6 +2648,9 @@ void lock_release(struct lockdep_map *lo
 {
 	unsigned long flags;
 
+	if (unlikely(!lock_stat && !prove_locking))
+		return;
+
 	if (unlikely(current->lockdep_recursion))
 		return;
 
@@ -2569,6 +2664,158 @@ void lock_release(struct lockdep_map *lo
 
 EXPORT_SYMBOL_GPL(lock_release);
 
+#ifdef CONFIG_LOCK_STAT
+static int
+print_lock_contention_bug(struct task_struct *curr, struct lockdep_map *lock,
+			   unsigned long ip)
+{
+	if (!debug_locks_off())
+		return 0;
+	if (debug_locks_silent)
+		return 0;
+
+	printk("\n=================================\n");
+	printk(  "[ BUG: bad contention detected! ]\n");
+	printk(  "---------------------------------\n");
+	printk("%s/%d is trying to contend lock (",
+		curr->comm, curr->pid);
+	print_lockdep_cache(lock);
+	printk(") at:\n");
+	print_ip_sym(ip);
+	printk("but there are no locks held!\n");
+	printk("\nother info that might help us debug this:\n");
+	lockdep_print_held_locks(curr);
+
+	printk("\nstack backtrace:\n");
+	dump_stack();
+
+	return 0;
+}
+
+static void
+__lock_contended(struct lockdep_map *lock, unsigned long ip)
+{
+	struct task_struct *curr = current;
+	struct held_lock *hlock, *prev_hlock;
+	struct lock_class_stats *stats;
+	unsigned int depth;
+	int i, point;
+
+	depth = curr->lockdep_depth;
+	if (DEBUG_LOCKS_WARN_ON(!depth))
+		return;
+
+	prev_hlock = NULL;
+	for (i = depth-1; i >= 0; i--) {
+		hlock = curr->held_locks + i;
+		/*
+		 * We must not cross into another context:
+		 */
+		if (prev_hlock && prev_hlock->irq_context != hlock->irq_context)
+			break;
+		if (hlock->instance == lock)
+			goto found_it;
+		prev_hlock = hlock;
+	}
+	print_lock_contention_bug(curr, lock, ip);
+	return;
+
+found_it:
+	hlock->waittime_stamp = sched_clock();
+
+	point = lock_contention_point(hlock->class, ip);
+
+	stats = get_lock_stats(hlock->class);
+	if (point < ARRAY_SIZE(stats->contention_point))
+		stats->contention_point[i]++;
+	put_lock_stats(stats);
+}
+
+static void
+__lock_acquired(struct lockdep_map *lock)
+{
+	struct task_struct *curr = current;
+	struct held_lock *hlock, *prev_hlock;
+	struct lock_class_stats *stats;
+	unsigned int depth;
+	u64 now;
+	s64 waittime;
+	int i;
+
+	depth = curr->lockdep_depth;
+	if (DEBUG_LOCKS_WARN_ON(!depth))
+		return;
+
+	prev_hlock = NULL;
+	for (i = depth-1; i >= 0; i--) {
+		hlock = curr->held_locks + i;
+		/*
+		 * We must not cross into another context:
+		 */
+		if (prev_hlock && prev_hlock->irq_context != hlock->irq_context)
+			break;
+		if (hlock->instance == lock)
+			goto found_it;
+		prev_hlock = hlock;
+	}
+	print_lock_contention_bug(curr, lock, _RET_IP_);
+	return;
+
+found_it:
+	if (!hlock->waittime_stamp)
+		return;
+
+	now = sched_clock();
+	waittime = now - hlock->waittime_stamp;
+	hlock->holdtime_stamp = now;
+
+	stats = get_lock_stats(hlock->class);
+	if (hlock->read)
+		lock_time_inc(&stats->read_waittime, waittime);
+	else
+		lock_time_inc(&stats->write_waittime, waittime);
+	put_lock_stats(stats);
+}
+
+void lock_contended(struct lockdep_map *lock, unsigned long ip)
+{
+	unsigned long flags;
+
+	if (unlikely(!lock_stat))
+		return;
+
+	if (unlikely(current->lockdep_recursion))
+		return;
+
+	raw_local_irq_save(flags);
+	check_flags(flags);
+	current->lockdep_recursion = 1;
+	__lock_contended(lock, ip);
+	current->lockdep_recursion = 0;
+	raw_local_irq_restore(flags);
+}
+EXPORT_SYMBOL_GPL(lock_contended);
+
+void lock_acquired(struct lockdep_map *lock)
+{
+	unsigned long flags;
+
+	if (unlikely(!lock_stat))
+		return;
+
+	if (unlikely(current->lockdep_recursion))
+		return;
+
+	raw_local_irq_save(flags);
+	check_flags(flags);
+	current->lockdep_recursion = 1;
+	__lock_acquired(lock);
+	current->lockdep_recursion = 0;
+	raw_local_irq_restore(flags);
+}
+EXPORT_SYMBOL_GPL(lock_acquired);
+#endif
+
 /*
  * Used by the testsuite, sanitize the validator state
  * after a simulated failure:
diff -puN kernel/sysctl.c~lockstat-core-infrastructure kernel/sysctl.c
--- a/kernel/sysctl.c~lockstat-core-infrastructure
+++ a/kernel/sysctl.c
@@ -161,6 +161,8 @@ extern ctl_table inotify_table[];
 int sysctl_legacy_va_layout;
 #endif
 
+extern int prove_locking;
+extern int lock_stat;
 
 /* The default sysctl tables: */
 
@@ -282,6 +284,26 @@ static ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
+#ifdef CONFIG_PROVE_LOCKING
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "prove_locking",
+		.data		= &prove_locking,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+#endif
+#ifdef CONFIG_LOCK_STAT
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "lock_stat",
+		.data		= &lock_stat,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+#endif
 	{
 		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "sched_features",
diff -puN lib/Kconfig.debug~lockstat-core-infrastructure lib/Kconfig.debug
--- a/lib/Kconfig.debug~lockstat-core-infrastructure
+++ a/lib/Kconfig.debug
@@ -283,6 +283,17 @@ config LOCKDEP
 	select KALLSYMS
 	select KALLSYMS_ALL
 
+config LOCK_STAT
+	bool "Lock usage statisitics"
+	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
+	select LOCKDEP
+	select DEBUG_SPINLOCK
+	select DEBUG_MUTEXES
+	select DEBUG_LOCK_ALLOC
+	default n
+	help
+	 This feature enables tracking lock contention points
+
 config DEBUG_LOCKDEP
 	bool "Lock dependency engine debugging"
 	depends on DEBUG_KERNEL && LOCKDEP
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
