From: akpm@linux-foundation.org
Subject: + ocfs2-dlm-fix-race-between-convert-and-recovery.patch added to
 -mm tree
Date: Thu, 17 Sep 2015 13:33:36 -0700
Message-ID: <55fb23a0.Xcbsfxb+ttC6an3D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44961 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbbIQUdh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Sep 2015 16:33:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jiangyiwen@huawei.com, jlbec@evilplan.org, mfasheh@suse.de, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: fix race between convert and recovery
has been added to the -mm tree.  Its filename is
     ocfs2-dlm-fix-race-between-convert-and-recovery.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-dlm-fix-race-between-convert-and-recovery.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-dlm-fix-race-between-convert-and-recovery.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2/dlm: fix race between convert and recovery

There is a race window between dlmconvert_remote and
dlm_move_lockres_to_recovery_list, which will cause a lock with
OCFS2_LOCK_BUSY in grant list, thus system hangs.

dlmconvert_remote
{
	spin_lock(&res->spinlock);
	list_move_tail(&lock->list, &res->converting);
	lock->convert_pending = 1;
	spin_unlock(&res->spinlock);

	status = dlm_send_remote_convert_request();
	>>>>>> race window, master has queued ast and return DLM_NORMAL,
	       and then down before sending ast.
	       this node detects master down and call
	       dlm_move_lockres_to_recovery_list, which will revert the
	       lock to grant list.
	       Then OCFS2_LOCK_BUSY won't be cleared as new master won't
	       send ast any more because it thinks already be authorized.

	spin_lock(&res->spinlock);
	lock->convert_pending = 0;
	if (status != DLM_NORMAL)
		dlm_revert_pending_convert(res, lock);
	spin_unlock(&res->spinlock);
}

In this case, just leave it in convert list and new master will take care
of it after recovery.  And if convert request returns other than
DLM_NORMAL, convert thread will do the revert itself.  So remove the
revert logic in dlm_move_lockres_to_recovery_list.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reported-by: Yiwen Jiang <jiangyiwen@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmrecovery.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff -puN fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-fix-race-between-convert-and-recovery fs/ocfs2/dlm/dlmrecovery.c
--- a/fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-fix-race-between-convert-and-recovery
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -2058,15 +2058,7 @@ void dlm_move_lockres_to_recovery_list(s
 		queue = dlm_list_idx_to_ptr(res, i);
 		list_for_each_entry_safe(lock, next, queue, list) {
 			dlm_lock_get(lock);
-			if (lock->convert_pending) {
-				/* move converting lock back to granted */
-				BUG_ON(i != DLM_CONVERTING_LIST);
-				mlog(0, "node died with convert pending "
-				     "on %.*s. move back to granted list.\n",
-				     res->lockname.len, res->lockname.name);
-				dlm_revert_pending_convert(res, lock);
-				lock->convert_pending = 0;
-			} else if (lock->lock_pending) {
+			if (lock->lock_pending) {
 				/* remove pending lock requests completely */
 				BUG_ON(i != DLM_BLOCKED_LIST);
 				mlog(0, "node died with lock pending "
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

ocfs2-dlm-fix-race-between-convert-and-recovery.patch

