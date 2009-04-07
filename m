From: akpm@linux-foundation.org
Subject: [merged] nilfs2-fix-miss-sync-issue-for-do_sync_mapping_range.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:08:57 -0700
Message-ID: <200904071908.n37J8vsm012044@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36923 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759983AbZDGTLe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:11:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, chris.mason@oracle.com, mm-commits@vger.kernel.org


The patch titled
     nilfs2: fix missed-sync issue for do_sync_mapping_range()
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-miss-sync-issue-for-do_sync_mapping_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nilfs2: fix missed-sync issue for do_sync_mapping_range()
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

Chris Mason pointed out that there is a missed sync issue in
nilfs_writepages():

On Wed, 17 Dec 2008 21:52:55 -0500, Chris Mason wrote:
> It looks like nilfs_writepage ignores WB_SYNC_NONE, which is used by
> do_sync_mapping_range().

where WB_SYNC_NONE in do_sync_mapping_range() was replaced with
WB_SYNC_ALL by Nick's patch (commit:
ee53a891f47444c53318b98dac947ede963db400).

This fixes the problem by letting nilfs_writepages() write out the log of
file data within the range if sync_mode is WB_SYNC_ALL.

This involves removal of nilfs_file_aio_write() which was previously
needed to ensure O_SYNC sync writes.

Cc: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/file.c    |   27 +--------
 fs/nilfs2/inode.c   |   16 +++--
 fs/nilfs2/segment.c |  120 +++++++++++++++++++++++++-----------------
 fs/nilfs2/segment.h |   11 +++
 4 files changed, 93 insertions(+), 81 deletions(-)

diff -puN fs/nilfs2/file.c~nilfs2-fix-miss-sync-issue-for-do_sync_mapping_range fs/nilfs2/file.c
--- a/fs/nilfs2/file.c~nilfs2-fix-miss-sync-issue-for-do_sync_mapping_range
+++ a/fs/nilfs2/file.c
@@ -44,35 +44,14 @@ int nilfs_sync_file(struct file *file, s
 		return 0;
 
 	if (datasync)
-		err = nilfs_construct_dsync_segment(inode->i_sb, inode);
+		err = nilfs_construct_dsync_segment(inode->i_sb, inode, 0,
+						    LLONG_MAX);
 	else
 		err = nilfs_construct_segment(inode->i_sb);
 
 	return err;
 }
 
-static ssize_t
-nilfs_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
-		     unsigned long nr_segs, loff_t pos)
-{
-	struct file *file = iocb->ki_filp;
-	struct inode *inode = file->f_dentry->d_inode;
-	ssize_t ret;
-
-	ret = generic_file_aio_write(iocb, iov, nr_segs, pos);
-	if (ret <= 0)
-		return ret;
-
-	if ((file->f_flags & O_SYNC) || IS_SYNC(inode)) {
-		int err;
-
-		err = nilfs_construct_dsync_segment(inode->i_sb, inode);
-		if (unlikely(err))
-			return err;
-	}
-	return ret;
-}
-
 static int nilfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct page *page = vmf->page;
@@ -160,7 +139,7 @@ struct file_operations nilfs_file_operat
 	.read		= do_sync_read,
 	.write		= do_sync_write,
 	.aio_read	= generic_file_aio_read,
-	.aio_write	= nilfs_file_aio_write,
+	.aio_write	= generic_file_aio_write,
 	.ioctl		= nilfs_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= nilfs_compat_ioctl,
diff -puN fs/nilfs2/inode.c~nilfs2-fix-miss-sync-issue-for-do_sync_mapping_range fs/nilfs2/inode.c
--- a/fs/nilfs2/inode.c~nilfs2-fix-miss-sync-issue-for-do_sync_mapping_range
+++ a/fs/nilfs2/inode.c
@@ -24,6 +24,7 @@
 #include <linux/buffer_head.h>
 #include <linux/mpage.h>
 #include <linux/writeback.h>
+#include <linux/uio.h>
 #include "nilfs.h"
 #include "segment.h"
 #include "page.h"
