From: akpm@linux-foundation.org
Subject: +
 ocfs2-check-if-the-ocfs2-lock-resource-be-initialized-before-calling-ocfs2_dlm_lock.patch added to -mm tree
Date: Tue, 31 Mar 2015 15:13:56 -0700
Message-ID: <551b1c24.+gLkyQLeQi397h8V%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54475 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbbCaWN5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Mar 2015 18:13:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.chen@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.com, xuejiufei@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: check if the ocfs2 lock resource has been initialized before calling ocfs2_dlm_lock
has been added to the -mm tree.  Its filename is
     ocfs2-check-if-the-ocfs2-lock-resource-be-initialized-before-calling-ocfs2_dlm_lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-check-if-the-ocfs2-lock-resource-be-initialized-before-calling-ocfs2_dlm_lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-check-if-the-ocfs2-lock-resource-be-initialized-before-calling-ocfs2_dlm_lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: alex chen <alex.chen@huawei.com>
Subject: ocfs2: check if the ocfs2 lock resource has been initialized before calling ocfs2_dlm_lock

If ocfs2 lockres has not been initialized before calling ocfs2_dlm_lock,
the lock won't be dropped and then will lead umount hung.  The case is
described below:

ocfs2_mknod
    ocfs2_mknod_locked
        __ocfs2_mknod_locked
            ocfs2_journal_access_di
            Failed because of -ENOMEM or other reasons, the inode lockres
            has not been initialized yet.

    iput(inode)
        ocfs2_evict_inode
            ocfs2_delete_inode
                ocfs2_inode_lock
                    ocfs2_inode_lock_full_nested
                        __ocfs2_cluster_lock
                        Succeeds and allocates a new dlm lockres.
            ocfs2_clear_inode
                ocfs2_open_unlock
                    ocfs2_drop_inode_locks
                        ocfs2_drop_lock
                        Since lockres has not been initialized, the lock
                        can't be dropped and the lockres can't be
                        migrated, thus umount will hang forever.

Signed-off-by: Alex Chen <alex.chen@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: joyce.xue <xuejiufei@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmglue.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN fs/ocfs2/dlmglue.c~ocfs2-check-if-the-ocfs2-lock-resource-be-initialized-before-calling-ocfs2_dlm_lock fs/ocfs2/dlmglue.c
--- a/fs/ocfs2/dlmglue.c~ocfs2-check-if-the-ocfs2-lock-resource-be-initialized-before-calling-ocfs2_dlm_lock
+++ a/fs/ocfs2/dlmglue.c
@@ -1391,6 +1391,11 @@ static int __ocfs2_cluster_lock(struct o
 	int noqueue_attempted = 0;
 	int dlm_locked = 0;
 
+	if (!(lockres->l_flags & OCFS2_LOCK_INITIALIZED)) {
+		mlog_errno(-EINVAL);
+		return -EINVAL;
+	}
+
 	ocfs2_init_mask_waiter(&mw);
 
 	if (lockres->l_ops->flags & LOCK_TYPE_USES_LVB)
_

Patches currently in -mm which might be from alex.chen@huawei.com are

ocfs2-check-if-the-ocfs2-lock-resource-be-initialized-before-calling-ocfs2_dlm_lock.patch
ocfs2-make-mlog_errno-return-the-errno.patch

