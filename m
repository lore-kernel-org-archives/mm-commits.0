From: akpm@linux-foundation.org
Subject: - lib-percpu_counter_add.patch removed from -mm tree
Date: Thu, 09 Aug 2007 13:56:17 -0700
Message-ID: <200708092056.l79KuHbg019010@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45862 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755363AbXHIU41 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 16:56:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org


The patch titled
     lib: percpu_counter_add
has been removed from the -mm tree.  Its filename was
     lib-percpu_counter_add.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: lib: percpu_counter_add
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

 s/percpu_counter_mod/percpu_counter_add/

Because its a better name, _mod implies modulo.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/balloc.c               |    4 ++--
 fs/ext2/ialloc.c               |    2 +-
 fs/ext3/balloc.c               |    4 ++--
 fs/ext3/resize.c               |    4 ++--
 fs/ext4/balloc.c               |    4 ++--
 fs/ext4/resize.c               |    4 ++--
 include/linux/percpu_counter.h |    8 ++++----
 lib/percpu_counter.c           |    4 ++--
 8 files changed, 17 insertions(+), 17 deletions(-)

diff -puN fs/ext2/balloc.c~lib-percpu_counter_add fs/ext2/balloc.c
--- a/fs/ext2/balloc.c~lib-percpu_counter_add
+++ a/fs/ext2/balloc.c
@@ -163,7 +163,7 @@ static int reserve_blocks(struct super_b
 			return 0;
 	}
 
-	percpu_counter_mod(&sbi->s_freeblocks_counter, -count);
+	percpu_counter_add(&sbi->s_freeblocks_counter, -count);
 	sb->s_dirt = 1;
 	return count;
 }
@@ -173,7 +173,7 @@ static void release_blocks(struct super_
 	if (count) {
 		struct ext2_sb_info *sbi = EXT2_SB(sb);
 
-		percpu_counter_mod(&sbi->s_freeblocks_counter, count);
+		percpu_counter_add(&sbi->s_freeblocks_counter, count);
 		sb->s_dirt = 1;
 	}
 }
diff -puN fs/ext2/ialloc.c~lib-percpu_counter_add fs/ext2/ialloc.c
--- a/fs/ext2/ialloc.c~lib-percpu_counter_add
+++ a/fs/ext2/ialloc.c
@@ -534,7 +534,7 @@ got:
 		goto fail;
 	}
 
-	percpu_counter_mod(&sbi->s_freeinodes_counter, -1);
+	percpu_counter_add(&sbi->s_freeinodes_counter, -1);
 	if (S_ISDIR(mode))
 		percpu_counter_inc(&sbi->s_dirs_counter);
 
diff -puN fs/ext3/balloc.c~lib-percpu_counter_add fs/ext3/balloc.c
--- a/fs/ext3/balloc.c~lib-percpu_counter_add
+++ a/fs/ext3/balloc.c
@@ -609,7 +609,7 @@ do_more:
 		cpu_to_le16(le16_to_cpu(desc->bg_free_blocks_count) +
 			group_freed);
 	spin_unlock(sb_bgl_lock(sbi, block_group));
-	percpu_counter_mod(&sbi->s_freeblocks_counter, count);
+	percpu_counter_add(&sbi->s_freeblocks_counter, count);
 
 	/* We dirtied the bitmap block */
 	BUFFER_TRACE(bitmap_bh, "dirtied bitmap block");
@@ -1672,7 +1672,7 @@ allocated:
 	gdp->bg_free_blocks_count =
 			cpu_to_le16(le16_to_cpu(gdp->bg_free_blocks_count)-num);
 	spin_unlock(sb_bgl_lock(sbi, group_no));
-	percpu_counter_mod(&sbi->s_freeblocks_counter, -num);
+	percpu_counter_add(&sbi->s_freeblocks_counter, -num);
 
 	BUFFER_TRACE(gdp_bh, "journal_dirty_metadata for group descriptor");
 	err = ext3_journal_dirty_metadata(handle, gdp_bh);
diff -puN fs/ext3/resize.c~lib-percpu_counter_add fs/ext3/resize.c
--- a/fs/ext3/resize.c~lib-percpu_counter_add
+++ a/fs/ext3/resize.c
@@ -884,9 +884,9 @@ int ext3_group_add(struct super_block *s
 		input->reserved_blocks);
 
 	/* Update the free space counts */
