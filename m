From: akpm@linux-foundation.org
Subject: [folded] nilfs2-segment-constructor-insert-checks-and-hole-block-allocation-in-page_mkwrite.patch removed from -mm tree
Date: Mon, 06 Apr 2009 15:35:57 -0700
Message-ID: <200904062235.n36MZwGD018320@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54782 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755110AbZDFWiQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 18:38:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, chris.mason@oracle.com, mm-commits@vger.kernel.org


The patch titled
     nilfs2: insert checks and hole block allocation in page_mkwrite
has been removed from the -mm tree.  Its filename was
     nilfs2-segment-constructor-insert-checks-and-hole-block-allocation-in-page_mkwrite.patch

This patch was dropped because it was folded into nilfs2-segment-constructor.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nilfs2: insert checks and hole block allocation in page_mkwrite
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

This will insert i_size check, a disk capacity check, and hole block
allocation code in the nilfs_page_mkwrite.

Previously, the hole block allocation was delayed until just before
writing for mmapped pages.  This accompanies removal of the delayed
allocation code.

This revision uses a page lock instead of i_alloc_sem for safety.

Cc: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/file.c    |   58 ++++++++++++++++++++++++++++++++++++++++--
 fs/nilfs2/segment.c |   44 +++----------------------------
 2 files changed, 61 insertions(+), 41 deletions(-)

