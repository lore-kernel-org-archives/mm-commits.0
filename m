From: akpm@linux-foundation.org
Subject: - mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit.patch removed from -mm tree
Date: Thu, 01 May 2008 02:31:45 -0700
Message-ID: <200805010931.m419Vj5V030899@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40799 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757992AbYEAJby (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:31:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     mm: bdi: allow setting a minimum for the bdi dirty limit
has been removed from the -mm tree.  Its filename was
     mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: bdi: allow setting a minimum for the bdi dirty limit
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Under normal circumstances each device is given a part of the total write-back
cache that relates to its current avg writeout speed in relation to the other
devices.

min_ratio - allows one to assign a minimum portion of the write-back cache to
a particular device.  This is useful in situations where you might want to
provide a minimum QoS.  (One request for this feature came from flash based
storage people who wanted to avoid writing out at all costs - they of course
needed some pdflush hacks as well)

max_ratio - allows one to assign a maximum portion of the dirty limit to a
particular device.  This is useful in situations where you want to avoid one
device taking all or most of the write-back cache.  Eg.  an NFS mount that is
prone to get stuck, or a FUSE mount which you don't trust to play fair.



Add "min_ratio" to /sys/class/bdi.  This indicates the minimum percentage of
the global dirty threshold allocated to this bdi.

[mszeredi@suse.cz]

 - fix parsing in min_ratio_store()
 - document new sysfs attribute

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-class-bdi |    6 ++++
 include/linux/backing-dev.h               |    4 ++
 mm/backing-dev.c                          |   21 +++++++++++++++
 mm/page-writeback.c                       |   27 +++++++++++++++++++-
 4 files changed, 57 insertions(+), 1 deletion(-)

diff -puN Documentation/ABI/testing/sysfs-class-bdi~mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit Documentation/ABI/testing/sysfs-class-bdi
--- a/Documentation/ABI/testing/sysfs-class-bdi~mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit
+++ a/Documentation/ABI/testing/sysfs-class-bdi
@@ -44,3 +44,9 @@ bdi_dirty_kb (read-only)
 	Current threshold on this BDI for reclaimable + writeback
 	memory
 
+min_ratio (read-write)
+
+	Minimal percentage of global dirty threshold allocated to this
+	bdi.  If the value written to this file would make the the sum
+	of all min_ratio values exceed 100, then EINVAL is returned.
+	The default is zero
diff -puN include/linux/backing-dev.h~mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit include/linux/backing-dev.h
--- a/include/linux/backing-dev.h~mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit
+++ a/include/linux/backing-dev.h
@@ -51,6 +51,8 @@ struct backing_dev_info {
 	struct prop_local_percpu completions;
 	int dirty_exceeded;
 
+	unsigned int min_ratio;
+
 	struct device *dev;
 };
 
@@ -137,6 +139,8 @@ static inline unsigned long bdi_stat_err
 #endif
 }
 
+int bdi_set_min_ratio(struct backing_dev_info *bdi, unsigned int min_ratio);
+
 /*
  * Flags in backing_dev_info::capability
  * - The first two flags control whether dirty pages will contribute to the
diff -puN mm/backing-dev.c~mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit mm/backing-dev.c
--- a/mm/backing-dev.c~mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit
+++ a/mm/backing-dev.c
@@ -55,6 +55,24 @@ static inline unsigned long get_dirty(st
 BDI_SHOW(dirty_kb, K(get_dirty(bdi, 1)))
 BDI_SHOW(bdi_dirty_kb, K(get_dirty(bdi, 2)))
 
+static ssize_t min_ratio_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct backing_dev_info *bdi = dev_get_drvdata(dev);
+	char *end;
+	unsigned int ratio;
+	ssize_t ret = -EINVAL;
+
+	ratio = simple_strtoul(buf, &end, 10);
+	if (*buf && (end[0] == '\0' || (end[0] == '\n' && end[1] == '\0'))) {
+		ret = bdi_set_min_ratio(bdi, ratio);
+		if (!ret)
+			ret = count;
+	}
+	return ret;
+}
+BDI_SHOW(min_ratio, bdi->min_ratio)
+
 #define __ATTR_RW(attr) __ATTR(attr, 0644, attr##_show, attr##_store)
 
 static struct device_attribute bdi_dev_attrs[] = {
@@ -63,6 +81,7 @@ static struct device_attribute bdi_dev_a
 	__ATTR_RO(writeback_kb),
 	__ATTR_RO(dirty_kb),
 	__ATTR_RO(bdi_dirty_kb),
+	__ATTR_RW(min_ratio),
 	__ATTR_NULL,
 };
 
@@ -127,6 +146,8 @@ int bdi_init(struct backing_dev_info *bd
 
 	bdi->dev = NULL;
 
+	bdi->min_ratio = 0;
+
 	for (i = 0; i < NR_BDI_STAT_ITEMS; i++) {
 		err = percpu_counter_init_irq(&bdi->bdi_stat[i], 0);
 		if (err)
diff -puN mm/page-writeback.c~mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit mm/page-writeback.c
--- a/mm/page-writeback.c~mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit
+++ a/mm/page-writeback.c
@@ -243,6 +243,29 @@ static void task_dirty_limit(struct task
 }
 
 /*
+ *
+ */
+static DEFINE_SPINLOCK(bdi_lock);
+static unsigned int bdi_min_ratio;
+
+int bdi_set_min_ratio(struct backing_dev_info *bdi, unsigned int min_ratio)
+{
+	int ret = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&bdi_lock, flags);
+	min_ratio -= bdi->min_ratio;
+	if (bdi_min_ratio + min_ratio < 100) {
+		bdi_min_ratio += min_ratio;
+		bdi->min_ratio += min_ratio;
+	} else
+		ret = -EINVAL;
+	spin_unlock_irqrestore(&bdi_lock, flags);
+
+	return ret;
+}
+
+/*
  * Work out the current dirty-memory clamping and background writeout
  * thresholds.
  *
@@ -330,7 +353,7 @@ get_dirty_limits(long *pbackground, long
 	*pdirty = dirty;
 
 	if (bdi) {
-		u64 bdi_dirty = dirty;
+		u64 bdi_dirty;
 		long numerator, denominator;
 
 		/*
@@ -338,8 +361,10 @@ get_dirty_limits(long *pbackground, long
 		 */
 		bdi_writeout_fraction(bdi, &numerator, &denominator);
 
+		bdi_dirty = (dirty * (100 - bdi_min_ratio)) / 100;
 		bdi_dirty *= numerator;
 		do_div(bdi_dirty, denominator);
+		bdi_dirty += (dirty * bdi->min_ratio) / 100;
 
 		*pbdi_dirty = bdi_dirty;
 		clip_bdi_dirty_limit(bdi, dirty, pbdi_dirty);
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
git-sched.patch
mutex-debug-check-mutex-magic-before-owner.patch
rcu-fix-rcu_try_flip_waitack_needed-to-prevent-grace-period-stall.patch

