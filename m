From: akpm@linux-foundation.org
Subject: + ocfs2-add-necessary-check-in-case-sb_getblk-fails-update.patch
 added to -mm tree
Date: Wed, 18 Sep 2013 16:16:18 -0700
Message-ID: <523a3442.tqEtH+W4fplcc0tC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47886 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab3IRXQT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Sep 2013 19:16:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rui.xiang@huawei.com, mfasheh@suse.de, jlbec@evilplan.org, jeff.liu@oracle.com, joseph.qi@huawei.com

Subject: + ocfs2-add-necessary-check-in-case-sb_getblk-fails-update.patch added to -mm tree
To: joseph.qi@huawei.com,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.de,rui.xiang@huawei.com
From: akpm@linux-foundation.org
Date: Wed, 18 Sep 2013 16:16:18 -0700


The patch titled
     Subject: ocfs2-add-necessary-check-in-case-sb_getblk-fails-update
has been added to the -mm tree.  Its filename is
     ocfs2-add-necessary-check-in-case-sb_getblk-fails-update.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-add-necessary-check-in-case-sb_getblk-fails-update.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-add-necessary-check-in-case-sb_getblk-fails-update.patch

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

ocfs2-return-enomem-when-sb_getblk-fails-update.patch
ocfs2-add-necessary-check-in-case-sb_getblk-fails-update.patch

