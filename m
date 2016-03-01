From: akpm@linux-foundation.org
Subject: + ocfs2-check-fix-inode-block-for-online-file-check-v4.patch
 added to -mm tree
Date: Mon, 29 Feb 2016 16:05:19 -0800
Message-ID: <56d4dcbf.RLvDETyjRBGv/MY5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49466 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbcCAAFU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Feb 2016 19:05:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ghe@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-check-fix-inode-block-for-online-file-check-v4
has been added to the -mm tree.  Its filename is
     ocfs2-check-fix-inode-block-for-online-file-check-v4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-check-fix-inode-block-for-online-file-check-v4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-check-fix-inode-block-for-online-file-check-v4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gang He <ghe@suse.com>
Subject: ocfs2-check-fix-inode-block-for-online-file-check-v4

Signed-off-by: Gang He <ghe@suse.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.c |   31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

diff -puN fs/ocfs2/inode.c~ocfs2-check-fix-inode-block-for-online-file-check-v4 fs/ocfs2/inode.c
--- a/fs/ocfs2/inode.c~ocfs2-check-fix-inode-block-for-online-file-check-v4
+++ a/fs/ocfs2/inode.c
@@ -425,7 +425,7 @@ static int ocfs2_read_locked_inode(struc
 	struct ocfs2_super *osb;
 	struct ocfs2_dinode *fe;
 	struct buffer_head *bh = NULL;
-	int status, can_lock;
+	int status, can_lock, lock_level = 0;
 	u32 generation = 0;
 
 	status = -EINVAL;
@@ -493,7 +493,7 @@ static int ocfs2_read_locked_inode(struc
 			mlog_errno(status);
 			return status;
 		}
-		status = ocfs2_inode_lock(inode, NULL, 0);
+		status = ocfs2_inode_lock(inode, NULL, lock_level);
 		if (status) {
 			make_bad_inode(inode);
 			mlog_errno(status);
@@ -563,7 +563,12 @@ static int ocfs2_read_locked_inode(struc
 
 	BUG_ON(args->fi_blkno != le64_to_cpu(fe->i_blkno));
 
-	if (buffer_dirty(bh)) {
+	if (buffer_dirty(bh) && !buffer_jbd(bh)) {
+		if (can_lock) {
+			ocfs2_inode_unlock(inode, lock_level);
+			lock_level = 1;
+			ocfs2_inode_lock(inode, NULL, lock_level);
+		}
 		status = ocfs2_write_block(osb, bh, INODE_CACHE(inode));
 		if (status < 0) {
 			mlog_errno(status);
@@ -575,7 +580,7 @@ static int ocfs2_read_locked_inode(struc
 
 bail:
 	if (can_lock)
-		ocfs2_inode_unlock(inode, 0);
+		ocfs2_inode_unlock(inode, lock_level);
 
 	if (status < 0)
 		make_bad_inode(inode);
@@ -1450,13 +1455,18 @@ static int ocfs2_filecheck_validate_inod
 
 	BUG_ON(!buffer_uptodate(bh));
 
+	/*
+	 * Call ocfs2_validate_meta_ecc() first since it has ecc repair
+	 * function, but we should not return error immediately when ecc
+	 * validation fails, because the reason is quite likely the invalid
+	 * inode number inputed.
+	 */
 	rc = ocfs2_validate_meta_ecc(sb, bh->b_data, &di->i_check);
 	if (rc) {
 		mlog(ML_ERROR,
 		     "Filecheck: checksum failed for dinode %llu\n",
 		     (unsigned long long)bh->b_blocknr);
 		rc = -OCFS2_FILECHECK_ERR_BLOCKECC;
-		goto bail;
 	}
 
 	if (!OCFS2_IS_VALID_DINODE(di)) {
@@ -1465,7 +1475,8 @@ static int ocfs2_filecheck_validate_inod
 		     (unsigned long long)bh->b_blocknr, 7, di->i_signature);
 		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
 		goto bail;
-	}
+	} else if (rc)
+		goto bail;
 
 	if (le64_to_cpu(di->i_blkno) != bh->b_blocknr) {
 		mlog(ML_ERROR,
@@ -1520,6 +1531,14 @@ static int ocfs2_filecheck_repair_inode_
 		return -OCFS2_FILECHECK_ERR_READONLY;
 	}
 
+	if (buffer_jbd(bh)) {
+		mlog(ML_ERROR,
+		     "Filecheck: cannot repair dinode #%llu, "
+		     "its buffer is in jbd\n",
+		     (unsigned long long)bh->b_blocknr);
+		return -OCFS2_FILECHECK_ERR_INJBD;
+	}
+
 	if (!OCFS2_IS_VALID_DINODE(di)) {
 		/* Cannot fix invalid inode block */
 		return -OCFS2_FILECHECK_ERR_INVALIDINO;
_

Patches currently in -mm which might be from ghe@suse.com are

ocfs2-export-ocfs2_kset-for-online-file-check.patch
ocfs2-sysfile-interfaces-for-online-file-check.patch
ocfs2-sysfile-interfaces-for-online-file-check-v4.patch
ocfs2-create-remove-sysfile-for-online-file-check.patch
ocfs2-check-fix-inode-block-for-online-file-check.patch
ocfs2-check-fix-inode-block-for-online-file-check-v4.patch
ocfs2-add-feature-document-for-online-file-check.patch

