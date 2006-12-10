From: akpm@osdl.org
Subject: - kernel-schedc-whitespace-cleanups-more.patch removed from -mm tree
Date: Sun, 10 Dec 2006 00:25:26 -0800
Message-ID: <200612100825.kBA8PQO8018808@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:33171 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760371AbWLJIZd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 03:25:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, maxextreme@gmail.com, mingo@elte.hu, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     kernel-schedc-whitespace-cleanups-more
has been removed from the -mm tree.  Its filename was
     kernel-schedc-whitespace-cleanups-more.patch

This patch was dropped because it was folded into kernel-schedc-whitespace-cleanups.patch

------------------------------------------------------
Subject: kernel-schedc-whitespace-cleanups-more
From: Andrew Morton <akpm@osdl.org>

Cc: Miguel Ojeda Sandonis <maxextreme@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/sched.c |   61 ++++++++++++++++++++++-------------------------
 1 file changed, 29 insertions(+), 32 deletions(-)

diff -puN kernel/sched.c~kernel-schedc-whitespace-cleanups-more kernel/sched.c
--- a/kernel/sched.c~kernel-schedc-whitespace-cleanups-more
+++ a/kernel/sched.c
@@ -1457,8 +1457,9 @@ static int try_to_wake_up(struct task_st
 
 		if (this_sd->flags & SD_WAKE_AFFINE) {
 			unsigned long tl = this_load;
-			unsigned long tl_per_task =
-				cpu_avg_load_per_task(this_cpu);
+			unsigned long tl_per_task;
+
+			tl_per_task = cpu_avg_load_per_task(this_cpu);
 
 			/*
 			 * If sync wakeup then subtract the (maximum possible)
@@ -3374,7 +3375,7 @@ void fastcall add_preempt_count(int val)
 	 * Spinlock count overflowing soon?
 	 */
 	DEBUG_LOCKS_WARN_ON((preempt_count() & PREEMPT_MASK) >=
-		PREEMPT_MASK - 10);
+				PREEMPT_MASK - 10);
 }
 EXPORT_SYMBOL(add_preempt_count);
 
