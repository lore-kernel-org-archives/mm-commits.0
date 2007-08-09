From: akpm@linux-foundation.org
Subject: - lib-percpu_counter_sum_positive.patch removed from -mm tree
Date: Thu, 09 Aug 2007 13:56:25 -0700
Message-ID: <200708092056.l79KuPOP019022@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50324 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759565AbXHIU4e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 16:56:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org


The patch titled
     lib: percpu_counter_sum_positive
has been removed from the -mm tree.  Its filename was
     lib-percpu_counter_sum_positive.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: lib: percpu_counter_sum_positive
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

 s/percpu_counter_sum/&_positive/

Because its consitent with percpu_counter_read*

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/super.c                |    4 ++--
 fs/ext4/super.c                |    4 ++--
 fs/file_table.c                |    2 +-
 include/linux/percpu_counter.h |    4 ++--
 lib/percpu_counter.c           |    4 ++--
 5 files changed, 9 insertions(+), 9 deletions(-)

diff -puN fs/ext3/super.c~lib-percpu_counter_sum_positive fs/ext3/super.c
--- a/fs/ext3/super.c~lib-percpu_counter_sum_positive
+++ a/fs/ext3/super.c
@@ -2542,13 +2542,13 @@ static int ext3_statfs (struct dentry * 
 	buf->f_type = EXT3_SUPER_MAGIC;
 	buf->f_bsize = sb->s_blocksize;
 	buf->f_blocks = le32_to_cpu(es->s_blocks_count) - sbi->s_overhead_last;
-	buf->f_bfree = percpu_counter_sum(&sbi->s_freeblocks_counter);
+	buf->f_bfree = percpu_counter_sum_positive(&sbi->s_freeblocks_counter);
 	es->s_free_blocks_count = cpu_to_le32(buf->f_bfree);
 	buf->f_bavail = buf->f_bfree - le32_to_cpu(es->s_r_blocks_count);
 	if (buf->f_bfree < le32_to_cpu(es->s_r_blocks_count))
 		buf->f_bavail = 0;
 	buf->f_files = le32_to_cpu(es->s_inodes_count);
-	buf->f_ffree = percpu_counter_sum(&sbi->s_freeinodes_counter);
+	buf->f_ffree = percpu_counter_sum_positive(&sbi->s_freeinodes_counter);
 	es->s_free_inodes_count = cpu_to_le32(buf->f_ffree);
 	buf->f_namelen = EXT3_NAME_LEN;
 	fsid = le64_to_cpup((void *)es->s_uuid) ^
diff -puN fs/ext4/super.c~lib-percpu_counter_sum_positive fs/ext4/super.c
--- a/fs/ext4/super.c~lib-percpu_counter_sum_positive
+++ a/fs/ext4/super.c
@@ -2662,13 +2662,13 @@ static int ext4_statfs (struct dentry * 
 	buf->f_type = EXT4_SUPER_MAGIC;
 	buf->f_bsize = sb->s_blocksize;
 	buf->f_blocks = ext4_blocks_count(es) - sbi->s_overhead_last;
-	buf->f_bfree = percpu_counter_sum(&sbi->s_freeblocks_counter);
+	buf->f_bfree = percpu_counter_sum_positive(&sbi->s_freeblocks_counter);
 	es->s_free_blocks_count = cpu_to_le32(buf->f_bfree);
 	buf->f_bavail = buf->f_bfree - ext4_r_blocks_count(es);
 	if (buf->f_bfree < ext4_r_blocks_count(es))
 		buf->f_bavail = 0;
 	buf->f_files = le32_to_cpu(es->s_inodes_count);
-	buf->f_ffree = percpu_counter_sum(&sbi->s_freeinodes_counter);
+	buf->f_ffree = percpu_counter_sum_positive(&sbi->s_freeinodes_counter);
 	es->s_free_inodes_count = cpu_to_le32(buf->f_ffree);
 	buf->f_namelen = EXT4_NAME_LEN;
 	fsid = le64_to_cpup((void *)es->s_uuid) ^
diff -puN fs/file_table.c~lib-percpu_counter_sum_positive fs/file_table.c
--- a/fs/file_table.c~lib-percpu_counter_sum_positive
+++ a/fs/file_table.c
@@ -98,7 +98,7 @@ struct file *get_empty_filp(void)
 		 * percpu_counters are inaccurate.  Do an expensive check before
 		 * we go and fail.
 		 */
-		if (percpu_counter_sum(&nr_files) >= files_stat.max_files)
+		if (percpu_counter_sum_positive(&nr_files) >= files_stat.max_files)
 			goto over;
 	}
 
diff -puN include/linux/percpu_counter.h~lib-percpu_counter_sum_positive include/linux/percpu_counter.h
--- a/include/linux/percpu_counter.h~lib-percpu_counter_sum_positive
+++ a/include/linux/percpu_counter.h
@@ -34,7 +34,7 @@ void percpu_counter_init(struct percpu_c
 void percpu_counter_destroy(struct percpu_counter *fbc);
 void percpu_counter_set(struct percpu_counter *fbc, s64 amount);
 void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch);
-s64 percpu_counter_sum(struct percpu_counter *fbc);
+s64 percpu_counter_sum_positive(struct percpu_counter *fbc);
 
 static inline void percpu_counter_add(struct percpu_counter *fbc, s64 amount)
 {
@@ -102,7 +102,7 @@ static inline s64 percpu_counter_read_po
 	return fbc->count;
 }
 
-static inline s64 percpu_counter_sum(struct percpu_counter *fbc)
+static inline s64 percpu_counter_sum_positive(struct percpu_counter *fbc)
 {
 	return percpu_counter_read_positive(fbc);
 }
diff -puN lib/percpu_counter.c~lib-percpu_counter_sum_positive lib/percpu_counter.c
--- a/lib/percpu_counter.c~lib-percpu_counter_sum_positive
+++ a/lib/percpu_counter.c
@@ -52,7 +52,7 @@ EXPORT_SYMBOL(__percpu_counter_add);
  * Add up all the per-cpu counts, return the result.  This is a more accurate
  * but much slower version of percpu_counter_read_positive()
  */
-s64 percpu_counter_sum(struct percpu_counter *fbc)
+s64 percpu_counter_sum_positive(struct percpu_counter *fbc)
 {
 	s64 ret;
 	int cpu;
@@ -66,7 +66,7 @@ s64 percpu_counter_sum(struct percpu_cou
 	spin_unlock(&fbc->lock);
 	return ret < 0 ? 0 : ret;
 }
-EXPORT_SYMBOL(percpu_counter_sum);
+EXPORT_SYMBOL(percpu_counter_sum_positive);
 
 void percpu_counter_init(struct percpu_counter *fbc, s64 amount)
 {
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

radix-tree-use-indirect-bit.patch
lib-percpu_counter_sum_positive.patch
lib-percpu_count_sum.patch
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
