From: akpm@linux-foundation.org
Subject: + ocfs2-use-oi-instead-of-ocfs2_i.patch added to -mm tree
Date: Thu, 08 Feb 2018 16:14:05 -0800
Message-ID: <5a7ce7cd.KtK4xe38GdY3LWMm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38080 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752056AbeBIAOG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 8 Feb 2018 19:14:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: piaojun@huawei.com, akpm@linux-foundation.org, alex.chen@huawei.com, ge.changwei@h3c.com, jiangqi903@gmail.com, jiangyiwen@huawei.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: use 'oi' instead of 'OCFS2_I()'
has been added to the -mm tree.  Its filename is
     ocfs2-use-oi-instead-of-ocfs2_i.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-use-oi-instead-of-ocfs2_i.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-use-oi-instead-of-ocfs2_i.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: piaojun <piaojun@huawei.com>
Subject: ocfs2: use 'oi' instead of 'OCFS2_I()'

We could use 'oi' instead of 'OCFS2_I()' to make code more elegant.

Link: http://lkml.kernel.org/r/5A7020FE.5050906@huawei.com
Signed-off-by: Jun Piao <piaojun@huawei.com>
Reviewed-by: Yiwen Jiang <jiangyiwen@huawei.com>
Reviewed-by: Alex Chen <alex.chen@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <ge.changwei@h3c.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c        |    2 +-
 fs/ocfs2/aops.c         |    2 +-
 fs/ocfs2/file.c         |    6 +++---
 fs/ocfs2/inode.c        |    2 +-
 fs/ocfs2/namei.c        |    6 +++---
 fs/ocfs2/refcounttree.c |    6 +++---
 6 files changed, 12 insertions(+), 12 deletions(-)

diff -puN fs/ocfs2/alloc.c~ocfs2-use-oi-instead-of-ocfs2_i fs/ocfs2/alloc.c
--- a/fs/ocfs2/alloc.c~ocfs2-use-oi-instead-of-ocfs2_i
+++ a/fs/ocfs2/alloc.c
@@ -7119,7 +7119,7 @@ int ocfs2_convert_inline_data_to_extents
 			goto out_commit;
 		did_quota = 1;
 
-		data_ac->ac_resv = &OCFS2_I(inode)->ip_la_data_resv;
+		data_ac->ac_resv = &oi->ip_la_data_resv;
 
 		ret = ocfs2_claim_clusters(handle, data_ac, 1, &bit_off,
 					   &num);
