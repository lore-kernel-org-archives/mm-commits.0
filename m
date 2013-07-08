From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-rework-transaction-rollback-in-ocfs2_relink_block_group.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:23:22 -0700
Message-ID: <51db11aa.uIRXq2P/syUR0WIW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50014 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844Ab3GHTXX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:23:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, younger.liu@huawei.com, sunil.mushran@gmail.com, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com

Subject: [merged] ocfs2-rework-transaction-rollback-in-ocfs2_relink_block_group.patch removed from -mm tree
To: jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,sunil.mushran@gmail.com,younger.liu@huawei.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:23:22 -0700


The patch titled
     Subject: ocfs2: rework transaction rollback in ocfs2_relink_block_group()
has been removed from the -mm tree.  Its filename was
     ocfs2-rework-transaction-rollback-in-ocfs2_relink_block_group.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jie Liu <jeff.liu@oracle.com>
Subject: ocfs2: rework transaction rollback in ocfs2_relink_block_group()

In ocfs2_relink_block_group(), we roll back all those changes if notify
intent to modify buffers for metadata update failed even if the relevant
buffer has not yet been modified/got dirty at that point, that are not
quite right because of:

- None buffer has been modified/dirty if failed to call
  ocfs2_journal_access_gd() against the previous block group buffer
- Only the previous block group buffer has got dirty if failed to
  call ocfs2_journal_access_gd() against the block group buffer
- There is no need to roll back the change for file entry buffer at all

Those problems will not cause anything wrong but unnecessary.
This patch fix them and kill the useless bg_ptr variable as well.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Cc: Younger Liu <younger.liu@huawei.com>
Cc: Sunil Mushran <sunil.mushran@gmail.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/suballoc.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff -puN fs/ocfs2/suballoc.c~ocfs2-rework-transaction-rollback-in-ocfs2_relink_block_group fs/ocfs2/suballoc.c
--- a/fs/ocfs2/suballoc.c~ocfs2-rework-transaction-rollback-in-ocfs2_relink_block_group
+++ a/fs/ocfs2/suballoc.c
@@ -1422,7 +1422,7 @@ static int ocfs2_relink_block_group(hand
 	int status;
 	/* there is a really tiny chance the journal calls could fail,
 	 * but we wouldn't want inconsistent blocks in *any* case. */
-	u64 fe_ptr, bg_ptr, prev_bg_ptr;
+	u64 bg_ptr, prev_bg_ptr;
 	struct ocfs2_dinode *fe = (struct ocfs2_dinode *) fe_bh->b_data;
 	struct ocfs2_group_desc *bg = (struct ocfs2_group_desc *) bg_bh->b_data;
 	struct ocfs2_group_desc *prev_bg = (struct ocfs2_group_desc *) prev_bg_bh->b_data;
@@ -1437,7 +1437,6 @@ static int ocfs2_relink_block_group(hand
 		(unsigned long long)le64_to_cpu(bg->bg_blkno),
 		(unsigned long long)le64_to_cpu(prev_bg->bg_blkno));
 
-	fe_ptr = le64_to_cpu(fe->id2.i_chain.cl_recs[chain].c_blkno);
 	bg_ptr = le64_to_cpu(bg->bg_next_group);
 	prev_bg_ptr = le64_to_cpu(prev_bg->bg_next_group);
 
@@ -1446,7 +1445,7 @@ static int ocfs2_relink_block_group(hand
 					 OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
-		goto out_rollback;
+		goto out;
 	}
 
 	prev_bg->bg_next_group = bg->bg_next_group;
@@ -1456,7 +1455,7 @@ static int ocfs2_relink_block_group(hand
 					 bg_bh, OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
-		goto out_rollback;
+		goto out_rollback_prev_bg;
 	}
 
 	bg->bg_next_group = fe->id2.i_chain.cl_recs[chain].c_blkno;
@@ -1466,21 +1465,21 @@ static int ocfs2_relink_block_group(hand
 					 fe_bh, OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
-		goto out_rollback;
+		goto out_rollback_bg;
 	}
 
 	fe->id2.i_chain.cl_recs[chain].c_blkno = bg->bg_blkno;
 	ocfs2_journal_dirty(handle, fe_bh);
 
-out_rollback:
-	if (status < 0) {
-		fe->id2.i_chain.cl_recs[chain].c_blkno = cpu_to_le64(fe_ptr);
-		bg->bg_next_group = cpu_to_le64(bg_ptr);
-		prev_bg->bg_next_group = cpu_to_le64(prev_bg_ptr);
-	}
+out:
+	return status;
 
-	if (status)
-		mlog_errno(status);
+out_rollback_bg:
+	bg->bg_next_group = cpu_to_le64(bg_ptr);
+out_rollback_prev_bg:
+	prev_bg->bg_next_group = cpu_to_le64(prev_bg_ptr);
+
+	mlog_errno(status);
 	return status;
 }
 
_

Patches currently in -mm which might be from jeff.liu@oracle.com are

origin.patch
linux-next.patch
ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del.patch
ocfs2-llseek-requires-ocfs2-inode-lock-for-the-file-in-seek_end.patch
ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size.patch
ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size-v2.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch

