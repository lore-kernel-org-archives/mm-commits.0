From: akpm@linux-foundation.org
Subject: - nohz-rate-limit-the-local-softirq-pending-warning-output.patch removed from -mm tree
Date: Tue, 29 May 2007 11:50:38 -0700
Message-ID: <200705291850.l4TIobwt008283@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:39308 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754573AbXE2Svf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:51:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     NOHZ: Rate limit the local softirq pending warning output
has been removed from the -mm tree.  Its filename was
     nohz-rate-limit-the-local-softirq-pending-warning-output.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: NOHZ: Rate limit the local softirq pending warning output
From: Thomas Gleixner <tglx@linutronix.de>

The warning in the NOHZ code, which triggers when a CPU goes idle with
softirqs pending can fill up the logs quite quickly.  Rate limit the output
until we found the root cause of that problem.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/tick-sched.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff -puN kernel/time/tick-sched.c~nohz-rate-limit-the-local-softirq-pending-warning-output kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~nohz-rate-limit-the-local-softirq-pending-warning-output
+++ a/kernel/time/tick-sched.c
@@ -167,9 +167,15 @@ void tick_nohz_stop_sched_tick(void)
 		goto end;
 
 	cpu = smp_processor_id();
-	if (unlikely(local_softirq_pending()))
-		printk(KERN_ERR "NOHZ: local_softirq_pending %02x\n",
-		       local_softirq_pending());
+	if (unlikely(local_softirq_pending())) {
+		static int ratelimit;
+
+		if (ratelimit < 10) {
+			printk(KERN_ERR "NOHZ: local_softirq_pending %02x\n",
+			       local_softirq_pending());
+			ratelimit++;
+		}
+	}
 
 	now = ktime_get();
 	/*
_

Patches currently in -mm which might be from tglx@linutronix.de are

git-drm.patch
s390-spinlock-initializer-cleanup.patch
i386-hpet-check-if-the-counter-works.patch
