From: akpm@linux-foundation.org
Subject: - futex-tidy-up-the-code.patch removed from -mm tree
Date: Mon, 18 Jun 2007 00:36:35 -0700
Message-ID: <200706180736.l5I7aZ3Z000833@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59538 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756129AbXFRHjx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Jun 2007 03:39:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, dada1@cosmosbay.com, drepper@redhat.com, kuznet@ms2.inr.ac.ru, mingo@elte.hu, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     FUTEX: Tidy up the code
has been removed from the -mm tree.  Its filename was
     futex-tidy-up-the-code.patch

This patch was dropped because futex-revert-the-non-functional-requeue_pi.patch destroyed it

------------------------------------------------------
Subject: FUTEX: Tidy up the code
From: Thomas Gleixner <tglx@linutronix.de>

The recent PRIVATE and REQUEUE_PI changes to the futex code made it hard to
read.  Tidy it up.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/futex.c          |  192 ++++++++++++++++----------------------
 kernel/rtmutex-debug.c  |    6 -
 kernel/rtmutex.c        |    6 -
 kernel/rtmutex_common.h |    7 +
 4 files changed, 88 insertions(+), 123 deletions(-)

diff -puN kernel/futex.c~futex-tidy-up-the-code kernel/futex.c
--- a/kernel/futex.c~futex-tidy-up-the-code
+++ a/kernel/futex.c
@@ -56,12 +56,6 @@
 
 #include "rtmutex_common.h"
 
-#ifdef CONFIG_DEBUG_RT_MUTEXES
-# include "rtmutex-debug.h"
-#else
-# include "rtmutex.h"
-#endif
-
 #define FUTEX_HASHBITS (CONFIG_BASE_SMALL ? 4 : 8)
 
 /*
@@ -133,6 +127,24 @@ static struct futex_hash_bucket futex_qu
 static struct vfsmount *futex_mnt;
 
 /*
+ * Take mm->mmap_sem, when futex is shared
+ */
+static inline void futex_lock_mm(struct rw_semaphore *fshared)
+{
+	if (fshared)
+		down_read(fshared);
+}
+
+/*
+ * Release mm->mmap_sem, when the futex is shared
+ */
+static inline void futex_unlock_mm(struct rw_semaphore *fshared)
+{
+	if (fshared)
+		up_read(fshared);
+}
+
+/*
  * We hash on the keys returned from get_futex_key (see below).
  */
 static struct futex_hash_bucket *hash_futex(union futex_key *key)
@@ -302,7 +314,18 @@ void drop_futex_key_refs(union futex_key
 }
 EXPORT_SYMBOL_GPL(drop_futex_key_refs);
 
