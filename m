From: akpm@linux-foundation.org
Subject: + ipc-semc-fix-incorrect-sem_lock-pairing.patch added to -mm tree
Date: Wed, 04 Jan 2017 17:37:52 -0800
Message-ID: <586da370.3Fmla2G7scgqNXgI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45562 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S969996AbdAEBqn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jan 2017 20:46:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: manfred@colorfullife.com, dave@stgolabs.net, dvyukov@google.com, johanna@mjao.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/sem.c: fix incorrect sem_lock pairing
has been added to the -mm tree.  Its filename is
     ipc-semc-fix-incorrect-sem_lock-pairing.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-semc-fix-incorrect-sem_lock-pairing.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-semc-fix-incorrect-sem_lock-pairing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Manfred Spraul <manfred@colorfullife.com>
Subject: ipc/sem.c: fix incorrect sem_lock pairing

Based on the syzcaller test case from dvyukov:
https://gist.githubusercontent.com/dvyukov/d0e5efefe4d7d6daed829f5c3ca26a40/raw/08d0a261fe3c987bed04fbf267e08ba04bd533ea/gistfile1.txt

The slow (i.e.: failure to acquire) syscall exit from semtimedop()
incorrectly assumed that the the same lock is acquired as it was at the
initial syscall entry.

This is wrong:
- thread A: single semop semop(), sleeps
- thread B: multi semop semop(), sleeps
- thread A: woken up by signal/timeout

With this sequence, the initial sem_lock() call locks the per-semaphore
spinlock, and it is unlocked with sem_unlock().  The call at the syscall
return locks the global spinlock.  Because locknum is not updated, the
following sem_unlock() call unlocks the per-semaphore spinlock, which is
actually not locked.

The fix is trivial: Use the return value from sem_lock.

Fixes: 370b262c896e ("ipc/sem: avoid idr tree lookup for interrupted semop")
Link: http://lkml.kernel.org/r/1482215645-22328-1-git-send-email-manfred@colorfullife.com
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Reported-by: Johanna Abrahamsson <johanna@mjao.org>
Tested-by: Johanna Abrahamsson <johanna@mjao.org>
Acked-by: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN ipc/sem.c~ipc-semc-fix-incorrect-sem_lock-pairing ipc/sem.c
--- a/ipc/sem.c~ipc-semc-fix-incorrect-sem_lock-pairing
+++ a/ipc/sem.c
@@ -1977,7 +1977,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid,
 		}
 
 		rcu_read_lock();
-		sem_lock(sma, sops, nsops);
+		locknum = sem_lock(sma, sops, nsops);
 
 		if (!ipc_valid_object(&sma->sem_perm))
 			goto out_unlock_free;
_

Patches currently in -mm which might be from manfred@colorfullife.com are

ipc-semc-fix-incorrect-sem_lock-pairing.patch
ipc-semc-avoid-using-spin_unlock_wait.patch
ipc-sem-add-hysteresis.patch

