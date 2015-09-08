From: akpm@linux-foundation.org
Subject: [merged] ocfs2-adjust-code-to-match-locking-unlocking-order.patch removed from -mm tree
Date: Tue, 08 Sep 2015 11:02:08 -0700
Message-ID: <55ef22a0.Hhc11tROlluysj0e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58765 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbbIHSCI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:02:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: adjust code to match locking/unlocking order
has been removed from the -mm tree.  Its filename was
     ocfs2-adjust-code-to-match-locking-unlocking-order.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: adjust code to match locking/unlocking order

Unlocking order in ocfs2_unlink and ocfs2_rename mismatches the
corresponding locking order, although it won't cause issues, adjust the
code so that it looks more reasonable.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff -puN fs/ocfs2/namei.c~ocfs2-adjust-code-to-match-locking-unlocking-order fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-adjust-code-to-match-locking-unlocking-order
+++ a/fs/ocfs2/namei.c
@@ -1035,11 +1035,6 @@ leave:
 	if (handle)
 		ocfs2_commit_trans(osb, handle);
 
-	if (child_locked)
-		ocfs2_inode_unlock(inode, 1);
-
-	ocfs2_inode_unlock(dir, 1);
-
 	if (orphan_dir) {
 		/* This was locked for us in ocfs2_prepare_orphan_dir() */
 		ocfs2_inode_unlock(orphan_dir, 1);
@@ -1047,6 +1042,11 @@ leave:
 		iput(orphan_dir);
 	}
 
+	if (child_locked)
+		ocfs2_inode_unlock(inode, 1);
+
+	ocfs2_inode_unlock(dir, 1);
+
 	brelse(fe_bh);
 	brelse(parent_node_bh);
 
@@ -1633,21 +1633,9 @@ static int ocfs2_rename(struct inode *ol
 	ocfs2_dentry_move(old_dentry, new_dentry, old_dir, new_dir);
 	status = 0;
 bail:
-	if (rename_lock)
-		ocfs2_rename_unlock(osb);
-
 	if (handle)
 		ocfs2_commit_trans(osb, handle);
 
-	if (parents_locked)
-		ocfs2_double_unlock(old_dir, new_dir);
-
-	if (old_child_locked)
-		ocfs2_inode_unlock(old_inode, 1);
-
-	if (new_child_locked)
-		ocfs2_inode_unlock(new_inode, 1);
-
 	if (orphan_dir) {
 		/* This was locked for us in ocfs2_prepare_orphan_dir() */
 		ocfs2_inode_unlock(orphan_dir, 1);
@@ -1655,6 +1643,18 @@ bail:
 		iput(orphan_dir);
 	}
 
+	if (new_child_locked)
+		ocfs2_inode_unlock(new_inode, 1);
+
+	if (old_child_locked)
+		ocfs2_inode_unlock(old_inode, 1);
+
+	if (parents_locked)
+		ocfs2_double_unlock(old_dir, new_dir);
+
+	if (rename_lock)
+		ocfs2_rename_unlock(osb);
+
 	if (new_inode)
 		sync_mapping_buffers(old_inode->i_mapping);
 
_

Patches currently in -mm which might be from joseph.qi@huawei.com are


