From: akpm@linux-foundation.org
Subject: +
 ocfs2-free-meta_ac-and-data_ac-when-ocfs2_start_trans-fails-in-ocfs2_xattr_set.patch added to -mm tree
Date: Thu, 08 Aug 2013 14:47:37 -0700
Message-ID: <520411f9.+khMEi+nCLtaN19t%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53196 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757968Ab3HHVri (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Aug 2013 17:47:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, joseph.qi@huawei.com, jlbec@evilplan.org, jeff.liu@oracle.com, younger.liu@huawei.com

Subject: + ocfs2-free-meta_ac-and-data_ac-when-ocfs2_start_trans-fails-in-ocfs2_xattr_set.patch added to -mm tree
To: younger.liu@huawei.com,jeff.liu@oracle.com,jlbec@evilplan.org,joseph.qi@huawei.com,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Thu, 08 Aug 2013 14:47:37 -0700


The patch titled
     Subject: ocfs2: free meta_ac and data_ac when ocfs2_start_trans fails in ocfs2_xattr_set()
has been added to the -mm tree.  Its filename is
     ocfs2-free-meta_ac-and-data_ac-when-ocfs2_start_trans-fails-in-ocfs2_xattr_set.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-free-meta_ac-and-data_ac-when-ocfs2_start_trans-fails-in-ocfs2_xattr_set.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-free-meta_ac-and-data_ac-when-ocfs2_start_trans-fails-in-ocfs2_xattr_set.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Younger Liu <younger.liu@huawei.com>
Subject: ocfs2: free meta_ac and data_ac when ocfs2_start_trans fails in ocfs2_xattr_set()

In ocfs2_xattr_set(), if ocfs2_start_trans failed, meta_ac and data_ac
should be free.  Otherwise, It would lead to a memory leak.

Signed-off-by: Younger Liu <younger.liu@huawei.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Jie Liu <jeff.liu@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/xattr.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/xattr.c~ocfs2-free-meta_ac-and-data_ac-when-ocfs2_start_trans-fails-in-ocfs2_xattr_set fs/ocfs2/xattr.c
--- a/fs/ocfs2/xattr.c~ocfs2-free-meta_ac-and-data_ac-when-ocfs2_start_trans-fails-in-ocfs2_xattr_set
+++ a/fs/ocfs2/xattr.c
@@ -3505,7 +3505,7 @@ int ocfs2_xattr_set(struct inode *inode,
 	int ret, credits, ref_meta = 0, ref_credits = 0;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct inode *tl_inode = osb->osb_tl_inode;
-	struct ocfs2_xattr_set_ctxt ctxt = { NULL, NULL, };
+	struct ocfs2_xattr_set_ctxt ctxt = { NULL, NULL, NULL, };
 	struct ocfs2_refcount_tree *ref_tree = NULL;
 
 	struct ocfs2_xattr_info xi = {
@@ -3609,13 +3609,14 @@ int ocfs2_xattr_set(struct inode *inode,
 	if (IS_ERR(ctxt.handle)) {
 		ret = PTR_ERR(ctxt.handle);
 		mlog_errno(ret);
-		goto cleanup;
+		goto out_free_ac;
 	}
 
 	ret = __ocfs2_xattr_set_handle(inode, di, &xi, &xis, &xbs, &ctxt);
 
 	ocfs2_commit_trans(osb, ctxt.handle);
 
+out_free_ac:
 	if (ctxt.data_ac)
 		ocfs2_free_alloc_context(ctxt.data_ac);
 	if (ctxt.meta_ac)
_

Patches currently in -mm which might be from younger.liu@huawei.com are

ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del.patch
ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size.patch
ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size-v2.patch
ocfs2-update-inode-size-after-zeronig-the-hole.patch
ocfs2-lighten-up-allocate-transaction.patch
ocfs2-ac_bits_wanted-should-be-local_alloc_bits-when-returns-enospc.patch
ocfs2-fix-a-memory-leak-in-__ocfs2_move_extents.patch
ocfs2-free-meta_ac-and-data_ac-when-ocfs2_start_trans-fails-in-ocfs2_xattr_set.patch
linux-next.patch

