From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-fix-journal-commit-deadlock-in-ocfs2_convert_inline_data_to_extents.patch removed from -mm tree
Date: Wed, 11 Feb 2015 12:21:12 -0800
Message-ID: <54dbb9b8.YOExiAteMi9e1W8C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40829 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013AbbBKUVN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 15:21:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.chen@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix journal commit deadlock in ocfs2_convert_inline_data_to_extents
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-journal-commit-deadlock-in-ocfs2_convert_inline_data_to_extents.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
-
-out:
-	if (pages) {
-		ocfs2_unlock_and_free_pages(pages, num_pages);
+	if (pages)
 		kfree(pages);
-	}
 
 	return ret;
 }
_

Patches currently in -mm which might be from alex.chen@huawei.com are

origin.patch
linux-next.patch
ocfs2-prepare-some-interfaces-used-in-append-direct-io.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir-fix.patch
ocfs2-add-orphan-recovery-types-in-ocfs2_recover_orphans.patch
ocfs2-implement-ocfs2_direct_io_write.patch
ocfs2-implement-ocfs2_direct_io_write-fix.patch
ocfs2-allocate-blocks-in-ocfs2_direct_io_get_blocks.patch
ocfs2-do-not-fallback-to-buffer-i-o-write-if-appending.patch
ocfs2-complete-the-rest-request-through-buffer-io.patch
ocfs2-wait-for-orphan-recovery-first-once-append-o_direct-write-crash.patch
ocfs2-set-append-dio-as-a-ro-compat-feature.patch

