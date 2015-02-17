From: akpm@linux-foundation.org
Subject: [merged] ocfs2-complete-the-rest-request-through-buffer-io.patch
 removed from -mm tree
Date: Tue, 17 Feb 2015 12:06:28 -0800
Message-ID: <54e39f44.MoTbehPV/mT2JQmA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35353 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbbBQUG3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Feb 2015 15:06:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, alex.chen@huawei.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@suse.com, wangww631@huawei.com, xuejiufei@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: complete the rest request through buffer io
has been removed from the -mm tree.  Its filename was
     ocfs2-complete-the-rest-request-through-buffer-io.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: complete the rest request through buffer io

Complte the rest request thourgh buffer io after direct write performed.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Weiwei Wang <wangww631@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Xuejiufei <xuejiufei@huawei.com>
Cc: alex chen <alex.chen@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |   43 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/file.c~ocfs2-complete-the-rest-request-through-buffer-io fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-complete-the-rest-request-through-buffer-io
+++ a/fs/ocfs2/file.c
@@ -2253,6 +2253,7 @@ static ssize_t ocfs2_file_write_iter(str
 	u32 old_clusters;
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(file);
+	struct address_space *mapping = file->f_mapping;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	int full_coherency = !(osb->s_mount_opt &
 			       OCFS2_MOUNT_COHERENCY_BUFFERED);
@@ -2367,11 +2368,51 @@ relock:
 
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
+
+		/*
+		 * for completing the rest of the request.
+		 */
+		*ppos += written;
+		count -= written;
+		written_buffered = generic_perform_write(file, from, *ppos);
+		/*
+		 * If generic_file_buffered_write() returned a synchronous error
+		 * then we want to return the number of bytes which were
+		 * direct-written, or the error code if that was zero. Note
+		 * that this differs from normal direct-io semantics, which
+		 * will return -EFOO even if some bytes were written.
+		 */
+		if (written_buffered < 0) {
+			ret = written_buffered;
+			goto out_dio;
+		}
+
+		iocb->ki_pos = *ppos + written_buffered;
+		/* We need to ensure that the page cache pages are written to
+		 * disk and invalidated to preserve the expected O_DIRECT
+		 * semantics.
+		 */
+		endbyte = *ppos + written_buffered - 1;
+		ret = filemap_write_and_wait_range(file->f_mapping, *ppos,
+				endbyte);
+		if (ret == 0) {
+			written += written_buffered;
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
 		current->backing_dev_info = inode_to_bdi(inode);
 		written = generic_perform_write(file, from, *ppos);
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

origin.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages-v3.patch

