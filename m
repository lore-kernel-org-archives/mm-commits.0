From: akpm@linux-foundation.org
Subject: + ipc-sem-add-hysteresis.patch added to -mm tree
Date: Wed, 19 Oct 2016 17:23:13 -0700
Message-ID: <58080e71.demL1pcB+zieK5zL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38536 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754904AbcJTAXO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Oct 2016 20:23:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: manfred@colorfullife.com, 1vier1@web.de, dave@stgolabs.net, felixh@informatik.uni-bremen.de, hpa@zytor.com, mingo@elte.hu, peterz@infradead.org, tglx@linutronix.de, xiaolong.ye@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/sem: add hysteresis
has been added to the -mm tree.  Its filename is
     ipc-sem-add-hysteresis.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-sem-add-hysteresis.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-sem-add-hysteresis.patch

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
Subject: ipc/sem: add hysteresis

sysv sem has two lock modes: One with per-semaphore locks, one lock mode
with a single global lock for the whole array.
When switching from the per-semaphore locks to the global lock, all
per-semaphore locks must be scanned for ongoing operations.

The patch adds a hysteresis for switching from the global lock to the
per semaphore locks. This reduces how often the per-semaphore locks
must be scanned.

Compared to the initial patch, this is a simplified solution:
Setting USE_GLOBAL_LOCK_HYSTERESIS to 1 restores the current behavior.

In theory, a workload with exactly 10 simple sops and then
one complex op now scales a bit worse, but this is pure theory:
If there is concurrency, the it won't be exactly 10:1:10:1:10:1:...
If there is no concurrency, then there is no need for scalability.

Link: http://lkml.kernel.org/r/1476851896-3590-3-git-send-email-manfred@colorfullife.com
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: <1vier1@web.de>
Cc: kernel test robot <xiaolong.ye@intel.com>
Cc: <felixh@informatik.uni-bremen.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sem.h |    2 
 ipc/sem.c           |   86 +++++++++++++++++++++++++++++-------------
 2 files changed, 62 insertions(+), 26 deletions(-)

diff -puN include/linux/sem.h~ipc-sem-add-hysteresis include/linux/sem.h
--- a/include/linux/sem.h~ipc-sem-add-hysteresis
+++ a/include/linux/sem.h
@@ -21,7 +21,7 @@ struct sem_array {
 	struct list_head	list_id;	/* undo requests on this array */
 	int			sem_nsems;	/* no. of semaphores in array */
 	int			complex_count;	/* pending complex operations */
-	bool			complex_mode;	/* no parallel simple ops */
+	unsigned int		use_global_lock;/* >0: global lock required */
 };
 
 #ifdef CONFIG_SYSVIPC
