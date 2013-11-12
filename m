From: akpm@linux-foundation.org
Subject: [folded-merged]
 ocfs2-add-necessary-check-in-case-sb_getblk-fails-update.patch removed from -mm tree
Date: Tue, 12 Nov 2013 14:32:15 -0800
Message-ID: <5282ac6f.tQO5c/l0f3kYXhXz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60466 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab3KLWcQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Nov 2013 17:32:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rui.xiang@huawei.com, mfasheh@suse.de, jlbec@evilplan.org, jeff.liu@oracle.com, joseph.qi@huawei.com

Subject: [folded-merged] ocfs2-add-necessary-check-in-case-sb_getblk-fails-update.patch removed from -mm tree
To: joseph.qi@huawei.com,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.de,rui.xiang@huawei.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 12 Nov 2013 14:32:15 -0800


The patch titled
     Subject: ocfs2-add-necessary-check-in-case-sb_getblk-fails-update
has been removed from the -mm tree.  Its filename was
     ocfs2-add-necessary-check-in-case-sb_getblk-fails-update.patch

This patch was dropped because it was folded into ocfs2-add-necessary-check-in-case-sb_getblk-fails.patch

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2-add-necessary-check-in-case-sb_getblk-fails-update

Need also add a check after calling sb_getblk in ocfs2_create_xattr_block.

Cc: Rui Xiang <rui.xiang@huawei.com>
Cc: Jie Liu <jeff.liu@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/xattr.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN fs/ocfs2/xattr.c~ocfs2-add-necessary-check-in-case-sb_getblk-fails-update fs/ocfs2/xattr.c
--- a/fs/ocfs2/xattr.c~ocfs2-add-necessary-check-in-case-sb_getblk-fails-update
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

Patches currently in -mm which might be from joseph.qi@huawei.com are

ocfs2-return-enomem-when-sb_getblk-fails.patch
ocfs2-add-necessary-check-in-case-sb_getblk-fails.patch

