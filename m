From: akpm@linux-foundation.org
Subject: + ipcsem-fine-grained-locking-for-semtimedop-fix-locking-in-semctl_main.patch added to -mm tree
Date: Tue, 23 Apr 2013 12:30:32 -0700
Message-ID: <20130423193032.7112931C034@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:39556 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198Ab3DWTis (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Apr 2013 15:38:48 -0400
Received: by mail-qe0-f74.google.com with SMTP id a11so107154qen.3
        for <mm-commits@vger.kernel.org>; Tue, 23 Apr 2013 12:38:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@redhat.com, davidlohr.bueso@hp.com


The patch titled
     Subject: ipc,sem: fix locking in semctl_main
has been added to the -mm tree.  Its filename is
     ipcsem-fine-grained-locking-for-semtimedop-fix-locking-in-semctl_main.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rik van Riel <riel@redhat.com>
Subject: ipc,sem: fix locking in semctl_main

Everywhere else in the code, we check sma->sem_perm.deleted under
the semaphore array lock, so we should do teh same here.
The easy fix is to simply not drop and re-take the lock, but keep
it locked.

Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN ipc/sem.c~ipcsem-fine-grained-locking-for-semtimedop-fix-locking-in-semctl_main ipc/sem.c
--- a/ipc/sem.c~ipcsem-fine-grained-locking-for-semtimedop-fix-locking-in-semctl_main
+++ a/ipc/sem.c
@@ -1115,10 +1115,9 @@ static int semctl_main(struct ipc_namesp
 				err = -EIDRM;
 				goto out_free;
 			}
-			sem_unlock(sma, -1);
-		}
+		} else
+			sem_lock(sma, NULL, -1);
 
-		sem_lock(sma, NULL, -1);
 		for (i = 0; i < sma->sem_nsems; i++)
 			sem_io[i] = sma->sem_base[i].semval;
 		sem_unlock(sma, -1);
_

Patches currently in -mm which might be from riel@redhat.com are

linux-next.patch
mm-remove-free_area_cache-use-in-powerpc-architecture.patch
vmscan-minor-cleanup-for-kswapd.patch
mm-introduce-free_highmem_page-helper-to-free-highmem-pages-into-buddy-system.patch
mm-merging-memory-blocks-resets-mempolicy.patch
mm-remove-config_hotplug-ifdefs.patch
mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim.patch
mm-remove-free_area_cache.patch
mm-add-vm-event-counters-for-balloon-pages-compaction.patch
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
ipcsem-fine-grained-locking-for-semtimedop-fix.patch
ipcsem-fine-grained-locking-for-semtimedop-fix-fix.patch
ipcsem-fine-grained-locking-for-semtimedop-fix-locking-in-semctl_main.patch

