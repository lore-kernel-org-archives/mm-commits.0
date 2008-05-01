From: akpm@linux-foundation.org
Subject: - mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit.patch removed from -mm tree
Date: Thu, 01 May 2008 02:31:48 -0700
Message-ID: <200805010931.m419VmAW030902@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35224 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757751AbYEAJbx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:31:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     mm: bdi: allow setting a maximum for the bdi dirty limit
has been removed from the -mm tree.  Its filename was
     mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: bdi: allow setting a maximum for the bdi dirty limit
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Add "max_ratio" to /sys/class/bdi.  This indicates the maximum percentage of
the global dirty threshold allocated to this bdi.

[mszeredi@suse.cz]

 - fix parsing in max_ratio_store().
 - export bdi_set_max_ratio() to modules
 - limit bdi_dirty with bdi->max_ratio
 - document new sysfs attribute

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-class-bdi |    9 +++-
 include/linux/backing-dev.h               |    2 
 include/linux/proportions.h               |   13 ++++++
 lib/proportions.c                         |   38 +++++++++++++++---
 mm/backing-dev.c                          |   21 ++++++++++
 mm/page-writeback.c                       |   41 +++++++++++++++++---
 6 files changed, 111 insertions(+), 13 deletions(-)

diff -puN Documentation/ABI/testing/sysfs-class-bdi~mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit Documentation/ABI/testing/sysfs-class-bdi
--- a/Documentation/ABI/testing/sysfs-class-bdi~mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit
+++ a/Documentation/ABI/testing/sysfs-class-bdi
@@ -49,4 +49,11 @@ min_ratio (read-write)
 	Minimal percentage of global dirty threshold allocated to this
 	bdi.  If the value written to this file would make the the sum
 	of all min_ratio values exceed 100, then EINVAL is returned.
-	The default is zero
+	If min_ratio would become larger than the current max_ratio,
+	then also EINVAL is returned.  The default is zero
+
+max_ratio (read-write)
+
+	Maximal percentage of global dirty threshold allocated to this
+	bdi.  If max_ratio would become smaller than the current
+	min_ratio, then EINVAL is returned.  The default is 100
diff -puN include/linux/backing-dev.h~mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit include/linux/backing-dev.h
--- a/include/linux/backing-dev.h~mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit
+++ a/include/linux/backing-dev.h
@@ -52,6 +52,7 @@ struct backing_dev_info {
 	int dirty_exceeded;
 
 	unsigned int min_ratio;
+	unsigned int max_ratio, max_prop_frac;
 
 	struct device *dev;
 };
@@ -140,6 +141,7 @@ static inline unsigned long bdi_stat_err
 }
 
 int bdi_set_min_ratio(struct backing_dev_info *bdi, unsigned int min_ratio);
+int bdi_set_max_ratio(struct backing_dev_info *bdi, unsigned int max_ratio);
 
 /*
  * Flags in backing_dev_info::capability
diff -puN include/linux/proportions.h~mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit include/linux/proportions.h
--- a/include/linux/proportions.h~mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit
+++ a/include/linux/proportions.h
@@ -78,6 +78,19 @@ void prop_inc_percpu(struct prop_descrip
 }
 
 /*
+ * Limit the time part in order to ensure there are some bits left for the
+ * cycle counter and fraction multiply.
+ */
+#define PROP_MAX_SHIFT (3*BITS_PER_LONG/4)
+
+#define PROP_FRAC_SHIFT		(BITS_PER_LONG - PROP_MAX_SHIFT - 1)
+#define PROP_FRAC_BASE		(1UL << PROP_FRAC_SHIFT)
+
+void __prop_inc_percpu_max(struct prop_descriptor *pd,
+			   struct prop_local_percpu *pl, long frac);
+
+
+/*
  * ----- SINGLE ------
  */
 
diff -puN lib/proportions.c~mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit lib/proportions.c
--- a/lib/proportions.c~mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit
+++ a/lib/proportions.c
@@ -73,12 +73,6 @@
 #include <linux/proportions.h>
 #include <linux/rcupdate.h>
 
