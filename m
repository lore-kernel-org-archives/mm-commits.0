From: akpm@linux-foundation.org
Subject: + kthread-call-wake_up_process-without-the-lock-being-held.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:33:02 -0800
Message-ID: <200802230733.m1N7Xp3P018256@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:54162 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763754AbYBWIFe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 03:05:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmitry.adamushko@gmail.com, a.p.zijlstra@chello.nl, apw@shadowen.org, mingo@elte.hu, nickpiggin@yahoo.com.au, oleg@tv-sign.ru, paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au


The patch titled
     kthread: call wake_up_process() without the lock being held
has been added to the -mm tree.  Its filename is
     kthread-call-wake_up_process-without-the-lock-being-held.patch

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
Subject: kthread: call wake_up_process() without the lock being held
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>

- from the POV of synchronization, there should be no need to call
  wake_up_process() with the 'kthread_create_lock' being held;

- moreover, in order to support a lockless check for
  list_empty(&kthread_create_list) in kthreadd() :

 	set_current_state(TASK_INTERRUPTIBLE);
    	if (list_empty(&kthread_create_list))
    		schedule();

we must ensure that a modification of the list (i.e.  list_add_tail()) has
been completed by the moment a state of the task is checked in
try_to_wake_up().  i.e.  they must not be re-ordered.

wake_up_process() (i.e.  try_to_wake_up() effectively) doesn't provide a full
mb.  By moving wake_up_process() out of the locked section, we get an
UNLOCK/LOCK pair (LOCK is in try_to_wake_up()) which is guaranteed to act as a
full mb.

Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/kthread.c~kthread-call-wake_up_process-without-the-lock-being-held kernel/kthread.c
--- a/kernel/kthread.c~kthread-call-wake_up_process-without-the-lock-being-held
+++ a/kernel/kthread.c
@@ -158,9 +158,9 @@ struct task_struct *kthread_create(int (
 
 	spin_lock(&kthread_create_lock);
 	list_add_tail(&create.list, &kthread_create_list);
-	wake_up_process(kthreadd_task);
 	spin_unlock(&kthread_create_lock);
 
+	wake_up_process(kthreadd_task);
 	wait_for_completion(&create.done);
 
 	if (!IS_ERR(create.result)) {
_

Patches currently in -mm which might be from dmitry.adamushko@gmail.com are

kthread-synchronization-issues.patch
kthread-add-a-missing-memory-barrier-to-kthread_stop.patch
kthread-call-wake_up_process-without-the-lock-being-held.patch
