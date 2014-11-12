From: akpm@linux-foundation.org
Subject: +
 ocfs2-do-not-set-ocfs2_lock_upconvert_finishing-if-nonblocking-lock-can-not-be-granted-at-once.patch added to -mm tree
Date: Tue, 11 Nov 2014 16:13:26 -0800
Message-ID: <5462a626.lSlb5A3cmrPhh4Mo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57546 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbaKLAN1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Nov 2014 19:13:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xuejiufei@huawei.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: do not set OCFS2_LOCK_UPCONVERT_FINISHING if nonblocking lock can not be granted at once
has been added to the -mm tree.  Its filename is
     ocfs2-do-not-set-ocfs2_lock_upconvert_finishing-if-nonblocking-lock-can-not-be-granted-at-once.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-do-not-set-ocfs2_lock_upconvert_finishing-if-nonblocking-lock-can-not-be-granted-at-once.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-do-not-set-ocfs2_lock_upconvert_finishing-if-nonblocking-lock-can-not-be-granted-at-once.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xue jiufei <xuejiufei@huawei.com>
Subject: ocfs2: do not set OCFS2_LOCK_UPCONVERT_FINISHING if nonblocking lock can not be granted at once

ocfs2_readpages() use nonblocking flag to avoid page lock inversion.  It
will trigger cluster hang because that flag OCFS2_LOCK_UPCONVERT_FINISHING
is not cleared if nonblocking lock cannot be granted at once.  The flag
would prevent dc thread from downconverting.  So other nodes cannot
acheive this lockres for ever.

So we should not set OCFS2_LOCK_UPCONVERT_FINISHING when receiving ast if
nonblocking lock had already returned.

Signed-off-by: joyce.xue <xuejiufei@huawei.com>
Reviewed-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmglue.c |   37 +++++++++++++++++++++++++++++++------
 fs/ocfs2/ocfs2.h   |    6 ++++++
 2 files changed, 37 insertions(+), 6 deletions(-)

diff -puN fs/ocfs2/dlmglue.c~ocfs2-do-not-set-ocfs2_lock_upconvert_finishing-if-nonblocking-lock-can-not-be-granted-at-once fs/ocfs2/dlmglue.c
--- a/fs/ocfs2/dlmglue.c~ocfs2-do-not-set-ocfs2_lock_upconvert_finishing-if-nonblocking-lock-can-not-be-granted-at-once
+++ a/fs/ocfs2/dlmglue.c
@@ -861,8 +861,13 @@ static inline void ocfs2_generic_handle_
 	 * We set the OCFS2_LOCK_UPCONVERT_FINISHING flag before clearing
 	 * the OCFS2_LOCK_BUSY flag to prevent the dc thread from
 	 * downconverting the lock before the upconvert has fully completed.
+	 * Do not prevent the dc thread from downconverting if NONBLOCK lock
+	 * had already returned.
 	 */
-	lockres_or_flags(lockres, OCFS2_LOCK_UPCONVERT_FINISHING);
+	if (!(lockres->l_flags & OCFS2_LOCK_NONBLOCK_FINISHED))
+		lockres_or_flags(lockres, OCFS2_LOCK_UPCONVERT_FINISHING);
+	else
+		lockres_clear_flags(lockres, OCFS2_LOCK_NONBLOCK_FINISHED);
 
 	lockres_clear_flags(lockres, OCFS2_LOCK_BUSY);
 }
