From: akpm@linux-foundation.org
Subject: + make-futex_wait-use-an-hrtimer-for-timeout.patch added to -mm tree
Date: Wed, 21 Mar 2007 15:46:52 -0700
Message-ID: <200703212246.l2LMkqHj005952@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57320 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbXCUWrR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Mar 2007 18:47:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pierre.peiffer@bull.net, drepper@redhat.com, mingo@elte.hu, sebastien.dugue@bull.net


The patch titled
     Make futex_wait() use an hrtimer for timeout
has been added to the -mm tree.  Its filename is
     make-futex_wait-use-an-hrtimer-for-timeout.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Make futex_wait() use an hrtimer for timeout
From: Pierre Peiffer <pierre.peiffer@bull.net>

This patch modifies futex_wait() to use an hrtimer + schedule() in place of
schedule_timeout().

schedule_timeout() is tick based, therefore the timeout granularity is the
tick (1 ms, 4 ms or 10 ms depending on HZ).  By using a high resolution timer
for timeout wakeup, we can attain a much finer timeout granularity (in the
microsecond range).  This parallels what is already done for futex_lock_pi().

The timeout passed to the syscall is no longer converted to jiffies and is
therefore passed to do_futex() and futex_wait() as an absolute ktime_t
therefore keeping nanosecond resolution.

Also this removes the need to pass the nanoseconds timeout part to
futex_lock_pi() in val2.

In futex_wait(), if there is no timeout then a regular schedule() is
performed.  Otherwise, an hrtimer is fired before schedule() is called.

Signed-off-by: Sebastien Dugue <sebastien.dugue@bull.net>
Signed-off-by: Pierre Peiffer <pierre.peiffer@bull.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/futex.h |    3 -
 kernel/futex.c        |   85 +++++++++++++++++++---------------------
 kernel/futex_compat.c |   17 +++-----
 3 files changed, 51 insertions(+), 54 deletions(-)

diff -puN include/linux/futex.h~make-futex_wait-use-an-hrtimer-for-timeout include/linux/futex.h
--- a/include/linux/futex.h~make-futex_wait-use-an-hrtimer-for-timeout
+++ a/include/linux/futex.h
@@ -1,6 +1,7 @@
 #ifndef _LINUX_FUTEX_H
 #define _LINUX_FUTEX_H
 
+#include <linux/ktime.h>
 #include <linux/sched.h>
 
 /* Second argument to futex syscall */
