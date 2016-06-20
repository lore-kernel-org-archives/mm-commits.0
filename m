From: akpm@linux-foundation.org
Subject: + ipc-sem-sem_lock-with-hysteresis.patch added to -mm tree
Date: Mon, 20 Jun 2016 16:05:36 -0700
Message-ID: <576876c0.mUMQAsbhSbizgWh7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45447 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104AbcFTXFh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Jun 2016 19:05:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: manfred@colorfullife.com, dave@stgolabs.net, felixh@informatik.uni-bremen.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/sem: sem_lock with hysteresis
has been added to the -mm tree.  Its filename is
     ipc-sem-sem_lock-with-hysteresis.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-sem-sem_lock-with-hysteresis.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-sem-sem_lock-with-hysteresis.patch

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
Subject: ipc/sem: sem_lock with hysteresis

sysv sem has two lock modes: One with per-semaphore locks, one lock mode
with a single big lock for the whole array.  When switching from the
per-semaphore locks to the big lock, all per-semaphore locks must be
scanned for ongoing operations.

The patch adds a hysteresis for switching from the big lock to the per
semaphore locks.  This reduces how often the per-semaphore locks must be
scanned.

Passed stress testing with sem-scalebench.

Link: http://lkml.kernel.org/r/1466280142-19741-2-git-send-email-manfred@colorfullife.com
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: <felixh@informatik.uni-bremen.de>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sem.h |    2 
 ipc/sem.c           |   91 ++++++++++++++++++++++--------------------
 2 files changed, 49 insertions(+), 44 deletions(-)

diff -puN include/linux/sem.h~ipc-sem-sem_lock-with-hysteresis include/linux/sem.h
--- a/include/linux/sem.h~ipc-sem-sem_lock-with-hysteresis
+++ a/include/linux/sem.h
@@ -21,7 +21,7 @@ struct sem_array {
 	struct list_head	list_id;	/* undo requests on this array */
 	int			sem_nsems;	/* no. of semaphores in array */
 	int			complex_count;	/* pending complex operations */
-	bool			complex_mode;	/* no parallel simple ops */
+	int			complex_mode;	/* >0: no parallel simple ops */
 };
 
 #ifdef CONFIG_SYSVIPC
