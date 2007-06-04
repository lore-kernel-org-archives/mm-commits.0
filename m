From: akpm@linux-foundation.org
Subject: + pi-futex-fixes.patch added to -mm tree
Date: Mon, 04 Jun 2007 15:05:26 -0700
Message-ID: <200706042205.l54M5QvN020247@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37088 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753998AbXFDWHf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jun 2007 18:07:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kuznet@ms2.inr.ac.ru, mingo@elte.hu, stable@kernel.org, tglx@linutronix.de


The patch titled
     pi-futex fixes
has been added to the -mm tree.  Its filename is
     pi-futex-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pi-futex fixes
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

(akpm: this doesn't vaguely apply to 2.6.21, but 2.6.21 need fixing!)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/futex.c |   73 ++++++++++++++++++++++++++++++++++++++---------
 1 files changed, 60 insertions(+), 13 deletions(-)

diff -puN kernel/futex.c~pi-futex-fixes kernel/futex.c
--- a/kernel/futex.c~pi-futex-fixes
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
@@ -540,6 +536,19 @@ lookup_pi_state(u32 uval, struct futex_h
 	if (!p)
 		return -ESRCH;
 
+	/*
+	 * Task state transitions are protected only by tasklist_lock
+	 * and by nothing else. Better solution would be
+	 * to use ->pi_lock. But this should be done in do_exit() as well.
+	 * So, I use tasklist_lock for now.
+	 */
+	read_lock(&tasklist_lock);
+	if (p->exit_state) {
+		read_unlock(&tasklist_lock);
+		put_task_struct(p);
+		return -ESRCH;
+	}
+
 	pi_state = alloc_pi_state();
 
 	/*
@@ -557,6 +566,8 @@ lookup_pi_state(u32 uval, struct futex_h
 	pi_state->owner = p;
 	spin_unlock_irq(&p->pi_lock);
 
+	read_unlock(&tasklist_lock);
+
 	put_task_struct(p);
 
 	*ps = pi_state;
@@ -1174,7 +1185,7 @@ static int futex_requeue(u32 __user *uad
 #ifdef CONFIG_DEBUG_PI_LIST
 				this->list.plist.lock = &hb2->lock;
 #endif
- 			}
+			}
 			this->key = key2;
 			get_futex_key_refs(&key2);
 			drop_count++;
@@ -1371,7 +1382,7 @@ static int fixup_pi_state_owner(u32 __us
 		curval = futex_atomic_cmpxchg_inatomic(uaddr,
 						       uval, newval);
 		if (curval == -EFAULT)
- 			ret = -EFAULT;
+			ret = -EFAULT;
 		if (curval == uval)
 			break;
 		uval = curval;
@@ -1709,6 +1720,7 @@ static int futex_lock_pi(u32 __user *uad
 	if (unlikely(ret != 0))
 		goto out_release_sem;
 
+ retry_unlocked:
 	hb = queue_lock(&q, -1, NULL);
 
  retry_locked:
@@ -1813,6 +1825,19 @@ static int futex_lock_pi(u32 __user *uad
 			if (unlikely(curval != uval))
 				goto retry_locked;
 			ret = 0;
+		} else if (ret == -ESRCH) {
+			/*
+			 * Process could exit right now, so that robust
+			 * list was processed after we got uval. Retry:
+			 */
+			pagefault_disable();
+			curval = futex_atomic_cmpxchg_inatomic(uaddr,
+							       uval, uval);
+			pagefault_enable();
+			if (unlikely(curval == -EFAULT))
+				goto uaddr_faulted;
+			if (unlikely(curval != uval))
+				goto retry_locked;
 		}
 		goto out_unlock_release_sem;
 	}
@@ -1861,6 +1886,22 @@ static int futex_lock_pi(u32 __user *uad
 		if (ret && q.pi_state->owner == curr) {
 			if (rt_mutex_trylock(&q.pi_state->pi_mutex))
 				ret = 0;
+			/*
+			 * Holy crap... Now futex lock returns -EDEADLK
+			 * sometimes, because ownership was passed to us while
+			 * unlock of previous owner. Who wrote this?
+			 * Please, fix this correctly. For now:
+			 */
+			if (ret == -EDEADLK) {
+				pagefault_disable();
+				uval = futex_atomic_cmpxchg_inatomic(uaddr,
+								     0, 0);
+				pagefault_enable();
+				if (uval != -EFAULT &&
+				    (uval & FUTEX_TID_MASK) == current->pid) {
+					ret = 0;
+				}
+			}
 		}
 		/* Unqueue and drop the lock */
 		unqueue_me_pi(&q);
@@ -1887,16 +1928,19 @@ static int futex_lock_pi(u32 __user *uad
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
 
@@ -1940,9 +1984,9 @@ retry:
 		goto out;
 
 	hb = hash_futex(&key);
+retry_unlocked:
 	spin_lock(&hb->lock);
 
-retry_locked:
 	/*
 	 * To avoid races, try to do the TID -> 0 atomic transition
 	 * again. If it succeeds then we can return without waking
@@ -2005,16 +2049,19 @@ pi_faulted:
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

pi-futex-fixes.patch
