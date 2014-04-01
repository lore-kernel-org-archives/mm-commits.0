From: akpm@linux-foundation.org
Subject: + ocfs2-iput-inode-alloc-when-failed-locally.patch added to -mm
 tree
Date: Tue, 01 Apr 2014 14:26:05 -0700
Message-ID: <533b2eed.NGF+ksMsBSKPrw/v%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38553 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbaDAV0G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Apr 2014 17:26:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.de, joseph.qi@huawei.com, jlbec@evilplan.org, jiangyiwen@huawei.com

Subject: + ocfs2-iput-inode-alloc-when-failed-locally.patch added to -mm tree
To: jiangyiwen@huawei.com,jlbec@evilplan.org,joseph.qi@huawei.com,mfasheh@suse.de
From: akpm@linux-foundation.org
Date: Tue, 01 Apr 2014 14:26:05 -0700


The patch titled
     Subject: ocfs2: iput inode alloc when failed locally
has been added to the -mm tree.  Its filename is
     ocfs2-iput-inode-alloc-when-failed-locally.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-iput-inode-alloc-when-failed-locally.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-iput-inode-alloc-when-failed-locally.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ocfs2-fix-a-tiny-race-when-running-dirop_fileop_racer.patch
ocfs2-iput-inode-alloc-when-failed-locally.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
ocfs2-manually-do-the-iput-once-ocfs2_add_entry-failed-in-ocfs2_symlink-and-ocfs2_mknod.patch

