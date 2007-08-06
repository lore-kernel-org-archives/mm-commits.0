From: akpm@linux-foundation.org
Subject: + mm-dirty-balancing-for-tasks.patch added to -mm tree
Date: Mon, 06 Aug 2007 13:19:19 -0700
Message-ID: <200708062019.l76KJJCT012967@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48999 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760029AbXHFUZh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Aug 2007 16:25:37 -0400
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
that the two approached appear quite similar.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    2 +
 kernel/exit.c         |    1 
 kernel/fork.c         |    8 +++++
 mm/page-writeback.c   |   56 +++++++++++++++++++++++++++++++++++++++-
 4 files changed, 66 insertions(+), 1 deletion(-)

diff -puN include/linux/sched.h~mm-dirty-balancing-for-tasks include/linux/sched.h
--- a/include/linux/sched.h~mm-dirty-balancing-for-tasks
+++ a/include/linux/sched.h
@@ -86,6 +86,7 @@ struct sched_param {
 #include <linux/timer.h>
 #include <linux/hrtimer.h>
 #include <linux/task_io_accounting.h>
+#include <linux/proportions.h>
 
 #include <asm/processor.h>
 
@@ -1194,6 +1195,7 @@ struct task_struct {
 #ifdef CONFIG_FAULT_INJECTION
 	int make_it_fail;
 #endif
+	struct prop_local_single dirties;
 };
 
 /*
diff -puN kernel/exit.c~mm-dirty-balancing-for-tasks kernel/exit.c
--- a/kernel/exit.c~mm-dirty-balancing-for-tasks
+++ a/kernel/exit.c
@@ -161,6 +161,7 @@ repeat:
 	ptrace_unlink(p);
 	BUG_ON(!list_empty(&p->ptrace_list) || !list_empty(&p->ptrace_children));
 	__exit_signal(p);
+	prop_local_destroy(&p->dirties);
 
 	/*
 	 * If we are the last non-leader member of the thread
diff -puN kernel/fork.c~mm-dirty-balancing-for-tasks kernel/fork.c
--- a/kernel/fork.c~mm-dirty-balancing-for-tasks
+++ a/kernel/fork.c
@@ -163,6 +163,7 @@ static struct task_struct *dup_task_stru
 {
 	struct task_struct *tsk;
 	struct thread_info *ti;
+	int err;
 
 	prepare_to_copy(orig);
 
@@ -176,6 +177,13 @@ static struct task_struct *dup_task_stru
 		return NULL;
 	}
 
+	err = prop_local_init(&tsk->dirties);
+	if (err) {
+		free_thread_info(ti);
+		free_task_struct(tsk);
+		return NULL;
+	}
+
 	*tsk = *orig;
 	tsk->stack = ti;
 	setup_thread_stack(tsk, orig);
diff -puN mm/page-writeback.c~mm-dirty-balancing-for-tasks mm/page-writeback.c
--- a/mm/page-writeback.c~mm-dirty-balancing-for-tasks
+++ a/mm/page-writeback.c
@@ -118,6 +118,7 @@ static void background_writeout(unsigned
  *
  */
 static struct prop_descriptor vm_completions;
+static struct prop_descriptor vm_dirties;
 
 static unsigned long determine_dirtyable_memory(void);
 
@@ -146,6 +147,7 @@ int dirty_ratio_handler(ctl_table *table
 	if (ret == 0 && write && vm_dirty_ratio != old_ratio) {
 		int shift = calc_period_shift();
 		prop_change_shift(&vm_completions, shift);
+		prop_change_shift(&vm_dirties, shift);
 	}
 	return ret;
 }
@@ -161,6 +163,16 @@ static void __bdi_writeout_inc(struct ba
 	prop_put_global(&vm_completions, pg);
 }
 
+static void task_dirty_inc(struct task_struct *tsk)
+{
+	unsigned long flags;
+	struct prop_global *pg = prop_get_global(&vm_dirties);
+	local_irq_save(flags);
+	__prop_inc(pg, &tsk->dirties);
+	local_irq_restore(flags);
+	prop_put_global(&vm_dirties, pg);
+}
+
 /*
  * Obtain an accurate fraction of the BDI's portion.
  */
@@ -201,6 +213,38 @@ clip_bdi_dirty_limit(struct backing_dev_
 	*pbdi_dirty = min(*pbdi_dirty, avail_dirty);
 }
 
+void task_dirties_fraction(struct task_struct *tsk,
+		long *numerator, long *denominator)
+{
+	struct prop_global *pg = prop_get_global(&vm_dirties);
+	prop_fraction(pg, &tsk->dirties, numerator, denominator);
+	prop_put_global(&vm_dirties, pg);
+}
+
+/*
+ * scale the dirty limit
+ *
+ * task specific dirty limit:
+ *
+ *   dirty -= (dirty/2) * p_{t}
+ */
+void task_dirty_limit(struct task_struct *tsk, long *pdirty)
+{
+	long numerator, denominator;
+	long dirty = *pdirty;
+	long long inv = dirty >> 1;
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
@@ -307,6 +351,7 @@ get_dirty_limits(long *pbackground, long
 
 		*pbdi_dirty = bdi_dirty;
 		clip_bdi_dirty_limit(bdi, dirty, pbdi_dirty);
+		task_dirty_limit(current, pbdi_dirty);
 	}
 }
 
@@ -728,6 +773,7 @@ void __init page_writeback_init(void)
 
 	shift = calc_period_shift();
 	prop_descriptor_init(&vm_completions, shift);
+	prop_descriptor_init(&vm_dirties, shift);
 }
 
 /**
@@ -1006,7 +1052,7 @@ EXPORT_SYMBOL(redirty_page_for_writepage
  * If the mapping doesn't provide a set_page_dirty a_op, then
  * just fall through and assume that it wants buffer_heads.
  */
-int fastcall set_page_dirty(struct page *page)
+static int __set_page_dirty(struct page *page)
 {
 	struct address_space *mapping = page_mapping(page);
 
@@ -1024,6 +1070,14 @@ int fastcall set_page_dirty(struct page 
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
lib-floating-proportions-_single.patch
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
containers-bdi-init-hooks.patch
workqueue-debug-flushing-deadlocks-with-lockdep.patch
workqueue-debug-work-related-deadlocks-with-lockdep.patch
