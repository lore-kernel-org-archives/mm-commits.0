From: akpm@linux-foundation.org
Subject: + ipc-semc-fix-complex_count-vs-simple-op-race.patch added to -mm tree
Date: Tue, 12 Jul 2016 14:30:30 -0700
Message-ID: <57856176.YfTGhBt7crABOslA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42386 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbcGLVaz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Jul 2016 17:30:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: manfred@colorfullife.com, 1vier1@web.de, dave@stgolabs.net, felixh@informatik.uni-bremen.de, hpa@zytor.com, mingo@elte.hu, peterz@infradead.org, stable@vger.kernel.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/sem.c: Fix complex_count vs. simple op race
has been added to the -mm tree.  Its filename is
     ipc-semc-fix-complex_count-vs-simple-op-race.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-semc-fix-complex_count-vs-simple-op-race.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-semc-fix-complex_count-vs-simple-op-race.patch

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
Return-Path: <manfred@colorfullife.com>
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on y.localdomain
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=2.5 tests=BAYES_00,T_DKIM_INVALID
	autolearn=ham autolearn_force=no version=3.4.1
Received: from y.localdomain (localhost [127.0.0.1])
	by y.localdomain (8.14.9/8.14.9/Debian-4) with ESMTP id u5PHcSj9013494
	for <akpm@localhost>; Sat, 25 Jun 2016 10:38:29 -0700
X-Original-To: akpm@mail.linuxfoundation.org
Delivered-To: akpm@mail.linuxfoundation.org
Received: from mail.linuxfoundation.org [140.211.169.12]
	by y.localdomain with IMAP (fetchmail-6.3.26)
	for <akpm@localhost> (single-drop); Sat, 25 Jun 2016 10:38:29 -0700 (PDT)
Received: from smtp1.linuxfoundation.org (smtp1.linux-foundation.org [172.17.192.35])
	by mail.linuxfoundation.org (Postfix) with ESMTPS id AA5539D
	for <akpm@mail.linuxfoundation.org>; Sat, 25 Jun 2016 17:38:24 +0000 (UTC)
X-Greylist: whitelisted by SQLgrey-1.7.6
Received: from mail-wm0-f72.google.com (mail-wm0-f72.google.com [74.125.82.72])
	by smtp1.linuxfoundation.org (Postfix) with ESMTPS id 9834321F
	for <akpm@mail.linuxfoundation.org>; Sat, 25 Jun 2016 17:38:22 +0000 (UTC)
Received: by mail-wm0-f72.google.com with SMTP id r190so42216817wmr.0
        for <akpm@mail.linuxfoundation.org>; Sat, 25 Jun 2016 10:38:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20130820;
        h=x-gm-message-state:dkim-signature:from:to:cc:subject:date
         :message-id:in-reply-to:references:delivered-to;
        bh=ZXlnqKtK7m/LzOfUF7Y+wb5go3NxMEhMHTbeHufxPTc=;
        b=iT238qdr1PO242FfLABzgBg3GMSJ6KV3druBknu2Et6ndg+KSlXz8mepdfLyE637Kh
         TkoGyyl3TjNHtt72Vzff7jtJlQyYafcro28ANwfWLKhhBi43VRxos+lPwY+W6J+CI89D
         bnnB3NuEfYH65Qxhb9Qt9o6wJxnYI+klVRNibXilurNGebHYGFbPDDCdxpPf/x3wAI1f
         71ND5953+3VNbn8qw4j7oPSBWjTYdOXFtzWytNQ4lUHbod72WjfKQRmtTQOlW/tsNDOQ
         h0BvVOJSjvqbPWFEduyMCKrL7+x8P8nGCfd1uglAVDR+CAI1nSfiHM8AYj0TUFoL48/L
         zSIA==
X-Gm-Message-State: ALyK8tKPa3+vmgboIp/d+BJLUpDxfeAWVOzP9r+EgBPjRyaPj12uoeB0Us+l0gazfaN3afA+Po91y+AIcKYzve7flTqp0uHak7SDvBH9xm8NtiyJf67cH+LgODULOUYswVy3CVEdpit5rcSLFTE7/J22BTvdDF9fxZni8sBm2DYhmpk+okWa5d1AKQaqZN4RZ5Szv5l5MQVp/tGifvZSZzl80GQMDaxq5GhJKgHRS9ycHbQ2Li0/QLQUwtY7dFTgzulH6DMKiAje8Kcw2PDZXu7SUmcM39Yu+GRK1UyYQf3msc4Vf4YL3NPfB3ec2QLfgh/Is8Q=
X-Received: by 10.194.172.102 with SMTP id bb6mr9520517wjc.151.1466876301326;
        Sat, 25 Jun 2016 10:38:21 -0700 (PDT)
