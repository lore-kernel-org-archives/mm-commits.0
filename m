From: akpm@linux-foundation.org
Subject: - uml-make-time-data-per-cpu.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:49:03 -0800
Message-ID: <200702112249.l1BMn3IP015690@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59808 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932689AbXBKWtG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:49:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, mm-commits@vger.kernel.org


The patch titled
     uml: make time data per-cpu
has been removed from the -mm tree.  Its filename was
     uml-make-time-data-per-cpu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: make time data per-cpu
From: Jeff Dike <jdike@addtoit.com>

prev_nsecs and delta need to be arrays, and indexed by CPU number.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/time.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff -puN arch/um/kernel/time.c~uml-make-time-data-per-cpu arch/um/kernel/time.c
--- a/arch/um/kernel/time.c~uml-make-time-data-per-cpu
+++ a/arch/um/kernel/time.c
@@ -35,31 +35,31 @@ unsigned long long sched_clock(void)
 	return (unsigned long long)jiffies_64 * (1000000000 / HZ);
 }
 
-static unsigned long long prev_nsecs;
+static unsigned long long prev_nsecs[NR_CPUS];
 #ifdef CONFIG_UML_REAL_TIME_CLOCK
-static long long delta;   		/* Deviation per interval */
+static long long delta[NR_CPUS];		/* Deviation per interval */
 #endif
 
 void timer_irq(union uml_pt_regs *regs)
 {
 	unsigned long long ticks = 0;
-
 #ifdef CONFIG_UML_REAL_TIME_CLOCK
-	if(prev_nsecs){
+	int c = cpu();
+	if(prev_nsecs[c]){
 		/* We've had 1 tick */
 		unsigned long long nsecs = os_nsecs();
 
-		delta += nsecs - prev_nsecs;
-		prev_nsecs = nsecs;
+		delta[c] += nsecs - prev_nsecs[c];
+		prev_nsecs[c] = nsecs;
 
 		/* Protect against the host clock being set backwards */
-		if(delta < 0)
-			delta = 0;
+		if(delta[c] < 0)
+			delta[c] = 0;
 
-		ticks += (delta * HZ) / BILLION;
-		delta -= (ticks * BILLION) / HZ;
+		ticks += (delta[c] * HZ) / BILLION;
+		delta[c] -= (ticks * BILLION) / HZ;
 	}
-	else prev_nsecs = os_nsecs();
+	else prev_nsecs[c] = os_nsecs();
 #else
 	ticks = 1;
 #endif
@@ -69,8 +69,8 @@ void timer_irq(union uml_pt_regs *regs)
 	}
 }
 
+/* Protects local_offset */
 static DEFINE_SPINLOCK(timer_spinlock);
-
 static unsigned long long local_offset = 0;
 
 static inline unsigned long long get_time(void)
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-fix-prototypes.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-um.patch
