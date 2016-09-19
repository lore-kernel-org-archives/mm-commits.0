From: akpm@linux-foundation.org
Subject: [patch 02/20] ocfs2/dlm: fix race between convert and migration
Date: Mon, 19 Sep 2016 14:43:55 -0700
Message-ID: <57e05c1b.l0p+ArbpbFgPqP06%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52786 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932199AbcISVn4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Sep 2016 17:43:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, joseph.qi@huawei.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@suse.de, piaojun@huawei.com, stable@vger.kernel.org

From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2/dlm: fix race between convert and migration

Commit ac7cf246dfdb ("ocfs2/dlm: fix race between convert and recovery")
checks if lockres master has changed to identify whether new master has
finished recovery or not.  This will introduce a race that right after old
master does umount ( means master will change), a new convert request
comes.

In this case, it will reset lockres state to DLM_RECOVERING and then retry
convert, and then fail with lockres->l_action being set to
OCFS2_AST_INVALID, which will cause inconsistent lock level between ocfs2
and dlm, and then finally BUG.

Since dlm recovery will clear lock->convert_pending in
dlm_move_lockres_to_recovery_list, we can use it to correctly identify the
race case between convert and recovery.  So fix it.

Fixes: ac7cf246dfdb ("ocfs2/dlm: fix race between convert and recovery")
Link: http://lkml.kernel.org/r/57CE1569.8010704@huawei.com
Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Jun Piao <piaojun@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmconvert.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/ocfs2/dlm/dlmconvert.c~ocfs2-dlm-fix-race-between-convert-and-migration fs/ocfs2/dlm/dlmconvert.c
--- a/fs/ocfs2/dlm/dlmconvert.c~ocfs2-dlm-fix-race-between-convert-and-migration
+++ a/fs/ocfs2/dlm/dlmconvert.c
@@ -268,7 +268,6 @@ enum dlm_status dlmconvert_remote(struct
 				  struct dlm_lock *lock, int flags, int type)
 {
 	enum dlm_status status;
-	u8 old_owner = res->owner;
 
 	mlog(0, "type=%d, convert_type=%d, busy=%d\n", lock->ml.type,
 	     lock->ml.convert_type, res->state & DLM_LOCK_RES_IN_PROGRESS);
@@ -335,7 +334,6 @@ enum dlm_status dlmconvert_remote(struct
 
 	spin_lock(&res->spinlock);
 	res->state &= ~DLM_LOCK_RES_IN_PROGRESS;
-	lock->convert_pending = 0;
 	/* if it failed, move it back to granted queue.
 	 * if master returns DLM_NORMAL and then down before sending ast,
 	 * it may have already been moved to granted queue, reset to
@@ -344,12 +342,14 @@ enum dlm_status dlmconvert_remote(struct
 		if (status != DLM_NOTQUEUED)
 			dlm_error(status);
 		dlm_revert_pending_convert(res, lock);
-	} else if ((res->state & DLM_LOCK_RES_RECOVERING) ||
-			(old_owner != res->owner)) {
-		mlog(0, "res %.*s is in recovering or has been recovered.\n",
-				res->lockname.len, res->lockname.name);
+	} else if (!lock->convert_pending) {
+		mlog(0, "%s: res %.*s, owner died and lock has been moved back "
+				"to granted list, retry convert.\n",
+				dlm->name, res->lockname.len, res->lockname.name);
 		status = DLM_RECOVERING;
 	}
+
+	lock->convert_pending = 0;
 bail:
 	spin_unlock(&res->spinlock);
 
_
