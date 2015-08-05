From: akpm@linux-foundation.org
Subject: + ocfs2-adjust-code-to-match-locking-unlocking-order.patch added
 to -mm tree
Date: Wed, 05 Aug 2015 14:04:41 -0700
Message-ID: <55c27a69.+x4/E3Sp59/rocRx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38317 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690AbbHEVEm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Aug 2015 17:04:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: adjust code to match locking/unlocking order
has been added to the -mm tree.  Its filename is
     ocfs2-adjust-code-to-match-locking-unlocking-order.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-adjust-code-to-match-locking-unlocking-order.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-adjust-code-to-match-locking-unlocking-order.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1018,11 +1018,6 @@ leave:
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
@@ -1030,6 +1025,11 @@ leave:
 		iput(orphan_dir);
 	}
 
+	if (child_locked)
+		ocfs2_inode_unlock(inode, 1);
+
+	ocfs2_inode_unlock(dir, 1);
+
 	brelse(fe_bh);
 	brelse(parent_node_bh);
 
@@ -1608,21 +1608,9 @@ static int ocfs2_rename(struct inode *ol
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
@@ -1630,6 +1618,18 @@ bail:
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

ocfs2-fix-bug-in-ocfs2_downconvert_thread_do_work.patch
ocfs2-fix-bug-in-ocfs2_downconvert_thread_do_work-v2.patch
ocfs2-fix-shift-left-overflow.patch
ocfs2-fix-race-between-dio-and-recover-orphan.patch
ocfs2-fix-several-issues-of-append-dio.patch
ocfs2-do-not-bug-if-buffer-not-uptodate-in-__ocfs2_journal_access.patch
ocfs2-clean-up-unused-local-variables-in-ocfs2_file_write_iter.patch
ocfs2-adjust-code-to-match-locking-unlocking-order.patch
ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed.patch
ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed-v2.patch
ocfs2-fix-race-between-crashed-dio-and-rm.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch

