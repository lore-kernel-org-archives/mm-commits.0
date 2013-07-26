From: akpm@linux-foundation.org
Subject: + ocfs2-using-i_size_read-to-access-i_size.patch added to -mm
 tree
Date: Fri, 26 Jul 2013 15:12:01 -0700
Message-ID: <51f2f431.LtSF6F4HOHuE2CVH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52096 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757675Ab3GZWMC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 26 Jul 2013 18:12:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com, junxiao.bi@oracle.com

Subject: + ocfs2-using-i_size_read-to-access-i_size.patch added to -mm tree
To: junxiao.bi@oracle.com,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Fri, 26 Jul 2013 15:12:01 -0700


The patch titled
     Subject: ocfs2: use i_size_read() to access i_size
has been added to the -mm tree.  Its filename is
     ocfs2-using-i_size_read-to-access-i_size.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-using-i_size_read-to-access-i_size.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-using-i_size_read-to-access-i_size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: ocfs2: use i_size_read() to access i_size

Though ocfs2 uses inode->i_mutex to protect i_size, there are both
i_size_read/write() and direct accesses.  Clean up all direct access to
eliminate confusion.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Jie Liu <jeff.liu@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c         |    2 +-
 fs/ocfs2/extent_map.c   |   10 +++++-----
 fs/ocfs2/ioctl.c        |    2 +-
 fs/ocfs2/journal.c      |    8 ++++----
 fs/ocfs2/move_extents.c |    2 +-
 fs/ocfs2/quota_global.c |    6 +++---
 fs/ocfs2/quota_local.c  |   12 ++++++------
 7 files changed, 21 insertions(+), 21 deletions(-)