diff -puN ipc/sem.c~ipc-sem-sem_lock-with-hysteresis ipc/sem.c
--- a/ipc/sem.c~ipc-sem-sem_lock-with-hysteresis
+++ a/ipc/sem.c
@@ -161,6 +161,13 @@ static int sysvipc_sem_proc_show(struct
 #define SEMOPM_FAST	64  /* ~ 372 bytes on stack */
 
 /*
+ * Switching from the mode suitable for simple ops
+ * to the mode for complex ops is costly. Therefore:
+ * use some hysteresis
+ */
+#define COMPLEX_MODE_ENTER 10
+
+/*
  * Locking:
  * a) global sem_lock() for read/write
  *	sem_undo.id_next,
@@ -279,17 +286,25 @@ static void sem_rcu_free(struct rcu_head
 /*
  * Enter the mode suitable for non-simple operations:
  * Caller must own sem_perm.lock.
+ * Note:
+ * There is no leave complex mode function. Leaving
+ * happens in sem_lock, with some hysteresis.
  */
 static void complexmode_enter(struct sem_array *sma)
 {
 	int i;
 	struct sem *sem;
 
-	if (sma->complex_mode)  {
-		/* We are already in complex_mode. Nothing to do */
+	if (sma->complex_mode > 0)  {
+		/*
+		 * We are already in complex_mode.
+		 * Nothing to do, just increase
+		 * counter until we return to simple mode
+		 */
+		WRITE_ONCE(sma->complex_mode, COMPLEX_MODE_ENTER);
 		return;
 	}
-	WRITE_ONCE(sma->complex_mode, true);
+	WRITE_ONCE(sma->complex_mode, COMPLEX_MODE_ENTER);
 
 	/* We need a full barrier:
 	 * The write to complex_mode must be visible
@@ -305,29 +320,6 @@ static void complexmode_enter(struct sem
 }
 
 /*
- * Try to leave the mode that disallows simple operations:
- * Caller must own sem_perm.lock.
- */
-static void complexmode_tryleave(struct sem_array *sma)
-{
-	if (sma->complex_count)  {
-		/* Complex ops are sleeping.
-		 * We must stay in complex mode
-		 */
-		return;
-	}
-	/*
-	 * Immediately after setting complex_mode to false,
-	 * a simple op can start. Thus: all memory writes
-	 * performed by the current operation must be visible
-	 * before we set complex_mode to false.
-	 */
-	smp_wmb();
-
-	WRITE_ONCE(sma->complex_mode, false);
-}
-
-/*
  * If the request contains only one semaphore operation, and there are
  * no complex transactions pending, lock only the semaphore involved.
  * Otherwise, lock the entire semaphore array, since we either have
@@ -383,27 +375,42 @@ static inline int sem_lock(struct sem_ar
 	ipc_lock_object(&sma->sem_perm);
 
 	if (sma->complex_count == 0) {
-		/* False alarm:
-		 * There is no complex operation, thus we can switch
-		 * back to the fast path.
-		 */
-		spin_lock(&sem->lock);
-		ipc_unlock_object(&sma->sem_perm);
-		return sops->sem_num;
-	} else {
-		/* Not a false alarm, thus complete the sequence for a
-		 * full lock.
+		/*
+		 * Check if fast path is possible:
+		 * There is no complex operation, check hysteresis
+		 * If 0, switch back to the fast path.
 		 */
-		complexmode_enter(sma);
-		return -1;
+		if (sma->complex_mode > 0) {
+			/* Note:
+			 * Immediately after setting complex_mode to 0,
+			 * a simple op could start.
+			 * The data it would access was written by the
+			 * previous owner of sem->sem_perm.lock, i.e
+			 * a release and an acquire memory barrier ago.
+			 * No need for another barrier.
+			 */
+			WRITE_ONCE(sma->complex_mode, sma->complex_mode-1);
+		}
+		if (sma->complex_mode == 0) {
+			spin_lock(&sem->lock);
+			ipc_unlock_object(&sma->sem_perm);
+			return sops->sem_num;
+		}
 	}
+	/*
+	 * Not a false alarm, full lock is required.
+	 * Since we are already in complex_mode (either because of waiting
+	 * complex ops or due to hysteresis), there is not need for a
+	 * complexmode_enter().
+	 */
+	WARN_ON(sma->complex_mode == 0);
+	return -1;
 }
 
 static inline void sem_unlock(struct sem_array *sma, int locknum)
 {
 	if (locknum == -1) {
 		unmerge_queues(sma);
-		complexmode_tryleave(sma);
 		ipc_unlock_object(&sma->sem_perm);
 	} else {
 		struct sem *sem = sma->sem_base + locknum;
@@ -555,7 +562,7 @@ static int newary(struct ipc_namespace *
 	}
 
 	sma->complex_count = 0;
-	sma->complex_mode = true; /* dropped by sem_unlock below */
+	WRITE_ONCE(sma->complex_mode, COMPLEX_MODE_ENTER);
 	INIT_LIST_HEAD(&sma->pending_alter);
 	INIT_LIST_HEAD(&sma->pending_const);
 	INIT_LIST_HEAD(&sma->list_id);
@@ -2212,7 +2219,7 @@ static int sysvipc_sem_proc_show(struct
 	 * The proc interface isn't aware of sem_lock(), it calls
 	 * ipc_lock_object() directly (in sysvipc_find_ipc).
 	 * In order to stay compatible with sem_lock(), we must
-	 * enter / leave complex_mode.
+	 * enter complex_mode.
 	 */
 	complexmode_enter(sma);
 
@@ -2231,8 +2238,6 @@ static int sysvipc_sem_proc_show(struct
 		   sem_otime,
 		   sma->sem_ctime);
 
-	complexmode_tryleave(sma);
