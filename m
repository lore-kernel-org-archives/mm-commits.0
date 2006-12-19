From: akpm@osdl.org
Subject: + sched-improve-efficiency-of-sched_fork.patch added to -mm tree
Date: Tue, 19 Dec 2006 12:08:40 -0800
Message-ID: <200612192008.kBJK8egi009000@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59489 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932934AbWLSUJA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Dec 2006 15:09:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pwil3058@bigpond.net.au, mingo@elte.hu, pwil3058@bigpond.com.au


The patch titled
     sched: improve efficiency of sched_fork()
has been added to the -mm tree.  Its filename is
     sched-improve-efficiency-of-sched_fork.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sched: improve efficiency of sched_fork()
From: Peter Williams <pwil3058@bigpond.net.au>

Problem:
	sched_fork() has always called scheduler_tick() in some (unlikely)
circumstances in order to update the current task in light of those
circumstances.  It has always been the case that the work done by
scheduler_tick() was more than was required to handle the problem in
hand but no harm was done except for the waste of a few CPU cycles.
However, the splitting of scheduler_tick() into two procedures in
2.6.20-rc1 enables the wasted cycles to be saved as the new procedure
task_running_tick() does all the work that is required to rectify the
problem being handled.

Solution:
	Replace the call to scheduler_tick() in sched_fork() with a call to
task_running_tick().

Signed-off-by: Peter Williams <pwil3058@bigpond.com.au>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/sched.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/sched.c~sched-improve-efficiency-of-sched_fork kernel/sched.c
--- a/kernel/sched.c~sched-improve-efficiency-of-sched_fork
+++ a/kernel/sched.c
@@ -1567,6 +1567,7 @@ int fastcall wake_up_state(struct task_s
 	return try_to_wake_up(p, state, 0);
 }
 
+static void task_running_tick(struct rq *rq, struct task_struct *p);
 /*
  * Perform scheduler related setup for a newly forked process p.
  * p is forked by current.
@@ -1627,7 +1628,7 @@ void fastcall sched_fork(struct task_str
 		 * runqueue lock is not a problem.
 		 */
 		current->time_slice = 1;
-		scheduler_tick();
+		task_running_tick(cpu_rq(cpu), current);
 	}
 	local_irq_enable();
 	put_cpu();
_

Patches currently in -mm which might be from pwil3058@bigpond.net.au are

sched-improve-efficiency-of-sched_fork.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
sched-add-above-background-load-function.patch

