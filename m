From: akpm@linux-foundation.org
Subject: [merged] ocfs2-iput-inode-alloc-when-failed-locally.patch removed from -mm tree
Date: Fri, 04 Apr 2014 12:30:38 -0700
Message-ID: <533f085e.kwd56WfgRi/tNNL/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42799 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487AbaDDTai (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:30:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.de, joseph.qi@huawei.com, jlbec@evilplan.org, jiangyiwen@huawei.com

Subject: [merged] ocfs2-iput-inode-alloc-when-failed-locally.patch removed from -mm tree
To: jiangyiwen@huawei.com,jlbec@evilplan.org,joseph.qi@huawei.com,mfasheh@suse.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:30:38 -0700


The patch titled
     Subject: ocfs2: iput inode alloc when failed locally
has been removed from the -mm tree.  Its filename was
     ocfs2-iput-inode-alloc-when-failed-locally.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: jiangyiwen <jiangyiwen@huawei.com>
Subject: ocfs2: iput inode alloc when failed locally

In ocfs2_info_handle_freeinode() and ocfs2_test_inode_bit() func, after
calls ocfs2_get_system_file_inode() to get inode ref, if calls
ocfs2_info_scan_inode_alloc() or ocfs2_inode_lock() failed, we should iput
inode alloc to avoid leaking the inode.

Signed-off-by: jiangyiwen <jiangyiwen@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/ioctl.c    |    5 +++--
 fs/ocfs2/suballoc.c |    1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/ioctl.c~ocfs2-iput-inode-alloc-when-failed-locally fs/ocfs2/ioctl.c
--- a/fs/ocfs2/ioctl.c~ocfs2-iput-inode-alloc-when-failed-locally
+++ a/fs/ocfs2/ioctl.c
@@ -413,11 +413,12 @@ int ocfs2_info_handle_freeinode(struct i
 		}
 
 		status = ocfs2_info_scan_inode_alloc(osb, inode_alloc, blkno, oifi, i);
-		if (status < 0)
-			goto bail;
 
 		iput(inode_alloc);
 		inode_alloc = NULL;
+
+		if (status < 0)
+			goto bail;
 	}
 
 	o2info_set_request_filled(&oifi->ifi_req);
diff -puN fs/ocfs2/suballoc.c~ocfs2-iput-inode-alloc-when-failed-locally fs/ocfs2/suballoc.c
--- a/fs/ocfs2/suballoc.c~ocfs2-iput-inode-alloc-when-failed-locally
+++ a/fs/ocfs2/suballoc.c
@@ -2894,6 +2894,7 @@ int ocfs2_test_inode_bit(struct ocfs2_su
 	status = ocfs2_inode_lock(inode_alloc_inode, &alloc_bh, 0);
 	if (status < 0) {
 		mutex_unlock(&inode_alloc_inode->i_mutex);
+		iput(inode_alloc_inode);
 		mlog(ML_ERROR, "lock on alloc inode on slot %u failed %d\n",
 		     (u32)suballoc_slot, status);
 		goto bail;
_

Patches currently in -mm which might be from jiangyiwen@huawei.com are

origin.patch
ocfs2-fix-a-tiny-race-when-running-dirop_fileop_racer.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
ocfs2-manually-do-the-iput-once-ocfs2_add_entry-failed-in-ocfs2_symlink-and-ocfs2_mknod.patch

