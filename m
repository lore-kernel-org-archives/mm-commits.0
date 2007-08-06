From: akpm@linux-foundation.org
Subject: + lib-floating-proportions-_single.patch added to -mm tree
Date: Mon, 06 Aug 2007 13:19:15 -0700
Message-ID: <200708062019.l76KJFUx012961@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58622 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761397AbXHFUZi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Aug 2007 16:25:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl


The patch titled
     lib: floating proportions _single
has been added to the -mm tree.  Its filename is
     lib-floating-proportions-_single.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lib: floating proportions _single
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Provide a prop_local that does not use a percpu variable for its counter.
This is useful for items that are not (or infrequently) accessed from
multiple context and/or are plenty enought that the percpu_counter overhead
will hurt (tasks).

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/proportions.h |  113 ++++++++++++++++++++++++++++--
 lib/proportions.c           |  125 +++++++++++++++++++++++++++++++---
 2 files changed, 220 insertions(+), 18 deletions(-)

diff -puN include/linux/proportions.h~lib-floating-proportions-_single include/linux/proportions.h
--- a/include/linux/proportions.h~lib-floating-proportions-_single
+++ a/include/linux/proportions.h
@@ -45,7 +45,11 @@ void prop_change_shift(struct prop_descr
 struct prop_global *prop_get_global(struct prop_descriptor *pd);
 void prop_put_global(struct prop_descriptor *pd, struct prop_global *pg);
 
-struct prop_local {
+/*
+ * ----- PERCPU ------
+ */
+
+struct prop_local_percpu {
 	/*
 	 * the local events counter
 	 */
@@ -59,23 +63,118 @@ struct prop_local {
 	spinlock_t lock;		/* protect the snapshot state */
 };
 
-int prop_local_init(struct prop_local *pl);
-void prop_local_destroy(struct prop_local *pl);
+int prop_local_init_percpu(struct prop_local_percpu *pl);
+void prop_local_destroy_percpu(struct prop_local_percpu *pl);
 
-void prop_norm(struct prop_global *pg, struct prop_local *pl);
+void prop_norm_percpu(struct prop_global *pg, struct prop_local_percpu *pl);
 
 /*
  *   ++x_{j}, ++t
  */
 static inline
-void __prop_inc(struct prop_global *pg, struct prop_local *pl)
+void __prop_inc_percpu(struct prop_global *pg, struct prop_local_percpu *pl)
 {
-	prop_norm(pg, pl);
+	prop_norm_percpu(pg, pl);
 	percpu_counter_add(&pl->events, 1);
 	percpu_counter_add(&pg->events, 1);
 }
 
-void prop_fraction(struct prop_global *pg, struct prop_local *pl,
+void prop_fraction_percpu(struct prop_global *pg, struct prop_local_percpu *pl,
+		long *numerator, long *denominator);
+
+/*
+ * ----- SINGLE ------
+ */
+
+struct prop_local_single {
+	/*
+	 * the local events counter
+	 */
+	unsigned long events;
+
+	/*
+	 * snapshot of the last seen global state
+	 * and a lock protecting this state
+	 */
+	int shift;
+	unsigned long period;
+	spinlock_t lock;		/* protect the snapshot state */
+};
+
+int prop_local_init_single(struct prop_local_single *pl);
+void prop_local_destroy_single(struct prop_local_single *pl);
+
+void prop_norm_single(struct prop_global *pg, struct prop_local_single *pl);
+
+/*
+ *   ++x_{j}, ++t
+ */
+static inline
+void __prop_inc_single(struct prop_global *pg, struct prop_local_single *pl)
+{
+	prop_norm_single(pg, pl);
+	pl->events++;
+	percpu_counter_add(&pg->events, 1);
+}
+
+void prop_fraction_single(struct prop_global *pg, struct prop_local_single *pl,
 		long *numerator, long *denominator);
 
+/*
+ * ----- GLUE ------
+ */
+
+#undef TYPE_EQUAL
+#define TYPE_EQUAL(expr, type) \
+	__builtin_types_compatible_p(typeof(expr), type)
+
+extern int __bad_prop_local(void);
+
+#define prop_local_init(prop_local)					\
+({	int err;							\
+	if (TYPE_EQUAL(*(prop_local), struct prop_local_percpu))	\
+		err = prop_local_init_percpu(				\
+			(struct prop_local_percpu *)(prop_local));	\
+	else if (TYPE_EQUAL(*(prop_local), struct prop_local_single))	\
+		err = prop_local_init_single(				\
+			(struct prop_local_single *)(prop_local));	\
+	else __bad_prop_local();					\
+	err;								\
+})
+
+#define prop_local_destroy(prop_local)					\
+do {									\
+	if (TYPE_EQUAL(*(prop_local), struct prop_local_percpu))	\
+		prop_local_destroy_percpu(				\
+			(struct prop_local_percpu *)(prop_local));	\
+	else if (TYPE_EQUAL(*(prop_local), struct prop_local_single))	\
+		prop_local_destroy_single(				\
+			(struct prop_local_single *)(prop_local));	\
+	else __bad_prop_local();					\
+} while (0)
+
+#define __prop_inc(prop_global, prop_local)				\
+do {									\
+	if (TYPE_EQUAL(*(prop_local), struct prop_local_percpu))	\
+		__prop_inc_percpu(prop_global,				\
+			(struct prop_local_percpu *)(prop_local)); 	\
+	else if (TYPE_EQUAL(*(prop_local), struct prop_local_single))	\
+		__prop_inc_single(prop_global,				\
+			(struct prop_local_single *)(prop_local)); 	\
+	else __bad_prop_local();					\
+} while (0)
+
+#define prop_fraction(prop_global, prop_local, num, denom)		\
+do {									\
+	if (TYPE_EQUAL(*(prop_local), struct prop_local_percpu))	\
+		prop_fraction_percpu(prop_global,			\
+			(struct prop_local_percpu *)(prop_local),	\
+			num, denom);					\
+	else if (TYPE_EQUAL(*(prop_local), struct prop_local_single))	\
+		prop_fraction_single(prop_global,			\
+			(struct prop_local_single *)(prop_local),	\
+			num, denom);					\
+	else __bad_prop_local();					\
+} while (0)
+
 #endif /* _LINUX_PROPORTIONS_H */
diff -puN lib/proportions.c~lib-floating-proportions-_single lib/proportions.c
--- a/lib/proportions.c~lib-floating-proportions-_single
+++ a/lib/proportions.c
@@ -159,22 +159,31 @@ void prop_put_global(struct prop_descrip
 	rcu_read_unlock();
 }
 
-static void prop_adjust_shift(struct prop_local *pl, int new_shift)
+static void
+__prop_adjust_shift(int *pl_shift, unsigned long *pl_period, int new_shift)
 {
-	int offset = pl->shift - new_shift;
+	int offset = *pl_shift - new_shift;
 
 	if (!offset)
 		return;
 
 	if (offset < 0)
-		pl->period <<= -offset;
+		*pl_period <<= -offset;
 	else
-		pl->period >>= offset;
+		*pl_period >>= offset;
 
-	pl->shift = new_shift;
+	*pl_shift = new_shift;
 }
 
-int prop_local_init(struct prop_local *pl)
+#define prop_adjust_shift(prop_local, pg_shift)			\
+	__prop_adjust_shift(&(prop_local)->shift,		\
+			    &(prop_local)->period, pg_shift)
+
+/*
+ * PERCPU
+ */
+
+int prop_local_init_percpu(struct prop_local_percpu *pl)
 {
 	spin_lock_init(&pl->lock);
 	pl->shift = 0;
@@ -182,7 +191,7 @@ int prop_local_init(struct prop_local *p
 	return percpu_counter_init_irq(&pl->events, 0);
 }
 
-void prop_local_destroy(struct prop_local *pl)
+void prop_local_destroy_percpu(struct prop_local_percpu *pl)
 {
 	percpu_counter_destroy(&pl->events);
 }
@@ -194,8 +203,7 @@ void prop_local_destroy(struct prop_loca
  *     x_{j} -= x_{j}/2;
  *     c_{j}++;
  */
-void prop_norm(struct prop_global *pg,
-		struct prop_local *pl)
+void prop_norm_percpu(struct prop_global *pg, struct prop_local_percpu *pl)
 {
 	unsigned long period = 1UL << (pg->shift - 1);
 	unsigned long period_mask = ~(period - 1);
@@ -248,17 +256,112 @@ void prop_norm(struct prop_global *pg,
  *
  *   p_{j} = x_{j} / (period/2 + t % period/2)
  */
-void prop_fraction(struct prop_global *pg, struct prop_local *pl,
+void prop_fraction_percpu(struct prop_global *pg, struct prop_local_percpu *pl,
 		long *numerator, long *denominator)
 {
 	unsigned long period_2 = 1UL << (pg->shift - 1);
 	unsigned long counter_mask = period_2 - 1;
 	unsigned long global_count;
 
-	prop_norm(pg, pl);
+	prop_norm_percpu(pg, pl);
 	*numerator = percpu_counter_read_positive(&pl->events);
 
 	global_count = percpu_counter_read(&pg->events);
 	*denominator = period_2 + (global_count & counter_mask);
 }
 
+/*
+ * SINGLE
+ */
+
+int prop_local_init_single(struct prop_local_single *pl)
+{
+	spin_lock_init(&pl->lock);
+	pl->shift = 0;
+	pl->period = 0;
+	pl->events = 0;
+	return 0;
+}
+
+void prop_local_destroy_single(struct prop_local_single *pl)
+{
+}
+
+/*
+ * Catch up with missed period expirations.
+ *
+ *   until (c_{j} == c)
+ *     x_{j} -= x_{j}/2;
+ *     c_{j}++;
+ */
+void prop_norm_single(struct prop_global *pg, struct prop_local_single *pl)
+{
+	unsigned long period = 1UL << (pg->shift - 1);
+	unsigned long period_mask = ~(period - 1);
+	unsigned long global_period;
+	unsigned long flags;
+
+	global_period = percpu_counter_read(&pg->events);
+	global_period &= period_mask;
+
+	/*
+	 * Fast path - check if the local and global period count still match
+	 * outside of the lock.
+	 */
+	if (pl->period == global_period)
+		return;
+
+	spin_lock_irqsave(&pl->lock, flags);
+	prop_adjust_shift(pl, pg->shift);
+	/*
+	 * For each missed period, we half the local counter.
+	 * basically:
+	 *   pl->events >> (global_period - pl->period);
+	 *
+	 * but since the distributed nature of single counters make division
+	 * rather hard, use a regular subtraction loop. This is safe, because
+	 * the events will only every be incremented, hence the subtraction
+	 * can never result in a negative number.
+	 */
+	while (pl->period != global_period) {
+		unsigned long val = pl->events;
+		unsigned long half = (val + 1) >> 1;
+
+		/*
+		 * Half of zero won't be much less, break out.
+		 * This limits the loop to shift iterations, even
+		 * if we missed a million.
+		 */
+		if (!val)
+			break;
+
+		/*
+		 * Iff shift >32 half might exceed the limits of
+		 * the regular single_counter_mod.
+		 */
+		pl->events -= half;
+		pl->period += period;
+	}
+	pl->period = global_period;
+	spin_unlock_irqrestore(&pl->lock, flags);
+}
+
+/*
+ * Obtain an fraction of this proportion
+ *
+ *   p_{j} = x_{j} / (period/2 + t % period/2)
+ */
+void prop_fraction_single(struct prop_global *pg, struct prop_local_single *pl,
+		long *numerator, long *denominator)
+{
+	unsigned long period_2 = 1UL << (pg->shift - 1);
+	unsigned long counter_mask = period_2 - 1;
+	unsigned long global_count;
+
+	prop_norm_single(pg, pl);
+	*numerator = pl->events;
+
+	global_count = percpu_counter_read(&pg->events);
+	*denominator = period_2 + (global_count & counter_mask);
+}
+
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
