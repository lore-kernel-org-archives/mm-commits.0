From: akpm@linux-foundation.org
Subject: + ocfs2-dlm-fix-bug-in-dlm_move_lockres_to_recovery_list.patch
 added to -mm tree
Date: Thu, 24 Sep 2015 14:10:49 -0700
Message-ID: <560466d9.6wkfSZZsz1wKkDXb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37357 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbbIXVKu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 24 Sep 2015 17:10:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jiangyiwen@huawei.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@suse.de, stable@vger.kernel.org, tariq.x.saeed@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: fix BUG in dlm_move_lockres_to_recovery_list
has been added to the -mm tree.  Its filename is
     ocfs2-dlm-fix-bug-in-dlm_move_lockres_to_recovery_list.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-dlm-fix-bug-in-dlm_move_lockres_to_recovery_list.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-dlm-fix-bug-in-dlm_move_lockres_to_recovery_list.patch

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
Subject: ocfs2/dlm: fix BUG in dlm_move_lockres_to_recovery_list

When master handles convert request, it queues ast first and then returns
status.  This may happen that the ast is sent before the request status
because the above two messages are sent by two threads.  And right after
the ast is sent, if master down, it may trigger BUG in
dlm_move_lockres_to_recovery_list in the requested node because ast
handler moves it to grant list without clear lock->convert_pending.  So
remove BUG_ON statement and check if the ast is processed in
dlmconvert_remote.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reported-by: Yiwen Jiang <jiangyiwen@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Tariq Saeed <tariq.x.saeed@oracle.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmconvert.c  |   13 +++++++++++++
 fs/ocfs2/dlm/dlmrecovery.c |    1 -
 2 files changed, 13 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/dlm/dlmconvert.c~ocfs2-dlm-fix-bug-in-dlm_move_lockres_to_recovery_list fs/ocfs2/dlm/dlmconvert.c
--- a/fs/ocfs2/dlm/dlmconvert.c~ocfs2-dlm-fix-bug-in-dlm_move_lockres_to_recovery_list
+++ a/fs/ocfs2/dlm/dlmconvert.c
@@ -288,6 +288,19 @@ enum dlm_status dlmconvert_remote(struct
 		status = DLM_DENIED;
 		goto bail;
 	}
+
+	if (lock->ml.type == type && lock->ml.convert_type == LKM_IVMODE) {
+		mlog(0, "last convert request returned DLM_RECOVERING, but "
+		     "owner has already queued and sent ast to me. res %.*s, "
+		     "(cookie=%u:%llu, type=%d, conv=%d)\n",
+		     res->lockname.len, res->lockname.name,
+		     dlm_get_lock_cookie_node(be64_to_cpu(lock->ml.cookie)),
+		     dlm_get_lock_cookie_seq(be64_to_cpu(lock->ml.cookie)),
+		     lock->ml.type, lock->ml.convert_type);
+		status = DLM_NORMAL;
+		goto bail;
+	}
+
 	res->state |= DLM_LOCK_RES_IN_PROGRESS;
 	/* move lock to local convert queue */
 	/* do not alter lock refcount.  switching lists. */
diff -puN fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-fix-bug-in-dlm_move_lockres_to_recovery_list fs/ocfs2/dlm/dlmrecovery.c
--- a/fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-fix-bug-in-dlm_move_lockres_to_recovery_list
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -2064,7 +2064,6 @@ void dlm_move_lockres_to_recovery_list(s
 			dlm_lock_get(lock);
 			if (lock->convert_pending) {
 				/* move converting lock back to granted */
-				BUG_ON(i != DLM_CONVERTING_LIST);
 				mlog(0, "node died with convert pending "
 				     "on %.*s. move back to granted list.\n",
 				     res->lockname.len, res->lockname.name);
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

ocfs2-dlm-fix-deadlock-when-dispatch-assert-master.patch
ocfs2-dlm-fix-race-between-convert-and-recovery.patch
ocfs2-dlm-fix-race-between-convert-and-recovery-v2.patch
ocfs2-dlm-fix-race-between-convert-and-recovery-v3.patch
ocfs2-dlm-fix-bug-in-dlm_move_lockres_to_recovery_list.patch
ocfs2-improve-performance-for-localalloc.patch

