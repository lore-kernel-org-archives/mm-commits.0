From: akpm@linux-foundation.org
Subject: [folded-merged]
 ipc-semc-fix-complex_count-vs-simple-op-race-update.patch removed from -mm
 tree
Date: Thu, 21 Jul 2016 13:13:06 -0700
Message-ID: <57912cd2.PeZ8s5/qndBfdxJP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52550 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998AbcGUUNH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jul 2016 16:13:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: manfred@colorfullife.com, dave@stgolabs.net, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc-semc-fix-complex_count-vs-simple-op-race-update
has been removed from the -mm tree.  Its filename was
     ipc-semc-fix-complex_count-vs-simple-op-race-update.patch

This patch was dropped because it was folded into ipc-semc-fix-complex_count-vs-simple-op-race.patch

------------------------------------------------------
From: Manfred Spraul <manfred@colorfullife.com>
Subject: ipc-semc-fix-complex_count-vs-simple-op-race-update

Link: http://lkml.kernel.org/r/1468386412-3608-2-git-send-email-manfred@colorfullife.com
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN ipc/sem.c~ipc-semc-fix-complex_count-vs-simple-op-race-update ipc/sem.c
--- a/ipc/sem.c~ipc-semc-fix-complex_count-vs-simple-op-race-update
+++ a/ipc/sem.c
@@ -291,6 +291,14 @@ static void complexmode_enter(struct sem
 		sem = sma->sem_base + i;
 		spin_unlock_wait(&sem->lock);
 	}
+	/*
+	 * spin_unlock_wait() is not a memory barriers, it is only a
+	 * control barrier. The code must pair with spin_unlock(&sem->lock),
+	 * thus just the control barrier is insufficient.
+	 *
+	 * smp_rmb() is sufficient, as writes cannot pass the control barrier.
+	 */
+	smp_rmb();
 }
 
 /*
@@ -346,7 +354,7 @@ static inline int sem_lock(struct sem_ar
 
 	/*
 	 * Initial check for complex_mode. Just an optimization,
-	 * no locking.
+	 * no locking, no memory barrier.
 	 */
 	if (!READ_ONCE(sma->complex_mode)) {
 		/*
@@ -361,7 +369,7 @@ static inline int sem_lock(struct sem_ar
 		 */
 		smp_mb();
 
-		if (!READ_ONCE(sma->complex_mode)) {
+		if (!smp_load_acquire(&sma->complex_mode)) {
 			/* fast path successful! */
 			return sops->sem_num;
 		}
_

Patches currently in -mm which might be from manfred@colorfullife.com are

ipc-semc-fix-complex_count-vs-simple-op-race.patch
ipc-semc-remove-duplicated-memory-barriers.patch
ipc-sem-sem_lock-with-hysteresis.patch

