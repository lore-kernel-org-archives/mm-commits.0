From: akpm@linux-foundation.org
Subject: + hrtimer-prevent-migration-for-raising-softirq.patch added to -mm tree
Date: Thu, 03 Jul 2008 15:50:16 -0700
Message-ID: <200807032250.m63MoG5V031449@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48198 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754863AbYGCWv2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Jul 2008 18:51:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rostedt@goodmis.org, mingo@elte.hu, srostedt@redhat.com, tglx@linutronix.de


The patch titled
     hrtimer: prevent migration for raising softirq
has been added to the -mm tree.  Its filename is
     hrtimer-prevent-migration-for-raising-softirq.patch

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hrtimer.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN kernel/hrtimer.c~hrtimer-prevent-migration-for-raising-softirq kernel/hrtimer.c
--- a/kernel/hrtimer.c~hrtimer-prevent-migration-for-raising-softirq
+++ a/kernel/hrtimer.c
@@ -1000,10 +1000,18 @@ hrtimer_start(struct hrtimer *timer, kti
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

linux-next.patch
ftrace-disable-function-tracing-bringing-up-new-cpu.patch
hrtimer-prevent-migration-for-raising-softirq.patch
split-the-typecheck-macros-out-of-include-linux-kernelh.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-fix.patch

