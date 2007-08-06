From: akpm@linux-foundation.org
Subject: + lib-percpu_count_sum.patch added to -mm tree
Date: Mon, 06 Aug 2007 13:19:00 -0700
Message-ID: <200708062019.l76KJ0rD012912@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48078 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761819AbXHFUTL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Aug 2007 16:19:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl


The patch titled
     lib: percpu_count_sum()
has been added to the -mm tree.  Its filename is
     lib-percpu_count_sum.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lib: percpu_count_sum()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Provide an accurate version of percpu_counter_read.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu_counter.h |   18 +++++++++++++++++-
 lib/percpu_counter.c           |    6 +++---
 2 files changed, 20 insertions(+), 4 deletions(-)

diff -puN include/linux/percpu_counter.h~lib-percpu_count_sum include/linux/percpu_counter.h
--- a/include/linux/percpu_counter.h~lib-percpu_count_sum
+++ a/include/linux/percpu_counter.h
@@ -34,13 +34,24 @@ void percpu_counter_init(struct percpu_c
 void percpu_counter_destroy(struct percpu_counter *fbc);
 void percpu_counter_set(struct percpu_counter *fbc, s64 amount);
 void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch);
-s64 percpu_counter_sum_positive(struct percpu_counter *fbc);
+s64 __percpu_counter_sum(struct percpu_counter *fbc);
 
 static inline void percpu_counter_add(struct percpu_counter *fbc, s64 amount)
 {
 	__percpu_counter_add(fbc, amount, FBC_BATCH);
 }
 
+static inline s64 percpu_counter_sum_positive(struct percpu_counter *fbc)
+{
+	s64 ret = __percpu_counter_sum(fbc);
+	return ret < 0 ? 0 : ret;
+}
+
+static inline s64 percpu_counter_sum(struct percpu_counter *fbc)
+{
+	return __percpu_counter_sum(fbc);
+}
+
 static inline s64 percpu_counter_read(struct percpu_counter *fbc)
 {
 	return fbc->count;
@@ -107,6 +118,11 @@ static inline s64 percpu_counter_sum_pos
 	return percpu_counter_read_positive(fbc);
 }
 
+static inline s64 percpu_counter_sum(struct percpu_counter *fbc)
+{
+	return percpu_counter_read(fbc);
+}
+
 #endif	/* CONFIG_SMP */
 
 static inline void percpu_counter_inc(struct percpu_counter *fbc)
diff -puN lib/percpu_counter.c~lib-percpu_count_sum lib/percpu_counter.c
--- a/lib/percpu_counter.c~lib-percpu_count_sum
+++ a/lib/percpu_counter.c
@@ -52,7 +52,7 @@ EXPORT_SYMBOL(__percpu_counter_add);
  * Add up all the per-cpu counts, return the result.  This is a more accurate
  * but much slower version of percpu_counter_read_positive()
  */
-s64 percpu_counter_sum_positive(struct percpu_counter *fbc)
+s64 __percpu_counter_sum(struct percpu_counter *fbc)
 {
 	s64 ret;
 	int cpu;
@@ -64,9 +64,9 @@ s64 percpu_counter_sum_positive(struct p
 		ret += *pcount;
 	}
 	spin_unlock(&fbc->lock);
-	return ret < 0 ? 0 : ret;
+	return ret;
 }
-EXPORT_SYMBOL(percpu_counter_sum_positive);
+EXPORT_SYMBOL(__percpu_counter_sum);
 
 void percpu_counter_init(struct percpu_counter *fbc, s64 amount)
 {
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