diff -puN fs/ocfs2/aops.c~ocfs2-use-oi-instead-of-ocfs2_i fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-use-oi-instead-of-ocfs2_i
+++ a/fs/ocfs2/aops.c
@@ -346,7 +346,7 @@ static int ocfs2_readpage(struct file *f
 	unlock = 0;
 
 out_alloc:
-	up_read(&OCFS2_I(inode)->ip_alloc_sem);
+	up_read(&oi->ip_alloc_sem);
 out_inode_unlock:
 	ocfs2_inode_unlock(inode, 0);
 out:
diff -puN fs/ocfs2/file.c~ocfs2-use-oi-instead-of-ocfs2_i fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-use-oi-instead-of-ocfs2_i
+++ a/fs/ocfs2/file.c
@@ -101,7 +101,7 @@ static int ocfs2_file_open(struct inode
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 
 	trace_ocfs2_file_open(inode, file, file->f_path.dentry,
-			      (unsigned long long)OCFS2_I(inode)->ip_blkno,
+			      (unsigned long long)oi->ip_blkno,
 			      file->f_path.dentry->d_name.len,
 			      file->f_path.dentry->d_name.name, mode);
 
@@ -116,7 +116,7 @@ static int ocfs2_file_open(struct inode
 	/* Check that the inode hasn't been wiped from disk by another
 	 * node. If it hasn't then we're safe as long as we hold the
 	 * spin lock until our increment of open count. */
-	if (OCFS2_I(inode)->ip_flags & OCFS2_INODE_DELETED) {
+	if (oi->ip_flags & OCFS2_INODE_DELETED) {
 		spin_unlock(&oi->ip_lock);
 
 		status = -ENOENT;
@@ -190,7 +190,7 @@ static int ocfs2_sync_file(struct file *
 	bool needs_barrier = false;
 
 	trace_ocfs2_sync_file(inode, file, file->f_path.dentry,
-			      OCFS2_I(inode)->ip_blkno,
+			      oi->ip_blkno,
 			      file->f_path.dentry->d_name.len,
 			      file->f_path.dentry->d_name.name,
 			      (unsigned long long)datasync);
diff -puN fs/ocfs2/inode.c~ocfs2-use-oi-instead-of-ocfs2_i fs/ocfs2/inode.c
--- a/fs/ocfs2/inode.c~ocfs2-use-oi-instead-of-ocfs2_i
+++ a/fs/ocfs2/inode.c
@@ -1160,7 +1160,7 @@ static void ocfs2_clear_inode(struct ino
 	 * exception here are successfully wiped inodes - their
 	 * metadata can now be considered to be part of the system
 	 * inodes from which it came. */
-	if (!(OCFS2_I(inode)->ip_flags & OCFS2_INODE_DELETED))
+	if (!(oi->ip_flags & OCFS2_INODE_DELETED))
 		ocfs2_checkpoint_inode(inode);
 
 	mlog_bug_on_msg(!list_empty(&oi->ip_io_markers),
diff -puN fs/ocfs2/namei.c~ocfs2-use-oi-instead-of-ocfs2_i fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-use-oi-instead-of-ocfs2_i
+++ a/fs/ocfs2/namei.c
@@ -525,7 +525,7 @@ static int __ocfs2_mknod_locked(struct i
 	 * these are used by the support functions here and in
 	 * callers. */
 	inode->i_ino = ino_from_blkno(osb->sb, fe_blkno);
-	OCFS2_I(inode)->ip_blkno = fe_blkno;
+	oi->ip_blkno = fe_blkno;
 	spin_lock(&osb->osb_lock);
 	inode->i_generation = osb->s_next_generation++;
 	spin_unlock(&osb->osb_lock);
@@ -1186,8 +1186,8 @@ static int ocfs2_double_lock(struct ocfs
 	}
 
 	trace_ocfs2_double_lock_end(
-			(unsigned long long)OCFS2_I(inode1)->ip_blkno,
-			(unsigned long long)OCFS2_I(inode2)->ip_blkno);
+			(unsigned long long)oi1->ip_blkno,
+			(unsigned long long)oi2->ip_blkno);
 
 bail:
 	if (status)
diff -puN fs/ocfs2/refcounttree.c~ocfs2-use-oi-instead-of-ocfs2_i fs/ocfs2/refcounttree.c
--- a/fs/ocfs2/refcounttree.c~ocfs2-use-oi-instead-of-ocfs2_i
+++ a/fs/ocfs2/refcounttree.c
@@ -573,7 +573,7 @@ static int ocfs2_create_refcount_tree(st
 	BUG_ON(ocfs2_is_refcount_inode(inode));
 
 	trace_ocfs2_create_refcount_tree(
-		(unsigned long long)OCFS2_I(inode)->ip_blkno);
+		(unsigned long long)oi->ip_blkno);
 
 	ret = ocfs2_reserve_new_metadata_blocks(osb, 1, &meta_ac);
 	if (ret) {
@@ -4766,8 +4766,8 @@ static int ocfs2_reflink_inodes_lock(str
 		*bh2 = *bh1;
 
 	trace_ocfs2_double_lock_end(
-			(unsigned long long)OCFS2_I(inode1)->ip_blkno,
-			(unsigned long long)OCFS2_I(inode2)->ip_blkno);
+			(unsigned long long)oi1->ip_blkno,
+			(unsigned long long)oi2->ip_blkno);
 
 	return 0;
 
_

Patches currently in -mm which might be from piaojun@huawei.com are

ocfs2-use-osb-instead-of-ocfs2_sb.patch
ocfs2-use-oi-instead-of-ocfs2_i.patch