X-Received: by 10.194.172.102 with SMTP id bb6mr9520471wjc.151.1466876300382;
        Sat, 25 Jun 2016 10:38:20 -0700 (PDT)
Received: from mail-wm0-x244.google.com (mail-wm0-x244.google.com. [2a00:1450:400c:c09::244])
        by mx.google.com with ESMTPS id y74si2903794wmh.115.2016.06.25.10.38.20
        for <akpm@linux-foundation.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 25 Jun 2016 10:38:20 -0700 (PDT)
Received-SPF: pass (google.com: domain of manfred@colorfullife.com designates 2a00:1450:400c:c09::244 as permitted sender) client-ip=2a00:1450:400c:c09::244;
Authentication-Results: mx.google.com;
       dkim=pass header.i=@colorfullife-com.20150623.gappssmtp.com;
       spf=pass (google.com: domain of manfred@colorfullife.com designates 2a00:1450:400c:c09::244 as permitted sender) smtp.mailfrom=manfred@colorfullife.com
Received: by mail-wm0-x244.google.com with SMTP id 187so13580351wmz.1
        for <akpm@linux-foundation.org>; Sat, 25 Jun 2016 10:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorfullife-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZXlnqKtK7m/LzOfUF7Y+wb5go3NxMEhMHTbeHufxPTc=;
        b=blE64BOLZLxMEFxM54qfXWTztsLoON9vUsrVVGxUq8WGwhDA/CUaaNzvYAc4gyd0uM
         Rhn6qBqAL1Wvmp82JmiGcr2Pp5COR4fpeD0BvBPxnTRvZ6tPpvXwgIR0BjFiYs86pqmV
         oBivcLuxlnLuuAXHkoJBsdHA9MHcBMgrhKVPGozfVBF7bjyNnYLsTTudT2eLwxZuRrVC
         msCpEh6NJ9U7sXamor07I6A95s1sZnSQF/L/uWzm6+yyCJj7kX+I08I5iE5N6EMaOXD6
         yl/MCT6ZeCkfJIbXgSG/olnWaWJFUua4oebcvTOMDVLWQfnPvFmQ6BRiAwwIZP7HXBqn
         uYfQ==
X-Received: by 10.194.120.167 with SMTP id ld7mr9462649wjb.69.1466876299792;
        Sat, 25 Jun 2016 10:38:19 -0700 (PDT)
Received: from localhost.localdomain (dslb-088-071-110-173.088.071.pools.vodafone-ip.de. [88.71.110.173])
        by smtp.googlemail.com with ESMTPSA id a4sm4630275wjq.40.2016.06.25.10.38.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 25 Jun 2016 10:38:19 -0700 (PDT)
To: "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <dave@stgolabs.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, 1vier1@web.de,
        felixh@informatik.uni-bremen.de,
        Manfred Spraul <manfred@colorfullife.com>, <stable@vger.kernel.org>
Subject: ipc/sem.c: Fix complex_count vs. simple op race
Date: Sat, 25 Jun 2016 19:37:51 +0200
Message-Id: <1466876272-3824-2-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 2.5.5
In-Reply-To: <1466876272-3824-1-git-send-email-manfred@colorfullife.com>
References: <1466876272-3824-1-git-send-email-manfred@colorfullife.com>
Delivered-To: akpm@linux-foundation.org

Commit 6d07b68ce16a ("ipc/sem.c: optimize sem_lock()") introduced a
race:

sem_lock has a fast path that allows parallel simple operations.
There are two reasons why a simple operation cannot run in parallel:
- a non-simple operations is ongoing (sma->sem_perm.lock held)
- a complex operation is sleeping (sma->complex_count != 0)

As both facts are stored independently, a thread can bypass the current
checks by sleeping in the right positions. See below for more details
(or kernel bugzilla 105651).

The patch fixes that by creating one variable (complex_mode)
that tracks both reasons why parallel operations are not possible.

The patch also updates stale documentation regarding the locking.

With regards to stable kernels:
The patch is required for all kernels that include the
commit 6d07b68ce16a ("ipc/sem.c: optimize sem_lock()") (3.10?)

The alternative is to revert the patch that introduced the race.

Background:
Here is the race of the current implementation:

Thread A: (simple op)
- does the first "sma->complex_count == 0" test

Thread B: (complex op)
- does sem_lock(): This includes an array scan. But the scan can't
  find Thread A, because Thread A does not own sem->lock yet.
- the thread does the operation, increases complex_count,
  drops sem_lock, sleeps

Thread A:
- spin_lock(&sem->lock), spin_is_locked(sma->sem_perm.lock)
- sleeps before the complex_count test

