From: akpm@linux-foundation.org
Subject: - futex-tidy-up-the-code-v2.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:57:41 -0700
Message-ID: <200707162057.l6GKvfrG002215@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54756 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759207AbXGPVRM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:17:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     FUTEX: Tidy up the code
has been removed from the -mm tree.  Its filename was
     futex-tidy-up-the-code-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: FUTEX: Tidy up the code
From: Thomas Gleixner <tglx@linutronix.de>

The recent PRIVATE and REQUEUE_PI changes to the futex code made it hard to
read.  Tidy it up.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/futex.c          |  138 ++++++++++++++++++--------------------
 kernel/rtmutex-debug.c  |    6 -
 kernel/rtmutex.c        |    6 -
 kernel/rtmutex_common.h |    9 ++
 4 files changed, 74 insertions(+), 85 deletions(-)

diff -puN kernel/futex.c~futex-tidy-up-the-code-v2 kernel/futex.c
--- a/kernel/futex.c~futex-tidy-up-the-code-v2
+++ a/kernel/futex.c
@@ -121,6 +121,24 @@ static struct futex_hash_bucket futex_qu
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
@@ -287,7 +305,18 @@ void drop_futex_key_refs(union futex_key
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
 
@@ -620,9 +649,7 @@ static int wake_futex_pi(u32 __user *uad
 
 		newval = FUTEX_WAITERS | new_owner->pid;
 
-		pagefault_disable();
-		curval = futex_atomic_cmpxchg_inatomic(uaddr, uval, newval);
-		pagefault_enable();
+		curval = cmpxchg_futex_value_locked(uaddr, uval, newval);
 
 		if (curval == -EFAULT)
 			ret = -EFAULT;
@@ -659,9 +686,7 @@ static int unlock_futex_pi(u32 __user *u
 	 * There is no waiter, so we unlock the futex. The owner died
 	 * bit has not to be preserved here. We are the owner:
 	 */
-	pagefault_disable();
-	oldval = futex_atomic_cmpxchg_inatomic(uaddr, uval, 0);
-	pagefault_enable();
+	oldval = cmpxchg_futex_value_locked(uaddr, uval, 0);
 
 	if (oldval == -EFAULT)
 		return oldval;
@@ -700,8 +725,7 @@ static int futex_wake(u32 __user *uaddr,
 	union futex_key key;
 	int ret;
 
-	if (fshared)
-		down_read(fshared);
+	futex_lock_mm(fshared);
 
 	ret = get_futex_key(uaddr, fshared, &key);
 	if (unlikely(ret != 0))
@@ -725,8 +749,7 @@ static int futex_wake(u32 __user *uaddr,
 
 	spin_unlock(&hb->lock);
 out:
-	if (fshared)
-		up_read(fshared);
+	futex_unlock_mm(fshared);
 	return ret;
 }
 
@@ -746,8 +769,7 @@ futex_wake_op(u32 __user *uaddr1, struct
 	int ret, op_ret, attempt = 0;
 
 retryfull:
-	if (fshared)
-		down_read(fshared);
+	futex_lock_mm(fshared);
 
 	ret = get_futex_key(uaddr1, fshared, &key1);
 	if (unlikely(ret != 0))
@@ -793,7 +815,7 @@ retry:
 		 */
 		if (attempt++) {
 			ret = futex_handle_fault((unsigned long)uaddr2,
-						fshared, attempt);
+						 fshared, attempt);
 			if (ret)
 				goto out;
 			goto retry;
@@ -803,8 +825,7 @@ retry:
 		 * If we would have faulted, release mmap_sem,
 		 * fault it in and start all over again.
 		 */
-		if (fshared)
-			up_read(fshared);
+		futex_unlock_mm(fshared);
 
 		ret = get_user(dummy, uaddr2);
 		if (ret)
@@ -841,8 +862,8 @@ retry:
 	if (hb1 != hb2)
 		spin_unlock(&hb2->lock);
 out:
-	if (fshared)
-		up_read(fshared);
+	futex_unlock_mm(fshared);
+
 	return ret;
 }
 
@@ -861,8 +882,7 @@ static int futex_requeue(u32 __user *uad
 	int ret, drop_count = 0;
 
  retry:
-	if (fshared)
-		down_read(fshared);
+	futex_lock_mm(fshared);
 
 	ret = get_futex_key(uaddr1, fshared, &key1);
 	if (unlikely(ret != 0))
@@ -890,8 +910,7 @@ static int futex_requeue(u32 __user *uad
 			 * If we would have faulted, release mmap_sem, fault
 			 * it in and start all over again.
 			 */
-			if (fshared)
-				up_read(fshared);
+			futex_unlock_mm(fshared);
 
 			ret = get_user(curval, uaddr1);
 
@@ -944,8 +963,7 @@ out_unlock:
 		drop_futex_key_refs(&key1);
 
 out:
-	if (fshared)
-		up_read(fshared);
+	futex_unlock_mm(fshared);
 	return ret;
 }
 
@@ -1113,10 +1131,7 @@ static int fixup_pi_state_owner(u32 __us
 	while (!ret) {
 		newval = (uval & FUTEX_OWNER_DIED) | newtid;
 
-		pagefault_disable();
-		curval = futex_atomic_cmpxchg_inatomic(uaddr,
-						       uval, newval);
-		pagefault_enable();
+		curval = cmpxchg_futex_value_locked(uaddr, uval, newval);
 
 		if (curval == -EFAULT)
 			ret = -EFAULT;
@@ -1134,6 +1149,7 @@ static int fixup_pi_state_owner(u32 __us
 #define ARG3_SHARED  1
 
 static long futex_wait_restart(struct restart_block *restart);
+
 static int futex_wait(u32 __user *uaddr, struct rw_semaphore *fshared,
 		      u32 val, ktime_t *abs_time)
 {
@@ -1148,8 +1164,7 @@ static int futex_wait(u32 __user *uaddr,
 
 	q.pi_state = NULL;
  retry:
-	if (fshared)
-		down_read(fshared);
+	futex_lock_mm(fshared);
 
 	ret = get_futex_key(uaddr, fshared, &q.key);
 	if (unlikely(ret != 0))
@@ -1186,8 +1201,7 @@ static int futex_wait(u32 __user *uaddr,
 		 * If we would have faulted, release mmap_sem, fault it in and
 		 * start all over again.
 		 */
-		if (fshared)
-			up_read(fshared);
+		futex_unlock_mm(fshared);
 
 		ret = get_user(uval, uaddr);
 
@@ -1206,8 +1220,7 @@ static int futex_wait(u32 __user *uaddr,
 	 * Now the futex is queued and we have checked the data, we
 	 * don't want to hold mmap_sem while we sleep.
 	 */
-	if (fshared)
-		up_read(fshared);
+	futex_unlock_mm(fshared);
 
 	/*
 	 * There might have been scheduling since the queue_me(), as we
@@ -1285,8 +1298,7 @@ static int futex_wait(u32 __user *uaddr,
 	queue_unlock(&q, hb);
 
  out_release_sem:
-	if (fshared)
-		up_read(fshared);
+	futex_unlock_mm(fshared);
 	return ret;
 }
 
@@ -1333,8 +1345,7 @@ static int futex_lock_pi(u32 __user *uad
 
 	q.pi_state = NULL;
  retry:
-	if (fshared)
-		down_read(fshared);
+	futex_lock_mm(fshared);
 
 	ret = get_futex_key(uaddr, fshared, &q.key);
 	if (unlikely(ret != 0))
@@ -1353,9 +1364,7 @@ static int futex_lock_pi(u32 __user *uad
 	 */
 	newval = current->pid;
 
-	pagefault_disable();
-	curval = futex_atomic_cmpxchg_inatomic(uaddr, 0, newval);
-	pagefault_enable();
+	curval = cmpxchg_futex_value_locked(uaddr, 0, newval);
 
 	if (unlikely(curval == -EFAULT))
 		goto uaddr_faulted;
@@ -1398,9 +1407,7 @@ static int futex_lock_pi(u32 __user *uad
 		lock_taken = 1;
 	}
 
-	pagefault_disable();
-	curval = futex_atomic_cmpxchg_inatomic(uaddr, uval, newval);
-	pagefault_enable();
+	curval = cmpxchg_futex_value_locked(uaddr, uval, newval);
 
 	if (unlikely(curval == -EFAULT))
 		goto uaddr_faulted;
@@ -1428,8 +1435,7 @@ static int futex_lock_pi(u32 __user *uad
 			 * exit to complete.
 			 */
 			queue_unlock(&q, hb);
-			if (fshared)
-				up_read(fshared);
+			futex_unlock_mm(fshared);
 			cond_resched();
 			goto retry;
 
@@ -1465,8 +1471,7 @@ static int futex_lock_pi(u32 __user *uad
 	 * Now the futex is queued and we have checked the data, we
 	 * don't want to hold mmap_sem while we sleep.
 	 */
-	if (fshared)
-		up_read(fshared);
+	futex_unlock_mm(fshared);
 
 	WARN_ON(!q.pi_state);
 	/*
@@ -1480,8 +1485,7 @@ static int futex_lock_pi(u32 __user *uad
 		ret = ret ? 0 : -EWOULDBLOCK;
 	}
 
-	if (fshared)
-		down_read(fshared);
+	futex_lock_mm(fshared);
 	spin_lock(q.lock_ptr);
 
 	if (!ret) {
@@ -1518,8 +1522,7 @@ static int futex_lock_pi(u32 __user *uad
 
 	/* Unqueue and drop the lock */
 	unqueue_me_pi(&q);
-	if (fshared)
-		up_read(fshared);
+	futex_unlock_mm(fshared);
 
 	return ret != -EINTR ? ret : -ERESTARTNOINTR;
 
@@ -1527,8 +1530,7 @@ static int futex_lock_pi(u32 __user *uad
 	queue_unlock(&q, hb);
 
  out_release_sem:
-	if (fshared)
-		up_read(fshared);
+	futex_unlock_mm(fshared);
 	return ret;
 
  uaddr_faulted:
@@ -1550,8 +1552,7 @@ static int futex_lock_pi(u32 __user *uad
 		goto retry_unlocked;
 	}
 
-	if (fshared)
-		up_read(fshared);
+	futex_unlock_mm(fshared);
 
 	ret = get_user(uval, uaddr);
 	if (!ret && (uval != -EFAULT))
@@ -1585,8 +1586,7 @@ retry:
 	/*
 	 * First take all the futex related locks:
 	 */
-	if (fshared)
-		down_read(fshared);
+	futex_lock_mm(fshared);
 
 	ret = get_futex_key(uaddr, fshared, &key);
 	if (unlikely(ret != 0))
@@ -1601,11 +1601,9 @@ retry_unlocked:
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
+
 
 	if (unlikely(uval == -EFAULT))
 		goto pi_faulted;
@@ -1647,8 +1645,7 @@ retry_unlocked:
 out_unlock:
 	spin_unlock(&hb->lock);
 out:
-	if (fshared)
-		up_read(fshared);
+	futex_unlock_mm(fshared);
 
 	return ret;
 
@@ -1671,8 +1668,7 @@ pi_faulted:
 		goto retry_unlocked;
 	}
 
-	if (fshared)
-		up_read(fshared);
+	futex_unlock_mm(fshared);
 
 	ret = get_user(uval, uaddr);
 	if (!ret && (uval != -EFAULT))
@@ -1729,8 +1725,8 @@ static int futex_fd(u32 __user *uaddr, i
 
 	if (printk_timed_ratelimit(&printk_interval, 60 * 60 * 1000)) {
 		printk(KERN_WARNING "Process `%s' used FUTEX_FD, which "
-		    	"will be removed from the kernel in June 2007\n",
-			current->comm);
+		       "will be removed from the kernel in June 2007\n",
+		       current->comm);
 	}
 
 	ret = -EINVAL;
@@ -1908,10 +1904,8 @@ retry:
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
diff -puN kernel/rtmutex-debug.c~futex-tidy-up-the-code-v2 kernel/rtmutex-debug.c
--- a/kernel/rtmutex-debug.c~futex-tidy-up-the-code-v2
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
 
diff -puN kernel/rtmutex.c~futex-tidy-up-the-code-v2 kernel/rtmutex.c
--- a/kernel/rtmutex.c~futex-tidy-up-the-code-v2
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
diff -puN kernel/rtmutex_common.h~futex-tidy-up-the-code-v2 kernel/rtmutex_common.h
--- a/kernel/rtmutex_common.h~futex-tidy-up-the-code-v2
+++ a/kernel/rtmutex_common.h
@@ -103,7 +103,7 @@ static inline struct task_struct *rt_mut
 
 static inline struct task_struct *rt_mutex_real_owner(struct rt_mutex *lock)
 {
- 	return (struct task_struct *)
+	return (struct task_struct *)
 		((unsigned long)lock->owner & ~RT_MUTEX_HAS_WAITERS);
 }
 
@@ -120,4 +120,11 @@ extern void rt_mutex_init_proxy_locked(s
 				       struct task_struct *proxy_owner);
 extern void rt_mutex_proxy_unlock(struct rt_mutex *lock,
 				  struct task_struct *proxy_owner);
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

origin.patch
git-acpi.patch
i386-hpet-check-if-the-counter-works.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
acpi-move-timer-broadcast-and-pmtimer-access-before-c3-arbiter-shutdown.patch
timekeeping-fixup-shadow-variable-argument.patch
timerc-cleanup-recently-introduced-whitespace-damage.patch
clockevents-remove-prototypes-of-removed-functions.patch
clockevents-fix-resume-logic.patch
clockevents-fix-device-replacement.patch
tick-management-spread-timer-interrupt.patch
highres-improve-debug-output.patch
hrtimer-speedup-hrtimer_enqueue.patch
pcspkr-use-the-global-pit-lock.patch
ntp-move-the-cmos-update-code-into-ntpc.patch
i386-pit-stop-only-when-in-periodic-or-oneshot-mode.patch
i386-remove-volatile-in-apicc.patch
i386-hpet-assumes-boot-cpu-is-0.patch
i386-move-pit-function-declarations-and-constants-to-correct-header-file.patch
x86_64-untangle-asm-hpeth-from-asm-timexh.patch
x86_64-use-generic-cmos-update.patch
x86_64-remove-dead-code-and-other-janitor-work-in-tscc.patch
x86_64-fix-apic-typo.patch
x86_64-convert-to-cleckevents.patch
acpi-remove-the-useless-ifdef-code.patch
x86_64-hpet-restore-vread.patch
x86_64-restore-restore-nohpet-cmdline.patch
x86_64-block-irq-balancing-for-timer.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-enable-high-resolution-timers-and-dynticks.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
ich-force-hpet-make-generic-time-capable-of-switching-broadcast-timer.patch
ich-force-hpet-restructure-hpet-generic-clock-code.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable.patch
ich-force-hpet-late-initialization-of-hpet-after-quirk.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable.patch
ich-force-hpet-ich5-fix-a-bug-with-suspend-resume.patch
ich-force-hpet-add-ich7_0-pciid-to-quirk-list.patch
geode-mfgpt-clock-event-device-support.patch
i386-x86_64-insert-hpet-firmware-resource-after-pci-enumeration-has-completed.patch
make-timespec_equal-take-const-arguments.patch
lguest-the-host-code.patch
lguest-the-host-code-lguest-vs-clockevents-fix-resume-logic.patch
