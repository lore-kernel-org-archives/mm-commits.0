From: akpm@linux-foundation.org
Subject: + ocfs2-do-not-fallback-to-buffer-i-o-write-if-fill-holes.patch
 added to -mm tree
Date: Tue, 23 Sep 2014 15:15:22 -0700
Message-ID: <5421f0fa.yVjaY9df0gGUDFuq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38412 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756950AbaIWWPX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Sep 2014 18:15:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wangww631@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: do not fallback to buffer I/O write if filling holes
has been added to the -mm tree.  Its filename is
     ocfs2-do-not-fallback-to-buffer-i-o-write-if-fill-holes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-do-not-fallback-to-buffer-i-o-write-if-fill-holes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-do-not-fallback-to-buffer-i-o-write-if-fill-holes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: WeiWei Wang <wangww631@huawei.com>
Subject: ocfs2: do not fallback to buffer I/O write if filling holes

In this commit, direct-io to a hole will go direct-io first, then fall
through to buffered I/O for completing the rest of the request.

Signed-off-by: Weiwei Wang <wangww631@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |   87 +++++++++++++++++++---------------------------
 1 file changed, 36 insertions(+), 51 deletions(-)

diff -puN fs/ocfs2/file.c~ocfs2-do-not-fallback-to-buffer-i-o-write-if-fill-holes fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-do-not-fallback-to-buffer-i-o-write-if-fill-holes
+++ a/fs/ocfs2/file.c
@@ -1349,44 +1349,6 @@ out:
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
@@ -2187,19 +2149,6 @@ static int ocfs2_prepare_inode_for_write
 			*direct_io = 0;
 			break;
 		}
-
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
 
@@ -2229,6 +2178,7 @@ static ssize_t ocfs2_file_write_iter(str
 	u32 old_clusters;
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(file);
+	struct address_space *mapping = file->f_mapping;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	int full_coherency = !(osb->s_mount_opt &
 			       OCFS2_MOUNT_COHERENCY_BUFFERED);
@@ -2343,11 +2293,46 @@ relock:
 
 	iov_iter_truncate(from, count);
 	if (direct_io) {
+		loff_t endbyte;
+		ssize_t written_buffered;
 		written = generic_file_direct_write(iocb, from, *ppos);
 		if (written < 0) {
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
+						   endbyte);
+		if (ret == 0) {
+			written = written_buffered;
+			invalidate_mapping_pages(mapping,
+						 *ppos >> PAGE_CACHE_SHIFT,
+						 endbyte >> PAGE_CACHE_SHIFT);
+		}
 	} else {
 		current->backing_dev_info = file->f_mapping->backing_dev_info;
 		written = generic_perform_write(file, from, *ppos);
_

Patches currently in -mm which might be from wangww631@huawei.com are

ocfs2-eliminate-the-static-flag-of-some-functions.patch
ocfs2-add-two-functions-of-add-and-remove-inode-in-orphan-dir.patch
ocfs2-add-orphan-recovery-types-in-ocfs2_recover_orphans.patch
ocfs2-add-and-remove-inode-in-orphan-dir-in-ocfs2_direct_io.patch
ocfs2-allocate-blocks-in-ocfs2_direct_io_get_blocks.patch
ocfs2-do-not-fallback-to-buffer-i-o-write-if-appending.patch
ocfs2-do-not-fallback-to-buffer-i-o-write-if-fill-holes.patch

