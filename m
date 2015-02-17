From: akpm@linux-foundation.org
Subject: [merged] ocfs2-implement-ocfs2_direct_io_write.patch removed from -mm tree
Date: Tue, 17 Feb 2015 12:06:22 -0800
Message-ID: <54e39f3e.whjh0CXniLCzRYsH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35340 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916AbbBQUGX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Feb 2015 15:06:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, alex.chen@huawei.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@suse.com, wangww631@huawei.com, xuejiufei@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: implement ocfs2_direct_IO_write
has been removed from the -mm tree.  Its filename was
     ocfs2-implement-ocfs2_direct_io_write.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: implement ocfs2_direct_IO_write

Implement ocfs2_direct_IO_write.  Add the inode to orphan dir first, and
then delete it once append O_DIRECT finished.

This is to make sure block allocation and inode size are consistent.

[akpm@linux-foundation.org: fix it for "block: Add discard flag to blkdev_issue_zeroout() function"]
Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Weiwei Wang <wangww631@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Xuejiufei <xuejiufei@huawei.com>
Cc: alex chen <alex.chen@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c  |  197 ++++++++++++++++++++++++++++++++++++++++++++-
 fs/ocfs2/ocfs2.h |   10 ++
 2 files changed, 204 insertions(+), 3 deletions(-)

diff -puN fs/ocfs2/aops.c~ocfs2-implement-ocfs2_direct_io_write fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-implement-ocfs2_direct_io_write
+++ a/fs/ocfs2/aops.c
@@ -28,6 +28,7 @@
 #include <linux/pipe_fs_i.h>
 #include <linux/mpage.h>
 #include <linux/quotaops.h>
+#include <linux/blkdev.h>
 
 #include <cluster/masklog.h>
 
@@ -47,6 +48,9 @@
 #include "ocfs2_trace.h"
 
 #include "buffer_head_io.h"
+#include "dir.h"
+#include "namei.h"
+#include "sysfile.h"
 
 static int ocfs2_symlink_get_block(struct inode *inode, sector_t iblock,
 				   struct buffer_head *bh_result, int create)
@@ -597,6 +601,184 @@ static int ocfs2_releasepage(struct page
 	return try_to_free_buffers(page);
 }
 
