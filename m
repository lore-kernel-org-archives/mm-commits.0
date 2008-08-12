From: akpm@linux-foundation.org
Subject: - lockdep-shrink-held_lock-structure.patch removed from -mm tree
Date: Tue, 12 Aug 2008 13:33:23 -0700
Message-ID: <200808122033.m7CKXNRD011784@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48445 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751654AbYHLUe0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Aug 2008 16:34:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davej@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     lockdep: shrink held_lock structure
has been removed from the -mm tree.  Its filename was
     lockdep-shrink-held_lock-structure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lockdep: shrink held_lock structure
From: Dave Jones <davej@redhat.com>

struct held_lock {
        u64                        prev_chain_key;       /*     0     8 */
        struct lock_class *        class;                /*     8     8 */
        long unsigned int          acquire_ip;           /*    16     8 */
        struct lockdep_map *       instance;             /*    24     8 */
        int                        irq_context;          /*    32     4 */
        int                        trylock;              /*    36     4 */
        int                        read;                 /*    40     4 */
        int                        check;                /*    44     4 */
        int                        hardirqs_off;         /*    48     4 */

        /* size: 56, cachelines: 1 */
        /* padding: 4 */
        /* last cacheline: 56 bytes */
};

struct held_lock {
        u64                        prev_chain_key;       /*     0     8 */
        long unsigned int          acquire_ip;           /*     8     8 */
        struct lockdep_map *       instance;             /*    16     8 */
        unsigned int               class_idx:11;         /*    24:21  4 */
        unsigned int               irq_context:1;        /*    24:20  4 */
        unsigned int               trylock:1;            /*    24:19  4 */
        unsigned int               read:2;               /*    24:17  4 */
        unsigned int               check:1;              /*    24:16  4 */
        unsigned int               hardirqs_off:1;       /*    24:15  4 */

        /* size: 32, cachelines: 1 */
        /* padding: 4 */
        /* bit_padding: 15 bits */
        /* last cacheline: 32 bytes */
};

[mingo@elte.hu: shrunk hlock->class too]
Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/lockdep.h    |   16 ++--
 kernel/lockdep.c           |  113 ++++++++++++++++++++---------------
 kernel/lockdep_internals.h |    3 
 3 files changed, 74 insertions(+), 58 deletions(-)

diff -puN include/linux/lockdep.h~lockdep-shrink-held_lock-structure include/linux/lockdep.h
--- a/include/linux/lockdep.h~lockdep-shrink-held_lock-structure
+++ a/include/linux/lockdep.h
@@ -190,6 +190,9 @@ struct lock_chain {
 	u64				chain_key;
 };
 
