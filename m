From: akpm@linux-foundation.org
Subject: [merged] x86-fix-cpufreq-tsc-scaling.patch removed from -mm tree
Date: Thu, 18 Jun 2009 11:20:44 -0700
Message-ID: <200906181820.n5IIKi9V018316@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37353 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753388AbZFRSVe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 14:21:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peterz@infradead.org, a.p.zijlstra@chello.nl, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: fix cpufreq tsc scaling
has been removed from the -mm tree.  Its filename was
     x86-fix-cpufreq-tsc-scaling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: fix cpufreq tsc scaling
From: Peter Zijlstra <peterz@infradead.org>

For freqency dependent TSCs we only scale the cycles, we do not account
for the discrepancy in absolute value.  Add a constant factor so that:

  c1 + f1*cyc == c2 + f2*cyc

LKML-Reference: <new-submission>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Chucked-on-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/timer.h |    6 +++++-
 arch/x86/kernel/tsc.c        |    8 ++++++--
 2 files changed, 11 insertions(+), 3 deletions(-)

diff -puN arch/x86/include/asm/timer.h~x86-fix-cpufreq-tsc-scaling arch/x86/include/asm/timer.h
--- a/arch/x86/include/asm/timer.h~x86-fix-cpufreq-tsc-scaling
+++ a/arch/x86/include/asm/timer.h
@@ -45,12 +45,16 @@ extern int no_timer_check;
  */
 
 DECLARE_PER_CPU(unsigned long, cyc2ns);
+DECLARE_PER_CPU(unsigned long long, cyc2ns_offset);
 
 #define CYC2NS_SCALE_FACTOR 10 /* 2^10, carefully chosen */
 
 static inline unsigned long long __cycles_2_ns(unsigned long long cyc)
 {
-	return cyc * per_cpu(cyc2ns, smp_processor_id()) >> CYC2NS_SCALE_FACTOR;
+	int cpu = smp_processor_id();
+	unsigned long long ns = per_cpu(cyc2ns_offset, cpu);
+	ns += cyc * per_cpu(cyc2ns, cpu) >> CYC2NS_SCALE_FACTOR;
+	return ns;
 }
 
 static inline unsigned long long cycles_2_ns(unsigned long long cyc)
diff -puN arch/x86/kernel/tsc.c~x86-fix-cpufreq-tsc-scaling arch/x86/kernel/tsc.c
--- a/arch/x86/kernel/tsc.c~x86-fix-cpufreq-tsc-scaling
+++ a/arch/x86/kernel/tsc.c
@@ -590,22 +590,26 @@ EXPORT_SYMBOL(recalibrate_cpu_khz);
  */
 
 DEFINE_PER_CPU(unsigned long, cyc2ns);
+DEFINE_PER_CPU(unsigned long long, cyc2ns_offset);
 
 static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
 {
-	unsigned long long tsc_now, ns_now;
+	unsigned long long tsc_now, ns_now, *offset;
 	unsigned long flags, *scale;
 
 	local_irq_save(flags);
 	sched_clock_idle_sleep_event();
 
 	scale = &per_cpu(cyc2ns, cpu);
+	offset = &per_cpu(cyc2ns_offset, cpu);
 
 	rdtscll(tsc_now);
 	ns_now = __cycles_2_ns(tsc_now);
 
-	if (cpu_khz)
+	if (cpu_khz) {
 		*scale = (NSEC_PER_MSEC << CYC2NS_SCALE_FACTOR)/cpu_khz;
+		*offset = ns_now - (tsc_now * *scale >> CYC2NS_SCALE_FACTOR);
+	}
 
 	sched_clock_idle_wakeup_event(0);
 	local_irq_restore(flags);
_

Patches currently in -mm which might be from peterz@infradead.org are

origin.patch
linux-next.patch

