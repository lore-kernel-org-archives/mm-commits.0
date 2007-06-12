From: akpm@linux-foundation.org
Subject: - pi-futex-fix-exit-races-and-locking-problems.patch removed from -mm tree
Date: Tue, 12 Jun 2007 11:57:21 -0700
Message-ID: <200706121857.l5CIvLjp018465@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42456 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750768AbXFLTLt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 15:11:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kuznet@ms2.inr.ac.ru, dada1@cosmosbay.com, drepper@redhat.com, mingo@elte.hu, rostedt@goodmis.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     pi-futex: fix exit races and locking problems
has been removed from the -mm tree.  Its filename was
     pi-futex-fix-exit-races-and-locking-problems.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pi-futex: fix exit races and locking problems
From: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>

1. New entries can be added to tsk->pi_state_list after task completed
   exit_pi_state_list(). The result is memory leakage and deadlocks.

2. handle_mm_fault() is called under spinlock. The result is obvious.

3. results in self-inflicted deadlock inside glibc.
   Sometimes futex_lock_pi returns -ESRCH, when it is not expected
   and glibc enters to for(;;) sleep() to simulate deadlock. This problem
   is quite obvious and I think the patch is right. Though it looks like
   each "if" in futex_lock_pi() got some stupid special case "else if". :-)

4. sometimes futex_lock_pi() returns -EDEADLK,
   when nobody has the lock. The reason is also obvious (see comment
   in the patch), but correct fix is far beyond my comprehension.
   I guess someone already saw this, the chunk:

                        if (rt_mutex_trylock(&q.pi_state->pi_mutex))
                                ret = 0;

   is obviously from the same opera. But it does not work, because the
   rtmutex is really taken at this point: wake_futex_pi() of previous
   owner reassigned it to us. My fix works. But it looks very stupid.
   I would think about removal of shift of ownership in wake_futex_pi()
   and making all the work in context of process taking lock.


Fix 1) Avoid the tasklist lock variant of the exit race fix by adding
    an additional state transition to the exit code.

    This fixes also the issue, when a task with recursive segfaults
    is not able to release the futexes.

Fix 2) Cleanup the lookup_pi_state() failure path and solve the -ESRCH
    problem finally.

Fix 3) Solve the fixup_pi_state_owner() problem which needs to do the fixup
    in the lock protected section by using the in_atomic userspace access
    functions.

    This removes also the ugly lock drop / unqueue inside of fixup_pi_state()

Fix 4) Fix a stale lock in the error path of futex_wake_pi()

Added some error checks for verification.

The -EDEADLK problem is solved by the rtmutex fixups.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    1 
 kernel/exit.c         |   24 +++
 kernel/futex.c        |  271 +++++++++++++++++++++++-----------------
 3 files changed, 184 insertions(+), 112 deletions(-)

