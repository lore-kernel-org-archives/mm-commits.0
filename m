From: akpm@linux-foundation.org
Subject: +
 ocfs2-take-ip_alloc_sem-in-ocfs2_dio_get_block-ocfs2_dio_end_io_write.patch added to -mm tree
Date: Mon, 23 Nov 2015 16:25:09 -0800
Message-ID: <5653ae65.IozK0bCG0kDFlwlE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57581 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbbKXAZK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Nov 2015 19:25:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ryan.ding@oracle.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: take ip_alloc_sem in ocfs2_dio_get_block & ocfs2_dio_end_io_write
has been added to the -mm tree.  Its filename is
     ocfs2-take-ip_alloc_sem-in-ocfs2_dio_get_block-ocfs2_dio_end_io_write.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-take-ip_alloc_sem-in-ocfs2_dio_get_block-ocfs2_dio_end_io_write.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-take-ip_alloc_sem-in-ocfs2_dio_get_block-ocfs2_dio_end_io_write.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ryan Ding <ryan.ding@oracle.com>
Subject: ocfs2: take ip_alloc_sem in ocfs2_dio_get_block & ocfs2_dio_end_io_write

Take ip_alloc_sem to prevent concurrent access to extent tree, which may
cause the extent tree in an unstable state.

Signed-off-by: Ryan Ding <ryan.ding@oracle.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff -puN fs/ocfs2/aops.c~ocfs2-take-ip_alloc_sem-in-ocfs2_dio_get_block-ocfs2_dio_end_io_write fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-take-ip_alloc_sem-in-ocfs2_dio_get_block-ocfs2_dio_end_io_write
+++ a/fs/ocfs2/aops.c
@@ -2151,6 +2151,7 @@ static int ocfs2_dio_get_block(struct in
 			       struct buffer_head *bh_result, int create)
 {
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	struct ocfs2_write_ctxt *wc;
 	struct ocfs2_write_cluster_desc *desc = NULL;
 	struct ocfs2_dio_write_ctxt *dwc = NULL;
@@ -2166,9 +2167,12 @@ static int ocfs2_dio_get_block(struct in
 	mlog(0, "get block of %lu at %llu:%u req %u\n",
 			inode->i_ino, pos, len, total_len);
 
+	down_read(&oi->ip_alloc_sem);
 	/* This is the fast path for re-write. */
 	ret = ocfs2_get_block(inode, iblock, bh_result, create);
 
+	up_read(&oi->ip_alloc_sem);
+
 	if (buffer_mapped(bh_result) &&
 	    !buffer_new(bh_result) &&
 	    ret == 0)
@@ -2206,6 +2210,8 @@ static int ocfs2_dio_get_block(struct in
 		goto out;
 	}
 
+	down_write(&oi->ip_alloc_sem);
+
 	if (first_get_block) {
 		if (ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb)))
 			ret = ocfs2_zero_tail(inode, di_bh, pos);
@@ -2259,6 +2265,7 @@ static int ocfs2_dio_get_block(struct in
 	BUG_ON(ret != len);
 	ret = 0;
 unlock:
+	up_write(&oi->ip_alloc_sem);
 	ocfs2_inode_unlock(inode, 1);
 	brelse(di_bh);
 out:
@@ -2275,6 +2282,7 @@ static void ocfs2_dio_end_io_write(struc
 	struct ocfs2_cached_dealloc_ctxt dealloc;
 	struct ocfs2_extent_tree et;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	struct ocfs2_unwritten_extent *ue = NULL;
 	struct buffer_head *di_bh = NULL;
 	struct ocfs2_dinode *di;
@@ -2293,12 +2301,6 @@ static void ocfs2_dio_end_io_write(struc
 	    !dwc->dw_orphaned)
 		goto out;
 
-	ret = ocfs2_inode_lock(inode, &di_bh, 1);
-	if (ret < 0) {
-		mlog_errno(ret);
-		goto out;
-	}
-
 	/* ocfs2_file_write_iter will get i_mutex, so we need not lock if we
 	 * are in that context. */
 	if (dwc->dw_writer_pid != task_pid_nr(current)) {
@@ -2306,6 +2308,14 @@ static void ocfs2_dio_end_io_write(struc
 		locked = 1;
 	}
 
+	ret = ocfs2_inode_lock(inode, &di_bh, 1);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	down_write(&oi->ip_alloc_sem);
+
 	/* Delete orphan before acquire i_mutex. */
 	if (dwc->dw_orphaned) {
 		BUG_ON(dwc->dw_writer_pid != task_pid_nr(current));
@@ -2359,6 +2369,7 @@ static void ocfs2_dio_end_io_write(struc
 commit:
 	ocfs2_commit_trans(osb, handle);
 unlock:
+	up_write(&oi->ip_alloc_sem);
 	ocfs2_inode_unlock(inode, 1);
 	brelse(di_bh);
 out:
_

Patches currently in -mm which might be from ryan.ding@oracle.com are

ocfs2-add-ocfs2_write_type_t-type-to-identify-the-caller-of-write.patch
ocfs2-use-c_new-to-indicate-newly-allocated-extents.patch
ocfs2-test-target-page-before-change-it.patch
ocfs2-do-not-change-i_size-in-write_end-for-direct-io.patch
ocfs2-return-the-physical-address-in-ocfs2_write_cluster.patch
ocfs2-record-unwritten-extents-when-populate-write-desc.patch
ocfs2-fix-sparse-file-data-ordering-issue-in-direct-io.patch
ocfs2-code-clean-up-for-direct-io.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue.patch
ocfs2-take-ip_alloc_sem-in-ocfs2_dio_get_block-ocfs2_dio_end_io_write.patch
ocfs2-fix-disk-file-size-and-memory-file-size-mismatch.patch
ocfs2-fix-a-deadlock-issue-in-ocfs2_dio_end_io_write.patch

