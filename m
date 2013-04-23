From: akpm@linux-foundation.org
Subject: + ipcsem-fine-grained-locking-for-semtimedop-do-not-call-sem_lock-when-bogus-sma.patch added to -mm tree
Date: Tue, 23 Apr 2013 12:38:38 -0700
Message-ID: <20130423193838.76B4631C034@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:61622 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab3DWTij (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Apr 2013 15:38:39 -0400
Received: by mail-gg0-f202.google.com with SMTP id 4so107547ggm.1
        for <mm-commits@vger.kernel.org>; Tue, 23 Apr 2013 12:38:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davidlohr.bueso@hp.com, benisty.e@gmail.com, riel@surriel.com


The patch titled
     Subject: ipc, sem: do not call sem_lock when bogus sma
has been added to the -mm tree.  Its filename is
     ipcsem-fine-grained-locking-for-semtimedop-do-not-call-sem_lock-when-bogus-sma.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: ipc, sem: do not call sem_lock when bogus sma

In exit_sem() we attempt to acquire the sma->sem_perm.lock by calling
sem_lock() immediately after obtaining sma. However, if sma isn't valid,
then calling sem_lock() will tend to do bad things.

Move the sma error check right after the sem_obtain_object_check() call
instead.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Emmanuel Benisty <benisty.e@gmail.com>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN ipc/sem.c~ipcsem-fine-grained-locking-for-semtimedop-do-not-call-sem_lock-when-bogus-sma ipc/sem.c
--- a/ipc/sem.c~ipcsem-fine-grained-locking-for-semtimedop-do-not-call-sem_lock-when-bogus-sma
+++ a/ipc/sem.c
@@ -1763,8 +1763,7 @@ void exit_sem(struct task_struct *tsk)
 		struct sem_array *sma;
 		struct sem_undo *un;
 		struct list_head tasks;
-		int semid;
-		int i;
+		int semid, i;
 
 		rcu_read_lock();
 		un = list_entry_rcu(ulp->list_proc.next,
@@ -1780,12 +1779,13 @@ void exit_sem(struct task_struct *tsk)
 		}
 
 		sma = sem_obtain_object_check(tsk->nsproxy->ipc_ns, un->semid);
-		sem_lock(sma, NULL, -1);
-
 		/* exit_sem raced with IPC_RMID, nothing to do */
-		if (IS_ERR(sma))
+		if (IS_ERR(sma)) {
+			rcu_read_unlock();
 			continue;
+		}
 
+		sem_lock(sma, NULL, -1);
 		un = __lookup_undo(ulp, semid);
 		if (un == NULL) {
 			/* exit_sem raced with IPC_RMID+semget() that created
_

Patches currently in -mm which might be from davidlohr.bueso@hp.com are

linux-next.patch
lib-int_sqrtc-optimize-square-root-algorithm.patch
ipc-remove-bogus-lock-comment-for-ipc_checkid.patch
ipc-introduce-obtaining-a-lockless-ipc-object.patch
ipc-introduce-obtaining-a-lockless-ipc-object-fix.patch
ipc-introduce-lockless-pre_down-ipcctl.patch
ipcsem-do-not-hold-ipc-lock-more-than-necessary.patch
ipcsem-do-not-hold-ipc-lock-more-than-necessary-fix.patch
ipcsem-open-code-and-rename-sem_lock.patch
ipcsem-open-code-and-rename-sem_lock-fix.patch
ipcsem-have-only-one-list-in-struct-sem_queue.patch
ipcsem-fine-grained-locking-for-semtimedop.patch
ipcsem-fine-grained-locking-for-semtimedop-fix-fix.patch
ipcsem-fine-grained-locking-for-semtimedop-fix-locking-in-semctl_main.patch
ipcsem-fine-grained-locking-for-semtimedop-untangle-rcu-locking-with-find_alloc_undo.patch
ipcsem-fine-grained-locking-for-semtimedop-do-not-call-sem_lock-when-bogus-sma.patch
rbtree_test-add-extra-rbtree-integrity-check.patch
rbtree_test-add-__init-__exit-annotations.patch

