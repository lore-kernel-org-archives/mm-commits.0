From: akpm@linux-foundation.org
Subject: + mm-dirty-balancing-for-tasks.patch added to -mm tree
Date: Fri, 14 Sep 2007 04:21:07 -0700
Message-ID: <200709141121.l8EBL7n9002328@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46769 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751647AbXINL2N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Sep 2007 07:28:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl


The patch titled
     mm: dirty balancing for tasks
has been added to the -mm tree.  Its filename is
     mm-dirty-balancing-for-tasks.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm: dirty balancing for tasks
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Based on ideas of Andrew:
  http://marc.info/?l=linux-kernel&m=102912915020543&w=2

Scale the bdi dirty limit inversly with the tasks dirty rate.
This makes heavy writers have a lower dirty limit than the occasional writer.

Andrea proposed something similar:
  http://lwn.net/Articles/152277/

The main disadvantage to his patch is that he uses an unrelated quantity to
measure time, which leaves him with a workload dependant tunable. Other than
that the two approaches appear quite similar.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/init_task.h |    1 
 include/linux/sched.h     |    2 +
 kernel/fork.c             |   10 +++++++
 mm/page-writeback.c       |   50 +++++++++++++++++++++++++++++++++++-
 4 files changed, 62 insertions(+), 1 deletion(-)

diff -puN include/linux/init_task.h~mm-dirty-balancing-for-tasks include/linux/init_task.h
--- a/include/linux/init_task.h~mm-dirty-balancing-for-tasks
+++ a/include/linux/init_task.h
@@ -169,6 +169,7 @@ extern struct group_info init_groups;
 		[PIDTYPE_PGID] = INIT_PID_LINK(PIDTYPE_PGID),		\
 		[PIDTYPE_SID]  = INIT_PID_LINK(PIDTYPE_SID),		\
 	},								\
+	.dirties = INIT_PROP_LOCAL_SINGLE(dirties),			\
 	INIT_TRACE_IRQFLAGS						\
 	INIT_LOCKDEP							\
 }
