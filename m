From: akpm@linux-foundation.org
Subject: + ocfs2-dlm-fix-race-between-convert-and-recovery-v2.patch added
 to -mm tree
Date: Fri, 18 Sep 2015 12:59:41 -0700
Message-ID: <55fc6d2d.vY24MB1lP6bR7hgL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48078 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134AbbIRT7m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Sep 2015 15:59:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jiangyiwen@huawei.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@suse.de, tariq.x.saeed@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-dlm-fix-race-between-convert-and-recovery-v2
has been added to the -mm tree.  Its filename is
     ocfs2-dlm-fix-race-between-convert-and-recovery-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-dlm-fix-race-between-convert-and-recovery-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-dlm-fix-race-between-convert-and-recovery-v2.patch

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
Subject: ocfs2-dlm-fix-race-between-convert-and-recovery-v2

changelog since v1:
Clean up convert_pending since it is now useless.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reported-by: Yiwen Jiang <jiangyiwen@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Tariq Saeed <tariq.x.saeed@oracle.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmcommon.h  |    1 -
 fs/ocfs2/dlm/dlmconvert.c |    2 --
 fs/ocfs2/dlm/dlmdebug.c   |    7 +++----
 fs/ocfs2/dlm/dlmlock.c    |    1 -
 4 files changed, 3 insertions(+), 8 deletions(-)

diff -puN fs/ocfs2/dlm/dlmcommon.h~ocfs2-dlm-fix-race-between-convert-and-recovery-v2 fs/ocfs2/dlm/dlmcommon.h
--- a/fs/ocfs2/dlm/dlmcommon.h~ocfs2-dlm-fix-race-between-convert-and-recovery-v2
+++ a/fs/ocfs2/dlm/dlmcommon.h
@@ -369,7 +369,6 @@ struct dlm_lock
 	struct dlm_lockstatus *lksb;
 	unsigned ast_pending:1,
 		 bast_pending:1,
-		 convert_pending:1,
 		 lock_pending:1,
 		 cancel_pending:1,
 		 unlock_pending:1,
diff -puN fs/ocfs2/dlm/dlmconvert.c~ocfs2-dlm-fix-race-between-convert-and-recovery-v2 fs/ocfs2/dlm/dlmconvert.c
--- a/fs/ocfs2/dlm/dlmconvert.c~ocfs2-dlm-fix-race-between-convert-and-recovery-v2
+++ a/fs/ocfs2/dlm/dlmconvert.c
@@ -291,7 +291,6 @@ enum dlm_status dlmconvert_remote(struct
 	/* move lock to local convert queue */
 	/* do not alter lock refcount.  switching lists. */
 	list_move_tail(&lock->list, &res->converting);
-	lock->convert_pending = 1;
 	lock->ml.convert_type = type;
 
 	if (flags & LKM_VALBLK) {
@@ -315,7 +314,6 @@ enum dlm_status dlmconvert_remote(struct
 
 	spin_lock(&res->spinlock);
 	res->state &= ~DLM_LOCK_RES_IN_PROGRESS;
-	lock->convert_pending = 0;
 	/* if it failed, move it back to granted queue */
 	if (status != DLM_NORMAL) {
 		if (status != DLM_NOTQUEUED)
diff -puN fs/ocfs2/dlm/dlmdebug.c~ocfs2-dlm-fix-race-between-convert-and-recovery-v2 fs/ocfs2/dlm/dlmdebug.c
--- a/fs/ocfs2/dlm/dlmdebug.c~ocfs2-dlm-fix-race-between-convert-and-recovery-v2
+++ a/fs/ocfs2/dlm/dlmdebug.c
@@ -77,7 +77,7 @@ static void __dlm_print_lock(struct dlm_
 
 	printk("    type=%d, conv=%d, node=%u, cookie=%u:%llu, "
 	       "ref=%u, ast=(empty=%c,pend=%c), bast=(empty=%c,pend=%c), "
-	       "pending=(conv=%c,lock=%c,cancel=%c,unlock=%c)\n",
+	       "pending=(lock=%c,cancel=%c,unlock=%c)\n",
 	       lock->ml.type, lock->ml.convert_type, lock->ml.node,
 	       dlm_get_lock_cookie_node(be64_to_cpu(lock->ml.cookie)),
 	       dlm_get_lock_cookie_seq(be64_to_cpu(lock->ml.cookie)),
@@ -86,7 +86,6 @@ static void __dlm_print_lock(struct dlm_
 	       (lock->ast_pending ? 'y' : 'n'),
 	       (list_empty(&lock->bast_list) ? 'y' : 'n'),
 	       (lock->bast_pending ? 'y' : 'n'),
-	       (lock->convert_pending ? 'y' : 'n'),
 	       (lock->lock_pending ? 'y' : 'n'),
 	       (lock->cancel_pending ? 'y' : 'n'),
 	       (lock->unlock_pending ? 'y' : 'n'));
@@ -502,7 +501,7 @@ static int dump_lock(struct dlm_lock *lo
 
 #define DEBUG_LOCK_VERSION	1
 	spin_lock(&lock->spinlock);
-	out = snprintf(buf, len, "LOCK:%d,%d,%d,%d,%d,%d:%lld,%d,%d,%d,%d,%d,"
+	out = snprintf(buf, len, "LOCK:%d,%d,%d,%d,%d,%d:%lld,%d,%d,%d,%d,"
 		       "%d,%d,%d,%d\n",
 		       DEBUG_LOCK_VERSION,
 		       list_type, lock->ml.type, lock->ml.convert_type,
@@ -512,7 +511,7 @@ static int dump_lock(struct dlm_lock *lo
 		       !list_empty(&lock->ast_list),
 		       !list_empty(&lock->bast_list),
 		       lock->ast_pending, lock->bast_pending,
-		       lock->convert_pending, lock->lock_pending,
+		       lock->lock_pending,
 		       lock->cancel_pending, lock->unlock_pending,
 		       atomic_read(&lock->lock_refs.refcount));
 	spin_unlock(&lock->spinlock);
diff -puN fs/ocfs2/dlm/dlmlock.c~ocfs2-dlm-fix-race-between-convert-and-recovery-v2 fs/ocfs2/dlm/dlmlock.c
--- a/fs/ocfs2/dlm/dlmlock.c~ocfs2-dlm-fix-race-between-convert-and-recovery-v2
+++ a/fs/ocfs2/dlm/dlmlock.c
@@ -411,7 +411,6 @@ static void dlm_init_lock(struct dlm_loc
 	newlock->ml.cookie = cpu_to_be64(cookie);
 	newlock->ast_pending = 0;
 	newlock->bast_pending = 0;
-	newlock->convert_pending = 0;
 	newlock->lock_pending = 0;
 	newlock->unlock_pending = 0;
 	newlock->cancel_pending = 0;
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

ocfs2-dlm-fix-race-between-convert-and-recovery.patch
ocfs2-dlm-fix-race-between-convert-and-recovery-v2.patch
ocfs2-dlm-fix-deadlock-when-dispatch-assert-master.patch

