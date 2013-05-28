From: akpm@linux-foundation.org
Subject: [merged] ocfs2-unlock-rw-lock-if-inode-lock-failed.patch removed
 from -mm tree
Date: Tue, 28 May 2013 12:36:43 -0700
Message-ID: <51a5074b.nnvuNzdduBVbA9CX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60391 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162Ab3E1Tgo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 May 2013 15:36:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sunil.mushran@gmail.com, mfasheh@suse.com, lizefan@huawei.com, jlbec@evilplan.org, du.duyongfeng@huawei.com, joseph.qi@huawei.com

Subject: [merged] ocfs2-unlock-rw-lock-if-inode-lock-failed.patch removed from -mm tree
To: joseph.qi@huawei.com,du.duyongfeng@huawei.com,jlbec@evilplan.org,lizefan@huawei.com,mfasheh@suse.com,sunil.mushran@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 May 2013 12:36:43 -0700


The patch titled
     Subject: ocfs2: unlock rw lock if inode lock failed
has been removed from the -mm tree.  Its filename was
     ocfs2-unlock-rw-lock-if-inode-lock-failed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: unlock rw lock if inode lock failed

In ocfs2_file_aio_write(), it does ocfs2_rw_lock() first and then
ocfs2_inode_lock().  But if ocfs2_inode_lock() failed, it goes to out_sems
without unlocking rw lock.  This will cause a bug in ocfs2_lock_res_free()
when testing res->l_ex_holders, which is increased in
__ocfs2_cluster_lock() and decreased in __ocfs2_cluster_unlock().

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: "Duyongfeng (B)" <du.duyongfeng@huawei.com>
Acked-by: Sunil Mushran <sunil.mushran@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/file.c~ocfs2-unlock-rw-lock-if-inode-lock-failed fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-unlock-rw-lock-if-inode-lock-failed
+++ a/fs/ocfs2/file.c
@@ -2288,7 +2288,7 @@ relock:
 		ret = ocfs2_inode_lock(inode, NULL, 1);
 		if (ret < 0) {
 			mlog_errno(ret);
-			goto out_sems;
+			goto out;
 		}
 
 		ocfs2_inode_unlock(inode, 1);
_

Patches currently in -mm which might be from joseph.qi@huawei.com are


