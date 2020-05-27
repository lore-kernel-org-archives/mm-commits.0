From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 ocfs2-clear-links-count-in-ocfs2_mknod-if-an-error-occurs.patch added to
 -mm tree
Date: Wed, 27 May 2020 15:55:02 -0700
Message-ID: <20200527225502._bYNxd42_%akpm@linux-foundation.org>
References: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725267AbgE0WzE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 May 2020 18:55:04 -0400
In-Reply-To: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gechangwei@live.cn, ghe@suse.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com, wangyan122@huawei.com


The patch titled
     Subject: ocfs2: clear links count in ocfs2_mknod() if an error occurs
has been added to the -mm tree.  Its filename is
     ocfs2-clear-links-count-in-ocfs2_mknod-if-an-error-occurs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-clear-links-count-in-ocfs2_mknod-if-an-error-occurs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-clear-links-count-in-ocfs2_mknod-if-an-error-occurs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wangyan <wangyan122@huawei.com>
Subject: ocfs2: clear links count in ocfs2_mknod() if an error occurs

In this condition, the inode can not be wiped when error happened.
ocfs2_mkdir()
  ->ocfs2_mknod()
    ->ocfs2_mknod_locked()
      ->__ocfs2_mknod_locked()
        ->ocfs2_set_links_count() // i_links_count is 2
    -> ... // an error accrue, goto roll_back or leave.
    ->ocfs2_commit_trans()
    ->iput(inode)
      ->evict()
        ->ocfs2_evict_inode()
          ->ocfs2_delete_inode()
            ->ocfs2_inode_lock()
              ->ocfs2_inode_lock_update()
                ->ocfs2_refresh_inode()
                  ->set_nlink();    // inode->i_nlink is 2 now.
            /* if wipe is 0, it will goto bail_unlock_inode */
            ->ocfs2_query_inode_wipe()
              ->if (inode->i_nlink) return; // wipe is 0.
            /* inode can not be wiped */
            ->ocfs2_wipe_inode()
So, we need clear links before the transaction committed.

Link: http://lkml.kernel.org/r/d8147c41-fb2b-bdf7-b660-1f3c8448c33f@huawei.com
Signed-off-by: Yan Wang <wangyan122@huawei.com>
Reviewed-by: Jun Piao <piaojun@huawei.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/namei.c~ocfs2-clear-links-count-in-ocfs2_mknod-if-an-error-occurs
+++ a/fs/ocfs2/namei.c
@@ -453,8 +453,12 @@ roll_back:
 leave:
 	if (status < 0 && did_quota_inode)
 		dquot_free_inode(inode);
-	if (handle)
+	if (handle) {
+		if (status < 0 && new_fe_bh != NULL)
+			ocfs2_set_links_count((struct ocfs2_dinode *)
+					new_fe_bh->b_data, 0);
 		ocfs2_commit_trans(osb, handle);
+	}
 
 	ocfs2_inode_unlock(dir, 1);
 	if (did_block_signals)
@@ -598,6 +602,8 @@ static int __ocfs2_mknod_locked(struct i
 leave:
 	if (status < 0) {
 		if (*new_fe_bh) {
+			if (fe)
+				ocfs2_set_links_count(fe, 0);
 			brelse(*new_fe_bh);
 			*new_fe_bh = NULL;
 		}
@@ -2023,8 +2029,12 @@ bail:
 					ocfs2_clusters_to_bytes(osb->sb, 1));
 	if (status < 0 && did_quota_inode)
 		dquot_free_inode(inode);
-	if (handle)
+	if (handle) {
+		if (status < 0 && new_fe_bh != NULL)
+			ocfs2_set_links_count((struct ocfs2_dinode *)
+					new_fe_bh->b_data, 0);
 		ocfs2_commit_trans(osb, handle);
+	}
 
 	ocfs2_inode_unlock(dir, 1);
 	if (did_block_signals)
_

Patches currently in -mm which might be from wangyan122@huawei.com are

ocfs2-clear-links-count-in-ocfs2_mknod-if-an-error-occurs.patch
ocfs2-fix-ocfs2-corrupt-when-iputting-an-inode.patch
