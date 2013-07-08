From: akpm@linux-foundation.org
Subject: [merged] ocfs2-fix-readonly-issue-in-ocfs2_unlink.patch removed
 from -mm tree
Date: Mon, 08 Jul 2013 12:23:26 -0700
Message-ID: <51db11ae.bXWB/pVRzqSdZKqX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50026 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab3GHTX1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:23:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sunil.mushran@gmail.com, shencanquan@huawei.com, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com, younger.liu@huawei.com

Subject: [merged] ocfs2-fix-readonly-issue-in-ocfs2_unlink.patch removed from -mm tree
To: younger.liu@huawei.com,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,shencanquan@huawei.com,sunil.mushran@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:23:26 -0700


The patch titled
     Subject: ocfs2: fix readonly issue in ocfs2_unlink()
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-readonly-issue-in-ocfs2_unlink.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Younger Liu <younger.liu@huawei.com>
Subject: ocfs2: fix readonly issue in ocfs2_unlink()

While deleting a file with ocfs2_unlink(), there is a bug in this
function.  This bug will result in filesystem read-only.

After calling ocfs2_orphan_add(), the file which will be deleted is added
into orphan dir.  If ocfs2_delete_entry() fails, the file still exists in
the parent dir.  And this scenario introduces a conflict of metadata.

If a file is added into orphan dir, when we put inode of the file with
iput(), the inode i_flags is setted (~OCFS2_VALID_FL) in
ocfs2_remove_inode(), and then write back to disk.

But as previously mentioned, the file still exists in the parent dir.  On
other nodes, the file can be still accessed.  When first read the file
with ocfs2_read_blocks() from disk, It will check and avalidate inode
using ocfs2_validate_inode_block().  So File system will be readonly
because the inode is invalid.  In other words, the inode i_flags has been
set (~OCFS2_VALID_FL).

[akpm@linux-foundation.org: cleanups]
[jeff.liu@oracle.com: s/inode_is_unlinkable/ocfs2_inode_is_unlinkable/]
Signed-off-by: Younger Liu <younger.liu@huawei.com>
Signed-off-by: Jensen <shencanquan@huawei.com>
Cc: Jie Liu <jeff.liu@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Sunil Mushran <sunil.mushran@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff -puN fs/ocfs2/namei.c~ocfs2-fix-readonly-issue-in-ocfs2_unlink fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-fix-readonly-issue-in-ocfs2_unlink
+++ a/fs/ocfs2/namei.c
@@ -773,7 +773,7 @@ static int ocfs2_remote_dentry_delete(st
 	return ret;
 }
 
-static inline int inode_is_unlinkable(struct inode *inode)
+static inline int ocfs2_inode_is_unlinkable(struct inode *inode)
 {
 	if (S_ISDIR(inode->i_mode)) {
 		if (inode->i_nlink == 2)
@@ -791,6 +791,7 @@ static int ocfs2_unlink(struct inode *di
 {
 	int status;
 	int child_locked = 0;
+	bool is_unlinkable = false;
 	struct inode *inode = dentry->d_inode;
 	struct inode *orphan_dir = NULL;
 	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
@@ -865,7 +866,7 @@ static int ocfs2_unlink(struct inode *di
 		goto leave;
 	}
 
-	if (inode_is_unlinkable(inode)) {
+	if (ocfs2_inode_is_unlinkable(inode)) {
 		status = ocfs2_prepare_orphan_dir(osb, &orphan_dir,
 						  OCFS2_I(inode)->ip_blkno,
 						  orphan_name, &orphan_insert);
@@ -873,6 +874,7 @@ static int ocfs2_unlink(struct inode *di
 			mlog_errno(status);
 			goto leave;
 		}
+		is_unlinkable = true;
 	}
 
 	handle = ocfs2_start_trans(osb, ocfs2_unlink_credits(osb->sb));
@@ -892,15 +894,6 @@ static int ocfs2_unlink(struct inode *di
 
 	fe = (struct ocfs2_dinode *) fe_bh->b_data;
 
-	if (inode_is_unlinkable(inode)) {
-		status = ocfs2_orphan_add(osb, handle, inode, fe_bh, orphan_name,
-					  &orphan_insert, orphan_dir);
-		if (status < 0) {
-			mlog_errno(status);
-			goto leave;
-		}
-	}
-
 	/* delete the name from the parent dir */
 	status = ocfs2_delete_entry(handle, dir, &lookup);
 	if (status < 0) {
@@ -923,6 +916,14 @@ static int ocfs2_unlink(struct inode *di
 		mlog_errno(status);
 		if (S_ISDIR(inode->i_mode))
 			inc_nlink(dir);
+		goto leave;
+	}
+
+	if (is_unlinkable) {
+		status = ocfs2_orphan_add(osb, handle, inode, fe_bh,
+				orphan_name, &orphan_insert, orphan_dir);
+		if (status < 0)
+			mlog_errno(status);
 	}
 
 leave:
_

Patches currently in -mm which might be from younger.liu@huawei.com are

origin.patch
ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del.patch
ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size.patch
ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size-v2.patch