diff -puN include/linux/sched.h~mm-dirty-balancing-for-tasks include/linux/sched.h
--- a/include/linux/sched.h~mm-dirty-balancing-for-tasks
+++ a/include/linux/sched.h
@@ -84,6 +84,7 @@ struct sched_param {
 #include <linux/timer.h>
 #include <linux/hrtimer.h>
 #include <linux/task_io_accounting.h>
+#include <linux/proportions.h>
 
 #include <asm/processor.h>
 
@@ -1123,6 +1124,7 @@ struct task_struct {
 #ifdef CONFIG_FAULT_INJECTION
 	int make_it_fail;
 #endif
+	struct prop_local_single dirties;
 };
 
 /*
diff -puN kernel/fork.c~mm-dirty-balancing-for-tasks kernel/fork.c
--- a/kernel/fork.c~mm-dirty-balancing-for-tasks
+++ a/kernel/fork.c
@@ -107,6 +107,7 @@ static struct kmem_cache *mm_cachep;
 
 void free_task(struct task_struct *tsk)
 {
+	prop_local_destroy_single(&tsk->dirties);
 	free_thread_info(tsk->stack);
 	rt_mutex_debug_task_free(tsk);
 	free_task_struct(tsk);
@@ -163,6 +164,7 @@ static struct task_struct *dup_task_stru
 {
 	struct task_struct *tsk;
 	struct thread_info *ti;
+	int err;
 
 	prepare_to_copy(orig);
 
@@ -178,6 +180,14 @@ static struct task_struct *dup_task_stru
 
 	*tsk = *orig;
 	tsk->stack = ti;
+
+	err = prop_local_init_single(&tsk->dirties);
+	if (err) {
+		free_thread_info(ti);
+		free_task_struct(tsk);
+		return NULL;
+	}
+
 	setup_thread_stack(tsk, orig);
 
 #ifdef CONFIG_CC_STACKPROTECTOR
diff -puN mm/page-writeback.c~mm-dirty-balancing-for-tasks mm/page-writeback.c
--- a/mm/page-writeback.c~mm-dirty-balancing-for-tasks
+++ a/mm/page-writeback.c
@@ -118,6 +118,7 @@ static void background_writeout(unsigned
  *
  */
 static struct prop_descriptor vm_completions;
+static struct prop_descriptor vm_dirties;
 
 static unsigned long determine_dirtyable_memory(void);
 
@@ -146,6 +147,7 @@ int dirty_ratio_handler(struct ctl_table
 	if (ret == 0 && write && vm_dirty_ratio != old_ratio) {
 		int shift = calc_period_shift();
 		prop_change_shift(&vm_completions, shift);
+		prop_change_shift(&vm_dirties, shift);
 	}
 	return ret;
 }
@@ -159,6 +161,11 @@ static inline void __bdi_writeout_inc(st
 	__prop_inc_percpu(&vm_completions, &bdi->completions);
 }
 
+static inline void task_dirty_inc(struct task_struct *tsk)
+{
+	prop_inc_single(&vm_dirties, &tsk->dirties);
+}
+
 /*
  * Obtain an accurate fraction of the BDI's portion.
  */
@@ -198,6 +205,37 @@ clip_bdi_dirty_limit(struct backing_dev_
 	*pbdi_dirty = min(*pbdi_dirty, avail_dirty);
 }
 
+static inline void task_dirties_fraction(struct task_struct *tsk,
+		long *numerator, long *denominator)
+{
+	prop_fraction_single(&vm_dirties, &tsk->dirties,
+				numerator, denominator);
+}
+
+/*
+ * scale the dirty limit
+ *
+ * task specific dirty limit:
+ *
+ *   dirty -= (dirty/8) * p_{t}
+ */
+void task_dirty_limit(struct task_struct *tsk, long *pdirty)
+{
+	long numerator, denominator;
+	long dirty = *pdirty;
+	long long inv = dirty >> 3;
+
+	task_dirties_fraction(tsk, &numerator, &denominator);
+	inv *= numerator;
+	do_div(inv, denominator);
+
+	dirty -= inv;
+	if (dirty < *pdirty/2)
+		dirty = *pdirty/2;
+
+	*pdirty = dirty;
+}
+
 /*
  * Work out the current dirty-memory clamping and background writeout
  * thresholds.
@@ -303,6 +341,7 @@ get_dirty_limits(long *pbackground, long
 
 		*pbdi_dirty = bdi_dirty;
 		clip_bdi_dirty_limit(bdi, dirty, pbdi_dirty);
+		task_dirty_limit(current, pbdi_dirty);
 	}
 }
 
@@ -724,6 +763,7 @@ void __init page_writeback_init(void)
 
 	shift = calc_period_shift();
 	prop_descriptor_init(&vm_completions, shift);
+	prop_descriptor_init(&vm_dirties, shift);
 }
 
 /**
@@ -1002,7 +1042,7 @@ EXPORT_SYMBOL(redirty_page_for_writepage
  * If the mapping doesn't provide a set_page_dirty a_op, then
  * just fall through and assume that it wants buffer_heads.
  */
-int fastcall set_page_dirty(struct page *page)
+static int __set_page_dirty(struct page *page)
 {
 	struct address_space *mapping = page_mapping(page);
 
@@ -1020,6 +1060,14 @@ int fastcall set_page_dirty(struct page 
 	}
 	return 0;
 }
+
+int fastcall set_page_dirty(struct page *page)
+{
+	int ret = __set_page_dirty(page);
+	if (ret)
+		task_dirty_inc(current);
+	return ret;
+}
 EXPORT_SYMBOL(set_page_dirty);
 
 /*
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

radix-tree-use-indirect-bit.patch
nfs-remove-congestion_end.patch
lib-percpu_counter_add.patch
lib-percpu_counter_sub.patch
lib-percpu_counter-variable-batch.patch
lib-make-percpu_counter_add-take-s64.patch
lib-percpu_counter_set.patch
lib-percpu_counter_sum_positive.patch
lib-percpu_count_sum.patch
lib-percpu_counter_init-error-handling.patch
lib-percpu_counter_init_irq.patch
mm-bdi-init-hooks.patch
mtd-bdi-init-hooks.patch
mtd-clean-up-the-backing_dev_info-usage.patch
mtd-give-mtdconcat-devices-their-own-backing_dev_info.patch
mm-scalable-bdi-statistics-counters.patch
mm-count-reclaimable-pages-per-bdi.patch
mm-count-writeback-pages-per-bdi.patch
mm-expose-bdi-statistics-in-sysfs.patch
lib-floating-proportions.patch
mm-per-device-dirty-threshold.patch
mm-dirty-balancing-for-tasks.patch
debug-sysfs-files-for-the-current-ratio-size-total.patch
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
task-containersv11-shared-container-subsystem-group-arrays-avoid-lockdep-warning.patch
task-containersv11-shared-container-subsystem-group-arrays-include-fix.patch
containers-bdi-init-hooks.patch
workqueue-debug-flushing-deadlocks-with-lockdep.patch
workqueue-debug-work-related-deadlocks-with-lockdep.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
