From: akpm@linux-foundation.org
Subject: +
 ocfs2-fix-journal-commit-deadlock-in-ocfs2_convert_inline_data_to_extents.patch added to -mm tree
Date: Tue, 13 Jan 2015 16:05:49 -0800
Message-ID: <54b5b2dd.aNwVgxh6mfJpi6iU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53562 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbbANAFu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Jan 2015 19:05:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.chen@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix journal commit deadlock in ocfs2_convert_inline_data_to_extents
has been added to the -mm tree.  Its filename is
     ocfs2-fix-journal-commit-deadlock-in-ocfs2_convert_inline_data_to_extents.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-journal-commit-deadlock-in-ocfs2_convert_inline_data_to_extents.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-journal-commit-deadlock-in-ocfs2_convert_inline_data_to_extents.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: alex chen <alex.chen@huawei.com>
Subject: ocfs2: fix journal commit deadlock in ocfs2_convert_inline_data_to_extents

Similar to ocfs2_write_end_nolock() which is metioned at commit 136f49b917
("ocfs2: fix journal commit deadlock"), we should unlock pages before
ocfs2_commit_trans() in ocfs2_convert_inline_data_to_extents, otherwise,
it will cause a deadlock with journal commit threads.

Signed-off-by: Alex Chen <alex.chen@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN fs/ocfs2/alloc.c~ocfs2-fix-journal-commit-deadlock-in-ocfs2_convert_inline_data_to_extents fs/ocfs2/alloc.c
--- a/fs/ocfs2/alloc.c~ocfs2-fix-journal-commit-deadlock-in-ocfs2_convert_inline_data_to_extents
+++ a/fs/ocfs2/alloc.c
@@ -6873,7 +6873,7 @@ int ocfs2_convert_inline_data_to_extents
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
 		mlog_errno(ret);
-		goto out_unlock;
+		goto out;
 	}
 
 	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
@@ -6931,7 +6931,7 @@ int ocfs2_convert_inline_data_to_extents
 		if (ret) {
 			mlog_errno(ret);
 			need_free = 1;
-			goto out_commit;
+			goto out_unlock;
 		}
 
 		page_end = PAGE_CACHE_SIZE;
@@ -6964,12 +6964,16 @@ int ocfs2_convert_inline_data_to_extents
 		if (ret) {
 			mlog_errno(ret);
 			need_free = 1;
-			goto out_commit;
+			goto out_unlock;
 		}
 
 		inode->i_blocks = ocfs2_inode_sector_count(inode);
 	}
 
+out_unlock:
+	if (pages)
+		ocfs2_unlock_and_free_pages(pages, num_pages);
+
 out_commit:
 	if (ret < 0 && did_quota)
 		dquot_free_space_nodirty(inode,
@@ -6989,15 +6993,11 @@ out_commit:
 
 	ocfs2_commit_trans(osb, handle);
 
-out_unlock:
+out:
 	if (data_ac)
 		ocfs2_free_alloc_context(data_ac);
