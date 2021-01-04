Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6971BC433DB
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jan 2021 18:56:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 219E722209
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jan 2021 18:56:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbhADS4p (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Jan 2021 13:56:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:49910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727098AbhADS4p (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 4 Jan 2021 13:56:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C12322225;
        Mon,  4 Jan 2021 18:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609786564;
        bh=IR1mfI+kAgo/PfHKAgP05fANGV1mkCL4PL5FaS59A/s=;
        h=Date:From:To:Subject:From;
        b=kWNsc91ibUYM6CXgXws+qAZM1HBIomMw7q5mngzuwqtdfvH6E1RbojgckZqiK5pg+
         onxYFuO8xD5h9+MCnhYCaIHfhM+SrntAIkmrRd+C7ZeBW+xeiQ9eiRsj+1b2d+ydee
         s28mhV9xQiLWyk63EK75gfe6/Ghu6Po/fyKMPQ9A=
Date:   Mon, 04 Jan 2021 10:56:04 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Message-ID: <20210104185604.qDR3bIMgW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kasan.rst                |    4 
 drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c |    3 
 fs/ext4/super.c                                  |  104 -------------
 kernel/dma/map_benchmark.c                       |    3 
 4 files changed, 114 deletions(-)

--- a/Documentation/dev-tools/kasan.rst~linux-next-git-rejects
+++ a/Documentation/dev-tools/kasan.rst
@@ -22,11 +22,7 @@ out-of-bounds accesses for global variab
 Tag-based KASAN is only supported in Clang.
 
 Currently generic KASAN is supported for the x86_64, arm, arm64, xtensa, s390
-<<<<<<< HEAD
 and riscv architectures, and tag-based KASAN modes are supported only for arm64.
-=======
-and riscv architectures, and tag-based KASAN is supported only for arm64.
->>>>>>> linux-next/akpm-base
 
 Usage
 -----
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c
@@ -731,14 +731,11 @@ static int vangogh_system_features_contr
 						en ? RLC_STATUS_NORMAL : RLC_STATUS_OFF, NULL);
 	else
 		return 0;
-<<<<<<< HEAD
-=======
 }
 
 static int vangogh_mode2_reset(struct smu_context *smu)
 {
 	return smu_cmn_send_smc_msg_with_param(smu, SMU_MSG_GfxDeviceDriverReset, SMU_RESET_MODE_2, NULL);
->>>>>>> linux-next/akpm-base
 }
 
 static const struct pptable_funcs vangogh_ppt_funcs = {
--- a/fs/ext4/super.c~linux-next-git-rejects
+++ a/fs/ext4/super.c
@@ -587,24 +587,12 @@ static int ext4_errno_to_code(int errno)
 	return EXT4_ERR_UNKNOWN;
 }
 
