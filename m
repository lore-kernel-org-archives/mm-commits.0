From: akpm@linux-foundation.org
Subject: [folded] nilfs2-fix-miss-sync-issue-for-do_sync_mapping_range-fix.patch removed from -mm tree
Date: Mon, 06 Apr 2009 15:36:49 -0700
Message-ID: <200904062236.n36Manv5018659@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45649 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756082AbZDFWif (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 18:38:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     nilfs2: fix segment summary corruption
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-miss-sync-issue-for-do_sync_mapping_range-fix.patch

This patch was dropped because it was folded into nilfs2-fix-miss-sync-issue-for-do_sync_mapping_range.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nilfs2: fix segment summary corruption
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

With a report from David Arendt, one of the recent bug fixes
(nilfs2-fix-miss-sync-issue-for-do_sync_mapping_range.patch) turned
out to break segment summary under some conditions.

This fixes the problem and clarifies a few routines to prevent similar
regressions.  Thanks to David for his ardent feedbacks.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segment.c |   83 ++++++++++++++++++++----------------------
 1 file changed, 41 insertions(+), 42 deletions(-)

diff -puN fs/nilfs2/segment.c~nilfs2-fix-miss-sync-issue-for-do_sync_mapping_range-fix fs/nilfs2/segment.c
--- a/fs/nilfs2/segment.c~nilfs2-fix-miss-sync-issue-for-do_sync_mapping_range-fix
+++ a/fs/nilfs2/segment.c
@@ -654,17 +654,16 @@ struct nilfs_sc_operations nilfs_sc_dsyn
 	.write_node_binfo = NULL,
 };
 
-static int nilfs_lookup_dirty_data_buffers(struct inode *inode,
-					   struct list_head *listp,
-					   struct nilfs_sc_info *sci,
-					   loff_t start, loff_t end)
+static size_t nilfs_lookup_dirty_data_buffers(struct inode *inode,
+					      struct list_head *listp,
+					      size_t nlimit,
+					      loff_t start, loff_t end)
 {
-	struct nilfs_segment_buffer *segbuf = sci->sc_curseg;
 	struct address_space *mapping = inode->i_mapping;
 	struct pagevec pvec;
-	unsigned i, ndirties = 0, nlimit;
 	pgoff_t index = 0, last = ULONG_MAX;
-	int err = 0;
+	size_t ndirties = 0;
+	int i;
 
 	if (unlikely(start != 0 || end != LLONG_MAX)) {
 		/*
@@ -675,16 +674,13 @@ static int nilfs_lookup_dirty_data_buffe
 		index = start >> PAGE_SHIFT;
 		last = end >> PAGE_SHIFT;
 	}
-	nlimit = sci->sc_segbuf_nblocks -
-		(sci->sc_nblk_this_inc + segbuf->sb_sum.nblocks);
-		/* Remaining number of blocks within the segment */
 	pagevec_init(&pvec, 0);
  repeat:
 	if (unlikely(index > last) ||
 	    !pagevec_lookup_tag(&pvec, mapping, &index, PAGECACHE_TAG_DIRTY,
 				min_t(pgoff_t, last - index,
 				      PAGEVEC_SIZE - 1) + 1))
-		return 0;
+		return ndirties;
 
 	for (i = 0; i < pagevec_count(&pvec); i++) {
 		struct buffer_head *bh, *head;
@@ -705,25 +701,19 @@ static int nilfs_lookup_dirty_data_buffe
 		do {
 			if (!buffer_dirty(bh))
 				continue;
-			if (unlikely(ndirties >= nlimit)) {
-				err = -E2BIG; /*
-					       * Internal code to indicate the
-					       * inode has more dirty buffers.
-					       */
-				goto bounded;
-			}
 			get_bh(bh);
 			list_add_tail(&bh->b_assoc_buffers, listp);
 			ndirties++;
+			if (unlikely(ndirties >= nlimit)) {
+				pagevec_release(&pvec);
+				cond_resched();
+				return ndirties;
+			}
 		} while (bh = bh->b_this_page, bh != head);
 	}
- bounded:
 	pagevec_release(&pvec);
 	cond_resched();
-
-	if (!err)
-		goto repeat;
-	return err;
+	goto repeat;
 }
 
 static void nilfs_lookup_dirty_node_buffers(struct inode *inode,
@@ -1077,23 +1067,31 @@ static int nilfs_segctor_apply_buffers(s
 	return err;
 }
 
+static size_t nilfs_segctor_buffer_rest(struct nilfs_sc_info *sci)
+{
+	/* Remaining number of blocks within segment buffer */
+	return sci->sc_segbuf_nblocks -
+		(sci->sc_nblk_this_inc + sci->sc_curseg->sb_sum.nblocks);
+}
+
 static int nilfs_segctor_scan_file(struct nilfs_sc_info *sci,
 				   struct inode *inode,
 				   struct nilfs_sc_operations *sc_ops)
 {
 	LIST_HEAD(data_buffers);
 	LIST_HEAD(node_buffers);
-	int err, err2;
+	int err;
 
 	if (!(sci->sc_stage.flags & NILFS_CF_NODE)) {
-		err = nilfs_lookup_dirty_data_buffers(inode, &data_buffers,
-						      sci, 0, LLONG_MAX);
-		if (err) {
-			err2 = nilfs_segctor_apply_buffers(
+		size_t n, rest = nilfs_segctor_buffer_rest(sci);
+
+		n = nilfs_lookup_dirty_data_buffers(
+			inode, &data_buffers, rest + 1, 0, LLONG_MAX);
+		if (n > rest) {
+			err = nilfs_segctor_apply_buffers(
 				sci, inode, &data_buffers,
-				err == -E2BIG ? sc_ops->collect_data : NULL);
-			if (err == -E2BIG)
-				err = err2;
+				sc_ops->collect_data);
+			BUG_ON(!err); /* always receive -E2BIG or true error */
 			goto break_or_fail;
 		}
 	}
@@ -1133,19 +1131,20 @@ static int nilfs_segctor_scan_file_dsync
 					 struct inode *inode)
 {
 	LIST_HEAD(data_buffers);
-	int err, err2;
+	size_t n, rest = nilfs_segctor_buffer_rest(sci);
+	int err;
 
-	err = nilfs_lookup_dirty_data_buffers(inode, &data_buffers, sci,
-					      sci->sc_dsync_start,
-					      sci->sc_dsync_end);
-
-	err2 = nilfs_segctor_apply_buffers(sci, inode, &data_buffers,
-					   (!err || err == -E2BIG) ?
-					   nilfs_collect_file_data : NULL);
-	if (err == -E2BIG)
-		err = err2;
-	if (!err)
+	n = nilfs_lookup_dirty_data_buffers(inode, &data_buffers, rest + 1,
+					    sci->sc_dsync_start,
+					    sci->sc_dsync_end);
+
+	err = nilfs_segctor_apply_buffers(sci, inode, &data_buffers,
+					  nilfs_collect_file_data);
+	if (!err) {
 		nilfs_segctor_end_finfo(sci, inode);
+		BUG_ON(n > rest);
+		/* always receive -E2BIG or true error if n > rest */
+	}
 	return err;
 }
 
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

