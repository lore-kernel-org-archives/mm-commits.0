From: akpm@linux-foundation.org
Subject: + ipcsem-fine-grained-locking-for-semtimedop-fix.patch added to -mm tree
Date: Mon, 25 Mar 2013 13:01:06 -0700
Message-ID: <20130325200106.7004D31C174@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:53296 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab3CYUBH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Mar 2013 16:01:07 -0400
Received: by mail-qe0-f73.google.com with SMTP id a11so655817qen.0
        for <mm-commits@vger.kernel.org>; Mon, 25 Mar 2013 13:01:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@surriel.com, riel@redhat.com, walken@google.com


The patch titled
     Subject: fix for sem_lock
has been added to the -mm tree.  Its filename is
     ipcsem-fine-grained-locking-for-semtimedop-fix.patch

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
Subject: fix for sem_lock

Fix a typo in sem_lock.  Of course we need to unlock the local
semaphore lock before jumping to lock_all, in the rare case that
somebody started a complex operation while we were spinning on
the spinlock.

Can be folded into patch 7/7 before merging

Signed-off-by: Rik van Riel <riel@redhat.com>
Reported-by: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN ipc/sem.c~ipcsem-fine-grained-locking-for-semtimedop-fix ipc/sem.c
--- a/ipc/sem.c~ipcsem-fine-grained-locking-for-semtimedop-fix
+++ a/ipc/sem.c
@@ -216,7 +216,7 @@ static inline int sem_lock(struct sem_ar
 		 * we may need to look at things we did not lock here.
 		 */
 		if (unlikely(sma->complex_count)) {
-			spin_unlock(&sma->sem_perm.lock);
+			spin_unlock(&sem->lock);
 			goto lock_all;
 		}
 		locknum = sops->sem_num;
_

Patches currently in -mm which might be from riel@surriel.com are

ipcsem-open-code-and-rename-sem_lock.patch
ipcsem-open-code-and-rename-sem_lock-fix.patch
ipcsem-have-only-one-list-in-struct-sem_queue.patch
ipcsem-fine-grained-locking-for-semtimedop.patch
ipcsem-fine-grained-locking-for-semtimedop-fix.patch

