From: akpm@linux-foundation.org
Subject: + ipcsem-fine-grained-locking-for-semtimedop-fix-fix.patch added to -mm tree
Date: Tue, 26 Mar 2013 11:36:17 -0700
Message-ID: <20130326183617.C80CF31C2E2@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:41205 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248Ab3CZSgS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Mar 2013 14:36:18 -0400
Received: by mail-qa0-f73.google.com with SMTP id hg5so69651qab.2
        for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2013 11:36:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davidlohr.bueso@hp.com, riel@redhat.com


The patch titled
     Subject: ipc, sem: prevent possible deadlock
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
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: ipc, sem: prevent possible deadlock

In semctl_main(), when cmd == GETALL, we're locking sma->sem_perm.lock
(through sem_lock_and_putref), yet after the conditional, we lock it
again.  Unlock sma right after exiting the conditional.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN ipc/sem.c~ipcsem-fine-grained-locking-for-semtimedop-fix-fix ipc/sem.c
--- a/ipc/sem.c~ipcsem-fine-grained-locking-for-semtimedop-fix-fix
+++ a/ipc/sem.c
@@ -1115,6 +1115,7 @@ static int semctl_main(struct ipc_namesp
 				err = -EIDRM;
 				goto out_free;
 			}
+			sem_unlock(sma, -1);
 		}
 
 		sem_lock(sma, NULL, -1);
_

Patches currently in -mm which might be from davidlohr.bueso@hp.com are

lib-int_sqrtc-optimize-square-root-algorithm.patch
ipc-remove-bogus-lock-comment-for-ipc_checkid.patch
ipc-introduce-obtaining-a-lockless-ipc-object.patch
ipc-introduce-obtaining-a-lockless-ipc-object-fix.patch
ipc-introduce-lockless-pre_down-ipcctl.patch
ipcsem-do-not-hold-ipc-lock-more-than-necessary.patch
ipcsem-open-code-and-rename-sem_lock.patch
ipcsem-open-code-and-rename-sem_lock-fix.patch
ipcsem-have-only-one-list-in-struct-sem_queue.patch
ipcsem-fine-grained-locking-for-semtimedop.patch
ipcsem-fine-grained-locking-for-semtimedop-fix-fix.patch

