From: akpm@linux-foundation.org
Subject: + futex-fix-kernel-doc-notation-and-spello.patch added to -mm tree
Date: Wed, 06 Mar 2013 14:07:02 -0800
Message-ID: <20130306220702.6F38C31C24E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:44584 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655Ab3CFWHE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Mar 2013 17:07:04 -0500
Received: by mail-ye0-f201.google.com with SMTP id m12so923598yen.0
        for <mm-commits@vger.kernel.org>; Wed, 06 Mar 2013 14:07:02 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rdunlap@infradead.org, tglx@linutronix.de


The patch titled
     Subject: futex: fix kernel-doc notation and spello
has been added to the -mm tree.  Its filename is
     futex-fix-kernel-doc-notation-and-spello.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: futex: fix kernel-doc notation and spello

Fix kernel-doc warning in futex.c and convert 'Returns' to the new Return:
kenrel-doc notation format.

Warning(kernel/futex.c:2286): Excess function parameter 'clockrt' description in 'futex_wait_requeue_pi'

Fix one spello.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/futex.c |   46 +++++++++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff -puN kernel/futex.c~futex-fix-kernel-doc-notation-and-spello kernel/futex.c
--- a/kernel/futex.c~futex-fix-kernel-doc-notation-and-spello
+++ a/kernel/futex.c
@@ -223,7 +223,8 @@ static void drop_futex_key_refs(union fu
  * @rw:		mapping needs to be read/write (values: VERIFY_READ,
  *              VERIFY_WRITE)
  *
- * Returns a negative error code or 0
+ * Return: a negative error code or 0
+ *
  * The key words are stored in *key on success.
  *
  * For shared mappings, it's (page->index, file_inode(vma->vm_file),
@@ -705,9 +706,9 @@ lookup_pi_state(u32 uval, struct futex_h
  *			be "current" except in the case of requeue pi.
  * @set_waiters:	force setting the FUTEX_WAITERS bit (1) or not (0)
  *
- * Returns:
- *  0 - ready to wait
- *  1 - acquired the lock
+ * Return:
+ *  0 - ready to wait;
+ *  1 - acquired the lock;
  * <0 - error
  *
  * The hb->lock and futex_key refs shall be held by the caller.
@@ -1191,9 +1192,9 @@ void requeue_pi_wake_futex(struct futex_
  * then direct futex_lock_pi_atomic() to force setting the FUTEX_WAITERS bit.
  * hb1 and hb2 must be held by the caller.
  *
- * Returns:
- *  0 - failed to acquire the lock atomicly
- *  1 - acquired the lock
+ * Return:
+ *  0 - failed to acquire the lock atomically;
+ *  1 - acquired the lock;
  * <0 - error
  */
 static int futex_proxy_trylock_atomic(u32 __user *pifutex,
@@ -1254,8 +1255,8 @@ static int futex_proxy_trylock_atomic(u3
  * Requeue waiters on uaddr1 to uaddr2. In the requeue_pi case, try to acquire
  * uaddr2 atomically on behalf of the top waiter.
  *
- * Returns:
- * >=0 - on success, the number of tasks requeued or woken
+ * Return:
+ * >=0 - on success, the number of tasks requeued or woken;
  *  <0 - on error
  */
 static int futex_requeue(u32 __user *uaddr1, unsigned int flags,
@@ -1536,8 +1537,8 @@ static inline void queue_me(struct futex
  * The q->lock_ptr must not be held by the caller. A call to unqueue_me() must
  * be paired with exactly one earlier call to queue_me().
  *
- * Returns:
- *   1 - if the futex_q was still queued (and we removed unqueued it)
+ * Return:
+ *   1 - if the futex_q was still queued (and we removed unqueued it);
  *   0 - if the futex_q was already removed by the waking thread
  */
 static int unqueue_me(struct futex_q *q)
@@ -1707,9 +1708,9 @@ static long futex_wait_restart(struct re
  * the pi_state owner as well as handle race conditions that may allow us to
  * acquire the lock. Must be called with the hb lock held.
  *
- * Returns:
- *  1 - success, lock taken
- *  0 - success, lock not taken
+ * Return:
+ *  1 - success, lock taken;
+ *  0 - success, lock not taken;
  * <0 - on error (-EFAULT)
  */
 static int fixup_owner(u32 __user *uaddr, struct futex_q *q, int locked)
@@ -1824,8 +1825,8 @@ static void futex_wait_queue_me(struct f
  * Return with the hb lock held and a q.key reference on success, and unlocked
  * with no q.key reference on failure.
  *
- * Returns:
- *  0 - uaddr contains val and hb has been locked
+ * Return:
+ *  0 - uaddr contains val and hb has been locked;
  * <1 - -EFAULT or -EWOULDBLOCK (uaddr does not contain val) and hb is unlocked
  */
 static int futex_wait_setup(u32 __user *uaddr, u32 val, unsigned int flags,
@@ -2203,9 +2204,9 @@ pi_faulted:
  * the wakeup and return the appropriate error code to the caller.  Must be
  * called with the hb lock held.
  *
- * Returns
- *  0 - no early wakeup detected
- * <0 - -ETIMEDOUT or -ERESTARTNOINTR
+ * Return:
+ *  0 = no early wakeup detected;
+ * <0 = -ETIMEDOUT or -ERESTARTNOINTR
  */
 static inline
 int handle_early_requeue_pi_wakeup(struct futex_hash_bucket *hb,
@@ -2247,7 +2248,6 @@ int handle_early_requeue_pi_wakeup(struc
  * @val:	the expected value of uaddr
  * @abs_time:	absolute timeout
  * @bitset:	32 bit wakeup bitset set by userspace, defaults to all
- * @clockrt:	whether to use CLOCK_REALTIME (1) or CLOCK_MONOTONIC (0)
  * @uaddr2:	the pi futex we will take prior to returning to user-space
  *
  * The caller will wait on uaddr and will be requeued by futex_requeue() to
@@ -2258,7 +2258,7 @@ int handle_early_requeue_pi_wakeup(struc
  * there was a need to.
  *
  * We call schedule in futex_wait_queue_me() when we enqueue and return there
- * via the following:
+ * via the following--
  * 1) wakeup on uaddr2 after an atomic lock acquisition by futex_requeue()
  * 2) wakeup on uaddr2 after a requeue
  * 3) signal
@@ -2276,8 +2276,8 @@ int handle_early_requeue_pi_wakeup(struc
  *
  * If 4 or 7, we cleanup and return with -ETIMEDOUT.
  *
- * Returns:
- *  0 - On success
+ * Return:
+ *  0 - On success;
  * <0 - On error
  */
 static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
_

Patches currently in -mm which might be from rdunlap@infradead.org are

linux-next.patch
futex-fix-kernel-doc-notation-and-spello.patch
debugging-keep-track-of-page-owners-fix-2.patch

