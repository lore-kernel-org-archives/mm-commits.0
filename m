From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-do-not-call-brelse-if-group_bh-is-not-initialized-in-ocfs2_group_add.patch removed from -mm tree
Date: Wed, 13 Nov 2013 12:37:29 -0800
Message-ID: <5283e309.YXoc1pZSSDU14HtE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42452 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab3KMUha (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:37:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, younger.liu@huawei.com

Subject: [merged] ocfs2-do-not-call-brelse-if-group_bh-is-not-initialized-in-ocfs2_group_add.patch removed from -mm tree
To: younger.liu@huawei.com,jlbec@evilplan.org,mfasheh@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:37:29 -0800


The patch titled
     Subject: ocfs2: do not call brelse() if group_bh is not initialized in ocfs2_group_add()
has been removed from the -mm tree.  Its filename was
     ocfs2-do-not-call-brelse-if-group_bh-is-not-initialized-in-ocfs2_group_add.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Younger Liu <younger.liu@huawei.com>
Subject: ocfs2: do not call brelse() if group_bh is not initialized in ocfs2_group_add()

If group_bh is not initialized, there is no need to release.  This problem
does not cause anything wrong, but the patch would make the code more
logical.

Signed-off-by: Younger Liu <younger.liu@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Acked-by: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/resize.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN fs/ocfs2/resize.c~ocfs2-do-not-call-brelse-if-group_bh-is-not-initialized-in-ocfs2_group_add fs/ocfs2/resize.c
--- a/fs/ocfs2/resize.c~ocfs2-do-not-call-brelse-if-group_bh-is-not-initialized-in-ocfs2_group_add
+++ a/fs/ocfs2/resize.c
@@ -514,7 +514,7 @@ int ocfs2_group_add(struct inode *inode,
 	ret = ocfs2_verify_group_and_input(main_bm_inode, fe, input, group_bh);
 	if (ret) {
 		mlog_errno(ret);
-		goto out_unlock;
+		goto out_free_group_bh;
 	}
 
 	trace_ocfs2_group_add((unsigned long long)input->group,
@@ -524,7 +524,7 @@ int ocfs2_group_add(struct inode *inode,
 	if (IS_ERR(handle)) {
 		mlog_errno(PTR_ERR(handle));
 		ret = -EINVAL;
-		goto out_unlock;
+		goto out_free_group_bh;
 	}
 
 	cl_bpc = le16_to_cpu(fe->id2.i_chain.cl_bpc);
@@ -577,8 +577,11 @@ int ocfs2_group_add(struct inode *inode,
 
 out_commit:
 	ocfs2_commit_trans(osb, handle);
-out_unlock:
+
+out_free_group_bh:
 	brelse(group_bh);
+
+out_unlock:
 	brelse(main_bm_bh);
 
 	ocfs2_inode_unlock(main_bm_inode, 1);
_

Patches currently in -mm which might be from younger.liu@huawei.com are

origin.patch
ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del.patch
ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size.patch
ocfs2-update-inode-size-after-zeronig-the-hole.patch

