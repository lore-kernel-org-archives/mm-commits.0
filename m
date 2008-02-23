From: akpm@linux-foundation.org
Subject: + kthread-add-a-missing-memory-barrier-to-kthread_stop.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:33:00 -0800
Message-ID: <200802230733.m1N7XnMu018253@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:57985 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763031AbYBWIFN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 03:05:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmitry.adamushko@gmail.com, a.p.zijlstra@chello.nl, apw@shadowen.org, mingo@elte.hu, nickpiggin@yahoo.com.au, oleg@tv-sign.ru, paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au


The patch titled
     kthread: add a missing memory barrier to kthread_stop()
has been added to the -mm tree.  Its filename is
     kthread-add-a-missing-memory-barrier-to-kthread_stop.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kthread: add a missing memory barrier to kthread_stop()
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>

We must ensure that kthread_stop_info.k has been updated before kthread's
wakeup.  This is required to properly support the use of kthread_should_stop()
in the main loop of kthread.

wake_up_process() doesn't imply a full memory barrier,
so we add an explicit one.

There is a requirement on how a main loop of kthread has to be orginized.

Namely, the sequence of events that lead to kthread being blocked (schedule())
has to be ordered as follows:

- set_current_state(TASK_INTERRUPTIBLE);
- if (kthread_should_stop()) break;
- schedule() or similar.

set_current_state() implies a full memory barrier, so this is
a matching barrier on the side of kthread_should_stop().

Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>index 45f8b83..86b69a0 100644
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff -puN kernel/kthread.c~kthread-add-a-missing-memory-barrier-to-kthread_stop kernel/kthread.c
--- a/kernel/kthread.c~kthread-add-a-missing-memory-barrier-to-kthread_stop
+++ a/kernel/kthread.c
@@ -53,6 +53,19 @@ static struct kthread_stop_info kthread_
  * When someone calls kthread_stop() on your kthread, it will be woken
  * and this will return true.  You should then return, and your return
  * value will be passed through to kthread_stop().
+ *
+ * In order to safely use kthread_stop() for kthread, there is a requirement
+ * on how its main loop has to be orginized. Namely, the sequence of
+ * events that lead to kthread being blocked (schedule()) has to be
+ * ordered as follows:
+ *
+ * - set_current_state(TASK_INTERRUPTIBLE);
+ * - if (kthread_should_stop()) break;
+ * - schedule() or similar.
+ *
+ * set_current_state() implies a full memory barrier. kthread_stop()
+ * has a matching barrier right after an update of kthread_stop_info.k
+ * and before kthread's wakeup.
  */
 int kthread_should_stop(void)
 {
@@ -211,6 +224,15 @@ int kthread_stop(struct task_struct *k)
 
 	/* Now set kthread_should_stop() to true, and wake it up. */
 	kthread_stop_info.k = k;
+
+	/*
+	 * We must ensure that kthread_stop_info.k has been updated before
+	 * the following wakeup. This is required to properly support the use
+	 * of kthread_should_stop() in the main loop of kthread
+	 * (see description of kthread_should_stop() for more details).
+	 */
+	smp_mb();
+
 	wake_up_process(k);
 	put_task_struct(k);
 
_

Patches currently in -mm which might be from dmitry.adamushko@gmail.com are

kthread-synchronization-issues.patch
kthread-add-a-missing-memory-barrier-to-kthread_stop.patch
kthread-call-wake_up_process-without-the-lock-being-held.patch
