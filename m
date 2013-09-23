From: akpm@linux-foundation.org
Subject: + ipc-semc-optimize-sem_lock.patch added to -mm tree
Date: Mon, 23 Sep 2013 14:07:44 -0700
Message-ID: <5240ada0.Gnnw7uuxaq0GPt8E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55640 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716Ab3IWVHp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Sep 2013 17:07:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, davidlohr@hp.com, bitbucket@online.de, manfred@colorfullife.com

Subject: + ipc-semc-optimize-sem_lock.patch added to -mm tree
To: manfred@colorfullife.com,bitbucket@online.de,davidlohr@hp.com,riel@redhat.com
From: akpm@linux-foundation.org
Date: Mon, 23 Sep 2013 14:07:44 -0700


The patch titled
     Subject: ipc/sem.c: optimize sem_lock()
has been added to the -mm tree.  Its filename is
     ipc-semc-optimize-sem_lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-semc-optimize-sem_lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-semc-optimize-sem_lock.patch

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
Subject: ipc/sem.c: optimize sem_lock()

Operations that need access to the whole array must guarantee that there
are no simple operations ongoing.  Right now this is achieved by
spin_unlock_wait(sem->lock) on all semaphores.

If complex_count is nonzero, then this spin_unlock_wait() is not
necessary, because it was already performed in the past by the thread that
increased complex_count and even though sem_perm.lock was dropped
inbetween, no simple operation could have started, because simple
operations cannot start when complex_count is non-zero.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Mike Galbraith <bitbucket@online.de>
Cc: Rik van Riel <riel@redhat.com>
Reviewed-by: Davidlohr Bueso <davidlohr@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN ipc/sem.c~ipc-semc-optimize-sem_lock ipc/sem.c
--- a/ipc/sem.c~ipc-semc-optimize-sem_lock
+++ a/ipc/sem.c
@@ -248,12 +248,20 @@ static void merge_queues(struct sem_arra
  * Caller must own sem_perm.lock.
  * New simple ops cannot start, because simple ops first check
  * that sem_perm.lock is free.
+ * that a) sem_perm.lock is free and b) complex_count is 0.
  */
 static void sem_wait_array(struct sem_array *sma)
 {
 	int i;
 	struct sem *sem;
 
+	if (sma->complex_count)  {
+		/* The thread that increased sma->complex_count waited on
+		 * all sem->lock locks. Thus we don't need to wait again.
+		 */
+		return;
+	}
+
 	for (i = 0; i < sma->sem_nsems; i++) {
 		sem = sma->sem_base + i;
 		spin_unlock_wait(&sem->lock);
_

Patches currently in -mm which might be from manfred@colorfullife.com are

ipc-semc-fix-race-in-sem_lock.patch
ipc-semc-optimize-sem_lock.patch
slab-leaks3-default-y.patch

