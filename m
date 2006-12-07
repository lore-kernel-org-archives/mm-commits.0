From: akpm@osdl.org
Subject: + lockdep-fix-possible-races-while-disabling-lock-debugging.patch added to -mm tree
Date: Thu, 07 Dec 2006 12:42:04 -0800
Message-ID: <200612072042.kB7Kg5xZ024958@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37097 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163317AbWLGUmd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 15:42:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu, jarkao2@o2.pl


The patch titled
     lockdep: fix possible races while disabling lock-debugging
has been added to the -mm tree.  Its filename is
     lockdep-fix-possible-races-while-disabling-lock-debugging.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Jarek Poplawski <jarkao2@o2.pl>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/lockdep.c |  164 +++++++++++++++++++++++++++------------------
 1 files changed, 101 insertions(+), 63 deletions(-)

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
@@ -973,14 +1001,14 @@ check_prev_add(struct task_struct *curr,
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
@@ -1045,8 +1073,10 @@ check_prevs_add(struct task_struct *curr
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
@@ -1200,7 +1230,8 @@ register_lock_class(struct lockdep_map *
 	hash_head = classhashentry(key);
 
 	raw_local_irq_save(flags);
-	__raw_spin_lock(&hash_lock);
+	if (!graph_lock())
+		return NULL;
 	/*
 	 * We have to do the hash-walk again, to avoid races
 	 * with another CPU:
@@ -1213,9 +1244,12 @@ register_lock_class(struct lockdep_map *
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
@@ -1236,18 +1270,23 @@ register_lock_class(struct lockdep_map *
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
@@ -1288,19 +1327,21 @@ cache_hit:
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
@@ -1376,9 +1417,7 @@ print_irq_inversion_bug(struct task_stru
 			struct held_lock *this, int forwards,
 			const char *irqclass)
 {
-	__raw_spin_unlock(&hash_lock);
-	debug_locks_off();
-	if (debug_locks_silent)
+	if (!debug_locks_off_graph_unlock() || debug_locks_silent)
 		return 0;
 
 	printk("\n=========================================================\n");
@@ -1467,9 +1506,7 @@ static int
 print_usage_bug(struct task_struct *curr, struct held_lock *this,
 		enum lock_usage_bit prev_bit, enum lock_usage_bit new_bit)
 {
-	__raw_spin_unlock(&hash_lock);
-	debug_locks_off();
-	if (debug_locks_silent)
+	if (!debug_locks_off_graph_unlock() || debug_locks_silent)
 		return 0;
 
 	printk("\n=================================\n");
@@ -1530,12 +1567,13 @@ static int mark_lock(struct task_struct 
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
 
@@ -1727,10 +1765,10 @@ static int mark_lock(struct task_struct 
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
@@ -2128,7 +2166,7 @@ out_calc_hash:
 	 * We look up the chain_key and do the O(N^2) check and update of
 	 * the dependencies only if this is a new dependency chain.
 	 * (If lookup_chain_cache() returns with 1 it acquires
-	 * hash_lock for us)
+	 * graph_lock for us)
 	 */
 	if (!trylock && (check == 2) && lookup_chain_cache(chain_key, class)) {
 		/*
@@ -2161,7 +2199,7 @@ out_calc_hash:
 		if (!chain_head && ret != 2)
 			if (!check_prevs_add(curr, hlock))
 				return 0;
-		__raw_spin_unlock(&hash_lock);
+		graph_unlock();
 	}
 	curr->lockdep_depth++;
 	check_chain_key(curr);
@@ -2473,7 +2511,7 @@ void lockdep_free_key_range(void *start,
 	int i;
 
 	raw_local_irq_save(flags);
-	__raw_spin_lock(&hash_lock);
+	graph_lock();
 
 	/*
 	 * Unhash all classes that were created by this module:
@@ -2487,7 +2525,7 @@ void lockdep_free_key_range(void *start,
 				zap_class(class);
 	}
 
-	__raw_spin_unlock(&hash_lock);
+	graph_unlock();
 	raw_local_irq_restore(flags);
 }
 
@@ -2515,20 +2553,20 @@ void lockdep_reset_lock(struct lockdep_m
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

origin.patch
add-bottom_half.h.patch
convert-pm_sem-to-a-mutex.patch
lockdep-annotate-nfs-nfsd-in-kernel-sockets.patch
sysrq-x-show-blocked-tasks.patch
lockdep-internal-locking-fixes.patch
lockdep-misc-fixes-in-lockdepc.patch
binfmt_elf-randomize-pie-binaries.patch
disable-clone_child_cleartid-for-abnormal-exit.patch
lockdep-annotate-bcsp-driver.patch
lockdep-print-current-locks-on-in_atomic-warnings.patch
lockdep-name-some-old-style-locks.patch
sleep-profiling.patch
debug-workqueue-locking-sanity.patch
retries-in-ext3_prepare_write-violate-ordering-requirements.patch
retries-in-ext4_prepare_write-violate-ordering-requirements.patch
ktime-fix-signed--unsigned-mismatch-in-ktime_to_ns.patch
kprobes-enable-booster-on-the-preemptible-kernel.patch
declare-smp_call_function_single-in-generic-code.patch
smp_call_function_single-check-that-local-interrupts-are-enabled.patch
hotplug-cpu-clean-up-hotcpu_notifier-use.patch
remove-kernel-lockdepclockdep_internal.patch
lockdep-more-chains.patch
lockdep-show-more-details-about-self-test-failures.patch
softirq-remove-bug_ons-which-can-incorrectly-trigger.patch
futex-remove-unneeded-barrier.patch
lockdep-register_lock_class-fix.patch
add-ignore_loglevel-boot-option.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
acpi-i686-x86_64-fix-laptop-bootup-hang-in-init_acpi.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
convert-i386-pda-code-to-use-%fs.patch
genapic-optimize-fix-apic-mode-setup-2.patch
genapic-always-use-physical-delivery-mode-on-8-cpus.patch
genapic-remove-es7000-workaround.patch
genapic-remove-clustered-apic-mode.patch
genapic-default-to-physical-mode-on-hotplug-cpu-kernels.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
cpei-gets-warning-at-kernel-irq-migrationc27-move_masked_irq.patch
time-re-add-verify_pmtmr_rate.patch
debug-add-sysrq_always_enabled-boot-option.patch
lockdep-filter-off-by-default.patch
lockdep-improve-verbose-messages.patch
lockdep-improve-lockdep_reset.patch
lockdep-clean-up-very_verbose-define.patch
lockdep-use-chain-hash-on-config_debug_lockdep-too.patch
lockdep-print-irq-trace-info-on-asserts.patch
lockdep-fix-possible-races-while-disabling-lock-debugging.patch
remove-the-old-bd_mutex-lockdep-annotation.patch
new-bd_mutex-lockdep-annotation.patch
remove-lock_key-approach-to-managing-nested-bd_mutex-locks.patch
simplify-some-aspects-of-bd_mutex-nesting.patch
use-mutex_lock_nested-for-bd_mutex-to-avoid-lockdep-warning.patch
avoid-lockdep-warning-in-md.patch
fix-generic-warn_on-message.patch
schedc-correct-comment-for-this_rq_lock-routine.patch
sched-fix-migration-cost-estimator.patch
sched-domain-move-sched-group-allocations-to-percpu-area.patch
move_task_off_dead_cpu-should-be-called-with-disabled-ints.patch
sched-domain-increase-the-smt-busy-rebalance-interval.patch
sched-avoid-taking-rq-lock-in-wake_priority_sleeper.patch
sched-remove-staggering-of-load-balancing.patch
sched-disable-interrupts-for-locking-in-load_balance.patch
sched-extract-load-calculation-from-rebalance_tick.patch
sched-move-idle-status-calculation-into-rebalance_tick.patch
sched-use-softirq-for-load-balancing.patch
sched-call-tasklet-less-frequently.patch
sched-add-option-to-serialize-load-balancing.patch
sched-add-option-to-serialize-load-balancing-fix.patch
sched-improve-migration-accuracy.patch
sched-improve-migration-accuracy-tidy.patch
sched-decrease-number-of-load-balances.patch
sched-remove-lb_stopbalance-counter.patch
sched-optimize-activate_task-for-rt-task.patch
kernel-schedc-whitespace-cleanups.patch
kernel-schedc-whitespace-cleanups-more.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
sched-cleanup-remove-task_t-convert-to-struct-task_struct-prefetch.patch
gtod-persistent-clock-support-core.patch
gtod-persistent-clock-support-i386.patch
time-uninline-jiffiesh.patch
time-uninline-jiffiesh-fix.patch
time-fix-msecs_to_jiffies-bug.patch
time-fix-timeout-overflow.patch
cleanup-uninline-irq_enter-and-move-it-into-a-function.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie-remove-incorrect-warning-in-kernel-timerc.patch
hrtimers-namespace-and-enum-cleanup.patch
hrtimers-clean-up-locking.patch
hrtimers-clean-up-locking-fix.patch
updated-hrtimers-state-tracking.patch
updated-hrtimers-clean-up-callback-tracking.patch
updated-hrtimers-move-and-add-documentation.patch
updated-add-a-framework-to-manage-clock-event-devices.patch
updated-acpi-include-apich.patch
updated-acpi-keep-track-of-timer-broadcast.patch
updated-acpi-add-state-propagation-for-dynamic-broadcasting.patch
updated-i386-cleanup-apic-code.patch
updated-i386-convert-to-clock-event-devices.patch
updated-pm_timer-allow-early-access-and-move-externs-to-a-header-file.patch
updated-i386-rework-local-apic-calibration.patch
updated-high-res-timers-core.patch
updated-high-res-timers-core-high-res-timers-do-itimer-rearming-in-process-context.patch
updated-gtod-mark-tsc-unusable-for-highres-timers.patch
high-res-timers-utilize-tsc-clocksource-again.patch
high-res-timers-utilize-tsc-clocksource-again-fix.patch
updated-dynticks-core-code.patch
updated-dynticks-core-code-fix-resume-bug.patch
updated-dyntick-add-nohz-stats-to-proc-stat.patch
updated-dynticks-i386-arch-code.patch
updated-dynticks-fix-nmi-watchdog.patch
updated-high-res-timers-dynticks-enable-i386-support.patch
updated-debugging-feature-timer-stats.patch
clockevents-core-check-for-clock-event-device-handler-being-non-null-before-calling-it.patch
round_jiffies-infrastructure.patch
round_jiffies-infrastructure-fix.patch
clocksource-add-usage-of-config_sysfs.patch
clocksource-small-cleanup-2.patch
clocksource-small-cleanup-2-fix.patch
clocksource-small-acpi_pm-cleanup.patch
kvm-amd-svm-implementation-more-i386-fixes.patch
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

