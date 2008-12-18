From: akpm@linux-foundation.org
Subject: + futex-update-futex_q-to-clarify-single-waiter-semantics.patch added to -mm tree
Date: Wed, 17 Dec 2008 22:12:27 -0800
Message-ID: <200812180612.mBI6CR53031131@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57961 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752163AbYLRGNo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Dec 2008 01:13:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dvhltc@us.ibm.com, a.p.zijlstra@chello.nl, mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de


The patch titled
     futex: update futex_q to clarify single waiter semantics
has been added to the -mm tree.  Its filename is
     futex-update-futex_q-to-clarify-single-waiter-semantics.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: futex: update futex_q to clarify single waiter semantics
From: Darren Hart <dvhltc@us.ibm.com>

I've tripped over this a couple times.  The futex_q uses a waiters list to
represent a single blocked task and then calls wake_up_all().  This can
lead to confusion in trying to understand the intent of the code, which is
to have a single futex_q for every task waiting on a futex.

This patch corrects the problem, using a single pointer to the waiting
task, and an appropriate call to wake_up, rather than wake_up_all.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/futex.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN kernel/futex.c~futex-update-futex_q-to-clarify-single-waiter-semantics kernel/futex.c
--- a/kernel/futex.c~futex-update-futex_q-to-clarify-single-waiter-semantics
+++ a/kernel/futex.c
@@ -92,11 +92,12 @@ struct futex_pi_state {
  * A futex_q has a woken state, just like tasks have TASK_RUNNING.
  * It is considered woken when plist_node_empty(&q->list) || q->lock_ptr == 0.
  * The order of wakup is always to make the first condition true, then
- * wake up q->waiters, then make the second condition true.
+ * wake up q->waiter, then make the second condition true.
  */
 struct futex_q {
 	struct plist_node list;
-	wait_queue_head_t waiters;
+	/* There can only be a single waiter */
+	wait_queue_head_t waiter;
 
 	/* Which hash list lock to use: */
 	spinlock_t *lock_ptr;
@@ -580,7 +581,7 @@ static void wake_futex(struct futex_q *q
 	 * The lock in wake_up_all() is a crucial memory barrier after the
 	 * plist_del() and also before assigning to q->lock_ptr.
 	 */
-	wake_up_all(&q->waiters);
+	wake_up(&q->waiter);
 	/*
 	 * The waiting task can free the futex_q as soon as this is written,
 	 * without taking any locks.  This must come last.
@@ -937,7 +938,7 @@ static inline struct futex_hash_bucket *
 {
 	struct futex_hash_bucket *hb;
 
-	init_waitqueue_head(&q->waiters);
+	init_waitqueue_head(&q->waiter);
 
 	get_futex_key_refs(&q->key);
 	hb = hash_futex(&q->key);
@@ -1228,7 +1229,7 @@ static int futex_wait(u32 __user *uaddr,
 
 	/* add_wait_queue is the barrier after __set_current_state. */
 	__set_current_state(TASK_INTERRUPTIBLE);
-	add_wait_queue(&q.waiters, &wait);
+	add_wait_queue(&q.waiter, &wait);
 	/*
 	 * !plist_node_empty() is safe here without any lock.
 	 * q.lock_ptr != 0 is not safe, because of ordering against wakeup.
_

Patches currently in -mm which might be from dvhltc@us.ibm.com are

futex-update-futex_q-to-clarify-single-waiter-semantics.patch

