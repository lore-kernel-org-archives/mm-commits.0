From: akpm@linux-foundation.org
Subject: + ocfs2-dlm-optimization-of-code-while-free-dead-node-locks.patch added to -mm tree
Date: Tue, 17 Jan 2017 12:45:37 -0800
Message-ID: <587e8271.fXxs4FOrtBDzWPk0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39100 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751268AbdAQUpn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jan 2017 15:45:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guozhonghua@h3c.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: optimize freeing of dead node locks
has been added to the -mm tree.  Its filename is
     ocfs2-dlm-optimization-of-code-while-free-dead-node-locks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-dlm-optimization-of-code-while-free-dead-node-locks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-dlm-optimization-of-code-while-free-dead-node-locks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Guozhonghua <guozhonghua@h3c.com>
Subject: ocfs2/dlm: optimize freeing of dead node locks

Three loops can be optimized into one and its sub loops, so less code can
do the same work.

Link: http://lkml.kernel.org/r/71604351584F6A4EBAE558C676F37CA4C4AF898E@H3CMLB12-EX.srv.huawei-3com.com
Signed-off-by: Guozhonghua <guozhonghua@h3c.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmrecovery.c |   39 ++++++++++++-----------------------
 1 file changed, 14 insertions(+), 25 deletions(-)

diff -puN fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-optimization-of-code-while-free-dead-node-locks fs/ocfs2/dlm/dlmrecovery.c
--- a/fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-optimization-of-code-while-free-dead-node-locks
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -2268,6 +2268,8 @@ static void dlm_free_dead_locks(struct d
 {
 	struct dlm_lock *lock, *next;
 	unsigned int freed = 0;
+       struct list_head *queue = NULL;
+       int i;
 
 	/* this node is the lockres master:
 	 * 1) remove any stale locks for the dead node
@@ -2280,31 +2282,18 @@ static void dlm_free_dead_locks(struct d
 	 * to force the DLM_UNLOCK_FREE_LOCK action so as to free the locks */
 
 	/* TODO: check pending_asts, pending_basts here */
-	list_for_each_entry_safe(lock, next, &res->granted, list) {
-		if (lock->ml.node == dead_node) {
-			list_del_init(&lock->list);
-			dlm_lock_put(lock);
-			/* Can't schedule DLM_UNLOCK_FREE_LOCK - do manually */
-			dlm_lock_put(lock);
-			freed++;
-		}
-	}
-	list_for_each_entry_safe(lock, next, &res->converting, list) {
-		if (lock->ml.node == dead_node) {
-			list_del_init(&lock->list);
-			dlm_lock_put(lock);
-			/* Can't schedule DLM_UNLOCK_FREE_LOCK - do manually */
-			dlm_lock_put(lock);
-			freed++;
-		}
-	}
-	list_for_each_entry_safe(lock, next, &res->blocked, list) {
-		if (lock->ml.node == dead_node) {
-			list_del_init(&lock->list);
-			dlm_lock_put(lock);
-			/* Can't schedule DLM_UNLOCK_FREE_LOCK - do manually */
-			dlm_lock_put(lock);
-			freed++;
+       for (i = DLM_GRANTED_LIST; i <= DLM_BLOCKED_LIST; i++) {
+               queue = dlm_list_idx_to_ptr(res, i);
+               list_for_each_entry_safe(lock, next, queue, list) {
+                       if (lock->ml.node == dead_node) {
+                               list_del_init(&lock->list);
+                               dlm_lock_put(lock);
+                               /* Can't schedule DLM_UNLOCK_FREE_LOCK
+                                * do manually
+                                */
+                               dlm_lock_put(lock);
+                               freed++;
+                       }
 		}
 	}
 
_

Patches currently in -mm which might be from guozhonghua@h3c.com are

ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks.patch

