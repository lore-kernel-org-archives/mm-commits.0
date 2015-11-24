From: akpm@linux-foundation.org
Subject: + ocfs2-fix-a-deadlock-issue-in-ocfs2_dio_end_io_write.patch
 added to -mm tree
Date: Mon, 23 Nov 2015 16:25:13 -0800
Message-ID: <5653ae69.8AdX4AzxwZsVL7DJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57591 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbbKXAZO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Nov 2015 19:25:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ryan.ding@oracle.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix a deadlock issue in ocfs2_dio_end_io_write()
has been added to the -mm tree.  Its filename is
     ocfs2-fix-a-deadlock-issue-in-ocfs2_dio_end_io_write.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-a-deadlock-issue-in-ocfs2_dio_end_io_write.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-a-deadlock-issue-in-ocfs2_dio_end_io_write.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ryan Ding <ryan.ding@oracle.com>
Subject: ocfs2: fix a deadlock issue in ocfs2_dio_end_io_write()

Should call ocfs2_free_alloc_context() to free meta_ac & data_ac before
calling ocfs2_run_deallocs().  Because ocfs2_run_deallocs() will acquire
the system inode's i_mutex hold by meta_ac.  So try to release the lock
before ocfs2_run_deallocs().

Fixes: af1310367f41 ("ocfs2: fix sparse file & data ordering issue in direct io.")
Signed-off-by: Ryan Ding <ryan.ding@oracle.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN fs/ocfs2/aops.c~ocfs2-fix-a-deadlock-issue-in-ocfs2_dio_end_io_write fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-fix-a-deadlock-issue-in-ocfs2_dio_end_io_write
+++ a/fs/ocfs2/aops.c
@@ -2341,6 +2341,10 @@ static void ocfs2_dio_end_io_write(struc
 
 	ret = ocfs2_lock_allocators(inode, &et, 0, dwc->dw_zero_count*2,
 				    &data_ac, &meta_ac);
+	if (ret) {
+		mlog_errno(ret);
+		goto unlock;
+	}
 
 	credits = ocfs2_calc_extend_credits(inode->i_sb, &di->id2.i_list);
 
@@ -2380,14 +2384,14 @@ unlock:
 	ocfs2_inode_unlock(inode, 1);
 	brelse(di_bh);
 out:
-	ocfs2_run_deallocs(osb, &dealloc);
-	if (locked)
-		mutex_unlock(&inode->i_mutex);
-	ocfs2_dio_free_write_ctx(inode, dwc);
 	if (data_ac)
 		ocfs2_free_alloc_context(data_ac);
 	if (meta_ac)
 		ocfs2_free_alloc_context(meta_ac);
+	ocfs2_run_deallocs(osb, &dealloc);
+	if (locked)
+		mutex_unlock(&inode->i_mutex);
+	ocfs2_dio_free_write_ctx(inode, dwc);
 }
 
 /*
_

Patches currently in -mm which might be from ryan.ding@oracle.com are

ocfs2-add-ocfs2_write_type_t-type-to-identify-the-caller-of-write.patch
ocfs2-use-c_new-to-indicate-newly-allocated-extents.patch
ocfs2-test-target-page-before-change-it.patch
ocfs2-do-not-change-i_size-in-write_end-for-direct-io.patch
ocfs2-return-the-physical-address-in-ocfs2_write_cluster.patch
ocfs2-record-unwritten-extents-when-populate-write-desc.patch
ocfs2-fix-sparse-file-data-ordering-issue-in-direct-io.patch
ocfs2-code-clean-up-for-direct-io.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue.patch
ocfs2-take-ip_alloc_sem-in-ocfs2_dio_get_block-ocfs2_dio_end_io_write.patch
ocfs2-fix-disk-file-size-and-memory-file-size-mismatch.patch
ocfs2-fix-a-deadlock-issue-in-ocfs2_dio_end_io_write.patch