-<<<<<<< HEAD
-static void __save_error_info(struct super_block *sb, int error,
-			      __u32 ino, __u64 block,
-			      const char *func, unsigned int line)
-{
-	struct ext4_sb_info *sbi = EXT4_SB(sb);
-
-	EXT4_SB(sb)->s_mount_state |= EXT4_ERROR_FS;
-	if (bdev_read_only(sb->s_bdev))
-		return;
-=======
 static void save_error_info(struct super_block *sb, int error,
 			    __u32 ino, __u64 block,
 			    const char *func, unsigned int line)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 
->>>>>>> linux-next/akpm-base
 	/* We default to EFSCORRUPTED error... */
 	if (error == 0)
 		error = EFSCORRUPTED;
@@ -628,18 +616,6 @@ static void save_error_info(struct super
 	spin_unlock(&sbi->s_error_lock);
 }
 
-<<<<<<< HEAD
-static void save_error_info(struct super_block *sb, int error,
-			    __u32 ino, __u64 block,
-			    const char *func, unsigned int line)
-{
-	__save_error_info(sb, error, ino, block, func, line);
-	if (!bdev_read_only(sb->s_bdev))
-		ext4_commit_super(sb, 1);
-}
-
-=======
->>>>>>> linux-next/akpm-base
 /* Deal with the reporting of failure conditions on a filesystem such as
  * inconsistencies detected or read IO failures.
  *
@@ -660,21 +636,6 @@ static void save_error_info(struct super
  * used to deal with unrecoverable failures such as journal IO errors or ENOMEM
  * at a critical moment in log management.
  */
-<<<<<<< HEAD
-static void ext4_handle_error(struct super_block *sb, bool force_ro)
-{
-	journal_t *journal = EXT4_SB(sb)->s_journal;
-
-	if (test_opt(sb, WARN_ON_ERROR))
-		WARN_ON_ONCE(1);
-
-	if (sb_rdonly(sb) || (!force_ro && test_opt(sb, ERRORS_CONT)))
-		return;
-
-	ext4_set_mount_flag(sb, EXT4_MF_FS_ABORTED);
-	if (journal)
-		jbd2_journal_abort(journal, -EIO);
-=======
 static void ext4_handle_error(struct super_block *sb, bool force_ro, int error,
 			      __u32 ino, __u64 block,
 			      const char *func, unsigned int line)
@@ -709,7 +670,6 @@ static void ext4_handle_error(struct sup
 	if (sb_rdonly(sb) || continue_fs)
 		return;
 
->>>>>>> linux-next/akpm-base
 	/*
 	 * We force ERRORS_RO behavior when system is rebooting. Otherwise we
 	 * could panic during 'reboot -f' as the underlying device got already
@@ -732,10 +692,6 @@ static void flush_stashed_error_work(str
 {
 	struct ext4_sb_info *sbi = container_of(work, struct ext4_sb_info,
 						s_error_work);
-<<<<<<< HEAD
-
-	ext4_commit_super(sbi->s_sb, 1);
-=======
 	journal_t *journal = sbi->s_journal;
 	handle_t *handle;
 
@@ -769,7 +725,6 @@ write_directly:
 	 * out and hope for the best.
 	 */
 	ext4_commit_super(sbi->s_sb);
->>>>>>> linux-next/akpm-base
 }
 
 #define ext4_error_ratelimit(sb)					\
@@ -796,12 +751,7 @@ void __ext4_error(struct super_block *sb
 		       sb->s_id, function, line, current->comm, &vaf);
 		va_end(args);
 	}
-<<<<<<< HEAD
-	save_error_info(sb, error, 0, block, function, line);
-	ext4_handle_error(sb, force_ro);
-=======
 	ext4_handle_error(sb, force_ro, error, 0, block, function, line);
->>>>>>> linux-next/akpm-base
 }
 
 void __ext4_error_inode(struct inode *inode, const char *function,
@@ -831,14 +781,8 @@ void __ext4_error_inode(struct inode *in
 			       current->comm, &vaf);
 		va_end(args);
 	}
-<<<<<<< HEAD
-	save_error_info(inode->i_sb, error, inode->i_ino, block,
-			function, line);
-	ext4_handle_error(inode->i_sb, false);
-=======
 	ext4_handle_error(inode->i_sb, false, error, inode->i_ino, block,
 			  function, line);
->>>>>>> linux-next/akpm-base
 }
 
 void __ext4_error_file(struct file *file, const char *function,
@@ -875,14 +819,8 @@ void __ext4_error_file(struct file *file
 			       current->comm, path, &vaf);
 		va_end(args);
 	}
-<<<<<<< HEAD
-	save_error_info(inode->i_sb, EFSCORRUPTED, inode->i_ino, block,
-			function, line);
-	ext4_handle_error(inode->i_sb, false);
-=======
 	ext4_handle_error(inode->i_sb, false, EFSCORRUPTED, inode->i_ino, block,
 			  function, line);
->>>>>>> linux-next/akpm-base
 }
 
 const char *ext4_decode_error(struct super_block *sb, int errno,
@@ -949,12 +887,7 @@ void __ext4_std_error(struct super_block
 		       sb->s_id, function, line, errstr);
 	}
 
-<<<<<<< HEAD
-	save_error_info(sb, -errno, 0, 0, function, line);
-	ext4_handle_error(sb, false);
-=======
 	ext4_handle_error(sb, false, -errno, 0, 0, function, line);
