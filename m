From: akpm@linux-foundation.org
Subject: + ipcsem-fine-grained-locking-for-semtimedop-fix-fix.patch added to -mm tree
Date: Mon, 25 Mar 2013 14:03:41 -0700
Message-ID: <20130325210341.709935A4016@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:61170 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455Ab3CYVDm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Mar 2013 17:03:42 -0400
Received: by mail-ye0-f201.google.com with SMTP id m2so217902yen.2
        for <mm-commits@vger.kernel.org>; Mon, 25 Mar 2013 14:03:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@surriel.com, riel@redhat.com, sasha.levin@oracle.com


The patch titled
     Subject: ipc,sem: fix lockdep false positive
has been added to the -mm tree.  Its filename is
     ipcsem-fine-grained-locking-for-semtimedop-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rik van Riel <riel@surriel.com>
Subject: ipc,sem: fix lockdep false positive

When locking all the semaphores inside a sem_array, the kernel ends up
locking a large number of locks with identical lockdep status. This
trips up lockdep.  Annotate the code to prevent such warnings.

Signed-off-by: Rik van Riel <riel@redhat.com>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN ipc/sem.c~ipcsem-fine-grained-locking-for-semtimedop-fix-fix ipc/sem.c
--- a/ipc/sem.c~ipcsem-fine-grained-locking-for-semtimedop-fix-fix
+++ a/ipc/sem.c
@@ -227,7 +227,7 @@ static inline int sem_lock(struct sem_ar
 		spin_lock(&sma->sem_perm.lock);
 		for (i = 0; i < sma->sem_nsems; i++) {
 			struct sem *sem = sma->sem_base + i;
-			spin_lock(&sem->lock);
+			spin_lock_nested(&sem->lock, SINGLE_DEPTH_NESTING);
 		}
 		locknum = -1;
 	}
@@ -426,7 +426,7 @@ static int newary(struct ipc_namespace *
 	for (i = 0; i < nsems; i++) {
 		INIT_LIST_HEAD(&sma->sem_base[i].sem_pending);
 		spin_lock_init(&sma->sem_base[i].lock);
-		spin_lock(&sma->sem_base[i].lock);
+		spin_lock_nested(&sma->sem_base[i].lock, SINGLE_DEPTH_NESTING);
 	}
 
 	sma->complex_count = 0;
_

Patches currently in -mm which might be from riel@surriel.com are

ipcsem-open-code-and-rename-sem_lock.patch
ipcsem-open-code-and-rename-sem_lock-fix.patch
ipcsem-have-only-one-list-in-struct-sem_queue.patch
ipcsem-fine-grained-locking-for-semtimedop.patch
ipcsem-fine-grained-locking-for-semtimedop-fix.patch
ipcsem-fine-grained-locking-for-semtimedop-fix-fix.patch

