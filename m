From: akpm@linux-foundation.org
Subject: [folded-merged]
 ocfs2-fix-deadlock-due-to-wrong-locking-order-fix.patch removed from -mm
 tree
Date: Thu, 09 Oct 2014 13:26:57 -0700
Message-ID: <5436ef91.D1CPlvyUGvspjx5f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35345 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbaJIU06 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2014 16:26:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: junxiao.bi@oracle.com, alex.chen@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix null handle in ocfs2_write_zero_page
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-deadlock-due-to-wrong-locking-order-fix.patch

This patch was dropped because it was folded into ocfs2-fix-deadlock-due-to-wrong-locking-order.patch

------------------------------------------------------
From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: ocfs2: fix null handle in ocfs2_write_zero_page

ocfs2_zero_start_ordered_transaction() will return NULL handle in data
writeback mode, this should be checked and bypass journal ops, or kernel
panic will be triggered.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Alex Chen <alex.chen@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN fs/ocfs2/file.c~ocfs2-fix-deadlock-due-to-wrong-locking-order-fix fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-fix-deadlock-due-to-wrong-locking-order-fix
+++ a/fs/ocfs2/file.c
@@ -833,14 +833,17 @@ static int ocfs2_write_zero_page(struct
 	di->i_mtime = di->i_ctime = cpu_to_le64(inode->i_mtime.tv_sec);
 	di->i_ctime_nsec = cpu_to_le32(inode->i_mtime.tv_nsec);
 	di->i_mtime_nsec = di->i_ctime_nsec;
-	ocfs2_journal_dirty(handle, di_bh);
-	ocfs2_update_inode_fsync_trans(handle, inode, 1);
+	if (handle) {
+		ocfs2_journal_dirty(handle, di_bh);
+		ocfs2_update_inode_fsync_trans(handle, inode, 1);
+	}
 
 out_unlock:
 	unlock_page(page);
 	page_cache_release(page);
 out_commit_trans:
-	ocfs2_commit_trans(OCFS2_SB(inode->i_sb), handle);
+	if (handle)
+		ocfs2_commit_trans(OCFS2_SB(inode->i_sb), handle);
 out:
 	return ret;
 }
_

Patches currently in -mm which might be from junxiao.bi@oracle.com are

ocfs2-dont-fire-quorum-before-connection-established.patch
ocfs2-fix-deadlock-due-to-wrong-locking-order.patch
mm-clear-__gfp_fs-when-pf_memalloc_noio-is-set.patch
ocfs2-fix-a-deadlock-while-o2net_wq-doing-direct-memory-reclaim.patch

