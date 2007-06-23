From: akpm@linux-foundation.org
Subject: - futex-revert-the-non-functional-requeue_pi.patch removed from -mm tree
Date: Sat, 23 Jun 2007 12:27:56 -0700
Message-ID: <200706231927.l5NJRudr022101@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48370 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755667AbXFWTf1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Jun 2007 15:35:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, drepper@redhat.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Futex: revert the non-functional REQUEUE_PI
has been removed from the -mm tree.  Its filename was
     futex-revert-the-non-functional-requeue_pi.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Futex: revert the non-functional REQUEUE_PI
From: Thomas Gleixner <tglx@linutronix.de>

Patch d0aa7a70bf03b9de9e995ab272293be1f7937822 titled

"futex_requeue_pi optimization"

introduced user space visible changes to the futex syscall.

The patch is non-functional and there is no way to fix it proper before
the 2.6.22 release.

The breakage report ( http://lkml.org/lkml/2007/5/12/17 ) went
unanswered, and unfortunately it turned out that the concept is not
feasible at all. It violates the rtmutex semantics badly by introducing
a virtual owner, which hacks around the coupling of the user-space
pi_futex and the kernel internal rt_mutex representation.

At the moment the only safe option is to remove it fully as it contains
user-space visible changes to broken kernel code, which we do not want
to expose in the 2.6.22 release.

The patch reverts the original patch mostly 1:1, but contains a couple
of trivial manual cleanups which were necessary due to patches, which
touched the same area of code later.

Verified against the glibc tests and my own PI futex tests.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/futex.h   |    9 
 kernel/futex.c          |  415 --------------------------------------
 kernel/futex_compat.c   |    3 
 kernel/rtmutex.c        |   41 ++-
 kernel/rtmutex_common.h |   34 ---
 5 files changed, 43 insertions(+), 459 deletions(-)

diff -puN include/linux/futex.h~futex-revert-the-non-functional-requeue_pi include/linux/futex.h
--- a/include/linux/futex.h~futex-revert-the-non-functional-requeue_pi
+++ a/include/linux/futex.h
@@ -17,7 +17,6 @@ union ktime;
 #define FUTEX_LOCK_PI		6
 #define FUTEX_UNLOCK_PI		7
 #define FUTEX_TRYLOCK_PI	8
-#define FUTEX_CMP_REQUEUE_PI	9
 
 #define FUTEX_PRIVATE_FLAG	128
 #define FUTEX_CMD_MASK		~FUTEX_PRIVATE_FLAG
@@ -98,14 +97,9 @@ struct robust_list_head {
 #define FUTEX_OWNER_DIED	0x40000000
 
 /*
- * Some processes have been requeued on this PI-futex
- */
-#define FUTEX_WAITER_REQUEUED	0x20000000
-
-/*
  * The rest of the robust-futex field is for the TID:
  */
-#define FUTEX_TID_MASK		0x0fffffff
+#define FUTEX_TID_MASK		0x3fffffff
 
 /*
  * This limit protects against a deliberately circular list.
@@ -139,7 +133,6 @@ handle_futex_death(u32 __user *uaddr, st
 #define FUT_OFF_MMSHARED 2 /* We set bit 1 if key has a reference on mm */
 
 union futex_key {
-	u32 __user *uaddr;
 	struct {
 		unsigned long pgoff;
 		struct inode *inode;
diff -puN kernel/futex.c~futex-revert-the-non-functional-requeue_pi kernel/futex.c
--- a/kernel/futex.c~futex-revert-the-non-functional-requeue_pi
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
@@ -111,12 +105,6 @@ struct futex_q {
 	/* Optional priority inheritance state: */
 	struct futex_pi_state *pi_state;
 	struct task_struct *task;
-
-	/*
-	 * This waiter is used in case of requeue from a
-	 * normal futex to a PI-futex
-	 */
-	struct rt_mutex_waiter waiter;
 };
 
 /*
@@ -216,9 +204,6 @@ int get_futex_key(u32 __user *uaddr, str
 	if (unlikely((vma->vm_flags & (VM_IO|VM_READ)) != VM_READ))
 		return (vma->vm_flags & VM_IO) ? -EPERM : -EACCES;
 
-	/* Save the user address in the ley */
-	key->uaddr = uaddr;
-
 	/*
 	 * Private mappings are handled in a simple way.
 	 *
@@ -636,8 +621,6 @@ static int wake_futex_pi(u32 __user *uad
 		int ret = 0;
 
 		newval = FUTEX_WAITERS | new_owner->pid;
-		/* Keep the FUTEX_WAITER_REQUEUED flag if it was set */
-		newval |= (uval & FUTEX_WAITER_REQUEUED);
 
 		pagefault_disable();
 		curval = futex_atomic_cmpxchg_inatomic(uaddr, uval, newval);
@@ -750,259 +733,6 @@ out:
 }
 
 /*
- * Called from futex_requeue_pi.
- * Set FUTEX_WAITERS and FUTEX_WAITER_REQUEUED flags on the
- * PI-futex value; search its associated pi_state if an owner exist
- * or create a new one without owner.
- */
-static inline int
-lookup_pi_state_for_requeue(u32 __user *uaddr, struct futex_hash_bucket *hb,
-			    union futex_key *key,
-			    struct futex_pi_state **pi_state)
-{
-	u32 curval, uval, newval;
-
-retry:
-	/*
-	 * We can't handle a fault cleanly because we can't
-	 * release the locks here. Simply return the fault.
-	 */
-	if (get_futex_value_locked(&curval, uaddr))
-		return -EFAULT;
-
-	/* set the flags FUTEX_WAITERS and FUTEX_WAITER_REQUEUED */
-	if ((curval & (FUTEX_WAITERS | FUTEX_WAITER_REQUEUED))
-	    != (FUTEX_WAITERS | FUTEX_WAITER_REQUEUED)) {
-		/*
-		 * No waiters yet, we prepare the futex to have some waiters.
-		 */
-
-		uval = curval;
-		newval = uval | FUTEX_WAITERS | FUTEX_WAITER_REQUEUED;
-
-		pagefault_disable();
-		curval = futex_atomic_cmpxchg_inatomic(uaddr, uval, newval);
-		pagefault_enable();
-
-		if (unlikely(curval == -EFAULT))
-			return -EFAULT;
-		if (unlikely(curval != uval))
-			goto retry;
-	}
-
-	if (!(curval & FUTEX_TID_MASK)
-	    || lookup_pi_state(curval, hb, key, pi_state)) {
-		/* the futex has no owner (yet) or the lookup failed:
-		   allocate one pi_state without owner */
-
-		*pi_state = alloc_pi_state();
-
-		/* Already stores the key: */
-		(*pi_state)->key = *key;
-
-		/* init the mutex without owner */
-		__rt_mutex_init(&(*pi_state)->pi_mutex, NULL);
-	}
-
-	return 0;
-}
-
-/*
- * Keep the first nr_wake waiter from futex1, wake up one,
- * and requeue the next nr_requeue waiters following hashed on
- * one physical page to another physical page (PI-futex uaddr2)
- */
-static int futex_requeue_pi(u32 __user *uaddr1,
-			    struct rw_semaphore *fshared,
-			    u32 __user *uaddr2,
-			    int nr_wake, int nr_requeue, u32 *cmpval)
-{
-	union futex_key key1, key2;
-	struct futex_hash_bucket *hb1, *hb2;
-	struct plist_head *head1;
-	struct futex_q *this, *next;
-	struct futex_pi_state *pi_state2 = NULL;
-	struct rt_mutex_waiter *waiter, *top_waiter = NULL;
-	struct rt_mutex *lock2 = NULL;
-	int ret, drop_count = 0;
-
-	if (refill_pi_state_cache())
-		return -ENOMEM;
-
-retry:
-	/*
-	 * First take all the futex related locks:
-	 */
-	if (fshared)
-		down_read(fshared);
-
-	ret = get_futex_key(uaddr1, fshared, &key1);
-	if (unlikely(ret != 0))
-		goto out;
-	ret = get_futex_key(uaddr2, fshared, &key2);
-	if (unlikely(ret != 0))
-		goto out;
-
-	hb1 = hash_futex(&key1);
-	hb2 = hash_futex(&key2);
-
-	double_lock_hb(hb1, hb2);
-
-	if (likely(cmpval != NULL)) {
-		u32 curval;
-
-		ret = get_futex_value_locked(&curval, uaddr1);
-
-		if (unlikely(ret)) {
-			spin_unlock(&hb1->lock);
-			if (hb1 != hb2)
-				spin_unlock(&hb2->lock);
-
-			/*
-			 * If we would have faulted, release mmap_sem, fault
-			 * it in and start all over again.
-			 */
-			if (fshared)
-				up_read(fshared);
-
-			ret = get_user(curval, uaddr1);
-
-			if (!ret)
-				goto retry;
-
-			return ret;
-		}
-		if (curval != *cmpval) {
-			ret = -EAGAIN;
-			goto out_unlock;
-		}
-	}
-
-	head1 = &hb1->chain;
-	plist_for_each_entry_safe(this, next, head1, list) {
-		if (!match_futex (&this->key, &key1))
-			continue;
-		if (++ret <= nr_wake) {
-			wake_futex(this);
-		} else {
-			/*
-			 * FIRST: get and set the pi_state
-			 */
-			if (!pi_state2) {
-				int s;
-				/* do this only the first time we requeue someone */
-				s = lookup_pi_state_for_requeue(uaddr2, hb2,
-								&key2, &pi_state2);
-				if (s) {
-					ret = s;
-					goto out_unlock;
-				}
-
-				lock2 = &pi_state2->pi_mutex;
-				spin_lock(&lock2->wait_lock);
-
-				/* Save the top waiter of the wait_list */
-				if (rt_mutex_has_waiters(lock2))
-					top_waiter = rt_mutex_top_waiter(lock2);
-			} else
-				atomic_inc(&pi_state2->refcount);
-
-
-			this->pi_state = pi_state2;
-
-			/*
-			 * SECOND: requeue futex_q to the correct hashbucket
-			 */
-
-			/*
-			 * If key1 and key2 hash to the same bucket, no need to
-			 * requeue.
-			 */
-			if (likely(head1 != &hb2->chain)) {
-				plist_del(&this->list, &hb1->chain);
-				plist_add(&this->list, &hb2->chain);
-				this->lock_ptr = &hb2->lock;
-#ifdef CONFIG_DEBUG_PI_LIST
-				this->list.plist.lock = &hb2->lock;
-#endif
-			}
-			this->key = key2;
-			get_futex_key_refs(&key2);
-			drop_count++;
-
-
-			/*
-			 * THIRD: queue it to lock2
-			 */
-			spin_lock_irq(&this->task->pi_lock);
-			waiter = &this->waiter;
-			waiter->task = this->task;
-			waiter->lock = lock2;
-			plist_node_init(&waiter->list_entry, this->task->prio);
-			plist_node_init(&waiter->pi_list_entry, this->task->prio);
-			plist_add(&waiter->list_entry, &lock2->wait_list);
-			this->task->pi_blocked_on = waiter;
-			spin_unlock_irq(&this->task->pi_lock);
-
-			if (ret - nr_wake >= nr_requeue)
-				break;
-		}
-	}
-
-	/* If we've requeued some tasks and the top_waiter of the rt_mutex
-	   has changed, we must adjust the priority of the owner, if any */
-	if (drop_count) {
-		struct task_struct *owner = rt_mutex_owner(lock2);
-		if (owner &&
-		    (top_waiter != (waiter = rt_mutex_top_waiter(lock2)))) {
-			int chain_walk = 0;
-
-			spin_lock_irq(&owner->pi_lock);
-			if (top_waiter)
-				plist_del(&top_waiter->pi_list_entry, &owner->pi_waiters);
-			else
-				/*
-				 * There was no waiters before the requeue,
-				 * the flag must be updated
-				 */
-				mark_rt_mutex_waiters(lock2);
-
-			plist_add(&waiter->pi_list_entry, &owner->pi_waiters);
-			__rt_mutex_adjust_prio(owner);
-			if (owner->pi_blocked_on) {
-				chain_walk = 1;
-				get_task_struct(owner);
-			}
-
-			spin_unlock_irq(&owner->pi_lock);
-			spin_unlock(&lock2->wait_lock);
-
-			if (chain_walk)
-				rt_mutex_adjust_prio_chain(owner, 0, lock2, NULL,
-							   current);
-		} else {
-			/* No owner or the top_waiter does not change */
-			mark_rt_mutex_waiters(lock2);
-			spin_unlock(&lock2->wait_lock);
-		}
-	}
-
-out_unlock:
-	spin_unlock(&hb1->lock);
-	if (hb1 != hb2)
-		spin_unlock(&hb2->lock);
-
-	/* drop_futex_key_refs() must be called outside the spinlocks. */
-	while (--drop_count >= 0)
-		drop_futex_key_refs(&key1);
-
-out:
-	if (fshared)
-		up_read(fshared);
-	return ret;
-}
-
-/*
  * Wake up all waiters hashed on the physical page that is mapped
  * to this virtual address:
  */
@@ -1384,7 +1114,6 @@ static int fixup_pi_state_owner(u32 __us
 
 	while (!ret) {
 		newval = (uval & FUTEX_OWNER_DIED) | newtid;
-		newval |= (uval & FUTEX_WAITER_REQUEUED);
 
 		pagefault_disable();
 		curval = futex_atomic_cmpxchg_inatomic(uaddr,
@@ -1416,7 +1145,7 @@ static int futex_wait(u32 __user *uaddr,
 	struct futex_q q;
 	u32 uval;
 	int ret;
-	struct hrtimer_sleeper t, *to = NULL;
+	struct hrtimer_sleeper t;
 	int rem = 0;
 
 	q.pi_state = NULL;
@@ -1472,14 +1201,6 @@ static int futex_wait(u32 __user *uaddr,
 	if (uval != val)
 		goto out_unlock_release_sem;
 
-	/*
-	 * This rt_mutex_waiter structure is prepared here and will
-	 * be used only if this task is requeued from a normal futex to
-	 * a PI-futex with futex_requeue_pi.
-	 */
-	debug_rt_mutex_init_waiter(&q.waiter);
-	q.waiter.task = NULL;
-
 	/* Only actually queue if *uaddr contained val.  */
 	__queue_me(&q, hb);
 
@@ -1510,7 +1231,6 @@ static int futex_wait(u32 __user *uaddr,
 		if (!abs_time)
 			schedule();
 		else {
-			to = &t;
 			hrtimer_init(&t.timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
 			hrtimer_init_sleeper(&t, current);
 			t.timer.expires = *abs_time;
@@ -1538,67 +1258,6 @@ static int futex_wait(u32 __user *uaddr,
 	 * we are the only user of it.
 	 */
 
-	if (q.pi_state) {
-		/*
-		 * We were woken but have been requeued on a PI-futex.
-		 * We have to complete the lock acquisition by taking
-		 * the rtmutex.
-		 */
-
-		struct rt_mutex *lock = &q.pi_state->pi_mutex;
-
-		spin_lock(&lock->wait_lock);
-		if (unlikely(q.waiter.task)) {
-			remove_waiter(lock, &q.waiter);
-		}
-		spin_unlock(&lock->wait_lock);
-
-		if (rem)
-			ret = -ETIMEDOUT;
-		else
-			ret = rt_mutex_timed_lock(lock, to, 1);
-
-		if (fshared)
-			down_read(fshared);
-		spin_lock(q.lock_ptr);
-
-		/*
-		 * Got the lock. We might not be the anticipated owner if we
-		 * did a lock-steal - fix up the PI-state in that case.
-		 */
-		if (!ret && q.pi_state->owner != curr) {
-			/*
-			 * We MUST play with the futex we were requeued on,
-			 * NOT the current futex.
-			 * We can retrieve it from the key of the pi_state
-			 */
-			uaddr = q.pi_state->key.uaddr;
-
-			ret = fixup_pi_state_owner(uaddr, &q, curr);
-		} else {
-			/*
-			 * Catch the rare case, where the lock was released
-			 * when we were on the way back before we locked
-			 * the hash bucket.
-			 */
-			if (ret && q.pi_state->owner == curr) {
-				if (rt_mutex_trylock(&q.pi_state->pi_mutex))
-					ret = 0;
-			}
-		}
-
-		/* Unqueue and drop the lock */
-		unqueue_me_pi(&q);
-		if (fshared)
-			up_read(fshared);
-
-		debug_rt_mutex_free_waiter(&q.waiter);
-
-		return ret;
-	}
-
-	debug_rt_mutex_free_waiter(&q.waiter);
-
 	/* If we were woken (and unqueued), we succeeded, whatever. */
 	if (!unqueue_me(&q))
 		return 0;
@@ -1648,51 +1307,6 @@ static long futex_wait_restart(struct re
 }
 
 
-static void set_pi_futex_owner(struct futex_hash_bucket *hb,
-			       union futex_key *key, struct task_struct *p)
-{
-	struct plist_head *head;
-	struct futex_q *this, *next;
-	struct futex_pi_state *pi_state = NULL;
-	struct rt_mutex *lock;
-
-	/* Search a waiter that should already exists */
-
-	head = &hb->chain;
-
-	plist_for_each_entry_safe(this, next, head, list) {
-		if (match_futex (&this->key, key)) {
-			pi_state = this->pi_state;
-			break;
-		}
-	}
-
-	BUG_ON(!pi_state);
-
-	/* set p as pi_state's owner */
-	lock = &pi_state->pi_mutex;
-
-	spin_lock(&lock->wait_lock);
-	spin_lock_irq(&p->pi_lock);
-
-	list_add(&pi_state->list, &p->pi_state_list);
-	pi_state->owner = p;
-
-
-	/* set p as pi_mutex's owner */
-	debug_rt_mutex_proxy_lock(lock, p);
-	WARN_ON(rt_mutex_owner(lock));
-	rt_mutex_set_owner(lock, p, 0);
-	rt_mutex_deadlock_account_lock(lock, p);
-
-	plist_add(&rt_mutex_top_waiter(lock)->pi_list_entry,
-		  &p->pi_waiters);
-	__rt_mutex_adjust_prio(p);
-
-	spin_unlock_irq(&p->pi_lock);
-	spin_unlock(&lock->wait_lock);
-}
-
 /*
  * Userspace tried a 0 -> TID atomic transition of the futex value
  * and failed. The kernel side here does the whole locking operation:
@@ -1753,8 +1367,7 @@ static int futex_lock_pi(u32 __user *uad
 	 * situation and we return success to user space.
 	 */
 	if (unlikely((curval & FUTEX_TID_MASK) == current->pid)) {
-		if (!(curval & FUTEX_WAITER_REQUEUED))
-			ret = -EDEADLK;
+		ret = -EDEADLK;
 		goto out_unlock_release_sem;
 	}
 
@@ -1774,14 +1387,14 @@ static int futex_lock_pi(u32 __user *uad
 
 	/*
 	 * There are two cases, where a futex might have no owner (the
-	 * owner TID is 0): OWNER_DIED or REQUEUE. We take over the
-	 * futex in this case. We also do an unconditional take over,
-	 * when the owner of the futex died.
+	 * owner TID is 0): OWNER_DIED. We take over the futex in this
+	 * case. We also do an unconditional take over, when the owner
+	 * of the futex died.
 	 *
 	 * This is safe as we are protected by the hash bucket lock !
 	 */
 	if (unlikely(ownerdied || !(curval & FUTEX_TID_MASK))) {
-		/* Keep the OWNER_DIED and REQUEUE bits */
+		/* Keep the OWNER_DIED bit */
 		newval = (curval & ~FUTEX_TID_MASK) | current->pid;
 		ownerdied = 0;
 		lock_taken = 1;
@@ -1797,14 +1410,10 @@ static int futex_lock_pi(u32 __user *uad
 		goto retry_locked;
 
 	/*
-	 * We took the lock due to requeue or owner died take over.
+	 * We took the lock due to owner died take over.
 	 */
-	if (unlikely(lock_taken)) {
-		/* For requeue we need to fixup the pi_futex */
-		if (curval & FUTEX_WAITER_REQUEUED)
-			set_pi_futex_owner(hb, &q.key, curr);
+	if (unlikely(lock_taken))
 		goto out_unlock_release_sem;
-	}
 
 	/*
 	 * We dont have the lock. Look up the PI state (or create it if
@@ -2289,8 +1898,6 @@ retry:
 		 * userspace.
 		 */
 		mval = (uval & FUTEX_WAITERS) | FUTEX_OWNER_DIED;
-		/* Also keep the FUTEX_WAITER_REQUEUED flag if set */
-		mval |= (uval & FUTEX_WAITER_REQUEUED);
 		nval = futex_atomic_cmpxchg_inatomic(uaddr, uval, mval);
 
 		if (nval == -EFAULT)
@@ -2427,9 +2034,6 @@ long do_futex(u32 __user *uaddr, int op,
 	case FUTEX_TRYLOCK_PI:
 		ret = futex_lock_pi(uaddr, fshared, 0, timeout, 1);
 		break;
-	case FUTEX_CMP_REQUEUE_PI:
-		ret = futex_requeue_pi(uaddr, fshared, uaddr2, val, val2, &val3);
-		break;
 	default:
 		ret = -ENOSYS;
 	}
@@ -2460,8 +2064,7 @@ asmlinkage long sys_futex(u32 __user *ua
 	/*
 	 * requeue parameter in 'utime' if cmd == FUTEX_REQUEUE.
 	 */
-	if (cmd == FUTEX_REQUEUE || cmd == FUTEX_CMP_REQUEUE
-	    || cmd == FUTEX_CMP_REQUEUE_PI)
+	if (cmd == FUTEX_REQUEUE || cmd == FUTEX_CMP_REQUEUE)
 		val2 = (u32) (unsigned long) utime;
 
 	return do_futex(uaddr, op, val, tp, uaddr2, val2, val3);
diff -puN kernel/futex_compat.c~futex-revert-the-non-functional-requeue_pi kernel/futex_compat.c
--- a/kernel/futex_compat.c~futex-revert-the-non-functional-requeue_pi
+++ a/kernel/futex_compat.c
@@ -157,8 +157,7 @@ asmlinkage long compat_sys_futex(u32 __u
 			t = ktime_add(ktime_get(), t);
 		tp = &t;
 	}
-	if (cmd == FUTEX_REQUEUE || cmd == FUTEX_CMP_REQUEUE
-	    || cmd == FUTEX_CMP_REQUEUE_PI)
+	if (cmd == FUTEX_REQUEUE || cmd == FUTEX_CMP_REQUEUE)
 		val2 = (int) (unsigned long) utime;
 
 	return do_futex(uaddr, op, val, tp, uaddr2, val2, val3);
diff -puN kernel/rtmutex.c~futex-revert-the-non-functional-requeue_pi kernel/rtmutex.c
--- a/kernel/rtmutex.c~futex-revert-the-non-functional-requeue_pi
+++ a/kernel/rtmutex.c
@@ -56,7 +56,7 @@
  * state.
  */
 
-void
+static void
 rt_mutex_set_owner(struct rt_mutex *lock, struct task_struct *owner,
 		   unsigned long mask)
 {
@@ -81,6 +81,29 @@ static void fixup_rt_mutex_waiters(struc
 }
 
 /*
+ * We can speed up the acquire/release, if the architecture
+ * supports cmpxchg and if there's no debugging state to be set up
+ */
+#if defined(__HAVE_ARCH_CMPXCHG) && !defined(CONFIG_DEBUG_RT_MUTEXES)
+# define rt_mutex_cmpxchg(l,c,n)	(cmpxchg(&l->owner, c, n) == c)
+static inline void mark_rt_mutex_waiters(struct rt_mutex *lock)
+{
+	unsigned long owner, *p = (unsigned long *) &lock->owner;
+
+	do {
+		owner = *p;
+	} while (cmpxchg(p, owner, owner | RT_MUTEX_HAS_WAITERS) != owner);
+}
+#else
+# define rt_mutex_cmpxchg(l,c,n)	(0)
+static inline void mark_rt_mutex_waiters(struct rt_mutex *lock)
+{
+	lock->owner = (struct task_struct *)
+			((unsigned long)lock->owner | RT_MUTEX_HAS_WAITERS);
+}
+#endif
+
+/*
  * Calculate task priority from the waiter list priority
  *
  * Return task->normal_prio when the waiter list is empty or when
@@ -100,7 +123,7 @@ int rt_mutex_getprio(struct task_struct 
  *
  * This can be both boosting and unboosting. task->pi_lock must be held.
  */
-void __rt_mutex_adjust_prio(struct task_struct *task)
+static void __rt_mutex_adjust_prio(struct task_struct *task)
 {
 	int prio = rt_mutex_getprio(task);
 
@@ -136,11 +159,11 @@ int max_lock_depth = 1024;
  * Decreases task's usage by one - may thus free the task.
  * Returns 0 or -EDEADLK.
  */
-int rt_mutex_adjust_prio_chain(struct task_struct *task,
-			       int deadlock_detect,
-			       struct rt_mutex *orig_lock,
-			       struct rt_mutex_waiter *orig_waiter,
-			       struct task_struct *top_task)
+static int rt_mutex_adjust_prio_chain(struct task_struct *task,
+				      int deadlock_detect,
+				      struct rt_mutex *orig_lock,
+				      struct rt_mutex_waiter *orig_waiter,
+				      struct task_struct *top_task)
 {
 	struct rt_mutex *lock;
 	struct rt_mutex_waiter *waiter, *top_waiter = orig_waiter;
@@ -514,8 +537,8 @@ static void wakeup_next_waiter(struct rt
  *
  * Must be called with lock->wait_lock held
  */
-void remove_waiter(struct rt_mutex *lock,
-		   struct rt_mutex_waiter *waiter)
+static void remove_waiter(struct rt_mutex *lock,
+			  struct rt_mutex_waiter *waiter)
 {
 	int first = (waiter == rt_mutex_top_waiter(lock));
 	struct task_struct *owner = rt_mutex_owner(lock);
diff -puN kernel/rtmutex_common.h~futex-revert-the-non-functional-requeue_pi kernel/rtmutex_common.h
--- a/kernel/rtmutex_common.h~futex-revert-the-non-functional-requeue_pi
+++ a/kernel/rtmutex_common.h
@@ -113,29 +113,6 @@ static inline unsigned long rt_mutex_own
 }
 
 /*
- * We can speed up the acquire/release, if the architecture
- * supports cmpxchg and if there's no debugging state to be set up
- */
-#if defined(__HAVE_ARCH_CMPXCHG) && !defined(CONFIG_DEBUG_RT_MUTEXES)
-# define rt_mutex_cmpxchg(l,c,n)	(cmpxchg(&l->owner, c, n) == c)
-static inline void mark_rt_mutex_waiters(struct rt_mutex *lock)
-{
-	unsigned long owner, *p = (unsigned long *) &lock->owner;
-
-	do {
-		owner = *p;
-	} while (cmpxchg(p, owner, owner | RT_MUTEX_HAS_WAITERS) != owner);
-}
-#else
-# define rt_mutex_cmpxchg(l,c,n)	(0)
-static inline void mark_rt_mutex_waiters(struct rt_mutex *lock)
-{
-	lock->owner = (struct task_struct *)
-			((unsigned long)lock->owner | RT_MUTEX_HAS_WAITERS);
-}
-#endif
-
-/*
  * PI-futex support (proxy locking functions, etc.):
  */
 extern struct task_struct *rt_mutex_next_owner(struct rt_mutex *lock);
@@ -143,15 +120,4 @@ extern void rt_mutex_init_proxy_locked(s
 				       struct task_struct *proxy_owner);
 extern void rt_mutex_proxy_unlock(struct rt_mutex *lock,
 				  struct task_struct *proxy_owner);
-
-extern void rt_mutex_set_owner(struct rt_mutex *lock, struct task_struct *owner,
-			       unsigned long mask);
-extern void __rt_mutex_adjust_prio(struct task_struct *task);
-extern int rt_mutex_adjust_prio_chain(struct task_struct *task,
-				      int deadlock_detect,
-				      struct rt_mutex *orig_lock,
-				      struct rt_mutex_waiter *orig_waiter,
-				      struct task_struct *top_task);
-extern void remove_waiter(struct rt_mutex *lock,
-			  struct rt_mutex_waiter *waiter);
 #endif
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-acpi-add-exports.patch
git-arm.patch
i386-hpet-check-if-the-counter-works.patch
remove-clockevents_releaserequest_device.patch
add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats.patch
improve-behaviour-of-spurious-irq-detect.patch
improve-behaviour-of-spurious-irq-detect-fix.patch
lguest-the-host-code.patch
