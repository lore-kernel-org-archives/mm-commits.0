From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-__ocfs2_mknod_locked-should-return-error-when-ocfs2_create_new_inode_locks-failed.patch removed from -mm tree
Date: Fri, 04 Apr 2014 12:30:24 -0700
Message-ID: <533f0850.GTorfvsciYa/eBeV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42770 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754387AbaDDTaZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:30:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, xuejiufei@huawei.com

Subject: [merged] ocfs2-__ocfs2_mknod_locked-should-return-error-when-ocfs2_create_new_inode_locks-failed.patch removed from -mm tree
To: xuejiufei@huawei.com,jlbec@evilplan.org,mfasheh@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:30:24 -0700


The patch titled
     Subject: ocfs2: __ocfs2_mknod_locked should return error when ocfs2_create_new_inode_locks() failed
has been removed from the -mm tree.  Its filename was
     ocfs2-__ocfs2_mknod_locked-should-return-error-when-ocfs2_create_new_inode_locks-failed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xue jiufei <xuejiufei@huawei.com>
Subject: ocfs2: __ocfs2_mknod_locked should return error when ocfs2_create_new_inode_locks() failed

When ocfs2_create_new_inode_locks() return error, inode open lock may not
be obtainted for this inode.  So other nodes can remove this file and free
dinode when inode still remain in memory on this node, which is not
correct and may trigger BUG.  So __ocfs2_mknod_locked should return error
when ocfs2_create_new_inode_locks() failed.

              Node_1                              Node_2
create fileA, call ocfs2_mknod()
  -> ocfs2_get_init_inode(), allocate inodeA
  -> ocfs2_claim_new_inode(), claim dinode(dinodeA)
  -> call ocfs2_create_new_inode_locks(),
     create open lock failed, return error
  -> __ocfs2_mknod_locked return success

                                                unlink fileA
                                                try open lock succeed,
                                                and free dinodeA

create another file, call ocfs2_mknod()
  -> ocfs2_get_init_inode(), allocate inodeB
  -> ocfs2_claim_new_inode(), as Node_2 had freed dinodeA,
     so claim dinodeA and update generation for dinodeA

call __ocfs2_drop_dl_inodes()->ocfs2_delete_inode()
to free inodeA, and finally triggers BUG
on(inode->i_generation != le32_to_cpu(fe->i_generation))
in function ocfs2_inode_lock_update().

Signed-off-by: joyce.xue <xuejiufei@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN fs/ocfs2/namei.c~ocfs2-__ocfs2_mknod_locked-should-return-error-when-ocfs2_create_new_inode_locks-failed fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-__ocfs2_mknod_locked-should-return-error-when-ocfs2_create_new_inode_locks-failed
+++ a/fs/ocfs2/namei.c
@@ -580,9 +580,6 @@ static int __ocfs2_mknod_locked(struct i
 	oi->i_sync_tid = handle->h_transaction->t_tid;
 	oi->i_datasync_tid = handle->h_transaction->t_tid;
 
-	status = 0; /* error in ocfs2_create_new_inode_locks is not
-		     * critical */