+static int ocfs2_is_overwrite(struct ocfs2_super *osb,
+		struct inode *inode, loff_t offset)
+{
+	int ret = 0;
+	u32 v_cpos = 0;
+	u32 p_cpos = 0;
+	unsigned int num_clusters = 0;
+	unsigned int ext_flags = 0;
+
+	v_cpos = ocfs2_bytes_to_clusters(osb->sb, offset);
+	ret = ocfs2_get_clusters(inode, v_cpos, &p_cpos,
+			&num_clusters, &ext_flags);
+	if (ret < 0) {
+		mlog_errno(ret);
+		return ret;
+	}
+
+	if (p_cpos && !(ext_flags & OCFS2_EXT_UNWRITTEN))
+		return 1;
+
+	return 0;
+}
+
+static ssize_t ocfs2_direct_IO_write(struct kiocb *iocb,
+		struct iov_iter *iter,
+		loff_t offset)
+{
+	ssize_t ret = 0;
+	ssize_t written = 0;
+	bool orphaned = false;
+	int is_overwrite = 0;
+	struct file *file = iocb->ki_filp;
+	struct inode *inode = file_inode(file)->i_mapping->host;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct buffer_head *di_bh = NULL;
+	size_t count = iter->count;
+	journal_t *journal = osb->journal->j_journal;
+	u32 zero_len;
+	int cluster_align;
+	loff_t final_size = offset + count;
+	int append_write = offset >= i_size_read(inode) ? 1 : 0;
+	unsigned int num_clusters = 0;
+	unsigned int ext_flags = 0;
+
+	{
+		u64 o = offset;
+
+		zero_len = do_div(o, 1 << osb->s_clustersize_bits);
+		cluster_align = !zero_len;
+	}
+
+	/*
+	 * when final_size > inode->i_size, inode->i_size will be
+	 * updated after direct write, so add the inode to orphan
+	 * dir first.
+	 */
+	if (final_size > i_size_read(inode)) {
+		ret = ocfs2_add_inode_to_orphan(osb, inode);
+		if (ret < 0) {
+			mlog_errno(ret);
+			goto out;
+		}
+		orphaned = true;
+	}
+
+	if (append_write) {
+		ret = ocfs2_inode_lock(inode, &di_bh, 1);
+		if (ret < 0) {
+			mlog_errno(ret);
+			goto clean_orphan;
+		}
+
+		if (ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb)))
+			ret = ocfs2_zero_extend(inode, di_bh, offset);
+		else
+			ret = ocfs2_extend_no_holes(inode, di_bh, offset,
+					offset);
+		if (ret < 0) {
+			mlog_errno(ret);
+			ocfs2_inode_unlock(inode, 1);
+			brelse(di_bh);
+			goto clean_orphan;
+		}
+
+		is_overwrite = ocfs2_is_overwrite(osb, inode, offset);
+		if (is_overwrite < 0) {
+			mlog_errno(is_overwrite);
+			ocfs2_inode_unlock(inode, 1);
+			brelse(di_bh);
+			goto clean_orphan;
+		}
+
+		ocfs2_inode_unlock(inode, 1);
+		brelse(di_bh);
+		di_bh = NULL;
+	}
+
+	written = __blockdev_direct_IO(WRITE, iocb, inode, inode->i_sb->s_bdev,
+			iter, offset,
+			ocfs2_direct_IO_get_blocks,
+			ocfs2_dio_end_io, NULL, 0);
+	if (unlikely(written < 0)) {
+		loff_t i_size = i_size_read(inode);
+
+		if (offset + count > i_size) {
+			ret = ocfs2_inode_lock(inode, &di_bh, 1);
+			if (ret < 0) {
+				mlog_errno(ret);
+				goto clean_orphan;
+			}
+
+			if (i_size == i_size_read(inode)) {
+				ret = ocfs2_truncate_file(inode, di_bh,
+						i_size);
+				if (ret < 0) {
+					if (ret != -ENOSPC)
+						mlog_errno(ret);
+
+					ocfs2_inode_unlock(inode, 1);
+					brelse(di_bh);
+					goto clean_orphan;
+				}
+			}
+
+			ocfs2_inode_unlock(inode, 1);
+			brelse(di_bh);
+
+			ret = jbd2_journal_force_commit(journal);
+			if (ret < 0)
+				mlog_errno(ret);
+		}
+	} else if (written < 0 && append_write && !is_overwrite &&
+			!cluster_align) {
+		u32 p_cpos = 0;
+		u32 v_cpos = ocfs2_bytes_to_clusters(osb->sb, offset);
+
+		ret = ocfs2_get_clusters(inode, v_cpos, &p_cpos,
+				&num_clusters, &ext_flags);
+		if (ret < 0) {
+			mlog_errno(ret);
+			goto clean_orphan;
+		}
+
+		BUG_ON(!p_cpos || (ext_flags & OCFS2_EXT_UNWRITTEN));
+
+		ret = blkdev_issue_zeroout(osb->sb->s_bdev,
+				p_cpos << (osb->s_clustersize_bits - 9),
+				zero_len >> 9, GFP_KERNEL, false);
+		if (ret < 0)
+			mlog_errno(ret);
+	}
+
+clean_orphan:
+	if (orphaned) {
+		int tmp_ret;
+		int update_isize = written > 0 ? 1 : 0;
+		loff_t end = update_isize ? offset + written : 0;
+
+		tmp_ret = ocfs2_del_inode_from_orphan(osb, inode,
+				update_isize, end);
+		if (tmp_ret < 0) {
+			ret = tmp_ret;
+			goto out;
+		}
+
+		tmp_ret = jbd2_journal_force_commit(journal);
+		if (tmp_ret < 0) {
+			ret = tmp_ret;
+			mlog_errno(tmp_ret);
+		}
+	}
+
+out:
+	if (ret >= 0)
+		ret = written;
+	return ret;
+}
+
 static ssize_t ocfs2_direct_IO(int rw,
 			       struct kiocb *iocb,
 			       struct iov_iter *iter,
@@ -604,6 +786,9 @@ static ssize_t ocfs2_direct_IO(int rw,
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(file)->i_mapping->host;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	int full_coherency = !(osb->s_mount_opt &
+			OCFS2_MOUNT_COHERENCY_BUFFERED);
 
 	/*
 	 * Fallback to buffered I/O if we see an inode without
@@ -612,14 +797,20 @@ static ssize_t ocfs2_direct_IO(int rw,
 	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
 		return 0;
 
-	/* Fallback to buffered I/O if we are appending. */
-	if (i_size_read(inode) <= offset)
+	/* Fallback to buffered I/O if we are appending and
+	 * concurrent O_DIRECT writes are allowed.
+	 */
+	if (i_size_read(inode) <= offset && !full_coherency)
 		return 0;
 
-	return __blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev,
+	if (rw == READ)
+		return __blockdev_direct_IO(rw, iocb, inode,
+				    inode->i_sb->s_bdev,
 				    iter, offset,
 				    ocfs2_direct_IO_get_blocks,
 				    ocfs2_dio_end_io, NULL, 0);
+	else
+		return ocfs2_direct_IO_write(iocb, iter, offset);
 }
 
 static void ocfs2_figure_cluster_boundaries(struct ocfs2_super *osb,
diff -puN fs/ocfs2/ocfs2.h~ocfs2-implement-ocfs2_direct_io_write fs/ocfs2/ocfs2.h
--- a/fs/ocfs2/ocfs2.h~ocfs2-implement-ocfs2_direct_io_write
+++ a/fs/ocfs2/ocfs2.h
@@ -731,6 +731,16 @@ static inline unsigned int ocfs2_cluster
 	return clusters;
 }
 
+static inline unsigned int ocfs2_bytes_to_clusters(struct super_block *sb,
+		u64 bytes)
+{
+	int cl_bits = OCFS2_SB(sb)->s_clustersize_bits;
+	unsigned int clusters;
+
+	clusters = (unsigned int)(bytes >> cl_bits);
+	return clusters;
+}
+
 static inline u64 ocfs2_blocks_for_bytes(struct super_block *sb,
 					 u64 bytes)
 {
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

origin.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages-v3.patch