-	percpu_counter_mod(&sbi->s_freeblocks_counter,
+	percpu_counter_add(&sbi->s_freeblocks_counter,
 			   input->free_blocks_count);
-	percpu_counter_mod(&sbi->s_freeinodes_counter,
+	percpu_counter_add(&sbi->s_freeinodes_counter,
 			   EXT3_INODES_PER_GROUP(sb));
 
 	ext3_journal_dirty_metadata(handle, sbi->s_sbh);
diff -puN fs/ext4/balloc.c~lib-percpu_counter_add fs/ext4/balloc.c
--- a/fs/ext4/balloc.c~lib-percpu_counter_add
+++ a/fs/ext4/balloc.c
@@ -628,7 +628,7 @@ do_more:
 		cpu_to_le16(le16_to_cpu(desc->bg_free_blocks_count) +
 			group_freed);
 	spin_unlock(sb_bgl_lock(sbi, block_group));
-	percpu_counter_mod(&sbi->s_freeblocks_counter, count);
+	percpu_counter_add(&sbi->s_freeblocks_counter, count);
 
 	/* We dirtied the bitmap block */
 	BUFFER_TRACE(bitmap_bh, "dirtied bitmap block");
@@ -1688,7 +1688,7 @@ allocated:
 	gdp->bg_free_blocks_count =
 			cpu_to_le16(le16_to_cpu(gdp->bg_free_blocks_count)-num);
 	spin_unlock(sb_bgl_lock(sbi, group_no));
-	percpu_counter_mod(&sbi->s_freeblocks_counter, -num);
+	percpu_counter_add(&sbi->s_freeblocks_counter, -num);
 
 	BUFFER_TRACE(gdp_bh, "journal_dirty_metadata for group descriptor");
 	err = ext4_journal_dirty_metadata(handle, gdp_bh);
diff -puN fs/ext4/resize.c~lib-percpu_counter_add fs/ext4/resize.c
--- a/fs/ext4/resize.c~lib-percpu_counter_add
+++ a/fs/ext4/resize.c
@@ -893,9 +893,9 @@ int ext4_group_add(struct super_block *s
 		input->reserved_blocks);
 
 	/* Update the free space counts */
-	percpu_counter_mod(&sbi->s_freeblocks_counter,
+	percpu_counter_add(&sbi->s_freeblocks_counter,
 			   input->free_blocks_count);
-	percpu_counter_mod(&sbi->s_freeinodes_counter,
+	percpu_counter_add(&sbi->s_freeinodes_counter,
 			   EXT4_INODES_PER_GROUP(sb));
 
 	ext4_journal_dirty_metadata(handle, sbi->s_sbh);
diff -puN include/linux/percpu_counter.h~lib-percpu_counter_add include/linux/percpu_counter.h
--- a/include/linux/percpu_counter.h~lib-percpu_counter_add
+++ a/include/linux/percpu_counter.h
@@ -32,7 +32,7 @@ struct percpu_counter {
 
 void percpu_counter_init(struct percpu_counter *fbc, s64 amount);
 void percpu_counter_destroy(struct percpu_counter *fbc);
-void percpu_counter_mod(struct percpu_counter *fbc, s32 amount);
+void percpu_counter_add(struct percpu_counter *fbc, s32 amount);
 s64 percpu_counter_sum(struct percpu_counter *fbc);
 
 static inline s64 percpu_counter_read(struct percpu_counter *fbc)
@@ -71,7 +71,7 @@ static inline void percpu_counter_destro
 }
 
 static inline void
-percpu_counter_mod(struct percpu_counter *fbc, s32 amount)
+percpu_counter_add(struct percpu_counter *fbc, s32 amount)
 {
 	preempt_disable();
 	fbc->count += amount;
@@ -97,12 +97,12 @@ static inline s64 percpu_counter_sum(str
 
 static inline void percpu_counter_inc(struct percpu_counter *fbc)
 {
-	percpu_counter_mod(fbc, 1);
+	percpu_counter_add(fbc, 1);
 }
 
 static inline void percpu_counter_dec(struct percpu_counter *fbc)
 {
-	percpu_counter_mod(fbc, -1);
+	percpu_counter_add(fbc, -1);
 }
 
 #endif /* _LINUX_PERCPU_COUNTER_H */
diff -puN lib/percpu_counter.c~lib-percpu_counter_add lib/percpu_counter.c
--- a/lib/percpu_counter.c~lib-percpu_counter_add
+++ a/lib/percpu_counter.c
@@ -14,7 +14,7 @@ static LIST_HEAD(percpu_counters);
 static DEFINE_MUTEX(percpu_counters_lock);
 #endif
 
-void percpu_counter_mod(struct percpu_counter *fbc, s32 amount)
+void percpu_counter_add(struct percpu_counter *fbc, s32 amount)
 {
 	long count;
 	s32 *pcount;
@@ -32,7 +32,7 @@ void percpu_counter_mod(struct percpu_co
 	}
 	put_cpu();
 }
-EXPORT_SYMBOL(percpu_counter_mod);
+EXPORT_SYMBOL(percpu_counter_add);
 
 /*
  * Add up all the per-cpu counts, return the result.  This is a more accurate
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

radix-tree-use-indirect-bit.patch
lib-percpu_counter_add.patch
lib-percpu_counter-variable-batch.patch
lib-make-percpu_counter_add-take-s64.patch
lib-percpu_counter_set.patch
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
