From: akpm@osdl.org
Subject: - lockdep-fix-possible-races-while-disabling-lock-debugging.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:10:02 -0800
Message-ID: <200612140610.kBE6A2Er002004@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52164 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917AbWLNGKW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:10:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, jarkao2@o2.pl, mm-commits@vger.kernel.org


The patch titled
     lockdep: fix possible races while disabling lock-debugging
has been removed from the -mm tree.  Its filename was
     lockdep-fix-possible-races-while-disabling-lock-debugging.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lockdep: fix possible races while disabling lock-debugging
From: Ingo Molnar <mingo@elte.hu>

Jarek Poplawski noticed that lockdep global state could be accessed in a
racy way if one CPU did a lockdep assert (shutting lockdep down), while the
other CPU would try to do something that changes its global state.

This patch fixes those races and cleans up lockdep's internal locking by
adding a graph_lock()/graph_unlock()/debug_locks_off_graph_unlock helpers.

(Also note that as we all know the Linux kernel is, by definition, bug-free
and perfect, so this code never triggers, so these fixes are highly
theoretical.  I wrote this patch for aesthetic reasons alone.)

[akpm@osdl.org: build fix]
[jarkao2@o2.pl: build fix's refix]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/lockdep.c |  170 +++++++++++++++++++++++++++------------------
 1 file changed, 105 insertions(+), 65 deletions(-)

diff -puN kernel/lockdep.c~lockdep-fix-possible-races-while-disabling-lock-debugging kernel/lockdep.c
--- a/kernel/lockdep.c~lockdep-fix-possible-races-while-disabling-lock-debugging
+++ a/kernel/lockdep.c
@@ -43,13 +43,49 @@
 #include "lockdep_internals.h"
 
 /*
- * hash_lock: protects the lockdep hashes and class/list/hash allocators.
+ * lockdep_lock: protects the lockdep graph, the hashes and the
+ *               class/list/hash allocators.
  *
  * This is one of the rare exceptions where it's justified
  * to use a raw spinlock - we really dont want the spinlock
- * code to recurse back into the lockdep code.
+ * code to recurse back into the lockdep code...
  */
-static raw_spinlock_t hash_lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
+static raw_spinlock_t lockdep_lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
+
+static int graph_lock(void)
+{
+	__raw_spin_lock(&lockdep_lock);
+	/*
+	 * Make sure that if another CPU detected a bug while
+	 * walking the graph we dont change it (while the other
+	 * CPU is busy printing out stuff with the graph lock
+	 * dropped already)
+	 */
+	if (!debug_locks) {
+		__raw_spin_unlock(&lockdep_lock);
+		return 0;
+	}
+	return 1;
+}
+
+static inline int graph_unlock(void)
+{
+	__raw_spin_unlock(&lockdep_lock);
+	return 0;
+}
+
+/*
+ * Turn lock debugging off and return with 0 if it was off already,
+ * and also release the graph lock:
+ */
+static inline int debug_locks_off_graph_unlock(void)
+{
+	int ret = debug_locks_off();
+
+	__raw_spin_unlock(&lockdep_lock);
+
+	return ret;
+}
 
 static int lockdep_initialized;
 
@@ -57,14 +93,15 @@ unsigned long nr_list_entries;
 static struct lock_list list_entries[MAX_LOCKDEP_ENTRIES];
 
 /*
- * Allocate a lockdep entry. (assumes hash_lock held, returns
+ * Allocate a lockdep entry. (assumes the graph_lock held, returns
  * with NULL on failure)
  */
 static struct lock_list *alloc_list_entry(void)
 {
 	if (nr_list_entries >= MAX_LOCKDEP_ENTRIES) {
-		__raw_spin_unlock(&hash_lock);
-		debug_locks_off();
+		if (!debug_locks_off_graph_unlock())
+			return NULL;
+
 		printk("BUG: MAX_LOCKDEP_ENTRIES too low!\n");
 		printk("turning off the locking correctness validator.\n");
 		return NULL;
@@ -205,7 +242,7 @@ static int softirq_verbose(struct lock_c
 
 /*
  * Stack-trace: tightly packed array of stack backtrace
- * addresses. Protected by the hash_lock.
+ * addresses. Protected by the graph_lock.
  */
 unsigned long nr_stack_trace_entries;
 static unsigned long stack_trace[MAX_STACK_TRACE_ENTRIES];
@@ -224,18 +261,15 @@ static int save_trace(struct stack_trace
 	trace->max_entries = trace->nr_entries;
 
 	nr_stack_trace_entries += trace->nr_entries;
-	if (DEBUG_LOCKS_WARN_ON(nr_stack_trace_entries > MAX_STACK_TRACE_ENTRIES)) {
-		__raw_spin_unlock(&hash_lock);
-		return 0;
-	}
 
 	if (nr_stack_trace_entries == MAX_STACK_TRACE_ENTRIES) {
-		__raw_spin_unlock(&hash_lock);
-		if (debug_locks_off()) {
-			printk("BUG: MAX_STACK_TRACE_ENTRIES too low!\n");
-			printk("turning off the locking correctness validator.\n");
-			dump_stack();
-		}
+		if (!debug_locks_off_graph_unlock())
+			return 0;
+
+		printk("BUG: MAX_STACK_TRACE_ENTRIES too low!\n");
+		printk("turning off the locking correctness validator.\n");
+		dump_stack();
+
 		return 0;
 	}
 
@@ -524,9 +558,7 @@ print_circular_bug_header(struct lock_li
 {
 	struct task_struct *curr = current;
 
-	__raw_spin_unlock(&hash_lock);
-	debug_locks_off();
-	if (debug_locks_silent)
+	if (!debug_locks_off_graph_unlock() || debug_locks_silent)
 		return 0;
 
 	printk("\n=======================================================\n");
@@ -554,12 +586,10 @@ static noinline int print_circular_bug_t
 	if (debug_locks_silent)
 		return 0;
 
-	/* hash_lock unlocked by the header */
-	__raw_spin_lock(&hash_lock);
 	this.class = check_source->class;
 	if (!save_trace(&this.trace))
 		return 0;
-	__raw_spin_unlock(&hash_lock);
+
 	print_circular_bug_entry(&this, 0);
 
 	printk("\nother info that might help us debug this:\n\n");
@@ -575,8 +605,10 @@ static noinline int print_circular_bug_t
 
 static int noinline print_infinite_recursion_bug(void)
 {
-	__raw_spin_unlock(&hash_lock);
-	DEBUG_LOCKS_WARN_ON(1);
+	if (!debug_locks_off_graph_unlock())
+		return 0;
+
+	WARN_ON(1);
 
 	return 0;
 }
@@ -711,9 +743,7 @@ print_bad_irq_dependency(struct task_str
 			 enum lock_usage_bit bit2,
 			 const char *irqclass)
 {
-	__raw_spin_unlock(&hash_lock);
-	debug_locks_off();
-	if (debug_locks_silent)
+	if (!debug_locks_off_graph_unlock() || debug_locks_silent)
 		return 0;
 
 	printk("\n======================================================\n");
@@ -794,9 +824,7 @@ static int
 print_deadlock_bug(struct task_struct *curr, struct held_lock *prev,
 		   struct held_lock *next)
 {
-	debug_locks_off();
-	__raw_spin_unlock(&hash_lock);
-	if (debug_locks_silent)
+	if (!debug_locks_off_graph_unlock() || debug_locks_silent)
 		return 0;
 
 	printk("\n=============================================\n");
@@ -972,14 +1000,14 @@ check_prev_add(struct task_struct *curr,
 	 * Debugging printouts:
 	 */
 	if (verbose(prev->class) || verbose(next->class)) {
-		__raw_spin_unlock(&hash_lock);
+		graph_unlock();
 		printk("\n new dependency: ");
 		print_lock_name(prev->class);
 		printk(" => ");
 		print_lock_name(next->class);
 		printk("\n");
 		dump_stack();
-		__raw_spin_lock(&hash_lock);
+		return graph_lock();
 	}
 	return 1;
 }
@@ -1044,8 +1072,10 @@ check_prevs_add(struct task_struct *curr
 	}
 	return 1;
 out_bug:
-	__raw_spin_unlock(&hash_lock);
-	DEBUG_LOCKS_WARN_ON(1);
+	if (!debug_locks_off_graph_unlock())
+		return 0;
+
+	WARN_ON(1);
 
 	return 0;
 }
@@ -1199,7 +1229,10 @@ register_lock_class(struct lockdep_map *
 	hash_head = classhashentry(key);
 
 	raw_local_irq_save(flags);
-	__raw_spin_lock(&hash_lock);
+	if (!graph_lock()) {
+		raw_local_irq_restore(flags);
+		return NULL;
+	}
 	/*
 	 * We have to do the hash-walk again, to avoid races
 	 * with another CPU:
@@ -1212,9 +1245,12 @@ register_lock_class(struct lockdep_map *
 	 * the hash:
 	 */
 	if (nr_lock_classes >= MAX_LOCKDEP_KEYS) {
-		__raw_spin_unlock(&hash_lock);
+		if (!debug_locks_off_graph_unlock()) {
+			raw_local_irq_restore(flags);
+			return NULL;
+		}
 		raw_local_irq_restore(flags);
-		debug_locks_off();
+
 		printk("BUG: MAX_LOCKDEP_KEYS too low!\n");
 		printk("turning off the locking correctness validator.\n");
 		return NULL;
@@ -1235,18 +1271,23 @@ register_lock_class(struct lockdep_map *
 	list_add_tail_rcu(&class->hash_entry, hash_head);
 
 	if (verbose(class)) {
-		__raw_spin_unlock(&hash_lock);
+		graph_unlock();
 		raw_local_irq_restore(flags);
+
 		printk("\nnew class %p: %s", class->key, class->name);
 		if (class->name_version > 1)
 			printk("#%d", class->name_version);
 		printk("\n");
 		dump_stack();
+
 		raw_local_irq_save(flags);
-		__raw_spin_lock(&hash_lock);
+		if (!graph_lock()) {
+			raw_local_irq_restore(flags);
+			return NULL;
+		}
 	}
 out_unlock_set:
-	__raw_spin_unlock(&hash_lock);
+	graph_unlock();
 	raw_local_irq_restore(flags);
 
 	if (!subclass || force)
@@ -1287,19 +1328,21 @@ cache_hit:
 	 * Allocate a new chain entry from the static array, and add
 	 * it to the hash:
 	 */
-	__raw_spin_lock(&hash_lock);
+	if (!graph_lock())
+		return 0;
 	/*
 	 * We have to walk the chain again locked - to avoid duplicates:
 	 */
 	list_for_each_entry(chain, hash_head, entry) {
 		if (chain->chain_key == chain_key) {
-			__raw_spin_unlock(&hash_lock);
+			graph_unlock();
 			goto cache_hit;
 		}
 	}
 	if (unlikely(nr_lock_chains >= MAX_LOCKDEP_CHAINS)) {
-		__raw_spin_unlock(&hash_lock);
-		debug_locks_off();
+		if (!debug_locks_off_graph_unlock())
+			return 0;
+
 		printk("BUG: MAX_LOCKDEP_CHAINS too low!\n");
 		printk("turning off the locking correctness validator.\n");
 		return 0;
@@ -1375,9 +1418,7 @@ print_irq_inversion_bug(struct task_stru
 			struct held_lock *this, int forwards,
 			const char *irqclass)
 {
-	__raw_spin_unlock(&hash_lock);
-	debug_locks_off();
-	if (debug_locks_silent)
+	if (!debug_locks_off_graph_unlock() || debug_locks_silent)
 		return 0;
 
 	printk("\n=========================================================\n");
@@ -1466,9 +1507,7 @@ static int
 print_usage_bug(struct task_struct *curr, struct held_lock *this,
 		enum lock_usage_bit prev_bit, enum lock_usage_bit new_bit)
 {
-	__raw_spin_unlock(&hash_lock);
-	debug_locks_off();
-	if (debug_locks_silent)
+	if (!debug_locks_off_graph_unlock() || debug_locks_silent)
 		return 0;
 
 	printk("\n=================================\n");
@@ -1529,12 +1568,13 @@ static int mark_lock(struct task_struct 
 	if (likely(this->class->usage_mask & new_mask))
 		return 1;
 
-	__raw_spin_lock(&hash_lock);
+	if (!graph_lock())
+		return 0;
 	/*
 	 * Make sure we didnt race:
 	 */
 	if (unlikely(this->class->usage_mask & new_mask)) {
-		__raw_spin_unlock(&hash_lock);
+		graph_unlock();
 		return 1;
 	}
 
@@ -1720,16 +1760,16 @@ static int mark_lock(struct task_struct 
 		debug_atomic_dec(&nr_unused_locks);
 		break;
 	default:
-		__raw_spin_unlock(&hash_lock);
-		debug_locks_off();
+		if (!debug_locks_off_graph_unlock())
+			return 0;
 		WARN_ON(1);
 		return 0;
 	}
 
-	__raw_spin_unlock(&hash_lock);
+	graph_unlock();
 
 	/*
-	 * We must printk outside of the hash_lock:
+	 * We must printk outside of the graph_lock:
 	 */
 	if (ret == 2) {
 		printk("\nmarked lock as {%s}:\n", usage_str[new_bit]);
@@ -2127,7 +2167,7 @@ out_calc_hash:
 	 * We look up the chain_key and do the O(N^2) check and update of
 	 * the dependencies only if this is a new dependency chain.
 	 * (If lookup_chain_cache() returns with 1 it acquires
-	 * hash_lock for us)
+	 * graph_lock for us)
 	 */
 	if (!trylock && (check == 2) && lookup_chain_cache(chain_key, class)) {
 		/*
@@ -2160,7 +2200,7 @@ out_calc_hash:
 		if (!chain_head && ret != 2)
 			if (!check_prevs_add(curr, hlock))
 				return 0;
-		__raw_spin_unlock(&hash_lock);
+		graph_unlock();
 	}
 	curr->lockdep_depth++;
 	check_chain_key(curr);
@@ -2472,7 +2512,7 @@ void lockdep_free_key_range(void *start,
 	int i;
 
 	raw_local_irq_save(flags);
-	__raw_spin_lock(&hash_lock);
+	graph_lock();
 
 	/*
 	 * Unhash all classes that were created by this module:
@@ -2486,7 +2526,7 @@ void lockdep_free_key_range(void *start,
 				zap_class(class);
 	}
 
-	__raw_spin_unlock(&hash_lock);
+	graph_unlock();
 	raw_local_irq_restore(flags);
 }
 
@@ -2514,20 +2554,20 @@ void lockdep_reset_lock(struct lockdep_m
 	 * Debug check: in the end all mapped classes should
 	 * be gone.
 	 */
-	__raw_spin_lock(&hash_lock);
+	graph_lock();
 	for (i = 0; i < CLASSHASH_SIZE; i++) {
 		head = classhash_table + i;
 		if (list_empty(head))
 			continue;
 		list_for_each_entry_safe(class, next, head, hash_entry) {
 			if (unlikely(class == lock->class_cache)) {
-				__raw_spin_unlock(&hash_lock);
-				DEBUG_LOCKS_WARN_ON(1);
+				if (debug_locks_off_graph_unlock())
+					WARN_ON(1);
 				goto out_restore;
 			}
 		}
 	}
-	__raw_spin_unlock(&hash_lock);
+	graph_unlock();
 
 out_restore:
 	raw_local_irq_restore(flags);
_

Patches currently in -mm which might be from mingo@elte.hu are

conditionally-check-expected_preempt_count-in-__resched_legal.patch
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
introduce-time_data-a-new-structure-to-hold-jiffies-xtime.patch
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

