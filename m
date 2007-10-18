From: akpm@linux-foundation.org
Subject: - lib-percpu_counter-variable-batch.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:51:13 -0700
Message-ID: <200710180651.l9I6pD5k030154@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54807 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756703AbXJRGvQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 02:51:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org


The patch titled
     lib: percpu_counter variable batch
has been removed from the -mm tree.  Its filename was
     lib-percpu_counter-variable-batch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lib: percpu_counter variable batch
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Because the current batch setup has an quadric error bound on the counter,
allow for an alternative setup.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu_counter.h |   10 +++++++++-
 lib/percpu_counter.c           |    6 +++---
 2 files changed, 12 insertions(+), 4 deletions(-)

diff -puN include/linux/percpu_counter.h~lib-percpu_counter-variable-batch include/linux/percpu_counter.h
--- a/include/linux/percpu_counter.h~lib-percpu_counter-variable-batch
+++ a/include/linux/percpu_counter.h
@@ -32,9 +32,14 @@ struct percpu_counter {
 
 void percpu_counter_init(struct percpu_counter *fbc, s64 amount);
 void percpu_counter_destroy(struct percpu_counter *fbc);
-void percpu_counter_add(struct percpu_counter *fbc, s32 amount);
+void __percpu_counter_add(struct percpu_counter *fbc, s32 amount, s32 batch);
 s64 percpu_counter_sum(struct percpu_counter *fbc);
 
+static inline void percpu_counter_add(struct percpu_counter *fbc, s32 amount)
+{
+	__percpu_counter_add(fbc, amount, FBC_BATCH);
+}
+
 static inline s64 percpu_counter_read(struct percpu_counter *fbc)
 {
 	return fbc->count;
@@ -70,6 +75,9 @@ static inline void percpu_counter_destro
 {
 }
 
+#define __percpu_counter_add(fbc, amount, batch) \
+	percpu_counter_add(fbc, amount)
+
 static inline void
 percpu_counter_add(struct percpu_counter *fbc, s32 amount)
 {
diff -puN lib/percpu_counter.c~lib-percpu_counter-variable-batch lib/percpu_counter.c
--- a/lib/percpu_counter.c~lib-percpu_counter-variable-batch
+++ a/lib/percpu_counter.c
@@ -14,7 +14,7 @@ static LIST_HEAD(percpu_counters);
 static DEFINE_MUTEX(percpu_counters_lock);
 #endif
 
-void percpu_counter_add(struct percpu_counter *fbc, s32 amount)
+void __percpu_counter_add(struct percpu_counter *fbc, s32 amount, s32 batch)
 {
 	long count;
 	s32 *pcount;
@@ -22,7 +22,7 @@ void percpu_counter_add(struct percpu_co
 
 	pcount = per_cpu_ptr(fbc->counters, cpu);
 	count = *pcount + amount;
-	if (count >= FBC_BATCH || count <= -FBC_BATCH) {
+	if (count >= batch || count <= -batch) {
 		spin_lock(&fbc->lock);
 		fbc->count += count;
 		*pcount = 0;
@@ -32,7 +32,7 @@ void percpu_counter_add(struct percpu_co
 	}
 	put_cpu();
 }
-EXPORT_SYMBOL(percpu_counter_add);
+EXPORT_SYMBOL(__percpu_counter_add);
 
 /*
  * Add up all the per-cpu counts, return the result.  This is a more accurate
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
peterz-vs-ext4-mballoc-core.patch
reiserfs-fix-up-lockdep-warnings.patch
reiserfs-fix-up-lockdep-warnings-checkpatch-fixes.patch
r-o-bind-mounts-track-number-of-mount-writers-make-lockdep-happy-with-r-o-bind-mounts.patch
task-containersv11-add-procfs-interface-containers-bdi-init-hooks.patch
task-containersv11-shared-container-subsystem-group-arrays-avoid-lockdep-warning.patch
task-containersv11-shared-container-subsystem-group-arrays-include-fix.patch
workqueue-debug-flushing-deadlocks-with-lockdep.patch
workqueue-debug-work-related-deadlocks-with-lockdep.patch
lockdep-fix-mismatched-lockdep_depth-curr_chain_hash-checkpatch-fixes.patch
fix-cpusets-update_cpumask.patch
fix-cpusets-update_cpumask-checkpatch-fixes.patch
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
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
