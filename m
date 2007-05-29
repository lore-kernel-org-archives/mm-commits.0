From: akpm@linux-foundation.org
Subject: - prevent-going-idle-with-softirq-pending.patch removed from -mm tree
Date: Tue, 29 May 2007 11:53:07 -0700
Message-ID: <200705291853.l4TIr6X3008447@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:56461 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765049AbXE2Sxu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:53:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, mingo@elte.hu, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Prevent going idle with softirq pending
has been removed from the -mm tree.  Its filename was
     prevent-going-idle-with-softirq-pending.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Prevent going idle with softirq pending
From: Thomas Gleixner <tglx@linutronix.de>

The NOHZ patch contains a check for softirqs pending when a CPU goes idle. 
The BUG is unrelated to NOHZ, it just was made visible by the NOHZ patch. 
The BUG showed up mainly on P4 / hyperthreading enabled machines which lead
the investigations into the wrong direction in the first place.  The real
cause is in cond_resched_softirq():

cond_resched_softirq() is enabling softirqs without invoking the softirq
daemon when softirqs are pending.  This leads to the warning message in the
NOHZ idle code:

t1 runs softirq disabled code on CPU#0
interrupt happens, softirq is raised, but deferred (softirqs disabled)
t1 calls cond_resched_softirq()
	enables softirqs via _local_bh_enable()
	calls schedule()
t2 runs
t1 is migrated to CPU#1
t2 is done and invokes idle()
NOHZ detects the pending softirq

Fix: change _local_bh_enable() to local_bh_enable() so the softirq
daemon is invoked.

Thanks to Anant Nitya for debugging this with great patience !

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    4 +---
 1 files changed, 1 insertion(+), 3 deletions(-)

diff -puN kernel/sched.c~prevent-going-idle-with-softirq-pending kernel/sched.c
--- a/kernel/sched.c~prevent-going-idle-with-softirq-pending
+++ a/kernel/sched.c
@@ -4775,9 +4775,7 @@ int __sched cond_resched_softirq(void)
 	BUG_ON(!in_softirq());
 
 	if (need_resched() && system_state == SYSTEM_RUNNING) {
-		raw_local_irq_disable();
-		_local_bh_enable();
-		raw_local_irq_enable();
+		local_bh_enable();
 		__cond_resched();
 		local_bh_disable();
 		return 1;
_

Patches currently in -mm which might be from tglx@linutronix.de are

git-drm.patch
s390-spinlock-initializer-cleanup.patch
i386-hpet-check-if-the-counter-works.patch