-/*
- * Limit the time part in order to ensure there are some bits left for the
- * cycle counter.
- */
-#define PROP_MAX_SHIFT (3*BITS_PER_LONG/4)
-
 int prop_descriptor_init(struct prop_descriptor *pd, int shift)
 {
 	int err;
@@ -268,6 +262,38 @@ void __prop_inc_percpu(struct prop_descr
 }
 
 /*
+ * identical to __prop_inc_percpu, except that it limits this pl's fraction to
+ * @frac/PROP_FRAC_BASE by ignoring events when this limit has been exceeded.
+ */
+void __prop_inc_percpu_max(struct prop_descriptor *pd,
+			   struct prop_local_percpu *pl, long frac)
+{
+	struct prop_global *pg = prop_get_global(pd);
+
+	prop_norm_percpu(pg, pl);
+
+	if (unlikely(frac != PROP_FRAC_BASE)) {
+		unsigned long period_2 = 1UL << (pg->shift - 1);
+		unsigned long counter_mask = period_2 - 1;
+		unsigned long global_count;
+		long numerator, denominator;
+
+		numerator = percpu_counter_read_positive(&pl->events);
+		global_count = percpu_counter_read(&pg->events);
+		denominator = period_2 + (global_count & counter_mask);
+
+		if (numerator > ((denominator * frac) >> PROP_FRAC_SHIFT))
+			goto out_put;
+	}
+
+	percpu_counter_add(&pl->events, 1);
+	percpu_counter_add(&pg->events, 1);
+
+out_put:
+	prop_put_global(pd, pg);
+}
+
+/*
  * Obtain a fraction of this proportion
  *
  *   p_{j} = x_{j} / (period/2 + t % period/2)
diff -puN mm/backing-dev.c~mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit mm/backing-dev.c
--- a/mm/backing-dev.c~mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit
+++ a/mm/backing-dev.c
@@ -73,6 +73,24 @@ static ssize_t min_ratio_store(struct de
 }
 BDI_SHOW(min_ratio, bdi->min_ratio)
 
+static ssize_t max_ratio_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct backing_dev_info *bdi = dev_get_drvdata(dev);
+	char *end;
+	unsigned int ratio;
+	ssize_t ret = -EINVAL;
+
+	ratio = simple_strtoul(buf, &end, 10);
+	if (*buf && (end[0] == '\0' || (end[0] == '\n' && end[1] == '\0'))) {
+		ret = bdi_set_max_ratio(bdi, ratio);
+		if (!ret)
+			ret = count;
+	}
+	return ret;
+}
+BDI_SHOW(max_ratio, bdi->max_ratio)
+
 #define __ATTR_RW(attr) __ATTR(attr, 0644, attr##_show, attr##_store)
 
 static struct device_attribute bdi_dev_attrs[] = {
@@ -82,6 +100,7 @@ static struct device_attribute bdi_dev_a
 	__ATTR_RO(dirty_kb),
 	__ATTR_RO(bdi_dirty_kb),
 	__ATTR_RW(min_ratio),
+	__ATTR_RW(max_ratio),
 	__ATTR_NULL,
 };
 
@@ -147,6 +166,8 @@ int bdi_init(struct backing_dev_info *bd
 	bdi->dev = NULL;
 
 	bdi->min_ratio = 0;
+	bdi->max_ratio = 100;
+	bdi->max_prop_frac = PROP_FRAC_BASE;
 
 	for (i = 0; i < NR_BDI_STAT_ITEMS; i++) {
 		err = percpu_counter_init_irq(&bdi->bdi_stat[i], 0);
diff -puN mm/page-writeback.c~mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit mm/page-writeback.c
--- a/mm/page-writeback.c~mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit
+++ a/mm/page-writeback.c
@@ -164,7 +164,8 @@ int dirty_ratio_handler(struct ctl_table
  */
 static inline void __bdi_writeout_inc(struct backing_dev_info *bdi)
 {
-	__prop_inc_percpu(&vm_completions, &bdi->completions);
+	__prop_inc_percpu_max(&vm_completions, &bdi->completions,
+			      bdi->max_prop_frac);
 }
 
 static inline void task_dirty_inc(struct task_struct *tsk)
@@ -254,16 +255,42 @@ int bdi_set_min_ratio(struct backing_dev
 	unsigned long flags;
 
 	spin_lock_irqsave(&bdi_lock, flags);
-	min_ratio -= bdi->min_ratio;
-	if (bdi_min_ratio + min_ratio < 100) {
-		bdi_min_ratio += min_ratio;
-		bdi->min_ratio += min_ratio;
-	} else
+	if (min_ratio > bdi->max_ratio) {
 		ret = -EINVAL;
+	} else {
+		min_ratio -= bdi->min_ratio;
+		if (bdi_min_ratio + min_ratio < 100) {
+			bdi_min_ratio += min_ratio;
+			bdi->min_ratio += min_ratio;
+		} else {
+			ret = -EINVAL;
+		}
+	}
+	spin_unlock_irqrestore(&bdi_lock, flags);
+
+	return ret;
+}
+
+int bdi_set_max_ratio(struct backing_dev_info *bdi, unsigned max_ratio)
+{
+	unsigned long flags;
+	int ret = 0;
+
+	if (max_ratio > 100)
+		return -EINVAL;
+
+	spin_lock_irqsave(&bdi_lock, flags);
+	if (bdi->min_ratio > max_ratio) {
+		ret = -EINVAL;
+	} else {
+		bdi->max_ratio = max_ratio;
+		bdi->max_prop_frac = (PROP_FRAC_BASE * max_ratio) / 100;
+	}
 	spin_unlock_irqrestore(&bdi_lock, flags);
 
 	return ret;
 }
+EXPORT_SYMBOL(bdi_set_max_ratio);
 
 /*
  * Work out the current dirty-memory clamping and background writeout
@@ -365,6 +392,8 @@ get_dirty_limits(long *pbackground, long
 		bdi_dirty *= numerator;
 		do_div(bdi_dirty, denominator);
 		bdi_dirty += (dirty * bdi->min_ratio) / 100;
+		if (bdi_dirty > (dirty * bdi->max_ratio) / 100)
+			bdi_dirty = dirty * bdi->max_ratio / 100;
 
 		*pbdi_dirty = bdi_dirty;
 		clip_bdi_dirty_limit(bdi, dirty, pbdi_dirty);
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
git-sched.patch
mutex-debug-check-mutex-magic-before-owner.patch
rcu-fix-rcu_try_flip_waitack_needed-to-prevent-grace-period-stall.patch

