From: akpm@linux-foundation.org
Subject: + rcu-fix-rcu_try_flip_waitack_needed-to-prevent-grace-period-stall.patch added to -mm tree
Date: Mon, 24 Mar 2008 14:35:03 -0700
Message-ID: <200803242135.m2OLZ3Kw026349@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38849 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750723AbYCXVgQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Mar 2008 17:36:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, dipankar@in.ibm.com, josh@kernel.org, mingo@elte.hu


The patch titled
     rcu: fix rcu_try_flip_waitack_needed() to prevent grace-period stall
has been added to the -mm tree.  Its filename is
     rcu-fix-rcu_try_flip_waitack_needed-to-prevent-grace-period-stall.patch

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
Subject: rcu: fix rcu_try_flip_waitack_needed() to prevent grace-period stall
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The comment was correct -- need to make the code match the comment.
Without this patch, if a CPU goes dynticks idle (and stays there forever)
in just the right phase of preemptible-RCU grace-period processing,
grace periods stall.  The offending sequence of events (courtesy
of Promela/spin, at least after I got the liveness criterion coded
correctly...) is as follows:

o	CPU 0 is in dynticks-idle mode.  Its dynticks_progress_counter
	is (say) 10.

o	CPU 0 takes an interrupt, so rcu_irq_enter() increments CPU 0's
	dynticks_progress_counter to 11.

o	CPU 1 is doing RCU grace-period processing in rcu_try_flip_idle(),
	sees rcu_pending(), so invokes dyntick_save_progress_counter(),
	which in turn takes a snapshot of CPU 0's dynticks_progress_counter
	into CPU 0's rcu_dyntick_snapshot -- now set to 11.  CPU 1 then
	updates the RCU grace-period state to rcu_try_flip_waitack().

o	CPU 0 returns from its interrupt, so rcu_irq_exit() increments
	CPU 0's dynticks_progress_counter to 12.

o	CPU 1 later invokes rcu_try_flip_waitack(), which notices that
	CPU 0 has not yet responded, and hence in turn invokes
	rcu_try_flip_waitack_needed().  This function examines the
	state of CPU 0's dynticks_progress_counter and rcu_dyntick_snapshot
	variables, which it copies to curr (== 12) and snap (== 11),
	respectively.

	Because curr!=snap, the first condition fails.

	Because curr-snap is only 1 and snap is odd, the second
	condition fails.

	rcu_try_flip_waitack_needed() therefore incorrectly concludes
	that it must wait for CPU 0 to explicitly acknowledge the
	counter flip.

o	CPU 0 remains forever in dynticks-idle mode, never taking
	any more hardware interrupts or any NMIs, and never running
	any more tasks.  (Of course, -something- will usually eventually
	happen, which might be why we haven't seen this one in the
	wild.  Still should be fixed!)

Therefore the grace period never ends.  Fix is to make the code match
the comment, as shown below.  With this fix, the above scenario
would be satisfied with curr being even, and allow the grace period
to proceed.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Josh Triplett <josh@kernel.org>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rcupreempt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/rcupreempt.c~rcu-fix-rcu_try_flip_waitack_needed-to-prevent-grace-period-stall kernel/rcupreempt.c
--- a/kernel/rcupreempt.c~rcu-fix-rcu_try_flip_waitack_needed-to-prevent-grace-period-stall
+++ a/kernel/rcupreempt.c
@@ -567,7 +567,7 @@ rcu_try_flip_waitack_needed(int cpu)
 	 * that this CPU already acknowledged the counter.
 	 */
 
-	if ((curr - snap) > 2 || (snap & 0x1) == 0)
+	if ((curr - snap) > 2 || (curr & 0x1) == 0)
 		return 0;
 
 	/* We need this CPU to explicitly acknowledge the counter flip. */
_

Patches currently in -mm which might be from paulmck@linux.vnet.ibm.com are

origin.patch
git-net.patch
kthread-call-wake_up_process-without-the-lock-being-held.patch
add-rcu_assign_index-if-ever-needed.patch
add-rcu_assign_index-if-ever-needed-fix.patch
rcu-split-listh-and-move-rcu-protected-lists-into-rculisth.patch
rcu-fix-rcu_try_flip_waitack_needed-to-prevent-grace-period-stall.patch
isolate-ratelimit-from-printkc-for-other-use.patch
add-warn_on_secs-macro.patch
add-warn_on_secs-macro-simplification.patch
add-warn_on_secs-macro-simplification-fix.patch
use-warn_on_secs-in-rcupreempth.patch
lock_task_sighand-add-rcu-lock-unlock.patch
k_getrusage-dont-take-rcu_read_lock.patch
do_task_stat-dont-take-rcu_read_lock.patch