Thread C: (complex op)
- does sem_lock (no array scan, complex_count==1)
- wakes up Thread B.
- decrements complex_count

Thread A:
- does the complex_count test

Bug:
Now both thread A and thread C operate on the same array, without
any synchronization.

Full memory barrier are required to synchronize changes of
complex_mode and the lock operations.

Fixes: 6d07b68ce16a ("ipc/sem.c: optimize sem_lock()")
Reported-by: felixh@informatik.uni-bremen.de
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: <stable@vger.kernel.org>
---
 include/linux/sem.h |   1 +
 ipc/sem.c           | 122 ++++++++++++++++++++++++++++++----------------------
 2 files changed, 71 insertions(+), 52 deletions(-)

diff --git a/include/linux/sem.h b/include/linux/sem.h
index 976ce3a..d0efd6e 100644
--- a/include/linux/sem.h
+++ b/include/linux/sem.h
@@ -21,6 +21,7 @@ struct sem_array {
 	struct list_head	list_id;	/* undo requests on this array */
 	int			sem_nsems;	/* no. of semaphores in array */
 	int			complex_count;	/* pending complex operations */
+	bool			complex_mode;	/* no parallel simple ops */
 };
 
 #ifdef CONFIG_SYSVIPC
diff --git a/ipc/sem.c b/ipc/sem.c
index ae72b3c..538f43a 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -162,14 +162,21 @@ static int sysvipc_sem_proc_show(struct seq_file *s, void *it);
 
 /*
  * Locking:
+ * a) global sem_lock() for read/write
  *	sem_undo.id_next,
  *	sem_array.complex_count,
- *	sem_array.pending{_alter,_cont},
- *	sem_array.sem_undo: global sem_lock() for read/write
- *	sem_undo.proc_next: only "current" is allowed to read/write that field.
+ *	sem_array.complex_mode
+ *	sem_array.pending{_alter,_const},
+ *	sem_array.sem_undo
  *
+ * b) global or semaphore sem_lock() for read/write:
  *	sem_array.sem_base[i].pending_{const,alter}:
- *		global or semaphore sem_lock() for read/write
+ *	sem_array.complex_mode (for read)
+ *
+ * c) special:
+ *	sem_undo_list.list_proc:
+ *	* undo_list->lock for write
+ *	* rcu for read
  */
 
 #define sc_semmsl	sem_ctls[0]
@@ -260,23 +267,25 @@ static void sem_rcu_free(struct rcu_head *head)
 }
 
 /*
- * Wait until all currently ongoing simple ops have completed.
+ * Enter the mode suitable for non-simple operations:
  * Caller must own sem_perm.lock.
- * New simple ops cannot start, because simple ops first check
- * that sem_perm.lock is free.
- * that a) sem_perm.lock is free and b) complex_count is 0.
  */
