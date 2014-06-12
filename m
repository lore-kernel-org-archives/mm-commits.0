From: akpm@linux-foundation.org
Subject: [failures]
 ocfs2-call-ocfs2_journal_access_di-before-ocfs2_journal_dirty-in-ocfs2_write_end_nolock.patch removed from -mm tree
Date: Thu, 12 Jun 2014 15:33:14 -0700
Message-ID: <539a2aaa.eAU4tJ4qvbXVDd6R%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36694 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbaFLWdP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jun 2014 18:33:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, vicky.yangwenfang@huawei.com

Subject: [failures] ocfs2-call-ocfs2_journal_access_di-before-ocfs2_journal_dirty-in-ocfs2_write_end_nolock.patch removed from -mm tree
To: vicky.yangwenfang@huawei.com,jlbec@evilplan.org,mfasheh@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Jun 2014 15:33:14 -0700


The patch titled
     Subject: ocfs2: call ocfs2_journal_access_di() before ocfs2_journal_dirty() in ocfs2_write_end_nolock()
has been removed from the -mm tree.  Its filename was
     ocfs2-call-ocfs2_journal_access_di-before-ocfs2_journal_dirty-in-ocfs2_write_end_nolock.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: yangwenfang <vicky.yangwenfang@huawei.com>
Subject: ocfs2: call ocfs2_journal_access_di() before ocfs2_journal_dirty() in ocfs2_write_end_nolock()

After we call ocfs2_journal_access_di() in ocfs2_write_begin(),
jbd2_journal_restart() may also be called, in this function transaction
A's t_updates-- and obtains a new transaction B.  If
jbd2_journal_commit_transaction() is happened to commit transaction A,
when t_updates==0, it will continue to complete commit and unfile buffer.

So when jbd2_journal_dirty_metadata(), the handle is pointed a new
transaction B, and the buffer head's journal head is already freed,
jh->b_transaction == NULL, jh->b_next_transaction == NULL, it returns
EINVAL, So it triggers the BUG_ON(status).

thread 1                                          jbd2
ocfs2_write_begin                     jbd2_journal_commit_transaction
ocfs2_write_begin_nolock
  ocfs2_start_trans
    jbd2__journal_start(t_updates+1,
                       transaction A)
    ocfs2_journal_access_di
    ocfs2_write_cluster_by_desc
      ocfs2_mark_extent_written
        ocfs2_change_extent_flag
          ocfs2_split_extent
            ocfs2_extend_rotate_transaction
              jbd2_journal_restart
              (t_updates-1,transaction B) t_updates==0
                                        __jbd2_journal_refile_buffer
                                        (jh->b_transaction = NULL)
ocfs2_write_end
ocfs2_write_end_nolock
    ocfs2_journal_dirty
        jbd2_journal_dirty_metadata(bug)
   ocfs2_commit_trans

In ext4, I found that: jbd2_journal_get_write_access() called by

ext4_write_end.
ext4_write_begin
    ext4_journal_start
        __ext4_journal_start_sb
            ext4_journal_check_start
            jbd2__journal_start

ext4_write_end
    ext4_mark_inode_dirty
        ext4_reserve_inode_write
            ext4_journal_get_write_access
                jbd2_journal_get_write_access
        ext4_mark_iloc_dirty
            ext4_do_update_inode
                ext4_handle_dirty_metadata
                    jbd2_journal_dirty_metadata


So I think we should put ocfs2_journal_access_di before
ocfs2_journal_dirty in the ocfs2_write_end.  and it works well after my
modification.

Signed-off-by: vicky <vicky.yangwenfang@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff -puN fs/ocfs2/aops.c~ocfs2-call-ocfs2_journal_access_di-before-ocfs2_journal_dirty-in-ocfs2_write_end_nolock fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-call-ocfs2_journal_access_di-before-ocfs2_journal_dirty-in-ocfs2_write_end_nolock
+++ a/fs/ocfs2/aops.c
@@ -1818,16 +1818,6 @@ try_again:
 		if (ret)
 			goto out_commit;
 	}
-	/*
-	 * We don't want this to fail in ocfs2_write_end(), so do it
-	 * here.
-	 */
-	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), wc->w_di_bh,
-				      OCFS2_JOURNAL_ACCESS_WRITE);
-	if (ret) {
-		mlog_errno(ret);
-		goto out_quota;
-	}
 
 	/*
 	 * Fill our page array first. That way we've grabbed enough so
@@ -2040,8 +2030,16 @@ out_write_size:
 	di->i_mtime = di->i_ctime = cpu_to_le64(inode->i_mtime.tv_sec);
 	di->i_mtime_nsec = di->i_ctime_nsec = cpu_to_le32(inode->i_mtime.tv_nsec);
 	ocfs2_update_inode_fsync_trans(handle, inode, 1);
-	ocfs2_journal_dirty(handle, wc->w_di_bh);
+	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), wc->w_di_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		copied = ret;
+		mlog_errno(ret);
+		goto out;
+	}
 
+	ocfs2_journal_dirty(handle, wc->w_di_bh);
+out:
 	ocfs2_commit_trans(osb, handle);
 
 	ocfs2_run_deallocs(osb, &wc->w_dealloc);
_

Patches currently in -mm which might be from vicky.yangwenfang@huawei.com are