diff -puN fs/ocfs2/aops.c~ocfs2-using-i_size_read-to-access-i_size fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-using-i_size_read-to-access-i_size
+++ a/fs/ocfs2/aops.c
@@ -2050,7 +2050,7 @@ int ocfs2_write_end_nolock(struct addres
 
 out_write_size:
 	pos += copied;
-	if (pos > inode->i_size) {
+	if (pos > i_size_read(inode)) {
 		i_size_write(inode, pos);
 		mark_inode_dirty(inode);
 	}
diff -puN fs/ocfs2/extent_map.c~ocfs2-using-i_size_read-to-access-i_size fs/ocfs2/extent_map.c
--- a/fs/ocfs2/extent_map.c~ocfs2-using-i_size_read-to-access-i_size
+++ a/fs/ocfs2/extent_map.c
@@ -852,20 +852,20 @@ int ocfs2_seek_data_hole_offset(struct f
 
 	down_read(&OCFS2_I(inode)->ip_alloc_sem);
 
-	if (*offset >= inode->i_size) {
+	if (*offset >= i_size_read(inode)) {
 		ret = -ENXIO;
 		goto out_unlock;
 	}
 
 	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
 		if (whence == SEEK_HOLE)
-			*offset = inode->i_size;
+			*offset = i_size_read(inode);
 		goto out_unlock;
 	}
 
 	clen = 0;
 	cpos = *offset >> cs_bits;
-	cend = ocfs2_clusters_for_bytes(inode->i_sb, inode->i_size);
+	cend = ocfs2_clusters_for_bytes(inode->i_sb, i_size_read(inode));
 
 	while (cpos < cend && !is_last) {
 		ret = ocfs2_get_clusters_nocache(inode, di_bh, cpos, &hole_size,
@@ -904,8 +904,8 @@ int ocfs2_seek_data_hole_offset(struct f
 		extlen = clen;
 		extlen <<=  cs_bits;
 
-		if ((extoff + extlen) > inode->i_size)
-			extlen = inode->i_size - extoff;
+		if ((extoff + extlen) > i_size_read(inode))
+			extlen = i_size_read(inode) - extoff;
 		extoff += extlen;
 		if (extoff > *offset)
 			*offset = extoff;
diff -puN fs/ocfs2/ioctl.c~ocfs2-using-i_size_read-to-access-i_size fs/ocfs2/ioctl.c
--- a/fs/ocfs2/ioctl.c~ocfs2-using-i_size_read-to-access-i_size
+++ a/fs/ocfs2/ioctl.c
@@ -303,7 +303,7 @@ int ocfs2_info_handle_journal_size(struc
 	if (o2info_from_user(oij, req))
 		goto bail;
 
-	oij.ij_journal_size = osb->journal->j_inode->i_size;
+	oij.ij_journal_size = i_size_read(osb->journal->j_inode);
 
 	o2info_set_request_filled(&oij.ij_req);
 
diff -puN fs/ocfs2/journal.c~ocfs2-using-i_size_read-to-access-i_size fs/ocfs2/journal.c
--- a/fs/ocfs2/journal.c~ocfs2-using-i_size_read-to-access-i_size
+++ a/fs/ocfs2/journal.c
@@ -836,14 +836,14 @@ int ocfs2_journal_init(struct ocfs2_jour
 	inode_lock = 1;
 	di = (struct ocfs2_dinode *)bh->b_data;
 
-	if (inode->i_size <  OCFS2_MIN_JOURNAL_SIZE) {
+	if (i_size_read(inode) <  OCFS2_MIN_JOURNAL_SIZE) {
 		mlog(ML_ERROR, "Journal file size (%lld) is too small!\n",
-		     inode->i_size);
+		     i_size_read(inode));
 		status = -EINVAL;
 		goto done;
 	}
 
-	trace_ocfs2_journal_init(inode->i_size,
+	trace_ocfs2_journal_init(i_size_read(inode),
 				 (unsigned long long)inode->i_blocks,
 				 OCFS2_I(inode)->ip_clusters);
 
@@ -1131,7 +1131,7 @@ static int ocfs2_force_read_journal(stru
 
 	memset(bhs, 0, sizeof(struct buffer_head *) * CONCURRENT_JOURNAL_FILL);
 
-	num_blocks = ocfs2_blocks_for_bytes(inode->i_sb, inode->i_size);
+	num_blocks = ocfs2_blocks_for_bytes(inode->i_sb, i_size_read(inode));
 	v_blkno = 0;
 	while (v_blkno < num_blocks) {
 		status = ocfs2_extent_map_get_blocks(inode, v_blkno,
diff -puN fs/ocfs2/move_extents.c~ocfs2-using-i_size_read-to-access-i_size fs/ocfs2/move_extents.c
--- a/fs/ocfs2/move_extents.c~ocfs2-using-i_size_read-to-access-i_size
+++ a/fs/ocfs2/move_extents.c
@@ -845,7 +845,7 @@ static int __ocfs2_move_extents_range(st
 	struct ocfs2_move_extents *range = context->range;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
-	if ((inode->i_size == 0) || (range->me_len == 0))
+	if ((i_size_read(inode) == 0) || (range->me_len == 0))
 		return 0;
 
 	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
diff -puN fs/ocfs2/quota_global.c~ocfs2-using-i_size_read-to-access-i_size fs/ocfs2/quota_global.c
--- a/fs/ocfs2/quota_global.c~ocfs2-using-i_size_read-to-access-i_size
+++ a/fs/ocfs2/quota_global.c
@@ -234,7 +234,7 @@ ssize_t ocfs2_quota_write(struct super_b
 		len = sb->s_blocksize - OCFS2_QBLK_RESERVED_SPACE - offset;
 	}
 
-	if (gqinode->i_size < off + len) {
+	if (i_size_read(gqinode) < off + len) {
 		loff_t rounded_end =
 				ocfs2_align_bytes_to_blocks(sb, off + len);
 
@@ -778,8 +778,8 @@ static int ocfs2_acquire_dquot(struct dq
 		 */
 		WARN_ON(journal_current_handle());
 		status = ocfs2_extend_no_holes(gqinode, NULL,
-			gqinode->i_size + (need_alloc << sb->s_blocksize_bits),
-			gqinode->i_size);
+			i_size_read(gqinode) + (need_alloc << sb->s_blocksize_bits),
+			i_size_read(gqinode));
 		if (status < 0)
 			goto out_dq;
 	}
diff -puN fs/ocfs2/quota_local.c~ocfs2-using-i_size_read-to-access-i_size fs/ocfs2/quota_local.c
--- a/fs/ocfs2/quota_local.c~ocfs2-using-i_size_read-to-access-i_size
+++ a/fs/ocfs2/quota_local.c
@@ -982,14 +982,14 @@ static struct ocfs2_quota_chunk *ocfs2_l
 
 	/* We are protected by dqio_sem so no locking needed */
 	status = ocfs2_extend_no_holes(lqinode, NULL,
-				       lqinode->i_size + 2 * sb->s_blocksize,
-				       lqinode->i_size);
+				       i_size_read(lqinode) + 2 * sb->s_blocksize,
+				       i_size_read(lqinode));
 	if (status < 0) {
 		mlog_errno(status);
 		goto out;
 	}
 	status = ocfs2_simple_size_update(lqinode, oinfo->dqi_lqi_bh,
-					  lqinode->i_size + 2 * sb->s_blocksize);
+					  i_size_read(lqinode) + 2 * sb->s_blocksize);
 	if (status < 0) {
 		mlog_errno(status);
 		goto out;
@@ -1125,14 +1125,14 @@ static struct ocfs2_quota_chunk *ocfs2_e
 
 	/* We are protected by dqio_sem so no locking needed */
 	status = ocfs2_extend_no_holes(lqinode, NULL,
-				       lqinode->i_size + sb->s_blocksize,
-				       lqinode->i_size);
+				       i_size_read(lqinode) + sb->s_blocksize,
+				       i_size_read(lqinode));
 	if (status < 0) {
 		mlog_errno(status);
 		goto out;
 	}
 	status = ocfs2_simple_size_update(lqinode, oinfo->dqi_lqi_bh,
-					  lqinode->i_size + sb->s_blocksize);
+					  i_size_read(lqinode) + sb->s_blocksize);
 	if (status < 0) {
 		mlog_errno(status);
 		goto out;
_

Patches currently in -mm which might be from junxiao.bi@oracle.com are

ocfs2-update-inode-size-after-zeronig-the-hole.patch
ocfs2-using-i_size_read-to-access-i_size.patch
linux-next.patch

