From: akpm@linux-foundation.org
Subject: [merged] ipc-semc-optimize-sem_lock.patch removed from -mm tree
Date: Thu, 17 Oct 2013 11:12:15 -0700
Message-ID: <5260287f.UhyY74EDkBESU5tk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44185 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758210Ab3JQSMQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Oct 2013 14:12:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, davidlohr@hp.com, bitbucket@online.de, manfred@colorfullife.com

Subject: [merged] ipc-semc-optimize-sem_lock.patch removed from -mm tree
To: manfred@colorfullife.com,bitbucket@online.de,davidlohr@hp.com,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 17 Oct 2013 11:12:15 -0700


The patch titled
     Subject: ipc/sem.c: optimize sem_lock()
has been removed from the -mm tree.  Its filename was
     ipc-semc-optimize-sem_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -257,12 +257,20 @@ static void sem_rcu_free(struct rcu_head
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

origin.patch
slab-leaks3-default-y.patch

