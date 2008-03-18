From: akpm@linux-foundation.org
Subject: + rcu-fix-misplaced-mb-in-rcu_enter-exit_nohz.patch added to -mm tree
Date: Mon, 17 Mar 2008 20:57:34 -0700
Message-ID: <200803180357.m2I3vYSP013010@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48219 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752237AbYCRD6r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 23:58:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com, nickpiggin@yahoo.com.au, oleg@tv-sign.ru, srostedt@redhat.com


The patch titled
     rcu: fix misplaced mb() in rcu_enter/exit_nohz()
has been added to the -mm tree.  Its filename is
     rcu-fix-misplaced-mb-in-rcu_enter-exit_nohz.patch

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
Subject: rcu: fix misplaced mb() in rcu_enter/exit_nohz()
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

In the process of writing up the mechanical proof of correctness for the
dynticks/preemptable-RCU interface, I noticed misplaced memory barriers in
rcu_enter_nohz() and rcu_exit_nohz().

This patch puts them in the right place and adds a comment.  The key thing to
keep in mind is that rcu_enter_nohz() is -exiting- the mode that can legally
execute RCU read-side critical sections.

The memory barrier must be between any potential RCU read-side critical
sections and the increment of the per-CPU dynticks_progress_counter, and thus
must come -before- this increment.  And vice versa for rcu_exit_nohz().

The locking in the scheduler is probably saving us for the moment.

Also, switch to smp_mb() - we don't need a barrier for uniprocessor kernels.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Steven Rostedt <srostedt@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rcupreempt.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/rcupreempt.h~rcu-fix-misplaced-mb-in-rcu_enter-exit_nohz include/linux/rcupreempt.h
--- a/include/linux/rcupreempt.h~rcu-fix-misplaced-mb-in-rcu_enter-exit_nohz
+++ a/include/linux/rcupreempt.h
@@ -87,15 +87,15 @@ DECLARE_PER_CPU(long, dynticks_progress_
 
 static inline void rcu_enter_nohz(void)
 {
+	smp_mb(); /* CPUs seeing ++ must see prior RCU read-side crit sects */
 	__get_cpu_var(dynticks_progress_counter)++;
 	WARN_ON(__get_cpu_var(dynticks_progress_counter) & 0x1);
-	mb();
 }
 
 static inline void rcu_exit_nohz(void)
 {
-	mb();
 	__get_cpu_var(dynticks_progress_counter)++;
+	smp_mb(); /* CPUs seeing ++ must see later RCU read-side crit sects */
 	WARN_ON(!(__get_cpu_var(dynticks_progress_counter) & 0x1));
 }
 
_

Patches currently in -mm which might be from paulmck@linux.vnet.ibm.com are

rcu-fix-misplaced-mb-in-rcu_enter-exit_nohz.patch
kthread-call-wake_up_process-without-the-lock-being-held.patch
add-rcu_assign_index-if-ever-needed.patch
add-rcu_assign_index-if-ever-needed-fix.patch
rcu-split-listh-and-move-rcu-protected-lists-into-rculisth.patch
isolate-ratelimit-from-printkc-for-other-use.patch
add-warn_on_secs-macro.patch
add-warn_on_secs-macro-simplification.patch
add-warn_on_secs-macro-simplification-fix.patch
use-warn_on_secs-in-rcupreempth.patch
lock_task_sighand-add-rcu-lock-unlock.patch
k_getrusage-dont-take-rcu_read_lock.patch
do_task_stat-dont-take-rcu_read_lock.patch

