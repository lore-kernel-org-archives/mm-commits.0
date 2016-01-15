From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-fix-slot-overwritten-if-storage-link-down-during-mount.patch removed
 from -mm tree
Date: Fri, 15 Jan 2016 14:31:44 -0800
Message-ID: <56997350.yGtCgYzY7ODKkcua%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59023 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbcAOWbp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:31:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jiangyiwen@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix slot overwritten if storage link down during mount
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-slot-overwritten-if-storage-link-down-during-mount.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: jiangyiwen <jiangyiwen@huawei.com>
Subject: ocfs2: fix slot overwritten if storage link down during mount

The following case will lead to slot overwritten.

N1                               N2
mount ocfs2 volume, find and
allocate slot 0, then set
osb->slot_num to 0, begin to
write slot info to disk
                                 mount ocfs2 volume, wait for super lock
write block fail because of
storage link down, unlock
super lock
                                 got super lock and also allocate slot 0
                                 then unlock super lock

mount fail and then dismount,
since osb->slot_num is 0, try to
put invalid slot to disk. And it
will succeed if storage link
restores.
                                 N2 slot info is now overwritten

Once another node say N3 mount, it will find and allocate slot 0 again,
which will lead to mount hung because journal has already been locked by
N2.  so when write slot info failed, invalidate slot in advance to avoid
overwrite slot.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/slot_map.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/slot_map.c~ocfs2-fix-slot-overwritten-if-storage-link-down-during-mount fs/ocfs2/slot_map.c
--- a/fs/ocfs2/slot_map.c~ocfs2-fix-slot-overwritten-if-storage-link-down-during-mount
+++ a/fs/ocfs2/slot_map.c
@@ -502,8 +502,17 @@ int ocfs2_find_slot(struct ocfs2_super *
 	trace_ocfs2_find_slot(osb->slot_num);
 
 	status = ocfs2_update_disk_slot(osb, si, osb->slot_num);
-	if (status < 0)
+	if (status < 0) {
 		mlog_errno(status);
+		/*
+		 * if write block failed, invalidate slot to avoid overwrite
+		 * slot during dismount in case another node rightly has mounted
+		 */
+		spin_lock(&osb->osb_lock);
+		ocfs2_invalidate_slot(si, osb->slot_num);
+		osb->slot_num = OCFS2_INVALID_SLOT;
+		spin_unlock(&osb->osb_lock);
+	}
 
 bail:
 	return status;
_

Patches currently in -mm which might be from jiangyiwen@huawei.com are

ocfs2-avoid-occurring-deadlock-by-changing-ocfs2_wq-from-global-to-local.patch
ocfs2-solve-a-problem-of-crossing-the-boundary-in-updating-backups.patch