diff -puN include/linux/sched.h~pi-futex-fix-exit-races-and-locking-problems include/linux/sched.h
--- a/include/linux/sched.h~pi-futex-fix-exit-races-and-locking-problems
+++ a/include/linux/sched.h
@@ -1162,6 +1162,7 @@ static inline void put_task_struct(struc
 					/* Not implemented yet, only for 486*/
 #define PF_STARTING	0x00000002	/* being created */
 #define PF_EXITING	0x00000004	/* getting shut down */
+#define PF_EXITPIDONE	0x00000008	/* pi exit done on shut down */
 #define PF_FORKNOEXEC	0x00000040	/* forked but didn't exec */
 #define PF_SUPERPRIV	0x00000100	/* used super-user privileges */
 #define PF_DUMPCORE	0x00000200	/* dumped core */
diff -puN kernel/exit.c~pi-futex-fix-exit-races-and-locking-problems kernel/exit.c
--- a/kernel/exit.c~pi-futex-fix-exit-races-and-locking-problems
+++ a/kernel/exit.c
@@ -892,13 +892,29 @@ fastcall NORET_TYPE void do_exit(long co
 	if (unlikely(tsk->flags & PF_EXITING)) {
 		printk(KERN_ALERT
 			"Fixing recursive fault but reboot is needed!\n");
+		/*
+		 * We can do this unlocked here. The futex code uses
+		 * this flag just to verify whether the pi state
+		 * cleanup has been done or not. In the worst case it
+		 * loops once more. We pretend that the cleanup was
+		 * done as there is no way to return. Either the
+		 * OWNER_DIED bit is set by now or we push the blocked
+		 * task into the wait for ever nirwana as well.
+		 */
+		tsk->flags |= PF_EXITPIDONE;
 		if (tsk->io_context)
 			exit_io_context();
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		schedule();
 	}
 
+	/*
+	 * tsk->flags are checked in the futex code to protect against
+	 * an exiting task cleaning up the robust pi futexes.
+	 */
+	spin_lock_irq(&tsk->pi_lock);
 	tsk->flags |= PF_EXITING;
+	spin_unlock_irq(&tsk->pi_lock);
 
 	if (unlikely(in_atomic()))
 		printk(KERN_INFO "note: %s[%d] exited with preempt_count %d\n",
@@ -912,7 +928,7 @@ fastcall NORET_TYPE void do_exit(long co
 	}
 	group_dead = atomic_dec_and_test(&tsk->signal->live);
 	if (group_dead) {
- 		hrtimer_cancel(&tsk->signal->real_timer);
+		hrtimer_cancel(&tsk->signal->real_timer);
 		exit_itimers(tsk->signal);
 	}
 	acct_collect(code, group_dead);
@@ -965,6 +981,12 @@ fastcall NORET_TYPE void do_exit(long co
 	 * Make sure we are holding no locks:
 	 */
 	debug_check_no_locks_held(tsk);
+	/*
+	 * We can do this unlocked here. The futex code uses this flag
+	 * just to verify whether the pi state cleanup has been done
+	 * or not. In the worst case it loops once more.
+	 */
+	tsk->flags |= PF_EXITPIDONE;
 
 	if (tsk->io_context)
 		exit_io_context();
diff -puN kernel/futex.c~pi-futex-fix-exit-races-and-locking-problems kernel/futex.c
--- a/kernel/futex.c~pi-futex-fix-exit-races-and-locking-problems
+++ a/kernel/futex.c
@@ -430,10 +430,6 @@ static struct task_struct * futex_find_g
 		p = NULL;
 		goto out_unlock;
 	}
-	if (p->exit_state != 0) {
-		p = NULL;
-		goto out_unlock;
-	}
 	get_task_struct(p);
 out_unlock:
 	rcu_read_unlock();
@@ -502,7 +498,7 @@ lookup_pi_state(u32 uval, struct futex_h
 	struct futex_q *this, *next;
 	struct plist_head *head;
 	struct task_struct *p;
-	pid_t pid;
+	pid_t pid = uval & FUTEX_TID_MASK;
 
 	head = &hb->chain;
 
@@ -520,6 +516,8 @@ lookup_pi_state(u32 uval, struct futex_h
 				return -EINVAL;
 
 			WARN_ON(!atomic_read(&pi_state->refcount));
+			WARN_ON(pid && pi_state->owner &&
+				pi_state->owner->pid != pid);
 
 			atomic_inc(&pi_state->refcount);
 			*ps = pi_state;
@@ -530,15 +528,33 @@ lookup_pi_state(u32 uval, struct futex_h
 
 	/*
 	 * We are the first waiter - try to look up the real owner and attach
-	 * the new pi_state to it, but bail out when the owner died bit is set
-	 * and TID = 0:
+	 * the new pi_state to it, but bail out when TID = 0
 	 */
-	pid = uval & FUTEX_TID_MASK;
-	if (!pid && (uval & FUTEX_OWNER_DIED))
+	if (!pid)
 		return -ESRCH;
 	p = futex_find_get_task(pid);
-	if (!p)
-		return -ESRCH;
+	if (IS_ERR(p))
+		return PTR_ERR(p);
+
+	/*
+	 * We need to look at the task state flags to figure out,
+	 * whether the task is exiting. To protect against the do_exit
+	 * change of the task flags, we do this protected by
+	 * p->pi_lock:
+	 */
+	spin_lock_irq(&p->pi_lock);
+	if (unlikely(p->flags & PF_EXITING)) {
+		/*
+		 * The task is on the way out. When PF_EXITPIDONE is
+		 * set, we know that the task has finished the
+		 * cleanup:
+		 */
+		int ret = (p->flags & PF_EXITPIDONE) ? -ESRCH : -EAGAIN;
+
+		spin_unlock_irq(&p->pi_lock);
+		put_task_struct(p);
+		return ret;
+	}
 
 	pi_state = alloc_pi_state();
 
@@ -551,7 +567,6 @@ lookup_pi_state(u32 uval, struct futex_h
 	/* Store the key for possible exit cleanups: */
 	pi_state->key = *key;
 
-	spin_lock_irq(&p->pi_lock);
 	WARN_ON(!list_empty(&pi_state->list));
 	list_add(&pi_state->list, &p->pi_state_list);
 	pi_state->owner = p;
@@ -618,6 +633,8 @@ static int wake_futex_pi(u32 __user *uad
 	 * preserve the owner died bit.)
 	 */
 	if (!(uval & FUTEX_OWNER_DIED)) {
+		int ret = 0;
+
 		newval = FUTEX_WAITERS | new_owner->pid;
 		/* Keep the FUTEX_WAITER_REQUEUED flag if it was set */
 		newval |= (uval & FUTEX_WAITER_REQUEUED);
@@ -625,10 +642,15 @@ static int wake_futex_pi(u32 __user *uad
 		pagefault_disable();
 		curval = futex_atomic_cmpxchg_inatomic(uaddr, uval, newval);
 		pagefault_enable();
+
 		if (curval == -EFAULT)
-			return -EFAULT;
+			ret = -EFAULT;
 		if (curval != uval)
-			return -EINVAL;
+			ret = -EINVAL;
+		if (ret) {
+			spin_unlock(&pi_state->pi_mutex.wait_lock);
+			return ret;
+		}
 	}
 
 	spin_lock_irq(&pi_state->owner->pi_lock);
@@ -1174,7 +1196,7 @@ static int futex_requeue(u32 __user *uad
 #ifdef CONFIG_DEBUG_PI_LIST
 				this->list.plist.lock = &hb2->lock;
 #endif
- 			}
+			}
 			this->key = key2;
 			get_futex_key_refs(&key2);
 			drop_count++;
@@ -1326,12 +1348,10 @@ static void unqueue_me_pi(struct futex_q
 /*
  * Fixup the pi_state owner with current.
  *
- * The cur->mm semaphore must be  held, it is released at return of this
- * function.
+ * Must be called with hash bucket lock held and mm->sem held for non
+ * private futexes.
  */
-static int fixup_pi_state_owner(u32 __user *uaddr, struct rw_semaphore *fshared,
-				struct futex_q *q,
-				struct futex_hash_bucket *hb,
+static int fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
 				struct task_struct *curr)
 {
 	u32 newtid = curr->pid | FUTEX_WAITERS;
@@ -1355,23 +1375,24 @@ static int fixup_pi_state_owner(u32 __us
 	list_add(&pi_state->list, &curr->pi_state_list);
 	spin_unlock_irq(&curr->pi_lock);
 
-	/* Unqueue and drop the lock */
-	unqueue_me_pi(q);
-	if (fshared)
-		up_read(fshared);
 	/*
 	 * We own it, so we have to replace the pending owner
 	 * TID. This must be atomic as we have preserve the
 	 * owner died bit here.
 	 */
-	ret = get_user(uval, uaddr);
+	ret = get_futex_value_locked(&uval, uaddr);
+
 	while (!ret) {
 		newval = (uval & FUTEX_OWNER_DIED) | newtid;
 		newval |= (uval & FUTEX_WAITER_REQUEUED);
+
+		pagefault_disable();
 		curval = futex_atomic_cmpxchg_inatomic(uaddr,
 						       uval, newval);
+		pagefault_enable();
+
 		if (curval == -EFAULT)
- 			ret = -EFAULT;
+			ret = -EFAULT;
 		if (curval == uval)
 			break;
 		uval = curval;
@@ -1553,10 +1574,7 @@ static int futex_wait(u32 __user *uaddr,
 			 */
 			uaddr = q.pi_state->key.uaddr;
 
-			/* mmap_sem and hash_bucket lock are unlocked at
-			   return of this function */
-			ret = fixup_pi_state_owner(uaddr, fshared,
-						   &q, hb, curr);
+			ret = fixup_pi_state_owner(uaddr, &q, curr);
 		} else {
 			/*
 			 * Catch the rare case, where the lock was released
@@ -1567,12 +1585,13 @@ static int futex_wait(u32 __user *uaddr,
 				if (rt_mutex_trylock(&q.pi_state->pi_mutex))
 					ret = 0;
 			}
-			/* Unqueue and drop the lock */
-			unqueue_me_pi(&q);
-			if (fshared)
-				up_read(fshared);
 		}
 
+		/* Unqueue and drop the lock */
+		unqueue_me_pi(&q);
+		if (fshared)
+			up_read(fshared);
+
 		debug_rt_mutex_free_waiter(&q.waiter);
 
 		return ret;
@@ -1688,7 +1707,7 @@ static int futex_lock_pi(u32 __user *uad
 	struct futex_hash_bucket *hb;
 	u32 uval, newval, curval;
 	struct futex_q q;
-	int ret, lock_held, attempt = 0;
+	int ret, lock_taken, ownerdied = 0, attempt = 0;
 
 	if (refill_pi_state_cache())
 		return -ENOMEM;
@@ -1709,10 +1728,11 @@ static int futex_lock_pi(u32 __user *uad
 	if (unlikely(ret != 0))
 		goto out_release_sem;
 
+ retry_unlocked:
 	hb = queue_lock(&q, -1, NULL);
 
  retry_locked:
-	lock_held = 0;
+	ret = lock_taken = 0;
 
 	/*
 	 * To avoid races, we attempt to take the lock here again
@@ -1728,43 +1748,44 @@ static int futex_lock_pi(u32 __user *uad
 	if (unlikely(curval == -EFAULT))
 		goto uaddr_faulted;
 
-	/* We own the lock already */
+	/*
+	 * Detect deadlocks. In case of REQUEUE_PI this is a valid
+	 * situation and we return success to user space.
+	 */
 	if (unlikely((curval & FUTEX_TID_MASK) == current->pid)) {
-		if (!detect && 0)
-			force_sig(SIGKILL, current);
-		/*
-		 * Normally, this check is done in user space.
-		 * In case of requeue, the owner may attempt to lock this futex,
-		 * even if the ownership has already been given by the previous
-		 * waker.
-		 * In the usual case, this is a case of deadlock, but not in case
-		 * of REQUEUE_PI.
-		 */
 		if (!(curval & FUTEX_WAITER_REQUEUED))
 			ret = -EDEADLK;
 		goto out_unlock_release_sem;
 	}
 
 	/*
-	 * Surprise - we got the lock. Just return
-	 * to userspace:
+	 * Surprise - we got the lock. Just return to userspace:
 	 */
 	if (unlikely(!curval))
 		goto out_unlock_release_sem;
 
 	uval = curval;
+
 	/*
-	 * In case of a requeue, check if there already is an owner
-	 * If not, just take the futex.
+	 * Set the WAITERS flag, so the owner will know it has someone
+	 * to wake at next unlock
 	 */
-	if ((curval & FUTEX_WAITER_REQUEUED) && !(curval & FUTEX_TID_MASK)) {
-		/* set current as futex owner */
-		newval = curval | current->pid;
-		lock_held = 1;
-	} else
-		/* Set the WAITERS flag, so the owner will know it has someone
-		   to wake at next unlock */
-		newval = curval | FUTEX_WAITERS;
+	newval = curval | FUTEX_WAITERS;
+
+	/*
+	 * There are two cases, where a futex might have no owner (the
+	 * owner TID is 0): OWNER_DIED or REQUEUE. We take over the
+	 * futex in this case. We also do an unconditional take over,
+	 * when the owner of the futex died.
+	 *
+	 * This is safe as we are protected by the hash bucket lock !
+	 */
+	if (unlikely(ownerdied || !(curval & FUTEX_TID_MASK))) {
+		/* Keep the OWNER_DIED and REQUEUE bits */
+		newval = (curval & ~FUTEX_TID_MASK) | current->pid;
+		ownerdied = 0;
+		lock_taken = 1;
+	}
 
 	pagefault_disable();
 	curval = futex_atomic_cmpxchg_inatomic(uaddr, uval, newval);
@@ -1775,8 +1796,13 @@ static int futex_lock_pi(u32 __user *uad
 	if (unlikely(curval != uval))
 		goto retry_locked;
 
-	if (lock_held) {
-		set_pi_futex_owner(hb, &q.key, curr);
+	/*
+	 * We took the lock due to requeue or owner died take over.
+	 */
+	if (unlikely(lock_taken)) {
+		/* For requeue we need to fixup the pi_futex */
+		if (curval & FUTEX_WAITER_REQUEUED)
+			set_pi_futex_owner(hb, &q.key, curr);
 		goto out_unlock_release_sem;
 	}
 
@@ -1787,34 +1813,40 @@ static int futex_lock_pi(u32 __user *uad
 	ret = lookup_pi_state(uval, hb, &q.key, &q.pi_state);
 
 	if (unlikely(ret)) {
-		/*
-		 * There were no waiters and the owner task lookup
-		 * failed. When the OWNER_DIED bit is set, then we
-		 * know that this is a robust futex and we actually
-		 * take the lock. This is safe as we are protected by
-		 * the hash bucket lock. We also set the waiters bit
-		 * unconditionally here, to simplify glibc handling of
-		 * multiple tasks racing to acquire the lock and
-		 * cleanup the problems which were left by the dead
-		 * owner.
-		 */
-		if (curval & FUTEX_OWNER_DIED) {
-			uval = newval;
-			newval = current->pid |
-				FUTEX_OWNER_DIED | FUTEX_WAITERS;
-
-			pagefault_disable();
-			curval = futex_atomic_cmpxchg_inatomic(uaddr,
-							       uval, newval);
-			pagefault_enable();
+		switch (ret) {
 
-			if (unlikely(curval == -EFAULT))
+		case -EAGAIN:
+			/*
+			 * Task is exiting and we just wait for the
+			 * exit to complete.
+			 */
+			queue_unlock(&q, hb);
+			if (fshared)
+				up_read(fshared);
+			cond_resched();
+			goto retry;
+
+		case -ESRCH:
+			/*
+			 * No owner found for this futex. Check if the
+			 * OWNER_DIED bit is set to figure out whether
+			 * this is a robust futex or not.
+			 */
+			if (get_futex_value_locked(&curval, uaddr))
 				goto uaddr_faulted;
-			if (unlikely(curval != uval))
+
+			/*
+			 * We simply start over in case of a robust
+			 * futex. The code above will take the futex
+			 * and return happy.
+			 */
+			if (curval & FUTEX_OWNER_DIED) {
+				ownerdied = 1;
 				goto retry_locked;
-			ret = 0;
+			}
+		default:
+			goto out_unlock_release_sem;
 		}
-		goto out_unlock_release_sem;
 	}
 
 	/*
@@ -1845,31 +1877,42 @@ static int futex_lock_pi(u32 __user *uad
 		down_read(fshared);
 	spin_lock(q.lock_ptr);
 
-	/*
-	 * Got the lock. We might not be the anticipated owner if we
-	 * did a lock-steal - fix up the PI-state in that case.
-	 */
-	if (!ret && q.pi_state->owner != curr)
-		/* mmap_sem is unlocked at return of this function */
-		ret = fixup_pi_state_owner(uaddr, fshared, &q, hb, curr);
-	else {
+	if (!ret) {
+		/*
+		 * Got the lock. We might not be the anticipated owner
+		 * if we did a lock-steal - fix up the PI-state in
+		 * that case:
+		 */
+		if (q.pi_state->owner != curr)
+			ret = fixup_pi_state_owner(uaddr, &q, curr);
+	} else {
 		/*
 		 * Catch the rare case, where the lock was released
-		 * when we were on the way back before we locked
-		 * the hash bucket.
+		 * when we were on the way back before we locked the
+		 * hash bucket.
 		 */
-		if (ret && q.pi_state->owner == curr) {
-			if (rt_mutex_trylock(&q.pi_state->pi_mutex))
-				ret = 0;
+		if (q.pi_state->owner == curr &&
+		    rt_mutex_trylock(&q.pi_state->pi_mutex)) {
+			ret = 0;
+		} else {
+			/*
+			 * Paranoia check. If we did not take the lock
+			 * in the trylock above, then we should not be
+			 * the owner of the rtmutex, neither the real
+			 * nor the pending one:
+			 */
+			if (rt_mutex_owner(&q.pi_state->pi_mutex) == curr)
+				printk(KERN_ERR "futex_lock_pi: ret = %d "
+				       "pi-mutex: %p pi-state %p\n", ret,
+				       q.pi_state->pi_mutex.owner,
+				       q.pi_state->owner);
 		}
-		/* Unqueue and drop the lock */
-		unqueue_me_pi(&q);
-		if (fshared)
-			up_read(fshared);
 	}
 
-	if (!detect && ret == -EDEADLK && 0)
-		force_sig(SIGKILL, current);
+	/* Unqueue and drop the lock */
+	unqueue_me_pi(&q);
+	if (fshared)
+		up_read(fshared);
 
 	return ret != -EINTR ? ret : -ERESTARTNOINTR;
 
@@ -1887,16 +1930,19 @@ static int futex_lock_pi(u32 __user *uad
 	 * non-atomically.  Therefore, if get_user below is not
 	 * enough, we need to handle the fault ourselves, while
 	 * still holding the mmap_sem.
+	 *
+	 * ... and hb->lock. :-) --ANK
 	 */
+	queue_unlock(&q, hb);
+
 	if (attempt++) {
 		ret = futex_handle_fault((unsigned long)uaddr, fshared,
 					 attempt);
 		if (ret)
-			goto out_unlock_release_sem;
-		goto retry_locked;
+			goto out_release_sem;
+		goto retry_unlocked;
 	}
 
-	queue_unlock(&q, hb);
 	if (fshared)
 		up_read(fshared);
 
@@ -1940,9 +1986,9 @@ retry:
 		goto out;
 
 	hb = hash_futex(&key);
+retry_unlocked:
 	spin_lock(&hb->lock);
 
-retry_locked:
 	/*
 	 * To avoid races, try to do the TID -> 0 atomic transition
 	 * again. If it succeeds then we can return without waking
@@ -2005,16 +2051,19 @@ pi_faulted:
 	 * non-atomically.  Therefore, if get_user below is not
 	 * enough, we need to handle the fault ourselves, while
 	 * still holding the mmap_sem.
+	 *
+	 * ... and hb->lock. --ANK
 	 */
+	spin_unlock(&hb->lock);
+
 	if (attempt++) {
 		ret = futex_handle_fault((unsigned long)uaddr, fshared,
 					 attempt);
 		if (ret)
-			goto out_unlock;
-		goto retry_locked;
+			goto out;
+		goto retry_unlocked;
 	}
 
-	spin_unlock(&hb->lock);
 	if (fshared)
 		up_read(fshared);
 
_

Patches currently in -mm which might be from kuznet@ms2.inr.ac.ru are

origin.patch
futex-tidy-up-the-code.patch
