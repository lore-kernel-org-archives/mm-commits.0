From: akpm@linux-foundation.org
Subject: [merged] ocfs2-add-necessary-check-in-case-sb_getblk-fails.patch
 removed from -mm tree
Date: Wed, 13 Nov 2013 12:37:14 -0800
Message-ID: <5283e2fa.q2KsTZBcvkIzfbqa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42428 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab3KMUhQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:37:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.de, joseph.qi@huawei.com, jlbec@evilplan.org, jeff.liu@oracle.com, rui.xiang@huawei.com

Subject: [merged] ocfs2-add-necessary-check-in-case-sb_getblk-fails.patch removed from -mm tree
To: rui.xiang@huawei.com,jeff.liu@oracle.com,jlbec@evilplan.org,joseph.qi@huawei.com,mfasheh@suse.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:37:14 -0800


The patch titled
     Subject: ocfs2: add necessary check in case sb_getblk() fails
has been removed from the -mm tree.  Its filename was
     ocfs2-add-necessary-check-in-case-sb_getblk-fails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rui Xiang <rui.xiang@huawei.com>
Subject: ocfs2: add necessary check in case sb_getblk() fails

sb_getblk() may return an err, so add a check for bh.

[joseph.qi@huawei.com: also add a check after calling sb_getblk() in ocfs2_create_xattr_block()]
Signed-off-by: Rui Xiang <rui.xiang@huawei.com>
Reviewed-by: Jie Liu <jeff.liu@oracle.com>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/refcounttree.c |    5 +++++
 fs/ocfs2/xattr.c        |    6 ++++++
 2 files changed, 11 insertions(+)

diff -puN fs/ocfs2/refcounttree.c~ocfs2-add-necessary-check-in-case-sb_getblk-fails fs/ocfs2/refcounttree.c
--- a/fs/ocfs2/refcounttree.c~ocfs2-add-necessary-check-in-case-sb_getblk-fails
+++ a/fs/ocfs2/refcounttree.c
@@ -612,6 +612,11 @@ static int ocfs2_create_refcount_tree(st
 	}
 
 	new_bh = sb_getblk(inode->i_sb, first_blkno);
+	if (!new_bh) {
+		ret = -ENOMEM;
+		mlog_errno(ret);
+		goto out_commit;
+	}
 	ocfs2_set_new_buffer_uptodate(&new_tree->rf_ci, new_bh);
 
 	ret = ocfs2_journal_access_rb(handle, &new_tree->rf_ci, new_bh,
diff -puN fs/ocfs2/xattr.c~ocfs2-add-necessary-check-in-case-sb_getblk-fails fs/ocfs2/xattr.c
--- a/fs/ocfs2/xattr.c~ocfs2-add-necessary-check-in-case-sb_getblk-fails
+++ a/fs/ocfs2/xattr.c
@@ -2864,6 +2864,12 @@ static int ocfs2_create_xattr_block(stru
 	}
 
 	new_bh = sb_getblk(inode->i_sb, first_blkno);
+	if (!new_bh) {
+		ret = -ENOMEM;
+		mlog_errno(ret);
+		goto end;
+	}
+
 	ocfs2_set_new_buffer_uptodate(INODE_CACHE(inode), new_bh);
 
 	ret = ocfs2_journal_access_xb(ctxt->handle, INODE_CACHE(inode),
_

Patches currently in -mm which might be from rui.xiang@huawei.com are

origin.patch

