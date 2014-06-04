From: akpm@linux-foundation.org
Subject: [folded-merged] fs-add-generic-data-flush-to-fsync-fix.patch
 removed from -mm tree
Date: Wed, 04 Jun 2014 15:20:03 -0700
Message-ID: <538f9b93.LTfzn2etWTAficeJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38938 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbaFDWUE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2014 18:20:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu, jack@suse.cz, hch@infradead.org, fabf@skynet.be, akpm@linux-foundation.org

Subject: [folded-merged] fs-add-generic-data-flush-to-fsync-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,fabf@skynet.be,hch@infradead.org,jack@suse.cz,tytso@mit.edu,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 04 Jun 2014 15:20:03 -0700


The patch titled
     Subject: fs-add-generic-data-flush-to-fsync-fix
has been removed from the -mm tree.  Its filename was
     fs-add-generic-data-flush-to-fsync-fix.patch

This patch was dropped because it was folded into fs-add-generic-data-flush-to-fsync.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-add-generic-data-flush-to-fsync-fix

nuke ifdef

Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Fabian Frederick <fabf@skynet.be>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/libfs.c             |    5 -----
 include/linux/blkdev.h |    6 ++++++
 2 files changed, 6 insertions(+), 5 deletions(-)

diff -puN fs/libfs.c~fs-add-generic-data-flush-to-fsync-fix fs/libfs.c
--- a/fs/libfs.c~fs-add-generic-data-flush-to-fsync-fix
+++ a/fs/libfs.c
@@ -982,12 +982,7 @@ int generic_file_fsync(struct file *file
 	err = __generic_file_fsync(file, start, end, datasync);
 	if (err)
 		return err;
-#ifdef CONFIG_BLOCK
 	return blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
-#else
-	return err;
-#endif
-
 }
 EXPORT_SYMBOL(generic_file_fsync);
 
diff -puN include/linux/blkdev.h~fs-add-generic-data-flush-to-fsync-fix include/linux/blkdev.h
--- a/include/linux/blkdev.h~fs-add-generic-data-flush-to-fsync-fix
+++ a/include/linux/blkdev.h
@@ -1624,6 +1624,12 @@ static inline bool blk_needs_flush_plug(
 	return false;
 }
 
+static inline int blkdev_issue_flush(struct block_device *bdev, gfp_t gfp_mask,
+				     sector_t *error_sector)
+{
+	return 0;
+}
+
 #endif /* CONFIG_BLOCK */
 
 #endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1.patch
arch-unicore32-mm-ioremapc-return-null-on-invalid-pfn.patch
ocfs2-limit-printk-when-journal-is-aborted.patch
fs-add-generic-data-flush-to-fsync.patch
fs-add-generic-data-flush-to-fsync-fix-fix.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
include-linux-mmdebugh-add-vm_warn_on-and-vm_warn_on_once.patch
mm-mempool-warn-about-__gfp_zero-usage-fix.patch
mm-pass-vm_bug_on-reason-to-dump_page-fix.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime-checkpatch-fixes.patch
mm-page_alloc-do-not-cache-reclaim-distances-fix.patch
fs-hugetlbfs-inodec-complete-conversion-to-pr_foo.patch
mm-compaction-cleanup-isolate_freepages-fix.patch
arc-call-find_vma-with-the-mmap_sem-held-fix.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal-checkpatch-fixes.patch
swap-use-bdev_read_page-bdev_write_page-fix.patch
mm-update-comment-for-default_max_map_count-fix.patch
memcg-fold-mem_cgroup_stolen-fix.patch
mm-compaction-embed-migration-mode-in-compact_control-fix.patch
mm-add-comment-for-__mod_zone_page_stat.patch
mm-add-comment-for-__mod_zone_page_stat-checkpatch-fixes.patch
mm-fold-mlocked_vma_newpage-into-its-only-call-site.patch
mm-fold-mlocked_vma_newpage-into-its-only-call-site-checkpatch-fixes.patch
fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers-fix.patch
mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possiblefix-2.patch
mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention-fix.patch
mm-document-do_fault_around-feature-fix.patch
mm-memory-failurec-support-dedicated-thread-to-handle-sigbusbus_mceerr_ao-checkpatch-fixes.patch
kernel-res_counterc-replace-simple_strtoull-by-kstrtoull-fix.patch
printk-release-lockbuf_lock-before-calling-console_trylock_for_printk-fix.patch
lib-btreec-fix-leak-of-whole-btree-nodes-fix.patch
init-mainc-dont-use-pr_debug.patch
init-mainc-add-initcall_blacklist-kernel-parameter-fix.patch
init-mainc-remove-an-ifdef.patch