@@ -145,8 +146,14 @@ static int nilfs_readpages(struct file *
 static int nilfs_writepages(struct address_space *mapping,
 			    struct writeback_control *wbc)
 {
-	/* This empty method is required not to call generic_writepages() */
-	return 0;
+	struct inode *inode = mapping->host;
+	int err = 0;
+
+	if (wbc->sync_mode == WB_SYNC_ALL)
+		err = nilfs_construct_dsync_segment(inode->i_sb, inode,
+						    wbc->range_start,
+						    wbc->range_end);
+	return err;
 }
 
 static int nilfs_writepage(struct page *page, struct writeback_control *wbc)
@@ -225,11 +232,6 @@ nilfs_direct_IO(int rw, struct kiocb *io
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
 	ssize_t size;
-	int err;
-
-	err = nilfs_construct_dsync_segment(inode->i_sb, inode);
-	if (unlikely(err))
-		return err;
 
 	if (rw == WRITE)
 		return 0;
diff -puN fs/nilfs2/segment.c~nilfs2-fix-miss-sync-issue-for-do_sync_mapping_range fs/nilfs2/segment.c
--- a/fs/nilfs2/segment.c~nilfs2-fix-miss-sync-issue-for-do_sync_mapping_range
+++ a/fs/nilfs2/segment.c
@@ -654,29 +654,41 @@ struct nilfs_sc_operations nilfs_sc_dsyn
 	.write_node_binfo = NULL,
 };
 
-static int nilfs_lookup_dirty_data_buffers(struct inode *inode,
-					   struct list_head *listp,
-					   struct nilfs_sc_info *sci)
+static size_t nilfs_lookup_dirty_data_buffers(struct inode *inode,
+					      struct list_head *listp,
+					      size_t nlimit,
+					      loff_t start, loff_t end)
 {
-	struct nilfs_segment_buffer *segbuf = sci->sc_curseg;
 	struct address_space *mapping = inode->i_mapping;
 	struct pagevec pvec;
-	unsigned i, ndirties = 0, nlimit;
-	pgoff_t index = 0;
-	int err = 0;
+	pgoff_t index = 0, last = ULONG_MAX;
+	size_t ndirties = 0;
+	int i;
 
-	nlimit = sci->sc_segbuf_nblocks -
-		(sci->sc_nblk_this_inc + segbuf->sb_sum.nblocks);
+	if (unlikely(start != 0 || end != LLONG_MAX)) {
+		/*
+		 * A valid range is given for sync-ing data pages. The
+		 * range is rounded to per-page; extra dirty buffers
+		 * may be included if blocksize < pagesize.
+		 */
+		index = start >> PAGE_SHIFT;
+		last = end >> PAGE_SHIFT;
+	}
 	pagevec_init(&pvec, 0);
  repeat:
-	if (!pagevec_lookup_tag(&pvec, mapping, &index, PAGECACHE_TAG_DIRTY,
-				PAGEVEC_SIZE))
-		return 0;
+	if (unlikely(index > last) ||
+	    !pagevec_lookup_tag(&pvec, mapping, &index, PAGECACHE_TAG_DIRTY,
+				min_t(pgoff_t, last - index,
+				      PAGEVEC_SIZE - 1) + 1))
+		return ndirties;
 
 	for (i = 0; i < pagevec_count(&pvec); i++) {
 		struct buffer_head *bh, *head;
 		struct page *page = pvec.pages[i];
 
+		if (unlikely(page->index > last))
+			break;
+
 		if (mapping->host) {
 			lock_page(page);
 			if (!page_has_buffers(page))
@@ -687,24 +699,21 @@ static int nilfs_lookup_dirty_data_buffe
 
 		bh = head = page_buffers(page);
 		do {
-			if (buffer_dirty(bh)) {
-				if (ndirties > nlimit) {
-					err = -E2BIG;
-					break;
-				}
-				get_bh(bh);
-				list_add_tail(&bh->b_assoc_buffers, listp);
-				ndirties++;
+			if (!buffer_dirty(bh))
+				continue;
+			get_bh(bh);
+			list_add_tail(&bh->b_assoc_buffers, listp);
+			ndirties++;
+			if (unlikely(ndirties >= nlimit)) {
+				pagevec_release(&pvec);
+				cond_resched();
+				return ndirties;
 			}
-			bh = bh->b_this_page;
-		} while (bh != head);
+		} while (bh = bh->b_this_page, bh != head);
 	}
 	pagevec_release(&pvec);
 	cond_resched();
-
-	if (!err)
-		goto repeat;
-	return err;
+	goto repeat;
 }
 
 static void nilfs_lookup_dirty_node_buffers(struct inode *inode,
@@ -1058,23 +1067,31 @@ static int nilfs_segctor_apply_buffers(s
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
-						      sci);
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
@@ -1114,16 +1131,20 @@ static int nilfs_segctor_scan_file_dsync
 					 struct inode *inode)
 {
 	LIST_HEAD(data_buffers);
-	int err, err2;
+	size_t n, rest = nilfs_segctor_buffer_rest(sci);
+	int err;
 
-	err = nilfs_lookup_dirty_data_buffers(inode, &data_buffers, sci);
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
 
@@ -1276,14 +1297,13 @@ static int nilfs_segctor_collect_blocks(
 	case NILFS_ST_DSYNC:
  dsync_mode:
 		sci->sc_curseg->sb_sum.flags |= NILFS_SS_SYNDT;
-		ii = sci->sc_stage.dirty_file_ptr;
+		ii = sci->sc_dsync_inode;
 		if (!test_bit(NILFS_I_BUSY, &ii->i_state))
 			break;
 
 		err = nilfs_segctor_scan_file_dsync(sci, &ii->vfs_inode);
 		if (unlikely(err))
 			break;
-		sci->sc_stage.dirty_file_ptr = NULL;
 		sci->sc_curseg->sb_sum.flags |= NILFS_SS_LOGEND;
 		sci->sc_stage.scnt = NILFS_ST_DONE;
 		return 0;
@@ -2624,7 +2644,9 @@ int nilfs_construct_segment(struct super
 /**
  * nilfs_construct_dsync_segment - construct a data-only logical segment
  * @sb: super block
- * @inode: the inode whose data blocks should be written out
+ * @inode: inode whose data blocks should be written out
+ * @start: start byte offset
+ * @end: end byte offset (inclusive)
  *
  * Return Value: On success, 0 is retured. On errors, one of the following
  * negative error code is returned.
@@ -2639,8 +2661,8 @@ int nilfs_construct_segment(struct super
  *
  * %-ENOMEM - Insufficient memory available.
  */
-int nilfs_construct_dsync_segment(struct super_block *sb,
-				  struct inode *inode)
+int nilfs_construct_dsync_segment(struct super_block *sb, struct inode *inode,
+				  loff_t start, loff_t end)
 {
 	struct nilfs_sb_info *sbi = NILFS_SB(sb);
 	struct nilfs_sc_info *sci = NILFS_SC(sbi);
@@ -2671,7 +2693,9 @@ int nilfs_construct_dsync_segment(struct
 		return 0;
 	}
 	spin_unlock(&sbi->s_inode_lock);
-	sci->sc_stage.dirty_file_ptr = ii;
+	sci->sc_dsync_inode = ii;
+	sci->sc_dsync_start = start;
+	sci->sc_dsync_end = end;
 
 	err = nilfs_segctor_do_construct(sci, SC_LSEG_DSYNC);
 
diff -puN fs/nilfs2/segment.h~nilfs2-fix-miss-sync-issue-for-do_sync_mapping_range fs/nilfs2/segment.h
--- a/fs/nilfs2/segment.h~nilfs2-fix-miss-sync-issue-for-do_sync_mapping_range
+++ a/fs/nilfs2/segment.h
@@ -93,6 +93,9 @@ struct nilfs_segsum_pointer {
  * @sc_active_segments: List of active segments that were already written out
  * @sc_cleaning_segments: List of segments to be freed through construction
  * @sc_copied_buffers: List of copied buffers (buffer heads) to freeze data
+ * @sc_dsync_inode: inode whose data pages are written for a sync operation
+ * @sc_dsync_start: start byte offset of data pages
+ * @sc_dsync_end: end byte offset of data pages (inclusive)
  * @sc_segbufs: List of segment buffers
  * @sc_segbuf_nblocks: Number of available blocks in segment buffers.
  * @sc_curseg: Current segment buffer
@@ -134,6 +137,10 @@ struct nilfs_sc_info {
 	struct list_head	sc_cleaning_segments;
 	struct list_head	sc_copied_buffers;
 
+	struct nilfs_inode_info *sc_dsync_inode;
+	loff_t			sc_dsync_start;
+	loff_t			sc_dsync_end;
+
 	/* Segment buffers */
 	struct list_head	sc_segbufs;
 	unsigned long		sc_segbuf_nblocks;
@@ -221,8 +228,8 @@ extern void nilfs_destroy_transaction_ca
 extern void nilfs_relax_pressure_in_lock(struct super_block *);
 
 extern int nilfs_construct_segment(struct super_block *);
-extern int nilfs_construct_dsync_segment(struct super_block *,
-					 struct inode *);
+extern int nilfs_construct_dsync_segment(struct super_block *, struct inode *,
+					 loff_t, loff_t);
 extern void nilfs_flush_segment(struct super_block *, ino_t);
 extern int nilfs_clean_segments(struct super_block *, void __user *);
 
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

origin.patch

