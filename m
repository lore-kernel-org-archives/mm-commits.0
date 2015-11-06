From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-should-reclaim-the-inode-if-__ocfs2_mknod_locked-returns-an-error.patch removed from -mm tree
Date: Fri, 06 Nov 2015 12:05:53 -0800
Message-ID: <563d0821.+7ZTMUDccSLSZJGX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48460 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033333AbbKFUFy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:05:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.chen@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: should reclaim the inode if '__ocfs2_mknod_locked' returns an error
has been removed from the -mm tree.  Its filename was
     ocfs2-should-reclaim-the-inode-if-__ocfs2_mknod_locked-returns-an-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: alex chen <alex.chen@huawei.com>
Subject: ocfs2: should reclaim the inode if '__ocfs2_mknod_locked' returns an error

In ocfs2_mknod_locked if '__ocfs2_mknod_locke		d' returns an error, we
should reclaim the inode successfully claimed above, otherwise, the
inode never be reused. The case is described below:

ocfs2_mknod
    ocfs2_mknod_locked
	ocfs2_claim_new_inode
		Successfully claim the inode
        __ocfs2_mknod_locked
            ocfs2_journal_access_di
            Failed because of -ENOMEM or other reasons, the inode
			lockres has not been initialized yet.

    iput(inode)
        ocfs2_evict_inode
            ocfs2_delete_inode
                ocfs2_inode_lock
                    ocfs2_inode_lock_full_nested
                        __ocfs2_cluster_lock
				Return -EINVAL because of the inode
				lockres has not been initialized.

		So the following operations are not performed
		ocfs2_wipe_inode
			ocfs2_remove_inode
				ocfs2_free_dinode
					ocfs2_free_suballoc_bits

Signed-off-by: Alex Chen <alex.chen@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/namei.c~ocfs2-should-reclaim-the-inode-if-__ocfs2_mknod_locked-returns-an-error fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-should-reclaim-the-inode-if-__ocfs2_mknod_locked-returns-an-error
+++ a/fs/ocfs2/namei.c
@@ -655,9 +655,18 @@ static int ocfs2_mknod_locked(struct ocf
 		return status;
 	}
 
-	return __ocfs2_mknod_locked(dir, inode, dev, new_fe_bh,
+	status = __ocfs2_mknod_locked(dir, inode, dev, new_fe_bh,
 				    parent_fe_bh, handle, inode_ac,
 				    fe_blkno, suballoc_loc, suballoc_bit);
+	if (status < 0) {
+		u64 bg_blkno = ocfs2_which_suballoc_group(fe_blkno, suballoc_bit);
+		int tmp = ocfs2_free_suballoc_bits(handle, inode_ac->ac_inode,
+				inode_ac->ac_bh, suballoc_bit, bg_blkno, 1);
+		if (tmp)
+			mlog_errno(tmp);
+	}
+
+	return status;
 }
 
 static int ocfs2_mkdir(struct inode *dir,
_

Patches currently in -mm which might be from alex.chen@huawei.com are