-static void sem_wait_array(struct sem_array *sma)
+static void complexmode_enter(struct sem_array *sma)
 {
 	int i;
 	struct sem *sem;
 
-	if (sma->complex_count)  {
-		/* The thread that increased sma->complex_count waited on
-		 * all sem->lock locks. Thus we don't need to wait again.
-		 */
+	if (sma->complex_mode)  {
+		/* We are already in complex_mode. Nothing to do */
 		return;
 	}
+	WRITE_ONCE(sma->complex_mode, true);
+
+	/* We need a full barrier:
+	 * The write to complex_mode must be visible
+	 * before we read the first sem->lock spinlock state.
+	 */
+	smp_mb();
 
 	for (i = 0; i < sma->sem_nsems; i++) {
 		sem = sma->sem_base + i;
@@ -285,6 +294,27 @@ static void sem_wait_array(struct sem_array *sma)
 }
 
 /*
+ * Try to leave the mode that disallows simple operations:
+ * Caller must own sem_perm.lock.
+ */
+static void complexmode_tryleave(struct sem_array *sma)
+{
+	if (sma->complex_count)  {
+		/* Complex ops are sleeping.
+		 * We must stay in complex mode
+		 */
+		return;
+	}
+	/*
+	 * Immediately after setting complex_mode to false,
+	 * a simple op can start. Thus: all memory writes
+	 * performed by the current operation must be visible
+	 * before we set complex_mode to false.
+	 */
+	smp_store_release(&sma->complex_mode, false);
+}
+
+/*
  * If the request contains only one semaphore operation, and there are
  * no complex transactions pending, lock only the semaphore involved.
  * Otherwise, lock the entire semaphore array, since we either have
@@ -300,56 +330,40 @@ static inline int sem_lock(struct sem_array *sma, struct sembuf *sops,
 		/* Complex operation - acquire a full lock */
 		ipc_lock_object(&sma->sem_perm);
 
-		/* And wait until all simple ops that are processed
-		 * right now have dropped their locks.
-		 */
-		sem_wait_array(sma);
+		/* Prevent parallel simple ops */
+		complexmode_enter(sma);
 		return -1;
 	}
 
 	/*
 	 * Only one semaphore affected - try to optimize locking.
-	 * The rules are:
-	 * - optimized locking is possible if no complex operation
-	 *   is either enqueued or processed right now.
-	 * - The test for enqueued complex ops is simple:
-	 *      sma->complex_count != 0
-	 * - Testing for complex ops that are processed right now is
-	 *   a bit more difficult. Complex ops acquire the full lock
-	 *   and first wait that the running simple ops have completed.
-	 *   (see above)
-	 *   Thus: If we own a simple lock and the global lock is free
-	 *	and complex_count is now 0, then it will stay 0 and
-	 *	thus just locking sem->lock is sufficient.
+	 * Optimized locking is possible if no complex operation
+	 * is either enqueued or processed right now.
+	 *
+	 * Both facts are tracked by complex_mode.
 	 */
 	sem = sma->sem_base + sops->sem_num;
 
-	if (sma->complex_count == 0) {
+	/*
+	 * Initial check for complex_mode. Just an optimization,
+	 * no locking.
+	 */
+	if (!READ_ONCE(sma->complex_mode)) {
 		/*
 		 * It appears that no complex operation is around.
 		 * Acquire the per-semaphore lock.
 		 */
 		spin_lock(&sem->lock);
 
-		/* Then check that the global lock is free */
-		if (!spin_is_locked(&sma->sem_perm.lock)) {
-			/*
-			 * We need a memory barrier with acquire semantics,
-			 * otherwise we can race with another thread that does:
-			 *	complex_count++;
-			 *	spin_unlock(sem_perm.lock);
-			 */
-			smp_acquire__after_ctrl_dep();
+		/*
+		 * A full barrier is required: the write of sem->lock
+		 * must be visible before the read is executed
+		 */
+		smp_mb();
 
-			/*
-			 * Now repeat the test of complex_count:
-			 * It can't change anymore until we drop sem->lock.
-			 * Thus: if is now 0, then it will stay 0.
-			 */
-			if (sma->complex_count == 0) {
-				/* fast path successful! */
-				return sops->sem_num;
-			}
+		if (!READ_ONCE(sma->complex_mode)) {
+			/* fast path successful! */
+			return sops->sem_num;
 		}
 		spin_unlock(&sem->lock);
 	}
@@ -369,7 +383,7 @@ static inline int sem_lock(struct sem_array *sma, struct sembuf *sops,
 		/* Not a false alarm, thus complete the sequence for a
 		 * full lock.
 		 */
-		sem_wait_array(sma);
+		complexmode_enter(sma);
 		return -1;
 	}
 }
@@ -378,6 +392,7 @@ static inline void sem_unlock(struct sem_array *sma, int locknum)
 {
 	if (locknum == -1) {
 		unmerge_queues(sma);
+		complexmode_tryleave(sma);
 		ipc_unlock_object(&sma->sem_perm);
 	} else {
 		struct sem *sem = sma->sem_base + locknum;
@@ -529,6 +544,7 @@ static int newary(struct ipc_namespace *ns, struct ipc_params *params)
 	}
 
 	sma->complex_count = 0;
+	sma->complex_mode = true; /* dropped by sem_unlock below */
 	INIT_LIST_HEAD(&sma->pending_alter);
 	INIT_LIST_HEAD(&sma->pending_const);
 	INIT_LIST_HEAD(&sma->list_id);
@@ -2184,10 +2200,10 @@ static int sysvipc_sem_proc_show(struct seq_file *s, void *it)
 	/*
 	 * The proc interface isn't aware of sem_lock(), it calls
 	 * ipc_lock_object() directly (in sysvipc_find_ipc).
-	 * In order to stay compatible with sem_lock(), we must wait until
-	 * all simple semop() calls have left their critical regions.
+	 * In order to stay compatible with sem_lock(), we must
+	 * enter / leave complex_mode.
 	 */
-	sem_wait_array(sma);
+	complexmode_enter(sma);
 
 	sem_otime = get_semotime(sma);
 
@@ -2204,6 +2220,8 @@ static int sysvipc_sem_proc_show(struct seq_file *s, void *it)
 		   sem_otime,
 		   sma->sem_ctime);
 
+	complexmode_tryleave(sma);
+
 	return 0;
 }
 #endif
-- 
2.5.5

Patches currently in -mm which might be from manfred@colorfullife.com are

ipc-semc-fix-complex_count-vs-simple-op-race.patch
ipc-sem-sem_lock-with-hysteresis.patch

