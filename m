From: akpm@linux-foundation.org
Subject: [failures] ipcsem-fine-grained-locking-for-semtimedop-fix-fix.patch removed from -mm tree
Date: Mon, 25 Mar 2013 14:58:57 -0700
Message-ID: <20130325215858.31A9631C1DB@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:49491 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758663Ab3CYV67 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Mar 2013 17:58:59 -0400
Received: by mail-qe0-f73.google.com with SMTP id a11so668430qen.2
        for <mm-commits@vger.kernel.org>; Mon, 25 Mar 2013 14:58:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@surriel.com, riel@redhat.com, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc,sem: fix lockdep false positive
has been removed from the -mm tree.  Its filename was
     ipcsem-fine-grained-locking-for-semtimedop-fix-fix.patch

This patch was dropped because it had testing failures

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