diff -puN fs/nilfs2/file.c~nilfs2-segment-constructor-insert-checks-and-hole-block-allocation-in-page_mkwrite fs/nilfs2/file.c
--- a/fs/nilfs2/file.c~nilfs2-segment-constructor-insert-checks-and-hole-block-allocation-in-page_mkwrite
+++ a/fs/nilfs2/file.c
@@ -75,8 +75,62 @@ nilfs_file_aio_write(struct kiocb *iocb,
 
 static int nilfs_page_mkwrite(struct vm_area_struct *vma, struct page *page)
 {
-	if (!(vma->vm_flags & (VM_WRITE | VM_MAYWRITE)))
-		return -EPERM;
+	struct inode *inode = vma->vm_file->f_dentry->d_inode;
+	struct nilfs_transaction_info ti;
+	int ret;
+
+	if (unlikely(nilfs_near_disk_full(NILFS_SB(inode->i_sb)->s_nilfs)))
+		return -ENOSPC;
+
+	lock_page(page);
+	if (page->mapping != inode->i_mapping ||
+	    page_offset(page) >= i_size_read(inode) || !PageUptodate(page)) {
+		unlock_page(page);
+		return -EINVAL;
+	}
+
+	/*
+	 * check to see if the page is mapped already (no holes)
+	 */
+	if (PageMappedToDisk(page)) {
+		unlock_page(page);
+		goto mapped;
+	}
+	if (page_has_buffers(page)) {
+		struct buffer_head *bh, *head;
+		int fully_mapped = 1;
+
+		bh = head = page_buffers(page);
+		do {
+			if (!buffer_mapped(bh)) {
+				fully_mapped = 0;
+				break;
+			}
+		} while (bh = bh->b_this_page, bh != head);
+
+		if (fully_mapped) {
+			SetPageMappedToDisk(page);
+			unlock_page(page);
+			goto mapped;
+		}
+	}
+	unlock_page(page);
+
+	/*
+	 * fill hole blocks
+	 */
+	ret = nilfs_transaction_begin(inode->i_sb, &ti, 1);
+	if (unlikely(ret))
+		return ret;
+
+	ret = block_page_mkwrite(vma, page, nilfs_get_block);
+	if (unlikely(ret)) {
+		nilfs_transaction_abort(inode->i_sb);
+		return ret;
+	}
+	nilfs_transaction_commit(inode->i_sb);
+
+ mapped:
 	SetPageChecked(page);
 	wait_on_page_writeback(page);
 	return 0;
diff -puN fs/nilfs2/segment.c~nilfs2-segment-constructor-insert-checks-and-hole-block-allocation-in-page_mkwrite fs/nilfs2/segment.c
--- a/fs/nilfs2/segment.c~nilfs2-segment-constructor-insert-checks-and-hole-block-allocation-in-page_mkwrite
+++ a/fs/nilfs2/segment.c
@@ -654,42 +654,6 @@ struct nilfs_sc_operations nilfs_sc_dsyn
 	.write_node_binfo = NULL,
 };
 
-static int nilfs_prepare_data_page(struct inode *inode, struct page *page)
-{
-	int err = 0;
-
-	lock_page(page);
-	if (!page_has_buffers(page))
-		create_empty_buffers(page, 1 << inode->i_blkbits, 0);
-
-	if (!PageMappedToDisk(page)) {
-		struct buffer_head *bh, *head;
-		sector_t blkoff
-			= page->index << (PAGE_SHIFT - inode->i_blkbits);
-
-		int non_mapped = 0;
-
-		bh = head = page_buffers(page);
-		do {
-			if (!buffer_mapped(bh)) {
-				if (!buffer_dirty(bh)) {
-					non_mapped++;
-					continue;
-				}
-				err = nilfs_get_block(inode, blkoff, bh, 1);
-				if (unlikely(err))
-					goto out_unlock;
-			}
-		} while (blkoff++, (bh = bh->b_this_page) != head);
-		if (!non_mapped)
-			SetPageMappedToDisk(page);
-	}
-
- out_unlock:
-	unlock_page(page);
-	return err;
-}
-
 static int nilfs_lookup_dirty_data_buffers(struct inode *inode,
 					   struct list_head *listp,
 					   struct nilfs_sc_info *sci)
@@ -714,9 +678,11 @@ static int nilfs_lookup_dirty_data_buffe
 		struct page *page = pvec.pages[i];
 
 		if (mapping->host) {
-			err = nilfs_prepare_data_page(inode, page);
-			if (unlikely(err))
-				break;
+			lock_page(page);
+			if (!page_has_buffers(page))
+				create_empty_buffers(page,
+						     1 << inode->i_blkbits, 0);
+			unlock_page(page);
 		}
 
 		bh = head = page_buffers(page);
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

nilfs2-add-document.patch
nilfs2-disk-format-and-userland-interface.patch
nilfs2-add-inode-and-other-major-structures.patch
nilfs2-integrated-block-mapping.patch
nilfs2-b-tree-based-block-mapping.patch
nilfs2-direct-block-mapping.patch
nilfs2-b-tree-node-cache.patch
nilfs2-buffer-and-page-operations.patch
nilfs2-meta-data-file.patch
nilfs2-persistent-object-allocator.patch
nilfs2-disk-address-translator.patch
nilfs2-inode-map-file.patch
nilfs2-checkpoint-file.patch
nilfs2-segment-usage-file.patch
nilfs2-inode-operations.patch
nilfs2-file-operations.patch
nilfs2-directory-entry-operations.patch
nilfs2-pathname-operations.patch
nilfs2-operations-for-the_nilfs-core-object.patch
nilfs2-super-block-operations.patch
nilfs2-segment-buffer.patch
nilfs2-segment-constructor.patch
nilfs2-segment-constructor-insert-checks-and-hole-block-allocation-in-page_mkwrite.patch
nilfs2-segment-constructor-insert-checks-and-hole-block-allocation-in-page_mkwrite-follow-page_mkwrite-prototype-change-for-matching-fault.patch
nilfs2-segment-constructor-insert-checks-and-hole-block-allocation-in-page_mkwrite-follow-page_mkwrite-prototype-change-for-matching-fault-fix-page_mkwrite-error-cases.patch
nilfs2-fix-miss-sync-issue-for-do_sync_mapping_range.patch
nilfs2-fix-miss-sync-issue-for-do_sync_mapping_range-fix.patch
nilfs2-recovery-functions.patch
nilfs2-another-dat-for-garbage-collection.patch
nilfs2-block-cache-for-garbage-collection.patch
nilfs2-ioctl-operations.patch
nilfs2-update-makefile-and-kconfig.patch
nilfs2-fix-problems-of-memory-allocation-in-ioctl.patch
nilfs2-cleanup-nilfs_clear_inode.patch
nilfs2-avoid-double-error-caused-by-nilfs_transaction_end.patch
nilfs2-insert-explanations-in-gcinode-file.patch
nilfs2-add-maintainer.patch
nilfs2-fix-gc-failure-on-volumes-keeping-numerous-snapshots.patch
nilfs2-fix-improper-return-values-of-nilfs_get_cpinfo-ioctl.patch
nilfs2-clean-up-indirect-function-calling-conventions.patch
nilfs2-fix-buggy-behavior-seen-in-enumerating-checkpoints.patch
nilfs2-remove-timedwait-ioctl-command.patch
nilfs2-use-fixed-sized-types-for-ioctl-structures.patch
nilfs2-remove-compat-ioctl-code.patch
nilfs2-use-unlocked_ioctl.patch
nilfs2-extend-nilfs_sustat-ioctl-struct.patch
nilfs2-replace-bug_on-and-bug-calls-triggerable-from-ioctl.patch
nilfs2-super-block-operations-fix-endian-bug.patch
nilfs2-clean-up-sketch-file.patch
nilfs2-mark-minor-flag-for-checkpoint-created-by-internal-operation.patch
nilfs2-simplify-handling-of-active-state-of-segments.patch
nilfs2-introduce-secondary-super-block.patch
nilfs2-introduce-secondary-super-block-fix.patch
nilfs2-support-nanosecond-timestamp.patch

