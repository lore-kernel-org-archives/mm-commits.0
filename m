From: akpm@linux-foundation.org
Subject: +
 ocfs2-fix-mutex_unlock-and-possible-memory-leak-in-ocfs2_remove_btree_range.patch added to -mm tree
Date: Tue, 11 Jun 2013 14:45:11 -0700
Message-ID: <51b79a67.MGJU9NBFqrTToWYI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43221 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796Ab3FKVpM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jun 2013 17:45:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com, joseph.qi@huawei.com

Subject: + ocfs2-fix-mutex_unlock-and-possible-memory-leak-in-ocfs2_remove_btree_range.patch added to -mm tree
To: joseph.qi@huawei.com,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Tue, 11 Jun 2013 14:45:11 -0700


The patch titled
     Subject: ocfs2: fix mutex_unlock and possible memory leak in ocfs2_remove_btree_range
has been added to the -mm tree.  Its filename is
     ocfs2-fix-mutex_unlock-and-possible-memory-leak-in-ocfs2_remove_btree_range.patch

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
Subject: ocfs2: fix mutex_unlock and possible memory leak in ocfs2_remove_btree_range

In ocfs2_remove_btree_range, when calling ocfs2_lock_refcount_tree and
ocfs2_prepare_refcount_change_for_del failed, it goes to out and then
tries to call mutex_unlock without mutex_lock before.  And when calling
ocfs2_reserve_blocks_for_rec_trunc failed, it should free ref_tree before
return.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Jie Liu <jeff.liu@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/ocfs2/alloc.c~ocfs2-fix-mutex_unlock-and-possible-memory-leak-in-ocfs2_remove_btree_range fs/ocfs2/alloc.c
--- a/fs/ocfs2/alloc.c~ocfs2-fix-mutex_unlock-and-possible-memory-leak-in-ocfs2_remove_btree_range
+++ a/fs/ocfs2/alloc.c
@@ -5655,7 +5655,7 @@ int ocfs2_remove_btree_range(struct inod
 					       &ref_tree, NULL);
 		if (ret) {
 			mlog_errno(ret);
-			goto out;
+			goto bail;
 		}
 
 		ret = ocfs2_prepare_refcount_change_for_del(inode,
@@ -5666,7 +5666,7 @@ int ocfs2_remove_btree_range(struct inod
 							    &extra_blocks);
 		if (ret < 0) {
 			mlog_errno(ret);
-			goto out;
+			goto bail;
 		}
 	}
 
@@ -5674,7 +5674,7 @@ int ocfs2_remove_btree_range(struct inod
 						 extra_blocks);
 	if (ret) {
 		mlog_errno(ret);
-		return ret;
+		goto bail;
 	}
 
 	mutex_lock(&tl_inode->i_mutex);
@@ -5734,7 +5734,7 @@ out_commit:
 	ocfs2_commit_trans(osb, handle);
 out:
 	mutex_unlock(&tl_inode->i_mutex);