@@ -94,7 +95,7 @@ struct robust_list_head {
 #define ROBUST_LIST_LIMIT	2048
 
 #ifdef __KERNEL__
-long do_futex(u32 __user *uaddr, int op, u32 val, unsigned long timeout,
+long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 	      u32 __user *uaddr2, u32 val2, u32 val3);
 
 extern int
diff -puN kernel/futex.c~make-futex_wait-use-an-hrtimer-for-timeout kernel/futex.c
--- a/kernel/futex.c~make-futex_wait-use-an-hrtimer-for-timeout
+++ a/kernel/futex.c
@@ -1001,16 +1001,16 @@ static void unqueue_me_pi(struct futex_q
 }
 
 static long futex_wait_restart(struct restart_block *restart);
-static int futex_wait_abstime(u32 __user *uaddr, u32 val,
-			int timed, unsigned long abs_time)
+static int futex_wait(u32 __user *uaddr, u32 val, ktime_t *abs_time)
 {
 	struct task_struct *curr = current;
 	DECLARE_WAITQUEUE(wait, curr);
 	struct futex_hash_bucket *hb;
 	struct futex_q q;
-	unsigned long time_left = 0;
 	u32 uval;
 	int ret;
+	struct hrtimer_sleeper t;
+	int rem = 0;
 
 	q.pi_state = NULL;
  retry:
@@ -1088,20 +1088,29 @@ static int futex_wait_abstime(u32 __user
 	 * !plist_node_empty() is safe here without any lock.
 	 * q.lock_ptr != 0 is not safe, because of ordering against wakeup.
 	 */
-	time_left = 0;
 	if (likely(!plist_node_empty(&q.list))) {
-		unsigned long rel_time;
+		if (!abs_time)
+			schedule();
+		else {
+			hrtimer_init(&t.timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
+			hrtimer_init_sleeper(&t, current);
+			t.timer.expires = *abs_time;
+
+			hrtimer_start(&t.timer, t.timer.expires, HRTIMER_MODE_ABS);
+
+			/*
+			 * the timer could have already expired, in which
+			 * case current would be flagged for rescheduling.
+			 * Don't bother calling schedule.
+			 */
+			if (likely(t.task))
+				schedule();
 
-		if (timed) {
-			unsigned long now = jiffies;
-			if (time_after(now, abs_time))
-				rel_time = 0;
-			else
-				rel_time = abs_time - now;
-		} else
-			rel_time = MAX_SCHEDULE_TIMEOUT;
+			hrtimer_cancel(&t.timer);
 
-		time_left = schedule_timeout(rel_time);
+			/* Flag if a timeout occured */
+			rem = (t.task == NULL);
+		}
 	}
 	__set_current_state(TASK_RUNNING);
 
@@ -1113,14 +1122,14 @@ static int futex_wait_abstime(u32 __user
 	/* If we were woken (and unqueued), we succeeded, whatever. */
 	if (!unqueue_me(&q))
 		return 0;
-	if (time_left == 0)
+	if (rem)
 		return -ETIMEDOUT;
 
 	/*
 	 * We expect signal_pending(current), but another thread may
 	 * have handled it for us already.
 	 */
-	if (time_left == MAX_SCHEDULE_TIMEOUT)
+	if (!abs_time)
 		return -ERESTARTSYS;
 	else {
 		struct restart_block *restart;
@@ -1128,8 +1137,7 @@ static int futex_wait_abstime(u32 __user
 		restart->fn = futex_wait_restart;
 		restart->arg0 = (unsigned long)uaddr;
 		restart->arg1 = (unsigned long)val;
-		restart->arg2 = (unsigned long)timed;
-		restart->arg3 = abs_time;
+		restart->arg2 = (unsigned long)abs_time;
 		return -ERESTART_RESTARTBLOCK;
 	}
 
@@ -1141,21 +1149,15 @@ static int futex_wait_abstime(u32 __user
 	return ret;
 }
 
-static int futex_wait(u32 __user *uaddr, u32 val, unsigned long rel_time)
-{
-	int timed = (rel_time != MAX_SCHEDULE_TIMEOUT);
-	return futex_wait_abstime(uaddr, val, timed, jiffies+rel_time);
-}
 
 static long futex_wait_restart(struct restart_block *restart)
 {
 	u32 __user *uaddr = (u32 __user *)restart->arg0;
 	u32 val = (u32)restart->arg1;
-	int timed = (int)restart->arg2;
-	unsigned long abs_time = restart->arg3;
+	ktime_t *abs_time = (ktime_t *)restart->arg2;
 
 	restart->fn = do_no_restart_syscall;
-	return (long)futex_wait_abstime(uaddr, val, timed, abs_time);
+	return (long)futex_wait(uaddr, val, abs_time);
 }
 
 
@@ -1165,8 +1167,8 @@ static long futex_wait_restart(struct re
  * if there are waiters then it will block, it does PI, etc. (Due to
  * races the kernel might see a 0 value of the futex too.)
  */
-static int futex_lock_pi(u32 __user *uaddr, int detect, unsigned long sec,
-			 long nsec, int trylock)
+static int futex_lock_pi(u32 __user *uaddr, int detect, ktime_t *time,
+			 int trylock)
 {
 	struct hrtimer_sleeper timeout, *to = NULL;
 	struct task_struct *curr = current;
@@ -1178,11 +1180,11 @@ static int futex_lock_pi(u32 __user *uad
 	if (refill_pi_state_cache())
 		return -ENOMEM;
 
-	if (sec != MAX_SCHEDULE_TIMEOUT) {
+	if (time) {
 		to = &timeout;
 		hrtimer_init(&to->timer, CLOCK_REALTIME, HRTIMER_MODE_ABS);
 		hrtimer_init_sleeper(to, current);
-		to->timer.expires = ktime_set(sec, nsec);
+		to->timer.expires = *time;
 	}
 
 	q.pi_state = NULL;
@@ -1818,7 +1820,7 @@ void exit_robust_list(struct task_struct
 	}
 }
 
-long do_futex(u32 __user *uaddr, int op, u32 val, unsigned long timeout,
+long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 		u32 __user *uaddr2, u32 val2, u32 val3)
 {
 	int ret;
@@ -1844,13 +1846,13 @@ long do_futex(u32 __user *uaddr, int op,
 		ret = futex_wake_op(uaddr, uaddr2, val, val2, val3);
 		break;
 	case FUTEX_LOCK_PI:
-		ret = futex_lock_pi(uaddr, val, timeout, val2, 0);
+		ret = futex_lock_pi(uaddr, val, timeout, 0);
 		break;
 	case FUTEX_UNLOCK_PI:
 		ret = futex_unlock_pi(uaddr);
 		break;
 	case FUTEX_TRYLOCK_PI:
-		ret = futex_lock_pi(uaddr, 0, timeout, val2, 1);
+		ret = futex_lock_pi(uaddr, 0, timeout, 1);
 		break;
 	default:
 		ret = -ENOSYS;
@@ -1863,21 +1865,18 @@ asmlinkage long sys_futex(u32 __user *ua
 			  struct timespec __user *utime, u32 __user *uaddr2,
 			  u32 val3)
 {
-	struct timespec t;
-	unsigned long timeout = MAX_SCHEDULE_TIMEOUT;
+	struct timespec ts;
+	ktime_t t, *tp = NULL;
 	u32 val2 = 0;
 
 	if (utime && (op == FUTEX_WAIT || op == FUTEX_LOCK_PI)) {
-		if (copy_from_user(&t, utime, sizeof(t)) != 0)
+		if (copy_from_user(&ts, utime, sizeof(ts)) != 0)
 			return -EFAULT;
-		if (!timespec_valid(&t))
+		if (!timespec_valid(&ts))
 			return -EINVAL;
 		if (op == FUTEX_WAIT)
-			timeout = timespec_to_jiffies(&t) + 1;
-		else {
-			timeout = t.tv_sec;
-			val2 = t.tv_nsec;
-		}
+			t = ktime_add(ktime_get(), timespec_to_ktime(ts));
+		tp = &t;
 	}
 	/*
 	 * requeue parameter in 'utime' if op == FUTEX_REQUEUE.
@@ -1885,7 +1884,7 @@ asmlinkage long sys_futex(u32 __user *ua
 	if (op == FUTEX_REQUEUE || op == FUTEX_CMP_REQUEUE)
 		val2 = (u32) (unsigned long) utime;
 
-	return do_futex(uaddr, op, val, timeout, uaddr2, val2, val3);
+	return do_futex(uaddr, op, val, tp, uaddr2, val2, val3);
 }
 
 static int futexfs_get_sb(struct file_system_type *fs_type,
diff -puN kernel/futex_compat.c~make-futex_wait-use-an-hrtimer-for-timeout kernel/futex_compat.c
--- a/kernel/futex_compat.c~make-futex_wait-use-an-hrtimer-for-timeout
+++ a/kernel/futex_compat.c
@@ -141,24 +141,21 @@ asmlinkage long compat_sys_futex(u32 __u
 		struct compat_timespec __user *utime, u32 __user *uaddr2,
 		u32 val3)
 {
-	struct timespec t;
-	unsigned long timeout = MAX_SCHEDULE_TIMEOUT;
+	struct timespec ts;
+	ktime_t t, *tp = NULL;
 	int val2 = 0;
 
 	if (utime && (op == FUTEX_WAIT || op == FUTEX_LOCK_PI)) {
-		if (get_compat_timespec(&t, utime))
+		if (get_compat_timespec(&ts, utime))
 			return -EFAULT;
-		if (!timespec_valid(&t))
+		if (!timespec_valid(&ts))
 			return -EINVAL;
 		if (op == FUTEX_WAIT)
-			timeout = timespec_to_jiffies(&t) + 1;
-		else {
-			timeout = t.tv_sec;
-			val2 = t.tv_nsec;
-		}
+			t = ktime_add(ktime_get(), timespec_to_ktime(ts));
+		tp = &t;
 	}
 	if (op == FUTEX_REQUEUE || op == FUTEX_CMP_REQUEUE)
 		val2 = (int) (unsigned long) utime;
 
-	return do_futex(uaddr, op, val, timeout, uaddr2, val2, val3);
+	return do_futex(uaddr, op, val, tp, uaddr2, val2, val3);
 }
_

Patches currently in -mm which might be from pierre.peiffer@bull.net are

futex-priority-based-wakeup.patch
make-futex_wait-use-an-hrtimer-for-timeout.patch
futex_requeue_pi-optimization.patch
sys_futex64-allows-64bit-futexes.patch
