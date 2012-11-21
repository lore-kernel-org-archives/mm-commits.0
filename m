From: akpm@linux-foundation.org
Subject: + futex-avoid-wake_futex-for-a-pi-futex_q.patch added to -mm tree
Date: Wed, 21 Nov 2012 14:35:39 -0800
Message-ID: <20121121223540.41D211001E0@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:33652 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965248Ab2KVT41 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Nov 2012 14:56:27 -0500
Received: by mail-qa0-f74.google.com with SMTP id g40so140411qab.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Nov 2012 11:56:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dvhart@linux.intel.com, davej@redat.com, jkacur@redhat.com, mingo@elte.hu, peterz@infradead.org, stable@vger.kernel.org, tglx@linutronix.de


The patch titled
     Subject: futex: avoid wake_futex() for a PI futex_q
has been added to the -mm tree.  Its filename is
     futex-avoid-wake_futex-for-a-pi-futex_q.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Darren Hart <dvhart@linux.intel.com>
Subject: futex: avoid wake_futex() for a PI futex_q

Dave Jones reported a bug with futex_lock_pi() that his trinity test
exposed.  Sometime between queue_me() and taking the q.lock_ptr, the
lock_ptr became NULL, resulting in a crash.

While futex_wake() is careful to not call wake_futex() on futex_q's with a
pi_state or an rt_waiter (which are either waiting for a futex_unlock_pi()
or a PI futex_requeue()), futex_wake_op() and futex_requeue() do not
perform the same test.

Update futex_wake_op() and futex_requeue() to test for q.pi_state and
q.rt_waiter and abort with -EINVAL if detected.  To ensure any future
breakage is caught, add a WARN() to wake_futex() if the same condition is
true.

This fix has seen 3 hours of testing with "trinity -c futex" on an x86_64
VM with 4 CPUS.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Reported-by: Dave Jones <davej@redat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: John Kacur <jkacur@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/futex.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff -puN kernel/futex.c~futex-avoid-wake_futex-for-a-pi-futex_q kernel/futex.c
--- a/kernel/futex.c~futex-avoid-wake_futex-for-a-pi-futex_q
+++ a/kernel/futex.c
@@ -843,6 +843,11 @@ static void wake_futex(struct futex_q *q
 {
 	struct task_struct *p = q->task;
 
+	if (q->pi_state || q->rt_waiter) {
+		WARN(1, "%s: refusing to wake PI futex\n", __FUNCTION__);
+		return;
+	}
+
 	/*
 	 * We set q->lock_ptr = NULL _before_ we wake up the task. If
 	 * a non-futex wake up happens on another CPU then the task
@@ -1078,6 +1083,10 @@ retry_private:
 
 	plist_for_each_entry_safe(this, next, head, list) {
 		if (match_futex (&this->key, &key1)) {
+			if (this->pi_state || this->rt_waiter) {
+				ret = -EINVAL;
+				goto out_unlock;
+			}
 			wake_futex(this);
 			if (++ret >= nr_wake)
 				break;
@@ -1090,6 +1099,10 @@ retry_private:
 		op_ret = 0;
 		plist_for_each_entry_safe(this, next, head, list) {
 			if (match_futex (&this->key, &key2)) {
+				if (this->pi_state || this->rt_waiter) {
+					ret = -EINVAL;
+					goto out_unlock;
+				}
 				wake_futex(this);
 				if (++op_ret >= nr_wake2)
 					break;
@@ -1098,6 +1111,7 @@ retry_private:
 		ret += op_ret;
 	}
 
+out_unlock:
 	double_unlock_hb(hb1, hb2);
 out_put_keys:
 	put_futex_key(&key2);
@@ -1387,9 +1401,13 @@ retry_private:
 		/*
 		 * FUTEX_WAIT_REQEUE_PI and FUTEX_CMP_REQUEUE_PI should always
 		 * be paired with each other and no other futex ops.
+		 *
+		 * We should never be requeueing a futex_q with a pi_state,
+		 * which is awaiting a futex_unlock_pi().
 		 */
 		if ((requeue_pi && !this->rt_waiter) ||
-		    (!requeue_pi && this->rt_waiter)) {
+		    (!requeue_pi && this->rt_waiter) ||
+		    this->pi_state) {
 			ret = -EINVAL;
 			break;
 		}
_

Patches currently in -mm which might be from dvhart@linux.intel.com are

linux-next.patch
futex-avoid-wake_futex-for-a-pi-futex_q.patch
futex-avoid-wake_futex-for-a-pi-futex_q-fix.patch