@@ -1324,13 +1329,12 @@ static void lockres_add_mask_waiter(stru
 
 /* returns 0 if the mw that was removed was already satisfied, -EBUSY
  * if the mask still hadn't reached its goal */
-static int lockres_remove_mask_waiter(struct ocfs2_lock_res *lockres,
+static int __lockres_remove_mask_waiter(struct ocfs2_lock_res *lockres,
 				      struct ocfs2_mask_waiter *mw)
 {
-	unsigned long flags;
 	int ret = 0;
 
-	spin_lock_irqsave(&lockres->l_lock, flags);
+	assert_spin_locked(&lockres->l_lock);
 	if (!list_empty(&mw->mw_item)) {
 		if ((lockres->l_flags & mw->mw_mask) != mw->mw_goal)
 			ret = -EBUSY;
@@ -1338,6 +1342,18 @@ static int lockres_remove_mask_waiter(st
 		list_del_init(&mw->mw_item);
 		init_completion(&mw->mw_complete);
 	}
+
+	return ret;
+}
+
+static int lockres_remove_mask_waiter(struct ocfs2_lock_res *lockres,
+				      struct ocfs2_mask_waiter *mw)
+{
+	unsigned long flags;
+	int ret = 0;
+
+	spin_lock_irqsave(&lockres->l_lock, flags);
+	ret = __lockres_remove_mask_waiter(lockres, mw);
 	spin_unlock_irqrestore(&lockres->l_lock, flags);
 
 	return ret;
@@ -1373,6 +1389,7 @@ static int __ocfs2_cluster_lock(struct o
 	unsigned long flags;
 	unsigned int gen;
 	int noqueue_attempted = 0;
+	int dlm_locked = 0;
 
 	ocfs2_init_mask_waiter(&mw);
 
@@ -1481,6 +1498,7 @@ again:
 			ocfs2_recover_from_dlm_error(lockres, 1);
 			goto out;
 		}
+		dlm_locked = 1;
 
 		mlog(0, "lock %s, successful return from ocfs2_dlm_lock\n",
 		     lockres->l_name);
@@ -1514,10 +1532,17 @@ out:
 	if (wait && arg_flags & OCFS2_LOCK_NONBLOCK &&
 	    mw.mw_mask & (OCFS2_LOCK_BUSY|OCFS2_LOCK_BLOCKED)) {
 		wait = 0;
-		if (lockres_remove_mask_waiter(lockres, &mw))
+		spin_lock_irqsave(&lockres->l_lock, flags);
+		if (__lockres_remove_mask_waiter(lockres, &mw)) {
+			if (dlm_locked)
+				lockres_or_flags(lockres,
+					OCFS2_LOCK_NONBLOCK_FINISHED);
+			spin_unlock_irqrestore(&lockres->l_lock, flags);
 			ret = -EAGAIN;
-		else
+		} else {
+			spin_unlock_irqrestore(&lockres->l_lock, flags);
 			goto again;
+		}
 	}
 	if (wait) {
 		ret = ocfs2_wait_for_mask(&mw);
diff -puN fs/ocfs2/ocfs2.h~ocfs2-do-not-set-ocfs2_lock_upconvert_finishing-if-nonblocking-lock-can-not-be-granted-at-once fs/ocfs2/ocfs2.h
--- a/fs/ocfs2/ocfs2.h~ocfs2-do-not-set-ocfs2_lock_upconvert_finishing-if-nonblocking-lock-can-not-be-granted-at-once
+++ a/fs/ocfs2/ocfs2.h
@@ -144,6 +144,12 @@ enum ocfs2_unlock_action {
 						     * before the upconvert
 						     * has completed */
 
+#define OCFS2_LOCK_NONBLOCK_FINISHED (0x00001000) /* NONBLOCK cluster
+						   * lock has already
+						   * returned, do not block
+						   * dc thread from
+						   * downconverting */
+
 struct ocfs2_lock_res_ops;
 
 typedef void (*ocfs2_lock_callback)(int status, unsigned long data);
_

Patches currently in -mm which might be from xuejiufei@huawei.com are

ocfs2-do-not-set-ocfs2_lock_upconvert_finishing-if-nonblocking-lock-can-not-be-granted-at-once.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
ocfs2-dlm-fix-race-between-dispatched_work-and-dlm_lockres_grab_inflight_worker.patch