diff -puN ipc/sem.c~ipc-sem-add-hysteresis ipc/sem.c
--- a/ipc/sem.c~ipc-sem-add-hysteresis
+++ a/ipc/sem.c
@@ -161,22 +161,42 @@ static int sysvipc_sem_proc_show(struct
 #define SEMOPM_FAST	64  /* ~ 372 bytes on stack */
 
 /*
+ * Switching from the mode suitable for simple ops
+ * to the mode for complex ops is costly. Therefore:
+ * use some hysteresis
+ */
+#define USE_GLOBAL_LOCK_HYSTERESIS	10
+
+/*
  * Locking:
  * a) global sem_lock() for read/write
  *	sem_undo.id_next,
  *	sem_array.complex_count,
- *	sem_array.complex_mode
  *	sem_array.pending{_alter,_const},
  *	sem_array.sem_undo
  *
  * b) global or semaphore sem_lock() for read/write:
  *	sem_array.sem_base[i].pending_{const,alter}:
- *	sem_array.complex_mode (for read)
  *
  * c) special:
  *	sem_undo_list.list_proc:
  *	* undo_list->lock for write
  *	* rcu for read
+ *	use_global_lock:
+ *	* global sem_lock() for write
+ *	* either local or global sem_lock() for read.
+ *
+ * Memory ordering:
+ * Most ordering is enforced by using spin_lock() and spin_unlock().
+ * The special case is use_global_lock:
+ * Setting it from non-zero to 0 is a RELEASE, this is ensured by
+ * using smp_store_release().
+ * Testing if it is non-zero is an ACQUIRE, this is ensured by using
+ * smp_load_acquire().
+ * Setting it from 0 to non-zero must be ordered with regards to
+ * this smp_load_acquire(), this is guaranteed because the smp_load_acquire()
+ * is inside a spin_lock() and after a write from 0 to non-zero a
+ * spin_lock()+spin_unlock() is done.
  */
 
 #define sc_semmsl	sem_ctls[0]
@@ -275,12 +295,16 @@ static void complexmode_enter(struct sem
 	int i;
 	struct sem *sem;
 
-	if (sma->complex_mode)  {
-		/* We are already in complex_mode. Nothing to do */
+	if (sma->use_global_lock > 0)  {
+		/*
+		 * We are already in global lock mode.
+		 * Nothing to do, just reset the
+		 * counter until we return to simple mode.
+		 */
+		sma->use_global_lock = USE_GLOBAL_LOCK_HYSTERESIS;
 		return;
 	}
-
-	sma->complex_mode = true;
+	sma->use_global_lock = USE_GLOBAL_LOCK_HYSTERESIS;
 
 	for (i = 0; i < sma->sem_nsems; i++) {
 		sem = sma->sem_base + i;
@@ -301,13 +325,17 @@ static void complexmode_tryleave(struct
 		 */
 		return;
 	}
-	/*
-	 * Immediately after setting complex_mode to false,
-	 * a simple op can start. Thus: all memory writes
-	 * performed by the current operation must be visible
-	 * before we set complex_mode to false.
-	 */
-	smp_store_release(&sma->complex_mode, false);
+	if (sma->use_global_lock == 1) {
+		/*
+		 * Immediately after setting use_global_lock to 0,
+		 * a simple op can start. Thus: all memory writes
+		 * performed by the current operation must be visible
+		 * before we set use_global_lock to 0.
+		 */
+		smp_store_release(&sma->use_global_lock, 0);
+	} else {
+		sma->use_global_lock--;
+	}
 }
 
 #define SEM_GLOBAL_LOCK	(-1)
@@ -337,22 +365,23 @@ static inline int sem_lock(struct sem_ar
 	 * Optimized locking is possible if no complex operation
 	 * is either enqueued or processed right now.
 	 *
-	 * Both facts are tracked by complex_mode.
+	 * Both facts are tracked by use_global_mode.
 	 */
 	sem = sma->sem_base + sops->sem_num;
 
 	/*
-	 * Initial check for complex_mode. Just an optimization,
+	 * Initial check for use_global_lock. Just an optimization,
 	 * no locking, no memory barrier.
 	 */
-	if (!sma->complex_mode) {
+	if (!sma->use_global_lock) {
 		/*
 		 * It appears that no complex operation is around.
 		 * Acquire the per-semaphore lock.
 		 */
 		spin_lock(&sem->lock);
 
-		if (!smp_load_acquire(&sma->complex_mode)) {
+		/* pairs with smp_store_release() */
+		if (!smp_load_acquire(&sma->use_global_lock)) {
 			/* fast path successful! */
 			return sops->sem_num;
 		}
@@ -362,19 +391,26 @@ static inline int sem_lock(struct sem_ar
 	/* slow path: acquire the full lock */
 	ipc_lock_object(&sma->sem_perm);
 
-	if (sma->complex_count == 0) {
-		/* False alarm:
-		 * There is no complex operation, thus we can switch
-		 * back to the fast path.
+	if (sma->use_global_lock == 0) {
+		/*
+		 * The use_global_lock mode ended while we waited for
+		 * sma->sem_perm.lock. Thus we must switch to locking
+		 * with sem->lock.
+		 * Unlike in the fast path, there is no need to recheck
+		 * sma->use_global_lock after we have acquired sem->lock:
+		 * We own sma->sem_perm.lock, thus use_global_lock cannot
+		 * change.
 		 */
 		spin_lock(&sem->lock);
+
 		ipc_unlock_object(&sma->sem_perm);
 		return sops->sem_num;
 	} else {
-		/* Not a false alarm, thus complete the sequence for a
-		 * full lock.
+		/*
+		 * Not a false alarm, thus continue to use the global lock
+		 * mode. No need for complexmode_enter(), this was done by
+		 * the caller that has set use_global_mode to non-zero.
 		 */
-		complexmode_enter(sma);
 		return SEM_GLOBAL_LOCK;
 	}
 }
@@ -535,7 +571,7 @@ static int newary(struct ipc_namespace *
 	}
 
 	sma->complex_count = 0;
-	sma->complex_mode = true; /* dropped by sem_unlock below */
+	sma->use_global_lock = USE_GLOBAL_LOCK_HYSTERESIS;
 	INIT_LIST_HEAD(&sma->pending_alter);
 	INIT_LIST_HEAD(&sma->pending_const);
 	INIT_LIST_HEAD(&sma->list_id);
_

Patches currently in -mm which might be from manfred@colorfullife.com are

ipc-semc-avoid-using-spin_unlock_wait.patch
ipc-sem-add-hysteresis.patch