-static inline int get_futex_value_locked(u32 *dest, u32 __user *from)
+static u32 cmpxchg_futex_value_locked(u32 __user *uaddr, u32 uval, u32 newval)
+{
+	u32 curval;
+
+	pagefault_disable();
+	curval = futex_atomic_cmpxchg_inatomic(uaddr, uval, newval);
+	pagefault_enable();
+
+	return curval;
+}
+
+static int get_futex_value_locked(u32 *dest, u32 __user *from)
 {
 	int ret;
 
@@ -424,14 +447,12 @@ static struct task_struct * futex_find_g
 
 	rcu_read_lock();
 	p = find_task_by_pid(pid);
-	if (!p)
-		goto out_unlock;
-	if ((current->euid != p->euid) && (current->euid != p->uid)) {
-		p = NULL;
-		goto out_unlock;
-	}
-	get_task_struct(p);
-out_unlock:
+
+	if (!p || ((current->euid != p->euid) && (current->euid != p->uid)))
+		p = ERR_PTR(-ESRCH);
+	else
+		get_task_struct(p);
+
 	rcu_read_unlock();
 
 	return p;
@@ -639,9 +660,7 @@ static int wake_futex_pi(u32 __user *uad
 		/* Keep the FUTEX_WAITER_REQUEUED flag if it was set */
 		newval |= (uval & FUTEX_WAITER_REQUEUED);
 
-		pagefault_disable();
-		curval = futex_atomic_cmpxchg_inatomic(uaddr, uval, newval);
-		pagefault_enable();
+		curval = cmpxchg_futex_value_locked(uaddr, uval, newval);
 
 		if (curval == -EFAULT)
 			ret = -EFAULT;
@@ -678,9 +697,7 @@ static int unlock_futex_pi(u32 __user *u
 	 * There is no waiter, so we unlock the futex. The owner died
 	 * bit has not to be preserved here. We are the owner:
 	 */
-	pagefault_disable();
-	oldval = futex_atomic_cmpxchg_inatomic(uaddr, uval, 0);
-	pagefault_enable();
+	oldval = cmpxchg_futex_value_locked(uaddr, uval, 0);
 
 	if (oldval == -EFAULT)
 		return oldval;
@@ -719,8 +736,7 @@ static int futex_wake(u32 __user *uaddr,
 	union futex_key key;
 	int ret;
 
-	if (fshared)
-		down_read(fshared);
+	futex_lock_mm(fshared);
 
 	ret = get_futex_key(uaddr, fshared, &key);
 	if (unlikely(ret != 0))
@@ -744,8 +760,7 @@ static int futex_wake(u32 __user *uaddr,
 
 	spin_unlock(&hb->lock);
 out:
-	if (fshared)
-		up_read(fshared);
+	futex_unlock_mm(fshared);
 	return ret;
 }
 
@@ -780,9 +795,7 @@ retry:
 		uval = curval;
 		newval = uval | FUTEX_WAITERS | FUTEX_WAITER_REQUEUED;
 
-		pagefault_disable();
-		curval = futex_atomic_cmpxchg_inatomic(uaddr, uval, newval);
-		pagefault_enable();
+		curval = cmpxchg_futex_value_locked(uaddr, uval, newval);
 
 		if (unlikely(curval == -EFAULT))
 			return -EFAULT;
@@ -830,11 +843,7 @@ static int futex_requeue_pi(u32 __user *
 		return -ENOMEM;
 
 retry:
-	/*
-	 * First take all the futex related locks:
-	 */
-	if (fshared)
-		down_read(fshared);
+	futex_lock_mm(fshared);
 
 	ret = get_futex_key(uaddr1, fshared, &key1);
 	if (unlikely(ret != 0))
@@ -862,8 +871,7 @@ retry:
 			 * If we would have faulted, release mmap_sem, fault
 			 * it in and start all over again.
 			 */
-			if (fshared)
-				up_read(fshared);
+			futex_unlock_mm(fshared);
 
 			ret = get_user(curval, uaddr1);
 
@@ -997,8 +1005,7 @@ out_unlock:
 		drop_futex_key_refs(&key1);
 
 out:
-	if (fshared)
-		up_read(fshared);
+	futex_unlock_mm(fshared);
 	return ret;
 }
 
@@ -1018,8 +1025,7 @@ futex_wake_op(u32 __user *uaddr1, struct
 	int ret, op_ret, attempt = 0;
 
 retryfull:
-	if (fshared)
-		down_read(fshared);
+	futex_lock_mm(fshared);
 
 	ret = get_futex_key(uaddr1, fshared, &key1);
 	if (unlikely(ret != 0))
@@ -1065,7 +1071,7 @@ retry:
 		 */
 		if (attempt++) {
 			ret = futex_handle_fault((unsigned long)uaddr2,
-						fshared, attempt);
+						 fshared, attempt);
 			if (ret)
 				goto out;
 			goto retry;
@@ -1075,8 +1081,7 @@ retry:
 		 * If we would have faulted, release mmap_sem,
 		 * fault it in and start all over again.
 		 */
-		if (fshared)
-			up_read(fshared);
+		futex_unlock_mm(fshared);
 
 		ret = get_user(dummy, uaddr2);
 		if (ret)
@@ -1113,8 +1118,7 @@ retry:
 	if (hb1 != hb2)
 		spin_unlock(&hb2->lock);
 out:
-	if (fshared)
-		up_read(fshared);
+	futex_unlock_mm(fshared);
 	return ret;
 }
 
@@ -1133,8 +1137,7 @@ static int futex_requeue(u32 __user *uad
 	int ret, drop_count = 0;
 
  retry:
-	if (fshared)
-		down_read(fshared);
+	futex_lock_mm(fshared);
 
 	ret = get_futex_key(uaddr1, fshared, &key1);
 	if (unlikely(ret != 0))
@@ -1162,8 +1165,7 @@ static int futex_requeue(u32 __user *uad
 			 * If we would have faulted, release mmap_sem, fault
 			 * it in and start all over again.
 			 */
-			if (fshared)
-				up_read(fshared);
+			futex_unlock_mm(fshared);
 
 			ret = get_user(curval, uaddr1);
 
@@ -1216,8 +1218,7 @@ out_unlock:
 		drop_futex_key_refs(&key1);
 
 out:
-	if (fshared)
-		up_read(fshared);
+	futex_unlock_mm(fshared);
 	return ret;
 }
 
@@ -1386,10 +1387,7 @@ static int fixup_pi_state_owner(u32 __us
 		newval = (uval & FUTEX_OWNER_DIED) | newtid;
 		newval |= (uval & FUTEX_WAITER_REQUEUED);
 
-		pagefault_disable();
-		curval = futex_atomic_cmpxchg_inatomic(uaddr,
-						       uval, newval);
-		pagefault_enable();
+		curval = cmpxchg_futex_value_locked(uaddr, uval, newval);
 
 		if (curval == -EFAULT)
 			ret = -EFAULT;
@@ -1407,6 +1405,7 @@ static int fixup_pi_state_owner(u32 __us
 #define ARG3_SHARED  1
 
 static long futex_wait_restart(struct restart_block *restart);
+
 static int futex_wait(u32 __user *uaddr, struct rw_semaphore *fshared,
 		      u32 val, ktime_t *abs_time)
 {
@@ -1421,8 +1420,7 @@ static int futex_wait(u32 __user *uaddr,
 
 	q.pi_state = NULL;
  retry:
-	if (fshared)
-		down_read(fshared);
+	futex_lock_mm(fshared);
 
 	ret = get_futex_key(uaddr, fshared, &q.key);
 	if (unlikely(ret != 0))
@@ -1459,8 +1457,7 @@ static int futex_wait(u32 __user *uaddr,
 		 * If we would have faulted, release mmap_sem, fault it in and
 		 * start all over again.
 		 */
-		if (fshared)
-			up_read(fshared);
+		futex_unlock_mm(fshared);
 
 		ret = get_user(uval, uaddr);
 
@@ -1487,8 +1484,7 @@ static int futex_wait(u32 __user *uaddr,
 	 * Now the futex is queued and we have checked the data, we
 	 * don't want to hold mmap_sem while we sleep.
 	 */
-	if (fshared)
-		up_read(fshared);
+	futex_unlock_mm(fshared);
 
 	/*
 	 * There might have been scheduling since the queue_me(), as we
@@ -1548,9 +1544,9 @@ static int futex_wait(u32 __user *uaddr,
 		struct rt_mutex *lock = &q.pi_state->pi_mutex;
 
 		spin_lock(&lock->wait_lock);
-		if (unlikely(q.waiter.task)) {
+		if (unlikely(q.waiter.task))
 			remove_waiter(lock, &q.waiter);
-		}
+
 		spin_unlock(&lock->wait_lock);
 
 		if (rem)
@@ -1558,8 +1554,7 @@ static int futex_wait(u32 __user *uaddr,
 		else
 			ret = rt_mutex_timed_lock(lock, to, 1);
 
-		if (fshared)
-			down_read(fshared);
+		futex_lock_mm(fshared);
 		spin_lock(q.lock_ptr);
 
 		/*
@@ -1589,8 +1584,7 @@ static int futex_wait(u32 __user *uaddr,
 
 		/* Unqueue and drop the lock */
 		unqueue_me_pi(&q);
-		if (fshared)
-			up_read(fshared);
+		futex_unlock_mm(fshared);
 
 		debug_rt_mutex_free_waiter(&q.waiter);
 
@@ -1628,8 +1622,7 @@ static int futex_wait(u32 __user *uaddr,
 	queue_unlock(&q, hb);
 
  out_release_sem:
-	if (fshared)
-		up_read(fshared);
+	futex_unlock_mm(fshared);
 	return ret;
 }
 
@@ -1721,8 +1714,7 @@ static int futex_lock_pi(u32 __user *uad
 
 	q.pi_state = NULL;
  retry:
-	if (fshared)
-		down_read(fshared);
+	futex_lock_mm(fshared);
 
 	ret = get_futex_key(uaddr, fshared, &q.key);
 	if (unlikely(ret != 0))
@@ -1741,9 +1733,7 @@ static int futex_lock_pi(u32 __user *uad
 	 */
 	newval = current->pid;
 
-	pagefault_disable();
-	curval = futex_atomic_cmpxchg_inatomic(uaddr, 0, newval);
-	pagefault_enable();
+	curval = cmpxchg_futex_value_locked(uaddr, 0, newval);
 
 	if (unlikely(curval == -EFAULT))
 		goto uaddr_faulted;
@@ -1787,9 +1777,7 @@ static int futex_lock_pi(u32 __user *uad
 		lock_taken = 1;
 	}
 
-	pagefault_disable();
-	curval = futex_atomic_cmpxchg_inatomic(uaddr, uval, newval);
-	pagefault_enable();
+	curval = cmpxchg_futex_value_locked(uaddr, uval, newval);
 
 	if (unlikely(curval == -EFAULT))
 		goto uaddr_faulted;
@@ -1821,8 +1809,7 @@ static int futex_lock_pi(u32 __user *uad
 			 * exit to complete.
 			 */
 			queue_unlock(&q, hb);
-			if (fshared)
-				up_read(fshared);
+			futex_unlock_mm(fshared);
 			cond_resched();
 			goto retry;
 
@@ -1858,8 +1845,7 @@ static int futex_lock_pi(u32 __user *uad
 	 * Now the futex is queued and we have checked the data, we
 	 * don't want to hold mmap_sem while we sleep.
 	 */
-	if (fshared)
-		up_read(fshared);
+	futex_unlock_mm(fshared);
 
 	WARN_ON(!q.pi_state);
 	/*
@@ -1873,8 +1859,7 @@ static int futex_lock_pi(u32 __user *uad
 		ret = ret ? 0 : -EWOULDBLOCK;
 	}
 
-	if (fshared)
-		down_read(fshared);
+	futex_lock_mm(fshared);
 	spin_lock(q.lock_ptr);
 
 	if (!ret) {
@@ -1911,8 +1896,7 @@ static int futex_lock_pi(u32 __user *uad
 
 	/* Unqueue and drop the lock */
 	unqueue_me_pi(&q);
-	if (fshared)
-		up_read(fshared);
+	futex_unlock_mm(fshared);
 
 	return ret != -EINTR ? ret : -ERESTARTNOINTR;
 
@@ -1920,8 +1904,7 @@ static int futex_lock_pi(u32 __user *uad
 	queue_unlock(&q, hb);
 
  out_release_sem:
-	if (fshared)
-		up_read(fshared);
+	futex_unlock_mm(fshared);
 	return ret;
 
  uaddr_faulted:
@@ -1943,8 +1926,7 @@ static int futex_lock_pi(u32 __user *uad
 		goto retry_unlocked;
 	}
 
-	if (fshared)
-		up_read(fshared);
+	futex_unlock_mm(fshared);
 
 	ret = get_user(uval, uaddr);
 	if (!ret && (uval != -EFAULT))
@@ -1975,11 +1957,8 @@ retry:
 	 */
 	if ((uval & FUTEX_TID_MASK) != current->pid)
 		return -EPERM;
-	/*
-	 * First take all the futex related locks:
-	 */
-	if (fshared)
-		down_read(fshared);
+
+	futex_lock_mm(fshared);
 
 	ret = get_futex_key(uaddr, fshared, &key);
 	if (unlikely(ret != 0))
@@ -1994,11 +1973,8 @@ retry_unlocked:
 	 * again. If it succeeds then we can return without waking
 	 * anyone else up:
 	 */
-	if (!(uval & FUTEX_OWNER_DIED)) {
-		pagefault_disable();
-		uval = futex_atomic_cmpxchg_inatomic(uaddr, current->pid, 0);
-		pagefault_enable();
-	}
+	if (!(uval & FUTEX_OWNER_DIED))
+		uval = cmpxchg_futex_value_locked(uaddr, current->pid, 0);
 
 	if (unlikely(uval == -EFAULT))
 		goto pi_faulted;
@@ -2040,9 +2016,7 @@ retry_unlocked:
 out_unlock:
 	spin_unlock(&hb->lock);
 out:
-	if (fshared)
-		up_read(fshared);
-
+	futex_unlock_mm(fshared);
 	return ret;
 
 pi_faulted:
@@ -2064,8 +2038,7 @@ pi_faulted:
 		goto retry_unlocked;
 	}
 
-	if (fshared)
-		up_read(fshared);
+	futex_unlock_mm(fshared);
 
 	ret = get_user(uval, uaddr);
 	if (!ret && (uval != -EFAULT))
@@ -2122,8 +2095,8 @@ static int futex_fd(u32 __user *uaddr, i
 
 	if (printk_timed_ratelimit(&printk_interval, 60 * 60 * 1000)) {
 		printk(KERN_WARNING "Process `%s' used FUTEX_FD, which "
-		    	"will be removed from the kernel in June 2007\n",
-			current->comm);
+		       "will be removed from the kernel in June 2007\n",
+		       current->comm);
 	}
 
 	ret = -EINVAL;
@@ -2288,9 +2261,8 @@ retry:
 		 * thread-death.) The rest of the cleanup is done in
 		 * userspace.
 		 */
-		mval = (uval & FUTEX_WAITERS) | FUTEX_OWNER_DIED;
-		/* Also keep the FUTEX_WAITER_REQUEUED flag if set */
-		mval |= (uval & FUTEX_WAITER_REQUEUED);
+		mval = uval & (FUTEX_WAITERS | FUTEX_WAITER_REQUEUED);
+		mval |= FUTEX_OWNER_DIED;
 		nval = futex_atomic_cmpxchg_inatomic(uaddr, uval, mval);
 
 		if (nval == -EFAULT)
@@ -2303,10 +2275,8 @@ retry:
 		 * Wake robust non-PI futexes here. The wakeup of
 		 * PI futexes happens in exit_pi_state():
 		 */
-		if (!pi) {
-			if (uval & FUTEX_WAITERS)
+		if (!pi && (uval & FUTEX_WAITERS))
 				futex_wake(uaddr, &curr->mm->mmap_sem, 1);
-		}
 	}
 	return 0;
 }
diff -puN kernel/rtmutex-debug.c~futex-tidy-up-the-code kernel/rtmutex-debug.c
--- a/kernel/rtmutex-debug.c~futex-tidy-up-the-code
+++ a/kernel/rtmutex-debug.c
@@ -29,12 +29,6 @@
 
 #include "rtmutex_common.h"
 
-#ifdef CONFIG_DEBUG_RT_MUTEXES
-# include "rtmutex-debug.h"
-#else
-# include "rtmutex.h"
-#endif
-
 # define TRACE_WARN_ON(x)			WARN_ON(x)
 # define TRACE_BUG_ON(x)			BUG_ON(x)
 
diff -puN kernel/rtmutex.c~futex-tidy-up-the-code kernel/rtmutex.c
--- a/kernel/rtmutex.c~futex-tidy-up-the-code
+++ a/kernel/rtmutex.c
@@ -17,12 +17,6 @@
 
 #include "rtmutex_common.h"
 
-#ifdef CONFIG_DEBUG_RT_MUTEXES
-# include "rtmutex-debug.h"
-#else
-# include "rtmutex.h"
-#endif
-
 /*
  * lock->owner state tracking:
  *
diff -puN kernel/rtmutex_common.h~futex-tidy-up-the-code kernel/rtmutex_common.h
--- a/kernel/rtmutex_common.h~futex-tidy-up-the-code
+++ a/kernel/rtmutex_common.h
@@ -154,4 +154,11 @@ extern int rt_mutex_adjust_prio_chain(st
 				      struct task_struct *top_task);
 extern void remove_waiter(struct rt_mutex *lock,
 			  struct rt_mutex_waiter *waiter);
+
+#ifdef CONFIG_DEBUG_RT_MUTEXES
+# include "rtmutex-debug.h"
+#else
+# include "rtmutex.h"
+#endif
+
 #endif
_

Patches currently in -mm which might be from tglx@linutronix.de are

futex-revert-the-non-functional-requeue_pi.patch
git-acpi-add-exports.patch
git-arm.patch
s390-spinlock-initializer-cleanup.patch
i386-hpet-check-if-the-counter-works.patch
remove-clockevents_releaserequest_device.patch
add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats.patch
futex-tidy-up-the-code.patch
improve-behaviour-of-spurious-irq-detect.patch
improve-behaviour-of-spurious-irq-detect-fix.patch
lock-debugging-loop-nicer-in-mark_rt_mutex_waiters.patch
lguest-the-host-code.patch