->>>>>>> linux-next/akpm-base
 }
 
 void __ext4_msg(struct super_block *sb,
@@ -1048,15 +981,6 @@ __acquires(bitlock)
 	if (test_opt(sb, ERRORS_CONT)) {
 		if (test_opt(sb, WARN_ON_ERROR))
 			WARN_ON_ONCE(1);
-<<<<<<< HEAD
-		__save_error_info(sb, EFSCORRUPTED, ino, block, function, line);
-		schedule_work(&EXT4_SB(sb)->s_error_work);
-		return;
-	}
-	ext4_unlock_group(sb, grp);
-	save_error_info(sb, EFSCORRUPTED, ino, block, function, line);
-	ext4_handle_error(sb, false);
-=======
 		EXT4_SB(sb)->s_mount_state |= EXT4_ERROR_FS;
 		if (!bdev_read_only(sb->s_bdev)) {
 			save_error_info(sb, EFSCORRUPTED, ino, block, function,
@@ -1067,7 +991,6 @@ __acquires(bitlock)
 	}
 	ext4_unlock_group(sb, grp);
 	ext4_handle_error(sb, false, EFSCORRUPTED, ino, block, function, line);
->>>>>>> linux-next/akpm-base
 	/*
 	 * We only get here in the ERRORS_RO case; relocking the group
 	 * may be dangerous, but nothing bad will happen since the
@@ -4262,16 +4185,6 @@ static int ext4_fill_super(struct super_
 
 	if (le32_to_cpu(es->s_log_block_size) >
 	    (EXT4_MAX_BLOCK_LOG_SIZE - EXT4_MIN_BLOCK_LOG_SIZE)) {
-<<<<<<< HEAD
-		ext4_msg(sb, KERN_ERR,
-			 "Invalid log block size: %u",
-			 le32_to_cpu(es->s_log_block_size));
-		goto failed_mount;
-	}
-	if (le32_to_cpu(es->s_log_cluster_size) >
-	    (EXT4_MAX_CLUSTER_LOG_SIZE - EXT4_MIN_BLOCK_LOG_SIZE)) {
-		ext4_msg(sb, KERN_ERR,
-=======
 		ext4_msg(sb, KERN_ERR,
 			 "Invalid log block size: %u",
 			 le32_to_cpu(es->s_log_block_size));
@@ -4280,7 +4193,6 @@ static int ext4_fill_super(struct super_
 	if (le32_to_cpu(es->s_log_cluster_size) >
 	    (EXT4_MAX_CLUSTER_LOG_SIZE - EXT4_MIN_BLOCK_LOG_SIZE)) {
 		ext4_msg(sb, KERN_ERR,
->>>>>>> linux-next/akpm-base
 			 "Invalid log cluster size: %u",
 			 le32_to_cpu(es->s_log_cluster_size));
 		goto failed_mount;
@@ -5560,17 +5472,8 @@ err_out:
 static void ext4_update_super(struct super_block *sb)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
-<<<<<<< HEAD
-	struct ext4_super_block *es = EXT4_SB(sb)->s_es;
-	struct buffer_head *sbh = EXT4_SB(sb)->s_sbh;
-	int error = 0;
-
-	if (!sbh || block_device_ejected(sb))
-		return error;
-=======
 	struct ext4_super_block *es = sbi->s_es;
 	struct buffer_head *sbh = sbi->s_sbh;
->>>>>>> linux-next/akpm-base
 
 	lock_buffer(sbh);
 	/*
@@ -5596,11 +5499,7 @@ static void ext4_update_super(struct sup
 	if (percpu_counter_initialized(&sbi->s_freeinodes_counter))
 		es->s_free_inodes_count =
 			cpu_to_le32(percpu_counter_sum_positive(
-<<<<<<< HEAD
-				&EXT4_SB(sb)->s_freeinodes_counter));
-=======
 				&sbi->s_freeinodes_counter));
->>>>>>> linux-next/akpm-base
 	/* Copy error information to the on-disk superblock */
 	spin_lock(&sbi->s_error_lock);
 	if (sbi->s_add_error_count > 0) {
@@ -5641,10 +5540,7 @@ static void ext4_update_super(struct sup
 	}
 	spin_unlock(&sbi->s_error_lock);
 
-<<<<<<< HEAD
 	BUFFER_TRACE(sbh, "marking dirty");
-=======
->>>>>>> linux-next/akpm-base
 	ext4_superblock_csum_set(sb);
 	unlock_buffer(sbh);
 }
--- a/kernel/dma/map_benchmark.c~linux-next-git-rejects
+++ a/kernel/dma/map_benchmark.c
@@ -214,15 +214,12 @@ static long map_benchmark_ioctl(struct f
 			return -EINVAL;
 		}
 
-<<<<<<< HEAD
-=======
 		if (map->bparam.dma_bits < 20 ||
 		    map->bparam.dma_bits > 64) {
 			pr_err("invalid dma_bits\n");
 			return -EINVAL;
 		}
 
->>>>>>> linux-next/akpm-base
 		if (map->bparam.node != NUMA_NO_NODE &&
 		    !node_possible(map->bparam.node)) {
 			pr_err("invalid numa node\n");
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-add-a-missing-mm_page_alloc_zone_locked-tracepoint-fix.patch
mm.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-fix.patch
mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage-checkpatch-fixes.patch
mm-fix-initialization-of-struct-page-for-holes-in-memory-layout-checkpatch-fixes.patch
mm-cma-allocate-cma-areas-bottom-up-fix-3-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
kfence-kasan-make-kfence-compatible-with-kasan-fix.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

