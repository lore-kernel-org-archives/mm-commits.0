From: akpm@linux-foundation.org
Subject: + ocfs2-add-necessary-check-in-case-sb_getblk-fails.patch added
 to -mm tree
Date: Tue, 17 Sep 2013 16:26:25 -0700
Message-ID: <5238e521.GeLag+VcWcwU97Ld%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39718 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921Ab3IQX00 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Sep 2013 19:26:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com, rui.xiang@huawei.com

Subject: + ocfs2-add-necessary-check-in-case-sb_getblk-fails.patch added to -mm tree
To: rui.xiang@huawei.com,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Tue, 17 Sep 2013 16:26:25 -0700


The patch titled
     Subject: ocfs2: add necessary check in case sb_getblk() fails
has been added to the -mm tree.  Its filename is
     ocfs2-add-necessary-check-in-case-sb_getblk-fails.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-add-necessary-check-in-case-sb_getblk-fails.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-add-necessary-check-in-case-sb_getblk-fails.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rui Xiang <rui.xiang@huawei.com>
Subject: ocfs2: add necessary check in case sb_getblk() fails

sb_getblk() may return an err, so add a check for bh.

Signed-off-by: Rui Xiang <rui.xiang@huawei.com>
Reviewed-by: Jie Liu <jeff.liu@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/refcounttree.c |    5 +++++
 1 file changed, 5 insertions(+)

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
_

Patches currently in -mm which might be from rui.xiang@huawei.com are

ocfs2-return-enomem-when-sb_getblk-fails.patch
ocfs2-add-necessary-check-in-case-sb_getblk-fails.patch

