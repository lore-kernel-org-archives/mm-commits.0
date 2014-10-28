From: akpm@linux-foundation.org
Subject: [to-be-updated]
 ocfs2-do-not-fallback-to-buffer-i-o-write-if-fill-holes.patch removed from
 -mm tree
Date: Tue, 28 Oct 2014 13:50:52 -0700
Message-ID: <545001ac.GyRaBPsO6rekDg6Z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33196 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730AbaJ1Uuv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Oct 2014 16:50:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wangww631@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: do not fall back to buffer I/O write if fill holes
has been removed from the -mm tree.  Its filename was
     ocfs2-do-not-fallback-to-buffer-i-o-write-if-fill-holes.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: WeiWei Wang <wangww631@huawei.com>
Subject: ocfs2: do not fall back to buffer I/O write if fill holes

Now append O_DIRECT write to a hole will try direct io first, then
fallback to buffered IO if fails.

Signed-off-by: Weiwei Wang <wangww631@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |   93 ++++++++++++++++++++--------------------------
 1 file changed, 42 insertions(+), 51 deletions(-)

diff -puN fs/ocfs2/file.c~ocfs2-do-not-fallback-to-buffer-i-o-write-if-fill-holes fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-do-not-fallback-to-buffer-i-o-write-if-fill-holes
+++ a/fs/ocfs2/file.c
@@ -1352,44 +1352,6 @@ out:
 	return ret;
 }
 
-/*
- * Will look for holes and unwritten extents in the range starting at
- * pos for count bytes (inclusive).
- */
-static int ocfs2_check_range_for_holes(struct inode *inode, loff_t pos,
-				       size_t count)
-{
-	int ret = 0;
-	unsigned int extent_flags;
-	u32 cpos, clusters, extent_len, phys_cpos;
-	struct super_block *sb = inode->i_sb;
-
-	cpos = pos >> OCFS2_SB(sb)->s_clustersize_bits;
-	clusters = ocfs2_clusters_for_bytes(sb, pos + count) - cpos;
-
-	while (clusters) {
-		ret = ocfs2_get_clusters(inode, cpos, &phys_cpos, &extent_len,
-					 &extent_flags);
-		if (ret < 0) {
-			mlog_errno(ret);
-			goto out;
-		}
-
-		if (phys_cpos == 0 || (extent_flags & OCFS2_EXT_UNWRITTEN)) {
-			ret = 1;
-			break;
-		}
-
-		if (extent_len > clusters)
-			extent_len = clusters;
-
-		clusters -= extent_len;
-		cpos += extent_len;
-	}
-out:
-	return ret;
-}
-
 static int ocfs2_write_remove_suid(struct inode *inode)
 {
 	int ret;
@@ -2205,18 +2167,6 @@ static int ocfs2_prepare_inode_for_write
 			break;
 		}
 
-		/*
-		 * We don't fill holes during direct io, so
-		 * check for them here. If any are found, the
-		 * caller will have to retake some cluster
-		 * locks and initiate the io as buffered.
-		 */
-		ret = ocfs2_check_range_for_holes(inode, saved_pos, count);
-		if (ret == 1) {
-			*direct_io = 0;
-			ret = 0;
-		} else if (ret < 0)
-			mlog_errno(ret);
 		break;
 	}
 
@@ -2246,6 +2196,7 @@ static ssize_t ocfs2_file_write_iter(str
 	u32 old_clusters;
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(file);
+	struct address_space *mapping = file->f_mapping;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	int full_coherency = !(osb->s_mount_opt &
 			       OCFS2_MOUNT_COHERENCY_BUFFERED);
@@ -2360,11 +2311,51 @@ relock:
 
 	iov_iter_truncate(from, count);
 	if (direct_io) {
+		loff_t endbyte;
+		ssize_t written_buffered;
 		written = generic_file_direct_write(iocb, from, *ppos);
-		if (written < 0) {
+		if (written < 0 || written == count) {
 			ret = written;
 			goto out_dio;
 		}
+		/*
+		 * direct-io write to a hole: fall through to buffered I/O
+		 * for completing the rest of the request.
+		 */
+		*ppos += written;
+		count -= written;
+		written_buffered = generic_perform_write(file, from, *ppos);
+		/*
+		 * If generic_file_buffered_write() retuned a synchronous error
+		 * then we want to return the number of bytes which were
+		 * direct-written, or the error code if that was zero.  Note
+		 * that this differs from normal direct-io semantics, which
+		 * will return -EFOO even if some bytes were written.
+		 */
+		if (written_buffered < 0) {
+			ret = written_buffered;
+			goto out;
+		}
+
+		/*
+		 * We need to ensure that the page cache pages are written to
+		 * disk and invalidated to preserve the expected O_DIRECT
+		 * semantics.
+		 */
+		endbyte = *ppos + written_buffered - written - 1;
+		ret = filemap_write_and_wait_range(file->f_mapping, *ppos,
+				endbyte);
+		if (ret == 0) {
+			written = written_buffered;
+			invalidate_mapping_pages(mapping,
+					*ppos >> PAGE_CACHE_SHIFT,
+					endbyte >> PAGE_CACHE_SHIFT);
+		} else {
+			/*
+			 * We don't know how much we wrote, so just return
+			 * the number of bytes which were direct-written
+			 */
+		}
 	} else {
 		current->backing_dev_info = file->f_mapping->backing_dev_info;
 		written = generic_perform_write(file, from, *ppos);
_

Patches currently in -mm which might be from wangww631@huawei.com are

ocfs2-do-not-fallback-to-buffer-i-o-write-if-fill-holes-checkpatch-fixes.patch

