From: akpm@linux-foundation.org
Subject: - hrtimer-prevent-migration-for-raising-softirq.patch removed from -mm tree
Date: Fri, 04 Jul 2008 00:27:07 -0700
Message-ID: <200807040727.m647R7FC019335@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34488 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755521AbYGDH2D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Jul 2008 03:28:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rostedt@goodmis.org, mingo@elte.hu, srostedt@redhat.com, stable@kernel.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     hrtimer: prevent migration for raising softirq
has been removed from the -mm tree.  Its filename was
     hrtimer-prevent-migration-for-raising-softirq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hrtimer: prevent migration for raising softirq
From: Steven Rostedt <rostedt@goodmis.org>

Due to a possible deadlock, the waking of the softirq was pushed outside
of the hrtimer base locks.  See commit
0c96c5979a522c3323c30a078a70120e29b5bdbc

Unfortunately this allows the task to migrate after setting up the softirq
and raising it.  Since softirqs run a queue that is per-cpu we may raise
the softirq on the wrong CPU and this will keep the queued softirq task
from running.

To solve this issue, this patch disables preemption around the releasing
of the hrtimer lock and raising of the softirq.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hrtimer.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN kernel/hrtimer.c~hrtimer-prevent-migration-for-raising-softirq kernel/hrtimer.c
--- a/kernel/hrtimer.c~hrtimer-prevent-migration-for-raising-softirq
+++ a/kernel/hrtimer.c
@@ -1003,10 +1003,18 @@ hrtimer_start(struct hrtimer *timer, kti
 	 */
 	raise = timer->state == HRTIMER_STATE_PENDING;
 
+	/*
+	 * We use preempt_disable to prevent this task from migrating after
+	 * setting up the softirq and raising it. Otherwise, if me migrate
+	 * we will raise the softirq on the wrong CPU.
+	 */
+	preempt_disable();
+
 	unlock_hrtimer_base(timer, &flags);
 
 	if (raise)
 		hrtimer_raise_softirq();
+	preempt_enable();
 
 	return ret;
 }
_

Patches currently in -mm which might be from rostedt@goodmis.org are

origin.patch
linux-next.patch
ftrace-disable-function-tracing-bringing-up-new-cpu.patch
split-the-typecheck-macros-out-of-include-linux-kernelh.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-fix.patch

