From: akpm@linux-foundation.org
Subject: [failures] smp-start-up-non-boot-cpus-asynchronously.patch removed from -mm tree
Date: Fri, 23 Mar 2012 12:24:20 -0700
Message-ID: <20120323192420.C13C2A02FF@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:60467 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759718Ab2CWTYW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Mar 2012 15:24:22 -0400
Received: by yenq2 with SMTP id q2so547458yen.1
        for <mm-commits@vger.kernel.org>; Fri, 23 Mar 2012 12:24:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@infradead.org, a.p.zijlstra@chello.nl, arjan@linux.intel.com, hpa@zytor.com, mikey@neuling.org, miltonm@bga.com, mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: smp: start up non-boot CPUs asynchronously
has been removed from the -mm tree.  Its filename was
     smp-start-up-non-boot-cpus-asynchronously.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Arjan van de Ven <arjan@infradead.org>
Subject: smp: start up non-boot CPUs asynchronously

The starting of the "not first" CPUs actually takes a lot of boot time of
the kernel[*] - up to "minutes" on some of the bigger SGI boxes.  Right
now, this is a fully sequential operation with the rest of the kernel
boot.

This patch turns this bringup of the other cpus into an asynchronous
operat= ion.  With some other changes (not in this patch) this can save
significant kernel boot time (upto 40% on my laptop!!).  Basically now
CPUs could get brought up in parallel to disk enumeration, gr= aphic mode
bringup etc etc etc.

Note that the implementation in this patch still waits for all CPUs to be
brought up before starting userspace; I would love to remove that
restriction over time (technically that is simple), but that becomes then
a change in behavior...  I'd like to see more discussion on that being a
good idea before I write that patch.

Second note on version 2 of the patch: This patch does currently not save
any boot time, due to a situation where the cpu hotplug lock gets taken
for write by the cpu bringup code, which starves out readers of this lock
throughout the kernel.  Ingo specifically requested this behavior to
expose this lock problem.

[*] Numbers below are from my laptop, per logical CPU.  If you have
    many CPUs like SGI does, multiply.

    We spend slightly more than 10 milliseconds on doing the hardware
    level "send ipi, wait for the cpu to get power" dance.  This is mostly
    just hardware physics.

    We spend a bunch of time calibrating loops-per-jiffie/tsc (in
    3.3-rc this is only done once per socket, but each time we do it, it's
    several dozen milliseconds) we spend 20 milliseconds on making sure
    the tsc is not out of sync with the rest of the system (we're looking
    at optimizing this right now)

    A 3.2 kernel spent on average 120 milliseconds per logical
    non-boot cpu on my laptop.  3.3-rc is better (the calibration is now
    cached for each physical cpu), but still dire.

[akpm@linux-foundation.org: fix warning, small cleanups]
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Milton Miller <miltonm@bga.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michael Neuling <mikey@neuling.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/smp.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff -puN kernel/smp.c~smp-start-up-non-boot-cpus-asynchronously kernel/smp.c
--- a/kernel/smp.c~smp-start-up-non-boot-cpus-asynchronously
+++ a/kernel/smp.c
@@ -12,6 +12,8 @@
 #include <linux/gfp.h>
 #include <linux/smp.h>
 #include <linux/cpu.h>
+#include <linux/async.h>
+#include <linux/delay.h>
 
 #ifdef CONFIG_USE_GENERIC_SMP_HELPERS
 static struct {
@@ -664,17 +666,34 @@ void __init setup_nr_cpu_ids(void)
 	nr_cpu_ids = find_last_bit(cpumask_bits(cpu_possible_mask),NR_CPUS) + 1;
 }
 
+void __init async_cpu_up(void *data, async_cookie_t cookie)
+{
+	unsigned long nr = (unsigned long)data;
+	/*
+	 * we can only up one cpu at a time, as enforced by the hotplug
+	 * lock; it's better to wait for all earlier CPUs to be done before
+	 * we bring up ours, so that the bring up order is predictable.
+	 */
+	async_synchronize_cookie(cookie);
+	cpu_up(nr);
+}
+
 /* Called by boot processor to activate the rest. */
 void __init smp_init(void)
 {
 	unsigned int cpu;
 
 	/* FIXME: This should be done in userspace --RR */
+
+	/*
+	 * But until we do this in userspace, we're going to do this
+	 * in parallel to the rest of the kernel boot up.-- Arjan
+	 */
 	for_each_present_cpu(cpu) {
 		if (num_online_cpus() >= setup_max_cpus)
 			break;
 		if (!cpu_online(cpu))
-			cpu_up(cpu);
+			async_schedule(async_cpu_up, (void *)(long)cpu);
 	}
 
 	/* Any cleanup work */
_

Patches currently in -mm which might be from arjan@infradead.org are