@@ -5449,19 +5450,19 @@ static void sched_domain_debug(struct sc
 		if (!(sd->flags & SD_LOAD_BALANCE)) {
 			printk("does not load-balance\n");
 			if (sd->parent)
-				printk(KERN_ERR "ERROR: "
-					"!SD_LOAD_BALANCE domain has parent");
+				printk(KERN_ERR "ERROR: !SD_LOAD_BALANCE domain"
+						" has parent");
 			break;
 		}
 
 		printk("span %s\n", str);
 
 		if (!cpu_isset(cpu, sd->span))
-			printk(KERN_ERR "ERROR: "
-				"domain->span does not contain CPU%d\n", cpu);
+			printk(KERN_ERR "ERROR: domain->span does not contain "
+					"CPU%d\n", cpu);
 		if (!cpu_isset(cpu, group->cpumask))
-			printk(KERN_ERR "ERROR: "
-				"domain->groups does not contain CPU%d\n", cpu);
+			printk(KERN_ERR "ERROR: domain->groups does not contain"
+					" CPU%d\n", cpu);
 
 		printk(KERN_DEBUG);
 		for (i = 0; i < level + 2; i++)
@@ -5476,8 +5477,8 @@ static void sched_domain_debug(struct sc
 
 			if (!group->cpu_power) {
 				printk("\n");
-				printk(KERN_ERR "ERROR: "
-					"domain->cpu_power not set\n");
+				printk(KERN_ERR "ERROR: domain->cpu_power not "
+						"set\n");
 			}
 
 			if (!cpus_weight(group->cpumask)) {
@@ -5500,18 +5501,17 @@ static void sched_domain_debug(struct sc
 		printk("\n");
 
 		if (!cpus_equal(sd->span, groupmask))
-			printk(KERN_ERR "ERROR: "
-				"groups don't span domain->span\n");
+			printk(KERN_ERR "ERROR: groups don't span "
+					"domain->span\n");
 
 		level++;
 		sd = sd->parent;
+		if (!sd)
+			continue;
 
-		if (sd) {
-			if (!cpus_subset(groupmask, sd->span))
-				printk(KERN_ERR "ERROR: "
-					"parent span is not a superset of "
-					"domain->span\n");
-		}
+		if (!cpus_subset(groupmask, sd->span))
+			printk(KERN_ERR "ERROR: parent span is not a superset "
+				"of domain->span\n");
 
 	} while (sd);
 }
@@ -5829,8 +5829,9 @@ __setup("max_cache_size=", setup_max_cac
  */
 static void touch_cache(void *__cache, unsigned long __size)
 {
-	unsigned long size = __size/sizeof(long), chunk1 = size/3,
-			chunk2 = 2*size/3;
+	unsigned long size = __size / sizeof(long);
+	unsigned long chunk1 = size / 3;
+	unsigned long chunk2 = 2 * size / 3;
 	unsigned long *cache = __cache;
 	int i;
 
@@ -6132,18 +6133,14 @@ static void calibrate_migration_costs(co
 			-1
 #endif
 		);
-	if (system_state == SYSTEM_BOOTING) {
-		if (num_online_cpus() > 1) {
-			printk("migration_cost=");
-			for (distance = 0; distance <= max_distance;
-				distance++) {
-				if (distance)
-					printk(",");
-				printk("%ld",
-					(long)migration_cost[distance] / 1000);
-			}
-			printk("\n");
+	if (system_state == SYSTEM_BOOTING && num_online_cpus() > 1) {
+		printk("migration_cost=");
+		for (distance = 0; distance <= max_distance; distance++) {
+			if (distance)
+				printk(",");
+			printk("%ld", (long)migration_cost[distance] / 1000);
 		}
+		printk("\n");
 	}
 	j1 = jiffies;
 	if (migration_debug)
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
submit-checklist-update.patch
io-accounting-core-statistics.patch
clean-up-__set_page_dirty_nobuffers.patch
io-accounting-write-accounting.patch
io-accounting-write-cancel-accounting.patch
io-accounting-read-accounting-2.patch
io-accounting-read-accounting-nfs-fix.patch
io-accounting-read-accounting-cifs-fix.patch
io-accounting-direct-io.patch
io-accounting-report-in-procfs.patch
cleanup-taskstatsh.patch
io-accounting-via-taskstats.patch
getdelays-various-fixes.patch
io-accounting-add-to-getdelays.patch
sched-add-option-to-serialize-load-balancing.patch
kernel-schedc-whitespace-cleanups.patch
kernel-schedc-whitespace-cleanups-more.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
swap_prefetch-vs-zoned-counters.patch
add-include-linux-freezerh-and-move-definitions-from-prefetch.patch
readahead-kconfig-options-fix.patch
readahead-minmax_ra_pages.patch
readahead-sysctl-parameters.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
readahead-context-based-method-locking-fix.patch
readahead-context-based-method-locking-fix-2.patch
readahead-call-scheme-ifdef-fix.patch
readahead-call-scheme-build-fix.patch
readahead-nfsd-case-fix.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
resier4-add-include-linux-freezerh-and-move-definitions-from.patch
make-kmem_cache_destroy-return-void-reiser4.patch
reiser4-hardirq-include-fix.patch
reiser4-run-truncate_inode_pages-in-reiser4_delete_inode.patch
reiser4-get_sb_dev-fix.patch
reiser4-vs-zoned-allocator.patch
reiser4-temp-fix.patch
reiser4-kmem_cache_t-removal.patch
hpt3xx-rework-rate-filtering-tidy.patch
jmicron-warning-fix.patch
md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure-fix.patch
statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear-tidy.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes-2.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release-fix.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc-fix.patch
gtod-persistent-clock-support-i386.patch
hrtimers-clean-up-locking-fix.patch
updated-hrtimers-state-tracking.patch
updated-i386-convert-to-clock-event-devices.patch
updated-i386-convert-to-clock-event-devices-fix.patch
updated-gtod-mark-tsc-unusable-for-highres-timers.patch
round_jiffies-infrastructure-fix.patch
clocksource-small-cleanup-2-fix.patch
kvm-userspace-interface.patch
slim-main-include-fix.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
e1000-printk-warning-fixes.patch
acpi_format_exception-debug.patch
add-debugging-aid-for-memory-initialisation-problems-fix.patch
kmap_atomic-debugging.patch
squash-ipc-warnings.patch
squash-udf-warnings.patch