+#define MAX_LOCKDEP_KEYS_BITS		11
+#define MAX_LOCKDEP_KEYS		(1UL << MAX_LOCKDEP_KEYS_BITS)
+
 struct held_lock {
 	/*
 	 * One-way hash of the dependency chain up to this point. We
@@ -206,14 +209,13 @@ struct held_lock {
 	 * with zero), here we store the previous hash value:
 	 */
 	u64				prev_chain_key;
-	struct lock_class		*class;
 	unsigned long			acquire_ip;
 	struct lockdep_map		*instance;
-
 #ifdef CONFIG_LOCK_STAT
 	u64 				waittime_stamp;
 	u64				holdtime_stamp;
 #endif
+	unsigned int			class_idx:MAX_LOCKDEP_KEYS_BITS;
 	/*
 	 * The lock-stack is unified in that the lock chains of interrupt
 	 * contexts nest ontop of process context chains, but we 'separate'
@@ -227,11 +229,11 @@ struct held_lock {
 	 * The following field is used to detect when we cross into an
 	 * interrupt context:
 	 */
-	int				irq_context;
-	int				trylock;
-	int				read;
-	int				check;
-	int				hardirqs_off;
+	unsigned int irq_context:1;
+	unsigned int trylock:1;
+	unsigned int read:2;
+	unsigned int check:1;
+	unsigned int hardirqs_off:1;
 };
 
 /*
diff -puN kernel/lockdep.c~lockdep-shrink-held_lock-structure kernel/lockdep.c
--- a/kernel/lockdep.c~lockdep-shrink-held_lock-structure
+++ a/kernel/lockdep.c
@@ -124,6 +124,15 @@ static struct lock_list list_entries[MAX
 unsigned long nr_lock_classes;
 static struct lock_class lock_classes[MAX_LOCKDEP_KEYS];
 
+static inline struct lock_class *hlock_class(struct held_lock *hlock)
+{
+	if (!hlock->class_idx) {
+		DEBUG_LOCKS_WARN_ON(1);
+		return NULL;
+	}
+	return lock_classes + hlock->class_idx - 1;
+}
+
 #ifdef CONFIG_LOCK_STAT
 static DEFINE_PER_CPU(struct lock_class_stats[MAX_LOCKDEP_KEYS], lock_stats);
 
@@ -222,7 +231,7 @@ static void lock_release_holdtime(struct
 
 	holdtime = sched_clock() - hlock->holdtime_stamp;
 
-	stats = get_lock_stats(hlock->class);
+	stats = get_lock_stats(hlock_class(hlock));
 	if (hlock->read)
 		lock_time_inc(&stats->read_holdtime, holdtime);
 	else
@@ -518,7 +527,7 @@ static void print_lockdep_cache(struct l
 
 static void print_lock(struct held_lock *hlock)
 {
-	print_lock_name(hlock->class);
+	print_lock_name(hlock_class(hlock));
 	printk(", at: ");
 	print_ip_sym(hlock->acquire_ip);
 }
@@ -948,7 +957,7 @@ static noinline int print_circular_bug_t
 	if (debug_locks_silent)
 		return 0;
 
-	this.class = check_source->class;
+	this.class = hlock_class(check_source);
 	if (!save_trace(&this.trace))
 		return 0;
 
@@ -1057,7 +1066,7 @@ check_noncircular(struct lock_class *sou
 	 * Check this lock's dependency list:
 	 */
 	list_for_each_entry(entry, &source->locks_after, entry) {
-		if (entry->class == check_target->class)
+		if (entry->class == hlock_class(check_target))
 			return print_circular_bug_header(entry, depth+1);
 		debug_atomic_inc(&nr_cyclic_checks);
 		if (!check_noncircular(entry->class, depth+1))
@@ -1150,6 +1159,11 @@ find_usage_backwards(struct lock_class *
 		return 2;
 	}
 
+	if (!source && debug_locks_off_graph_unlock()) {
+		WARN_ON(1);
+		return 0;
+	}
+
 	/*
 	 * Check this lock's dependency list:
 	 */
@@ -1189,9 +1203,9 @@ print_bad_irq_dependency(struct task_str
 	printk("\nand this task is already holding:\n");
 	print_lock(prev);
 	printk("which would create a new lock dependency:\n");
-	print_lock_name(prev->class);
+	print_lock_name(hlock_class(prev));
 	printk(" ->");
-	print_lock_name(next->class);
+	print_lock_name(hlock_class(next));
 	printk("\n");
 
 	printk("\nbut this new dependency connects a %s-irq-safe lock:\n",
@@ -1232,12 +1246,12 @@ check_usage(struct task_struct *curr, st
 
 	find_usage_bit = bit_backwards;
 	/* fills in <backwards_match> */
-	ret = find_usage_backwards(prev->class, 0);
+	ret = find_usage_backwards(hlock_class(prev), 0);
 	if (!ret || ret == 1)
 		return ret;
 
 	find_usage_bit = bit_forwards;
-	ret = find_usage_forwards(next->class, 0);
+	ret = find_usage_forwards(hlock_class(next), 0);
 	if (!ret || ret == 1)
 		return ret;
 	/* ret == 2 */
@@ -1362,7 +1376,7 @@ check_deadlock(struct task_struct *curr,
 
 	for (i = 0; i < curr->lockdep_depth; i++) {
 		prev = curr->held_locks + i;
-		if (prev->class != next->class)
+		if (hlock_class(prev) != hlock_class(next))
 			continue;
 		/*
 		 * Allow read-after-read recursion of the same
@@ -1415,7 +1429,7 @@ check_prev_add(struct task_struct *curr,
 	 */
 	check_source = next;
 	check_target = prev;
-	if (!(check_noncircular(next->class, 0)))
+	if (!(check_noncircular(hlock_class(next), 0)))
 		return print_circular_bug_tail();
 
 	if (!check_prev_add_irq(curr, prev, next))
@@ -1439,8 +1453,8 @@ check_prev_add(struct task_struct *curr,
 	 *  chains - the second one will be new, but L1 already has
 	 *  L2 added to its dependency list, due to the first chain.)
 	 */
-	list_for_each_entry(entry, &prev->class->locks_after, entry) {
-		if (entry->class == next->class) {
+	list_for_each_entry(entry, &hlock_class(prev)->locks_after, entry) {
+		if (entry->class == hlock_class(next)) {
 			if (distance == 1)
 				entry->distance = 1;
 			return 2;
@@ -1451,26 +1465,28 @@ check_prev_add(struct task_struct *curr,
 	 * Ok, all validations passed, add the new lock
 	 * to the previous lock's dependency list:
 	 */
-	ret = add_lock_to_list(prev->class, next->class,
-			       &prev->class->locks_after, next->acquire_ip, distance);
+	ret = add_lock_to_list(hlock_class(prev), hlock_class(next),
+			       &hlock_class(prev)->locks_after,
+			       next->acquire_ip, distance);
 
 	if (!ret)
 		return 0;
 
-	ret = add_lock_to_list(next->class, prev->class,
-			       &next->class->locks_before, next->acquire_ip, distance);
+	ret = add_lock_to_list(hlock_class(next), hlock_class(prev),
+			       &hlock_class(next)->locks_before,
+			       next->acquire_ip, distance);
 	if (!ret)
 		return 0;
 
 	/*
 	 * Debugging printouts:
 	 */
-	if (verbose(prev->class) || verbose(next->class)) {
+	if (verbose(hlock_class(prev)) || verbose(hlock_class(next))) {
 		graph_unlock();
 		printk("\n new dependency: ");
-		print_lock_name(prev->class);
+		print_lock_name(hlock_class(prev));
 		printk(" => ");
-		print_lock_name(next->class);
+		print_lock_name(hlock_class(next));
 		printk("\n");
 		dump_stack();
 		return graph_lock();
@@ -1567,7 +1583,7 @@ static inline int lookup_chain_cache(str
 				     struct held_lock *hlock,
 				     u64 chain_key)
 {
-	struct lock_class *class = hlock->class;
+	struct lock_class *class = hlock_class(hlock);
 	struct list_head *hash_head = chainhashentry(chain_key);
 	struct lock_chain *chain;
 	struct held_lock *hlock_curr, *hlock_next;
@@ -1640,7 +1656,7 @@ cache_hit:
 	if (likely(cn + chain->depth <= MAX_LOCKDEP_CHAIN_HLOCKS)) {
 		chain->base = cn;
 		for (j = 0; j < chain->depth - 1; j++, i++) {
-			int lock_id = curr->held_locks[i].class - lock_classes;
+			int lock_id = curr->held_locks[i].class_idx - 1;
 			chain_hlocks[chain->base + j] = lock_id;
 		}
 		chain_hlocks[chain->base + j] = class - lock_classes;
@@ -1735,7 +1751,7 @@ static void check_chain_key(struct task_
 				(unsigned long long)hlock->prev_chain_key);
 			return;
 		}
-		id = hlock->class - lock_classes;
+		id = hlock->class_idx - 1;
 		if (DEBUG_LOCKS_WARN_ON(id >= MAX_LOCKDEP_KEYS))
 			return;
 
@@ -1779,7 +1795,7 @@ print_usage_bug(struct task_struct *curr
 	print_lock(this);
 
 	printk("{%s} state was registered at:\n", usage_str[prev_bit]);
-	print_stack_trace(this->class->usage_traces + prev_bit, 1);
+	print_stack_trace(hlock_class(this)->usage_traces + prev_bit, 1);
 
 	print_irqtrace_events(curr);
 	printk("\nother info that might help us debug this:\n");
@@ -1798,7 +1814,7 @@ static inline int
 valid_state(struct task_struct *curr, struct held_lock *this,
 	    enum lock_usage_bit new_bit, enum lock_usage_bit bad_bit)
 {
-	if (unlikely(this->class->usage_mask & (1 << bad_bit)))
+	if (unlikely(hlock_class(this)->usage_mask & (1 << bad_bit)))
 		return print_usage_bug(curr, this, bad_bit, new_bit);
 	return 1;
 }
@@ -1837,7 +1853,7 @@ print_irq_inversion_bug(struct task_stru
 	lockdep_print_held_locks(curr);
 
 	printk("\nthe first lock's dependencies:\n");
-	print_lock_dependencies(this->class, 0);
+	print_lock_dependencies(hlock_class(this), 0);
 
 	printk("\nthe second lock's dependencies:\n");
 	print_lock_dependencies(other, 0);
@@ -1860,7 +1876,7 @@ check_usage_forwards(struct task_struct 
 
 	find_usage_bit = bit;
 	/* fills in <forwards_match> */
-	ret = find_usage_forwards(this->class, 0);
+	ret = find_usage_forwards(hlock_class(this), 0);
 	if (!ret || ret == 1)
 		return ret;
 
@@ -1879,7 +1895,7 @@ check_usage_backwards(struct task_struct
 
 	find_usage_bit = bit;
 	/* fills in <backwards_match> */
-	ret = find_usage_backwards(this->class, 0);
+	ret = find_usage_backwards(hlock_class(this), 0);
 	if (!ret || ret == 1)
 		return ret;
 
@@ -1945,7 +1961,7 @@ static int mark_lock_irq(struct task_str
 				LOCK_ENABLED_HARDIRQS_READ, "hard-read"))
 			return 0;
 #endif
-		if (hardirq_verbose(this->class))
+		if (hardirq_verbose(hlock_class(this)))
 			ret = 2;
 		break;
 	case LOCK_USED_IN_SOFTIRQ:
@@ -1970,7 +1986,7 @@ static int mark_lock_irq(struct task_str
 				LOCK_ENABLED_SOFTIRQS_READ, "soft-read"))
 			return 0;
 #endif
-		if (softirq_verbose(this->class))
+		if (softirq_verbose(hlock_class(this)))
 			ret = 2;
 		break;
 	case LOCK_USED_IN_HARDIRQ_READ:
@@ -1983,7 +1999,7 @@ static int mark_lock_irq(struct task_str
 		if (!check_usage_forwards(curr, this,
 					  LOCK_ENABLED_HARDIRQS, "hard"))
 			return 0;
-		if (hardirq_verbose(this->class))
+		if (hardirq_verbose(hlock_class(this)))
 			ret = 2;
 		break;
 	case LOCK_USED_IN_SOFTIRQ_READ:
@@ -1996,7 +2012,7 @@ static int mark_lock_irq(struct task_str
 		if (!check_usage_forwards(curr, this,
 					  LOCK_ENABLED_SOFTIRQS, "soft"))
 			return 0;
-		if (softirq_verbose(this->class))
+		if (softirq_verbose(hlock_class(this)))
 			ret = 2;
 		break;
 	case LOCK_ENABLED_HARDIRQS:
@@ -2022,7 +2038,7 @@ static int mark_lock_irq(struct task_str
 				   LOCK_USED_IN_HARDIRQ_READ, "hard-read"))
 			return 0;
 #endif
-		if (hardirq_verbose(this->class))
+		if (hardirq_verbose(hlock_class(this)))
 			ret = 2;
 		break;
 	case LOCK_ENABLED_SOFTIRQS:
@@ -2048,7 +2064,7 @@ static int mark_lock_irq(struct task_str
 				   LOCK_USED_IN_SOFTIRQ_READ, "soft-read"))
 			return 0;
 #endif
-		if (softirq_verbose(this->class))
+		if (softirq_verbose(hlock_class(this)))
 			ret = 2;
 		break;
 	case LOCK_ENABLED_HARDIRQS_READ:
@@ -2063,7 +2079,7 @@ static int mark_lock_irq(struct task_str
 					   LOCK_USED_IN_HARDIRQ, "hard"))
 			return 0;
 #endif
-		if (hardirq_verbose(this->class))
+		if (hardirq_verbose(hlock_class(this)))
 			ret = 2;
 		break;
 	case LOCK_ENABLED_SOFTIRQS_READ:
@@ -2078,7 +2094,7 @@ static int mark_lock_irq(struct task_str
 					   LOCK_USED_IN_SOFTIRQ, "soft"))
 			return 0;
 #endif
-		if (softirq_verbose(this->class))
+		if (softirq_verbose(hlock_class(this)))
 			ret = 2;
 		break;
 	default:
@@ -2394,7 +2410,7 @@ static int mark_lock(struct task_struct 
 	 * If already set then do not dirty the cacheline,
 	 * nor do any checks:
 	 */
-	if (likely(this->class->usage_mask & new_mask))
+	if (likely(hlock_class(this)->usage_mask & new_mask))
 		return 1;
 
 	if (!graph_lock())
@@ -2402,14 +2418,14 @@ static int mark_lock(struct task_struct 
 	/*
 	 * Make sure we didnt race:
 	 */
-	if (unlikely(this->class->usage_mask & new_mask)) {
+	if (unlikely(hlock_class(this)->usage_mask & new_mask)) {
 		graph_unlock();
 		return 1;
 	}
 
-	this->class->usage_mask |= new_mask;
+	hlock_class(this)->usage_mask |= new_mask;
 
-	if (!save_trace(this->class->usage_traces + new_bit))
+	if (!save_trace(hlock_class(this)->usage_traces + new_bit))
 		return 0;
 
 	switch (new_bit) {
@@ -2543,8 +2559,9 @@ static int __lock_acquire(struct lockdep
 		return 0;
 
 	hlock = curr->held_locks + depth;
-
-	hlock->class = class;
+	if (DEBUG_LOCKS_WARN_ON(!class))
+		return 0;
+	hlock->class_idx = class - lock_classes + 1;
 	hlock->acquire_ip = ip;
 	hlock->instance = lock;
 	hlock->trylock = trylock;
@@ -2688,7 +2705,7 @@ __lock_set_subclass(struct lockdep_map *
 
 found_it:
 	class = register_lock_class(lock, subclass, 0);
-	hlock->class = class;
+	hlock->class_idx = class - lock_classes + 1;
 
 	curr->lockdep_depth = i;
 	curr->curr_chain_key = hlock->prev_chain_key;
@@ -2696,7 +2713,7 @@ found_it:
 	for (; i < depth; i++) {
 		hlock = curr->held_locks + i;
 		if (!__lock_acquire(hlock->instance,
-			hlock->class->subclass, hlock->trylock,
+			hlock_class(hlock)->subclass, hlock->trylock,
 				hlock->read, hlock->check, hlock->hardirqs_off,
 				hlock->acquire_ip))
 			return 0;
@@ -2757,7 +2774,7 @@ found_it:
 	for (i++; i < depth; i++) {
 		hlock = curr->held_locks + i;
 		if (!__lock_acquire(hlock->instance,
-			hlock->class->subclass, hlock->trylock,
+			hlock_class(hlock)->subclass, hlock->trylock,
 				hlock->read, hlock->check, hlock->hardirqs_off,
 				hlock->acquire_ip))
 			return 0;
@@ -2802,7 +2819,7 @@ static int lock_release_nested(struct ta
 
 #ifdef CONFIG_DEBUG_LOCKDEP
 	hlock->prev_chain_key = 0;
-	hlock->class = NULL;
+	hlock_class(hlock) = NULL;
 	hlock->acquire_ip = 0;
 	hlock->irq_context = 0;
 #endif
@@ -2998,9 +3015,9 @@ __lock_contended(struct lockdep_map *loc
 found_it:
 	hlock->waittime_stamp = sched_clock();
 
-	point = lock_contention_point(hlock->class, ip);
+	point = lock_contention_point(hlock_class(hlock), ip);
 
-	stats = get_lock_stats(hlock->class);
+	stats = get_lock_stats(hlock_class(hlock));
 	if (point < ARRAY_SIZE(stats->contention_point))
 		stats->contention_point[i]++;
 	if (lock->cpu != smp_processor_id())
@@ -3046,7 +3063,7 @@ found_it:
 		hlock->holdtime_stamp = now;
 	}
 
-	stats = get_lock_stats(hlock->class);
+	stats = get_lock_stats(hlock_class(hlock));
 	if (waittime) {
 		if (hlock->read)
 			lock_time_inc(&stats->read_waittime, waittime);
diff -puN kernel/lockdep_internals.h~lockdep-shrink-held_lock-structure kernel/lockdep_internals.h
--- a/kernel/lockdep_internals.h~lockdep-shrink-held_lock-structure
+++ a/kernel/lockdep_internals.h
@@ -17,9 +17,6 @@
  */
 #define MAX_LOCKDEP_ENTRIES	8192UL
 
-#define MAX_LOCKDEP_KEYS_BITS	11
-#define MAX_LOCKDEP_KEYS	(1UL << MAX_LOCKDEP_KEYS_BITS)
