From: akpm@linux-foundation.org
Subject: - lib-percpu_counter_init-error-handling.patch removed from -mm tree
Date: Thu, 09 Aug 2007 13:56:29 -0700
Message-ID: <200708092056.l79KuTCG019028@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36114 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762584AbXHIU4i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 16:56:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org


The patch titled
     lib: percpu_counter_init error handling
has been removed from the -mm tree.  Its filename was
     lib-percpu_counter_init-error-handling.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: lib: percpu_counter_init error handling
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

alloc_percpu can fail, propagate that error.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/super.c                |   11 ++++++++---
 fs/ext3/super.c                |   11 ++++++++---
 fs/ext4/super.c                |   11 ++++++++---
 include/linux/percpu_counter.h |    5 +++--
 lib/percpu_counter.c           |    8 +++++++-
 5 files changed, 34 insertions(+), 12 deletions(-)

diff -puN fs/ext2/super.c~lib-percpu_counter_init-error-handling fs/ext2/super.c
--- a/fs/ext2/super.c~lib-percpu_counter_init-error-handling
+++ a/fs/ext2/super.c
@@ -711,6 +711,7 @@ static int ext2_fill_super(struct super_
 	int db_count;
 	int i, j;
 	__le32 features;
+	int err;
 
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
@@ -965,12 +966,16 @@ static int ext2_fill_super(struct super_
 	get_random_bytes(&sbi->s_next_generation, sizeof(u32));
 	spin_lock_init(&sbi->s_next_gen_lock);
 
-	percpu_counter_init(&sbi->s_freeblocks_counter,
+	err = percpu_counter_init(&sbi->s_freeblocks_counter,
 				ext2_count_free_blocks(sb));
-	percpu_counter_init(&sbi->s_freeinodes_counter,
+	err |= percpu_counter_init(&sbi->s_freeinodes_counter,
 				ext2_count_free_inodes(sb));
-	percpu_counter_init(&sbi->s_dirs_counter,
+	err |= percpu_counter_init(&sbi->s_dirs_counter,
 				ext2_count_dirs(sb));
+	if (err) {
+		printk(KERN_ERR "EXT2-fs: insufficient memory\n");
+		goto failed_mount3;
+	}
 	/*
 	 * set up enough so that it can read an inode
 	 */
diff -puN fs/ext3/super.c~lib-percpu_counter_init-error-handling fs/ext3/super.c
--- a/fs/ext3/super.c~lib-percpu_counter_init-error-handling
+++ a/fs/ext3/super.c
@@ -1485,6 +1485,7 @@ static int ext3_fill_super (struct super
 	int i;
 	int needs_recovery;
 	__le32 features;
+	int err;
 
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
@@ -1745,12 +1746,16 @@ static int ext3_fill_super (struct super
 	get_random_bytes(&sbi->s_next_generation, sizeof(u32));
 	spin_lock_init(&sbi->s_next_gen_lock);
 
-	percpu_counter_init(&sbi->s_freeblocks_counter,
+	err = percpu_counter_init(&sbi->s_freeblocks_counter,
 		ext3_count_free_blocks(sb));
-	percpu_counter_init(&sbi->s_freeinodes_counter,
+	err |= percpu_counter_init(&sbi->s_freeinodes_counter,
 		ext3_count_free_inodes(sb));
-	percpu_counter_init(&sbi->s_dirs_counter,
+	err |= percpu_counter_init(&sbi->s_dirs_counter,
 		ext3_count_dirs(sb));
+	if (err) {
+		printk(KERN_ERR "EXT3-fs: insufficient memory\n");
+		goto failed_mount3;
+	}
 
 	/* per fileystem reservation list head & lock */
 	spin_lock_init(&sbi->s_rsv_window_lock);
diff -puN fs/ext4/super.c~lib-percpu_counter_init-error-handling fs/ext4/super.c
--- a/fs/ext4/super.c~lib-percpu_counter_init-error-handling
+++ a/fs/ext4/super.c
@@ -1548,6 +1548,7 @@ static int ext4_fill_super (struct super
 	int needs_recovery;
 	__le32 features;
 	__u64 blocks_count;
+	int err;
 
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
@@ -1829,12 +1830,16 @@ static int ext4_fill_super (struct super
 	get_random_bytes(&sbi->s_next_generation, sizeof(u32));
 	spin_lock_init(&sbi->s_next_gen_lock);
 
-	percpu_counter_init(&sbi->s_freeblocks_counter,
+	err = percpu_counter_init(&sbi->s_freeblocks_counter,
 		ext4_count_free_blocks(sb));
-	percpu_counter_init(&sbi->s_freeinodes_counter,
+	err |= percpu_counter_init(&sbi->s_freeinodes_counter,
 		ext4_count_free_inodes(sb));
-	percpu_counter_init(&sbi->s_dirs_counter,
+	err |= percpu_counter_init(&sbi->s_dirs_counter,
 		ext4_count_dirs(sb));
+	if (err) {
+		printk(KERN_ERR "EXT4-fs: insufficient memory\n");
+		goto failed_mount3;
+	}
 
 	/* per fileystem reservation list head & lock */
 	spin_lock_init(&sbi->s_rsv_window_lock);
diff -puN include/linux/percpu_counter.h~lib-percpu_counter_init-error-handling include/linux/percpu_counter.h
--- a/include/linux/percpu_counter.h~lib-percpu_counter_init-error-handling
+++ a/include/linux/percpu_counter.h
@@ -30,7 +30,7 @@ struct percpu_counter {
 #define FBC_BATCH	(NR_CPUS*4)
 #endif
 
-void percpu_counter_init(struct percpu_counter *fbc, s64 amount);
+int percpu_counter_init(struct percpu_counter *fbc, s64 amount);
 void percpu_counter_destroy(struct percpu_counter *fbc);
 void percpu_counter_set(struct percpu_counter *fbc, s64 amount);
 void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch);
@@ -78,9 +78,10 @@ struct percpu_counter {
 	s64 count;
 };
 
-static inline void percpu_counter_init(struct percpu_counter *fbc, s64 amount)
+static inline int percpu_counter_init(struct percpu_counter *fbc, s64 amount)
 {
 	fbc->count = amount;
+	return 0;
 }
 
 static inline void percpu_counter_destroy(struct percpu_counter *fbc)
diff -puN lib/percpu_counter.c~lib-percpu_counter_init-error-handling lib/percpu_counter.c
--- a/lib/percpu_counter.c~lib-percpu_counter_init-error-handling
+++ a/lib/percpu_counter.c
@@ -68,21 +68,27 @@ s64 __percpu_counter_sum(struct percpu_c
 }
 EXPORT_SYMBOL(__percpu_counter_sum);
 
-void percpu_counter_init(struct percpu_counter *fbc, s64 amount)
+int percpu_counter_init(struct percpu_counter *fbc, s64 amount)
 {
 	spin_lock_init(&fbc->lock);
 	fbc->count = amount;
 	fbc->counters = alloc_percpu(s32);
+	if (!fbc->counters)
+		return -ENOMEM;
 #ifdef CONFIG_HOTPLUG_CPU
 	mutex_lock(&percpu_counters_lock);
 	list_add(&fbc->list, &percpu_counters);
 	mutex_unlock(&percpu_counters_lock);
 #endif
+	return 0;
 }
 EXPORT_SYMBOL(percpu_counter_init);
 
 void percpu_counter_destroy(struct percpu_counter *fbc)
 {
+	if (!fbc->counters)
+		return;
+
 	free_percpu(fbc->counters);
 #ifdef CONFIG_HOTPLUG_CPU
 	mutex_lock(&percpu_counters_lock);
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

radix-tree-use-indirect-bit.patch
lib-percpu_counter_init-error-handling.patch
lib-percpu_counter_init_irq.patch
mm-bdi-init-hooks.patch
mm-bdi-init-hooks-fix.patch
mtd-bdi-init-hooks.patch
mtd-clean-up-the-backing_dev_info-usage.patch
mtd-give-mtdconcat-devices-their-own-backing_dev_info.patch
mm-scalable-bdi-statistics-counters.patch
mm-count-reclaimable-pages-per-bdi.patch
mm-count-writeback-pages-per-bdi.patch
mm-expose-bdi-statistics-in-sysfs.patch
lib-floating-proportions.patch
lib-floating-proportions-_single.patch
lib-floating-proportions-_single-tidy.patch
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
task-containersv11-add-procfs-interface-containers-bdi-init-hooks.patch
workqueue-debug-flushing-deadlocks-with-lockdep.patch
workqueue-debug-work-related-deadlocks-with-lockdep.patch
